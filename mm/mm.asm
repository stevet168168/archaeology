; Manic Miner disassembly
; http://skoolkit.ca/
;
; Copyright 1983 Bug-Byte Ltd (Manic Miner)
; Copyright 2010, 2012-2016 Richard Dymond (this disassembly)

  ORG $8000

; Cavern name
;
; The cavern name is copied here and then used by the routine at STARTGAME.
CAVERNNAME:
  DEFS $20

; Cavern tiles
;
; The cavern tiles are copied here by the routine at STARTGAME and then used to
; draw the cavern by the routine at DRAWSHEET.
;
; The extra tile at EXTRA behaves like a floor tile, and is used as such in The
; Endorian Forest, Attack of the Mutant Telephones, Ore Refinery, Skylab
; Landing Bay and The Bank. It is also used in The Menagerie as spider silk,
; and in Miner Willy meets the Kong Beast and Return of the Alien Kong Beast as
; a switch.
BACKGROUND:
  DEFS $09                ; Background tile (also used by the routines at
                          ; MOVEWILLY, CRUMBLE, LIGHTBEAM, EUGENE, KONGBEAST
                          ; and WILLYATTR)
FLOOR:
  DEFS $09                ; Floor tile (also used by the routine at LIGHTBEAM)
CRUMBLING:
  DEFS $09                ; Crumbling floor tile (also used by the routine at
                          ; MOVEWILLY)
WALL:
  DEFS $09                ; Wall tile (also used by the routines at MOVEWILLY,
                          ; MOVEWILLY2 and LIGHTBEAM)
CONVEYOR:
  DEFS $09                ; Conveyor tile (also used by the routine at
                          ; MOVEWILLY2)
NASTY1:
  DEFS $09                ; Nasty tile 1 (also used by the routines at
                          ; MOVEWILLY and WILLYATTR)
NASTY2:
  DEFS $09                ; Nasty tile 2 (also used by the routines at
                          ; MOVEWILLY and WILLYATTR)
EXTRA:
  DEFS $09                ; Extra tile (also used by the routine at CHKSWITCH)

; Willy's pixel y-coordinate (x2)
;
; Initialised by the routine at STARTGAME, and used by the routines at
; MOVEWILLY, MOVEWILLY2, WILLYATTRS and DRAWWILLY. Holds the LSB of the address
; of the entry in the screen buffer address lookup table at SBUFADDRS that
; corresponds to Willy's pixel y-coordinate; in practice, this is twice Willy's
; actual pixel y-coordinate.
PIXEL_Y:
  DEFB $00

; Willy's animation frame
;
; Initialised upon entry to a cavern or after losing a life by the routine at
; STARTGAME, used by the routine at DRAWWILLY, and updated by the routine at
; MOVEWILLY2. Possible values are 0, 1, 2 and 3.
FRAME:
  DEFB $00

; Willy's direction and movement flags
;
; Initialised by the routine at STARTGAME.
;
; +--------+-----------------------------------------+-----------------------+
; | Bit(s) | Meaning                                 | Used by               |
; +--------+-----------------------------------------+-----------------------+
; | 0      | Direction Willy is facing (reset=right, | MOVEWILLY2, DRAWWILLY |
; |        | set=left)                               |                       |
; | 1      | Willy's movement flag (set=moving)      | MOVEWILLY, MOVEWILLY2 |
; | 2-7    | Unused (always reset)                   |                       |
; +--------+-----------------------------------------+-----------------------+
DMFLAGS:
  DEFB $00

; Airborne status indicator
;
; Initialised by the routine at STARTGAME, and used by the routines at LOOP,
; MOVEWILLY, MOVEWILLY2 and KILLWILLY. Possible values are:
;
; +-------+---------------------------------------------------------------+
; | Value | Meaning                                                       |
; +-------+---------------------------------------------------------------+
; | 0     | Willy is neither falling nor jumping                          |
; | 1     | Willy is jumping                                              |
; | 2-11  | Willy is falling, and can land safely                         |
; | 12+   | Willy is falling, and has fallen too far to land safely (see  |
; |       | MOVEWILLY2)                                                   |
; | 255   | Willy has collided with a nasty or a guardian (see KILLWILLY) |
; +-------+---------------------------------------------------------------+
AIRBORNE:
  DEFB $00

; Address of Willy's location in the attribute buffer at 5C00
;
; Initialised by the routine at STARTGAME, used by the routines at MOVEWILLY,
; CHKPORTAL, CHKSWITCH, WILLYATTRS and DRAWWILLY, and updated by the routine at
; MOVEWILLY2.
LOCATION:
  DEFW $0000

; Jumping animation counter
;
; Initialised by the routine at STARTGAME, and used by the routines at
; MOVEWILLY and MOVEWILLY2.
JUMPING:
  DEFB $00

; Conveyor definition
;
; The conveyor definition is copied here by the routine at STARTGAME.
CONVDIR:
  DEFB $00                ; Direction (0=left, 1=right; used by the routines at
                          ; MOVEWILLY2 and MVCONVEYOR)
CONVLOC:
  DEFW $0000              ; Address of the conveyor's location in the screen
                          ; buffer at 28672 (used by the routine at MVCONVEYOR)
CONVLEN:
  DEFB $00                ; Length (used by the routine at MVCONVEYOR)

; Border colour
;
; Initialised and used by the routine at STARTGAME, and also used by the
; routines at LOOP, MOVEWILLY and KONGBEAST.
BORDER:
  DEFB $00

; Attribute of the last item drawn
;
; Used by the routines at EUGENE and DRAWITEMS. Holds the attribute byte of the
; last item drawn, or 0 if all the items have been collected.
ITEMATTR:
  DEFB $00

; Item definitions
;
; The item definitions are copied here by the routine at STARTGAME, and then
; used by the routine at DRAWITEMS. An item definition contains the following
; information:
;
; +---------+-----------------------------------------------------------------+
; | Byte(s) | Contents                                                        |
; +---------+-----------------------------------------------------------------+
; | 0       | Current attribute                                               |
; | 1,2     | Address of the item's location in the attribute buffer at 23552 |
; | 3       | MSB of the address of the item's location in the screen buffer  |
; |         | at 24576                                                        |
; | 4       | Unused (always 255)                                             |
; +---------+-----------------------------------------------------------------+
ITEMS:
  DEFS $05                ; Item 1
  DEFS $05                ; Item 2
  DEFS $05                ; Item 3
  DEFS $05                ; Item 4
  DEFS $05                ; Item 5
  DEFB $00                ; Terminator (set to 255)

; Portal definition
;
; The portal definition is copied here by the routine at STARTGAME.
PORTAL:
  DEFB $00                ; Attribute byte (used by the routines at DRAWITEMS
                          ; and CHKPORTAL)
PORTALG:
  DEFS $20                ; Graphic data (used by the routine at CHKPORTAL)
PORTALLOC1:
  DEFW $0000              ; Address of the portal's location in the attribute
                          ; buffer at 23552 (used by the routine at CHKPORTAL)
PORTALLOC2:
  DEFW $0000              ; Address of the portal's location in the screen
                          ; buffer at 24576 (used by the routine at CHKPORTAL)

; Item graphic
;
; The item graphic is copied here by the routine at STARTGAME, and then used by
; the routine at DRAWITEMS.
ITEM:
  DEFS $08

; Remaining air supply
;
; Initialised (always to 63 in practice) and used by the routine at STARTGAME,
; updated by the routine at DECAIR, and also used by the routine at NXSHEET.
; Its value ranges from 36 to 63 and is actually the LSB of the display file
; address for the cell at the right end of the air bar. The amount of air to
; draw in this cell is determined by the value of the game clock at CLOCK.
AIR:
  DEFB $00

; Game clock
;
; Initialised by the routine at STARTGAME, updated on every pass through the
; main loop by the routine at DECAIR, and used for timing purposes by the
; routines at MOVEHG, EUGENE and KONGBEAST. Its value (which is always a
; multiple of 4) is also used by the routine at DECAIR to compute the amount of
; air to draw in the cell at the right end of the air bar.
CLOCK:
  DEFB $00

; Horizontal guardians
;
; The horizontal guardian definitions are copied here by the routine at
; STARTGAME, and then used by the routines at MOVEHG and DRAWHG. There are four
; slots, each one seven bytes long, used to hold the state of the horizontal
; guardians in the current cavern.
;
; For each horizontal guardian, the seven bytes are used as follows:
;
; +------+--------------------------------------------------------------------+
; | Byte | Contents                                                           |
; +------+--------------------------------------------------------------------+
; | 0    | Bit 7: animation speed (0=normal, 1=slow)                          |
; |      | Bits 0-6: attribute (BRIGHT, PAPER and INK)                        |
; | 1,2  | Address of the guardian's location in the attribute buffer at      |
; |      | 23552                                                              |
; | 3    | MSB of the address of the guardian's location in the screen buffer |
; |      | at 24576                                                           |
; | 4    | Animation frame                                                    |
; | 5    | LSB of the address of the leftmost point of the guardian's path in |
; |      | the attribute buffer                                               |
; | 6    | LSB of the address of the rightmost point of the guardian's path   |
; |      | in the attribute buffer                                            |
; +------+--------------------------------------------------------------------+
HGUARDS:
  DEFS $07                ; Horizontal guardian 1
HGUARD2:
  DEFS $07                ; Horizontal guardian 2
  DEFS $07                ; Horizontal guardian 3
  DEFS $07                ; Horizontal guardian 4
  DEFB $00                ; Terminator (set to 255)

; Eugene's direction or the Kong Beast's status
;
; Initialised by the routine at STARTGAME, and used by the routines at EUGENE
; (to hold Eugene's direction: 0=down, 1=up) and KONGBEAST (to hold the Kong
; Beast's status: 0=on the ledge, 1=falling, 2=dead).
EUGDIR:
  DEFB $00

; Eugene's or the Kong Beast's pixel y-coordinate
;
; Initialised by the routine at STARTGAME, and used by the routines at START
; (to hold the index into the message scrolled across the screen after the
; theme tune has finished playing), ENDGAM (to hold the distance of the boot
; from the top of the screen as it descends onto Willy), EUGENE (to hold
; Eugene's pixel y-coordinate) and KONGBEAST (to hold the Kong Beast's pixel
; y-coordinate).
EUGHGT:
  DEFB $00

; Vertical guardians
;
; The vertical guardian definitions are copied here by the routine at
; STARTGAME, and then used by the routines at SKYLABS and VGUARDIANS. There are
; four slots, each one seven bytes long, used to hold the state of the vertical
; guardians in the current cavern.
;
; For each vertical guardian, the seven bytes are used as follows:
;
; +------+------------------------------+
; | Byte | Contents                     |
; +------+------------------------------+
; | 0    | Attribute                    |
; | 1    | Animation frame              |
; | 2    | Pixel y-coordinate           |
; | 3    | x-coordinate                 |
; | 4    | Pixel y-coordinate increment |
; | 5    | Minimum pixel y-coordinate   |
; | 6    | Maximum pixel y-coordinate   |
; +------+------------------------------+
;
; In most of the caverns that do not have vertical guardians, this area is
; overwritten by unused bytes from the cavern definition. The exception is
; Eugene's Lair: the routine at STARTGAME copies the graphic data for the
; Eugene sprite into the last 32 bytes of this area, where it is then used by
; the routine at EUGENE.
VGUARDS:
  DEFS $07                ; Vertical guardian 1
  DEFS $07                ; Vertical guardian 2
  DEFS $07                ; Vertical guardian 3
  DEFS $07                ; Vertical guardian 4
  DEFB $00                ; Terminator (set to 255 in caverns that have four
                          ; vertical guardians)
  DEFS $06                ; Spare

; Guardian graphic data
;
; The guardian graphic data is copied here by the routine at STARTGAME, and
; then used by the routines at DRAWHG, SKYLABS, VGUARDIANS and KONGBEAST.
GGDATA:
  DEFS $0100

; Willy sprite graphic data
;
; Used by the routines at START, LOOP and DRAWWILLY.
MANDAT:
  DEFB $06,$00,$3E,$00,$7C,$00,$34,$00,$3E,$00,$3C,$00,$18,$00,$3C,$00
  DEFB $7E,$00,$7E,$00,$F7,$00,$FB,$00,$3C,$00,$76,$00,$6E,$00,$77,$00
  DEFB $01,$80,$0F,$80,$1F,$00,$0D,$00,$0F,$80,$0F,$00,$06,$00,$0F,$00
  DEFB $1B,$80,$1B,$80,$1B,$80,$1D,$80,$0F,$00,$06,$00,$06,$00,$07,$00
WILLYR2:
  DEFB $00,$60,$03,$E0,$07,$C0,$03,$40,$03,$E0,$03,$C0,$01,$80,$03,$C0
  DEFB $07,$E0,$07,$E0,$0F,$70,$0F,$B0,$03,$C0,$07,$60,$06,$E0,$07,$70
WILLYR3:
  DEFB $00,$18,$00,$F8,$01,$F0,$00,$D0,$00,$F8,$00,$F0,$00,$60,$00,$F0
  DEFB $01,$F8,$03,$FC,$07,$FE,$06,$F6,$00,$F8,$01,$DA,$03,$0E,$03,$84
  DEFB $18,$00,$1F,$00,$0F,$80,$0B,$00,$1F,$00,$0F,$00,$06,$00,$0F,$00
  DEFB $1F,$80,$3F,$C0,$7F,$E0,$6F,$60,$1F,$00,$5B,$80,$70,$C0,$21,$C0
  DEFB $06,$00,$07,$C0,$03,$E0,$02,$C0,$07,$C0,$03,$C0,$01,$80,$03,$C0
  DEFB $07,$E0,$07,$E0,$0E,$F0,$0D,$F0,$03,$C0,$06,$E0,$07,$60,$0E,$E0
  DEFB $01,$80,$01,$F0,$00,$F8,$00,$B0,$01,$F0,$00,$F0,$00,$60,$00,$F0
  DEFB $01,$F8,$01,$D8,$01,$D8,$01,$B8,$00,$F0,$00,$60,$00,$60,$00,$E0
  DEFB $00,$60,$00,$7C,$00,$3E,$00,$2C,$00,$7C,$00,$3C,$00,$18,$00,$3C
  DEFB $00,$7E,$00,$7E,$00,$EF,$00,$DF,$00,$3C,$00,$6E,$00,$76,$00,$EE

; Screen buffer address lookup table
;
; Used by the routines at ENDGAM, EUGENE, SKYLABS, VGUARDIANS, KONGBEAST and
; DRAWWILLY. The value of the Nth entry (0<=N<=127) in this lookup table is the
; screen buffer address for the point with pixel coordinates (x,y)=(0,N), with
; the origin (0,0) at the top-left corner.
SBUFADDRS:
  DEFW $6000              ; y=0
  DEFW $6100              ; y=1
  DEFW $6200              ; y=2
  DEFW $6300              ; y=3
  DEFW $6400              ; y=4
  DEFW $6500              ; y=5
  DEFW $6600              ; y=6
  DEFW $6700              ; y=7
  DEFW $6020              ; y=8
  DEFW $6120              ; y=9
  DEFW $6220              ; y=10
  DEFW $6320              ; y=11
  DEFW $6420              ; y=12
  DEFW $6520              ; y=13
  DEFW $6620              ; y=14
  DEFW $6720              ; y=15
  DEFW $6040              ; y=16
  DEFW $6140              ; y=17
  DEFW $6240              ; y=18
  DEFW $6340              ; y=19
  DEFW $6440              ; y=20
  DEFW $6540              ; y=21
  DEFW $6640              ; y=22
  DEFW $6740              ; y=23
  DEFW $6060              ; y=24
  DEFW $6160              ; y=25
  DEFW $6260              ; y=26
  DEFW $6360              ; y=27
  DEFW $6460              ; y=28
  DEFW $6560              ; y=29
  DEFW $6660              ; y=30
  DEFW $6760              ; y=31
  DEFW $6080              ; y=32
  DEFW $6180              ; y=33
  DEFW $6280              ; y=34
  DEFW $6380              ; y=35
  DEFW $6480              ; y=36
  DEFW $6580              ; y=37
  DEFW $6680              ; y=38
  DEFW $6780              ; y=39
  DEFW $60A0              ; y=40
  DEFW $61A0              ; y=41
  DEFW $62A0              ; y=42
  DEFW $63A0              ; y=43
  DEFW $64A0              ; y=44
  DEFW $65A0              ; y=45
  DEFW $66A0              ; y=46
  DEFW $67A0              ; y=47
  DEFW $60C0              ; y=48
  DEFW $61C0              ; y=49
  DEFW $62C0              ; y=50
  DEFW $63C0              ; y=51
  DEFW $64C0              ; y=52
  DEFW $65C0              ; y=53
  DEFW $66C0              ; y=54
  DEFW $67C0              ; y=55
  DEFW $60E0              ; y=56
  DEFW $61E0              ; y=57
  DEFW $62E0              ; y=58
  DEFW $63E0              ; y=59
  DEFW $64E0              ; y=60
  DEFW $65E0              ; y=61
  DEFW $66E0              ; y=62
  DEFW $67E0              ; y=63
  DEFW $6800              ; y=64
  DEFW $6900              ; y=65
  DEFW $6A00              ; y=66
  DEFW $6B00              ; y=67
  DEFW $6C00              ; y=68
  DEFW $6D00              ; y=69
  DEFW $6E00              ; y=70
  DEFW $6F00              ; y=71
  DEFW $6820              ; y=72
  DEFW $6920              ; y=73
  DEFW $6A20              ; y=74
  DEFW $6B20              ; y=75
  DEFW $6C20              ; y=76
  DEFW $6D20              ; y=77
  DEFW $6E20              ; y=78
  DEFW $6F20              ; y=79
  DEFW $6840              ; y=80
  DEFW $6940              ; y=81
  DEFW $6A40              ; y=82
  DEFW $6B40              ; y=83
  DEFW $6C40              ; y=84
  DEFW $6D40              ; y=85
  DEFW $6E40              ; y=86
  DEFW $6F40              ; y=87
  DEFW $6860              ; y=88
  DEFW $6960              ; y=89
  DEFW $6A60              ; y=90
  DEFW $6B60              ; y=91
  DEFW $6C60              ; y=92
  DEFW $6D60              ; y=93
  DEFW $6E60              ; y=94
  DEFW $6F60              ; y=95
  DEFW $6880              ; y=96
  DEFW $6980              ; y=97
  DEFW $6A80              ; y=98
  DEFW $6B80              ; y=99
  DEFW $6C80              ; y=100
  DEFW $6D80              ; y=101
  DEFW $6E80              ; y=102
  DEFW $6F80              ; y=103
  DEFW $68A0              ; y=104
  DEFW $69A0              ; y=105
  DEFW $6AA0              ; y=106
  DEFW $6BA0              ; y=107
  DEFW $6CA0              ; y=108
  DEFW $6DA0              ; y=109
  DEFW $6EA0              ; y=110
  DEFW $6FA0              ; y=111
  DEFW $68C0              ; y=112
  DEFW $69C0              ; y=113
  DEFW $6AC0              ; y=114
  DEFW $6BC0              ; y=115
  DEFW $6CC0              ; y=116
  DEFW $6DC0              ; y=117
  DEFW $6EC0              ; y=118
  DEFW $6FC0              ; y=119
  DEFW $68E0              ; y=120
  DEFW $69E0              ; y=121
  DEFW $6AE0              ; y=122
  DEFW $6BE0              ; y=123
  DEFW $6CE0              ; y=124
  DEFW $6DE0              ; y=125
  DEFW $6EE0              ; y=126
  DEFW $6FE0              ; y=127

; The game has just loaded
BEGIN:
  DI                      ; Disable interrupts
  LD SP,$9CFE             ; Place the stack somewhere safe (near the end of the
                          ; source code remnants at SOURCE)
  JP START                ; Display the title screen and play the theme tune

; Current cavern number
;
; Initialised by the routine at START, used by the routines at STARTGAME, LOOP,
; DRAWSHEET and DRAWHG, and updated by the routine at NXSHEET.
SHEET:
  DEFB $00

; Left-right movement table
;
; Used by the routine at MOVEWILLY2. The entries in this table are used to map
; the existing value (V) of Willy's direction and movement flags at DMFLAGS to
; a new value (V'), depending on the direction Willy is facing and how he is
; moving or being moved (by 'left' and 'right' keypresses and joystick input,
; or by a conveyor).
;
; One of the first four entries is used when Willy is not moving.
LRMOVEMENT:
  DEFB $00                ; V=0 (facing right, no movement) + no movement: V'=0
                          ; (no change)
  DEFB $01                ; V=1 (facing left, no movement) + no movement: V'=1
                          ; (no change)
  DEFB $00                ; V=2 (facing right, moving) + no movement: V'=0
                          ; (facing right, no movement) (i.e. stop)
  DEFB $01                ; V=3 (facing left, moving) + no movement: V'=1
                          ; (facing left, no movement) (i.e. stop)
; One of the next four entries is used when Willy is moving left.
  DEFB $01                ; V=0 (facing right, no movement) + move left: V'=1
                          ; (facing left, no movement) (i.e. turn around)
  DEFB $03                ; V=1 (facing left, no movement) + move left: V'=3
                          ; (facing left, moving)
  DEFB $01                ; V=2 (facing right, moving) + move left: V'=1
                          ; (facing left, no movement) (i.e. turn around)
  DEFB $03                ; V=3 (facing left, moving) + move left: V'=3 (no
                          ; change)
; One of the next four entries is used when Willy is moving right.
  DEFB $02                ; V=0 (facing right, no movement) + move right: V'=2
                          ; (facing right, moving)
  DEFB $00                ; V=1 (facing left, no movement) + move right: V'=0
                          ; (facing right, no movement) (i.e. turn around)
  DEFB $02                ; V=2 (facing right, moving) + move right: V'=2 (no
                          ; change)
  DEFB $00                ; V=3 (facing left, moving) + move right: V'=0
                          ; (facing right, no movement) (i.e. turn around)
