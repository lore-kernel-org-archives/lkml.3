Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328Ab3BLOzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:55:54 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:40424 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691Ab3BLOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 05/10] cris/kgb: Make symbols used from asm global
Date: Tue, 12 Feb 2013 15:52:52 +0100
Message-Id: <1360680777-12622-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_breakpoint':
(.text+0x2c3e): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_breakpoint':
(.text+0x2c48): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_breakpoint':
(.text+0x2c50): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_breakpoint':
(.text+0x2c58): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_breakpoint':
(.text+0x2c60): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o:(.text+0x2c68): more undefined references to `reg' follow
arch/cris/arch-v10/kernel/built-in.o: In function `is_static':
kgdb.c:(.text+0x2d46): undefined reference to `internal_stack'
kgdb.c:(.text+0x2d4e): undefined reference to `handle_exception'
kgdb.c:(.text+0x2d54): undefined reference to `reg'
kgdb.c:(.text+0x2d5c): undefined reference to `reg'
kgdb.c:(.text+0x2d64): undefined reference to `reg'
kgdb.c:(.text+0x2d6c): undefined reference to `reg'
kgdb.c:(.text+0x2d74): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o:kgdb.c:(.text+0x2d7c): more undefined references to `reg' follow
arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_serial':
(.text+0x2ef6): undefined reference to `internal_stack'
arch/cris/arch-v10/kernel/built-in.o: In function `kgdb_handle_serial':
(.text+0x2efe): undefined reference to `handle_exception'
arch/cris/arch-v10/kernel/built-in.o: In function `goback':
kgdb.c:(.text+0x2f04): undefined reference to `reg'
kgdb.c:(.text+0x2f0c): undefined reference to `reg'
kgdb.c:(.text+0x2f14): undefined reference to `reg'
kgdb.c:(.text+0x2f1c): undefined reference to `reg'
kgdb.c:(.text+0x2f24): undefined reference to `reg'
arch/cris/arch-v10/kernel/built-in.o:kgdb.c:(.text+0x2f2c): more undefined references to `reg' follow

Make reg, internal_stack, and handle_exception global to fix this.
Rename reg to cris_reg as it's a too generic name for a global symbol.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |  218 +++++++++++++++++++-------------------
 1 files changed, 109 insertions(+), 109 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index e02d2df..7e24b73 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -329,7 +329,7 @@ static int register_size[] =
 
 /* Contains the register image of the executing thread in the assembler
    part of the code in order to avoid horrible addressing modes. */
-static registers reg;
+registers cris_reg;
 
 /* FIXME: Should this be used? Delete otherwise. */
 /* Contains the assumed consistency state of the register image. Uses the
@@ -337,7 +337,7 @@ static registers reg;
 static int consistency_status = SUCCESS;
 
 /********************************** Handle exceptions ************************/
-/* The variable reg contains the register image associated with the
+/* The variable cris_reg contains the register image associated with the
    current_thread_c variable. It is a complete register image created at
    entry. The reg_g contains a register image of a task where the general
    registers are taken from the stack and all special registers are taken
@@ -351,14 +351,14 @@ static int current_thread_c = 0;
 static int current_thread_g = 0;
 
 /* Need two register images in order to handle Hct and Hgt commands. The
-   variable reg_g is in addition to reg above. */
+   variable reg_g is in addition to cris_reg above. */
 static registers reg_g;
 #endif /* PROCESS_SUPPORT */
 
 /********************************** Breakpoint *******************************/
 /* Use an internal stack in the breakpoint and interrupt response routines */
 #define INTERNAL_STACK_SIZE 1024
-static char internal_stack[INTERNAL_STACK_SIZE];
+char internal_stack[INTERNAL_STACK_SIZE];
 
 /* Due to the breakpoint return pointer, a state variable is needed to keep
    track of whether it is a static (compiled) or dynamic (gdb-invoked)
@@ -667,7 +667,7 @@ static int
 write_register (int regno, char *val)
 {
 	int status = SUCCESS;
-	registers *current_reg = &reg;
+	registers *current_reg = &cris_reg;
 
         if (regno >= R0 && regno <= PC) {
 		/* 32-bit register with simple offset. */
@@ -737,7 +737,7 @@ write_stack_register (int thread_id, int regno, char *valptr)
 static int
 read_register (char regno, unsigned int *valptr)
 {
-	registers *current_reg = &reg;
+	registers *current_reg = &cris_reg;
 
 	if (regno >= R0 && regno <= PC) {
 		/* 32-bit register with simple offset. */
@@ -825,7 +825,7 @@ stub_is_stopped(int sigval)
 
 	/* A struct assignment translates into a libc memcpy call. Avoid
 	   all libc functions in order to prevent recursive break points. */
-	copy_registers (&reg_g, &reg, sizeof(registers));
+	copy_registers (&reg_g, &cris_reg, sizeof(registers));
 
 	/* Store thread:r...; with the executing task TID. */
 	gdb_cris_strcpy (&remcomOutBuffer[pos], "thread:");
@@ -851,7 +851,7 @@ kill_restart (void)
 
 /* All expected commands are sent from remote.c. Send a response according
    to the description in remote.c. */
-static void
+void
 handle_exception (int sigval)
 {
 	/* Avoid warning of not used. */
@@ -877,14 +877,14 @@ handle_exception (int sigval)
 				{
 #ifdef PROCESS_SUPPORT
 					/* Use the special register content in the executing thread. */
-					copy_registers (&reg_g, &reg, sizeof(registers));
+					copy_registers (&reg_g, &cris_reg, sizeof(registers));
 					/* Replace the content available on the stack. */
 					if (current_thread_g != executing_task) {
 						copy_registers_from_stack (current_thread_g, &reg_g);
 					}
 					mem2hex ((unsigned char *)remcomOutBuffer, (unsigned char *)&reg_g, sizeof(registers));
 #else
-					mem2hex(remcomOutBuffer, (char *)&reg, sizeof(registers));
+					mem2hex(remcomOutBuffer, (char *)&cris_reg, sizeof(registers));
 #endif
 				}
 				break;
@@ -897,13 +897,13 @@ handle_exception (int sigval)
 #ifdef PROCESS_SUPPORT
 				hex2mem ((unsigned char *)&reg_g, &remcomInBuffer[1], sizeof(registers));
 				if (current_thread_g == executing_task) {
-					copy_registers (&reg, &reg_g, sizeof(registers));
+					copy_registers (&cris_reg, &reg_g, sizeof(registers));
 				}
 				else {
 					copy_registers_to_stack(current_thread_g, &reg_g);
 				}
 #else
-				hex2mem((char *)&reg, &remcomInBuffer[1], sizeof(registers));
+				hex2mem((char *)&cris_reg, &remcomInBuffer[1], sizeof(registers));
 #endif
 				gdb_cris_strcpy (remcomOutBuffer, "OK");
 				break;
@@ -1004,7 +1004,7 @@ handle_exception (int sigval)
 				   Success: return to the executing thread.
 				   Failure: will never know. */
 				if (remcomInBuffer[1] != '\0') {
-					reg.pc = gdb_cris_strtol (&remcomInBuffer[1], 0, 16);
+					cris_reg.pc = gdb_cris_strtol (&remcomInBuffer[1], 0, 16);
 				}
 				enableDebugIRQ();
 				return;
@@ -1202,37 +1202,37 @@ asm ("\n"
 ";;\n"
 ";; Create a register image of the caller\n"
 ";;\n"
-"  move     $dccr,[reg+0x5E] ; Save the flags in DCCR before disable interrupts\n"
+"  move     $dccr,[cris_reg+0x5E] ; Save the flags in DCCR before disable interrupts\n"
 "  di                        ; Disable interrupts\n"
-"  move.d   $r0,[reg]        ; Save R0\n"
-"  move.d   $r1,[reg+0x04]   ; Save R1\n"
-"  move.d   $r2,[reg+0x08]   ; Save R2\n"
-"  move.d   $r3,[reg+0x0C]   ; Save R3\n"
-"  move.d   $r4,[reg+0x10]   ; Save R4\n"
-"  move.d   $r5,[reg+0x14]   ; Save R5\n"
-"  move.d   $r6,[reg+0x18]   ; Save R6\n"
-"  move.d   $r7,[reg+0x1C]   ; Save R7\n"
-"  move.d   $r8,[reg+0x20]   ; Save R8\n"
-"  move.d   $r9,[reg+0x24]   ; Save R9\n"
-"  move.d   $r10,[reg+0x28]  ; Save R10\n"
-"  move.d   $r11,[reg+0x2C]  ; Save R11\n"
-"  move.d   $r12,[reg+0x30]  ; Save R12\n"
-"  move.d   $r13,[reg+0x34]  ; Save R13\n"
-"  move.d   $sp,[reg+0x38]   ; Save SP (R14)\n"
+"  move.d   $r0,[cris_reg]        ; Save R0\n"
+"  move.d   $r1,[cris_reg+0x04]   ; Save R1\n"
+"  move.d   $r2,[cris_reg+0x08]   ; Save R2\n"
+"  move.d   $r3,[cris_reg+0x0C]   ; Save R3\n"
+"  move.d   $r4,[cris_reg+0x10]   ; Save R4\n"
+"  move.d   $r5,[cris_reg+0x14]   ; Save R5\n"
+"  move.d   $r6,[cris_reg+0x18]   ; Save R6\n"
+"  move.d   $r7,[cris_reg+0x1C]   ; Save R7\n"
+"  move.d   $r8,[cris_reg+0x20]   ; Save R8\n"
+"  move.d   $r9,[cris_reg+0x24]   ; Save R9\n"
+"  move.d   $r10,[cris_reg+0x28]  ; Save R10\n"
+"  move.d   $r11,[cris_reg+0x2C]  ; Save R11\n"
+"  move.d   $r12,[cris_reg+0x30]  ; Save R12\n"
+"  move.d   $r13,[cris_reg+0x34]  ; Save R13\n"
+"  move.d   $sp,[cris_reg+0x38]   ; Save SP (R14)\n"
 ";; Due to the old assembler-versions BRP might not be recognized\n"
 "  .word 0xE670              ; move brp,$r0\n"
 "  subq     2,$r0             ; Set to address of previous instruction.\n"
-"  move.d   $r0,[reg+0x3c]   ; Save the address in PC (R15)\n"
-"  clear.b  [reg+0x40]      ; Clear P0\n"
-"  move     $vr,[reg+0x41]   ; Save special register P1\n"
-"  clear.w  [reg+0x42]      ; Clear P4\n"
-"  move     $ccr,[reg+0x44]  ; Save special register CCR\n"
-"  move     $mof,[reg+0x46]  ; P7\n"
-"  clear.d  [reg+0x4A]      ; Clear P8\n"
-"  move     $ibr,[reg+0x4E]  ; P9,\n"
-"  move     $irp,[reg+0x52]  ; P10,\n"
-"  move     $srp,[reg+0x56]  ; P11,\n"
-"  move     $dtp0,[reg+0x5A] ; P12, register BAR, assembler might not know BAR\n"
+"  move.d   $r0,[cris_reg+0x3c]   ; Save the address in PC (R15)\n"
+"  clear.b  [cris_reg+0x40]      ; Clear P0\n"
+"  move     $vr,[cris_reg+0x41]   ; Save special register P1\n"
+"  clear.w  [cris_reg+0x42]      ; Clear P4\n"
+"  move     $ccr,[cris_reg+0x44]  ; Save special register CCR\n"
+"  move     $mof,[cris_reg+0x46]  ; P7\n"
+"  clear.d  [cris_reg+0x4A]      ; Clear P8\n"
+"  move     $ibr,[cris_reg+0x4E]  ; P9,\n"
+"  move     $irp,[cris_reg+0x52]  ; P10,\n"
+"  move     $srp,[cris_reg+0x56]  ; P11,\n"
+"  move     $dtp0,[cris_reg+0x5A] ; P12, register BAR, assembler might not know BAR\n"
 "                            ; P13, register DCCR already saved\n"
 ";; Due to the old assembler-versions BRP might not be recognized\n"
 "  .word 0xE670              ; move brp,r0\n"
@@ -1246,8 +1246,8 @@ asm ("\n"
 "is_static:\n"
 "  moveq    1,$r1\n"
 "  move.b   $r1,[is_dyn_brkp] ; Set the state variable to dynamic breakpoint\n"
-"  move.d   $r0,[reg+0x62]    ; Save the return address in BRP\n"
-"  move     $usp,[reg+0x66]   ; USP\n"
+"  move.d   $r0,[cris_reg+0x62]    ; Save the return address in BRP\n"
+"  move     $usp,[cris_reg+0x66]   ; USP\n"
 ";;\n"
 ";; Handle the communication\n"
 ";;\n"
@@ -1257,28 +1257,28 @@ asm ("\n"
 ";;\n"
 ";; Return to the caller\n"
 ";;\n"
-"   move.d  [reg],$r0         ; Restore R0\n"
-"   move.d  [reg+0x04],$r1    ; Restore R1\n"
-"   move.d  [reg+0x08],$r2    ; Restore R2\n"
-"   move.d  [reg+0x0C],$r3    ; Restore R3\n"
-"   move.d  [reg+0x10],$r4    ; Restore R4\n"
-"   move.d  [reg+0x14],$r5    ; Restore R5\n"
-"   move.d  [reg+0x18],$r6    ; Restore R6\n"
-"   move.d  [reg+0x1C],$r7    ; Restore R7\n"
-"   move.d  [reg+0x20],$r8    ; Restore R8\n"
-"   move.d  [reg+0x24],$r9    ; Restore R9\n"
-"   move.d  [reg+0x28],$r10   ; Restore R10\n"
-"   move.d  [reg+0x2C],$r11   ; Restore R11\n"
-"   move.d  [reg+0x30],$r12   ; Restore R12\n"
-"   move.d  [reg+0x34],$r13   ; Restore R13\n"
+"   move.d  [cris_reg],$r0         ; Restore R0\n"
+"   move.d  [cris_reg+0x04],$r1    ; Restore R1\n"
+"   move.d  [cris_reg+0x08],$r2    ; Restore R2\n"
+"   move.d  [cris_reg+0x0C],$r3    ; Restore R3\n"
+"   move.d  [cris_reg+0x10],$r4    ; Restore R4\n"
+"   move.d  [cris_reg+0x14],$r5    ; Restore R5\n"
+"   move.d  [cris_reg+0x18],$r6    ; Restore R6\n"
+"   move.d  [cris_reg+0x1C],$r7    ; Restore R7\n"
+"   move.d  [cris_reg+0x20],$r8    ; Restore R8\n"
+"   move.d  [cris_reg+0x24],$r9    ; Restore R9\n"
+"   move.d  [cris_reg+0x28],$r10   ; Restore R10\n"
+"   move.d  [cris_reg+0x2C],$r11   ; Restore R11\n"
+"   move.d  [cris_reg+0x30],$r12   ; Restore R12\n"
+"   move.d  [cris_reg+0x34],$r13   ; Restore R13\n"
 ";;\n"
 ";; FIXME: Which registers should be restored?\n"
 ";;\n"
-"   move.d  [reg+0x38],$sp    ; Restore SP (R14)\n"
-"   move    [reg+0x56],$srp   ; Restore the subroutine return pointer.\n"
-"   move    [reg+0x5E],$dccr  ; Restore DCCR\n"
-"   move    [reg+0x66],$usp   ; Restore USP\n"
-"   jump    [reg+0x62]       ; A jump to the content in register BRP works.\n"
+"   move.d  [cris_reg+0x38],$sp    ; Restore SP (R14)\n"
+"   move    [cris_reg+0x56],$srp   ; Restore the subroutine return pointer.\n"
+"   move    [cris_reg+0x5E],$dccr  ; Restore DCCR\n"
+"   move    [cris_reg+0x66],$usp   ; Restore USP\n"
+"   jump    [cris_reg+0x62]       ; A jump to the content in register BRP works.\n"
 "   nop                       ;\n"
 "\n");
 
@@ -1298,39 +1298,39 @@ asm ("\n"
 ";; Response to a serial interrupt\n"
 ";;\n"
 "\n"
-"  move     $dccr,[reg+0x5E] ; Save the flags in DCCR\n"
+"  move     $dccr,[cris_reg+0x5E] ; Save the flags in DCCR\n"
 "  di                        ; Disable interrupts\n"
-"  move.d   $r0,[reg]        ; Save R0\n"
-"  move.d   $r1,[reg+0x04]   ; Save R1\n"
-"  move.d   $r2,[reg+0x08]   ; Save R2\n"
-"  move.d   $r3,[reg+0x0C]   ; Save R3\n"
-"  move.d   $r4,[reg+0x10]   ; Save R4\n"
-"  move.d   $r5,[reg+0x14]   ; Save R5\n"
-"  move.d   $r6,[reg+0x18]   ; Save R6\n"
-"  move.d   $r7,[reg+0x1C]   ; Save R7\n"
-"  move.d   $r8,[reg+0x20]   ; Save R8\n"
-"  move.d   $r9,[reg+0x24]   ; Save R9\n"
-"  move.d   $r10,[reg+0x28]  ; Save R10\n"
-"  move.d   $r11,[reg+0x2C]  ; Save R11\n"
-"  move.d   $r12,[reg+0x30]  ; Save R12\n"
-"  move.d   $r13,[reg+0x34]  ; Save R13\n"
-"  move.d   $sp,[reg+0x38]   ; Save SP (R14)\n"
-"  move     $irp,[reg+0x3c]  ; Save the address in PC (R15)\n"
-"  clear.b  [reg+0x40]      ; Clear P0\n"
-"  move     $vr,[reg+0x41]   ; Save special register P1,\n"
-"  clear.w  [reg+0x42]      ; Clear P4\n"
-"  move     $ccr,[reg+0x44]  ; Save special register CCR\n"
-"  move     $mof,[reg+0x46]  ; P7\n"
-"  clear.d  [reg+0x4A]      ; Clear P8\n"
-"  move     $ibr,[reg+0x4E]  ; P9,\n"
-"  move     $irp,[reg+0x52]  ; P10,\n"
-"  move     $srp,[reg+0x56]  ; P11,\n"
-"  move     $dtp0,[reg+0x5A] ; P12, register BAR, assembler might not know BAR\n"
+"  move.d   $r0,[cris_reg]        ; Save R0\n"
+"  move.d   $r1,[cris_reg+0x04]   ; Save R1\n"
+"  move.d   $r2,[cris_reg+0x08]   ; Save R2\n"
+"  move.d   $r3,[cris_reg+0x0C]   ; Save R3\n"
+"  move.d   $r4,[cris_reg+0x10]   ; Save R4\n"
+"  move.d   $r5,[cris_reg+0x14]   ; Save R5\n"
+"  move.d   $r6,[cris_reg+0x18]   ; Save R6\n"
+"  move.d   $r7,[cris_reg+0x1C]   ; Save R7\n"
+"  move.d   $r8,[cris_reg+0x20]   ; Save R8\n"
+"  move.d   $r9,[cris_reg+0x24]   ; Save R9\n"
+"  move.d   $r10,[cris_reg+0x28]  ; Save R10\n"
+"  move.d   $r11,[cris_reg+0x2C]  ; Save R11\n"
+"  move.d   $r12,[cris_reg+0x30]  ; Save R12\n"
+"  move.d   $r13,[cris_reg+0x34]  ; Save R13\n"
+"  move.d   $sp,[cris_reg+0x38]   ; Save SP (R14)\n"
+"  move     $irp,[cris_reg+0x3c]  ; Save the address in PC (R15)\n"
+"  clear.b  [cris_reg+0x40]      ; Clear P0\n"
+"  move     $vr,[cris_reg+0x41]   ; Save special register P1,\n"
+"  clear.w  [cris_reg+0x42]      ; Clear P4\n"
+"  move     $ccr,[cris_reg+0x44]  ; Save special register CCR\n"
+"  move     $mof,[cris_reg+0x46]  ; P7\n"
+"  clear.d  [cris_reg+0x4A]      ; Clear P8\n"
+"  move     $ibr,[cris_reg+0x4E]  ; P9,\n"
+"  move     $irp,[cris_reg+0x52]  ; P10,\n"
+"  move     $srp,[cris_reg+0x56]  ; P11,\n"
+"  move     $dtp0,[cris_reg+0x5A] ; P12, register BAR, assembler might not know BAR\n"
 "                            ; P13, register DCCR already saved\n"
 ";; Due to the old assembler-versions BRP might not be recognized\n"
 "  .word 0xE670              ; move brp,r0\n"
-"  move.d   $r0,[reg+0x62]   ; Save the return address in BRP\n"
-"  move     $usp,[reg+0x66]  ; USP\n"
+"  move.d   $r0,[cris_reg+0x62]   ; Save the return address in BRP\n"
+"  move     $usp,[cris_reg+0x66]  ; USP\n"
 "\n"
 ";; get the serial character (from debugport.c) and check if it is a ctrl-c\n"
 "\n"
@@ -1339,7 +1339,7 @@ asm ("\n"
 "  bne goback\n"
 "  nop\n"
 "\n"
-"  move.d  [reg+0x5E], $r10		; Get DCCR\n"
+"  move.d  [cris_reg+0x5E], $r10		; Get DCCR\n"
 "  btstq	   8, $r10			; Test the U-flag.\n"
 "  bmi	   goback\n"
 "  nop\n"
@@ -1355,27 +1355,27 @@ asm ("\n"
 ";;\n"
 ";; Return to the caller\n"
 ";;\n"
-"   move.d  [reg],$r0         ; Restore R0\n"
-"   move.d  [reg+0x04],$r1    ; Restore R1\n"
-"   move.d  [reg+0x08],$r2    ; Restore R2\n"
-"   move.d  [reg+0x0C],$r3    ; Restore R3\n"
-"   move.d  [reg+0x10],$r4    ; Restore R4\n"
-"   move.d  [reg+0x14],$r5    ; Restore R5\n"
-"   move.d  [reg+0x18],$r6    ; Restore R6\n"
-"   move.d  [reg+0x1C],$r7    ; Restore R7\n"
-"   move.d  [reg+0x20],$r8    ; Restore R8\n"
-"   move.d  [reg+0x24],$r9    ; Restore R9\n"
-"   move.d  [reg+0x28],$r10   ; Restore R10\n"
-"   move.d  [reg+0x2C],$r11   ; Restore R11\n"
-"   move.d  [reg+0x30],$r12   ; Restore R12\n"
-"   move.d  [reg+0x34],$r13   ; Restore R13\n"
+"   move.d  [cris_reg],$r0         ; Restore R0\n"
+"   move.d  [cris_reg+0x04],$r1    ; Restore R1\n"
+"   move.d  [cris_reg+0x08],$r2    ; Restore R2\n"
+"   move.d  [cris_reg+0x0C],$r3    ; Restore R3\n"
+"   move.d  [cris_reg+0x10],$r4    ; Restore R4\n"
+"   move.d  [cris_reg+0x14],$r5    ; Restore R5\n"
+"   move.d  [cris_reg+0x18],$r6    ; Restore R6\n"
+"   move.d  [cris_reg+0x1C],$r7    ; Restore R7\n"
+"   move.d  [cris_reg+0x20],$r8    ; Restore R8\n"
+"   move.d  [cris_reg+0x24],$r9    ; Restore R9\n"
+"   move.d  [cris_reg+0x28],$r10   ; Restore R10\n"
+"   move.d  [cris_reg+0x2C],$r11   ; Restore R11\n"
+"   move.d  [cris_reg+0x30],$r12   ; Restore R12\n"
+"   move.d  [cris_reg+0x34],$r13   ; Restore R13\n"
 ";;\n"
 ";; FIXME: Which registers should be restored?\n"
 ";;\n"
-"   move.d  [reg+0x38],$sp    ; Restore SP (R14)\n"
-"   move    [reg+0x56],$srp   ; Restore the subroutine return pointer.\n"
-"   move    [reg+0x5E],$dccr  ; Restore DCCR\n"
-"   move    [reg+0x66],$usp   ; Restore USP\n"
+"   move.d  [cris_reg+0x38],$sp    ; Restore SP (R14)\n"
+"   move    [cris_reg+0x56],$srp   ; Restore the subroutine return pointer.\n"
+"   move    [cris_reg+0x5E],$dccr  ; Restore DCCR\n"
+"   move    [cris_reg+0x66],$usp   ; Restore USP\n"
 "   reti                      ; Return from the interrupt routine\n"
 "   nop\n"
 "\n");
-- 
1.7.0.4

