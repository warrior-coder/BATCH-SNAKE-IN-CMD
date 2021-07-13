::
:: Funny Snake Game in pure batch file
::

Setlocal EnableDelayedExpansion
@echo off

title Snake Game
mode con lines=28 cols=22

set WIDTH=20
set HEIGHT=20

set "line="
set "cell="

set PX=5
set PY=5
set P_DIR=4
set P_SCORE=0

set TX0=4
set TY0=5
set TX1=3
set TY1=5
set TX2=2
set TY2=5
set T_INDEX=2

set /a FX=%random% %% 19 + 1
set /a FY=%random% %% 19 + 1

:: ------------------------- Main game loop -------------------------
for /l %%. in () do (
    
    call :DRAW_SCREEN
     
    choice /c wasdcx /n /t 1 /d x
    if !errorlevel! EQU 1 (
       set P_DIR=1
    ) else if !errorlevel! EQU 2 (
       set P_DIR=2
    ) else if !errorlevel! EQU 3 (
       set P_DIR=3
    ) else if !errorlevel! EQU 4 (
       set P_DIR=4
    ) else if !errorlevel! EQU 5 exit
    	
    call :MOVE_PLAYER
)

:MOVE_PLAYER
    :: Move tail
    for /l %%i in (!T_INDEX!,-1,1) do (
       set /a i_next=%%i-1
       for /l %%j in (!i_next!, 999, !i_next!) do (
          set /a TX%%i=!TX%%j!
          set /a TY%%i=!TY%%j!
       )
    )
    set /a TX0=!PX!
    set /a TY0=!PY!	
	
    :: Move head
    if !P_DIR! EQU 1 (
       set /a PY-=1
    ) else if !P_DIR! EQU 2 (
       set /a PX-=1
    ) else if !P_DIR! EQU 3 (
       set /a PY+=1
    ) else if !P_DIR! EQU 4 (
       set /a PX+=1
    )
    
    :: if leave borders
    if !PX! LSS 1 (
       set PX=%WIDTH%
    ) else if !PX! GTR %WIDTH% (
       set PX=1
    ) else if !PY! LSS 1 (
       set PY=%HEIGHT%
    ) else if !PY! GTR %HEIGHT% (
       set PY=1
    )
    
    :: Food eat
    if !PX! EQU !FX! if !PY! EQU !FY! (
       set /a T_INDEX+=1
       set /a P_SCORE+=1
       set /a FX=%random% %% 19 + 1
       set /a FY=%random% %% 19 + 1
    )
exit /b

:DRAW_SCREEN
    :: Clear firstly
    cls

    :: Start drawing
    echo SCORE: !P_SCORE! & echo.

    set "line=######################"
    for /l %%Y in (1, 1, %HEIGHT%) do (
       set "line=!line!#"
    
       for /l %%X in (1, 1, %WIDTH%) do (
          set "cell= "
          
          :: Tail draw
          for /l %%i in (0,1,!T_INDEX!) do if %%X EQU !TX%%i! if %%Y EQU !TY%%i! set "cell=O"

          :: Food draw
          if %%X EQU !FX! if %%Y EQU !FY! set "cell=F" 
          
          :: Head draw
          if %%X EQU %PX% if %%Y EQU %PY% set "cell=@"
	   
          set line=!line!!cell!
       )
    	set "line=!line!#"
    )
    set "line=!line!######################"
    echo !line!
exit /b