; One of the final four entries is used when Willy is being pulled both left
; and right; each entry leaves the flags at DMFLAGS unchanged (so Willy carries
; on moving in the direction he's already moving, or remains stationary).
  DEFB $00                ; V=V'=0 (facing right, no movement)
  DEFB $01                ; V=V'=1 (facing left, no movement)
  DEFB $02                ; V=V'=2 (facing right, moving)
  DEFB $03                ; V=V'=3 (facing left, moving)

; 'AIR'
;
; Used by the routine at STARTGAME.
MESSAIR:
  DEFM "AIR"

; Unused
  DEFM "0000"

; High score
;
; Used by the routine at LOOP and updated by the routine at ENDGAM.
HGHSCOR:
  DEFM "000000"

; Score
;
; Initialised by the routine at STARTGAME, and used by the routines at LOOP,
; ENDGAM, NXSHEET and INCSCORE.
SCORE:
  DEFM "0000"             ; Overflow digits (these may be updated, but are
                          ; never printed)
SCORBUF:
  DEFM "000000"

; 'High Score 000000   Score 000000'
;
; Used by the routine at STARTGAME.
MESSHSSC:
  DEFM "High Score 000000   Score 000000"

; 'Game'
;
; Used by the routine at ENDGAM.
MESSG:
  DEFM "Game"

; 'Over'
;
; Used by the routine at ENDGAM.
MESSO:
  DEFM "Over"

; Lives remaining
;
; Initialised to 2 by the routine at START, and used and updated by the
; routines at LOOP and INCSCORE.
NOMEN:
  DEFB $00

; Screen flash counter
;
; Initialised by the routine at START, and used by the routines at LOOP and
; INCSCORE.
FLASH:
  DEFB $00

; Kempston joystick indicator
;
; Initialised by the routine at START, and used by the routines at LOOP,
; MOVEWILLY2 and CHECKENTER. Holds 1 if a joystick is present, 0 otherwise.
KEMP:
  DEFB $00

; Game mode indicator
;
; Initialised by the routine at START, and used by the routines at STARTGAME,
; LOOP and NXSHEET. Holds 0 when a game is in progress, or a value from 1 to 64
; when in demo mode.
DEMO:
  DEFB $00

; In-game music note index
;
; Initialised by the routine at START, and used and updated by the routine at
; LOOP.
NOTEINDEX:
  DEFB $00

; Music flags
;
; The keypress flag in bit 0 is initialised by the routine at START; bits 0 and
; 1 are checked and updated by the routine at LOOP.
;
; +--------+-----------------------------------------------------------------+
; | Bit(s) | Meaning                                                         |
; +--------+-----------------------------------------------------------------+
; | 0      | Keypress flag (set=H-ENTER being pressed, reset=no key pressed) |
; | 1      | In-game music flag (set=music off, reset=music on)              |
; | 2-7    | Unused                                                          |
; +--------+-----------------------------------------------------------------+
MUSICFLAGS:
  DEFB $00

; 6031769 key counter
;
; Used by the routines at LOOP and NXSHEET.
CHEAT:
  DEFB $00

; 6031769
;
; Used by the routine at LOOP. In each pair of bytes here, bits 0-4 of the
; first byte correspond to keys 1-2-3-4-5, and bits 0-4 of the second byte
; correspond to keys 0-9-8-7-6; among those bits, a zero indicates a key being
; pressed.
  DEFB %00011111,%00011111 ; (no keys pressed)
CHEATDT:
  DEFB %00011111,%00001111 ; 6
  DEFB %00011111,%00011110 ; 0
  DEFB %00011011,%00011111 ; 3
  DEFB %00011110,%00011111 ; 1
  DEFB %00011111,%00010111 ; 7
  DEFB %00011111,%00001111 ; 6
  DEFB %00011111,%00011101 ; 9

; Title screen tune data (The Blue Danube)
;
; Used by the routine at PLAYTUNE. The tune data is organised into 95 groups of
; three bytes each, one group for each note in the tune. The first byte in each
; group determines the duration of the note, and the second and third bytes
; determine the frequency (and also the piano keys that light up).
THEMETUNE:
  DEFB $50,$80,$81
  DEFB $50,$66,$67
  DEFB $50,$56,$57
  DEFB $32,$56,$57
  DEFB $32,$AB,$CB
  DEFB $32,$2B,$33
  DEFB $32,$2B,$33
  DEFB $32,$AB,$CB
  DEFB $32,$33,$40
  DEFB $32,$33,$40
  DEFB $32,$AB,$CB
  DEFB $32,$80,$81
  DEFB $32,$80,$81
  DEFB $32,$66,$67
  DEFB $32,$56,$57
  DEFB $32,$60,$56
  DEFB $32,$AB,$C0
  DEFB $32,$2B,$30
  DEFB $32,$2B,$30
  DEFB $32,$AB,$C0
  DEFB $32,$30,$44
  DEFB $32,$30,$44
  DEFB $32,$AB,$C0
  DEFB $32,$88,$89
  DEFB $32,$88,$89
  DEFB $32,$72,$73
  DEFB $32,$4C,$4D
  DEFB $32,$4C,$4D
  DEFB $32,$AB,$C0
  DEFB $32,$26,$30
  DEFB $32,$26,$30
  DEFB $32,$AB,$C0
  DEFB $32,$30,$44
  DEFB $32,$30,$44
  DEFB $32,$AB,$C0
  DEFB $32,$88,$89
  DEFB $32,$88,$89
  DEFB $32,$72,$73
  DEFB $32,$4C,$4D
  DEFB $32,$4C,$4D
  DEFB $32,$AB,$CB
  DEFB $32,$26,$33
  DEFB $32,$26,$33
  DEFB $32,$AB,$CB
  DEFB $32,$33,$40
  DEFB $32,$33,$40
  DEFB $32,$AB,$CB
  DEFB $32,$80,$81
  DEFB $32,$80,$81
  DEFB $32,$66,$67
  DEFB $32,$56,$57
  DEFB $32,$40,$41
  DEFB $32,$80,$AB
  DEFB $32,$20,$2B
  DEFB $32,$20,$2B
  DEFB $32,$80,$AB
  DEFB $32,$2B,$33
  DEFB $32,$2B,$33
  DEFB $32,$80,$AB
  DEFB $32,$80,$81
  DEFB $32,$80,$81
  DEFB $32,$66,$67
  DEFB $32,$56,$57
  DEFB $32,$40,$41
  DEFB $32,$80,$98
  DEFB $32,$20,$26
  DEFB $32,$20,$26
  DEFB $32,$80,$98
  DEFB $32,$26,$30
  DEFB $32,$26,$30
  DEFB $32,$00,$00
  DEFB $32,$72,$73
  DEFB $32,$72,$73
  DEFB $32,$60,$61
  DEFB $32,$4C,$4D
  DEFB $32,$4C,$99
  DEFB $32,$4C,$4D
  DEFB $32,$4C,$4D
  DEFB $32,$4C,$99
  DEFB $32,$5B,$5C
  DEFB $32,$56,$57
  DEFB $32,$33,$CD
  DEFB $32,$33,$34
  DEFB $32,$33,$34
  DEFB $32,$33,$CD
  DEFB $32,$40,$41
  DEFB $32,$66,$67
  DEFB $64,$66,$67
  DEFB $32,$72,$73
  DEFB $64,$4C,$4D
  DEFB $32,$56,$57
  DEFB $32,$80,$CB
  DEFB $19,$80,$00
  DEFB $19,$80,$81
  DEFB $32,$80,$CB
  DEFB $FF                ; End marker

; In-game tune data (In the Hall of the Mountain King)
;
; Used by the routine at LOOP.
GAMETUNE:
  DEFB $80,$72,$66,$60,$56,$66,$56,$56,$51,$60,$51,$51,$56,$66,$56,$56
  DEFB $80,$72,$66,$60,$56,$66,$56,$56,$51,$60,$51,$51,$56,$56,$56,$56
  DEFB $80,$72,$66,$60,$56,$66,$56,$56,$51,$60,$51,$51,$56,$66,$56,$56
  DEFB $80,$72,$66,$60,$56,$66,$56,$40,$56,$66,$80,$66,$56,$56,$56,$56

; Display the title screen and play the theme tune
;
; Used by the routines at BEGIN, LOOP and ENDGAM.
;
; The first thing this routine does is initialise some game status buffer
; variables in preparation for the next game.
START:
  XOR A                   ; A=0
  LD (SHEET),A            ; Initialise the current cavern number at SHEET
  LD (KEMP),A             ; Initialise the Kempston joystick indicator at KEMP
  LD (DEMO),A             ; Initialise the game mode indicator at DEMO
  LD (NOTEINDEX),A        ; Initialise the in-game music note index at
                          ; NOTEINDEX
  LD (FLASH),A            ; Initialise the screen flash counter at FLASH
  LD A,$02                ; Initialise the number of lives remaining at NOMEN
  LD (NOMEN),A
  LD HL,MUSICFLAGS        ; Initialise the keypress flag in bit 0 at MUSICFLAGS
  SET 0,(HL)
; Next, prepare the screen.
  LD HL,$4000             ; Clear the entire display file
  LD DE,$4001
  LD BC,$17FF
  LD (HL),$00
  LDIR
  LD HL,TITLESCR1         ; Copy the graphic data at TITLESCR1 to the top
  LD DE,$4000             ; two-thirds of the display file
  LD BC,$1000
  LDIR
  LD HL,$483D             ; Draw Willy at (9,29)
  LD DE,WILLYR2
  LD C,$00
  CALL DRWFIX
  LD HL,CAVERN19          ; Copy the attribute bytes from CAVERN19 to the top
  LD DE,$5800             ; third of the attribute file
  LD BC,$0100
  LDIR
  LD HL,LOWERATTRS        ; Copy the attribute bytes from LOWERATTRS to the
  LD BC,$0200             ; bottom two-thirds of the attribute file
  LDIR
; Now check whether there is a joystick connected.
  LD BC,$001F             ; B=0, C=31 (joystick port)
  DI                      ; Disable interrupts (which are already disabled)
  XOR A                   ; A=0
START_0:
  IN E,(C)                ; Combine 256 readings of the joystick port in A; if
  OR E                    ; no joystick is connected, some of these readings
  DJNZ START_0            ; will have bit 5 set
  AND $20                 ; Is a joystick connected (bit 5 reset)?
  JR NZ,START_1           ; Jump if not
  LD A,$01                ; Set the Kempston joystick indicator at KEMP to 1
  LD (KEMP),A
; And finally, play the theme tune and check for keypresses.
START_1:
  LD IY,THEMETUNE         ; Point IY at the theme tune data at THEMETUNE
  CALL PLAYTUNE           ; Play the theme tune
  JP NZ,STARTGAME         ; Start the game if ENTER or the fire button was
                          ; pressed
  XOR A                   ; Initialise the game status buffer variable at
  LD (EUGHGT),A           ; EUGHGT; this will be used as an index for the
                          ; message scrolled across the screen
START_2:
  LD A,(EUGHGT)           ; Pick up the message index from EUGHGT
  LD IX,MESSINTRO         ; Point IX at the corresponding location in the
  LD IXl,A                ; message at MESSINTRO
  LD DE,$5060             ; Print 32 characters of the message at (19,0)
  LD C,$20
  CALL PMESS
  LD A,(EUGHGT)           ; Pick up the message index from EUGHGT
  AND $06                 ; Keep only bits 1 and 2, and move them into bits 6
  RRCA                    ; and 7, so that A holds 0, 64, 128 or 192; this
  RRCA                    ; value determines the animation frame to use for
  RRCA                    ; Willy
  LD E,A                  ; Point DE at the graphic data for Willy's sprite
  LD D,$82                ; (MANDAT+A)
  LD HL,$483D             ; Draw Willy at (9,29)
  LD C,$00
  CALL DRWFIX
  LD BC,$0064             ; Pause for about 0.1s
START_3:
  DJNZ START_3
  DEC C
  JR NZ,START_3
  LD BC,$BFFE             ; Read keys H-J-K-L-ENTER
  IN A,(C)
  AND $01                 ; Keep only bit 0 of the result (ENTER)
  CP $01                  ; Is ENTER being pressed?
  JR NZ,STARTGAME         ; If so, start the game
  LD A,(EUGHGT)           ; Pick up the message index from EUGHGT
  INC A                   ; Increment it
  CP $E0                  ; Set the zero flag if we've reached the end of the
                          ; message
  LD (EUGHGT),A           ; Store the new message index at EUGHGT
  JR NZ,START_2           ; Jump back unless we've finished scrolling the
                          ; message across the screen
  LD A,$40                ; Initialise the game mode indicator at DEMO to 64:
  LD (DEMO),A             ; demo mode
; This routine continues into the one at STARTGAME.

; Start the game (or demo mode)
;
; Used by the routine at START.
STARTGAME:
  LD HL,SCORE             ; Initialise the score at SCORE
  LD DE,$8426
  LD BC,$0009
  LD (HL),$30
  LDIR
; This entry point is used by the routines at LOOP (when teleporting into a
; cavern or reinitialising the current cavern after Willy has lost a life) and
; NXSHEET.
NEWSHT:
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  SLA A                   ; Point HL at the first byte of the cavern definition
  SLA A
  ADD A,$B0
  LD H,A
  LD L,$00
  LD DE,$5E00             ; Copy the cavern's attribute bytes into the buffer
  LD BC,$0200             ; at 24064
  LDIR
  LD DE,CAVERNNAME        ; Copy the rest of the cavern definition into the
  LD BC,$0200             ; game status buffer at 8000
  LDIR
  CALL DRAWSHEET          ; Draw the current cavern to the screen buffer at
                          ; 28672
  LD HL,$5000             ; Clear the bottom third of the display file
  LD DE,$5001
  LD BC,$07FF
  LD (HL),$00
  LDIR
  LD IX,CAVERNNAME        ; Print the cavern name (see CAVERNNAME) at (16,0)
  LD C,$20
  LD DE,$5000
  CALL PMESS
  LD IX,MESSAIR           ; Print 'AIR' (see MESSAIR) at (17,0)
  LD C,$03
  LD DE,$5020
  CALL PMESS
  LD A,$52                ; Initialise A to 82; this is the MSB of the display
                          ; file address at which to start drawing the bar that
                          ; represents the air supply
STARTGAME_0:
  LD H,A                  ; Prepare HL and DE for drawing a row of pixels in
  LD D,A                  ; the air bar
  LD L,$24
  LD E,$25
  LD B,A                  ; Save the display file address MSB in B briefly
  LD A,(AIR)              ; Pick up the value of the initial air supply from
                          ; AIR
  SUB $24                 ; Now C determines the length of the air bar (in cell
  LD C,A                  ; widths)
  LD A,B                  ; Restore the display file address MSB to A
  LD B,$00                ; Now BC determines the length of the air bar (in
                          ; cell widths)
  LD (HL),$FF             ; Draw a single row of pixels across C cells
  LDIR
  INC A                   ; Increment the display file address MSB in A (moving
                          ; down to the next row of pixels)
  CP $56                  ; Have we drawn all four rows of pixels in the air
                          ; bar yet?
  JR NZ,STARTGAME_0       ; If not, jump back to draw the next one
  LD IX,MESSHSSC          ; Print 'High Score 000000   Score 000000' (see
  LD DE,$5060             ; MESSHSSC) at (19,0)
  LD C,$20
  CALL PMESS
  LD A,(BORDER)           ; Pick up the border colour for the current cavern
                          ; from BORDER
  LD C,$FE                ; Set the border colour
  OUT (C),A
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Are we in demo mode?
  JR Z,LOOP               ; If not, enter the main loop now
  LD A,$40                ; Reset the game mode indicator at DEMO to 64 (we're
  LD (DEMO),A             ; in demo mode)
; This routine continues into the main loop at LOOP.

; Main loop
;
; The routine at STARTGAME continues here.
;
; The first thing to do is check whether there are any remaining lives to draw
; at the bottom of the screen.
LOOP:
  LD A,(NOMEN)            ; Pick up the number of lives remaining from NOMEN
  LD HL,$50A0             ; Set HL to the display file address at which to draw
                          ; the first Willy sprite
  OR A                    ; Are there any lives remaining?
  JR Z,LOOP_1             ; Jump if not
  LD B,A                  ; Initialise B to the number of lives remaining
; The following loop draws the remaining lives at the bottom of the screen.
LOOP_0:
  LD C,$00                ; C=0; this tells the sprite-drawing routine at
                          ; DRWFIX to overwrite any existing graphics
  PUSH HL                 ; Save HL and BC briefly
  PUSH BC
  LD A,(NOTEINDEX)        ; Pick up the in-game music note index from
                          ; NOTEINDEX; this will determine the animation frame
                          ; for the Willy sprites
  RLCA                    ; Now A=0 (frame 0), 32 (frame 1), 64 (frame 2) or 96
  RLCA                    ; (frame 3)
  RLCA
  AND $60
  LD E,A                  ; Point DE at the corresponding Willy sprite (at
  LD D,$82                ; MANDAT+A)
  CALL DRWFIX             ; Draw the Willy sprite on the screen
  POP BC                  ; Restore HL and BC
  POP HL
  INC HL                  ; Move HL along to the location at which to draw the
  INC HL                  ; next Willy sprite
  DJNZ LOOP_0             ; Jump back to draw any remaining sprites
; Now draw a boot if cheat mode has been activated.
LOOP_1:
  LD A,(CHEAT)            ; Pick up the 6031769 key counter from CHEAT
  CP $07                  ; Has 6031769 been keyed in yet?
  JR NZ,LOOP_2            ; Jump if not
  LD DE,BOOT              ; Point DE at the graphic data for the boot (at BOOT)
  LD C,$00                ; C=0 (overwrite mode)
  CALL DRWFIX             ; Draw the boot at the bottom of the screen next to
                          ; the remaining lives
; Next, prepare the screen and attribute buffers for drawing to the screen.
LOOP_2:
  LD HL,$5E00             ; Copy the contents of the attribute buffer at 24064
  LD DE,$5C00             ; (the attributes for the empty cavern) into the
  LD BC,$0200             ; attribute buffer at 23552
  LDIR
  LD HL,$7000             ; Copy the contents of the screen buffer at 28672
  LD DE,$6000             ; (the tiles for the empty cavern) into the screen
  LD BC,$1000             ; buffer at 24576
  LDIR
  CALL MOVEHG             ; Move the horizontal guardians in the current cavern
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Are we in demo mode?
  CALL Z,MOVEWILLY        ; If not, move Willy
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Are we in demo mode?
  CALL Z,WILLYATTRS       ; If not, check and set the attribute bytes for
                          ; Willy's sprite in the buffer at 23552, and draw
                          ; Willy to the screen buffer at 24576
  CALL DRAWHG             ; Draw the horizontal guardians in the current cavern
  CALL MVCONVEYOR         ; Move the conveyor in the current cavern
  CALL DRAWITEMS          ; Draw the items in the current cavern and collect
                          ; any that Willy is touching
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $04                  ; Are we in Eugene's Lair?
  CALL Z,EUGENE           ; If so, move and draw Eugene
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $0D                  ; Are we in Skylab Landing Bay?
  JP Z,SKYLABS            ; If so, move and draw the Skylabs
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $08                  ; Are we in Wacky Amoebatrons or beyond?
  CALL NC,VGUARDIANS      ; If so, move and draw the vertical guardians
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $07                  ; Are we in Miner Willy meets the Kong Beast?
  CALL Z,KONGBEAST        ; If so, move and draw the Kong Beast
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $0B                  ; Are we in Return of the Alien Kong Beast?
  CALL Z,KONGBEAST        ; If so, move and draw the Kong Beast
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $12                  ; Are we in Solar Power Generator?
  CALL Z,LIGHTBEAM        ; If so, move and draw the light beam
; This entry point is used by the routine at SKYLABS.
LOOP_3:
  CALL CHKPORTAL          ; Draw the portal, or move to the next cavern if
                          ; Willy has entered it
; This entry point is used by the routine at KILLWILLY.
LOOP_4:
  LD HL,$6000             ; Copy the contents of the screen buffer at 24576 to
  LD DE,$4000             ; the display file
  LD BC,$1000
  LDIR
  LD A,(FLASH)            ; Pick up the screen flash counter from FLASH
  OR A                    ; Is it zero?
  JR Z,LOOP_5             ; Jump if so
  DEC A                   ; Decrement the screen flash counter at FLASH
  LD (FLASH),A
  RLCA                    ; Move bits 0-2 into bits 3-5 and clear all the other
  RLCA                    ; bits
  RLCA
  AND $38
  LD HL,$5C00             ; Set every attribute byte in the buffer at 23552 to
  LD DE,$5C01             ; this value
  LD BC,$01FF
  LD (HL),A
  LDIR
LOOP_5:
  LD HL,$5C00             ; Copy the contents of the attribute buffer at 23552
  LD DE,$5800             ; to the attribute file
  LD BC,$0200
  LDIR
  LD IX,SCORBUF           ; Print the score (see SCORBUF) at (19,26)
  LD DE,$507A
  LD C,$06
  CALL PMESS
  LD IX,HGHSCOR           ; Print the high score (see HGHSCOR) at (19,11)
  LD DE,$506B
  LD C,$06
  CALL PMESS
  CALL DECAIR             ; Decrease the air remaining in the current cavern
  JP Z,MANDEAD            ; Jump if there's no air left
; Now check whether SHIFT and SPACE are being pressed.
  LD BC,$FEFE             ; Read keys SHIFT-Z-X-C-V
  IN A,(C)
  LD E,A                  ; Save the result in E
  LD B,$7F                ; Read keys B-N-M-SS-SPACE
  IN A,(C)
  OR E                    ; Combine the results
  AND $01                 ; Are SHIFT and SPACE being pressed?
  JP Z,START              ; If so, quit the game
; Now read the keys A, S, D, F and G (which pause the game).
  LD B,$FD                ; Read keys A-S-D-F-G
  IN A,(C)
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR Z,LOOP_7             ; Jump if not
LOOP_6:
  LD B,$02                ; Read every half-row of keys except A-S-D-F-G
  IN A,(C)
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR Z,LOOP_6             ; Jump back if not (the game is still paused)
; Here we check whether Willy has had a fatal accident.
LOOP_7:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $FF                  ; Has Willy landed after falling from too great a
                          ; height, or collided with a nasty or a guardian?
  JP Z,MANDEAD            ; Jump if so
; Now read the keys H, J, K, L and ENTER (which toggle the in-game music).
  LD B,$BF                ; Prepare B for reading keys H-J-K-L-ENTER
  LD HL,MUSICFLAGS        ; Point HL at the music flags at MUSICFLAGS
  IN A,(C)                ; Read keys H-J-K-L-ENTER
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR Z,LOOP_8             ; Jump if not
  BIT 0,(HL)              ; Were any of these keys being pressed the last time
                          ; we checked?
  JR NZ,LOOP_9            ; Jump if so
  LD A,(HL)               ; Set bit 0 (the keypress flag) and flip bit 1 (the
  XOR $03                 ; in-game music flag) at MUSICFLAGS
  LD (HL),A
  JR LOOP_9
LOOP_8:
  RES 0,(HL)              ; Reset bit 0 (the keypress flag) at MUSICFLAGS
LOOP_9:
  BIT 1,(HL)              ; Has the in-game music been switched off?
  JR NZ,NONOTE4           ; Jump if so
; The next section of code plays a note of the in-game music.
  LD A,(NOTEINDEX)        ; Increment the in-game music note index at NOTEINDEX
  INC A
  LD (NOTEINDEX),A
  AND $7E                 ; Point HL at the appropriate entry in the tune data
  RRCA                    ; table at GAMETUNE
  LD E,A
  LD D,$00
  LD HL,GAMETUNE
  ADD HL,DE
  LD A,(BORDER)           ; Pick up the border colour for the current cavern
                          ; from BORDER
  LD E,(HL)               ; Initialise the pitch delay counter in E
  LD BC,$0003             ; Initialise the duration delay counters in B (0) and
                          ; C (3)
TM51:
  OUT ($FE),A             ; Produce a note of the in-game music
SEE37708:
  DEC E
  JR NZ,NOFLP6
  LD E,(HL)
  XOR $18
NOFLP6:
  DJNZ TM51
  DEC C
  JR NZ,TM51
; If we're in demo mode, check the keyboard and joystick and return to the
; title screen if there's any input.
NONOTE4:
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Are we in demo mode?
  JR Z,NODEM1             ; Jump if not
  DEC A                   ; We're in demo mode; is it time to show the next
                          ; cavern?
  JP Z,MANDEAD            ; Jump if so
  LD (DEMO),A             ; Update the game mode indicator at DEMO
  LD BC,$00FE             ; Read every row of keys on the keyboard
  IN A,(C)
  AND $1F                 ; Are any keys being pressed?
  CP $1F
  JP NZ,START             ; If so, return to the title screen
  LD A,(KEMP)             ; Pick up the Kempston joystick indicator from KEMP
  OR A                    ; Is there a joystick connected?
  JR Z,NODEM1             ; Jump if not
  IN A,($1F)              ; Collect input from the joystick
  OR A                    ; Is the joystick being moved or the fire button
                          ; being pressed?
  JP NZ,START             ; If so, return to the title screen
; Here we check the teleport keys.
NODEM1:
  LD BC,$EFFE             ; Read keys 6-7-8-9-0
  IN A,(C)
  BIT 4,A                 ; Is '6' (the activator key) being pressed?
  JP NZ,CKCHEAT           ; Jump if not
  LD A,(CHEAT)            ; Pick up the 6031769 key counter from CHEAT
  CP $07                  ; Has 6031769 been keyed in yet?
  JP NZ,CKCHEAT           ; Jump if not
  LD B,$F7                ; Read keys 1-2-3-4-5
  IN A,(C)
  CPL                     ; Keep only bits 0-4 and flip them
  AND $1F
  CP $14                  ; Is the result 20 or greater?
  JP NC,CKCHEAT           ; Jump if so (this is not a cavern number)
  LD (SHEET),A            ; Store the cavern number at SHEET
  JP NEWSHT               ; Teleport into the cavern
; Now check the 6031769 keys.
CKCHEAT:
  LD A,(CHEAT)            ; Pick up the 6031769 key counter from CHEAT
  CP $07                  ; Has 6031769 been keyed in yet?
  JP Z,LOOP               ; If so, jump back to the start of the main loop
  RLCA                    ; Point IX at the corresponding entry in the 6031769
  LD E,A                  ; table at CHEATDT
  LD D,$00
  LD IX,CHEATDT
  ADD IX,DE
  LD BC,$F7FE             ; Read keys 1-2-3-4-5
  IN A,(C)
  AND $1F                 ; Keep only bits 0-4
  CP (IX+$00)             ; Does this match the first byte of the entry in the
                          ; 6031769 table?
  JR Z,CKNXCHT            ; Jump if so
  CP $1F                  ; Are any of the keys 1-2-3-4-5 being pressed?
  JP Z,LOOP               ; If not, jump back to the start of the main loop
  CP (IX-$02)             ; Does the keyboard reading match the first byte of
                          ; the previous entry in the 6031769 table?
  JP Z,LOOP               ; If so, jump back to the start of the main loop
  XOR A                   ; Reset the 6031769 key counter at CHEAT to 0 (an
  LD (CHEAT),A            ; incorrect key is being pressed)
  JP LOOP                 ; Jump back to the start of the main loop
CKNXCHT:
  LD B,$EF                ; Read keys 6-7-8-9-0
  IN A,(C)
  AND $1F                 ; Keep only bits 0-4
  CP (IX+$01)             ; Does this match the second byte of the entry in the
                          ; 6031769 table?
  JR Z,INCCHT             ; If so, jump to increment the 6031769 key counter
  CP $1F                  ; Are any of the keys 6-7-8-9-0 being pressed?
  JP Z,LOOP               ; If not, jump back to the start of the main loop
  CP (IX-$01)             ; Does the keyboard reading match the second byte of
                          ; the previous entry in the 6031769 table?
  JP Z,LOOP               ; If so, jump back to the start of the main loop
  XOR A                   ; Reset the 6031769 key counter at CHEAT to 0 (an
  LD (CHEAT),A            ; incorrect key is being pressed)
  JP LOOP                 ; Jump back to the start of the main loop
INCCHT:
  LD A,(CHEAT)            ; Increment the 6031769 key counter at CHEAT (the
  INC A                   ; next key in the sequence is being pressed)
  LD (CHEAT),A
  JP LOOP                 ; Jump back to the start of the main loop
; The air in the cavern has run out, or Willy has had a fatal accident, or it's
; demo mode and it's time to show the next cavern.
MANDEAD:
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Is it demo mode?
  JP NZ,NXSHEET           ; If so, move to the next cavern
  LD A,$47                ; A=71 (INK 7: PAPER 0: BRIGHT 1)
; The following loop fills the top two thirds of the attribute file with a
; single value (71 TO 64 STEP -1) and makes a sound effect.
LPDEAD1:
  LD HL,$5800             ; Fill the top two thirds of the attribute file with
  LD DE,$5801             ; the value in A
  LD BC,$01FF
  LD (HL),A
  LDIR
  LD E,A                  ; Save the attribute byte (64-71) in E for later
                          ; retrieval
  CPL                     ; D=63-8*(E AND 7); this value determines the pitch
  AND $07                 ; of the short note that will be played
  RLCA
  RLCA
  RLCA
  OR $07
  LD D,A
  LD C,E                  ; C=8+32*(E AND 7); this value determines the
  RRC C                   ; duration of the short note that will be played
  RRC C
  RRC C
  OR $10                  ; Set bit 4 of A (for no apparent reason)
  XOR A                   ; Set A=0 (this will make the border black)
TM21:
  OUT ($FE),A             ; Produce a short note whose pitch is determined by D
  XOR $18                 ; and whose duration is determined by C
  LD B,D
TM22:
  DJNZ TM22
  DEC C
  JR NZ,TM21
  LD A,E                  ; Restore the attribute byte (originally 71) to A
  DEC A                   ; Decrement it (effectively decrementing the INK
                          ; colour)
  CP $3F                  ; Have we used attribute value 64 (INK 0) yet?
  JR NZ,LPDEAD1           ; If not, jump back to update the INK colour in the
                          ; top two thirds of the screen and make another sound
                          ; effect
; Finally, check whether any lives remain.
  LD HL,NOMEN             ; Pick up the number of lives remaining from NOMEN
  LD A,(HL)
  OR A                    ; Are there any lives remaining?
  JP Z,ENDGAM             ; If not, display the game over sequence
  DEC (HL)                ; Decrease the number of lives remaining by one
  JP NEWSHT               ; Jump back to reinitialise the current cavern

; Display the game over sequence
;
; Used by the routine at LOOP. First check whether we have a new high score.
ENDGAM:
  LD HL,HGHSCOR           ; Point HL at the high score at HGHSCOR
  LD DE,SCORBUF           ; Point DE at the current score at SCORBUF
  LD B,$06                ; There are 6 digits to compare
LPHGH:
  LD A,(DE)               ; Pick up a digit of the current score
  CP (HL)                 ; Compare it with the corresponding digit of the high
                          ; score
  JP C,FEET               ; Jump if it's less than the corresponding digit of
                          ; the high score
  JP NZ,NEWHGH            ; Jump if it's greater than the corresponding digit
                          ; of the high score
  INC HL                  ; Point HL at the next digit of the high score
  INC DE                  ; Point DE at the next digit of the current score
  DJNZ LPHGH              ; Jump back to compare the next pair of digits
NEWHGH:
  LD HL,SCORBUF           ; Replace the high score with the current score
  LD DE,HGHSCOR
  LD BC,$0006
  LDIR
; Now prepare the screen for the game over sequence.
FEET:
  LD HL,$4000             ; Clear the top two-thirds of the display file
  LD DE,$4001
  LD BC,$0FFF
  LD (HL),$00
  LDIR
  XOR A                   ; Initialise the game status buffer variable at
  LD (EUGHGT),A           ; EUGHGT; this variable will determine the distance
                          ; of the boot from the top of the screen
  LD DE,WILLYR2           ; Draw Willy at (12,15)
  LD HL,$488F
  LD C,$00
  CALL DRWFIX
  LD DE,PLINTH            ; Draw the plinth (see PLINTH) underneath Willy at
  LD HL,$48CF             ; (14,15)
  LD C,$00
  CALL DRWFIX
; The following loop draws the boot's descent onto the plinth that supports
; Willy.
LOOPFT:
  LD A,(EUGHGT)           ; Pick up the distance variable from EUGHGT
  LD C,A                  ; Point BC at the corresponding entry in the screen
  LD B,$83                ; buffer address lookup table at SBUFADDRS
  LD A,(BC)               ; Point HL at the corresponding location in the
  OR $0F                  ; display file
  LD L,A
  INC BC
  LD A,(BC)
  SUB $20
  LD H,A
  LD DE,BOOT              ; Draw the boot (see BOOT) at this location, without
  LD C,$00                ; erasing the boot at the previous location; this
  CALL DRWFIX             ; leaves the portion of the boot sprite that's above
                          ; the ankle in place, and makes the boot appear as if
                          ; it's at the end of a long, extending trouser leg
  LD A,(EUGHGT)           ; Pick up the distance variable from EUGHGT
  CPL                     ; A=255-A
  LD E,A                  ; Store this value (63-255) in E; it determines the
                          ; (rising) pitch of the sound effect that will be
                          ; made
  XOR A                   ; A=0 (black border)
  LD BC,$0040             ; C=64; this value determines the duration of the
                          ; sound effect
TM111:
  OUT ($FE),A             ; Produce a short note whose pitch is determined by E
  XOR $18
  LD B,E
TM112:
  DJNZ TM112
  DEC C
  JR NZ,TM111
  LD HL,$5800             ; Prepare BC, DE and HL for setting the attribute
  LD DE,$5801             ; bytes in the top two-thirds of the screen
  LD BC,$01FF
  LD A,(EUGHGT)           ; Pick up the distance variable from EUGHGT
  AND $0C                 ; Keep only bits 2 and 3
  RLCA                    ; Shift bits 2 and 3 into bits 3 and 4; these bits
                          ; determine the PAPER colour: 0, 1, 2 or 3
  OR $47                  ; Set bits 0-2 (INK 7) and 6 (BRIGHT 1)
  LD (HL),A               ; Copy this attribute value into the top two-thirds
  LDIR                    ; of the screen
  LD A,(EUGHGT)           ; Add 4 to the distance variable at EUGHGT; this will
  ADD A,$04               ; move the boot sprite down two pixel rows
  LD (EUGHGT),A
  CP $C4                  ; Has the boot met the plinth yet?
  JR NZ,LOOPFT            ; Jump back if not
; Now print the "Game Over" message, just to drive the point home.
  LD IX,MESSG             ; Print "Game" (see MESSG) at (6,10)
  LD C,$04
  LD DE,$40CA
  CALL PMESS
  LD IX,MESSO             ; Print "Over" (see MESSO) at (6,18)
  LD C,$04
  LD DE,$40D2
  CALL PMESS
  LD BC,$0000             ; Prepare the delay counters for the following loop;
  LD D,$06                ; the counter in C will also determine the INK
                          ; colours to use for the "Game Over" message
; The following loop makes the "Game Over" message glisten for about 1.57s.
TM91:
  DJNZ TM91               ; Delay for about a millisecond
  LD A,C                  ; Change the INK colour of the "G" in "Game" at
  AND $07                 ; (6,10)
  OR $40
  LD ($58CA),A
  INC A                   ; Change the INK colour of the "a" in "Game" at
  AND $07                 ; (6,11)
  OR $40
  LD ($58CB),A
  INC A                   ; Change the INK colour of the "m" in "Game" at
  AND $07                 ; (6,12)
  OR $40
  LD ($58CC),A
  INC A                   ; Change the INK colour of the "e" in "Game" at
  AND $07                 ; (6,13)
  OR $40
  LD ($58CD),A
  INC A                   ; Change the INK colour of the "O" in "Over" at
  AND $07                 ; (6,18)
  OR $40
  LD ($58D2),A
  INC A                   ; Change the INK colour of the "v" in "Over" at
  AND $07                 ; (6,19)
  OR $40
  LD ($58D3),A
  INC A                   ; Change the INK colour of the "e" in "Over" at
  AND $07                 ; (6,20)
  OR $40
  LD ($58D4),A
  INC A                   ; Change the INK colour of the "r" in "Over" at
  AND $07                 ; (6,21)
  OR $40
  LD ($58D5),A
  DEC C                   ; Decrement the counter in C
  JR NZ,TM91              ; Jump back unless it's zero
  DEC D                   ; Decrement the counter in D (initially 6)
  JR NZ,TM91              ; Jump back unless it's zero
  JP START                ; Display the title screen and play the theme tune

; Decrease the air remaining in the current cavern
;
; Used by the routines at LOOP, LIGHTBEAM and NXSHEET. Returns with the zero
; flag set if there is no air remaining.
DECAIR:
  LD A,(CLOCK)            ; Update the game clock at CLOCK
  SUB $04
  LD (CLOCK),A
  CP $FC                  ; Was it just decreased from zero?
  JR NZ,DECAIR_0          ; Jump if not
  LD A,(AIR)              ; Pick up the value of the remaining air supply from
                          ; AIR
  CP $24                  ; Has the air supply run out?
  RET Z                   ; Return (with the zero flag set) if so
  DEC A                   ; Decrement the air supply at AIR
  LD (AIR),A
  LD A,(CLOCK)            ; Pick up the value of the game clock at CLOCK
DECAIR_0:
  AND $E0                 ; A=INT(A/32); this value specifies how many pixels
  RLCA                    ; to draw from left to right in the cell at the right
  RLCA                    ; end of the air bar
  RLCA
  LD E,$00                ; Initialise E to 0 (all bits reset)
  OR A                    ; Do we need to draw any pixels in the cell at the
                          ; right end of the air bar?
  JR Z,DECAIR_2           ; Jump if not
  LD B,A                  ; Copy the number of pixels to draw (1-7) to B
DECAIR_1:
  RRC E                   ; Set this many bits in E (from bit 7 towards bit 0)
  SET 7,E
  DJNZ DECAIR_1
DECAIR_2:
  LD A,(AIR)              ; Pick up the value of the remaining air supply from
                          ; AIR
  LD L,A                  ; Set HL to the display file address at which to draw
  LD H,$52                ; the top row of pixels in the cell at the right end
                          ; of the air bar
  LD B,$04                ; There are four rows of pixels to draw
DECAIR_3:
  LD (HL),E               ; Draw the four rows of pixels at the right end of
  INC H                   ; the air bar
  DJNZ DECAIR_3
  XOR A                   ; Reset the zero flag to indicate that there is still
  INC A                   ; some air remaining; these instructions are
                          ; redundant, since the zero flag is already reset at
                          ; this point
  RET

; Draw the current cavern to the screen buffer at 7000
;
; Used by the routine at STARTGAME.
DRAWSHEET:
  LD IX,$5E00             ; Point IX at the first byte of the attribute buffer
                          ; at 24064
  LD A,$70                ; Set the operand of the 'LD D,n' instruction at
  LD ($8A9C),A            ; SBMSB (below) to $70
  CALL DRAWSHEET_0        ; Draw the tiles for the top half of the cavern to
                          ; the screen buffer at 28672
  LD IX,$5F00             ; Point IX at the 256th byte of the attribute buffer
                          ; at 24064 in preparation for drawing the bottom half
                          ; of the cavern; this instruction is redundant, since
                          ; IX already holds 5F00
  LD A,$78                ; Set the operand of the 'LD D,n' instruction at
  LD ($8A9C),A            ; SBMSB (below) to $78
DRAWSHEET_0:
  LD C,$00                ; C will count 256 tiles
; The following loop draws 256 tiles (for either the top half or the bottom
; half of the cavern) to the screen buffer at 28672.
DRAWSHEET_1:
  LD E,C                  ; E holds the LSB of the screen buffer address
  LD A,(IX+$00)           ; Pick up an attribute byte from the buffer at 24064;
                          ; this identifies the type of tile to draw
  LD HL,BACKGROUND        ; Move HL through the attribute bytes and graphic
  LD BC,$0048             ; data of the background, floor, crumbling floor,
  CPIR                    ; wall, conveyor and nasty tiles starting at
                          ; BACKGROUND until we find a byte that matches the
                          ; attribute byte of the tile to be drawn
  LD C,E                  ; Restore the value of the tile counter in C
  LD B,$08                ; There are eight bytes in the tile
SBMSB:
  LD D,$00                ; This instruction is set to either 'LD D,$70' or 'LD
                          ; D,$78' above; now DE holds the appropriate address
                          ; in the screen buffer at 28672
DRAWSHEET_2:
  LD A,(HL)               ; Copy the tile graphic data to the screen buffer at
  LD (DE),A               ; 28672
  INC HL
  INC D
  DJNZ DRAWSHEET_2
  INC IX                  ; Move IX along to the next byte in the attribute
                          ; buffer
  INC C                   ; Have we drawn 256 tiles yet?
  JP NZ,DRAWSHEET_1       ; If not, jump back to draw the next one
; The empty cavern has been drawn to the screen buffer at 28672. If we're in
; The Final Barrier, however, there is further work to do.
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $13                  ; Is it The Final Barrier?
  RET NZ                  ; Return if not
  LD HL,TITLESCR1         ; Copy the graphic data from TITLESCR1 to the top
  LD DE,$7000             ; half of the screen buffer at 28672
  LD BC,$0800
  LDIR
  RET

; Move Willy (1)
;
; Used by the routine at LOOP. This routine deals with Willy if he's jumping or
; falling.
MOVEWILLY:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $01                  ; Is Willy jumping?
  JR NZ,MOVEWILLY_3       ; Jump if not
; Willy is currently jumping.
  LD A,(JUMPING)          ; Pick up the jumping animation counter (0-17) from
                          ; JUMPING
  RES 0,A                 ; Now -8<=A<=8 (and A is even)
  SUB $08
  LD HL,PIXEL_Y           ; Adjust Willy's pixel y-coordinate at PIXEL_Y
  ADD A,(HL)              ; depending on where Willy is in the jump
  LD (HL),A
  CALL MOVEWILLY_7        ; Adjust Willy's attribute buffer location at
                          ; LOCATION depending on his pixel y-coordinate
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  CP (HL)                 ; Is the top-left cell of Willy's sprite overlapping
                          ; a wall tile?
  JP Z,MOVEWILLY_10       ; Jump if so
  INC HL                  ; Point HL at the top-right cell occupied by Willy's
                          ; sprite
  CP (HL)                 ; Is the top-right cell of Willy's sprite overlapping
                          ; a wall tile?
  JP Z,MOVEWILLY_10       ; Jump if so
  LD A,(JUMPING)          ; Increment the jumping animation counter at JUMPING
  INC A
  LD (JUMPING),A
  SUB $08                 ; A=J-8, where J (1-18) is the new value of the
                          ; jumping animation counter
  JP P,MOVEWILLY_0        ; Jump if J>=8
  NEG                     ; A=8-J (1<=J<=7, 1<=A<=7)
MOVEWILLY_0:
  INC A                   ; A=1+ABS(J-8)
  RLCA                    ; D=8*(1+ABS(J-8)); this value determines the pitch
  RLCA                    ; of the jumping sound effect (rising as Willy rises,
  RLCA                    ; falling as Willy falls)
  LD D,A
  LD C,$20                ; C=32; this value determines the duration of the
                          ; jumping sound effect
  LD A,(BORDER)           ; Pick up the border colour for the current cavern
                          ; from BORDER
MOVEWILLY_1:
  OUT ($FE),A             ; Make a jumping sound effect
  XOR $18
  LD B,D
MOVEWILLY_2:
  DJNZ MOVEWILLY_2
  DEC C
  JR NZ,MOVEWILLY_1
  LD A,(JUMPING)          ; Pick up the jumping animation counter (1-18) from
                          ; JUMPING
  CP $12                  ; Has Willy reached the end of the jump?
  JP Z,MOVEWILLY_8        ; Jump if so
  CP $10                  ; Is the jumping animation counter now 16?
  JR Z,MOVEWILLY_3        ; Jump if so
  CP $0D                  ; Is the jumping animation counter now 13?
  JP NZ,MOVEWILLY2_6      ; Jump if not
; If we get here, then Willy is standing on the floor, or he's falling, or his
; jumping animation counter is 13 (at which point Willy is on his way down and
; is exactly two cell-heights above where he started the jump) or 16 (at which
; point Willy is on his way down and is exactly one cell-height above where he
; started the jump).
MOVEWILLY_3:
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  AND $0F                 ; Does Willy's sprite occupy six cells at the moment?
  JR NZ,MOVEWILLY_4       ; Jump if so
  LD HL,(LOCATION)        ; Pick up Willy's attribute buffer coordinates from
                          ; LOCATION
  LD DE,$0040             ; Point HL at the left-hand cell below Willy's sprite
  ADD HL,DE
  LD A,(CRUMBLING)        ; Pick up the attribute byte of the crumbling floor
                          ; tile for the current cavern from CRUMBLING
  CP (HL)                 ; Does the left-hand cell below Willy's sprite
                          ; contain a crumbling floor tile?
  CALL Z,CRUMBLE          ; If so, make it crumble
  LD A,(NASTY1)           ; Pick up the attribute byte of the first nasty tile
                          ; for the current cavern from NASTY1
  CP (HL)                 ; Does the left-hand cell below Willy's sprite
                          ; contain a nasty tile?
  JR Z,MOVEWILLY_4        ; Jump if so
  LD A,(NASTY2)           ; Pick up the attribute byte of the second nasty tile
                          ; for the current cavern from NASTY2
  CP (HL)                 ; Does the left-hand cell below Willy's sprite
                          ; contain a nasty tile?
  JR Z,MOVEWILLY_4        ; Jump if so
  INC HL                  ; Point HL at the right-hand cell below Willy's
                          ; sprite
  LD A,(CRUMBLING)        ; Pick up the attribute byte of the crumbling floor
                          ; tile for the current cavern from CRUMBLING
  CP (HL)                 ; Does the right-hand cell below Willy's sprite
                          ; contain a crumbling floor tile?
  CALL Z,CRUMBLE          ; If so, make it crumble
  LD A,(NASTY1)           ; Pick up the attribute byte of the first nasty tile
                          ; for the current cavern from NASTY1
  CP (HL)                 ; Does the right-hand cell below Willy's sprite
                          ; contain a nasty tile?
  JR Z,MOVEWILLY_4        ; Jump if so
  LD A,(NASTY2)           ; Pick up the attribute byte of the second nasty tile
                          ; for the current cavern from NASTY2
  CP (HL)                 ; Does the right-hand cell below Willy's sprite
                          ; contain a nasty tile?
  JR Z,MOVEWILLY_4        ; Jump if so
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  CP (HL)                 ; Set the zero flag if the right-hand cell below
                          ; Willy's sprite is empty
  DEC HL                  ; Point HL at the left-hand cell below Willy's sprite
  JP NZ,MOVEWILLY2        ; Jump if the right-hand cell below Willy's sprite is
                          ; not empty
  CP (HL)                 ; Is the left-hand cell below Willy's sprite empty?
  JP NZ,MOVEWILLY2        ; Jump if not
MOVEWILLY_4:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $01                  ; Is Willy jumping?
  JP Z,MOVEWILLY2_6       ; Jump if so
; If we get here, then Willy is either in the process of falling or just about
; to start falling.
  LD HL,DMFLAGS           ; Reset bit 1 at DMFLAGS: Willy is not moving left or
  RES 1,(HL)              ; right
  OR A                    ; Is Willy already falling?
  JP Z,MOVEWILLY_9        ; Jump if not
  INC A                   ; Increment the airborne status indicator at AIRBORNE
  LD (AIRBORNE),A
  RLCA                    ; D=16*A; this value determines the pitch of the
  RLCA                    ; falling sound effect
  RLCA
  RLCA
  LD D,A
  LD C,$20                ; C=32; this value determines the duration of the
                          ; falling sound effect
  LD A,(BORDER)           ; Pick up the border colour for the current cavern
                          ; from BORDER
MOVEWILLY_5:
  OUT ($FE),A             ; Make a falling sound effect
  XOR $18
  LD B,D
MOVEWILLY_6:
  DJNZ MOVEWILLY_6
  DEC C
  JR NZ,MOVEWILLY_5
  LD A,(PIXEL_Y)          ; Add 8 to Willy's pixel y-coordinate at PIXEL_Y;
  ADD A,$08               ; this moves Willy downwards by 4 pixels
  LD (PIXEL_Y),A
MOVEWILLY_7:
  AND $F0                 ; L=16*Y, where Y is Willy's screen y-coordinate
  LD L,A                  ; (0-14)
  XOR A                   ; Clear A and the carry flag
  RL L                    ; Now L=32*(Y-8*INT(Y/8)), and the carry flag is set
                          ; if Willy is in the lower half of the cavern (Y>=8)
  ADC A,$5C               ; H=92 or 93 (MSB of the address of Willy's location
  LD H,A                  ; in the attribute buffer)
  LD A,(LOCATION)         ; Pick up Willy's screen x-coordinate (1-29) from
  AND $1F                 ; bits 0-4 at LOCATION
  OR L                    ; Now L holds the LSB of Willy's attribute buffer
  LD L,A                  ; address
  LD (LOCATION),HL        ; Store Willy's updated attribute buffer location at
                          ; LOCATION
  RET
; Willy has just finished a jump.
MOVEWILLY_8:
  LD A,$06                ; Set the airborne status indicator at AIRBORNE to 6:
  LD (AIRBORNE),A         ; Willy will continue to fall unless he's landed on a
                          ; wall or floor block
  RET
; Willy has just started falling.
MOVEWILLY_9:
  LD A,$02                ; Set the airborne status indicator at AIRBORNE to 2
  LD (AIRBORNE),A
  RET
; The top-left or top-right cell of Willy's sprite is overlapping a wall tile.
MOVEWILLY_10:
  LD A,(PIXEL_Y)          ; Adjust Willy's pixel y-coordinate at PIXEL_Y so
  ADD A,$10               ; that the top row of cells of his sprite is just
  AND $F0                 ; below the wall tile
  LD (PIXEL_Y),A
  CALL MOVEWILLY_7        ; Adjust Willy's attribute buffer location at
                          ; LOCATION to account for this new pixel y-coordinate
  LD A,$02                ; Set the airborne status indicator at AIRBORNE to 2:
  LD (AIRBORNE),A         ; Willy has started falling
  LD HL,DMFLAGS           ; Reset bit 1 at DMFLAGS: Willy is not moving left or
  RES 1,(HL)              ; right
  RET

; Animate a crumbling floor tile in the current cavern
;
; Used by the routine at MOVEWILLY.
;
; HL Address of the crumbling floor tile's location in the attribute buffer at
;    23552
CRUMBLE:
  LD C,L                  ; Point BC at the bottom row of pixels of the
  LD A,H                  ; crumbling floor tile in the screen buffer at 28672
  ADD A,$1B
  OR $07
  LD B,A
CRUMBLE_0:
  DEC B                   ; Collect the pixels from the row above in A
  LD A,(BC)
  INC B                   ; Copy these pixels into the row below it
  LD (BC),A
  DEC B                   ; Point BC at the next row of pixels up
  LD A,B                  ; Have we dealt with the bottom seven pixel rows of
  AND $07                 ; the crumbling floor tile yet?
  JR NZ,CRUMBLE_0         ; If not, jump back to deal with the next one up
  XOR A                   ; Clear the top row of pixels in the crumbling floor
  LD (BC),A               ; tile
  LD A,B                  ; Point BC at the bottom row of pixels in the
  ADD A,$07               ; crumbling floor tile
  LD B,A
  LD A,(BC)               ; Pick up the bottom row of pixels in A
  OR A                    ; Is the bottom row clear?
  RET NZ                  ; Return if not
; The bottom row of pixels in the crumbling floor tile is clear. Time to put a
; background tile in its place.
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  INC H                   ; Set HL to the address of the crumbling floor tile's
  INC H                   ; location in the attribute buffer at 24064
  LD (HL),A               ; Set the attribute at this location to that of the
                          ; background tile
  DEC H                   ; Set HL back to the address of the crumbling floor
  DEC H                   ; tile's location in the attribute buffer at 23552
  RET

; Move Willy (2)
;
; Used by the routine at MOVEWILLY. This routine checks the keyboard and
; joystick, and moves Willy left or right if necessary.
;
; HL Attribute buffer address of the left-hand cell below Willy's sprite
MOVEWILLY2:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $0C                  ; Has Willy just landed after falling from too great
                          ; a height?
  JP NC,KILLWILLY_0       ; If so, kill him
  LD E,$FF                ; Initialise E to 255 (all bits set); it will be used
                          ; to hold keyboard and joystick readings
  XOR A                   ; Reset the airborne status indicator at AIRBORNE
  LD (AIRBORNE),A         ; (Willy has landed safely)
  LD A,(CONVEYOR)         ; Pick up the attribute byte of the conveyor tile for
                          ; the current cavern from CONVEYOR
  CP (HL)                 ; Does the attribute byte of the left-hand cell below
                          ; Willy's sprite match that of the conveyor tile?
  JR Z,MOVEWILLY2_0       ; Jump if so
  INC HL                  ; Point HL at the right-hand cell below Willy's
                          ; sprite
  CP (HL)                 ; Does the attribute byte of the right-hand cell
                          ; below Willy's sprite match that of the conveyor
                          ; tile?
  JR NZ,MOVEWILLY2_1      ; Jump if not
MOVEWILLY2_0:
  LD A,(CONVDIR)          ; Pick up the direction byte of the conveyor
                          ; definition from CONVDIR (0=left, 1=right)
  SUB $03                 ; Now E=253 (bit 1 reset) if the conveyor is moving
  LD E,A                  ; left, or 254 (bit 0 reset) if it's moving right
MOVEWILLY2_1:
  LD BC,$DFFE             ; Read keys P-O-I-U-Y (right, left, right, left,
  IN A,(C)                ; right) into bits 0-4 of A
  AND $1F                 ; Set bit 5 and reset bits 6 and 7
  OR $20
  AND E                   ; Reset bit 0 if the conveyor is moving right, or bit
                          ; 1 if it's moving left
  LD E,A                  ; Save the result in E
  LD BC,$FBFE             ; Read keys Q-W-E-R-T (left, right, left, right,
  IN A,(C)                ; left) into bits 0-4 of A
  AND $1F                 ; Keep only bits 0-4, shift them into bits 1-5, and
  RLC A                   ; set bit 0
  OR $01
  AND E                   ; Merge this keyboard reading into bits 1-5 of E
  LD E,A
  LD B,$F7                ; Read keys 1-2-3-4-5 ('5' is left) into bits 0-4 of
  IN A,(C)                ; A
  RRCA                    ; Rotate the result right and set bits 0-2 and 4-7;
  OR $F7                  ; this ignores every key except '5' (left)
  AND E                   ; Merge this reading of the '5' key into bit 3 of E
  LD E,A
  LD B,$EF                ; Read keys 0-9-8-7-6 ('8' is right) into bits 0-4 of
  IN A,(C)                ; A
  OR $FB                  ; Set bits 0, 1 and 3-7; this ignores every key
                          ; except '8' (right)
  AND E                   ; Merge this reading of the '8' key into bit 2 of E
  LD E,A
  LD A,(KEMP)             ; Collect the Kempston joystick indicator from KEMP
  OR A                    ; Is the joystick connected?
  JR Z,MOVEWILLY2_2       ; Jump if not
  LD BC,$001F             ; Collect input from the joystick
  IN A,(C)
  AND $03                 ; Keep only bits 0 (right) and 1 (left) and flip them
  CPL
  AND E                   ; Merge this reading of the joystick right and left
  LD E,A                  ; buttons into bits 0 and 1 of E
; At this point, bits 0-5 in E indicate the direction in which Willy is being
; moved or trying to move. If bit 0, 2 or 4 is reset, Willy is being moved or
; trying to move right; if bit 1, 3 or 5 is reset, Willy is being moved or
; trying to move left.
MOVEWILLY2_2:
  LD C,$00                ; Initialise C to 0 (no movement)
  LD A,E                  ; Copy the movement bits into A
  AND $2A                 ; Keep only bits 1, 3 and 5 (the 'left' bits)
  CP $2A                  ; Are any of these bits reset?
  JR Z,MOVEWILLY2_3       ; Jump if not
  LD C,$04                ; Set bit 2 of C: Willy is moving left
MOVEWILLY2_3:
  LD A,E                  ; Copy the movement bits into A
  AND $15                 ; Keep only bits 0, 2 and 4 (the 'right' bits)
  CP $15                  ; Are any of these bits reset?
  JR Z,MOVEWILLY2_4       ; Jump if not
  SET 3,C                 ; Set bit 3 of C: Willy is moving right
MOVEWILLY2_4:
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  ADD A,C                 ; Point HL at the entry in the left-right movement
  LD C,A                  ; table at LRMOVEMENT that corresponds to the
  LD B,$00                ; direction Willy is facing, and the direction in
  LD HL,LRMOVEMENT        ; which he is being moved or trying to move
  ADD HL,BC
  LD A,(HL)               ; Update Willy's direction and movement flags at
  LD (DMFLAGS),A          ; DMFLAGS with the entry from the left-right movement
                          ; table
; That is left-right movement taken care of. Now check the jump keys.
  LD BC,$7EFE             ; Read keys SHIFT-Z-X-C-V and B-N-M-SS-SPACE
  IN A,(C)
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR NZ,MOVEWILLY2_5      ; Jump if so
  LD B,$EF                ; Read keys 0-9-8-7-6 into bits 0-4 of A
  IN A,(C)
  AND $09                 ; Keep only bits 0 (the '0' key) and 3 (the '7' key)
  CP $09                  ; Is '0' or '7' being pressed?
  JR NZ,MOVEWILLY2_5      ; Jump if so
  LD A,(KEMP)             ; Collect the Kempston joystick indicator from KEMP
  OR A                    ; Is the joystick connected?
  JR Z,MOVEWILLY2_6       ; Jump if not
  LD BC,$001F             ; Collect input from the joystick
  IN A,(C)
  BIT 4,A                 ; Is the fire button being pressed?
  JR Z,MOVEWILLY2_6       ; Jump if not
; A jump key or the fire button is being pressed. Time to make Willy jump.
MOVEWILLY2_5:
  XOR A                   ; Initialise the jumping animation counter at JUMPING
  LD (JUMPING),A
  INC A                   ; Set the airborne status indicator at AIRBORNE to 1:
  LD (AIRBORNE),A         ; Willy is jumping
; This entry point is used by the routine at MOVEWILLY.
MOVEWILLY2_6:
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  AND $02                 ; Is Willy moving?
  RET Z                   ; Return if not
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  AND $01                 ; Is Willy facing right?
  JP Z,MOVEWILLY2_9       ; Jump if so
; Willy is moving left.
  LD A,(FRAME)            ; Pick up Willy's animation frame from FRAME
  OR A                    ; Is it 0?
  JR Z,MOVEWILLY2_7       ; If so, jump to move Willy's sprite left across a
                          ; cell boundary
  DEC A                   ; Decrement Willy's animation frame at FRAME
  LD (FRAME),A
  RET
; Willy's sprite is moving left across a cell boundary. In the comments that
; follow, (x,y) refers to the coordinates of the top-left cell currently
; occupied by Willy's sprite.
MOVEWILLY2_7:
  LD HL,(LOCATION)        ; Collect Willy's attribute buffer coordinates from
                          ; LOCATION
  DEC HL                  ; Point HL at the cell at (x-1,y+1)
  LD DE,$0020
  ADD HL,DE
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  AND $0F                 ; Does Willy's sprite currently occupy only two rows
                          ; of cells?
  JR Z,MOVEWILLY2_8       ; Jump if so
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  ADD HL,DE               ; Point HL at the cell at (x-1,y+2)
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  OR A                    ; Clear the carry flag for subtraction
  SBC HL,DE               ; Point HL at the cell at (x-1,y+1)
MOVEWILLY2_8:
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  OR A                    ; Clear the carry flag for subtraction
  SBC HL,DE               ; Point HL at the cell at (x-1,y)
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  LD (LOCATION),HL        ; Save Willy's new attribute buffer coordinates (in
                          ; HL) at LOCATION
  LD A,$03                ; Change Willy's animation frame at FRAME from 0 to 3
  LD (FRAME),A
  RET
