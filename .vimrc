" ========= Vundle Config ========== {{{
" vim插件 https://vimawesome.com/

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'valloric/youcompleteme'
Plugin 'Chiel92/vim-autoformat'
Plugin 'skywind3000/asyncrun.vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" }}}

" ============== General Config ========== {{{
set t_Co=256
set number
set laststatus=2
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" }}}

" =========== Plugins Config ========== {{{

" nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" airline-themes
let g:airline_theme='bubblegum'
function! WindowNumber(...)
        let builder = a:1
        let context = a:2
        call builder.add_section('airline_b','%{tabpagewinnr(tabpagenr())}')
        return 0
endfunction
call airline#add_statusline_func('WindowNumber')
call airline#add_inactive_statusline_func('WindowNumber')
augroup vimrc
  " Auto rebuild C/C++ project when source file is updated, asynchronously
  autocmd BufWritePost *.c,*.cpp,*.h
              \ let dir=expand('<amatch>:p:h') |
              \ if filereadable(dir.'/Makefile') || filereadable(dir.'/makefile') |
              \   execute 'AsyncRun -cwd=<root> make -j8' |
              \ endif
  " Auto toggle the quickfix window
  autocmd User AsyncRunStop
              \ if g:asyncrun_status=='failure' |
              \   execute('call asyncrun#quickfix_toggle(8, 1)') |
              \ else |
              \   execute('call asyncrun#quickfix_toggle(8, 0)') |
              \ endif
augroup END

" Define new accents
function! AirlineThemePatch(palette)
  " [ guifg, guibg, ctermfg, ctermbg, opts ].
  " See "help attr-list" for valid values for the "opt" value.
  " http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
  let a:palette.accents.running = [ '', '', '', '', '' ]
  let a:palette.accents.success = [ '#00ff00', '' , 'green', '', '' ]
  let a:palette.accents.failure = [ '#ff0000', '' , 'red', '', '' ]
endfunction
let g:airline_theme_patch_func = 'AirlineThemePatch'


" Change color of the relevant section according to g:asyncrun_status, a global variable exposed by AsyncRun
" 'running': default, 'success': green, 'failure': red
let g:async_status_old = ''
function! Get_asyncrun_running()

  let async_status = g:asyncrun_status
  if async_status != g:async_status_old

    if async_status == 'running'
      call airline#parts#define_accent('asyncrun_status', 'running')
    elseif async_status == 'success'
      call airline#parts#define_accent('asyncrun_status', 'success')
    elseif async_status == 'failure'
      call airline#parts#define_accent('asyncrun_status', 'failure')
    endif

    let g:airline_section_x = airline#section#create(['asyncrun_status'])
    AirlineRefresh
    let g:async_status_old = async_status

  endif

  return async_status

endfunction

call airline#parts#define_function('asyncrun_status', 'Get_asyncrun_running')
let g:airline_section_x = airline#section#create(['asyncrun_status'])


" vim-colors-solarized
syntax on
set background=dark
colorscheme solarized
" let g:solarized_termcolors=256

" tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 30

" youcompleteme
let g:syntastic_java_checkers = []
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/youcompleteme/third_party/ycmd/examples/.ycm_extra_conf.py'

" vim-autoformat
noremap <F3> :Autoformat<CR>
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" }}}