; Willy is moving right.
MOVEWILLY2_9:
  LD A,(FRAME)            ; Pick up Willy's animation frame from FRAME
  CP $03                  ; Is it 3?
  JR Z,MOVEWILLY2_10      ; If so, jump to move Willy's sprite right across a
                          ; cell boundary
  INC A                   ; Increment Willy's animation frame at FRAME
  LD (FRAME),A
  RET
; Willy's sprite is moving right across a cell boundary. In the comments that
; follow, (x,y) refers to the coordinates of the top-left cell currently
; occupied by Willy's sprite.
MOVEWILLY2_10:
  LD HL,(LOCATION)        ; Collect Willy's attribute buffer coordinates from
                          ; LOCATION
  INC HL                  ; Point HL at the cell at (x+2,y)
  INC HL
  LD DE,$0020             ; Prepare DE for addition
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  ADD HL,DE               ; Point HL at the cell at (x+2,y+1)
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  AND $0F                 ; Does Willy's sprite currently occupy only two rows
                          ; of cells?
  JR Z,MOVEWILLY2_11      ; Jump if so
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  ADD HL,DE               ; Point HL at the cell at (x+2,y+2)
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  OR A                    ; Clear the carry flag for subtraction
  SBC HL,DE               ; Point HL at the cell at (x+2,y+1)
MOVEWILLY2_11:
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current cavern from WALL
  OR A                    ; Clear the carry flag for subtraction
  SBC HL,DE               ; Point HL at the cell at (x+2,y)
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  DEC HL                  ; Point HL at the cell at (x+1,y)
  LD (LOCATION),HL        ; Save Willy's new attribute buffer coordinates (in
                          ; HL) at LOCATION
  XOR A                   ; Change Willy's animation frame at FRAME from 3 to 0
  LD (FRAME),A
  RET

; Kill Willy
;
; Used by the routine at WILLYATTR when Willy hits a nasty.
KILLWILLY:
  POP HL                  ; Drop the return address from the stack
; This entry point is used by the routines at MOVEWILLY2 (when Willy lands
; after falling from too great a height), DRAWHG (when Willy collides with a
; horizontal guardian), EUGENE (when Willy collides with Eugene), VGUARDIANS
; (when Willy collides with a vertical guardian) and KONGBEAST (when Willy
; collides with the Kong Beast).
KILLWILLY_0:
  POP HL                  ; Drop the return address from the stack
; This entry point is used by the routine at SKYLABS when a Skylab falls on
; Willy.
KILLWILLY_1:
  LD A,$FF                ; Set the airborne status indicator at AIRBORNE to
  LD (AIRBORNE),A         ; 255 (meaning Willy has had a fatal accident)
  JP LOOP_4               ; Jump back into the main loop

; Move the horizontal guardians in the current cavern
;
; Used by the routine at LOOP.
MOVEHG:
  LD IY,HGUARDS           ; Point IY at the first byte of the first horizontal
                          ; guardian definition at HGUARDS
  LD DE,$0007             ; Prepare DE for addition (there are 7 bytes in a
                          ; guardian definition)
; The guardian-moving loop begins here.
MOVEHG_0:
  LD A,(IY+$00)           ; Pick up the first byte of the guardian definition
  CP $FF                  ; Have we dealt with all the guardians yet?
  RET Z                   ; Return if so
  OR A                    ; Is this guardian definition blank?
  JR Z,MOVEHG_6           ; If so, skip it and consider the next one
  LD A,(CLOCK)            ; Pick up the value of the game clock at CLOCK
  AND $04                 ; Move bit 2 (which is toggled on each pass through
  RRCA                    ; the main loop) to bit 7 and clear all the other
  RRCA                    ; bits
  RRCA
  AND (IY+$00)            ; Combine this bit with bit 7 of the first byte of
                          ; the guardian definition, which specifies the
                          ; guardian's animation speed: 0=normal, 1=slow
  JR NZ,MOVEHG_6          ; Jump to consider the next guardian if this one is
                          ; not due to be moved on this pass
; The guardian will be moved on this pass.
  LD A,(IY+$04)           ; Pick up the current animation frame (0-7)
  CP $03                  ; Is it 3 (the terminal frame for a guardian moving
                          ; right)?
  JR Z,MOVEHG_2           ; Jump if so to move the guardian right across a cell
                          ; boundary or turn it round
  CP $04                  ; Is the current animation frame 4 (the terminal
                          ; frame for a guardian moving left)?
  JR Z,MOVEHG_4           ; Jump if so to move the guardian left across a cell
                          ; boundary or turn it round
  JR NC,MOVEHG_1          ; Jump if the animation frame is 5, 6 or 7
  INC (IY+$04)            ; Increment the animation frame (this guardian is
                          ; moving right)
  JR MOVEHG_6             ; Jump forward to consider the next guardian
MOVEHG_1:
  DEC (IY+$04)            ; Decrement the animation frame (this guardian is
                          ; moving left)
  JR MOVEHG_6             ; Jump forward to consider the next guardian
MOVEHG_2:
  LD A,(IY+$01)           ; Pick up the LSB of the address of the guardian's
                          ; location in the attribute buffer at 23552
  CP (IY+$06)             ; Has the guardian reached the rightmost point in its
                          ; path?
  JR NZ,MOVEHG_3          ; Jump if not
  LD (IY+$04),$07         ; Set the animation frame to 7 (turning the guardian
                          ; round to face left)
  JR MOVEHG_6             ; Jump forward to consider the next guardian
MOVEHG_3:
  LD (IY+$04),$00         ; Set the animation frame to 0 (the initial frame for
                          ; a guardian moving right)
  INC (IY+$01)            ; Increment the guardian's x-coordinate (moving it
                          ; right across a cell boundary)
  JR MOVEHG_6             ; Jump forward to consider the next guardian
MOVEHG_4:
  LD A,(IY+$01)           ; Pick up the LSB of the address of the guardian's
                          ; location in the attribute buffer at 23552
  CP (IY+$05)             ; Has the guardian reached the leftmost point in its
                          ; path?
  JR NZ,MOVEHG_5          ; Jump if not
  LD (IY+$04),$00         ; Set the animation frame to 0 (turning the guardian
                          ; round to face right)
  JR MOVEHG_6             ; Jump forward to consider the next guardian
MOVEHG_5:
  LD (IY+$04),$07         ; Set the animation frame to 7 (the initial frame for
                          ; a guardian moving left)
  DEC (IY+$01)            ; Decrement the guardian's x-coordinate (moving it
                          ; left across a cell boundary)
; The current guardian definition has been dealt with. Time for the next one.
MOVEHG_6:
  ADD IY,DE               ; Point IY at the first byte of the next horizontal
                          ; guardian definition
  JR MOVEHG_0             ; Jump back to deal with the next horizontal guardian

; Move and draw the light beam in Solar Power Generator
;
; Used by the routine at LOOP.
LIGHTBEAM:
  LD HL,$5C17             ; Point HL at the cell at (0,23) in the attribute
                          ; buffer at 23552 (the source of the light beam)
  LD DE,$0020             ; Prepare DE for addition (the beam travels
                          ; vertically downwards to start with)
; The beam-drawing loop begins here.
LIGHTBEAM_0:
  LD A,(FLOOR)            ; Pick up the attribute byte of the floor tile for
                          ; the cavern from FLOOR
  CP (HL)                 ; Does HL point at a floor tile?
  RET Z                   ; Return if so (the light beam stops here)
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; cavern from WALL
  CP (HL)                 ; Does HL point at a wall tile?
  RET Z                   ; Return if so (the light beam stops here)
  LD A,$27                ; A=39 (INK 7: PAPER 4)
  CP (HL)                 ; Does HL point at a tile with this attribute value?
  JR NZ,LIGHTBEAM_1       ; Jump if not (the light beam is not touching Willy)
  EXX                     ; Switch to the shadow registers briefly (to preserve
                          ; DE and HL)
  CALL DECAIR             ; Decrease the air supply by four units
  CALL DECAIR
  CALL DECAIR
  CALL DECAIR
  EXX                     ; Switch back to the normal registers (restoring DE
                          ; and HL)
  JR LIGHTBEAM_2          ; Jump forward to draw the light beam over Willy
LIGHTBEAM_1:
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the cavern from BACKGROUND
  CP (HL)                 ; Does HL point at a background tile?
  JR Z,LIGHTBEAM_2        ; Jump if so (the light beam will not be reflected at
                          ; this point)
  LD A,E                  ; Toggle the value in DE between 32 and -1 (and
  XOR $DF                 ; therefore the direction of the light beam between
  LD E,A                  ; vertically downwards and horizontally to the left):
  LD A,D                  ; the light beam has hit a guardian
  CPL
  LD D,A
LIGHTBEAM_2:
  LD (HL),$77             ; Draw a portion of the light beam with attribute
                          ; value 119 (INK 7: PAPER 6: BRIGHT 1)
  ADD HL,DE               ; Point HL at the cell where the next portion of the
                          ; light beam will be drawn
  JR LIGHTBEAM_0          ; Jump back to draw the next portion of the light
                          ; beam

; Draw the horizontal guardians in the current cavern
;
; Used by the routine at LOOP.
DRAWHG:
  LD IY,HGUARDS           ; Point IY at the first byte of the first horizontal
                          ; guardian definition at HGUARDS
; The guardian-drawing loop begins here.
DRAWHG_0:
  LD A,(IY+$00)           ; Pick up the first byte of the guardian definition
  CP $FF                  ; Have we dealt with all the guardians yet?
  RET Z                   ; Return if so
  OR A                    ; Is this guardian definition blank?
  JR Z,DRAWHG_2           ; If so, skip it and consider the next one
  LD DE,$001F             ; Prepare DE for addition
  LD L,(IY+$01)           ; Point HL at the address of the guardian's location
  LD H,(IY+$02)           ; in the attribute buffer at 23552
  AND $7F                 ; Reset bit 7 (which specifies the animation speed)
                          ; of the attribute byte, ensuring no FLASH
  LD (HL),A               ; Set the attribute bytes for the guardian in the
  INC HL                  ; buffer at 23552
  LD (HL),A
  ADD HL,DE
  LD (HL),A
  INC HL
  LD (HL),A
  LD C,$01                ; Prepare C for the call to the drawing routine at
                          ; DRWFIX later on
  LD A,(IY+$04)           ; Pick up the animation frame (0-7)
  RRCA                    ; Multiply it by 32
  RRCA
  RRCA
  LD E,A                  ; Copy the result to E
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  CP $07                  ; Are we in one of the first seven caverns?
  JR C,DRAWHG_1           ; Jump if so
  CP $09                  ; Are we in The Endorian Forest?
  JR Z,DRAWHG_1           ; Jump if so
  CP $0F                  ; Are we in The Sixteenth Cavern?
  JR Z,DRAWHG_1           ; Jump if so
  SET 7,E                 ; Add 128 to E (the horizontal guardians in this
                          ; cavern use frames 4-7 only)
DRAWHG_1:
  LD D,$81                ; Point DE at the graphic data for the appropriate
                          ; guardian sprite (at GGDATA+E)
  LD L,(IY+$01)           ; Point HL at the address of the guardian's location
  LD H,(IY+$03)           ; in the screen buffer at 24576
  CALL DRWFIX             ; Draw the guardian to the screen buffer at 24576
  JP NZ,KILLWILLY_0       ; Kill Willy if the guardian collided with him
; The current guardian definition has been dealt with. Time for the next one.
DRAWHG_2:
  LD DE,$0007             ; Point IY at the first byte of the next horizontal
  ADD IY,DE               ; guardian definition
  JR DRAWHG_0             ; Jump back to deal with the next horizontal guardian

; Move and draw Eugene in Eugene's Lair
;
; Used by the routine at LOOP. First we move Eugene up or down, or change his
; direction.
EUGENE:
  LD A,(ITEMATTR)         ; Pick up the attribute of the last item drawn from
                          ; ITEMATTR
  OR A                    ; Have all the items been collected?
  JR Z,EUGENE_0           ; Jump if so
  LD A,(EUGDIR)           ; Pick up Eugene's direction from EUGDIR
  OR A                    ; Is Eugene moving downwards?
  JR Z,EUGENE_0           ; Jump if so
  LD A,(EUGHGT)           ; Pick up Eugene's pixel y-coordinate from EUGHGT
  DEC A                   ; Decrement it (moving Eugene up)
  JR Z,EUGENE_1           ; Jump if Eugene has reached the top of the cavern
  LD (EUGHGT),A           ; Update Eugene's pixel y-coordinate at EUGHGT
  JR EUGENE_2
EUGENE_0:
  LD A,(EUGHGT)           ; Pick up Eugene's pixel y-coordinate from EUGHGT
  INC A                   ; Increment it (moving Eugene down)
  CP $58                  ; Has Eugene reached the portal yet?
  JR Z,EUGENE_1           ; Jump if so
  LD (EUGHGT),A           ; Update Eugene's pixel y-coordinate at EUGHGT
  JR EUGENE_2
EUGENE_1:
  LD A,(EUGDIR)           ; Toggle Eugene's direction at EUGDIR
  XOR $01
  LD (EUGDIR),A
; Now that Eugene's movement has been dealt with, it's time to draw him.
EUGENE_2:
  LD A,(EUGHGT)           ; Pick up Eugene's pixel y-coordinate from EUGHGT
  AND $7F                 ; Point DE at the entry in the screen buffer address
  RLCA                    ; lookup table at SBUFADDRS that corresponds to
  LD E,A                  ; Eugene's y-coordinate
  LD D,$83
  LD A,(DE)               ; Point HL at the address of Eugene's location in the
  OR $0F                  ; screen buffer at 24576
  LD L,A
  INC DE
  LD A,(DE)
  LD H,A
  LD DE,$80E0             ; Draw Eugene to the screen buffer at 24576
  LD C,$01
  CALL DRWFIX
  JP NZ,KILLWILLY_0       ; Kill Willy if Eugene collided with him
  LD A,(EUGHGT)           ; Pick up Eugene's pixel y-coordinate from EUGHGT
  AND $78                 ; Point HL at the address of Eugene's location in the
  RLCA                    ; attribute buffer at 23552
  OR $07
  SCF
  RL A
  LD L,A
  LD A,$00
  ADC A,$5C
  LD H,A
  LD A,(ITEMATTR)         ; Pick up the attribute of the last item drawn from
                          ; ITEMATTR
  OR A                    ; Set the zero flag if all the items have been
                          ; collected
  LD A,$07                ; Assume we will draw Eugene with white INK
  JR NZ,EUGENE_3          ; Jump if there are items remaining to be collected
  LD A,(CLOCK)            ; Pick up the value of the game clock at CLOCK
  RRCA                    ; Move bits 2-4 into bits 0-2 and clear the other
  RRCA                    ; bits; this value (which decreases by one on each
  AND $07                 ; pass through the main loop) will be Eugene's INK
                          ; colour
; This entry point is used by the routines at SKYLABS (to set the attributes
; for a Skylab), VGUARDIANS (to set the attributes for a vertical guardian) and
; KONGBEAST (to set the attributes for the Kong Beast).
EUGENE_3:
  LD (HL),A               ; Save the INK colour in the attribute buffer
                          ; temporarily
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  AND $F8                 ; Combine its PAPER colour with the chosen INK colour
  OR (HL)
  LD (HL),A               ; Set the attribute byte for the top-left cell of the
                          ; sprite in the attribute buffer at 23552
  LD DE,$001F             ; Prepare DE for addition
  INC HL                  ; Set the attribute byte for the top-right cell of
  LD (HL),A               ; the sprite in the attribute buffer at 23552
  ADD HL,DE               ; Set the attribute byte for the middle-left cell of
  LD (HL),A               ; the sprite in the attribute buffer at 23552
  INC HL                  ; Set the attribute byte for the middle-right cell of
  LD (HL),A               ; the sprite in the attribute buffer at 23552
  ADD HL,DE               ; Set the attribute byte for the bottom-left cell of
  LD (HL),A               ; the sprite in the attribute buffer at 23552
  INC HL                  ; Set the attribute byte for the bottom-right cell of
  LD (HL),A               ; the sprite in the attribute buffer at 23552
  RET

; Move and draw the Skylabs in Skylab Landing Bay
;
; Used by the routine at LOOP.
SKYLABS:
  LD IY,VGUARDS           ; Point IY at the first byte of the first vertical
                          ; guardian definition at VGUARDS
; The Skylab-moving loop begins here.
SKYLABS_0:
  LD A,(IY+$00)           ; Pick up the first byte of the guardian definition
  CP $FF                  ; Have we dealt with all the Skylabs yet?
  JP Z,LOOP_3             ; If so, re-enter the main loop
  LD A,(IY+$02)           ; Pick up the Skylab's pixel y-coordinate
  CP (IY+$06)             ; Has it reached its crash site yet?
  JR NC,SKYLABS_1         ; Jump if so
  ADD A,(IY+$04)          ; Increment the Skylab's y-coordinate (moving it
  LD (IY+$02),A           ; downwards)
  JR SKYLABS_2
; The Skylab has reached its crash site. Start or continue its disintegration.
SKYLABS_1:
  INC (IY+$01)            ; Increment the animation frame
  LD A,(IY+$01)           ; Pick up the animation frame
  CP $08                  ; Has the Skylab completely disintegrated yet?
  JR NZ,SKYLABS_2         ; Jump if not
  LD A,(IY+$05)           ; Reset the Skylab's pixel y-coordinate
  LD (IY+$02),A
  LD A,(IY+$03)           ; Add 8 to the Skylab's x-coordinate (wrapping around
  ADD A,$08               ; at the right side of the screen)
  AND $1F
  LD (IY+$03),A
  LD (IY+$01),$00         ; Reset the animation frame to 0
; Now that the Skylab's movement has been dealt with, time to draw it.
SKYLABS_2:
  LD E,(IY+$02)           ; Pick up the Skylab's pixel y-coordinate in E
  RLC E                   ; Point DE at the entry in the screen buffer address
  LD D,$83                ; lookup table at SBUFADDRS that corresponds to the
                          ; Skylab's pixel y-coordinate
  LD A,(DE)               ; Point HL at the address of the Skylab's location in
  ADD A,(IY+$03)          ; the screen buffer at 24576
  LD L,A
  INC DE
  LD A,(DE)
  LD H,A
  LD A,(IY+$01)           ; Pick up the animation frame (0-7)
  RRCA                    ; Multiply it by 32
  RRCA
  RRCA
  LD E,A                  ; Point DE at the graphic data for the corresponding
  LD D,$81                ; Skylab sprite (at GGDATA+A)
  LD C,$01                ; Draw the Skylab to the screen buffer at 24576
  CALL DRWFIX
  JP NZ,KILLWILLY_1       ; Kill Willy if the Skylab collided with him
  LD A,(IY+$02)           ; Point HL at the address of the Skylab's location in
  AND $40                 ; the attribute buffer at 23552
  RLCA
  RLCA
  ADD A,$5C
  LD H,A
  LD A,(IY+$02)
  RLCA
  RLCA
  AND $E0
  OR (IY+$03)
  LD L,A
  LD A,(IY+$00)           ; Pick up the Skylab's attribute byte
  CALL EUGENE_3           ; Set the attribute bytes for the Skylab
; The current guardian definition has been dealt with. Time for the next one.
  LD DE,$0007             ; Point IY at the first byte of the next vertical
  ADD IY,DE               ; guardian definition
  JR SKYLABS_0            ; Jump back to deal with the next Skylab

; Move and draw the vertical guardians in the current cavern
;
; Used by the routine at LOOP.
VGUARDIANS:
  LD IY,VGUARDS           ; Point IY at the first byte of the first vertical
                          ; guardian definition at VGUARDS
; The guardian-moving loop begins here.
VGUARDIANS_0:
  LD A,(IY+$00)           ; Pick up the first byte of the guardian definition
  CP $FF                  ; Have we dealt with all the guardians yet?
  RET Z                   ; Return if so
  INC (IY+$01)            ; Increment the guardian's animation frame
  RES 2,(IY+$01)          ; Reset the animation frame to 0 if it overflowed to
                          ; 4
  LD A,(IY+$02)           ; Pick up the guardian's pixel y-coordinate
  ADD A,(IY+$04)          ; Add the current y-coordinate increment
  CP (IY+$05)             ; Has the guardian reached the highest point of its
                          ; path (minimum y-coordinate)?
  JR C,VGUARDIANS_1       ; If so, jump to change its direction of movement
  CP (IY+$06)             ; Has the guardian reached the lowest point of its
                          ; path (maximum y-coordinate)?
  JR NC,VGUARDIANS_1      ; If so, jump to change its direction of movement
  LD (IY+$02),A           ; Update the guardian's pixel y-coordinate
  JR VGUARDIANS_2
VGUARDIANS_1:
  LD A,(IY+$04)           ; Negate the y-coordinate increment; this changes the
  NEG                     ; guardian's direction of movement
  LD (IY+$04),A
; Now that the guardian's movement has been dealt with, time to draw it.
VGUARDIANS_2:
  LD A,(IY+$02)           ; Pick up the guardian's pixel y-coordinate
  AND $7F                 ; Point DE at the entry in the screen buffer address
  RLCA                    ; lookup table at SBUFADDRS that corresponds to the
  LD E,A                  ; guardian's pixel y-coordinate
  LD D,$83
  LD A,(DE)               ; Point HL at the address of the guardian's location
  OR (IY+$03)             ; in the screen buffer at 24576
  LD L,A
  INC DE
  LD A,(DE)
  LD H,A
  LD A,(IY+$01)           ; Pick up the guardian's animation frame (0-3)
  RRCA                    ; Multiply it by 32
  RRCA
  RRCA
  LD E,A                  ; Point DE at the graphic data for the appropriate
  LD D,$81                ; guardian sprite (at GGDATA+A)
  LD C,$01                ; Draw the guardian to the screen buffer at 24576
  CALL DRWFIX
  JP NZ,KILLWILLY_0       ; Kill Willy if the guardian collided with him
  LD A,(IY+$02)           ; Pick up the guardian's pixel y-coordinate
  AND $40                 ; Point HL at the address of the guardian's location
  RLCA                    ; in the attribute buffer at 23552
  RLCA
  ADD A,$5C
  LD H,A
  LD A,(IY+$02)
  RLCA
  RLCA
  AND $E0
  OR (IY+$03)
  LD L,A
  LD A,(IY+$00)           ; Pick up the guardian's attribute byte
  CALL EUGENE_3           ; Set the attribute bytes for the guardian
; The current guardian definition has been dealt with. Time for the next one.
  LD DE,$0007             ; Point IY at the first byte of the next vertical
  ADD IY,DE               ; guardian definition
  JR VGUARDIANS_0         ; Jump back to deal with the next vertical guardian

; Draw the items in the current cavern and collect any that Willy is touching
;
; Used by the routine at LOOP.
DRAWITEMS:
  XOR A                   ; Initialise the attribute of the last item drawn at
  LD (ITEMATTR),A         ; ITEMATTR to 0 (in case there are no items left to
                          ; draw)
  LD IY,ITEMS             ; Point IY at the first byte of the first item
                          ; definition at ITEMS
; The item-drawing loop begins here.
DRAWITEMS_0:
  LD A,(IY+$00)           ; Pick up the first byte of the item definition
  CP $FF                  ; Have we dealt with all the items yet?
  JR Z,DRAWITEMS_3        ; Jump if so
  OR A                    ; Has this item already been collected?
  JR Z,DRAWITEMS_2        ; If so, skip it and consider the next one
  LD E,(IY+$01)           ; Point DE at the address of the item's location in
  LD D,(IY+$02)           ; the attribute buffer at 23552
  LD A,(DE)               ; Pick up the current attribute byte at the item's
                          ; location
  AND $07                 ; Is the INK white (which happens if Willy is
  CP $07                  ; touching the item)?
  JR NZ,DRAWITEMS_1       ; Jump if not
; Willy is touching this item, so add it to his collection.
  LD HL,$842C             ; Add 100 to the score
  CALL INCSCORE_0
  LD (IY+$00),$00         ; Set the item's attribute byte to 0 so that it will
                          ; be skipped the next time
  JR DRAWITEMS_2          ; Jump forward to consider the next item
; This item has not been collected yet.
DRAWITEMS_1:
  LD A,(IY+$00)           ; Pick up the item's current attribute byte
  AND $F8                 ; Keep the BRIGHT and PAPER bits, and set the INK to
  OR $03                  ; 3 (magenta)
  LD B,A                  ; Store this value in B
  LD A,(IY+$00)           ; Pick up the item's current attribute byte again
  AND $03                 ; Keep only bits 0 and 1 and add the value in B; this
  ADD A,B                 ; maintains the BRIGHT and PAPER bits, and cycles the
                          ; INK colour through 3, 4, 5 and 6
  LD (IY+$00),A           ; Store the new attribute byte
  LD (DE),A               ; Update the attribute byte at the item's location in
                          ; the buffer at 23552
  LD (ITEMATTR),A         ; Store the new attribute byte at ITEMATTR as well
  LD D,(IY+$03)           ; Point DE at the address of the item's location in
                          ; the screen buffer at 24576
  LD HL,ITEM              ; Point HL at the item graphic for the current cavern
                          ; (at ITEM)
  LD B,$08                ; There are eight pixel rows to copy
  CALL PRINTCHAR_0        ; Draw the item to the screen buffer at 24576
; The current item definition has been dealt with. Time for the next one.
DRAWITEMS_2:
  INC IY                  ; Point IY at the first byte of the next item
  INC IY                  ; definition
  INC IY
  INC IY
  INC IY
  JR DRAWITEMS_0          ; Jump back to deal with the next item
; All the items have been dealt with. Check whether there were any left.
DRAWITEMS_3:
  LD A,(ITEMATTR)         ; Pick up the attribute of the last item drawn at
                          ; ITEMATTR
  OR A                    ; Were any items drawn?
  RET NZ                  ; Return if so (some remain to be collected)
  LD HL,PORTAL            ; Ensure that the portal is flashing by setting bit 7
  SET 7,(HL)              ; of its attribute byte at PORTAL
  RET

; Draw the portal, or move to the next cavern if Willy has entered it
;
; Used by the routine at LOOP. First check whether Willy has entered the
; portal.
CHKPORTAL:
  LD HL,(PORTALLOC1)      ; Pick up the address of the portal's location in the
                          ; attribute buffer at 23552 from PORTALLOC1
  LD A,(LOCATION)         ; Pick up the LSB of the address of Willy's location
                          ; in the attribute buffer at 23552 from LOCATION
  CP L                    ; Does it match that of the portal?
  JR NZ,CHKPORTAL_0       ; Jump if not
  LD A,($806D)            ; Pick up the MSB of the address of Willy's location
                          ; in the attribute buffer at 23552 from 806D
  CP H                    ; Does it match that of the portal?
  JR NZ,CHKPORTAL_0       ; Jump if not
  LD A,(PORTAL)           ; Pick up the portal's attribute byte from PORTAL
  BIT 7,A                 ; Is the portal flashing?
  JR Z,CHKPORTAL_0        ; Jump if not
  POP HL                  ; Drop the return address from the stack
  JP NXSHEET              ; Move Willy to the next cavern
; Willy has not entered the portal, or it's not flashing, so just draw it.
CHKPORTAL_0:
  LD A,(PORTAL)           ; Pick up the portal's attribute byte from PORTAL
  LD (HL),A               ; Set the attribute bytes for the portal in the
  INC HL                  ; buffer at 23552
  LD (HL),A
  LD DE,$001F
  ADD HL,DE
  LD (HL),A
  INC HL
  LD (HL),A
  LD DE,PORTALG           ; Point DE at the graphic data for the portal at
                          ; PORTALG
  LD HL,(PORTALLOC2)      ; Pick up the address of the portal's location in the
                          ; screen buffer at 24576 from PORTALLOC2
  LD C,$00                ; C=0: overwrite mode
; This routine continues into the one at DRWFIX.

; Draw a sprite
;
; Used by the routines at START (to draw Willy on the title screen), LOOP (to
; draw the remaining lives), ENDGAM (to draw Willy, the boot and the plinth
; during the game over sequence), DRAWHG (to draw horizontal guardians), EUGENE
; (to draw Eugene in Eugene's Lair), SKYLABS (to draw the Skylabs in Skylab
; Landing Bay), VGUARDIANS (to draw vertical guardians), CHKPORTAL (to draw the
; portal in the current cavern), NXSHEET (to draw Willy above ground and the
; swordfish graphic over the portal in The Final Barrier) and KONGBEAST (to
; draw the Kong Beast in Miner Willy meets the Kong Beast and Return of the
; Alien Kong Beast). If C=1 on entry, this routine returns with the zero flag
; reset if any of the set bits in the sprite being drawn collides with a set
; bit in the background.
;
; C Drawing mode: 0 (overwrite) or 1 (blend)
; DE Address of sprite graphic data
; HL Address to draw at
DRWFIX:
  LD B,$10                ; There are 16 rows of pixels to draw
DRWFIX_0:
  BIT 0,C                 ; Set the zero flag if we're in overwrite mode
  LD A,(DE)               ; Pick up a sprite graphic byte
  JR Z,DRWFIX_1           ; Jump if we're in overwrite mode
  AND (HL)                ; Return with the zero flag reset if any of the set
  RET NZ                  ; bits in the sprite graphic byte collide with a set
                          ; bit in the background (e.g. in Willy's sprite)
  LD A,(DE)               ; Pick up the sprite graphic byte again
  OR (HL)                 ; Blend it with the background byte
DRWFIX_1:
  LD (HL),A               ; Copy the graphic byte to its destination cell
  INC L                   ; Move HL along to the next cell on the right
  INC DE                  ; Point DE at the next sprite graphic byte
  BIT 0,C                 ; Set the zero flag if we're in overwrite mode
  LD A,(DE)               ; Pick up a sprite graphic byte
  JR Z,DRWFIX_2           ; Jump if we're in overwrite mode
  AND (HL)                ; Return with the zero flag reset if any of the set
  RET NZ                  ; bits in the sprite graphic byte collide with a set
                          ; bit in the background (e.g. in Willy's sprite)
  LD A,(DE)               ; Pick up the sprite graphic byte again
  OR (HL)                 ; Blend it with the background byte
DRWFIX_2:
  LD (HL),A               ; Copy the graphic byte to its destination cell
  DEC L                   ; Move HL to the next pixel row down in the cell on
  INC H                   ; the left
  INC DE                  ; Point DE at the next sprite graphic byte
  LD A,H                  ; Have we drawn the bottom pixel row in this pair of
  AND $07                 ; cells yet?
  JR NZ,DRWFIX_3          ; Jump if not
  LD A,H                  ; Otherwise move HL to the top pixel row in the cell
  SUB $08                 ; below
  LD H,A
  LD A,L
  ADD A,$20
  LD L,A
  AND $E0                 ; Was the last pair of cells at y-coordinate 7 or 15?
  JR NZ,DRWFIX_3          ; Jump if not
  LD A,H                  ; Otherwise adjust HL to account for the movement
  ADD A,$08               ; from the top or middle third of the screen to the
  LD H,A                  ; next one down
DRWFIX_3:
  DJNZ DRWFIX_0           ; Jump back until all 16 rows of pixels have been
                          ; drawn
  XOR A                   ; Set the zero flag (to indicate no collision)
  RET

; Move to the next cavern
;
; Used by the routines at LOOP and CHKPORTAL.
NXSHEET:
  LD A,(SHEET)            ; Pick up the number of the current cavern from SHEET
  INC A                   ; Increment the cavern number
  CP $14                  ; Is the current cavern The Final Barrier?
  JR NZ,NXSHEET_3         ; Jump if not
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Are we in demo mode?
  JP NZ,NXSHEET_2         ; Jump if so
  LD A,(CHEAT)            ; Pick up the 6031769 key counter from CHEAT
  CP $07                  ; Is cheat mode activated?
  JR Z,NXSHEET_2          ; Jump if so
; Willy has made it through The Final Barrier without cheating.
  LD C,$00                ; Draw Willy at (2,19) on the ground above the portal
  LD DE,WILLYR3
  LD HL,$4053
  CALL DRWFIX
  LD DE,SWORDFISH         ; Draw the swordfish graphic (see SWORDFISH) over the
  LD HL,$40B3             ; portal
  CALL DRWFIX
  LD HL,$5853             ; Point HL at (2,19) in the attribute file
  LD DE,$001F             ; Prepare DE for addition
  LD (HL),$2F             ; Set the attributes for the upper half of Willy's
  INC HL                  ; sprite at (2,19) and (2,20) to 47 (INK 7: PAPER 5)
  LD (HL),$2F
  ADD HL,DE               ; Set the attributes for the lower half of Willy's
  LD (HL),$27             ; sprite at (3,19) and (3,20) to 39 (INK 7: PAPER 4)
  INC HL
  LD (HL),$27
  ADD HL,DE               ; Point HL at (5,19) in the attribute file
  INC HL
  ADD HL,DE
  LD (HL),$45             ; Set the attributes for the fish at (5,19) and
  INC HL                  ; (5,20) to 69 (INK 5: PAPER 0: BRIGHT 1)
  LD (HL),$45
  ADD HL,DE               ; Set the attribute for the handle of the sword at
  LD (HL),$46             ; (6,19) to 70 (INK 6: PAPER 0: BRIGHT 1)
  INC HL                  ; Set the attribute for the blade of the sword at
  LD (HL),$47             ; (6,20) to 71 (INK 7: PAPER 0: BRIGHT 1)
  ADD HL,DE               ; Set the attributes at (7,19) and (7,20) to 0 (to
  LD (HL),$00             ; hide Willy's feet just below where the portal was)
  INC HL
  LD (HL),$00
  LD BC,$0000             ; Prepare C and D for the celebratory sound effect
  LD D,$32
  XOR A                   ; A=0 (black border)
NXSHEET_0:
  OUT ($FE),A             ; Produce the celebratory sound effect: Willy has
  XOR $18                 ; escaped from the mine
  LD E,A
  LD A,C
  ADD A,D
  ADD A,D
  ADD A,D
  LD B,A
  LD A,E
NXSHEET_1:
  DJNZ NXSHEET_1
  DEC C
  JR NZ,NXSHEET_0
  DEC D
  JR NZ,NXSHEET_0
NXSHEET_2:
  XOR A                   ; A=0 (the next cavern will be Central Cavern)
NXSHEET_3:
  LD (SHEET),A            ; Update the cavern number at SHEET
; The next section of code cycles the INK and PAPER colours of the current
; cavern.
  LD A,$3F                ; Initialise A to 63 (INK 7: PAPER 7)
NXSHEET_4:
  LD HL,$5800             ; Set the attributes for the top two-thirds of the
  LD DE,$5801             ; screen to the value in A
  LD BC,$01FF
  LD (HL),A
  LDIR
  LD BC,$0004             ; Pause for about 0.004s
NXSHEET_5:
  DJNZ NXSHEET_5
  DEC C
  JR NZ,NXSHEET_5
  DEC A                   ; Decrement the attribute value in A
  JR NZ,NXSHEET_4         ; Jump back until we've gone through all attribute
                          ; values from 63 down to 1
  LD A,(DEMO)             ; Pick up the game mode indicator from DEMO
  OR A                    ; Are we in demo mode?
  JP NZ,NEWSHT            ; If so, demo the next cavern
; The following loop increases the score and decreases the air supply until it
; runs out.
NXSHEET_6:
  CALL DECAIR             ; Decrease the air remaining in the current cavern
  JP Z,NEWSHT             ; Move to the next cavern if the air supply is now
                          ; gone
  LD HL,$842E             ; Add 1 to the score
  CALL INCSCORE_0
  LD IX,SCORBUF           ; Print the new score at (19,26)
  LD C,$06
  LD DE,$507A
  CALL PMESS
  LD C,$04                ; C=4; this value determines the duration of the
                          ; sound effect
  LD A,(AIR)              ; Pick up the remaining air supply (S) from AIR
  CPL                     ; D=2*(63-S); this value determines the pitch of the
  AND $3F                 ; sound effect (which decreases with the amount of
  RLC A                   ; air remaining)
  LD D,A
NXSHEET_7:
  LD A,$00                ; Produce a short note
  OUT ($FE),A
  LD B,D
NXSHEET_8:
  DJNZ NXSHEET_8
  LD A,$18
  OUT ($FE),A
  LD B,D
NXSHEET_9:
  DJNZ NXSHEET_9
  DEC C
  JR NZ,NXSHEET_7
  JR NXSHEET_6            ; Jump back to decrease the air supply again

; Add to the score
;
; The entry point to this routine is at INCSCORE_0.
INCSCORE:
  LD (HL),$30             ; Roll the digit over from '9' to '0'
  DEC HL                  ; Point HL at the next digit to the left
  LD A,L                  ; Is this the 10000s digit?
  CP $2A
  JR NZ,INCSCORE_0        ; Jump if not
; Willy has scored another 10000 points. Give him an extra life.
  LD A,$08                ; Set the screen flash counter at FLASH to 8
  LD (FLASH),A
  LD A,(NOMEN)            ; Increment the number of lives remaining at NOMEN
  INC A
  LD (NOMEN),A
; The entry point to this routine is here and is used by the routines at
; DRAWITEMS, NXSHEET and KONGBEAST with HL pointing at the digit of the score
; (see SCORBUF) to be incremented.
INCSCORE_0:
  LD A,(HL)               ; Pick up a digit of the score
  CP $39                  ; Is it '9'?
  JR Z,INCSCORE           ; Jump if so
  INC (HL)                ; Increment the digit
  RET

; Move the conveyor in the current cavern
;
; Used by the routine at LOOP.
MVCONVEYOR:
  LD HL,(CONVLOC)         ; Pick up the address of the conveyor's location in
                          ; the screen buffer at 28672 from CONVLOC
  LD E,L                  ; Copy this address to DE
  LD D,H
  LD A,(CONVLEN)          ; Pick up the length of the conveyor from CONVLEN
  LD B,A                  ; B will count the conveyor tiles
  LD A,(CONVDIR)          ; Pick up the direction of the conveyor from CONVDIR
  OR A                    ; Is the conveyor moving right?
  JR NZ,MVCONVEYOR_1      ; Jump if so
; The conveyor is moving left.
  LD A,(HL)               ; Copy the first pixel row of the conveyor tile to A
  RLC A                   ; Rotate it left twice
  RLC A
  INC H                   ; Point HL at the third pixel row of the conveyor
  INC H                   ; tile
  LD C,(HL)               ; Copy this pixel row to C
  RRC C                   ; Rotate it right twice
  RRC C
MVCONVEYOR_0:
  LD (DE),A               ; Update the first and third pixel rows of every
  LD (HL),C               ; conveyor tile in the screen buffer at 28672
  INC L
  INC E
  DJNZ MVCONVEYOR_0
  RET
; The conveyor is moving right.
MVCONVEYOR_1:
  LD A,(HL)               ; Copy the first pixel row of the conveyor tile to A
  RRC A                   ; Rotate it right twice
  RRC A
  INC H                   ; Point HL at the third pixel row of the conveyor
  INC H                   ; tile
  LD C,(HL)               ; Copy this pixel row to C
  RLC C                   ; Rotate it left twice
  RLC C
  JR MVCONVEYOR_0         ; Jump back to update the first and third pixel rows
                          ; of every conveyor tile

; Move and draw the Kong Beast in the current cavern
;
; Used by the routine at LOOP.
KONGBEAST:
  LD HL,$5C06             ; Flip the left-hand switch at (0,6) if Willy is
  CALL CHKSWITCH          ; touching it
  LD A,(EUGDIR)           ; Pick up the Kong Beast's status from EUGDIR
  CP $02                  ; Is the Kong Beast already dead?
  RET Z                   ; Return if so
  LD A,($7506)            ; Pick up the sixth pixel row of the left-hand switch
                          ; from the screen buffer at 28672
  CP $10                  ; Has the switch been flipped?
  JP Z,KONGBEAST_8        ; Jump if not
; The left-hand switch has been flipped. Deal with opening up the wall if that
; is still in progress.
  LD A,($5F71)            ; Pick up the attribute byte of the tile at (11,17)
                          ; in the buffer at 24064
  OR A                    ; Has the wall there been removed yet?
  JR Z,KONGBEAST_2        ; Jump if so
  LD HL,$7F71             ; Point HL at the bottom row of pixels of the wall
                          ; tile at (11,17) in the screen buffer at 28672
KONGBEAST_0:
  LD A,(HL)               ; Pick up a pixel row
  OR A                    ; Is it blank yet?
  JR NZ,KONGBEAST_1       ; Jump if not
  DEC H                   ; Point HL at the next pixel row up
  LD A,H                  ; Have we checked all 8 pixel rows yet?
  CP $77
  JR NZ,KONGBEAST_0       ; If not, jump back to check the next one
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  LD ($5F71),A            ; Change the attributes at (11,17) and (12,17) in the
  LD ($5F91),A            ; buffer at 24064 to match the background tile (the
                          ; wall there is now gone)
  LD A,$72                ; Update the seventh byte of the guardian definition
  LD ($80CB),A            ; at HGUARD2 so that the guardian moves through the
                          ; opening in the wall
  JR KONGBEAST_2
KONGBEAST_1:
  LD (HL),$00             ; Clear a pixel row of the wall tile at (11,17) in
                          ; the screen buffer at 28672
  LD L,$91                ; Point HL at the opposite pixel row of the wall tile
  LD A,H                  ; one cell down at (12,17)
  XOR $07
  LD H,A
  LD (HL),$00             ; Clear that pixel row as well
; Now check the right-hand switch.
KONGBEAST_2:
  LD HL,$5C12             ; Flip the right-hand switch at (0,18) if Willy is
  CALL CHKSWITCH          ; touching it (and it hasn't already been flipped)
  JR NZ,KONGBEAST_4       ; Jump if the switch was not flipped
  XOR A                   ; Initialise the Kong Beast's pixel y-coordinate at
  LD (EUGHGT),A           ; EUGHGT to 0
  INC A                   ; Update the Kong Beast's status at EUGDIR to 1: he
  LD (EUGDIR),A           ; is falling
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  LD ($5E4F),A            ; Change the attributes of the floor beneath the Kong
  LD ($5E50),A            ; Beast in the buffer at 24064 to match that of the
                          ; background tile
  LD HL,$704F             ; Point HL at (2,15) in the screen buffer at 28672
  LD B,$08                ; Clear the cells at (2,15) and (2,16), removing the
KONGBEAST_3:
  LD (HL),$00             ; floor beneath the Kong Beast
  INC L
  LD (HL),$00
  DEC L
  INC H
  DJNZ KONGBEAST_3
KONGBEAST_4:
  LD A,(EUGDIR)           ; Pick up the Kong Beast's status from EUGDIR
  OR A                    ; Is the Kong Beast still on the ledge?
  JR Z,KONGBEAST_8        ; Jump if so
; The Kong Beast is falling.
  LD A,(EUGHGT)           ; Pick up the Kong Beast's pixel y-coordinate from
                          ; EUGHGT
  CP $64                  ; Has he fallen into the portal yet?
  JR Z,KONGBEAST_7        ; Jump if so
  ADD A,$04               ; Add 4 to the Kong Beast's pixel y-coordinate at
  LD (EUGHGT),A           ; EUGHGT (moving him downwards)
  LD C,A                  ; Copy the pixel y-coordinate to C; this value
                          ; determines the pitch of the sound effect
  LD D,$10                ; D=16; this value determines the duration of the
                          ; sound effect
  LD A,(BORDER)           ; Pick up the border colour for the current cavern
                          ; from BORDER
KONGBEAST_5:
  OUT ($FE),A             ; Make a falling sound effect
  XOR $18
  LD B,C
KONGBEAST_6:
  DJNZ KONGBEAST_6
  DEC D
  JR NZ,KONGBEAST_5
  LD A,C                  ; Copy the Kong Beast's pixel y-coordinate back into
                          ; A
  RLCA                    ; Point DE at the entry in the screen buffer address
  LD E,A                  ; lookup table at SBUFADDRS that corresponds to the
  LD D,$83                ; Kong Beast's pixel y-coordinate
  LD A,(DE)               ; Point HL at the address of the Kong Beast's
  OR $0F                  ; location in the screen buffer at 24576
  LD L,A
  INC DE
  LD A,(DE)
  LD H,A
  LD D,$81                ; Use bit 5 of the value of the game clock at CLOCK
  LD A,(CLOCK)            ; (which is toggled once every eight passes through
  AND $20                 ; the main loop) to point DE at the graphic data for
  OR $40                  ; the appropriate Kong Beast sprite
  LD E,A
  LD C,$00                ; Draw the Kong Beast to the screen buffer at 24576
  CALL DRWFIX
  LD HL,$842C             ; Add 100 to the score
  CALL INCSCORE_0
  LD A,(EUGHGT)           ; Pick up the Kong Beast's pixel y-coordinate from
                          ; EUGHGT
  AND $78                 ; Point HL at the address of the Kong Beast's
  LD L,A                  ; location in the attribute buffer at 23552
  LD H,$17
  ADD HL,HL
  ADD HL,HL
  LD A,L
  OR $0F
  LD L,A
  LD A,$06                ; The Kong Beast is drawn with yellow INK
  JP EUGENE_3             ; Set the attribute bytes for the Kong Beast
; The Kong Beast has fallen into the portal.
KONGBEAST_7:
  LD A,$02                ; Set the Kong Beast's status at EUGDIR to 2: he is
  LD (EUGDIR),A           ; dead
  RET
; The Kong Beast is still on the ledge.
KONGBEAST_8:
  LD A,(CLOCK)            ; Pick up the value of the game clock at CLOCK
  AND $20                 ; Use bit 5 of this value (which is toggled once
  LD E,A                  ; every eight passes through the main loop) to point
  LD D,$81                ; DE at the graphic data for the appropriate Kong
                          ; Beast sprite
  LD HL,$600F             ; Draw the Kong Beast at (0,15) in the screen buffer
  LD C,$01                ; at 24576
  CALL DRWFIX
  JP NZ,KILLWILLY_0       ; Kill Willy if he collided with the Kong Beast
  LD A,$44                ; A=68 (INK 4: PAPER 0: BRIGHT 1)
  LD ($5C2F),A            ; Set the attribute bytes for the Kong Beast in the
  LD ($5C30),A            ; buffer at 23552
  LD ($5C0F),A
  LD ($5C10),A
  RET

; Flip a switch in a Kong Beast cavern if Willy is touching it
;
; Used by the routine at KONGBEAST. Returns with the zero flag set if Willy
; flips the switch.
;
; HL Address of the switch's location in the attribute buffer at 23552
CHKSWITCH:
  LD A,(LOCATION)         ; Pick up the LSB of the address of Willy's location
                          ; in the attribute buffer at 23552 from LOCATION
  INC A                   ; Is it equal to or one less than the LSB of the
  AND $FE                 ; address of the switch's location?
  CP L
  RET NZ                  ; Return (with the zero flag reset) if not
  LD A,($806D)            ; Pick up the MSB of the address of Willy's location
                          ; in the attribute buffer at 23552 from 806D
  CP H                    ; Does it match the MSB of the address of the
                          ; switch's location?
  RET NZ                  ; Return (with the zero flag reset) if not
  LD A,($8065)            ; Pick up the sixth byte of the graphic data for the
                          ; switch tile from 8065
  LD H,$75                ; Point HL at the sixth row of pixels of the switch
                          ; tile in the screen buffer at 28672
  CP (HL)                 ; Has the switch already been flipped?
  RET NZ                  ; Return (with the zero flag reset) if so
; Willy is flipping the switch.
  LD (HL),$08             ; Update the sixth, seventh and eighth rows of pixels
  INC H                   ; of the switch tile in the screen buffer at 28672 to
  LD (HL),$06             ; make it appear flipped
  INC H
  LD (HL),$06
  XOR A                   ; Set the zero flag: Willy has flipped the switch
  OR A                    ; This instruction is redundant
  RET

; Check and set the attribute bytes for Willy's sprite in the buffer at 5C00
;
; Used by the routine at LOOP.
WILLYATTRS:
  LD HL,(LOCATION)        ; Pick up the address of Willy's location in the
                          ; attribute buffer at 23552 from LOCATION
  LD DE,$001F             ; Prepare DE for addition
  LD C,$0F                ; Set C=15 for the top two rows of cells (to make the
                          ; routine at WILLYATTR force white INK)
  CALL WILLYATTR          ; Check and set the attribute byte for the top-left
                          ; cell
  INC HL                  ; Move HL to the next cell to the right
  CALL WILLYATTR          ; Check and set the attribute byte for the top-right
                          ; cell
  ADD HL,DE               ; Move HL down a row and back one cell to the left
  CALL WILLYATTR          ; Check and set the attribute byte for the mid-left
                          ; cell
  INC HL                  ; Move HL to the next cell to the right
  CALL WILLYATTR          ; Check and set the attribute byte for the mid-right
                          ; cell
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  LD C,A                  ; Copy it to C
  ADD HL,DE               ; Move HL down a row and back one cell to the left
  CALL WILLYATTR          ; Check and set the attribute byte for the
                          ; bottom-left cell
  INC HL                  ; Move HL to the next cell to the right
  CALL WILLYATTR          ; Check and set the attribute byte for the
                          ; bottom-right cell
  JR DRAWWILLY            ; Draw Willy to the screen buffer at 24576

; Check and set the attribute byte for a cell occupied by Willy's sprite
;
; Used by the routine at WILLYATTRS.
;
; C 15 or Willy's pixel y-coordinate
; HL Address of the cell in the attribute buffer at 23552
WILLYATTR:
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  CP (HL)                 ; Does this cell contain a background tile?
  JR NZ,WILLYATTR_0       ; Jump if not
  LD A,C                  ; Set the zero flag if we are going to retain the INK
  AND $0F                 ; colour in this cell; this happens only if the cell
                          ; is in the bottom row and Willy's sprite is confined
                          ; to the top two rows
  JR Z,WILLYATTR_0        ; Jump if we are going to retain the current INK
                          ; colour in this cell
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current cavern from BACKGROUND
  OR $07                  ; Set bits 0-2, making the INK white
  LD (HL),A               ; Set the attribute byte for this cell in the buffer
                          ; at 23552
WILLYATTR_0:
  LD A,(NASTY1)           ; Pick up the attribute byte of the first nasty tile
                          ; for the current cavern from NASTY1
  CP (HL)                 ; Has Willy hit a nasty of the first kind?
  JP Z,KILLWILLY          ; Kill Willy if so
  LD A,(NASTY2)           ; Pick up the attribute byte of the second nasty tile
                          ; for the current cavern from NASTY2
  CP (HL)                 ; Has Willy hit a nasty of the second kind?
  JP Z,KILLWILLY          ; Kill Willy if so
  RET

; Draw Willy to the screen buffer at 6000
;
; Used by the routine at WILLYATTRS.
DRAWWILLY:
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  LD IXh,$83              ; Point IX at the entry in the screen buffer address
  LD IXl,A                ; lookup table at SBUFADDRS that corresponds to
                          ; Willy's y-coordinate
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  AND $01                 ; Now E=0 if Willy is facing right, or 128 if he's
  RRCA                    ; facing left
  LD E,A
  LD A,(FRAME)            ; Pick up Willy's animation frame (0-3) from FRAME
  AND $03                 ; Point DE at the sprite graphic data for Willy's
  RRCA                    ; current animation frame (see MANDAT)
  RRCA
  RRCA
  OR E
  LD E,A
  LD D,$82
  LD B,$10                ; There are 16 rows of pixels to copy
  LD A,(LOCATION)         ; Pick up Willy's screen x-coordinate (0-31) from
  AND $1F                 ; LOCATION
  LD C,A                  ; Copy it to C
DRAWWILLY_0:
  LD A,(IX+$00)           ; Set HL to the address in the screen buffer at 24576
  LD H,(IX+$01)           ; that corresponds to where we are going to draw the
  OR C                    ; next pixel row of the sprite graphic
  LD L,A
  LD A,(DE)               ; Pick up a sprite graphic byte
  OR (HL)                 ; Merge it with the background
  LD (HL),A               ; Save the resultant byte to the screen buffer
  INC HL                  ; Move HL along to the next cell to the right
  INC DE                  ; Point DE at the next sprite graphic byte
  LD A,(DE)               ; Pick it up in A
  OR (HL)                 ; Merge it with the background
  LD (HL),A               ; Save the resultant byte to the screen buffer
  INC IX                  ; Point IX at the next entry in the screen buffer
  INC IX                  ; address lookup table at SBUFADDRS
  INC DE                  ; Point DE at the next sprite graphic byte
  DJNZ DRAWWILLY_0        ; Jump back until all 16 rows of pixels have been
                          ; drawn
  RET

; Print a message
;
; Used by the routines at START, STARTGAME, LOOP, ENDGAM and NXSHEET.
;
; IX Address of the message
; C Length of the message
; DE Display file address
PMESS:
  LD A,(IX+$00)           ; Collect a character from the message
  CALL PRINTCHAR          ; Print it
  INC IX                  ; Point IX at the next character in the message
  INC E                   ; Point DE at the next character cell (subtracting 8
  LD A,D                  ; from D compensates for the operations performed by
  SUB $08                 ; the routine at PRINTCHAR)
  LD D,A
  DEC C                   ; Have we printed the entire message yet?
  JR NZ,PMESS             ; If not, jump back to print the next character
  RET

; Print a single character
;
; Used by the routine at PMESS.
;
; A ASCII code of the character
; DE Display file address
PRINTCHAR:
  LD H,$07                ; Point HL at the bitmap for the character (in the
  LD L,A                  ; ROM)
  SET 7,L
  ADD HL,HL
  ADD HL,HL
  ADD HL,HL
  LD B,$08                ; There are eight pixel rows in a character bitmap
; This entry point is used by the routine at DRAWITEMS to draw an item in the
; current cavern.
PRINTCHAR_0:
  LD A,(HL)               ; Copy the character bitmap to the screen (or item
  LD (DE),A               ; graphic to the screen buffer)
  INC HL
  INC D
  DJNZ PRINTCHAR_0
  RET

; Play the theme tune (The Blue Danube)
;
; Used by the routine at START. Returns with the zero flag reset if ENTER or
; the fire button is pressed while the tune is being played.
;
; IY THEMETUNE (tune data)
PLAYTUNE:
  LD A,(IY+$00)           ; Pick up the next byte of tune data from the table
                          ; at THEMETUNE
  CP $FF                  ; Has the tune finished?
  RET Z                   ; Return (with the zero flag set) if so
  LD C,A                  ; Copy the first byte of data for this note (which
                          ; determines the duration) to C
  LD B,$00                ; Initialise B, which will be used as a delay counter
                          ; in the note-producing loop
  XOR A                   ; Set A=0 (for no apparent reasaon)
  LD D,(IY+$01)           ; Pick up the second byte of data for this note
  LD A,D                  ; Copy it to A
  CALL PIANOKEY           ; Calculate the attribute file address for the
                          ; corresponding piano key
  LD (HL),$50             ; Set the attribute byte for the piano key to 80 (INK
                          ; 0: PAPER 2: BRIGHT 1)
  LD E,(IY+$02)           ; Pick up the third byte of data for this note
  LD A,E                  ; Copy it to A
  CALL PIANOKEY           ; Calculate the attribute file address for the
                          ; corresponding piano key
  LD (HL),$28             ; Set the attribute byte for the piano key to 40 (INK
                          ; 0: PAPER 5: BRIGHT 0)
PLAYTUNE_0:
  OUT ($FE),A             ; Produce a sound based on the frequency parameters
  DEC D                   ; in the second and third bytes of data for this note
  JR NZ,PLAYTUNE_1        ; (copied into D and E)
  LD D,(IY+$01)
  XOR $18
PLAYTUNE_1:
  DEC E
  JR NZ,PLAYTUNE_2
  LD E,(IY+$02)
  XOR $18
PLAYTUNE_2:
  DJNZ PLAYTUNE_0
  DEC C
  JR NZ,PLAYTUNE_0
  CALL CHECKENTER         ; Check whether ENTER or the fire button is being
                          ; pressed
  RET NZ                  ; Return (with the zero flag reset) if it is
  LD A,(IY+$01)           ; Pick up the second byte of data for this note
  CALL PIANOKEY           ; Calculate the attribute file address for the
                          ; corresponding piano key
  LD (HL),$38             ; Set the attribute byte for the piano key back to 56
                          ; (INK 0: PAPER 7: BRIGHT 0)
  LD A,(IY+$02)           ; Pick up the third byte of data for this note
  CALL PIANOKEY           ; Calculate the attribute file address for the
                          ; corresponding piano key
  LD (HL),$38             ; Set the attribute byte for the piano key back to 56
                          ; (INK 0: PAPER 7: BRIGHT 0)
  INC IY                  ; Move IY along to the data for the next note in the
  INC IY                  ; tune
  INC IY
  JR PLAYTUNE             ; Jump back to play the next note

; Calculate the attribute file address for a piano key
;
; Used by the routine at PLAYTUNE. Returns with the attribute file address in
; HL.
;
; A Frequency parameter from the tune data table at THEMETUNE
PIANOKEY:
  SUB $08                 ; Compute the piano key index (K) based on the
  RRCA                    ; frequency parameter (F), and store it in bits 0-4
  RRCA                    ; of A: K=31-INT((F-8)/8)
  RRCA
  CPL
  OR $E0                  ; A=224+K; this is the LSB
  LD L,A                  ; Set HL to the attribute file address for the piano
  LD H,$59                ; key
  RET

; Check whether ENTER or the fire button is being pressed
;
; Used by the routine at PLAYTUNE. Returns with the zero flag reset if ENTER or
; the fire button on the joystick is being pressed.
CHECKENTER:
  LD A,(KEMP)             ; Pick up the Kempston joystick indicator from KEMP
  OR A                    ; Is the joystick connected?
  JR Z,CHECKENTER_0       ; Jump if not
  IN A,($1F)              ; Collect input from the joystick
  BIT 4,A                 ; Is the fire button being pressed?
  RET NZ                  ; Return (with the zero flag reset) if so
CHECKENTER_0:
  LD BC,$BFFE             ; Read keys H-J-K-L-ENTER
  IN A,(C)
  AND $01                 ; Keep only bit 0 of the result (ENTER)
  CP $01                  ; Reset the zero flag if ENTER is being pressed
  RET

; Source code remnants
;
; The source code here corresponds to the code at SEE37708.
SOURCE:
  DEFM $09,"DEC",$09,"E"  ; DEC E
  DEFW $0F78              ; 3960 JR NZ,NOFLP6
  DEFB $0D
  DEFM $09,"JR",$09,"NZ,NOFLP6"
  DEFW $0F82              ; 3970 LD E,(HL)
  DEFB $0A
  DEFM $09,"LD",$09,"E,(HL)"
  DEFW $0F8C              ; 3980 XOR 24
  DEFB $07
  DEFM $09,"XOR",$09,"24"
  DEFW $0F96              ; 3990 NOFLP6 DJNZ TM51
  DEFB $10
  DEFM "NOFLP6",$09,"DJNZ",$09,"TM51"
  DEFW $0FA0              ; 4000 DEC C
  DEFB $06
  DEFM $09,"DEC",$09,"C"
  DEFW $0FAA              ; 4010 JR NZ,TM51
  DEFB $0B
  DEFM $09,"JR",$09,"NZ,TM51"
  DEFW $0FB4              ; 4020 NONOTE4 LD A,(DEMO)
  DEFB $13
  DEFM "NONOTE4",$09,"LD",$09,"A,(DEMO)"
  DEFW $0FBE              ; 4030 OR A
  DEFB $05
  DEFM $09,"OR",$09,"A"
  DEFW $0FC8              ; 4040 JR Z,NODEM1
  DEFB $0C
  DEFM $09,"JR",$09,"Z,NODEM1"
  DEFW $0FD2              ; 4050 DEC A
  DEFB $06
  DEFM $09,"DEC",$09,"A"
  DEFW $0FDC              ; 4060 JP Z,MANDEAD
  DEFB $0D
  DEFM $09,"JP",$09,"Z,MANDEAD"
  DEFW $0FE6              ; 4070 LD (DEMO),A
  DEFB $0C
  DEFM $09,"LD",$09,"(DEMO),A"
  DEFW $0FF0              ; 4080 LD BC,0FEH
  DEFB $0B
  DEFM $09,"LD",$09,"BC,0FEH"
  DEFW $0FFA              ; 4090 IN A,(C)
  DEFB $09
  DEFM $09,"IN",$09,"A,(C)"
  DEFW $1004              ; 4100 AND 31
  DEFB $07
  DEFM $09,"AND",$09,"31"
  DEFW $100E              ; 4110 CP 31
  DEFB $06
  DEFM $09,"CP",$09,"31"
  DEFW $1018              ; 4120 JP NZ,START
  DEFB $0C
  DEFM $09,"JP",$09,"NZ,START"
  DEFW $1022              ; 4130 LD A,(KEMP)
  DEFB $0C
  DEFM $09,"LD",$09,"A,(KEMP)"
  DEFW $102C              ; 4140 OR A
  DEFB $05
  DEFM $09,"OR",$09,"A"
  DEFW $1036              ; 4150 JR Z,NODEM1
  DEFB $0C
  DEFM $09,"JR",$09,"Z,NODEM1"
  DEFW $1040              ; 4160 IN A,(31)
  DEFB $0A
  DEFM $09,"IN",$09,"A,(31)"
  DEFW $104A              ; 4170 OR A
  DEFB $05
  DEFM $09,"OR",$09,"A"
  DEFW $1054              ; 4180 JP NZ,START
  DEFB $0C
  DEFM $09,"JP",$09,"NZ,START"
  DEFW $105E              ; 4190 NODEM1 LD BC,0EFFEH
  DEFB $13
  DEFM "NODEM1",$09,"LD",$09,"BC,0EFFEH"
  DEFW $1068              ; 4200 IN A,(C)
  DEFB $09
  DEFM $09,"IN",$09,"A,(C)"
  DEFW $1072              ; 4210 BIT 4,A
  DEFB $08
  DEFM $09,"BIT",$09,"4,A"
  DEFW $107C              ; 4220 JP NZ,CKCHEAT
  DEFB $0E
  DEFM $09,"JP",$09,"NZ,CKCHEAT"
  DEFW $1086              ; 4230 LD A,(CHEAT)
  DEFB $0D
  DEFM $09,"LD",$09,"A,(CHEAT)"
  DEFW $1090              ; 4240 CP 7
  DEFB $05
  DEFM $09,"CP",$09,"7"
  DEFW $109A              ; 4250 JP NZ,CKCHEAT
  DEFB $0E
  DEFM $09,"JP",$09,"NZ,CKCHEAT"
  DEFW $10A4              ; 4260 LD B,0F7H
  DEFB $0A
  DEFM $09,"LD",$09,"B,0F7H"
  DEFW $10AE              ; 4270 IN A,(C)
  DEFB $09
  DEFM $09,"IN",$09,"A,(C)"
  DEFW $10B8              ; 4280 CPL
  DEFB $04
  DEFM $09,"CPL"
  DEFW $10C2              ; 4290 AND 31
  DEFB $07
  DEFM $09,"AND",$09,"31"
  DEFW $10CC              ; 4300 CP 20
  DEFB $06
  DEFM $09,"CP",$09,"20"
  DEFW $10D6              ; 4310 JP NC,CKCHEAT
  DEFB $0E
  DEFM $09,"JP",$09,"NC,CKCHEAT"
  DEFW $10E0              ; 4320 LD (SHEET),A
  DEFB $0D
  DEFM $09,"LD",$09,"(SHEET),A"
  DEFW $10EA              ; 4330 JP NEWSHT
  DEFB $0A
  DEFM $09,"JP",$09,"NEWSHT"
  DEFW $10F4              ; 4340 CKCHEAT LD A,(CHEAT)
  DEFB $14
  DEFM "CKCHEAT",$09,"LD",$09,"A,(CHEAT)"
  DEFW $10FE              ; 4350 CP 7
  DEFB $05
  DEFM $09,"CP",$09,"7"
  DEFW $1108              ; 4360 JP Z,LOOP
  DEFB $0A
  DEFM $09,"JP",$09,"Z,LOOP"
  DEFW $1112              ; 4370 RLCA
  DEFB $05
  DEFM $09,"RLCA"
  DEFW $111C              ; 4380 LD E,A
  DEFB $07
  DEFM $09,"LD",$09,"E,A"
  DEFW $1126              ; 4390 LD D,0
  DEFB $07
  DEFM $09,"LD",$09,"D,0"
  DEFW $1130              ; 4400 LD IX,CHEATDT
  DEFB $0E
  DEFM $09,"LD",$09,"IX,CHEATDT"
  DEFW $113A              ; 4410 ADD IX,DE
  DEFB $0A
  DEFM $09,"ADD",$09,"IX,DE"
  DEFW $1144              ; 4420 LD BC,0F7FEH
  DEFB $0D
  DEFM $09,"LD",$09,"BC,0F7FEH"
  DEFW $114E              ; 4430 IN A,(C)
  DEFB $09
  DEFM $09,"IN",$09,"A,(C)"
  DEFW $1158              ; 4440 AND 31
  DEFB $07
  DEFM $09,"AND",$09,"31"
  DEFW $1162              ; 4450 CP (IX+0)
  DEFB $0A
  DEFM $09,"CP",$09,"(IX+0)"
  DEFW $116C              ; 4460 JR Z,CKNXCHT
  DEFB $0D
  DEFM $09,"JR",$09,"Z,CKNXCHT"
  DEFW $1176              ; 4470 CP 31
  DEFB $06
  DEFM $09,"CP",$09,"31"
  DEFW $1180              ; 4480 JP Z,LOOP
  DEFB $0A
  DEFM $09,"JP",$09,"Z,LOOP"
  DEFW $118A              ; 4490 CP (IX-2)
  DEFB $0A
  DEFM $09,"CP",$09,"(IX-2)"
  DEFW $1194              ; 4500 JP Z,LOOP
  DEFB $0A
  DEFM $09,"JP",$09,"Z,LOOP"
  DEFW $119E              ; 4510 XOR A
  DEFB $06
  DEFM $09,"XOR",$09,"A"
  DEFW $11A8              ; 4520 LD (CHEAT),A
  DEFB $0D
  DEFM $09,"LD",$09,"(CHEAT),A"
  DEFW $11B2              ; 4530 JP LOOP
  DEFB $08
  DEFM $09,"JP",$09,"LOOP"
  DEFW $11BC              ; 4540 CKNXCHT LD B,0EFH
  DEFB $11
  DEFM "CKNXCHT",$09,"LD",$09,"B,0EFH"
  DEFW $11C6              ; 4550 IN A,(C)
  DEFB $09
  DEFM $09,"IN",$09,"A,(C)"
  DEFW $11D0              ; 4560 AND 31
  DEFB $07
  DEFM $09,"AND",$09,"31"
  DEFW $11DA              ; 4570 CP (IX+1)
  DEFB $0A
  DEFM $09,"CP",$09,"(IX+1)"
  DEFW $11E4              ; 4580 JR Z,INCCHT
  DEFB $0C
  DEFM $09,"JR",$09,"Z,INCCHT"
  DEFW $11EE              ; 4590 CP 31
  DEFB $06
  DEFM $09,"CP",$09,"31"
  DEFW $11F8              ; 4600 JP Z,LOOP
  DEFB $0A
  DEFM $09,"JP",$09,"Z,LOOP"
  DEFW $1202              ; 4610 CP (IX-1)
  DEFB $0A
  DEFM $09,"CP",$09,"(IX-1)"
  DEFW $120C              ; 4620 JP Z,LOOP
  DEFB $0A
  DEFM $09,"JP",$09,"Z,LOOP"
  DEFW $1216              ; 4630 XOR A
  DEFB $06
  DEFM $09,"XOR",$09,"A"
  DEFW $1220              ; 4640 LD (CHEAT),A
  DEFB $0D
  DEFM $09,"LD",$09,"(CHEAT),A"
  DEFW $122A              ; 4650 JP LOOP
  DEFB $08
  DEFM $09,"JP",$09,"LOOP"
  DEFW $1234              ; 4660 INCCHT LD A,(CHEAT)
  DEFB $13
  DEFM "INCCHT",$09,"LD",$09,"A,(CHEAT)"
  DEFW $123E              ; 4670 INC A
  DEFB $06
  DEFM $09,"INC",$09,"A"
  DEFW $1248              ; 4680 LD (CHEAT),A
  DEFB $0D
  DEFM $09,"LD",$09,"(CHEAT),A"
  DEFW $1252              ; 4690 JP LOOP
  DEFB $08
  DEFM $09,"JP",$09,"LOOP"
  DEFW $125C              ; 4700 MANDEAD LD A,(DEMO)
  DEFB $13
  DEFM "MANDEAD",$09,"LD",$09,"A,(DEMO)"
  DEFW $1266              ; 4710 OR A
  DEFB $05
  DEFM $09,"OR",$09,"A"
  DEFW $1270              ; 4720 JP NZ,NXSHEET
  DEFB $0E
  DEFM $09,"JP",$09,"NZ,NXSHEET"
  DEFW $127A              ; 4730 LD A,47H
  DEFB $09
  DEFM $09,"LD",$09,"A,47H"
  DEFW $1284              ; 4740 LPDEAD1 LD HL,5800H
  DEFB $13
  DEFM "LPDEAD1",$09,"LD",$09,"HL,5800H"
  DEFW $128E              ; 4750 LD DE,5801H
  DEFB $0C
  DEFM $09,"LD",$09,"DE,5801H"
  DEFW $1298              ; 4760 LD BC,1FFH
  DEFB $0B
  DEFM $09,"LD",$09,"BC,1FFH"
  DEFW $12A2              ; 4770 LD (HL),A
  DEFB $0A
  DEFM $09,"LD",$09,"(HL),A"
  DEFW $12AC              ; 4780 LDIR
  DEFB $05
  DEFM $09,"LDIR"
  DEFW $12B6              ; 4790 LD E,A
  DEFB $07
  DEFM $09,"LD",$09,"E,A"
  DEFW $12C0              ; 4800 CPL
  DEFB $04
  DEFM $09,"CPL"
  DEFW $12CA              ; 4810 AND 7
  DEFB $06
  DEFM $09,"AND",$09,"7"
  DEFW $12D4              ; 4820 RLCA
  DEFB $05
  DEFM $09,"RLCA"
  DEFW $12DE              ; 4830 RLCA
  DEFB $05
  DEFM $09,"RLCA"
  DEFW $12E8              ; 4840 RLCA
  DEFB $05
  DEFM $09,"RLCA"
  DEFW $12F2              ; 4850 OR 7
  DEFB $05
  DEFM $09,"OR",$09,"7"
  DEFW $12FC              ; 4860 LD D,A
  DEFB $07
  DEFM $09,"LD",$09,"D,A"
  DEFW $1306              ; 4870 LD C,E
  DEFB $07
  DEFM $09,"LD",$09,"C,E"
  DEFW $1310              ; 4880 RRC C
  DEFB $06
  DEFM $09,"RRC",$09,"C"
  DEFW $131A              ; 4890 RRC C
  DEFB $06
  DEFM $09,"RRC",$09,"C"
  DEFW $1324              ; 4900 RRC C
  DEFB $06
  DEFM $09,"RRC",$09,"C"
  DEFW $132E              ; 4910 OR 16
  DEFB $06
  DEFM $09,"OR",$09,"16"
  DEFW $1338              ; 4920 XOR A
  DEFB $06
  DEFM $09,"XOR",$09,"A"
  DEFW $1342              ; 4930 TM21 OUT (254),A
  DEFB $10
  DEFM "TM21",$09,"OUT",$09,"(254),A"
  DEFW $134C              ; 4940 XOR 24
  DEFB $07
  DEFM $09,"XOR",$09,"24"
  DEFW $1356              ; 4950 LD B,D
  DEFB $07
  DEFM $09,"LD",$09,"B,D"
  DEFW $1360              ; 4960 TM22 DJNZ TM22
  DEFB $0E
  DEFM "TM22",$09,"DJNZ",$09,"TM22"
  DEFW $136A              ; 4970 DEC C
  DEFB $06
  DEFM $09,"DEC",$09,"C"
  DEFW $1374              ; 4980 JR NZ,TM21
  DEFB $0B
  DEFM $09,"JR",$09,"NZ,TM21"
  DEFW $137E              ; 4990 LD A,E
  DEFB $07
  DEFM $09,"LD",$09,"A,E"
  DEFW $1388              ; 5000 DEC A
  DEFB $06
  DEFM $09,"DEC",$09,"A"
  DEFW $1392              ; 5010 CP 3FH
  DEFB $07
  DEFM $09,"CP",$09,"3FH"
  DEFW $139C              ; 5020 JR NZ,LPDEAD1
  DEFB $0E
  DEFM $09,"JR",$09,"NZ,LPDEAD1"
  DEFW $13A6              ; 5030 LD HL,NOMEN
  DEFB $0C
  DEFM $09,"LD",$09,"HL,NOMEN"
  DEFW $13B0              ; 5040 LD A,(HL)
  DEFB $0A
  DEFM $09,"LD",$09,"A,(HL)"
  DEFW $13BA              ; 5050 OR A
  DEFB $05
  DEFM $09,"OR",$09,"A"
  DEFW $13C4              ; 5060 JP Z,ENDGAM
  DEFB $0C
  DEFM $09,"JP",$09,"Z,ENDGAM"
  DEFW $13CE              ; 5070 DEC (HL)
  DEFB $09
  DEFM $09,"DEC",$09,"(HL)"
  DEFW $13D8              ; 5080 JP NEWSHT
  DEFB $0A
  DEFM $09,"JP",$09,"NEWSHT"
  DEFW $13E2              ; 5090 ENDGAM LD HL,HGHSCOR
  DEFB $14
  DEFM "ENDGAM",$09,"LD",$09,"HL,HGHSCOR"
  DEFW $13EC              ; 5100 LD DE,SCORBUF
  DEFB $0E
  DEFM $09,"LD",$09,"DE,SCORBUF"
  DEFW $13F6              ; 5110 LD B,6
  DEFB $07
  DEFM $09,"LD",$09,"B,6"
  DEFW $1400              ; 5120 LPHGH LD A,(DE)
  DEFB $0F
  DEFM "LPHGH",$09,"LD",$09,"A,(DE)"
  DEFW $140A              ; 5130 CP (HL)
  DEFB $08
  DEFM $09,"CP",$09,"(HL)"
  DEFW $1414              ; 5140 JP C,FEET
  DEFB $0A
  DEFM $09,"JP",$09,"C,FEET"
  DEFW $141E              ; 5150 JP NZ,NEWHGH
  DEFB $0D
  DEFM $09,"JP",$09,"NZ,NEWHGH"
  DEFW $1428              ; 5160 INC HL
  DEFB $07
  DEFM $09,"INC",$09,"HL"
  DEFW $1432              ; 5170 INC DE
  DEFB $07
  DEFM $09,"INC",$09,"DE"
  DEFW $143C              ; 5180 DJNZ LPHGH
  DEFB $0B
  DEFM $09,"DJNZ",$09,"LPHGH"
  DEFW $1446              ; 5190 NEWHGH LD HL,SCORBUF
  DEFB $14
  DEFM "NEWHGH",$09,"LD",$09,"HL,SCORBUF"
  DEFW $1450              ; 5200 LD DE,HGHSCOR
  DEFB $0E
  DEFM $09,"LD",$09,"DE,HGHSCOR"
  DEFW $145A              ; 5210 LD BC,6
  DEFB $08
  DEFM $09,"LD",$09,"BC,6"
  DEFW $1464              ; 5220 LDIR
  DEFB $05
  DEFM $09,"LDIR"
  DEFW $146E              ; 5230 FEET LD HL,4000H
  DEFB $10
  DEFM "FEET",$09,"LD",$09,"HL,4000H"
  DEFW $1478              ; 5240 LD DE,4001H
  DEFB $0C
  DEFM $09,"LD",$09,"DE,4001H"
  DEFW $1482              ; 5250 LD BC,0FFFH
  DEFB $0C
  DEFM $09,"LD",$09,"BC,0FFFH"
  DEFW $148C              ; 5260 LD (HL),0
  DEFB $0A
  DEFM $09,"LD",$09,"(HL),0"
  DEFW $1496              ; 5270 LDIR
  DEFB $05
  DEFM $09,"LDIR"
  DEFW $14A0              ; 5280 XOR A
  DEFB $06
  DEFM $09,"XOR",$09,"A"
  DEFW $14AA              ; 5290 LD (EUGHGT),A
  DEFB $0E
  DEFM $09,"LD",$09,"(EUGHGT),A"
  DEFW $14B4              ; 5300 LD DE,MANDAT+64
  DEFB $10
  DEFM $09,"LD",$09,"DE,MANDAT+64"
  DEFW $14BE              ; 5310 LD HL,488FH
  DEFB $0C
  DEFM $09,"LD",$09,"HL,488FH"
  DEFW $14C8              ; 5320 LD C,0
  DEFB $07
  DEFM $09,"LD",$09,"C,0"
  DEFW $14D2              ; 5330 CALL DRWFIX
  DEFB $0C
  DEFM $09,"CALL",$09,"DRWFIX"
  DEFW $14DC              ; 5340 LD DE,0B6E0H
  DEFB $0D
  DEFM $09,"LD",$09,"DE,0B6E0H"
  DEFW $14E6              ; 5350 LD HL,48CFH
  DEFB $0C
  DEFM $09,"LD",$09,"HL,48CFH"
  DEFW $14F0              ; 5360 LD C,0
  DEFB $07
  DEFM $09,"LD",$09,"C,0"
  DEFW $14FA              ; 5370 CALL DRWFIX
  DEFB $0C
  DEFM $09,"CALL",$09,"DRWFIX"
  DEFW $1504              ; 5380 LOOPFT LD A,(EUGHGT)
  DEFB $14
  DEFM "LOOPFT",$09,"LD",$09,"A,(EUGHGT)"
  DEFW $150E              ; 5390 LD C,A
  DEFB $07
  DEFM $09,"LD",$09,"C,A"
  DEFW $1518              ; 5400 LD B,83H
  DEFB $09
  DEFM $09,"LD",$09,"B,83H"
  DEFW $1522              ; 5410 LD A,(BC)
  DEFB $0A
  DEFM $09,"LD",$09,"A,(BC)"
  DEFW $152C              ; 5420 OR 0FH
  DEFB $07
  DEFM $09,"OR",$09,"0FH"
  DEFW $1536              ; 5430 LD L,A
  DEFB $07
  DEFM $09,"LD",$09,"L,A"
  DEFW $1540              ; 5440 INC BC
  DEFB $07
  DEFM $09,"INC",$09,"BC"
  DEFW $154A              ; 5450 LD A,(BC)
  DEFB $0A
  DEFM $09,"LD",$09,"A,(BC)"
  DEFW $1554              ; 5460 SUB 20H
  DEFB $08
  DEFM $09,"SUB",$09,"20H"
  DEFW $155E              ; 5470 LD H,A
  DEFB $07
  DEFM $09,"LD",$09,"H,A"
  DEFW $1568              ; 5480 LD DE,0BAE0H
  DEFB $0D
  DEFM $09,"LD",$09,"DE,0BAE0H"
  DEFW $1572              ; 5490 LD C,0
  DEFB $07
  DEFM $09,"LD",$09,"C,0"
  DEFW $157C              ; 5500 CALL DRWFIX
  DEFB $0C
  DEFM $09,"CALL",$09,"DRWFIX"
  DEFW $1586              ; 5510 LD A,(EUGHGT)
  DEFB $0E
  DEFM $09,"LD",$09,"A,(EUGHGT)"
  DEFW $1590              ; 5520 CPL
  DEFB $04
  DEFM $09,"CPL"
  DEFW $159A              ; 5530 LD E,A
  DEFB $07
  DEFM $09,"LD",$09,"E,A"
  DEFW $15A4              ; 5540 XOR A
  DEFB $06
  DEFM $09,"XOR",$09,"A"
  DEFW $15AE              ; 5550 LD BC,40H
  DEFB $0A
  DEFM $09,"LD",$09,"BC,40H"
  DEFW $15B8              ; 5560 TM111 OUT (254),A
  DEFB $11
  DEFM "TM111",$09,"OUT",$09,"(254),A"
  DEFW $15C2              ; 5570 XOR 24
  DEFB $07
  DEFM $09,"XOR",$09,"24"
  DEFW $15CC              ; 5580 LD B,E
  DEFB $07
  DEFM $09,"LD",$09,"B,E"
  DEFW $15D6              ; 5590 TM112 DJNZ TM112
  DEFB $10
  DEFM "TM112",$09,"DJNZ",$09,"TM112"
  DEFW $15E0              ; 5600 DEC C
  DEFB $06
  DEFM $09,"DEC",$09,"C"
  DEFW $15EA              ; 5610 JR NZ,TM111
  DEFB $0C
  DEFM $09,"JR",$09,"NZ,TM111"
  DEFW $15F4              ; 5620 LD HL,5800H
  DEFB $0C
  DEFM $09,"LD",$09,"HL,5800H"
  DEFW $15FE              ; 5630 LD DE,5801H
  DEFB $0C
  DEFM $09,"LD",$09,"DE,5801H"
  DEFW $1608              ; 5640 LD BC,1FFH
  DEFB $0B
  DEFM $09,"LD",$09,"BC,1FFH"
  DEFW $1612              ; 5650 LD A,(EUGHGT)
  DEFB $0E
  DEFM $09,"LD",$09,"A,(EUGHGT)"
  DEFW $161C              ; 5660 AND 0CH
  DEFB $08
  DEFM $09,"AND",$09,"0CH"
  DEFW $1626              ; 5670 RLCA
  DEFB $05
  DEFM $09,"RLCA"
  DEFW $1630              ; 5680 OR 47H
  DEFB $07
  DEFM $09,"OR",$09,"47H"
  DEFW $163A              ; 5690 LD (HL),A
  DEFB $0A
  DEFM $09,"LD",$09,"(HL),A"
  DEFW $1644              ; 5700 LDIR
  DEFB $05
  DEFM $09,"LDIR"
  DEFW $164E              ; 5710 LD A,(EUGHGT)
  DEFB $0E
  DEFM $09,"LD",$09,"A,(EUGHGT)"
  DEFW $1658              ; 5720 ADD A,4
  DEFB $08
  DEFM $09,"ADD",$09,"A,4"
  DEFW $1662              ; 5730 LD (EUGHGT),A
  DEFB $0E
  DEFM $09,"LD",$09,"(EUGHGT),A"
  DEFW $166C              ; 5740 CP 0C4H
  DEFB $08
  DEFM $09,"CP",$09,"0C4H"
  DEFW $1676              ; 5750 JR NZ,LOOPFT
  DEFB $0D
  DEFM $09,"JR",$09,"NZ,LOOPFT"
  DEFW $1680              ; 5760 LD IX,MESSG
  DEFB $0C
  DEFM $09,"LD",$09,"IX,MESSG"
  DEFW $168A              ; 5770 LD C,4
  DEFB $07
  DEFM $09,"LD",$09,"C,4"
  DEFW $1694              ; 5780 LD DE,40CAH
  DEFB $0C
  DEFM $09,"LD",$09,"DE,40CAH"
  DEFW $169E              ; 5790 CALL PMESS
  DEFB $0B
  DEFM $09,"CALL",$09,"PMESS"
  DEFW $16A8              ; 5800 LD IX,MESSO
  DEFB $0C
  DEFM $09,"LD",$09,"IX,MESSO"
  DEFW $16B2              ; 5810 LD C,4
  DEFB $07
  DEFM $09,"LD",$09,"C,4"
  DEFW $16BC              ; 5820 LD DE,40D2H
  DEFB $0C
  DEFM $09,"LD",$09,"DE,40D2H"
  DEFW $16C6              ; 5830 CALL PMESS
  DEFB $0B
  DEFM $09,"CALL",$09,"PMESS"
  DEFW $16D0              ; 5840 LD BC,0
  DEFB $08
  DEFM $09,"LD",$09,"BC,0"
  DEFW $16DA              ; 5850 LD D,6
  DEFB $07
  DEFM $09,"LD",$09,"D,6"
  DEFW $16E4              ; 5860 TM91 DJNZ TM91
  DEFB $0E
  DEFM "TM91",$09,"DJNZ",$09,"TM91"
  DEFW $16EE              ; 5870 LD A,C
  DEFB $07
  DEFM $09,"LD",$09,"A,C"
  DEFW $16F8              ; 5880 A[ND 7]
  DEFB $06
  DEFM $09,"A"

; '...MANIC MINER . . © BUG-BYTE ltd. 1983...'
;
; Used by the routine at START.
MESSINTRO:
  DEFM ".  .  .  .  .  .  .  .  .  .  . MANIC MINER . . "
  DEFM $7F," BUG-BYTE ltd. 1983 . . By Matthew Smith . . . "
  DEFM "Q to P = Left & Right . . Bottom row = Jump . . "
  DEFM "A to G = Pause . . H to L = Tune On/Off . . . "
  DEFM "Guide Miner Willy through 20 lethal caverns"
  DEFM " .  .  .  .  .  .  .  ."

; Attribute data for the bottom two-thirds of the title screen
;
; Used by the routine at START. The graphic data for the middle third of the
; title screen is located at TITLESCR2.
LOWERATTRS:
  DEFB $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16
  DEFB $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16
  DEFB $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
  DEFB $17,$17,$17,$17,$17,$10,$10,$10,$10,$10,$10,$10,$10,$17,$17,$17
  DEFB $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
  DEFB $17,$17,$17,$17,$17,$16,$16,$16,$16,$16,$16,$16,$16,$17,$17,$17
  DEFB $13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13
  DEFB $13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13
  DEFB $17,$17,$17,$17,$17,$17,$10,$10,$10,$10,$10,$10,$16,$16,$16,$16
  DEFB $16,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
  DEFB $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38
  DEFB $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38
  DEFB $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38
  DEFB $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38
  DEFB $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30
  DEFB $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30
  DEFB $57,$57,$57,$57,$57,$57,$57,$57,$57,$57,$67,$67,$67,$67,$67,$67
  DEFB $67,$67,$67,$67,$67,$67,$67,$67,$67,$67,$67,$67,$67,$67,$67,$67
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Title screen graphic data
;
; Used by the routines at START and DRAWSHEET.
;
; The attributes for the top third of the title screen are located at CAVERN19
; (in the cavern data for The Final Barrier).
;
; The attributes for the middle third of the title screen are located at
; LOWERATTRS.
TITLESCR1:
  DEFB $05,$00,$00,$00,$00,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$01,$81,$81,$80,$00,$00,$00,$00,$00,$00
  DEFB $3B,$00,$08,$63,$00,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$00,$00,$07,$FF,$E0
  DEFB $03,$00,$00,$54,$00,$FF,$00,$00,$07,$E0,$00,$00,$0F,$DF,$DC,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$22,$22,$22,$08,$E0,$10
  DEFB $00,$FF,$9F,$94,$F3,$00,$3F,$C0,$1F,$F8,$03,$FC,$00,$00,$00,$00
  DEFB $00,$24,$42,$42,$24,$44,$00,$00,$00,$00,$77,$77,$77,$00,$FF,$00
  DEFB $00,$00,$00,$8A,$00,$07,$FF,$FC,$07,$E0,$3F,$FF,$E0,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$4A,$00,$00,$00,$01,$FF,$FF,$80,$00,$00,$E0,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$00,$01,$B9,$80,$30,$FF,$FF,$07,$C0,$FF,$FF,$0F,$FF,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$24,$00,$12,$40,$12,$40,$12,$40,$01,$22,$40,$11,$41,$02,$10
  DEFB $24,$10,$21,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21
  DEFB $07,$00,$00,$00,$00,$00,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$03,$42,$42,$C0,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$C8,$00,$00,$00,$00,$00,$01,$F0,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$00,$00,$04,$00,$20
  DEFB $05,$00,$00,$55,$00,$FF,$00,$00,$7F,$FE,$00,$00,$0F,$EF,$78,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$81,$81,$00,$77,$77,$77,$09,$10,$10
  DEFB $00,$7F,$0F,$55,$F4,$00,$7F,$E0,$1F,$F8,$07,$FE,$00,$00,$00,$00
  DEFB $00,$24,$42,$44,$22,$42,$00,$00,$00,$00,$77,$77,$77,$31,$FF,$8C
  DEFB $00,$00,$00,$52,$00,$01,$FF,$FE,$07,$E0,$7F,$FF,$80,$00,$00,$0F
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$52,$00,$70,$00,$03,$FF,$FF,$C0,$00,$0E,$F0,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$00,$03,$10,$00,$30,$7F,$FF,$01,$F0,$FF,$FC,$01,$FF,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$24,$30,$21,$51,$30,$24,$31,$20,$20,$42,$10,$34,$21,$03,$12
  DEFB $02,$13,$40,$00,$00,$42,$00,$00,$00,$00,$00,$00,$00,$00,$00,$31
  DEFB $03,$00,$00,$00,$00,$00,$D0,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$07,$24,$24,$E0,$00,$00,$00,$00,$00,$00
  DEFB $1D,$00,$00,$00,$00,$00,$B4,$00,$00,$00,$00,$00,$07,$F8,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$81,$81,$00,$00,$00,$00,$04,$18,$20
  DEFB $05,$00,$00,$94,$00,$D0,$00,$00,$7F,$FE,$00,$00,$1F,$FF,$97,$80
  DEFB $00,$65,$76,$56,$86,$56,$00,$81,$81,$00,$77,$77,$77,$09,$50,$10
  DEFB $00,$3E,$07,$55,$C0,$00,$FF,$E0,$1F,$F8,$07,$FF,$00,$00,$00,$00
  DEFB $00,$22,$42,$44,$24,$42,$00,$00,$00,$00,$77,$77,$77,$32,$FF,$4C
  DEFB $00,$00,$00,$51,$00,$00,$7F,$FE,$00,$00,$7F,$FE,$00,$00,$00,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$06,$52,$30,$7F,$00,$03,$FF,$FF,$C0,$00,$FE,$F8,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $0F,$00,$00,$00,$00,$00,$3F,$FF,$07,$E0,$FF,$F0,$00,$3F,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $02,$13,$15,$02,$43,$60,$21,$34,$50,$31,$21,$50,$37,$61,$50,$28
  DEFB $12,$03,$46,$00,$00,$24,$00,$00,$00,$00,$00,$00,$00,$00,$00,$27
  DEFB $01,$00,$00,$00,$00,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$0F,$18,$18,$F0,$00,$00,$00,$00,$00,$00
  DEFB $1F,$00,$00,$00,$00,$00,$F6,$00,$00,$00,$00,$00,$0F,$FC,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$81,$81,$00,$00,$00,$00,$04,$00,$20
  DEFB $17,$00,$00,$A2,$00,$F8,$00,$00,$7F,$FE,$00,$00,$1F,$FF,$EF,$5C
  DEFB $70,$85,$97,$54,$68,$67,$00,$81,$81,$00,$FF,$FF,$FF,$3F,$FF,$FC
  DEFB $00,$14,$02,$54,$C0,$01,$FF,$F0,$1F,$F8,$0F,$FF,$80,$00,$00,$00
  DEFB $00,$42,$44,$22,$24,$22,$00,$00,$00,$00,$77,$77,$77,$34,$FF,$2C
  DEFB $00,$00,$00,$95,$00,$00,$1F,$FF,$00,$00,$FF,$F8,$00,$00,$0F,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$0F,$51,$F8,$7F,$F0,$07,$FF,$FF,$E0,$0F,$FE,$F8,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $0F,$00,$00,$00,$00,$00,$1E,$7F,$03,$F0,$FF,$80,$00,$03,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $21,$30,$54,$30,$67,$28,$91,$20,$34,$51,$90,$24,$31,$54,$61,$20
  DEFB $34,$51,$90,$00,$00,$83,$00,$00,$00,$00,$00,$00,$00,$00,$00,$73
  DEFB $06,$00,$00,$00,$00,$00,$E4,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$1F,$18,$18,$F8,$00,$00,$00,$00,$00,$00
  DEFB $05,$00,$07,$81,$C0,$30,$C8,$00,$00,$00,$00,$00,$1E,$3B,$B0,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$81,$81,$00,$00,$00,$00,$04,$00,$20
  DEFB $1D,$00,$00,$AA,$00,$C0,$00,$00,$3F,$FC,$00,$00,$0E,$7F,$EE,$DE
  DEFB $F8,$66,$66,$66,$66,$66,$00,$81,$81,$00,$FF,$FF,$FF,$7F,$FF,$FE
  DEFB $00,$00,$00,$92,$80,$01,$FF,$F0,$0F,$F0,$0F,$FF,$80,$00,$00,$00
  DEFB $00,$42,$24,$42,$42,$44,$00,$00,$00,$00,$77,$77,$77,$3F,$FF,$FC
  DEFB $00,$00,$00,$A5,$00,$00,$07,$FF,$03,$C0,$FF,$E0,$00,$00,$3F,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$7F,$89,$FC,$7F,$FF,$07,$FF,$FF,$E0,$FF,$FE,$FC,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $3F,$00,$00,$00,$00,$00,$00,$1F,$01,$80,$FE,$00,$00,$00,$C1,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $74,$11,$57,$91,$51,$21,$02,$46,$19,$12,$02,$49,$12,$06,$74,$21
  DEFB $34,$61,$21,$00,$00,$21,$00,$00,$00,$00,$00,$00,$00,$00,$00,$43
  DEFB $0B,$00,$00,$00,$00,$00,$D0,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$3F,$24,$24,$FC,$00,$00,$00,$00,$00,$00
  DEFB $03,$00,$02,$C3,$A0,$00,$D0,$00,$00,$00,$00,$00,$1D,$D7,$D8,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$81,$81,$00,$00,$00,$00,$04,$00,$20
  DEFB $1F,$00,$00,$AA,$00,$80,$01,$80,$3F,$FC,$01,$80,$0F,$BF,$EE,$DE
  DEFB $F8,$66,$66,$66,$66,$66,$00,$81,$81,$00,$77,$77,$77,$FF,$FF,$FF
  DEFB $00,$00,$00,$8A,$00,$03,$FF,$F8,$0F,$F0,$1F,$FF,$C0,$00,$00,$00
  DEFB $00,$24,$42,$24,$24,$24,$00,$00,$00,$00,$77,$77,$77,$30,$FF,$0C
  DEFB $00,$00,$00,$A9,$00,$00,$01,$FE,$1F,$F8,$7F,$80,$00,$00,$FF,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$01,$FF,$AA,$FC,$FF,$FF,$C7,$FF,$FF,$E3,$FF,$FF,$FE,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $FF,$00,$00,$00,$00,$00,$00,$0F,$0F,$C0,$F0,$00,$00,$00,$3E,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $F8,$10,$2F,$46,$21,$71,$15,$46,$31,$26,$15,$42,$13,$15,$03,$24
  DEFB $34,$51,$51,$00,$00,$51,$00,$00,$00,$00,$00,$00,$00,$00,$00,$24
  DEFB $05,$00,$00,$00,$00,$00,$B4,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$7F,$42,$42,$FE,$00,$00,$00,$00,$00,$00
  DEFB $06,$00,$01,$53,$C0,$00,$B8,$00,$00,$00,$00,$00,$0B,$EF,$E8,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$81,$81,$00,$00,$00,$00,$00,$00,$20
  DEFB $0A,$00,$00,$AA,$00,$00,$07,$80,$3F,$FC,$01,$E0,$07,$DF,$CF,$6F
  DEFB $78,$66,$66,$66,$66,$66,$00,$FF,$FF,$00,$77,$77,$77,$FF,$FF,$FF
  DEFB $00,$00,$00,$AA,$00,$03,$FF,$F8,$0F,$F0,$1F,$FF,$C0,$00,$00,$00
  DEFB $00,$22,$42,$44,$22,$42,$00,$00,$00,$00,$77,$77,$77,$30,$3C,$0C
  DEFB $00,$00,$00,$AA,$00,$00,$00,$7C,$7F,$FE,$3E,$00,$00,$0F,$FF,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$0F,$FF,$AA,$FE,$FF,$FF,$CF,$FF,$FF,$F3,$FF,$FF,$FE,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $FF,$00,$00,$00,$00,$00,$00,$07,$03,$F0,$E0,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$20,$31,$20,$33,$20,$31,$20,$02,$10,$42,$10,$12,$40,$10,$42
  DEFB $40,$10,$42,$00,$00,$82,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40
  DEFB $2A,$00,$00,$00,$00,$00,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$FF,$81,$81,$FF,$00,$00,$00,$00,$00,$00
  DEFB $03,$00,$00,$A3,$00,$00,$64,$00,$00,$00,$00,$00,$07,$DF,$EC,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$00,$00,$04,$00,$20
  DEFB $07,$00,$00,$A2,$00,$00,$1F,$C0,$3F,$FC,$03,$F8,$03,$8F,$87,$BF
  DEFB $F0,$66,$66,$66,$66,$66,$00,$FF,$FF,$00,$77,$77,$77,$FF,$FF,$FF
  DEFB $00,$00,$00,$AA,$00,$07,$FF,$FC,$0F,$F0,$3F,$FF,$E0,$00,$00,$00
  DEFB $7E,$A6,$F6,$A6,$F6,$A6,$00,$00,$00,$00,$77,$77,$77,$30,$00,$0C
  DEFB $00,$00,$00,$8A,$00,$00,$00,$18,$FF,$FF,$18,$00,$00,$FF,$FF,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$3F,$FF,$4A,$FF,$FF,$FF,$CF,$FF,$FF,$F3,$FF,$FF,$FF,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $FF,$00,$00,$00,$00,$00,$00,$01,$01,$C0,$80,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $FC,$BD,$FE,$BC,$FD,$BE,$CB,$DF,$EB,$CF,$CD,$EF,$CF,$BF,$FE,$CD
  DEFB $BC,$CE,$BD,$00,$00,$DB,$00,$00,$00,$00,$00,$00,$00,$00,$00,$BD
TITLESCR2:
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$82,$0C,$3F,$86,$1E,$33,$80,$00,$00,$22,$31,$8C,$3C,$60
  DEFB $0C,$60,$60,$00,$00,$8B,$A2,$FB,$C0,$8B,$A0,$88,$80,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$FC,$FC,$FE,$7C,$7C,$00,$FE,$C6,$FE,$FE
  DEFB $FC,$00,$FE,$7C,$00,$7C,$FE,$10,$FC,$FE,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$41,$00,$0C,$60,$C6,$0E,$31,$81,$00,$00,$20,$31,$8C,$1C,$60
  DEFB $4C,$30,$70,$00,$00,$D9,$32,$82,$20,$89,$20,$85,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$FE,$FE,$FE,$FE,$FE,$00,$FE,$E6,$FE,$FE
  DEFB $FE,$00,$FE,$FE,$00,$FE,$FE,$38,$FE,$FE,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44
  DEFB $00,$03,$FF,$1E,$04,$0E,$0F,$78,$3A,$00,$07,$F8,$3B,$DC,$1E,$FF
  DEFB $9F,$F0,$00,$00,$00,$01,$FF,$88,$F3,$CE,$89,$FF,$80,$00,$00,$00
  DEFB $00,$82,$00,$0C,$40,$C6,$06,$30,$C6,$00,$00,$20,$31,$8C,$0C,$61
  DEFB $8C,$18,$10,$00,$00,$A9,$2A,$E3,$C0,$A9,$20,$82,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$C6,$C6,$C0,$C2,$C2,$00,$C0,$F6,$30,$C0
  DEFB $C6,$00,$30,$C6,$00,$C2,$30,$6C,$C6,$30,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11
  DEFB $11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11
  DEFB $00,$06,$07,$3C,$0E,$07,$06,$30,$C6,$00,$08,$38,$71,$8E,$0C,$61
  DEFB $8C,$38,$00,$00,$00,$02,$04,$14,$8A,$24,$CA,$00,$00,$00,$00,$00
  DEFB $00,$8C,$00,$1E,$E1,$EF,$02,$78,$38,$00,$00,$70,$7B,$DE,$04,$FF
  DEFB $9E,$0E,$20,$00,$00,$89,$26,$82,$80,$A9,$20,$82,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$FE,$FE,$F0,$F8,$F8,$00,$F0,$F6,$30,$F0
  DEFB $FE,$00,$30,$C6,$00,$F8,$30,$C6,$FE,$30,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$09,$8B,$6C,$0E,$07,$86,$31,$83,$00,$10,$2C,$71,$8F,$0C,$60
  DEFB $4C,$18,$00,$00,$00,$01,$C4,$22,$F3,$C4,$AA,$60,$00,$00,$00,$00
  DEFB $00,$70,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$07,$C0,$00,$00,$8B,$A2,$FA,$60,$53,$BE,$FA,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$FC,$FC,$F0,$3E,$3E,$00,$F0,$DE,$30,$F0
  DEFB $FC,$00,$30,$C6,$00,$3E,$30,$C6,$FC,$30,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$09,$93,$CC,$1B,$06,$C6,$33,$80,$00,$10,$2C,$B1,$8D,$8C,$62
  DEFB $0C,$18,$00,$00,$00,$00,$24,$3E,$A2,$84,$9A,$20,$00,$00,$00,$00
  DEFB $FF,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $FF,$F0,$1F,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$C0,$D8,$C0,$86,$86,$00,$C0,$DE,$30,$C0
  DEFB $D8,$00,$30,$C6,$00,$86,$30,$FE,$D8,$30,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$06,$23,$8C,$13,$06,$66,$33,$00,$00,$13,$26,$B1,$8C,$CC,$7E
  DEFB $0F,$F0,$00,$00,$00,$FF,$C4,$22,$9A,$6E,$89,$C0,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$C0,$CC,$FE,$FE,$FE,$00,$FE,$CE,$30,$FE
  DEFB $CC,$00,$30,$FE,$00,$FE,$30,$FE,$CC,$30,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$43,$0C,$31,$86,$36,$33,$00,$00,$0C,$27,$31,$8C,$6C,$62
  DEFB $0C,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$C0,$C6,$FE,$7C,$7C,$00,$FE,$C6,$30,$FE
  DEFB $C6,$00,$30,$7C,$00,$7C,$30,$C6,$C6,$30,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7
  DEFB $C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$07,$C7,$C7,$C1,$07,$C7,$C1,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

; Central Cavern (teleport: 6)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN0:
  DEFB $16,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$05,$00,$00,$00,$00
  DEFB $05,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$44
  DEFB $00,$00,$00,$44,$00,$00,$00,$16
  DEFB $16,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$02,$02
  DEFB $02,$02,$42,$02,$02,$02,$02,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$42,$42,$42,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$16,$16,$16,$00,$44,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$42,$42,$42,$42,$00,$00,$00
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$42,$42,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$44,$00,$00,$00
  DEFB $00,$00,$00,$00,$16,$16,$16,$02
  DEFB $02,$02,$02,$02,$42,$42,$42,$16
  DEFB $16,$00,$00,$00,$00,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "         Central Cavern         " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $42,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $16,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $04,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor
  DEFB $44,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1
  DEFB $05,$FF,$FE,$7E,$7C,$4C,$4C,$08,$08 ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7828              ; Location in the screen buffer at 28672: (9,8)
  DEFB $14                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (0,9)
  DEFW $5C09
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (0,29)
  DEFW $5C1D
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (1,16)
  DEFW $5C30
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (4,24)
  DEFW $5C98
  DEFB $60
  DEFB $FF
  DEFB $03                ; Item 5 at (6,30)
  DEFW $5CDE
  DEFB $60
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $FF,$FF,$92,$49,$B6,$DB,$FF,$FF ; Graphic data
  DEFB $92,$49,$B6,$DB,$FF,$FF,$92,$49
  DEFB $B6,$DB,$FF,$FF,$92,$49,$B6,$DB
  DEFB $FF,$FF,$92,$49,$B6,$DB,$FF,$FF
  DEFW $5DBD              ; Location in the attribute buffer at 23552: (13,29)
  DEFW $68BD              ; Location in the screen buffer at 24576: (13,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $FC                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $46                ; Horizontal guardian 1: y=7, initial x=8, 8<=x<=15,
  DEFW $5CE8              ; speed=normal
  DEFB $60
  DEFB $00
  DEFB $E8
  DEFB $EF
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next byte is copied to VGUARDS and indicates that there are no vertical
; guardians in this cavern.
  DEFB $FF                ; Terminator
; The next two bytes are unused.
  DEFB $00,$00            ; Unused
; The next 32 bytes define the swordfish graphic that appears in The Final
; Barrier when the game is completed.
SWORDFISH:
  DEFB $02,$A0,$05,$43,$1F,$E4,$73,$FF ; Swordfish graphic data
  DEFB $F2,$F8,$1F,$3F,$FF,$E4,$3F,$C3
  DEFB $00,$00,$01,$00,$39,$FC,$6F,$02
  DEFB $51,$01,$7F,$FE,$39,$FC,$01,$00
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $1F,$20,$39,$E0,$19,$E0,$0F,$20 ; Guardian graphic data
  DEFB $9F,$00,$5F,$80,$FF,$C0,$5E,$00
  DEFB $9F,$C0,$1F,$80,$0E,$00,$1F,$00
  DEFB $BB,$A0,$71,$C0,$20,$80,$11,$00
  DEFB $07,$C4,$0E,$7C,$06,$7C,$23,$C4
  DEFB $17,$C0,$17,$E0,$3F,$F0,$17,$F0
  DEFB $17,$F0,$27,$E0,$03,$80,$03,$80
  DEFB $06,$C0,$06,$C0,$1C,$70,$06,$C0
  DEFB $01,$F2,$03,$9E,$01,$9E,$00,$F2
  DEFB $09,$F0,$05,$F8,$0F,$FC,$05,$E0
  DEFB $09,$FC,$01,$F8,$00,$E0,$00,$E0
  DEFB $00,$E0,$00,$E0,$00,$E0,$01,$F0
  DEFB $00,$7D,$00,$E7,$00,$67,$00,$3D
  DEFB $00,$7C,$00,$7F,$03,$FC,$00,$78
  DEFB $00,$7C,$00,$7F,$00,$38,$00,$38
  DEFB $00,$6C,$00,$6C,$01,$C7,$00,$6C
  DEFB $BE,$00,$E7,$00,$E6,$00,$BC,$00
  DEFB $3E,$00,$FE,$00,$3F,$C0,$1E,$00
  DEFB $3E,$00,$FE,$00,$1C,$00,$1C,$00
  DEFB $36,$00,$36,$00,$E3,$80,$36,$00
  DEFB $4F,$80,$79,$C0,$79,$80,$4F,$00
  DEFB $0F,$90,$1F,$A0,$3F,$F0,$07,$A0
  DEFB $3F,$90,$1F,$80,$07,$00,$07,$00
  DEFB $07,$00,$07,$00,$07,$00,$0F,$80
  DEFB $23,$E0,$3E,$70,$3E,$60,$23,$C4
  DEFB $03,$E8,$07,$E8,$0F,$FC,$0F,$E8
  DEFB $0F,$E8,$07,$E4,$01,$C0,$01,$C0
  DEFB $03,$60,$03,$60,$0E,$38,$03,$60
  DEFB $04,$F8,$07,$9C,$07,$98,$04,$F0
  DEFB $00,$F9,$01,$FA,$03,$FF,$00,$7A
  DEFB $03,$F9,$01,$F8,$00,$70,$00,$F8
  DEFB $05,$DD,$03,$8E,$01,$04,$00,$88

; The Cold Room (teleport: 16)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN1:
  DEFB $16,$08,$08,$08,$08,$08,$08,$08 ; Attributes
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$16,$16,$16,$16,$16
  DEFB $16,$16,$16,$16,$16,$16,$16,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$0D,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$0B,$0B,$0B
  DEFB $4B,$08,$08,$08,$08,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$16
  DEFB $16,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  DEFB $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  DEFB $4B,$4B,$4B,$4B,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$16,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$4B,$4B,$4B
  DEFB $4B,$16,$0B,$0B,$16,$08,$08,$16
  DEFB $16,$4B,$0B,$0B,$0B,$0B,$0B,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$16,$08,$08,$16,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$16,$0B,$0B,$16,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$16,$0B,$0B,$16,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$0B,$0B,$0B,$0B,$08
  DEFB $08,$16,$0B,$0B,$16,$08,$08,$16
  DEFB $16,$08,$08,$0E,$0E,$0E,$0E,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$16,$0B,$0B,$16,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$4B,$4B
  DEFB $4B,$4B,$08,$08,$08,$08,$08,$08
  DEFB $08,$16,$0B,$0B,$16,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $0B,$0B,$0B,$0B,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$16
  DEFB $16,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$16
  DEFB $16,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  DEFB $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  DEFB $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  DEFB $4B,$4B,$4B,$4B,$4B,$4B,$4B,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "          The Cold Room         " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $4B,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $0B,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $16,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $0E,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor
  DEFB $0C,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $0D,$FF,$FE,$5E,$6C,$4C,$4C,$08,$08 ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $7863              ; Location in the screen buffer at 28672: (11,3)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $0B                ; Item 1 at (1,7)
  DEFW $5C27
  DEFB $60
  DEFB $FF
  DEFB $0C                ; Item 2 at (1,24)
  DEFW $5C38
  DEFB $60
  DEFB $FF
  DEFB $0D                ; Item 3 at (7,26)
  DEFW $5CFA
  DEFB $60
  DEFB $FF
  DEFB $0E                ; Item 4 at (9,3)
  DEFW $5D23
  DEFB $68
  DEFB $FF
  DEFB $0B                ; Item 5 at (12,19)
  DEFW $5D93
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $53                ; Attribute
  DEFB $FF,$FF,$92,$49,$92,$49,$92,$49 ; Graphic data
  DEFB $92,$49,$92,$49,$92,$49,$92,$49
  DEFB $92,$49,$92,$49,$92,$49,$92,$49
  DEFB $92,$49,$92,$49,$92,$49,$FF,$FF
  DEFW $5DBD              ; Location in the attribute buffer at 23552: (13,29)
  DEFW $68BD              ; Location in the screen buffer at 24576: (13,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $50,$A8,$54,$A8,$54,$2C,$02,$01 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $FC                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $0E                ; Horizontal guardian 1: y=3, initial x=18, 1<=x<=18,
  DEFW $5C72              ; speed=normal
  DEFB $60
  DEFB $07
  DEFB $61
  DEFB $72
  DEFB $0D                ; Horizontal guardian 2: y=13, initial x=29,
  DEFW $5DBD              ; 12<=x<=29, speed=normal
  DEFB $68
  DEFB $07
  DEFB $AC
  DEFB $BD
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next byte is copied to VGUARDS and indicates that there are no vertical
; guardians in this cavern.
  DEFB $FF                ; Terminator
; The next two bytes are unused.
  DEFB $00,$00            ; Unused
; The next 32 bytes define the plinth graphic that appears on the Game Over
; screen.
PLINTH:
  DEFB $FF,$FF,$72,$4E,$8A,$51,$AA,$55 ; Plinth graphic data
  DEFB $4A,$52,$12,$48,$22,$44,$2A,$54
  DEFB $2A,$54,$2A,$54,$2A,$54,$2A,$54
  DEFB $2A,$54,$2A,$54,$2A,$54,$2A,$54
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $0C,$00,$1E,$00,$1B,$00,$1E,$C0 ; Guardian graphic data
  DEFB $39,$00,$32,$00,$3A,$00,$3D,$00
  DEFB $6D,$00,$69,$00,$69,$00,$61,$00
  DEFB $71,$00,$BE,$00,$08,$00,$1E,$00
  DEFB $03,$00,$07,$80,$06,$C0,$07,$B0
  DEFB $0E,$40,$0C,$80,$0F,$80,$0D,$C0
  DEFB $1B,$40,$1B,$40,$16,$40,$18,$40
  DEFB $1C,$40,$2F,$80,$05,$40,$0F,$80
  DEFB $00,$C0,$01,$E0,$01,$B0,$01,$EC
  DEFB $03,$90,$03,$20,$03,$A0,$03,$D0
  DEFB $06,$D0,$06,$90,$06,$90,$06,$10
  DEFB $07,$10,$0B,$E8,$02,$50,$07,$E0
  DEFB $00,$30,$00,$78,$00,$6C,$00,$7B
  DEFB $00,$E4,$00,$C8,$00,$E8,$00,$F4
  DEFB $01,$B4,$01,$94,$01,$94,$01,$84
  DEFB $01,$C4,$02,$F8,$00,$54,$00,$F8
  DEFB $0C,$00,$1E,$00,$36,$00,$DE,$00
  DEFB $27,$00,$13,$00,$17,$00,$2F,$00
  DEFB $2D,$80,$29,$80,$29,$80,$21,$80
  DEFB $23,$80,$1F,$40,$2A,$00,$1F,$00
  DEFB $03,$00,$07,$80,$0D,$80,$37,$80
  DEFB $09,$C0,$04,$C0,$05,$C0,$0B,$C0
  DEFB $0B,$60,$09,$60,$09,$60,$08,$60
  DEFB $08,$E0,$17,$D0,$0A,$40,$07,$E0
  DEFB $00,$C0,$01,$E0,$03,$60,$0D,$E0
  DEFB $02,$70,$01,$30,$01,$F0,$03,$B0
  DEFB $02,$D8,$02,$D8,$02,$68,$02,$18
  DEFB $02,$38,$01,$F4,$02,$A0,$01,$F0
  DEFB $00,$30,$00,$78,$00,$D8,$03,$78
  DEFB $00,$9C,$00,$4C,$00,$5C,$00,$BC
  DEFB $00,$B6,$00,$96,$00,$96,$00,$86
  DEFB $00,$8E,$00,$7D,$00,$10,$00,$78

; The Menagerie (teleport: 26)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN2:
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$43,$00,$00,$00,$00,$00
  DEFB $00,$00,$03,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$43,$00,$00,$00,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$43,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$45,$45,$45,$45,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$45,$45,$45,$45,$45,$45,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$45,$45,$45,$45,$0D
  DEFB $0D,$03,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$03,$00,$00,$00,$00,$02,$02
  DEFB $02,$02,$02,$02,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$03,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$45,$45,$45,$45,$45,$45,$0D
  DEFB $0D,$43,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$45,$45
  DEFB $45,$45,$45,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$00,$00,$00,$00,$45,$45,$45
  DEFB $45,$45,$45,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$0D
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0D
  DEFB $0D,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$0D
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "          The Menagerie         " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $45,$FF,$FF,$66,$99,$66,$99,$FF,$00 ; Floor
  DEFB $05,$FF,$FF,$66,$99,$42,$18,$EA,$00 ; Crumbling floor
  DEFB $0D,$81,$C3,$A5,$99,$99,$A5,$C3,$81 ; Wall
  DEFB $02,$F0,$AA,$F0,$66,$66,$00,$00,$00 ; Conveyor
  DEFB $06,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $43,$10,$D6,$38,$D6,$38,$44,$C6,$28 ; Nasty 2
  DEFB $03,$10,$10,$10,$10,$10,$10,$10,$10 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7826              ; Location in the screen buffer at 28672: (9,6)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (0,6)
  DEFW $5C06
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (0,15)
  DEFW $5C0F
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (0,23)
  DEFW $5C17
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (6,30)
  DEFW $5CDE
  DEFB $60
  DEFB $FF
  DEFB $03                ; Item 5 at (6,21)
  DEFW $5CD5
  DEFB $60
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $FF,$FF,$44,$44,$99,$99,$22,$22 ; Graphic data
  DEFB $22,$22,$99,$99,$44,$44,$44,$44
  DEFB $99,$99,$22,$22,$22,$22,$99,$99
  DEFB $44,$44,$44,$44,$99,$99,$FF,$FF
  DEFW $5D7D              ; Location in the attribute buffer at 23552: (11,29)
  DEFW $687D              ; Location in the screen buffer at 24576: (11,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $44                ; Horizontal guardian 1: y=13, initial x=19,
  DEFW $5DB3              ; 1<=x<=19, speed=normal
  DEFB $68
  DEFB $07
  DEFB $A1
  DEFB $B3
  DEFB $43                ; Horizontal guardian 2: y=3, initial x=16, 1<=x<=16,
  DEFW $5C70              ; speed=normal
  DEFB $60
  DEFB $07
  DEFB $61
  DEFB $70
  DEFB $42                ; Horizontal guardian 3: y=3, initial x=18,
  DEFW $5C72              ; 18<=x<=29, speed=normal
  DEFB $60
  DEFB $00
  DEFB $72
  DEFB $7D
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next byte is copied to VGUARDS and indicates that there are no vertical
; guardians in this cavern.
  DEFB $FF                ; Terminator
; The next two bytes are unused.
  DEFB $00,$00            ; Unused
; The next 32 bytes define the boot graphic that appears on the Game Over
; screen (see LOOPFT). It also appears at the bottom of the screen next to the
; remaining lives when cheat mode is activated (see LOOP_1).
BOOT:
  DEFB $2A,$C0,$35,$40,$3F,$C0,$09,$00 ; Boot graphic data
  DEFB $09,$00,$1F,$80,$10,$80,$10,$80
  DEFB $11,$80,$22,$40,$20,$B8,$59,$24
  DEFB $44,$42,$44,$02,$44,$02,$FF,$FF
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $03,$00,$06,$80,$07,$C0,$03,$00 ; Guardian graphic data
  DEFB $01,$80,$00,$C0,$BE,$C0,$E3,$80
  DEFB $41,$00,$AB,$00,$7F,$00,$3E,$00
  DEFB $08,$00,$08,$00,$08,$00,$14,$00
  DEFB $00,$C0,$01,$A0,$01,$F0,$00,$C0
  DEFB $00,$60,$00,$30,$2F,$B0,$38,$E0
  DEFB $18,$C0,$30,$C0,$15,$C0,$0A,$80
  DEFB $15,$00,$02,$00,$05,$00,$00,$00
  DEFB $00,$30,$00,$68,$00,$7C,$00,$30
  DEFB $00,$18,$00,$0C,$0B,$EC,$0E,$38
  DEFB $04,$10,$0A,$B0,$07,$F0,$03,$E0
  DEFB $00,$80,$01,$40,$00,$00,$00,$00
  DEFB $00,$0C,$00,$1A,$00,$1F,$00,$AC
  DEFB $01,$56,$00,$AB,$03,$5B,$03,$86
  DEFB $01,$0C,$03,$FC,$01,$FC,$00,$F8
  DEFB $00,$20,$00,$20,$00,$50,$00,$00
  DEFB $30,$00,$58,$00,$F8,$00,$35,$00
  DEFB $6A,$80,$D5,$00,$DA,$C0,$61,$C0
  DEFB $30,$80,$3F,$C0,$3F,$80,$1F,$00
  DEFB $04,$00,$04,$00,$0A,$00,$00,$00
  DEFB $0C,$00,$16,$00,$3E,$00,$0C,$00
  DEFB $18,$00,$30,$00,$37,$D0,$1C,$70
  DEFB $08,$20,$0D,$50,$0F,$E0,$07,$C0
  DEFB $01,$00,$02,$80,$00,$00,$00,$00
  DEFB $03,$00,$05,$80,$0F,$80,$03,$00
  DEFB $06,$00,$0C,$00,$0D,$F4,$07,$1C
  DEFB $03,$18,$03,$0C,$03,$A8,$01,$50
  DEFB $00,$A8,$00,$40,$00,$A0,$00,$00
  DEFB $00,$C0,$01,$60,$03,$E0,$00,$C0
  DEFB $01,$80,$03,$00,$03,$7D,$01,$C7
  DEFB $00,$82,$00,$D5,$00,$FE,$00,$7C
  DEFB $00,$10,$00,$10,$00,$10,$00,$28

; Abandoned Uranium Workings (teleport: 126)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN3:
  DEFB $29,$00,$00,$00,$00,$00,$00,$05 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$29,$29
  DEFB $29,$29,$29,$29,$29,$29,$29,$29
  DEFB $29,$29,$29,$29,$29,$29,$29,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$46,$46,$46,$46,$46
  DEFB $46,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$46,$46,$46,$46,$29
  DEFB $29,$46,$00,$00,$00,$00,$00,$46
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$46,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$46,$46,$00,$00
  DEFB $00,$00,$00,$00,$00,$46,$46,$46
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$06,$06,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$46
  DEFB $46,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$46,$46,$46,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$46,$46,$46,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$03,$03,$03,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$46,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$46,$46,$46,$00
  DEFB $00,$00,$00,$00,$00,$00,$46,$46
  DEFB $46,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$46,$46
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$05
  DEFB $00,$00,$00,$00,$46,$46,$46,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$46,$46,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$29
  DEFB $29,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$29
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "   Abandoned Uranium Workings   " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $46,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $06,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $29,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $03,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor
  DEFB $04,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $05,$10,$10,$10,$54,$38,$D6,$38,$54 ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $01                ; Direction and movement flags: facing left (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DBD              ; Location in the attribute buffer at 23552: (13,29)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $7841              ; Location in the screen buffer at 28672: (10,1)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (0,1)
  DEFW $5C01
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (1,12)
  DEFW $5C2C
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (1,25)
  DEFW $5C39
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (6,16)
  DEFW $5CD0
  DEFB $60
  DEFB $FF
  DEFB $03                ; Item 5 at (6,30)
  DEFW $5CDE
  DEFB $60
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $22,$22,$11,$11,$88,$88,$44,$44 ; Graphic data
  DEFB $22,$22,$11,$11,$88,$88,$44,$44
  DEFB $22,$22,$11,$11,$88,$88,$44,$44
  DEFB $22,$22,$11,$11,$88,$88,$44,$44
  DEFW $5C3D              ; Location in the attribute buffer at 23552: (1,29)
  DEFW $603D              ; Location in the screen buffer at 24576: (1,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $42                ; Horizontal guardian 1: y=13, initial x=1, 1<=x<=10,
  DEFW $5DA1              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $A1
  DEFB $AA
  DEFB $44                ; Horizontal guardian 2: y=13, initial x=7, 6<=x<=15,
  DEFW $5DA7              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $A6
  DEFB $AF
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $07,$00,$0B,$80,$13,$C0,$13,$C0 ; Guardian graphic data
  DEFB $13,$C0,$0B,$80,$07,$00,$01,$00
  DEFB $07,$00,$05,$00,$07,$00,$07,$80
  DEFB $4F,$80,$5F,$C0,$FE,$C0,$3C,$40
  DEFB $01,$C0,$02,$E0,$05,$D0,$05,$D0
  DEFB $05,$D0,$02,$E0,$01,$C0,$00,$40
  DEFB $01,$C0,$01,$40,$01,$C0,$01,$E0
  DEFB $23,$E0,$2F,$F0,$7F,$B0,$1F,$10
  DEFB $00,$70,$00,$E8,$01,$E4,$01,$E4
  DEFB $01,$E4,$00,$E8,$00,$70,$00,$10
  DEFB $00,$70,$00,$50,$00,$70,$00,$F8
  DEFB $21,$F8,$27,$FC,$7F,$EC,$0F,$C4
  DEFB $00,$1C,$00,$36,$00,$63,$00,$63
  DEFB $00,$63,$00,$36,$00,$1C,$00,$04
  DEFB $00,$1C,$00,$14,$00,$1C,$00,$1E
  DEFB $04,$3E,$04,$FF,$0F,$FB,$03,$F1
  DEFB $38,$00,$6C,$00,$C6,$00,$C6,$00
  DEFB $C6,$00,$6C,$00,$38,$00,$20,$00
  DEFB $38,$00,$28,$00,$38,$00,$78,$00
  DEFB $7C,$20,$FF,$20,$DF,$F0,$8F,$C0
  DEFB $0E,$00,$17,$00,$27,$80,$27,$80
  DEFB $27,$80,$17,$00,$0E,$00,$08,$00
  DEFB $0E,$00,$0A,$00,$0E,$00,$1F,$00
  DEFB $1F,$84,$3F,$E4,$37,$FE,$23,$F0
  DEFB $03,$80,$07,$40,$0B,$A0,$0B,$A0
  DEFB $0B,$A0,$07,$40,$03,$80,$02,$00
  DEFB $03,$80,$02,$80,$03,$80,$07,$80
  DEFB $07,$C4,$0F,$F4,$0D,$FE,$08,$F8
  DEFB $00,$E0,$01,$D0,$03,$C8,$03,$C8
  DEFB $03,$C8,$01,$D0,$00,$E0,$00,$80
  DEFB $00,$E0,$00,$A0,$00,$E0,$01,$E0
  DEFB $01,$F2,$03,$FA,$03,$7F,$02,$3C

; Eugene's Lair (teleport: 36)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN4:
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10 ; Attributes
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$13,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $16,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$15,$15,$15,$15,$15,$15,$15
  DEFB $15,$15,$15,$15,$15,$15,$10,$10
  DEFB $10,$10,$14,$14,$14,$14,$15,$15
  DEFB $15,$15,$15,$15,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$15,$15,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$16,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$56,$56,$56,$56,$56,$56
  DEFB $56,$56,$56,$56,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$15,$15,$15,$15
  DEFB $15,$15,$15,$15,$15,$15,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$14,$14,$15,$15,$15,$15,$15
  DEFB $15,$15,$15,$15,$15,$15,$10,$10
  DEFB $10,$10,$15,$15,$15,$15,$15,$15
  DEFB $15,$10,$10,$10,$10,$10,$15,$2E
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $2E,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$15,$15,$10,$10,$10,$10,$10
  DEFB $2E,$10,$10,$10,$10,$10,$2E,$10
  DEFB $10,$2E,$10,$10,$10,$10,$10,$10
  DEFB $10,$10,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$10,$10,$10,$10,$16,$10,$10
  DEFB $2E,$10,$10,$10,$10,$10,$2E,$10
  DEFB $10,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  DEFB $16,$16,$10,$10,$10,$10,$10,$2E
  DEFB $2E,$15,$15,$15,$15,$15,$15,$15
  DEFB $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  DEFB $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  DEFB $15,$15,$15,$15,$15,$15,$15,$2E
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "         Eugene's Lair          " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $10,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $15,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $14,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $2E,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $56,$FC,$66,$FC,$66,$00,$00,$00,$00 ; Conveyor
  DEFB $16,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1
  DEFB $13,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $30                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5C61              ; Location in the attribute buffer at 23552: (3,1)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7812              ; Location in the screen buffer at 28672: (8,18)
  DEFB $0A                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $13                ; Item 1 at (1,30)
  DEFW $5C3E
  DEFB $60
  DEFB $FF
  DEFB $14                ; Item 2 at (6,10)
  DEFW $5CCA
  DEFB $60
  DEFB $FF
  DEFB $15                ; Item 3 at (7,29)
  DEFW $5CFD
  DEFB $60
  DEFB $FF
  DEFB $16                ; Item 4 at (12,7)
  DEFW $5D87
  DEFB $68
  DEFB $FF
  DEFB $13                ; Item 5 at (12,9)
  DEFW $5D89
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $57                ; Attribute
  DEFB $FF,$FF,$AA,$AA,$AA,$AA,$AA,$AA ; Graphic data
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$FF,$FF
  DEFW $5DAF              ; Location in the attribute buffer at 23552: (13,15)
  DEFW $68AF              ; Location in the screen buffer at 24576: (13,15)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $1F,$23,$47,$FF,$8F,$8E,$8C,$F8 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $16                ; Horizontal guardian 1: y=3, initial x=12, 1<=x<=12,
  DEFW $5C6C              ; speed=normal
  DEFB $60
  DEFB $07
  DEFB $61
  DEFB $6C
  DEFB $10                ; Horizontal guardian 2: y=7, initial x=4, 4<=x<=12,
  DEFW $5CE4              ; speed=normal
  DEFB $60
  DEFB $00
  DEFB $E4
  DEFB $EC
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT and specify Eugene's
; initial direction and pixel y-coordinate.
  DEFB $00                ; Initial direction (down)
  DEFB $00                ; Initial pixel y-coordinate
; The next three bytes are unused.
  DEFB $00,$00,$00        ; Unused
; The next 32 bytes define the Eugene graphic.
EUGENEG:
  DEFB $03,$C0,$0F,$F0,$1F,$F8,$1F,$F8 ; Eugene graphic data
  DEFB $31,$8C,$0E,$70,$6F,$F6,$AE,$75
  DEFB $B1,$8D,$9F,$F9,$9B,$D9,$8C,$31
  DEFB $47,$E2,$02,$40,$02,$40,$0E,$70
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $C0,$00,$C0,$00,$C0,$00,$C0,$00 ; Guardian graphic data
  DEFB $C0,$00,$C0,$00,$C0,$00,$DF,$C0
  DEFB $DF,$C0,$FF,$C0,$1F,$C0,$0F,$80
  DEFB $77,$80,$FF,$00,$DF,$00,$DF,$00
  DEFB $30,$00,$30,$00,$30,$00,$30,$00
  DEFB $30,$20,$30,$C0,$33,$00,$34,$00
  DEFB $37,$F0,$3F,$F0,$07,$F0,$03,$E0
  DEFB $1D,$E0,$3F,$C0,$37,$C0,$37,$C0
  DEFB $0C,$00,$0C,$00,$0C,$20,$0C,$40
  DEFB $0C,$40,$0C,$80,$0C,$80,$0D,$00
  DEFB $0D,$FC,$0F,$FC,$01,$FC,$00,$F8
  DEFB $07,$78,$0F,$F0,$0D,$F0,$0D,$F0
  DEFB $03,$00,$03,$00,$03,$00,$03,$00
  DEFB $03,$02,$03,$0C,$03,$30,$03,$40
  DEFB $03,$7F,$03,$FF,$00,$7F,$00,$3E
  DEFB $01,$DE,$03,$FC,$03,$7C,$03,$7C
  DEFB $00,$C0,$00,$C0,$00,$C0,$00,$C0
  DEFB $40,$C0,$30,$C0,$0C,$C0,$02,$C0
  DEFB $FE,$C0,$FF,$C0,$FE,$00,$7C,$00
  DEFB $7B,$80,$3F,$C0,$3E,$C0,$3E,$C0
  DEFB $00,$30,$00,$30,$04,$30,$02,$30
  DEFB $02,$30,$01,$30,$01,$30,$00,$B0
  DEFB $3F,$B0,$3F,$F0,$3F,$80,$1F,$00
  DEFB $1E,$E0,$0F,$F0,$0F,$B0,$0F,$B0
  DEFB $00,$0C,$00,$0C,$00,$0C,$00,$0C
  DEFB $04,$0C,$03,$0C,$00,$CC,$00,$2C
  DEFB $0F,$EC,$0F,$FC,$0F,$E0,$07,$C0
  DEFB $07,$B8,$03,$FC,$03,$EC,$03,$EC
  DEFB $00,$03,$00,$03,$00,$03,$00,$03
  DEFB $00,$03,$00,$03,$00,$03,$03,$FB
  DEFB $03,$FB,$03,$FF,$03,$F8,$01,$F0
  DEFB $01,$EE,$00,$FF,$00,$FB,$00,$FB

; Processing Plant (teleport: 136)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN5:
  DEFB $16,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $44,$44,$44,$00,$00,$00,$00,$44
  DEFB $44,$00,$00,$00,$00,$44,$44,$44
  DEFB $44,$44,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$44,$44,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$44,$44,$44,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$44
  DEFB $44,$44,$44,$44,$00,$00,$00,$16
  DEFB $16,$44,$44,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$44
  DEFB $16,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$06,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$43,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$44,$44,$44,$16
  DEFB $16,$00,$00,$05,$05,$05,$05,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$44,$44
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "       Processing Plant         " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$FF,$FF,$99,$99,$FF,$99,$66,$00 ; Floor
  DEFB $04,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor (unused)
  DEFB $16,$FF,$99,$FF,$66,$FF,$99,$FF,$66 ; Wall
  DEFB $05,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor
  DEFB $43,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1
  DEFB $06,$3C,$18,$BD,$E7,$E7,$BD,$18,$3C ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $30                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $03                ; Animation frame (see FRAME)
  DEFB $01                ; Direction and movement flags: facing left (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5C6F              ; Location in the attribute buffer at 23552: (3,15)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $78A3              ; Location in the screen buffer at 28672: (13,3)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (6,15)
  DEFW $5CCF
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (6,17)
  DEFW $5CD1
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (7,30)
  DEFW $5CFE
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (10,1)
  DEFW $5D41
  DEFB $68
  DEFB $FF
  DEFB $03                ; Item 5 at (11,13)
  DEFW $5D6D
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $FF,$FF,$81,$81,$BF,$FD,$BF,$FD ; Graphic data
  DEFB $B0,$0D,$B0,$0D,$B0,$0D,$F0,$0F
  DEFB $F0,$0F,$B0,$0D,$B0,$0D,$B0,$0D
  DEFB $BF,$FD,$BF,$FD,$81,$81,$FF,$FF
  DEFW $5C1D              ; Location in the attribute buffer at 23552: (0,29)
  DEFW $601D              ; Location in the screen buffer at 24576: (0,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $46                ; Horizontal guardian 1: y=8, initial x=6, 6<=x<=13,
  DEFW $5D06              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $06
  DEFB $0D
  DEFB $43                ; Horizontal guardian 2: y=8, initial x=14,
  DEFW $5D0E              ; 14<=x<=21, speed=normal
  DEFB $68
  DEFB $01
  DEFB $0E
  DEFB $15
  DEFB $45                ; Horizontal guardian 3: y=13, initial x=8, 8<=x<=20,
  DEFW $5DA8              ; speed=normal
  DEFB $68
  DEFB $02
  DEFB $A8
  DEFB $B4
  DEFB $06                ; Horizontal guardian 4: y=13, initial x=24,
  DEFW $5DB8              ; 24<=x<=29, speed=normal
  DEFB $68
  DEFB $03
  DEFB $B8
  DEFB $BD
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $1F,$00,$7F,$C0,$73,$E0,$F3,$80 ; Guardian graphic data
  DEFB $FE,$00,$F8,$00,$FE,$00,$FF,$80
  DEFB $7F,$E0,$7F,$C0,$1F,$00,$0A,$00
  DEFB $0A,$00,$0A,$00,$0A,$00,$1F,$00
  DEFB $07,$C0,$1F,$F0,$1E,$70,$3E,$78
  DEFB $3F,$F8,$3E,$00,$3F,$F8,$3F,$F8
  DEFB $1F,$F0,$1F,$F0,$07,$C0,$02,$80
  DEFB $02,$80,$07,$C0,$00,$00,$00,$00
  DEFB $01,$F0,$07,$FC,$07,$3E,$0F,$38
  DEFB $0F,$E0,$0F,$80,$0F,$E0,$0F,$F8
  DEFB $07,$FE,$07,$FC,$01,$F0,$01,$F0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$7C,$01,$CF,$01,$CE,$03,$FC
  DEFB $03,$F0,$03,$E0,$03,$F0,$03,$FC
  DEFB $01,$FE,$01,$FF,$00,$7C,$00,$28
  DEFB $00,$28,$00,$7C,$00,$00,$00,$00
  DEFB $3E,$00,$F3,$80,$73,$80,$3F,$C0
  DEFB $0F,$C0,$07,$C0,$0F,$C0,$3F,$C0
  DEFB $7F,$80,$FF,$80,$3E,$00,$14,$00
  DEFB $14,$00,$3E,$00,$00,$00,$00,$00
  DEFB $0F,$80,$3F,$E0,$7C,$E0,$1C,$F0
  DEFB $07,$F0,$01,$F0,$07,$F0,$1F,$F0
  DEFB $7F,$E0,$3F,$E0,$0F,$80,$0F,$80
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $03,$E0,$0F,$F8,$0E,$78,$1E,$7C
  DEFB $1F,$FC,$00,$7C,$1F,$FC,$1F,$FC
  DEFB $0F,$F8,$0F,$F8,$03,$E0,$01,$40
  DEFB $01,$40,$03,$E0,$00,$00,$00,$00
  DEFB $00,$F8,$03,$FE,$07,$CE,$01,$CF
  DEFB $00,$7F,$00,$1F,$00,$7F,$01,$FF
  DEFB $07,$FE,$03,$FE,$00,$F8,$00,$50
  DEFB $00,$50,$00,$50,$00,$50,$00,$F8

; The Vat (teleport: 236)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN6:
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$4D,$4D
  DEFB $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  DEFB $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$46
  DEFB $46,$4D,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$00,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$4D,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$02,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$04
  DEFB $04,$04,$04,$04,$00,$00,$46,$46
  DEFB $46,$4D,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$16,$02,$02,$4D
  DEFB $4D,$46,$46,$46,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$4D,$02,$02,$00,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$02,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$4D,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$00,$02,$02,$02,$4D
  DEFB $4D,$46,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$4D,$02,$02,$02,$02,$02,$16
  DEFB $02,$02,$02,$02,$02,$02,$02,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$46,$46
  DEFB $46,$4D,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$02,$4D
  DEFB $4D,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$00,$00,$00,$00
  DEFB $00,$4D,$02,$00,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$16,$02,$02,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$4D,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$00,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$4D,$4D
  DEFB $4D,$4D,$02,$02,$02,$02,$02,$16
  DEFB $02,$02,$02,$02,$02,$02,$02,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$46,$46,$46,$00,$00,$4D,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$4D
  DEFB $4D,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$4D,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$4D
  DEFB $4D,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$4D,$4D
  DEFB $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  DEFB $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "            The Vat             " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $46,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$AA,$55,$AA,$55,$AA,$55,$AA ; Crumbling floor
  DEFB $4D,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $04,$F4,$66,$F4,$00,$00,$00,$00,$00 ; Conveyor
  DEFB $15,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $16,$A5,$42,$3C,$DB,$3C,$7E,$A5,$24 ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $70A7              ; Location in the screen buffer at 28672: (5,7)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $13                ; Item 1 at (3,30)
  DEFW $5C7E
  DEFB $60
  DEFB $FF
  DEFB $14                ; Item 2 at (6,20)
  DEFW $5CD4
  DEFB $60
  DEFB $FF
  DEFB $15                ; Item 3 at (7,27)
  DEFW $5CFB
  DEFB $60
  DEFB $FF
  DEFB $16                ; Item 4 at (10,19)
  DEFW $5D53
  DEFB $68
  DEFB $FF
  DEFB $13                ; Item 5 at (11,30)
  DEFW $5D7E
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0B                ; Attribute
  DEFB $FF,$FF,$81,$81,$81,$81,$81,$81 ; Graphic data
  DEFB $81,$81,$81,$81,$81,$81,$FF,$FF
  DEFB $FF,$FF,$81,$81,$81,$81,$81,$81
  DEFB $81,$81,$81,$81,$81,$81,$FF,$FF
  DEFW $5DAF              ; Location in the attribute buffer at 23552: (13,15)
  DEFW $68AF              ; Location in the screen buffer at 24576: (13,15)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $45                ; Horizontal guardian 1: y=1, initial x=15,
  DEFW $5C2F              ; 15<=x<=29, speed=normal
  DEFB $60
  DEFB $00
  DEFB $2F
  DEFB $3D
  DEFB $43                ; Horizontal guardian 2: y=8, initial x=10, 2<=x<=10,
  DEFW $5D0A              ; speed=normal
  DEFB $68
  DEFB $07
  DEFB $02
  DEFB $0A
  DEFB $06                ; Horizontal guardian 3: y=13, initial x=17,
  DEFW $5DB1              ; 17<=x<=29, speed=normal
  DEFB $68
  DEFB $00
  DEFB $B1
  DEFB $BD
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $18,$00,$1C,$00,$0A,$80,$0F,$80 ; Guardian graphic data
  DEFB $0C,$00,$1C,$00,$1E,$00,$1D,$00
  DEFB $3C,$00,$3E,$00,$3E,$00,$6E,$00
  DEFB $44,$00,$42,$00,$81,$00,$00,$00
  DEFB $00,$00,$00,$00,$06,$00,$07,$00
  DEFB $02,$A0,$03,$E0,$03,$80,$07,$00
  DEFB $07,$80,$07,$40,$0F,$00,$0F,$80
  DEFB $0F,$80,$1B,$80,$33,$00,$40,$C0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$80,$01,$C0,$00,$A8,$00,$F8
  DEFB $00,$E0,$01,$C0,$01,$E0,$01,$D0
  DEFB $03,$C0,$03,$E0,$07,$E0,$3E,$F8
  DEFB $00,$00,$00,$00,$00,$60,$00,$70
  DEFB $00,$2A,$00,$3E,$00,$38,$00,$70
  DEFB $00,$78,$00,$74,$00,$F0,$00,$F8
  DEFB $01,$F8,$01,$B0,$03,$0C,$04,$00
  DEFB $00,$00,$00,$00,$06,$00,$0E,$00
  DEFB $54,$00,$7C,$00,$1C,$00,$0E,$00
  DEFB $1E,$00,$2E,$00,$0F,$00,$1F,$00
  DEFB $1F,$80,$0D,$80,$30,$C0,$00,$20
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$80,$03,$80,$15,$00,$1F,$00
  DEFB $07,$00,$03,$80,$07,$80,$0B,$80
  DEFB $03,$C0,$07,$C0,$07,$E0,$1F,$7C
  DEFB $00,$00,$00,$00,$00,$60,$00,$E0
  DEFB $05,$40,$07,$C0,$01,$C0,$00,$E0
  DEFB $01,$E0,$02,$E0,$00,$F0,$01,$F0
  DEFB $01,$F0,$01,$D8,$00,$CC,$03,$02
  DEFB $00,$18,$00,$38,$01,$50,$01,$F0
  DEFB $00,$30,$00,$38,$00,$78,$00,$B8
  DEFB $00,$3C,$00,$7C,$00,$7C,$00,$76
  DEFB $00,$22,$00,$42,$00,$81,$00,$00

; Miner Willy meets the Kong Beast (teleport: 1236)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN7:
  DEFB $72,$00,$05,$00,$00,$00,$06,$00 ; Attributes
  DEFB $00,$00,$05,$00,$00,$00,$00,$00
  DEFB $00,$72,$06,$00,$72,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$72,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$42
  DEFB $42,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$42,$42,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$42,$42,$42,$00,$00,$00,$00
  DEFB $00,$42,$42,$42,$42,$42,$42,$00
  DEFB $00,$72,$42,$42,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$42,$42,$42
  DEFB $42,$00,$00,$00,$00,$00,$42,$72
  DEFB $72,$00,$42,$42,$42,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$42,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $42,$42,$42,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$42,$42,$42,$42,$42,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$42,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$42,$42,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$42,$42,$42,$42,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$42,$42,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$42,$42,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$72,$00,$00,$00,$00,$42,$42
  DEFB $42,$42,$42,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$44,$44,$44,$72,$00
  DEFB $00,$72,$42,$42,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$72,$00
  DEFB $00,$72,$00,$00,$00,$00,$00,$04
  DEFB $00,$00,$00,$00,$00,$00,$00,$72
  DEFB $72,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$72
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "Miner Willy meets the Kong Beast" ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $42,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor (unused)
  DEFB $72,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $44,$F0,$66,$F0,$AA,$00,$00,$00,$00 ; Conveyor
  DEFB $04,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1
  DEFB $05,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2
  DEFB $06,$FF,$81,$81,$42,$3C,$10,$60,$60 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $78AB              ; Location in the screen buffer at 28672: (13,11)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (2,13)
  DEFW $5C4D
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (6,14)
  DEFW $5CCE
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (8,2)
  DEFW $5D02
  DEFB $68
  DEFB $FF
  DEFB $06                ; Item 4 at (13,29)
  DEFW $5DBD
  DEFB $68
  DEFB $FF
  DEFB $FF,$FF,$FF,$FF,$FF ; Item 5 (unused)
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $FF,$FF,$80,$01,$C0,$03,$A0,$05 ; Graphic data
  DEFB $90,$09,$C8,$13,$A4,$25,$92,$49
  DEFB $C9,$93,$A4,$25,$92,$49,$C9,$93
  DEFB $A4,$25,$C9,$93,$92,$49,$FF,$FF
  DEFW $5DAF              ; Location in the attribute buffer at 23552: (13,15)
  DEFW $68AF              ; Location in the screen buffer at 24576: (13,15)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $80,$C0,$EC,$72,$28,$54,$8A,$87 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $44                ; Horizontal guardian 1: y=13, initial x=9, 1<=x<=9,
  DEFW $5DA9              ; speed=normal
  DEFB $68
  DEFB $07
  DEFB $A1
  DEFB $A9
  DEFB $C3                ; Horizontal guardian 2: y=11, initial x=11,
  DEFW $5D6B              ; 11<=x<=15, speed=slow
  DEFB $68
  DEFB $00
  DEFB $6B
  DEFB $6F
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $05                ; Horizontal guardian 4: y=7, initial x=18,
  DEFW $5CF2              ; 18<=x<=21, speed=normal
  DEFB $60
  DEFB $00
  DEFB $F2
  DEFB $F5
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT; the first byte specifies
; the Kong Beast's initial status, but the second byte is not used.
  DEFB $00                ; Initial status (on the ledge)
  DEFB $00                ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $13,$C8,$1D,$B8,$0F,$F0,$06,$60 ; Guardian graphic data
  DEFB $05,$A0,$02,$40,$07,$E0,$0F,$F0
  DEFB $1F,$F8,$33,$CC,$63,$C6,$46,$62
  DEFB $2C,$34,$06,$60,$02,$40,$0E,$70
  DEFB $0B,$D0,$0D,$B0,$0F,$F0,$06,$60
  DEFB $05,$A0,$02,$40,$03,$C0,$1F,$F8
  DEFB $7F,$FE,$E7,$E7,$83,$C1,$C7,$E3
  DEFB $06,$60,$0C,$30,$08,$10,$38,$1C
  DEFB $1C,$38,$06,$60,$0C,$30,$66,$66
  DEFB $23,$C4,$67,$E6,$37,$EC,$1F,$F8
  DEFB $0F,$F0,$07,$E0,$02,$40,$05,$A0
  DEFB $06,$60,$0F,$F0,$0D,$B0,$0B,$D0
  DEFB $70,$0E,$18,$18,$0C,$30,$06,$60
  DEFB $63,$C6,$27,$E4,$67,$E6,$37,$EC
  DEFB $1F,$F8,$0F,$F0,$02,$40,$05,$A0
  DEFB $16,$68,$0F,$F0,$0D,$B0,$03,$C0
  DEFB $08,$00,$05,$00,$08,$80,$25,$00
  DEFB $48,$80,$21,$00,$4C,$00,$33,$00
  DEFB $44,$80,$44,$80,$88,$40,$84,$40
  DEFB $48,$80,$48,$80,$33,$00,$0C,$00
  DEFB $02,$00,$11,$20,$0A,$40,$11,$20
  DEFB $0A,$40,$10,$20,$03,$00,$0C,$C0
  DEFB $10,$20,$10,$60,$22,$90,$25,$10
  DEFB $18,$20,$10,$20,$0C,$C0,$03,$00
  DEFB $00,$40,$02,$20,$04,$48,$02,$24
  DEFB $04,$48,$02,$04,$00,$C8,$03,$30
  DEFB $04,$08,$04,$08,$0B,$44,$08,$B4
  DEFB $04,$08,$04,$08,$03,$30,$00,$C0
  DEFB $00,$44,$01,$22,$02,$44,$01,$22
  DEFB $02,$44,$01,$02,$02,$30,$00,$CC
  DEFB $01,$42,$01,$22,$02,$11,$02,$21
  DEFB $01,$12,$01,$0A,$00,$CC,$00,$30

; Wacky Amoebatrons (teleport: 46)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN8:
  DEFB $16,$00,$00,$16,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$06,$06,$06,$06,$00,$00,$06
  DEFB $06,$06,$00,$00,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$00,$00,$06,$06
  DEFB $06,$00,$00,$06,$06,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$16
  DEFB $16,$00,$00,$06,$06,$00,$00,$06
  DEFB $06,$06,$00,$00,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$06,$06
  DEFB $06,$00,$00,$06,$06,$00,$00,$16
  DEFB $16,$06,$06,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$06,$00,$00,$06
  DEFB $06,$06,$00,$00,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$00,$00,$06,$06
  DEFB $06,$00,$00,$06,$06,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$06,$06,$06,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$06,$06,$06,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "        Wacky Amoebatrons       " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $42,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor (unused)
  DEFB $16,$5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A ; Wall
  DEFB $04,$F0,$66,$F0,$66,$00,$00,$00,$00 ; Conveyor
  DEFB $44,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $05,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA1              ; Location in the attribute buffer at 23552: (13,1)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $780C              ; Location in the screen buffer at 28672: (8,12)
  DEFB $08                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (1,16)
  DEFW $5C30
  DEFB $60
  DEFB $FF
  DEFB $FF,$FF,$FF,$FF,$FF ; Item 2 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 3 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 4 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 5 (unused)
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $FF,$FF,$80,$01,$81,$81,$82,$41 ; Graphic data
  DEFB $84,$21,$88,$11,$90,$09,$A1,$85
  DEFB $A1,$85,$90,$09,$88,$11,$84,$21
  DEFB $82,$41,$81,$81,$80,$01,$FF,$FF
  DEFW $5C01              ; Location in the attribute buffer at 23552: (0,1)
  DEFW $6001              ; Location in the screen buffer at 24576: (0,1)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $44                ; Horizontal guardian 1: y=3, initial x=12,
  DEFW $5C6C              ; 12<=x<=18, speed=normal
  DEFB $60
  DEFB $00
  DEFB $6C
  DEFB $72
  DEFB $85                ; Horizontal guardian 2: y=10, initial x=16,
  DEFW $5D50              ; 12<=x<=18, speed=slow
  DEFB $68
  DEFB $00
  DEFB $4C
  DEFB $52
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $43                ; Vertical guardian 1: x=5, initial y=8, 5<=y<=100,
  DEFB $00                ; initial y-increment=1
  DEFB $08
  DEFB $05
  DEFB $01
  DEFB $05
  DEFB $64
  DEFB $04                ; Vertical guardian 2: x=10, initial y=8, 5<=y<=100,
  DEFB $01                ; initial y-increment=2
  DEFB $08
  DEFB $0A
  DEFB $02
  DEFB $05
  DEFB $64
  DEFB $05                ; Vertical guardian 3: x=20, initial y=8, 5<=y<=100,
  DEFB $02                ; initial y-increment=1
  DEFB $08
  DEFB $14
  DEFB $01
  DEFB $05
  DEFB $64
  DEFB $42                ; Vertical guardian 4: x=25, initial y=8, 5<=y<=100,
  DEFB $03                ; initial y-increment=2
  DEFB $08
  DEFB $19
  DEFB $02
  DEFB $05
  DEFB $64
  DEFB $FF                ; Terminator
; The next 6 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $0A,$20,$16,$68,$01,$50,$39,$62 ; Guardian graphic data
  DEFB $65,$CE,$03,$D0,$FF,$EE,$87,$F1
  DEFB $77,$E4,$C7,$FF,$8B,$F1,$32,$AC
  DEFB $64,$A6,$49,$A2,$12,$90,$36,$98
  DEFB $00,$00,$05,$20,$03,$40,$31,$74
  DEFB $1D,$CC,$03,$D0,$3F,$EC,$07,$F4
  DEFB $3F,$E0,$67,$FC,$0B,$F2,$32,$AC
  DEFB $24,$A4,$0B,$90,$1A,$D8,$00,$C0
  DEFB $00,$00,$00,$00,$02,$20,$09,$60
  DEFB $05,$C8,$03,$D0,$1F,$E0,$07,$F8
  DEFB $1F,$E0,$17,$F8,$0F,$F0,$12,$A8
  DEFB $05,$A0,$0A,$B0,$00,$C0,$00,$00
  DEFB $00,$00,$05,$20,$03,$40,$31,$74
  DEFB $1D,$CC,$03,$D0,$3F,$EC,$07,$F4
  DEFB $3F,$E0,$67,$FC,$0B,$F2,$32,$AC
  DEFB $24,$A4,$0B,$90,$1A,$D8,$00,$C0
  DEFB $0C,$00,$0C,$00,$0C,$00,$0C,$00
  DEFB $0C,$00,$0C,$00,$0C,$00,$0C,$00
  DEFB $0C,$00,$0C,$00,$FF,$C0,$0C,$00
  DEFB $61,$80,$D2,$C0,$B3,$40,$61,$80
  DEFB $03,$00,$03,$00,$03,$00,$03,$00
  DEFB $03,$00,$03,$00,$03,$00,$03,$00
  DEFB $03,$00,$03,$00,$3F,$F0,$03,$00
  DEFB $18,$60,$24,$D0,$3C,$D0,$18,$60
  DEFB $00,$C0,$00,$C0,$00,$C0,$00,$C0
  DEFB $00,$C0,$00,$C0,$00,$C0,$00,$C0
  DEFB $00,$C0,$00,$C0,$0F,$FC,$00,$C0
  DEFB $06,$18,$0B,$34,$0D,$2C,$06,$18
  DEFB $00,$30,$00,$30,$00,$30,$00,$30
  DEFB $00,$30,$00,$30,$00,$30,$00,$30
  DEFB $00,$30,$00,$30,$03,$FF,$00,$30
  DEFB $01,$86,$02,$4D,$03,$CD,$01,$86

; The Endorian Forest (teleport: 146)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN9:
  DEFB $16,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$04,$00,$44,$44,$44
  DEFB $16,$00,$04,$00,$04,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$04,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$44,$44,$44,$44,$44,$44,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$44,$44,$44,$44,$16
  DEFB $16,$00,$00,$04,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$44,$44,$44,$44,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $44,$02,$02,$02,$02,$02,$02,$02
  DEFB $16,$00,$00,$00,$00,$00,$00,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$16
  DEFB $16,$44,$44,$44,$44,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$44,$44,$44,$44,$44,$44,$44
  DEFB $02,$02,$02,$00,$00,$00,$00,$16
  DEFB $16,$44,$44,$44,$44,$44,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$04,$00,$00,$00,$00,$00,$00
  DEFB $00,$44,$44,$44,$44,$44,$44,$44
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$44,$44,$16
  DEFB $16,$44,$44,$44,$44,$02,$02,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$44,$44,$44,$44,$44,$44,$44
  DEFB $00,$00,$00,$00,$00,$00,$04,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$00,$00,$00,$00,$00,$04
  DEFB $02,$02,$02,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$44,$44,$44,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$44,$44,$44,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "       The Endorian Forest      " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$7C,$FF,$EF,$1E,$0C,$08,$08,$08 ; Floor
  DEFB $02,$FC,$FF,$87,$0C,$08,$08,$08,$00 ; Crumbling floor
  DEFB $16,$4A,$4A,$4A,$52,$54,$4A,$2A,$2A ; Wall
  DEFB $43,$F0,$66,$F0,$66,$00,$00,$00,$00 ; Conveyor (unused)
  DEFB $45,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $04,$48,$B2,$5D,$12,$70,$AE,$A9,$47 ; Nasty 2
  DEFB $05,$FF,$FF,$CA,$65,$92,$28,$82,$00 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $40                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5C81              ; Location in the attribute buffer at 23552: (4,1)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the (unused) conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7013              ; Location in the screen buffer at 28672: (0,19)
  DEFB $01                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (2,21)
  DEFW $5C55
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (1,14)
  DEFW $5C2E
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (6,12)
  DEFW $5CCC
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (8,18)
  DEFW $5D12
  DEFB $68
  DEFB $FF
  DEFB $03                ; Item 5 at (1,30)
  DEFW $5C3E
  DEFB $60
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $1E                ; Attribute
  DEFB $FF,$FF,$F8,$8F,$88,$91,$AA,$91 ; Graphic data
  DEFB $AA,$95,$8A,$85,$90,$91,$D5,$B9
  DEFB $D5,$55,$D1,$45,$89,$39,$89,$03
  DEFB $A8,$AB,$AA,$AB,$8A,$89,$FF,$FF
  DEFW $5DAC              ; Location in the attribute buffer at 23552: (13,12)
  DEFW $68AC              ; Location in the screen buffer at 24576: (13,12)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $08,$08,$3E,$5F,$5F,$47,$61,$3E ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $F8                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $46                ; Horizontal guardian 1: y=7, initial x=9, 9<=x<=14,
  DEFW $5CE9              ; speed=normal
  DEFB $60
  DEFB $00
  DEFB $E9
  DEFB $EE
  DEFB $C2                ; Horizontal guardian 2: y=10, initial x=12,
  DEFW $5D4C              ; 8<=x<=14, speed=slow
  DEFB $68
  DEFB $00
  DEFB $48
  DEFB $4E
  DEFB $43                ; Horizontal guardian 3: y=13, initial x=8, 4<=x<=26,
  DEFW $5DA8              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $A4
  DEFB $BA
  DEFB $05                ; Horizontal guardian 4: y=5, initial x=18,
  DEFW $5CB2              ; 17<=x<=21, speed=normal
  DEFB $60
  DEFB $00
  DEFB $B1
  DEFB $B5
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $70,$00,$50,$00,$7C,$00,$34,$00 ; Guardian graphic data
  DEFB $3E,$00,$3E,$00,$18,$00,$3C,$00
  DEFB $7E,$00,$7E,$00,$F7,$00,$FB,$00
  DEFB $3C,$00,$76,$00,$6E,$00,$77,$00
  DEFB $1C,$00,$14,$00,$1F,$00,$0D,$00
  DEFB $0F,$80,$0F,$80,$06,$00,$0F,$00
  DEFB $1B,$80,$1B,$80,$1B,$80,$1D,$80
  DEFB $0F,$00,$06,$00,$06,$00,$07,$00
  DEFB $07,$00,$05,$00,$07,$C0,$03,$40
  DEFB $03,$E0,$03,$E0,$01,$80,$03,$C0
  DEFB $07,$E0,$07,$E0,$0F,$70,$0F,$B0
  DEFB $03,$C0,$07,$60,$06,$E0,$07,$70
  DEFB $01,$C0,$01,$40,$01,$F0,$00,$D0
  DEFB $00,$F8,$00,$F8,$00,$60,$00,$F0
  DEFB $01,$F8,$03,$FC,$07,$FE,$06,$F6
  DEFB $00,$F8,$01,$DA,$03,$0E,$03,$84
  DEFB $03,$80,$06,$80,$0F,$80,$0B,$00
  DEFB $1F,$00,$1F,$00,$06,$00,$0F,$00
  DEFB $1F,$80,$3F,$C0,$7F,$E0,$6F,$60
  DEFB $1F,$00,$5B,$80,$70,$C0,$21,$C0
  DEFB $00,$E0,$01,$A0,$03,$E0,$02,$C0
  DEFB $07,$C0,$07,$C0,$01,$80,$03,$C0
  DEFB $07,$E0,$07,$E0,$0E,$F0,$0D,$F0
  DEFB $03,$C0,$06,$E0,$07,$60,$0E,$E0
  DEFB $00,$38,$00,$68,$00,$F8,$00,$B0
  DEFB $01,$F0,$01,$F0,$00,$60,$00,$F0
  DEFB $01,$F8,$01,$D8,$01,$D8,$01,$B8
  DEFB $00,$F0,$00,$60,$00,$60,$00,$E0
  DEFB $00,$0E,$00,$1A,$00,$3E,$00,$2C
  DEFB $00,$7C,$00,$7C,$00,$18,$00,$3C
  DEFB $00,$7E,$00,$7E,$00,$EF,$00,$DF
  DEFB $00,$3C,$00,$6E,$00,$76,$00,$EE

; Attack of the Mutant Telephones (teleport: 246)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN10:
  DEFB $0E,$0E,$0E,$0E,$0E,$0E,$0E,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$42,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$46,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$41,$41,$41,$41,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$41,$41,$41
  DEFB $41,$41,$41,$00,$00,$00,$00,$41
  DEFB $41,$45,$45,$45,$45,$45,$45,$45
  DEFB $41,$41,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $42,$00,$00,$00,$00,$41,$41,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $42,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$41,$41,$00,$00,$06,$06,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $42,$00,$00,$00,$00,$41,$41,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$00,$00,$00,$00
  DEFB $46,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$00,$00,$00
  DEFB $00,$00,$00,$42,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$41,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$01,$01
  DEFB $01,$41,$00,$00,$42,$00,$00,$00
  DEFB $00,$00,$00,$46,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$46,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$41,$41,$41,$0E
  DEFB $0E,$41,$41,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$41
  DEFB $41,$41,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$0E
  DEFB $0E,$41,$41,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$41,$41,$41,$0E
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "Attack of the Mutant Telephones " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $41,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $01,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $0E,$AA,$55,$AA,$55,$AA,$55,$AA,$55 ; Wall
  DEFB $06,$FE,$66,$FE,$00,$00,$00,$00,$00 ; Conveyor
  DEFB $46,$10,$10,$D6,$38,$D6,$38,$54,$92 ; Nasty 1
  DEFB $42,$10,$10,$10,$10,$10,$10,$10,$10 ; Nasty 2
  DEFB $45,$FF,$FF,$FF,$FF,$AA,$00,$00,$00 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $10                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5C23              ; Location in the attribute buffer at 23552: (1,3)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7805              ; Location in the screen buffer at 28672: (8,5)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (0,24)
  DEFW $5C18
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (1,30)
  DEFW $5C3E
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (4,1)
  DEFW $5C81
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (6,19)
  DEFW $5CD3
  DEFB $60
  DEFB $FF
  DEFB $03                ; Item 5 at (13,30)
  DEFW $5DBE
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $56                ; Attribute
  DEFB $FF,$FF,$DA,$AB,$EA,$6B,$FF,$FF ; Graphic data
  DEFB $90,$09,$90,$09,$FF,$FF,$90,$09
  DEFB $90,$09,$FF,$FF,$90,$09,$90,$09
  DEFB $FF,$FF,$90,$09,$90,$09,$FF,$FF
  DEFW $5C21              ; Location in the attribute buffer at 23552: (1,1)
  DEFW $6021              ; Location in the screen buffer at 24576: (1,1)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $3C,$5A,$95,$D5,$D5,$D5,$5A,$3C ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $46                ; Horizontal guardian 1: y=3, initial x=15,
  DEFW $5C6F              ; 15<=x<=24, speed=normal
  DEFB $60
  DEFB $00
  DEFB $6F
  DEFB $78
  DEFB $C4                ; Horizontal guardian 2: y=7, initial x=14,
  DEFW $5CEE              ; 14<=x<=18, speed=slow
  DEFB $60
  DEFB $00
  DEFB $EE
  DEFB $F2
  DEFB $42                ; Horizontal guardian 3: y=13, initial x=15,
  DEFW $5DAF              ; 5<=x<=19, speed=normal
  DEFB $68
  DEFB $07
  DEFB $A5
  DEFB $B3
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $43                ; Vertical guardian 1: x=12, initial y=8, 2<=y<=56,
  DEFB $00                ; initial y-increment=2
  DEFB $08
  DEFB $0C
  DEFB $02
  DEFB $02
  DEFB $38
  DEFB $04                ; Vertical guardian 2: x=3, initial y=32, 32<=y<=100,
  DEFB $01                ; initial y-increment=1
  DEFB $20
  DEFB $03
  DEFB $01
  DEFB $20
  DEFB $64
  DEFB $06                ; Vertical guardian 3: x=21, initial y=48,
  DEFB $02                ; 48<=y<=100, initial y-increment=1
  DEFB $30
  DEFB $15
  DEFB $01
  DEFB $30
  DEFB $64
  DEFB $42                ; Vertical guardian 4: x=26, initial y=48, 4<=y<=100,
  DEFB $03                ; initial y-increment=-3
  DEFB $30
  DEFB $1A
  DEFB $FD
  DEFB $04
  DEFB $64
  DEFB $FF                ; Terminator
; The next 6 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $00,$00,$00,$00,$3F,$FC,$63,$C6 ; Guardian graphic data
  DEFB $EB,$D7,$E8,$17,$0F,$F0,$07,$E0
  DEFB $0C,$30,$0B,$D0,$1B,$D8,$1C,$38
  DEFB $3F,$FC,$3F,$FC,$3F,$FC,$3F,$FC
  DEFB $3C,$00,$7F,$C0,$7F,$F8,$63,$C6
  DEFB $08,$57,$08,$17,$0F,$F7,$07,$E0
  DEFB $0C,$30,$0B,$D0,$1B,$D8,$1C,$38
  DEFB $3F,$FC,$3F,$FC,$3F,$FC,$3F,$FC
  DEFB $00,$00,$00,$00,$3F,$FC,$63,$C6
  DEFB $EB,$D7,$E8,$17,$0F,$F0,$07,$E0
  DEFB $0C,$30,$0B,$D0,$1B,$D8,$1C,$38
  DEFB $3F,$FC,$3F,$FC,$3F,$FC,$3F,$FC
  DEFB $00,$3C,$03,$FE,$1F,$FE,$63,$C6
  DEFB $EA,$10,$E8,$10,$EF,$F0,$07,$E0
  DEFB $0C,$30,$0B,$D0,$1B,$D8,$1C,$38
  DEFB $3F,$FC,$3F,$FC,$3F,$FC,$3F,$FC
  DEFB $0C,$00,$16,$00,$2D,$00,$4C,$80
  DEFB $8C,$40,$8C,$40,$4C,$80,$2D,$00
  DEFB $16,$00,$0C,$00,$37,$00,$4C,$00
  DEFB $7F,$C0,$FF,$C0,$40,$80,$2E,$00
  DEFB $03,$00,$03,$00,$05,$80,$07,$80
  DEFB $0B,$40,$0B,$40,$07,$80,$05,$80
  DEFB $03,$00,$03,$00,$0E,$C0,$03,$20
  DEFB $3F,$E0,$3F,$F0,$10,$20,$07,$40
  DEFB $00,$C0,$00,$C0,$00,$C0,$00,$C0
  DEFB $00,$80,$00,$80,$00,$C0,$00,$C0
  DEFB $00,$C0,$00,$C0,$01,$D0,$04,$C8
  DEFB $0F,$FC,$0F,$F8,$00,$08,$03,$B0
  DEFB $00,$30,$00,$68,$00,$B4,$00,$B4
  DEFB $01,$32,$01,$32,$00,$B4,$00,$B4
  DEFB $00,$68,$00,$30,$00,$B8,$01,$32
  DEFB $03,$FF,$01,$FF,$01,$00,$00,$DC

; Return of the Alien Kong Beast (teleport: 1246)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN11:
  DEFB $65,$00,$05,$00,$00,$00,$06,$00 ; Attributes
  DEFB $00,$00,$05,$00,$00,$00,$00,$00
  DEFB $00,$65,$06,$00,$00,$65,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$03
  DEFB $03,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$43,$43,$43,$00,$00,$00,$00
  DEFB $00,$03,$03,$03,$03,$03,$65,$00
  DEFB $00,$65,$03,$03,$03,$03,$03,$03
  DEFB $43,$43,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$65,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$43,$65
  DEFB $65,$00,$00,$00,$00,$00,$43,$43
  DEFB $00,$00,$00,$00,$00,$00,$65,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$43,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$65,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$43,$43,$43,$43,$43,$43,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$43,$43,$43,$43,$65,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$43,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$65,$43,$43,$43,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$43,$43,$00,$00,$00,$00,$65
  DEFB $65,$43,$43,$43,$43,$43,$43,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$04
  DEFB $00,$00,$00,$00,$04,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$43,$43,$43,$65,$00
  DEFB $00,$65,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$65,$00
  DEFB $00,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$43,$43,$43,$43,$43,$43,$43
  DEFB $43,$43,$43,$43,$43,$43,$65,$65
  DEFB $65,$65,$43,$43,$43,$43,$43,$43
  DEFB $43,$43,$43,$43,$43,$43,$43,$65
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM " Return of the Alien Kong Beast " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $43,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $03,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $65,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $46,$F0,$66,$F0,$AA,$00,$00,$00,$00 ; Conveyor
  DEFB $04,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1
  DEFB $05,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2
  DEFB $06,$FF,$81,$81,$42,$3C,$10,$60,$60 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $78B2              ; Location in the screen buffer at 28672: (13,18)
  DEFB $0B                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (3,15)
  DEFW $5C6F
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (7,16)
  DEFW $5CF0
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (6,2)
  DEFW $5CC2
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (13,29)
  DEFW $5DBD
  DEFB $68
  DEFB $FF
  DEFB $03                ; Item 5 at (5,26)
  DEFW $5CBA
  DEFB $60
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $5E                ; Attribute
  DEFB $FF,$FF,$80,$01,$8F,$F1,$8F,$F1 ; Graphic data
  DEFB $8F,$F1,$8F,$F1,$8F,$F1,$8C,$31
  DEFB $8C,$31,$8F,$F1,$8F,$F1,$8F,$F1
  DEFB $8F,$F1,$8F,$F1,$80,$01,$FF,$FF
  DEFW $5DAF              ; Location in the attribute buffer at 23552: (13,15)
  DEFW $68AF              ; Location in the screen buffer at 24576: (13,15)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $80,$C0,$EC,$72,$28,$54,$8A,$87 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $44                ; Horizontal guardian 1: y=13, initial x=9, 1<=x<=9,
  DEFW $5DA9              ; speed=normal
  DEFB $68
  DEFB $07
  DEFB $A1
  DEFB $A9
  DEFB $C6                ; Horizontal guardian 2: y=11, initial x=11,
  DEFW $5D6B              ; 11<=x<=15, speed=slow
  DEFB $68
  DEFB $00
  DEFB $6B
  DEFB $6F
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $05                ; Horizontal guardian 4: y=6, initial x=25,
  DEFW $5CD9              ; 25<=x<=28, speed=normal
  DEFB $60
  DEFB $00
  DEFB $D9
  DEFB $DC
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT; the first byte specifies
; the Kong Beast's initial status, but the second byte is not used.
  DEFB $00                ; Initial status (on the ledge)
  DEFB $00                ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $13,$C8,$1D,$B8,$0F,$F0,$06,$60 ; Guardian graphic data
  DEFB $05,$A0,$02,$40,$07,$E0,$0F,$F0
  DEFB $1F,$F8,$33,$CC,$63,$C6,$46,$62
  DEFB $2C,$34,$06,$60,$02,$40,$0E,$70
  DEFB $0B,$D0,$0D,$B0,$0F,$F0,$06,$60
  DEFB $05,$A0,$02,$40,$03,$C0,$1F,$F8
  DEFB $7F,$FE,$E7,$E7,$83,$C1,$C7,$E3
  DEFB $06,$60,$0C,$30,$08,$10,$38,$1C
  DEFB $1C,$38,$06,$60,$0C,$30,$66,$66
  DEFB $23,$C4,$67,$E6,$37,$EC,$1F,$F8
  DEFB $0F,$F0,$07,$E0,$02,$40,$05,$A0
  DEFB $06,$60,$0F,$F0,$0D,$B0,$0B,$D0
  DEFB $70,$0E,$18,$18,$0C,$30,$06,$60
  DEFB $63,$C6,$27,$E4,$67,$E6,$37,$EC
  DEFB $1F,$F8,$0F,$F0,$02,$40,$05,$A0
  DEFB $16,$68,$0F,$F0,$0D,$B0,$03,$C0
  DEFB $08,$00,$05,$00,$08,$80,$25,$00
  DEFB $48,$80,$21,$00,$4C,$00,$33,$00
  DEFB $44,$80,$44,$80,$88,$40,$84,$40
  DEFB $48,$80,$48,$80,$33,$00,$0C,$00
  DEFB $02,$00,$11,$20,$0A,$40,$11,$20
  DEFB $0A,$40,$10,$20,$03,$00,$0C,$C0
  DEFB $10,$20,$10,$60,$22,$90,$25,$10
  DEFB $18,$20,$10,$20,$0C,$C0,$03,$00
  DEFB $00,$40,$02,$20,$04,$48,$02,$24
  DEFB $04,$48,$02,$04,$00,$C8,$03,$30
  DEFB $04,$08,$04,$08,$0B,$44,$08,$B4
  DEFB $04,$08,$04,$08,$03,$30,$00,$C0
  DEFB $00,$44,$01,$22,$02,$44,$01,$22
  DEFB $02,$44,$01,$02,$02,$30,$00,$CC
  DEFB $01,$42,$01,$22,$02,$11,$02,$21
  DEFB $01,$12,$01,$0A,$00,$CC,$00,$30

; Ore Refinery (teleport: 346)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN12:
  DEFB $16,$16,$16,$16,$16,$16,$16,$16 ; Attributes
  DEFB $16,$16,$16,$16,$16,$16,$16,$16
  DEFB $16,$16,$16,$16,$16,$16,$16,$16
  DEFB $16,$16,$16,$16,$16,$16,$16,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$00,$00,$05,$05,$05,$05,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$05
  DEFB $05,$00,$00,$05,$05,$05,$05,$00
  DEFB $00,$05,$05,$05,$05,$05,$00,$00
  DEFB $05,$05,$05,$05,$00,$00,$05,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$05
  DEFB $05,$05,$05,$05,$00,$00,$05,$05
  DEFB $05,$00,$00,$00,$05,$05,$05,$05
  DEFB $05,$00,$00,$05,$05,$05,$05,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$05
  DEFB $05,$05,$00,$00,$05,$05,$05,$00
  DEFB $00,$05,$05,$05,$05,$00,$00,$05
  DEFB $05,$05,$05,$00,$00,$05,$05,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$06,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$05,$05,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$05,$05,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "          Ore Refinery          " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $05,$FF,$FF,$11,$22,$44,$88,$FF,$FF ; Floor
  DEFB $42,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor (unused)
  DEFB $16,$5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A ; Wall
  DEFB $04,$F0,$66,$F0,$66,$00,$00,$00,$00 ; Conveyor
  DEFB $44,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $45,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2 (unused)
  DEFB $06,$FF,$81,$81,$81,$81,$81,$81,$81 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DBD              ; Location in the attribute buffer at 23552: (13,29)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $78E3              ; Location in the screen buffer at 28672: (15,3)
  DEFB $1A                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (3,26)
  DEFW $5C7A
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (6,10)
  DEFW $5CCA
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (9,19)
  DEFW $5D33
  DEFB $68
  DEFB $FF
  DEFB $06                ; Item 4 at (9,26)
  DEFW $5D3A
  DEFB $68
  DEFB $FF
  DEFB $03                ; Item 5 at (12,11)
  DEFW $5D8B
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $4F                ; Attribute
  DEFB $03,$C0,$07,$E0,$0F,$F0,$09,$90 ; Graphic data
  DEFB $09,$90,$07,$E0,$05,$A0,$02,$40
  DEFB $61,$86,$F8,$1F,$FE,$7F,$05,$E0
  DEFB $07,$A0,$FE,$7F,$F8,$1F,$60,$06
  DEFW $5DA1              ; Location in the attribute buffer at 23552: (13,1)
  DEFW $68A1              ; Location in the screen buffer at 24576: (13,1)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$6E,$42,$DB,$C9,$62,$7E,$18 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $FC                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $43                ; Horizontal guardian 1: y=1, initial x=7, 7<=x<=29,
  DEFW $5C27              ; speed=normal
  DEFB $60
  DEFB $00
  DEFB $27
  DEFB $3D
  DEFB $C4                ; Horizontal guardian 2: y=4, initial x=16, 7<=x<=29,
  DEFW $5C90              ; speed=slow
  DEFB $60
  DEFB $00
  DEFB $87
  DEFB $9D
  DEFB $46                ; Horizontal guardian 3: y=7, initial x=20,
  DEFW $5CF4              ; 10<=x<=26, speed=normal
  DEFB $60
  DEFB $07
  DEFB $EA
  DEFB $FA
  DEFB $C2                ; Horizontal guardian 4: y=10, initial x=18,
  DEFW $5D52              ; 7<=x<=29, speed=slow
  DEFB $68
  DEFB $00
  DEFB $47
  DEFB $5D
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $47                ; Vertical guardian 1: x=5, initial y=8, 8<=y<=100,
  DEFB $00                ; initial y-increment=2
  DEFB $08
  DEFB $05
  DEFB $02
  DEFB $08
  DEFB $64
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $00,$00,$00,$00,$00,$00,$03,$C0 ; Guardian graphic data
  DEFB $0C,$30,$10,$08,$20,$04,$40,$02
  DEFB $80,$01,$40,$02,$20,$04,$D0,$0B
  DEFB $2C,$34,$4B,$D2,$12,$48,$02,$40
  DEFB $00,$00,$00,$00,$00,$00,$03,$C0
  DEFB $0C,$30,$10,$08,$20,$04,$40,$02
  DEFB $F8,$1F,$57,$EA,$2B,$D4,$12,$48
  DEFB $0C,$30,$03,$C0,$00,$00,$00,$00
  DEFB $04,$20,$04,$20,$12,$48,$4B,$D2
  DEFB $2C,$34,$93,$C9,$A7,$E5,$46,$62
  DEFB $86,$61,$47,$E2,$23,$C4,$10,$08
  DEFB $0C,$30,$03,$C0,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$03,$C0
  DEFB $0C,$30,$12,$48,$2A,$54,$5F,$FA
  DEFB $F6,$7F,$47,$E2,$23,$C4,$10,$08
  DEFB $0C,$30,$03,$C0,$00,$00,$00,$00
  DEFB $61,$80,$B2,$40,$B3,$C0,$61,$80
  DEFB $0C,$00,$FF,$C0,$52,$80,$12,$00
  DEFB $12,$00,$1E,$00,$0C,$00,$0C,$00
  DEFB $0C,$00,$0C,$00,$1E,$00,$3F,$00
  DEFB $18,$60,$24,$D0,$3C,$D0,$18,$60
  DEFB $03,$00,$3F,$F0,$14,$A0,$04,$80
  DEFB $04,$80,$07,$80,$03,$00,$03,$00
  DEFB $07,$80,$0F,$C0,$00,$00,$00,$00
  DEFB $06,$18,$0D,$3C,$0D,$24,$06,$18
  DEFB $00,$C0,$0F,$FC,$05,$28,$01,$20
  DEFB $01,$20,$01,$E0,$01,$E0,$03,$F0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$86,$03,$CB,$02,$4B,$01,$86
  DEFB $00,$30,$03,$FF,$01,$4A,$00,$48
  DEFB $00,$48,$00,$78,$00,$30,$00,$30
  DEFB $00,$78,$00,$FC,$00,$00,$00,$00

; Skylab Landing Bay (teleport: 1346)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN13:
  DEFB $68,$08,$08,$08,$08,$08,$08,$08 ; Attributes
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$4C
  DEFB $0C,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$4C,$0C,$08,$08,$08
  DEFB $08,$08,$08,$4C,$0C,$08,$08,$08
  DEFB $08,$08,$08,$4C,$0C,$08,$08,$08
  DEFB $08,$08,$08,$4C,$0C,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$4C
  DEFB $0C,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$4C
  DEFB $0C,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$4C,$0C,$08
  DEFB $08,$08,$08,$08,$08,$4C,$0C,$08
  DEFB $08,$08,$08,$08,$08,$4C,$0C,$08
  DEFB $08,$08,$08,$08,$08,$4C,$0C,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$4C,$0C,$08,$08,$08,$08,$08
  DEFB $08,$4C,$0C,$08,$08,$08,$08,$4B
  DEFB $4B,$4B,$4B,$4B,$4B,$08,$08,$08
  DEFB $08,$4C,$0C,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$4C
  DEFB $0C,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$08
  DEFB $08,$08,$08,$08,$08,$08,$08,$68
  DEFB $68,$68,$68,$68,$68,$68,$68,$68
  DEFB $68,$68,$68,$68,$68,$68,$68,$68
  DEFB $68,$68,$68,$68,$68,$68,$68,$68
  DEFB $68,$68,$68,$68,$68,$68,$68,$68
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "       Skylab Landing Bay       " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $4C,$FF,$FF,$62,$64,$78,$70,$60,$60 ; Floor
  DEFB $02,$FC,$FF,$FF,$87,$FF,$08,$08,$00 ; Crumbling floor (unused)
  DEFB $68,$01,$82,$C4,$E8,$E0,$D8,$BC,$7E ; Wall
  DEFB $4B,$F0,$66,$F0,$66,$00,$00,$00,$00 ; Conveyor
  DEFB $00,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $00,$48,$B2,$5D,$12,$70,$AE,$A9,$47 ; Nasty 2 (unused)
  DEFB $0C,$FF,$FF,$46,$26,$1E,$0E,$06,$06 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DBD              ; Location in the attribute buffer at 23552: (13,29)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $786F              ; Location in the screen buffer at 28672: (11,15)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $06                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $0B                ; Item 1 at (2,23)
  DEFW $5C57
  DEFB $60
  DEFB $FF
  DEFB $0C                ; Item 2 at (8,3)
  DEFW $5D03
  DEFB $68
  DEFB $FF
  DEFB $0D                ; Item 3 at (7,27)
  DEFW $5CFB
  DEFB $60
  DEFB $FF
  DEFB $0E                ; Item 4 at (7,16)
  DEFW $5CF0
  DEFB $60
  DEFB $FF
  DEFB $00,$FF,$FF,$FF,$FF ; Item 5 (unused)
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $1E                ; Attribute
  DEFB $FF,$FF,$FF,$FF,$FC,$3F,$F8,$1F ; Graphic data
  DEFB $F0,$0F,$E0,$07,$C1,$83,$C2,$43
  DEFB $C2,$43,$C1,$83,$E0,$07,$F0,$0F
  DEFB $F8,$1F,$FC,$3F,$FF,$FF,$FF,$FF
  DEFW $5C0F              ; Location in the attribute buffer at 23552: (0,15)
  DEFW $600F              ; Location in the screen buffer at 24576: (0,15)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $AA,$AA,$FE,$FE,$FE,$FE,$AA,$AA ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $F8                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $FF                ; Horizontal guardian 1: y=7, initial x=9, 9<=x<=14,
  DEFW $5CE9              ; speed=slow (unused)
  DEFB $60
  DEFB $00
  DEFB $E9
  DEFB $EE
  DEFB $C2                ; Horizontal guardian 2: y=10, initial x=12,
  DEFW $5D4C              ; 8<=x<=14, speed=slow (unused)
  DEFB $68
  DEFB $00
  DEFB $48
  DEFB $4E
  DEFB $43                ; Horizontal guardian 3: y=13, initial x=8, 4<=x<=26,
  DEFW $5DA8              ; speed=normal (unused)
  DEFB $68
  DEFB $00
  DEFB $A4
  DEFB $BA
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $0F                ; Vertical guardian 1: x=1, initial y=0, 0<=y<=72,
  DEFB $00                ; y-increment=4
  DEFB $00
  DEFB $01
  DEFB $04
  DEFB $00
  DEFB $48
  DEFB $0D                ; Vertical guardian 2: x=11, initial y=0, 0<=y<=32,
  DEFB $00                ; y-increment=1
  DEFB $00
  DEFB $0B
  DEFB $01
  DEFB $00
  DEFB $20
  DEFB $0E                ; Vertical guardian 3: x=21, initial y=2, 2<=y<=56,
  DEFB $00                ; y-increment=3
  DEFB $02
  DEFB $15
  DEFB $03
  DEFB $02
  DEFB $38
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $03,$C0,$FF,$FF,$AB,$D5,$FF,$FF ; Guardian graphic data
  DEFB $13,$C8,$29,$94,$15,$A8,$0B,$D0
  DEFB $05,$A0,$03,$C0,$03,$C0,$05,$A0
  DEFB $0A,$50,$14,$28,$28,$14,$10,$08
  DEFB $00,$00,$00,$00,$03,$C0,$FF,$FF
  DEFB $AB,$D5,$FF,$FF,$13,$C8,$29,$94
  DEFB $15,$A8,$0B,$D0,$05,$A0,$03,$C0
  DEFB $03,$C0,$25,$A0,$4A,$54,$14,$2A
  DEFB $00,$00,$00,$00,$00,$00,$00,$07
  DEFB $03,$FD,$FF,$D7,$AB,$F8,$FF,$C0
  DEFB $03,$C0,$01,$80,$15,$A4,$4B,$D2
  DEFB $05,$A4,$23,$C2,$0B,$D0,$25,$A8
  DEFB $00,$00,$00,$00,$00,$00,$00,$20
  DEFB $02,$02,$00,$15,$03,$CE,$0F,$D4
  DEFB $CB,$C8,$B7,$C2,$E3,$C8,$31,$81
  DEFB $07,$E4,$C3,$C8,$17,$C2,$23,$FC
  DEFB $00,$00,$01,$00,$00,$00,$08,$20
  DEFB $00,$00,$00,$00,$21,$02,$00,$11
  DEFB $03,$8A,$0E,$90,$4B,$C0,$37,$02
  DEFB $62,$C0,$31,$01,$05,$E2,$C3,$44
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$02,$00,$00,$00,$00,$20
  DEFB $10,$08,$0A,$84,$00,$20,$65,$00
  DEFB $22,$68,$08,$A0,$03,$D0,$17,$E0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $02,$00,$00,$20,$10,$00,$00,$00
  DEFB $05,$10,$00,$68,$22,$A0,$0D,$D0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$80
  DEFB $00,$20,$08,$00,$02,$C0,$07,$60

; The Bank (teleport: 2346)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN14:
  DEFB $0E,$00,$00,$00,$00,$00,$0E,$0E ; Attributes
  DEFB $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  DEFB $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  DEFB $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $45,$45,$45,$45,$45,$45,$45,$45
  DEFB $45,$45,$45,$45,$45,$45,$45,$45
  DEFB $41,$41,$41,$41,$41,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $42,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$06,$06,$0E
  DEFB $0E,$41,$41,$41,$41,$41,$00,$00
  DEFB $46,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $41,$41,$00,$00,$42,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$01
  DEFB $00,$00,$00,$00,$41,$41,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$06,$06,$0E
  DEFB $0E,$00,$00,$41,$41,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$41,$41,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$41,$41,$00,$42,$06,$06,$0E
  DEFB $0E,$41,$41,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$41,$41,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$46,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$41,$41,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$41,$41,$41
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$41
  DEFB $41,$00,$00,$00,$00,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$41,$41,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$0E
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$06,$06,$0E
  DEFB $0E,$41,$41,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$41,$41,$41,$41
  DEFB $41,$41,$41,$41,$41,$41,$41,$0E
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "            The Bank            " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $41,$FF,$FF,$DD,$77,$AA,$55,$22,$00 ; Floor
  DEFB $01,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $0E,$AA,$55,$AA,$55,$AA,$55,$AA,$55 ; Wall
  DEFB $45,$FE,$66,$FE,$00,$00,$00,$00,$00 ; Conveyor
  DEFB $46,$10,$10,$D6,$38,$D6,$38,$54,$92 ; Nasty 1
  DEFB $42,$10,$10,$10,$10,$10,$10,$10,$10 ; Nasty 2
  DEFB $06,$FF,$FF,$18,$18,$18,$18,$18,$18 ; Extra
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7068              ; Location in the screen buffer at 28672: (3,8)
  DEFB $10                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (2,25)
  DEFW $5C59
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (6,12)
  DEFW $5CCC
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (14,26)
  DEFW $5DDA
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Item 4 at (6,19) (unused)
  DEFW $5CD3
  DEFB $60
  DEFB $FF
  DEFB $03                ; Item 5 at (13,30) (unused)
  DEFW $5DBE
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $56                ; Attribute
  DEFB $FF,$FF,$80,$01,$80,$01,$80,$01 ; Graphic data
  DEFB $80,$01,$88,$01,$AA,$01,$9C,$3D
  DEFB $FF,$47,$9C,$01,$AA,$01,$88,$01
  DEFB $80,$01,$80,$01,$80,$01,$FF,$FF
  DEFW $5C61              ; Location in the attribute buffer at 23552: (3,1)
  DEFW $6061              ; Location in the screen buffer at 24576: (3,1)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $7C,$38,$64,$DE,$8E,$DE,$82,$7C ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $FC                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $45                ; Horizontal guardian 1: y=13, initial x=17,
  DEFW $5DB1              ; 17<=x<=19, speed=normal
  DEFB $68
  DEFB $00
  DEFB $B1
  DEFB $B3
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $06                ; Vertical guardian 1: x=9, initial y=40, 36<=y<=102,
  DEFB $00                ; initial y-increment=2
  DEFB $28
  DEFB $09
  DEFB $02
  DEFB $24
  DEFB $66
  DEFB $07                ; Vertical guardian 2: x=15, initial y=64,
  DEFB $01                ; 36<=y<=102, initial y-increment=1
  DEFB $40
  DEFB $0F
  DEFB $01
  DEFB $24
  DEFB $66
  DEFB $44                ; Vertical guardian 3: x=21, initial y=80,
  DEFB $03                ; 32<=y<=104, initial y-increment=-3
  DEFB $50
  DEFB $15
  DEFB $FD
  DEFB $20
  DEFB $68
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next 6 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $61,$86,$9F,$F9,$9F,$F9,$61,$86 ; Guardian graphic data
  DEFB $03,$C0,$FF,$FF,$80,$01,$AA,$A9
  DEFB $9F,$FD,$B5,$59,$90,$0D,$B5,$59
  DEFB $9F,$FD,$AA,$A9,$80,$01,$FF,$FF
  DEFB $1D,$B8,$22,$F4,$22,$F4,$1D,$B8
  DEFB $03,$C0,$FF,$FF,$D5,$55,$BF,$FF
  DEFB $EA,$AD,$B0,$07,$E5,$4D,$B0,$07
  DEFB $EA,$AD,$BF,$FF,$D5,$55,$FF,$FF
  DEFB $07,$E0,$08,$10,$08,$10,$07,$E0
  DEFB $03,$C0,$FF,$FF,$FF,$FF,$D5,$57
  DEFB $E0,$03,$CA,$A7,$E7,$F3,$CA,$A7
  DEFB $E0,$03,$D5,$57,$FF,$FF,$FF,$FF
  DEFB $1D,$B8,$2F,$44,$2F,$44,$1D,$B8
  DEFB $03,$C0,$FF,$FF,$AA,$AB,$C0,$01
  DEFB $95,$53,$CF,$F9,$9A,$B3,$CF,$F9
  DEFB $95,$53,$C0,$01,$AA,$AB,$FF,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$FF,$C0,$81,$C0
  DEFB $FF,$C0,$82,$40,$FE,$40,$FF,$C0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$3F,$F0,$20,$70
  DEFB $3F,$F0,$20,$90,$3F,$90,$3F,$F0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $0F,$FC,$08,$1C,$0F,$FC,$08,$24
  DEFB $0F,$E4,$0F,$FC,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$03,$FF,$02,$07
  DEFB $03,$FF,$02,$09,$03,$F9,$03,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00

; The Sixteenth Cavern (teleport: 12346)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN15:
  DEFB $65,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$42,$00,$00,$00,$00,$42,$00
  DEFB $00,$00,$00,$65,$00,$00,$65,$00
  DEFB $00,$00,$00,$00,$00,$00,$42,$42
  DEFB $42,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$65,$00,$00,$65,$65
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$42,$00,$00,$00
  DEFB $00,$00,$00,$65,$00,$00,$65,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$42,$42,$42,$42,$42,$42,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$65,$00,$00,$65,$65
  DEFB $65,$65,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$02,$02,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$65,$65,$42,$42,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$42,$00,$00,$00,$00,$65
  DEFB $65,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$00,$00,$00
  DEFB $00,$00,$42,$00,$00,$00,$00,$65
  DEFB $65,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$04
  DEFB $04,$04,$00,$00,$00,$00,$00,$65
  DEFB $65,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$65
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "      The Sixteenth Cavern      " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $42,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $65,$49,$F9,$4F,$49,$FF,$48,$78,$CF ; Wall
  DEFB $46,$F0,$66,$F0,$AA,$00,$00,$00,$00 ; Conveyor
  DEFB $04,$44,$44,$44,$44,$66,$EE,$EE,$FF ; Nasty 1
  DEFB $05,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2 (unused)
  DEFB $06,$FF,$81,$81,$42,$3C,$10,$60,$60 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DA2              ; Location in the attribute buffer at 23552: (13,2)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7823              ; Location in the screen buffer at 28672: (9,3)
  DEFB $18                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (2,30)
  DEFW $5C5E
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (7,13)
  DEFW $5CED
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (0,1)
  DEFW $5C01
  DEFB $60
  DEFB $FF
  DEFB $06                ; Item 4 at (10,17)
  DEFW $5D51
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Item 5 at (5,26) (unused)
  DEFW $5CBA
  DEFB $60
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $5E                ; Attribute
  DEFB $FF,$FF,$81,$81,$81,$81,$FF,$FF ; Graphic data
  DEFB $81,$81,$81,$81,$FF,$FF,$81,$81
  DEFB $81,$81,$FF,$FF,$81,$81,$81,$81
  DEFB $FF,$FF,$81,$81,$81,$81,$FF,$FF
  DEFW $5CAC              ; Location in the attribute buffer at 23552: (5,12)
  DEFW $60AC              ; Location in the screen buffer at 24576: (5,12)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $0F,$09,$3D,$27,$F4,$9C,$90,$F0 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $F8                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $44                ; Horizontal guardian 1: y=13, initial x=9, 1<=x<=18,
  DEFW $5DA9              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $A1
  DEFB $B2
  DEFB $06                ; Horizontal guardian 2: y=10, initial x=1, 1<=x<=7,
  DEFW $5D41              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $41
  DEFB $47
  DEFB $43                ; Horizontal guardian 3: y=7, initial x=18,
  DEFW $5CF2              ; 18<=x<=23, speed=normal
  DEFB $60
  DEFB $00
  DEFB $F2
  DEFB $F7
  DEFB $85                ; Horizontal guardian 4: y=5, initial x=26,
  DEFW $5CBA              ; 25<=x<=29, speed=slow
  DEFB $60
  DEFB $00
  DEFB $B9
  DEFB $BD
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 1 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $00,$00,$08,$00,$14,$00,$2A,$00 ; Guardian graphic data
  DEFB $55,$00,$4A,$00,$84,$00,$80,$C0
  DEFB $80,$C0,$41,$00,$7F,$80,$3F,$C0
  DEFB $1F,$80,$0F,$00,$0A,$80,$12,$40
  DEFB $2A,$00,$15,$00,$2A,$00,$15,$00
  DEFB $20,$00,$20,$00,$20,$00,$20,$30
  DEFB $20,$30,$10,$40,$1F,$E0,$0F,$F0
  DEFB $07,$E0,$03,$C0,$02,$A0,$04,$90
  DEFB $00,$00,$10,$00,$28,$00,$54,$00
  DEFB $AA,$00,$51,$00,$21,$00,$01,$0C
  DEFB $02,$0C,$02,$10,$03,$F8,$03,$FC
  DEFB $01,$F8,$00,$F0,$00,$A8,$01,$24
  DEFB $05,$40,$0A,$80,$05,$40,$0A,$80
  DEFB $00,$40,$00,$40,$00,$40,$00,$43
  DEFB $00,$83,$00,$84,$00,$FE,$00,$FF
  DEFB $00,$7E,$00,$3C,$00,$2A,$00,$49
  DEFB $02,$A0,$01,$50,$02,$A0,$01,$50
  DEFB $02,$00,$02,$00,$02,$00,$C2,$00
  DEFB $C1,$00,$21,$00,$7F,$00,$FF,$00
  DEFB $7E,$00,$3C,$00,$54,$00,$92,$00
  DEFB $00,$00,$00,$08,$00,$14,$00,$2A
  DEFB $00,$55,$00,$8A,$00,$84,$30,$80
  DEFB $30,$40,$08,$40,$1F,$C0,$3F,$C0
  DEFB $1F,$80,$0F,$00,$15,$00,$24,$80
  DEFB $00,$54,$00,$A8,$00,$54,$00,$A8
  DEFB $00,$04,$00,$04,$00,$04,$0C,$04
  DEFB $0C,$04,$02,$08,$07,$F8,$0F,$F0
  DEFB $07,$E0,$03,$C0,$05,$40,$09,$20
  DEFB $00,$00,$00,$10,$00,$28,$00,$54
  DEFB $00,$AA,$00,$52,$00,$21,$03,$01
  DEFB $03,$01,$00,$82,$01,$FE,$03,$FC
  DEFB $01,$F8,$00,$F0,$01,$50,$02,$48

; The Warehouse (teleport: 56)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN16:
  DEFB $16,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$16,$16,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$06,$00
  DEFB $00,$06,$00,$00,$00,$06,$00,$00
  DEFB $06,$00,$00,$00,$00,$00,$06,$00
  DEFB $06,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$04,$04,$44,$44,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$44
  DEFB $00,$44,$44,$00,$00,$04,$04,$16
  DEFB $16,$44,$44,$21,$44,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$16
  DEFB $16,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$44,$00
  DEFB $44,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$21,$00,$00,$44,$44,$16
  DEFB $16,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$20,$20
  DEFB $20,$20,$20,$00,$00,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$16
  DEFB $16,$00,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$16
  DEFB $16,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$44,$44
  DEFB $44,$44,$44,$00,$44,$44,$21,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$16
  DEFB $16,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$21,$00,$00,$44,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$00,$00,$00,$44,$44,$16
  DEFB $16,$44,$44,$00,$00,$44,$44,$44
  DEFB $44,$44,$00,$00,$44,$44,$44,$44
  DEFB $44,$44,$44,$44,$44,$44,$44,$44
  DEFB $44,$44,$44,$00,$00,$44,$44,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$04,$04,$04,$04,$16
  DEFB $16,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "         The Warehouse          " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $44,$FF,$AA,$55,$AA,$55,$AA,$55,$AA ; Crumbling floor
  DEFB $16,$FF,$99,$BB,$FF,$FF,$99,$BB,$FF ; Wall
  DEFB $20,$F0,$66,$F0,$66,$00,$00,$00,$00 ; Conveyor
  DEFB $06,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1
  DEFB $21,$42,$D7,$FE,$65,$A6,$7D,$EE,$D7 ; Nasty 2
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $30                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $03                ; Animation frame (see FRAME)
  DEFB $01                ; Direction and movement flags: facing left (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5C61              ; Location in the attribute buffer at 23552: (3,1)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $780E              ; Location in the screen buffer at 28672: (8,14)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $23                ; Item 1 at (5,24)
  DEFW $5CB8
  DEFB $60
  DEFB $FF
  DEFB $24                ; Item 2 at (7,15)
  DEFW $5CEF
  DEFB $60
  DEFB $FF
  DEFB $25                ; Item 3 at (9,1)
  DEFW $5D21
  DEFB $68
  DEFB $FF
  DEFB $26                ; Item 4 at (10,19)
  DEFW $5D53
  DEFB $68
  DEFB $FF
  DEFB $23                ; Item 5 at (11,26)
  DEFW $5D7A
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $4C                ; Attribute
  DEFB $FF,$FF,$80,$01,$BF,$FD,$A0,$05 ; Graphic data
  DEFB $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  DEFB $A5,$A5,$A5,$A5,$AF,$F5,$A5,$A5
  DEFB $A5,$A5,$A5,$A5,$A5,$A5,$FF,$FF
  DEFW $5C3D              ; Location in the attribute buffer at 23552: (1,29)
  DEFW $603D              ; Location in the screen buffer at 24576: (1,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $C2                ; Horizontal guardian 1: y=13, initial x=5, 5<=x<=8,
  DEFW $5DA5              ; speed=slow
  DEFB $68
  DEFB $00
  DEFB $A5
  DEFB $A8
  DEFB $05                ; Horizontal guardian 2: y=13, initial x=12,
  DEFW $5DAC              ; 12<=x<=25, speed=normal
  DEFB $68
  DEFB $00
  DEFB $AC
  DEFB $B9
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $41                ; Vertical guardian 1: x=3, initial y=64, 64<=y<=102,
  DEFB $00                ; initial y-increment=2
  DEFB $40
  DEFB $03
  DEFB $02
  DEFB $40
  DEFB $66
  DEFB $06                ; Vertical guardian 2: x=10, initial y=64, 3<=y<=96,
  DEFB $01                ; initial y-increment=-3
  DEFB $40
  DEFB $0A
  DEFB $FD
  DEFB $03
  DEFB $60
  DEFB $47                ; Vertical guardian 3: x=19, initial y=48, 0<=y<=64,
  DEFB $02                ; initial y-increment=1
  DEFB $30
  DEFB $13
  DEFB $01
  DEFB $00
  DEFB $40
  DEFB $43                ; Vertical guardian 4: x=27, initial y=0, 4<=y<=96,
  DEFB $03                ; initial y-increment=4
  DEFB $00
  DEFB $1B
  DEFB $04
  DEFB $04
  DEFB $60
  DEFB $FF                ; Terminator
; The next 6 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $55,$55,$FF,$FF,$FF,$FF,$08,$10 ; Guardian graphic data
  DEFB $08,$10,$08,$10,$F8,$1F,$55,$55
  DEFB $FF,$FF,$FF,$FF,$08,$10,$08,$10
  DEFB $08,$10,$58,$15,$FF,$FF,$FF,$FF
  DEFB $00,$00,$55,$55,$FF,$FF,$FF,$FF
  DEFB $08,$10,$F8,$1F,$08,$10,$3F,$FE
  DEFB $38,$1E,$08,$10,$5F,$F5,$FF,$FF
  DEFB $FF,$FF,$00,$00,$FF,$FF,$00,$00
  DEFB $00,$00,$00,$00,$FF,$FF,$55,$55
  DEFB $FF,$FF,$FF,$FF,$08,$10,$38,$1E
  DEFB $3F,$FE,$08,$10,$F8,$1F,$5F,$F5
  DEFB $FF,$FF,$FF,$FF,$00,$00,$00,$00
  DEFB $00,$00,$55,$55,$FF,$FF,$F8,$1F
  DEFB $08,$10,$55,$55,$FF,$FF,$FF,$FF
  DEFB $78,$1D,$F8,$1F,$F8,$1F,$08,$10
  DEFB $55,$55,$FF,$FF,$FF,$FF,$00,$00
  DEFB $7E,$00,$99,$00,$FF,$00,$DB,$00
  DEFB $E7,$00,$7E,$00,$24,$00,$24,$00
  DEFB $24,$00,$42,$00,$42,$00,$42,$00
  DEFB $81,$00,$81,$00,$C3,$00,$C3,$00
  DEFB $00,$00,$1F,$80,$26,$40,$3F,$C0
  DEFB $36,$C0,$39,$C0,$1F,$80,$10,$80
  DEFB $20,$40,$20,$40,$40,$20,$40,$20
  DEFB $80,$10,$80,$30,$C0,$30,$C0,$00
  DEFB $00,$00,$00,$00,$00,$00,$07,$E0
  DEFB $09,$90,$0F,$F0,$0D,$B0,$0E,$70
  DEFB $07,$E0,$08,$10,$10,$08,$20,$04
  DEFB $40,$02,$80,$01,$C0,$03,$C0,$03
  DEFB $00,$00,$01,$F8,$02,$64,$03,$FC
  DEFB $03,$6C,$03,$9C,$01,$F8,$01,$08
  DEFB $02,$04,$02,$04,$04,$02,$04,$02
  DEFB $08,$01,$0C,$01,$0C,$03,$00,$03

; Amoebatrons' Revenge (teleport: 156)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN17:
  DEFB $16,$00,$00,$00,$00,$00,$00,$00 ; Attributes
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$16,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$42,$42,$00,$00,$42
  DEFB $42,$42,$00,$00,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$00,$00,$42,$42
  DEFB $42,$00,$00,$42,$42,$42,$42,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$42,$42,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$00,$00,$42,$42
  DEFB $42,$00,$00,$42,$42,$00,$00,$16
  DEFB $16,$00,$00,$42,$42,$00,$00,$42
  DEFB $42,$42,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$42,$42,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$42,$42,$00,$00,$42
  DEFB $42,$42,$00,$00,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$00,$00,$42,$42
  DEFB $42,$00,$00,$42,$42,$00,$00,$16
  DEFB $16,$42,$42,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $16,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$16
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "      Amoebatrons' Revenge      " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $42,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor (unused)
  DEFB $16,$FF,$81,$81,$FF,$FF,$81,$81,$FF ; Wall
  DEFB $04,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor (unused)
  DEFB $44,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $05,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $03                ; Animation frame (see FRAME)
  DEFB $01                ; Direction and movement flags: facing left (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DBD              ; Location in the attribute buffer at 23552: (13,29)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the (unused) conveyor.
  DEFB $01                ; Direction (right)
  DEFW $7827              ; Location in the screen buffer at 28672: (9,7)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (1,16)
  DEFW $5C30
  DEFB $60
  DEFB $FF
  DEFB $FF,$FF,$FF,$FF,$FF ; Item 2 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 3 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 4 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 5 (unused)
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $0E                ; Attribute
  DEFB $FF,$FF,$80,$01,$B0,$0D,$A0,$05 ; Graphic data
  DEFB $AA,$55,$AA,$55,$AA,$55,$AA,$55
  DEFB $AA,$55,$AA,$55,$AA,$55,$AA,$55
  DEFB $A0,$05,$B0,$0D,$80,$01,$FF,$FF
  DEFW $5C1D              ; Location in the attribute buffer at 23552: (0,29)
  DEFW $601D              ; Location in the screen buffer at 24576: (0,29)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $80                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $C4                ; Horizontal guardian 1: y=3, initial x=12,
  DEFW $5C6C              ; 12<=x<=18, speed=slow
  DEFB $60
  DEFB $00
  DEFB $6C
  DEFB $72
  DEFB $85                ; Horizontal guardian 2: y=10, initial x=16,
  DEFW $5D50              ; 12<=x<=17, speed=slow
  DEFB $68
  DEFB $00
  DEFB $4C
  DEFB $51
  DEFB $43                ; Horizontal guardian 3: y=6, initial x=16,
  DEFW $5CD0              ; 12<=x<=17, speed=normal
  DEFB $60
  DEFB $00
  DEFB $CC
  DEFB $D1
  DEFB $06                ; Horizontal guardian 4: y=13, initial x=16,
  DEFW $5DB0              ; 12<=x<=18, speed=normal
  DEFB $68
  DEFB $07
  DEFB $AC
  DEFB $B2
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $43                ; Vertical guardian 1: x=5, initial y=8, 5<=y<=104,
  DEFB $00                ; initial y-increment=3
  DEFB $08
  DEFB $05
  DEFB $03
  DEFB $05
  DEFB $68
  DEFB $04                ; Vertical guardian 2: x=10, initial y=8, 5<=y<=104,
  DEFB $01                ; initial y-increment=2
  DEFB $08
  DEFB $0A
  DEFB $02
  DEFB $05
  DEFB $68
  DEFB $05                ; Vertical guardian 3: x=20, initial y=8, 5<=y<=104,
  DEFB $02                ; initial y-increment=4
  DEFB $08
  DEFB $14
  DEFB $04
  DEFB $05
  DEFB $68
  DEFB $06                ; Vertical guardian 4: x=25, initial y=8, 5<=y<=104,
  DEFB $03                ; initial y-increment=1
  DEFB $08
  DEFB $19
  DEFB $01
  DEFB $05
  DEFB $68
  DEFB $FF                ; Terminator
; The next 6 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $03,$C0,$0E,$70,$13,$C8,$31,$8C ; Guardian graphic data
  DEFB $39,$9C,$5F,$FA,$8D,$B2,$84,$A4
  DEFB $49,$24,$29,$12,$24,$89,$42,$49
  DEFB $82,$52,$04,$90,$08,$88,$00,$40
  DEFB $03,$C0,$0E,$70,$13,$C8,$31,$8C
  DEFB $39,$9C,$5F,$FA,$4D,$B1,$85,$11
  DEFB $84,$92,$48,$A4,$29,$24,$29,$12
  DEFB $44,$89,$02,$48,$02,$50,$04,$00
  DEFB $03,$C0,$0E,$70,$13,$C8,$31,$8C
  DEFB $39,$9C,$5F,$FA,$4D,$B1,$44,$91
  DEFB $82,$49,$82,$4A,$44,$94,$25,$24
  DEFB $29,$22,$08,$90,$04,$48,$00,$40
  DEFB $03,$C0,$0E,$70,$13,$C8,$31,$8C
  DEFB $39,$9C,$5F,$FA,$4D,$B2,$29,$12
  DEFB $24,$91,$42,$49,$82,$4A,$84,$4A
  DEFB $48,$91,$09,$20,$09,$00,$00,$80
  DEFB $0C,$00,$0C,$00,$0C,$00,$0C,$00
  DEFB $0C,$00,$0C,$00,$0C,$00,$0C,$00
  DEFB $0C,$00,$0C,$00,$FF,$C0,$0C,$00
  DEFB $61,$80,$D2,$C0,$B3,$40,$61,$80
  DEFB $03,$00,$03,$00,$03,$00,$03,$00
  DEFB $03,$00,$03,$00,$03,$00,$03,$00
  DEFB $03,$00,$03,$00,$3F,$F0,$03,$00
  DEFB $18,$60,$24,$D0,$3C,$D0,$18,$60
  DEFB $00,$C0,$00,$C0,$00,$C0,$00,$C0
  DEFB $00,$C0,$00,$C0,$00,$C0,$00,$C0
  DEFB $00,$C0,$00,$C0,$0F,$FC,$00,$C0
  DEFB $06,$18,$0B,$34,$0D,$2C,$06,$18
  DEFB $00,$30,$00,$30,$00,$30,$00,$30
  DEFB $00,$30,$00,$30,$00,$30,$00,$30
  DEFB $00,$30,$00,$30,$03,$FF,$00,$30
  DEFB $01,$86,$02,$4D,$03,$CD,$01,$86

; Solar Power Generator (teleport: 256)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN18:
  DEFB $16,$16,$16,$24,$24,$24,$24,$24 ; Attributes
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$20,$20,$24,$24,$24
  DEFB $24,$20,$20,$20,$20,$20,$20,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $20,$20,$20,$20,$20,$20,$20,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$20,$20,$20,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$20,$20,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$20,$20,$20
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $20,$20,$20,$20,$20,$20,$20,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$20,$20,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$20,$20,$20,$20,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $20,$20,$20,$20,$20,$20,$20,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$26
  DEFB $26,$26,$26,$24,$24,$24,$20,$20
  DEFB $20,$20,$20,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$16,$16,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$24
  DEFB $24,$24,$24,$24,$24,$24,$24,$16
  DEFB $16,$16,$16,$20,$20,$20,$20,$20
  DEFB $20,$20,$20,$20,$20,$20,$20,$20
  DEFB $20,$20,$20,$20,$20,$20,$20,$16
  DEFB $20,$20,$20,$20,$20,$20,$20,$16
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "     Solar Power Generator      " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $24,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $20,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor (unused)
  DEFB $16,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $26,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor
  DEFB $44,$44,$28,$94,$51,$35,$D6,$58,$10 ; Nasty 1 (unused)
  DEFB $05,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $A0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $00                ; Direction and movement flags: facing right (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5D4E              ; Location in the attribute buffer at 23552: (10,14)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $7887              ; Location in the screen buffer at 28672: (12,7)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $03                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $23                ; Item 1 at (1,30)
  DEFW $5C3E
  DEFB $60
  DEFB $FF
  DEFB $24                ; Item 2 at (5,1)
  DEFW $5CA1
  DEFB $60
  DEFB $FF
  DEFB $25                ; Item 3 at (12,30)
  DEFW $5D9E
  DEFB $68
  DEFB $FF
  DEFB $FF,$FF,$FF,$FF,$FF ; Item 4 (unused)
  DEFB $00,$FF,$FF,$FF,$FF ; Item 5 (unused)
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $4E                ; Attribute
  DEFB $FF,$FF,$80,$01,$BF,$FD,$A0,$05 ; Graphic data
  DEFB $AF,$F5,$A8,$15,$AB,$D5,$AA,$55
  DEFB $AA,$55,$AB,$D5,$A8,$15,$AF,$F5
  DEFB $A0,$05,$BF,$FD,$80,$01,$FF,$FF
  DEFW $5C21              ; Location in the attribute buffer at 23552: (1,1)
  DEFW $6021              ; Location in the screen buffer at 24576: (1,1)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $F0                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $26                ; Horizontal guardian 1: y=3, initial x=24,
  DEFW $5C78              ; 23<=x<=29, speed=normal
  DEFB $60
  DEFB $00
  DEFB $77
  DEFB $7D
  DEFB $21                ; Horizontal guardian 2: y=6, initial x=28,
  DEFW $5CDC              ; 22<=x<=29, speed=normal
  DEFB $60
  DEFB $00
  DEFB $D6
  DEFB $DD
  DEFB $A2                ; Horizontal guardian 3: y=9, initial x=29,
  DEFW $5D3D              ; 23<=x<=29, speed=slow
  DEFB $68
  DEFB $07
  DEFB $37
  DEFB $3D
  DEFB $26                ; Horizontal guardian 4: y=13, initial x=16,
  DEFW $5DB0              ; 13<=x<=29, speed=normal
  DEFB $68
  DEFB $00
  DEFB $AD
  DEFB $BD
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $26                ; Vertical guardian 1: x=5, initial y=64, 2<=y<=102,
  DEFB $00                ; initial y-increment=3
  DEFB $40
  DEFB $05
  DEFB $03
  DEFB $02
  DEFB $66
  DEFB $22                ; Vertical guardian 2: x=11, initial y=56,
  DEFB $01                ; 48<=y<=102, initial y-increment=-2
  DEFB $38
  DEFB $0B
  DEFB $FE
  DEFB $30
  DEFB $66
  DEFB $21                ; Vertical guardian 3: x=16, initial y=80, 4<=y<=80,
  DEFB $02                ; initial y-increment=1
  DEFB $50
  DEFB $10
  DEFB $01
  DEFB $04
  DEFB $50
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $03,$40,$0F,$70,$3F,$3C,$3F,$4C ; Guardian graphic data
  DEFB $5F,$66,$5F,$76,$9F,$7F,$00,$7F
  DEFB $8E,$00,$8E,$FF,$46,$FE,$40,$F2
  DEFB $20,$04,$30,$0C,$0C,$30,$02,$C0
  DEFB $03,$C0,$0F,$F0,$3F,$AC,$3F,$CC
  DEFB $5F,$C6,$47,$B6,$99,$BF,$9E,$7F
  DEFB $8E,$7F,$8D,$9F,$45,$E6,$41,$F2
  DEFB $20,$04,$30,$0C,$0C,$30,$03,$C0
  DEFB $03,$C0,$0F,$F0,$2F,$BC,$37,$C8
  DEFB $5B,$E6,$5D,$E6,$9E,$DF,$9E,$3F
  DEFB $8C,$7F,$8B,$7F,$47,$BE,$41,$C2
  DEFB $00,$04,$30,$04,$0C,$30,$03,$C0
  DEFB $03,$C0,$0B,$F0,$3D,$BC,$3D,$CC
  DEFB $5D,$E6,$5E,$F4,$9E,$E3,$9E,$1F
  DEFB $88,$7F,$87,$7F,$07,$7E,$41,$B2
  DEFB $20,$04,$30,$0C,$0C,$10,$03,$C0
  DEFB $06,$00,$0C,$00,$18,$00,$38,$00
  DEFB $74,$00,$CA,$80,$85,$C0,$03,$C0
  DEFB $06,$40,$CE,$C0,$D8,$40,$FF,$C0
  DEFB $E2,$00,$C8,$80,$D5,$40,$08,$80
  DEFB $01,$80,$03,$00,$06,$00,$0E,$00
  DEFB $1D,$00,$32,$A0,$21,$70,$00,$F0
  DEFB $01,$90,$63,$B0,$66,$10,$7F,$F0
  DEFB $78,$80,$62,$20,$65,$50,$02,$20
  DEFB $00,$60,$00,$C0,$01,$80,$03,$80
  DEFB $07,$40,$0C,$A8,$08,$5C,$00,$3C
  DEFB $00,$64,$30,$EC,$31,$84,$3F,$FC
  DEFB $3E,$20,$30,$88,$31,$54,$00,$88
  DEFB $00,$18,$00,$30,$00,$60,$00,$E0
  DEFB $01,$D0,$03,$2A,$02,$17,$00,$0F
  DEFB $00,$19,$06,$3B,$06,$61,$07,$FF
  DEFB $07,$88,$06,$22,$06,$55,$00,$22

; The Final Barrier (teleport: 1256)
;
; Used by the routine at STARTGAME.
;
; The first 512 bytes are the attributes that define the layout of the cavern.
CAVERN19:
  DEFB $2C,$22,$22,$22,$22,$22,$2C,$28 ; Attributes
  DEFB $28,$28,$28,$28,$2F,$2F,$2F,$2F
  DEFB $2F,$28,$28,$28,$28,$28,$2E,$32
  DEFB $32,$2E,$28,$28,$28,$28,$28,$28
  DEFB $2C,$22,$22,$22,$22,$22,$2C,$28
  DEFB $28,$2F,$28,$28,$2F,$2F,$2F,$2F
  DEFB $2F,$28,$28,$28,$28,$28,$3A,$38
  DEFB $38,$3A,$28,$28,$28,$2A,$2A,$2A
  DEFB $2C,$22,$22,$16,$22,$2C,$2E,$2E
  DEFB $2E,$2E,$2E,$2E,$2F,$2F,$2F,$2F
  DEFB $2F,$2E,$2B,$2E,$2B,$2E,$3A,$38
  DEFB $38,$3A,$2F,$2F,$2F,$2A,$2A,$2A
  DEFB $28,$2C,$2C,$16,$2C,$2E,$2E,$2E
  DEFB $2E,$2E,$2E,$2E,$2E,$28,$28,$28
  DEFB $2C,$2C,$2C,$2C,$2C,$2C,$3A,$3A
  DEFB $3A,$3A,$2F,$2F,$2F,$28,$2A,$28
  DEFB $28,$2F,$28,$16,$28,$2E,$2E,$2E
  DEFB $2E,$2E,$2E,$2E,$2E,$2C,$2C,$2C
  DEFB $26,$26,$26,$26,$26,$26,$26,$26
  DEFB $26,$26,$26,$26,$26,$26,$26,$26
  DEFB $28,$2C,$2C,$16,$2C,$2E,$2E,$2E
  DEFB $2E,$2E,$2E,$2E,$2E,$27,$26,$26
  DEFB $26,$26,$26,$00,$00,$26,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $0C,$26,$26,$26,$26,$21,$21,$21
  DEFB $0E,$0E,$21,$21,$21,$27,$26,$26
  DEFB $26,$26,$26,$00,$00,$26,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $26,$26,$26,$26,$26,$26,$26,$26
  DEFB $26,$26,$26,$26,$26,$26,$26,$26
  DEFB $26,$26,$26,$00,$00,$26,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $26,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$42,$42,$26
  DEFB $26,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $26,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$05
  DEFB $05,$05,$05,$05,$05,$05,$05,$00
  DEFB $00,$00,$02,$00,$00,$00,$00,$26
  DEFB $26,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$44,$00,$00,$44,$00,$00,$00
  DEFB $00,$44,$00,$00,$00,$44,$00,$00
  DEFB $00,$00,$00,$00,$42,$00,$00,$26
  DEFB $26,$42,$42,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $26,$00,$00,$00,$00,$42,$42,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $26,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$26
  DEFB $26,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$42
  DEFB $42,$42,$42,$42,$42,$42,$42,$26
; The next 32 bytes are copied to CAVERNNAME and specify the cavern name.
  DEFM "        The Final Barrier       " ; Cavern name
; The next 72 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the cavern.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $42,$FF,$FF,$DB,$6E,$C5,$40,$00,$00 ; Floor
  DEFB $02,$FF,$DB,$A5,$24,$52,$20,$08,$00 ; Crumbling floor
  DEFB $26,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $05,$F0,$66,$F0,$66,$00,$99,$FF,$00 ; Conveyor
  DEFB $44,$10,$10,$D6,$38,$D6,$38,$54,$92 ; Nasty 1
  DEFB $0A,$7E,$3C,$1C,$18,$18,$08,$08,$08 ; Nasty 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Extra (unused)
; The next seven bytes are copied to 8068-806E and specify Miner Willy's
; initial location and appearance in the cavern.
  DEFB $D0                ; Pixel y-coordinate * 2 (see PIXEL_Y)
  DEFB $00                ; Animation frame (see FRAME)
  DEFB $01                ; Direction and movement flags: facing left (see
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (see AIRBORNE)
  DEFW $5DBB              ; Location in the attribute buffer at 23552: (13,27)
                          ; (see LOCATION)
  DEFB $00                ; Jumping animation counter (see JUMPING)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $7841              ; Location in the screen buffer at 28672: (10,1)
  DEFB $16                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next byte is copied to ITEMATTR, but is not used.
  DEFB $00                ; Unused
; The next 25 bytes are copied to ITEMS and specify the location and initial
; colour of the items in the cavern.
  DEFB $03                ; Item 1 at (5,23)
  DEFW $5CB7
  DEFB $60
  DEFB $FF
  DEFB $04                ; Item 2 at (6,30)
  DEFW $5CDE
  DEFB $60
  DEFB $FF
  DEFB $05                ; Item 3 at (11,10)
  DEFW $5D6A
  DEFB $68
  DEFB $FF
  DEFB $06                ; Item 4 at (11,14)
  DEFW $5D6E
  DEFB $68
  DEFB $FF
  DEFB $03                ; Item 5 at (11,19)
  DEFW $5D73
  DEFB $68
  DEFB $FF
  DEFB $FF                ; Terminator
; The next 37 bytes are copied to PORTAL and define the portal graphic and its
; location.
  DEFB $1E                ; Attribute
  DEFB $00,$00,$07,$E0,$18,$18,$23,$C4 ; Graphic data
  DEFB $44,$22,$48,$12,$48,$12,$48,$12
  DEFB $44,$22,$22,$44,$1A,$58,$4A,$52
  DEFB $7A,$5E,$42,$42,$7E,$7E,$00,$00
  DEFW $5CB3              ; Location in the attribute buffer at 23552: (5,19)
  DEFW $60B3              ; Location in the screen buffer at 24576: (5,19)
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$48,$88,$90,$68,$04,$0A,$04 ; Item graphic data
; The next byte is copied to AIR and specifies the initial air supply in the
; cavern.
  DEFB $3F                ; Air
; The next byte is copied to CLOCK and initialises the game clock.
  DEFB $FC                ; Game clock
; The next 28 bytes are copied to HGUARDS and define the horizontal guardians.
  DEFB $46                ; Horizontal guardian 1: y=13, initial x=7, 7<=x<=22,
  DEFW $5DA7              ; speed=normal
  DEFB $68
  DEFB $00
  DEFB $A7
  DEFB $B6
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Horizontal guardian 4 (unused)
  DEFB $FF                ; Terminator
; The next two bytes are copied to EUGDIR and EUGHGT but are not used.
  DEFB $00,$00            ; Unused
; The next 28 bytes are copied to VGUARDS and define the vertical guardians.
  DEFB $07                ; Vertical guardian 1: x=24, initial y=48,
  DEFB $00                ; 40<=y<=103, initial y-increment=1
  DEFB $30
  DEFB $18
  DEFB $01
  DEFB $28
  DEFB $67
  DEFB $FF,$00,$00,$00,$00,$00,$00 ; Vertical guardian 2 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 3 (unused)
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Vertical guardian 4 (unused)
; The next 7 bytes are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00 ; Unused
; The next 256 bytes are copied to GGDATA and define the guardian graphics.
  DEFB $00,$00,$00,$00,$00,$00,$03,$C0 ; Guardian graphic data
  DEFB $0C,$30,$10,$08,$20,$04,$40,$02
  DEFB $80,$01,$40,$02,$20,$04,$D0,$0B
  DEFB $2C,$34,$4B,$D2,$12,$48,$02,$40
  DEFB $00,$00,$00,$00,$00,$00,$03,$C0
  DEFB $0C,$30,$10,$08,$20,$04,$40,$02
  DEFB $F8,$1F,$57,$EA,$2B,$D4,$12,$48
  DEFB $0C,$30,$03,$C0,$00,$00,$00,$00
  DEFB $04,$20,$04,$20,$12,$48,$4B,$D2
  DEFB $2C,$34,$93,$C9,$A7,$E5,$46,$62
  DEFB $86,$61,$47,$E2,$23,$C4,$10,$08
  DEFB $0C,$30,$03,$C0,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$03,$C0
  DEFB $0C,$30,$12,$48,$2A,$54,$5F,$FA
  DEFB $F6,$7F,$47,$E2,$23,$C4,$10,$08
  DEFB $0C,$30,$03,$C0,$00,$00,$00,$00
  DEFB $12,$00,$0C,$00,$1E,$00,$BF,$40
  DEFB $73,$80,$73,$80,$BF,$40,$5E,$80
  DEFB $4C,$80,$52,$80,$7F,$80,$0C,$00
  DEFB $61,$80,$92,$C0,$B2,$40,$61,$80
  DEFB $03,$00,$07,$80,$07,$80,$1C,$E0
  DEFB $3B,$70,$3B,$70,$1C,$E0,$17,$A0
  DEFB $17,$A0,$13,$20,$1F,$E0,$03,$00
  DEFB $18,$60,$24,$90,$34,$B0,$18,$60
  DEFB $01,$E0,$01,$E0,$01,$20,$0E,$DC
  DEFB $0D,$EC,$0D,$EC,$0E,$DC,$05,$28
  DEFB $05,$E8,$05,$E8,$07,$F8,$00,$C0
  DEFB $06,$18,$0D,$24,$09,$34,$06,$18
  DEFB $00,$78,$00,$48,$00,$30,$03,$7B
  DEFB $02,$FD,$02,$FD,$03,$7B,$01,$32
  DEFB $01,$4A,$01,$7A,$01,$FE,$00,$30
  DEFB $01,$86,$02,$CD,$02,$49,$01,$86

  END BEGIN

