Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243Ab3BLOxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:53:14 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:43601 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab3BLOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 08/10] [RFC] cris/kgdb: Remove sections protected by #ifdef PROCESS_SUPPORT
Date: Tue, 12 Feb 2013 15:52:55 +0100
Message-Id: <1360680777-12622-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabled, it doesn't build anyway:

arch/cris/arch-v10/kernel/kgdb.c: In function 'copy_registers_from_stack':
arch/cris/arch-v10/kernel/kgdb.c:631:2: error: unknown type name 'stack_registers'
arch/cris/arch-v10/kernel/kgdb.c:631:24: error: 'stack_registers' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c:631:24: note: each undeclared identifier is reported only once for each function it appears in
arch/cris/arch-v10/kernel/kgdb.c:631:41: error: expected expression before ')' token
arch/cris/arch-v10/kernel/kgdb.c:635:11: error: request for member 'r' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:636:29: error: 'stack_list' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c:637:16: error: request for member 'pc' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:638:18: error: request for member 'dccr' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:639:17: error: request for member 'srp' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c: In function 'copy_registers_to_stack':
arch/cris/arch-v10/kernel/kgdb.c:648:2: error: unknown type name 'stack_registers'
arch/cris/arch-v10/kernel/kgdb.c:648:24: error: 'stack_registers' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c:648:41: error: expected expression before ')' token
arch/cris/arch-v10/kernel/kgdb.c:652:4: error: request for member 'r' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:654:3: error: request for member 'pc' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:655:3: error: request for member 'dccr' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:656:3: error: request for member 'srp' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c: In function 'write_stack_register':
arch/cris/arch-v10/kernel/kgdb.c:702:2: error: unknown type name 'stack_registers'
arch/cris/arch-v10/kernel/kgdb.c:702:24: error: 'stack_registers' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c:702:41: error: expected expression before ')' token
arch/cris/arch-v10/kernel/kgdb.c:707:4: error: request for member 'r' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:710:3: error: 'stack_list' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c:713:4: error: request for member 'pc' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:716:4: error: request for member 'srp' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c:719:4: error: request for member 'dccr' in something not a structure or union
arch/cris/arch-v10/kernel/kgdb.c: In function 'stub_is_stopped':
arch/cris/arch-v10/kernel/kgdb.c:827:36: error: 'pos' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c: In function 'handle_exception':
arch/cris/arch-v10/kernel/kgdb.c:1064:40: error: 'number_of_tasks' undeclared (first use in this function)
arch/cris/arch-v10/kernel/kgdb.c:1125:8: error: implicit declaration of function 'os_is_started' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |  257 +-------------------------------------
 1 files changed, 2 insertions(+), 255 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 0e79907..22d846b 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -341,16 +341,6 @@ static int consistency_status = SUCCESS;
    in order to provide access mainly for 'g', 'G' and 'P'.
 */
 
-#ifdef PROCESS_SUPPORT
-/* Need two task id pointers in order to handle Hct and Hgt commands. */
-static int current_thread_c = 0;
-static int current_thread_g = 0;
-
-/* Need two register images in order to handle Hct and Hgt commands. The
-   variable reg_g is in addition to cris_reg above. */
-static registers reg_g;
-#endif /* PROCESS_SUPPORT */
-
 /********************************** Breakpoint *******************************/
 /* Use an internal stack in the breakpoint and interrupt response routines */
 #define INTERNAL_STACK_SIZE 1024
@@ -608,55 +598,6 @@ putDebugString (const unsigned char *str, int length)
 }
 
 /********************************* Register image ****************************/
-#ifdef PROCESS_SUPPORT
-/* Copy the content of a register image into another. The size n is
-   the size of the register image. Due to struct assignment generation of
-   memcpy in libc. */
-static void
-copy_registers (registers *dptr, registers *sptr, int n)
-{
-	unsigned char *dreg;
-	unsigned char *sreg;
-	
-	for (dreg = (unsigned char*)dptr, sreg = (unsigned char*)sptr; n > 0; n--)
-		*dreg++ = *sreg++;
-}
-
-/* Copy the stored registers from the stack. Put the register contents
-   of thread thread_id in the struct reg. */
-static void
-copy_registers_from_stack (int thread_id, registers *regptr)
-{
-	int j;
-	stack_registers *s = (stack_registers *)stack_list[thread_id];
-	unsigned int *d = (unsigned int *)regptr;
-	
-	for (j = 13; j >= 0; j--)
-		*d++ = s->r[j];
-	regptr->sp = (unsigned int)stack_list[thread_id];
-	regptr->pc = s->pc;
-	regptr->dccr = s->dccr;
-	regptr->srp = s->srp;
-}
-
-/* Copy the registers to the stack. Put the register contents of thread
-   thread_id from struct reg to the stack. */
-static void
-copy_registers_to_stack (int thread_id, registers *regptr)
-{
-	int i;
-	stack_registers *d = (stack_registers *)stack_list[thread_id];
-	unsigned int *s = (unsigned int *)regptr;
-	
-	for (i = 0; i < 14; i++) {
-		d->r[i] = *s++;
-	}
-	d->pc = regptr->pc;
-	d->dccr = regptr->dccr;
-	d->srp = regptr->srp;
-}
-#endif
-
 /* Write a value to a specified register in the register image of the current
    thread. Returns status code SUCCESS, E02 or E05. */
 static int
@@ -692,40 +633,6 @@ write_register (int regno, char *val)
 	return status;
 }
 
-#ifdef PROCESS_SUPPORT
-/* Write a value to a specified register in the stack of a thread other
-   than the current thread. Returns status code SUCCESS or E07. */
-static int
-write_stack_register (int thread_id, int regno, char *valptr)
-{
-	int status = SUCCESS;
-	stack_registers *d = (stack_registers *)stack_list[thread_id];
-	unsigned int val;
-	
-	hex2mem ((unsigned char *)&val, valptr, sizeof(unsigned int));
-	if (regno >= R0 && regno < SP) {
-		d->r[regno] = val;
-	}
-	else if (regno == SP) {
-		stack_list[thread_id] = val;
-	}
-	else if (regno == PC) {
-		d->pc = val;
-	}
-	else if (regno == SRP) {
-		d->srp = val;
-	}
-	else if (regno == DCCR) {
-		d->dccr = val;
-	}
-	else {
-		/* Do not support registers in the current thread. */
-		status = E07;
-	}
-	return status;
-}
-#endif
-
 /* Read a value from a specified register in the register image. Returns the
    value in the register or -1 for non-implemented registers.
    Should check consistency_status after a call which may be E05 after changes
@@ -811,26 +718,6 @@ stub_is_stopped(int sigval)
                 
 	}
 
-#ifdef PROCESS_SUPPORT
-	/* Store the registers of the executing thread. Assume that both step,
-	   continue, and register content requests are with respect to this
-	   thread. The executing task is from the operating system scheduler. */
-
-	current_thread_c = executing_task;
-	current_thread_g = executing_task;
-
-	/* A struct assignment translates into a libc memcpy call. Avoid
-	   all libc functions in order to prevent recursive break points. */
-	copy_registers (&reg_g, &cris_reg, sizeof(registers));
-
-	/* Store thread:r...; with the executing task TID. */
-	gdb_cris_strcpy (&remcomOutBuffer[pos], "thread:");
-	pos += gdb_cris_strlen ("thread:");
-	remcomOutBuffer[pos++] = hex_asc_hi(executing_task);
-	remcomOutBuffer[pos++] = hex_asc_lo(executing_task);
-	gdb_cris_strcpy (&remcomOutBuffer[pos], ";");
-#endif
-
 	/* null-terminate and send it off */
 
 	*ptr = 0;
@@ -865,19 +752,7 @@ handle_exception (int sigval)
 				   in a register  are in the same order the machine uses.
 				   Failure: void. */
 				
-				{
-#ifdef PROCESS_SUPPORT
-					/* Use the special register content in the executing thread. */
-					copy_registers (&reg_g, &cris_reg, sizeof(registers));
-					/* Replace the content available on the stack. */
-					if (current_thread_g != executing_task) {
-						copy_registers_from_stack (current_thread_g, &reg_g);
-					}
-					mem2hex ((unsigned char *)remcomOutBuffer, (unsigned char *)&reg_g, sizeof(registers));
-#else
-					mem2hex(remcomOutBuffer, (char *)&cris_reg, sizeof(registers));
-#endif
-				}
+				mem2hex(remcomOutBuffer, (char *)&cris_reg, sizeof(registers));
 				break;
 				
 			case 'G':
@@ -885,17 +760,7 @@ handle_exception (int sigval)
 				   Each byte of register data  is described by two hex digits.
 				   Success: OK
 				   Failure: void. */
-#ifdef PROCESS_SUPPORT
-				hex2mem ((unsigned char *)&reg_g, &remcomInBuffer[1], sizeof(registers));
-				if (current_thread_g == executing_task) {
-					copy_registers (&cris_reg, &reg_g, sizeof(registers));
-				}
-				else {
-					copy_registers_to_stack(current_thread_g, &reg_g);
-				}
-#else
 				hex2mem((char *)&cris_reg, &remcomInBuffer[1], sizeof(registers));
-#endif
 				gdb_cris_strcpy (remcomOutBuffer, "OK");
 				break;
 				
@@ -911,12 +776,7 @@ handle_exception (int sigval)
 					char *suffix;
 					int regno = gdb_cris_strtol (&remcomInBuffer[1], &suffix, 16);
 					int status;
-#ifdef PROCESS_SUPPORT
-					if (current_thread_g != executing_task)
-						status = write_stack_register (current_thread_g, regno, suffix+1);
-					else
-#endif
-						status = write_register (regno, suffix+1);
+					status = write_register (regno, suffix+1);
 
 					switch (status) {
 						case E02:
@@ -1051,119 +911,6 @@ handle_exception (int sigval)
 				   Not supported: E04 */
 				gdb_cris_strcpy (remcomOutBuffer, error_message[E04]);
 				break;
-#ifdef PROCESS_SUPPORT
-
-			case 'T':
-				/* Thread alive. TXX
-				   Is thread XX alive?
-				   Success: OK, thread XX is alive.
-				   Failure: E03, thread XX is dead. */
-				{
-					int thread_id = (int)gdb_cris_strtol (&remcomInBuffer[1], 0, 16);
-					/* Cannot tell whether it is alive or not. */
-					if (thread_id >= 0 && thread_id < number_of_tasks)
-						gdb_cris_strcpy (remcomOutBuffer, "OK");
-				}
-				break;
-								
-			case 'H':
-				/* Set thread for subsequent operations: Hct
-				   c = 'c' for thread used in step and continue;
-				   t can be -1 for all threads.
-				   c = 'g' for thread used in other  operations.
-				   t = 0 means pick any thread.
-				   Success: OK
-				   Failure: E01 */
-				{
-					int thread_id = gdb_cris_strtol (&remcomInBuffer[2], 0, 16);
-					if (remcomInBuffer[1] == 'c') {
-						/* c = 'c' for thread used in step and continue */
-						/* Do not change current_thread_c here. It would create a mess in
-						   the scheduler. */
-						gdb_cris_strcpy (remcomOutBuffer, "OK");
-					}
-					else if (remcomInBuffer[1] == 'g') {
-						/* c = 'g' for thread used in other  operations.
-						   t = 0 means pick any thread. Impossible since the scheduler does
-						   not allow that. */
-						if (thread_id >= 0 && thread_id < number_of_tasks) {
-							current_thread_g = thread_id;
-							gdb_cris_strcpy (remcomOutBuffer, "OK");
-						}
-						else {
-							/* Not expected - send an error message. */
-							gdb_cris_strcpy (remcomOutBuffer, error_message[E01]);
-						}
-					}
-					else {
-						/* Not expected - send an error message. */
-						gdb_cris_strcpy (remcomOutBuffer, error_message[E01]);
-					}
-				}
-				break;
-				
-			case 'q':
-			case 'Q':
-				/* Query of general interest. qXXXX
-				   Set general value XXXX. QXXXX=yyyy */
-				{
-					int pos;
-					int nextpos;
-					int thread_id;
-					
-					switch (remcomInBuffer[1]) {
-						case 'C':
-							/* Identify the remote current thread. */
-							gdb_cris_strcpy (&remcomOutBuffer[0], "QC");
-							remcomOutBuffer[2] = hex_asc_hi(current_thread_c);
-							remcomOutBuffer[3] = hex_asc_lo(current_thread_c);
-							remcomOutBuffer[4] = '\0';
-							break;
-						case 'L':
-							gdb_cris_strcpy (&remcomOutBuffer[0], "QM");
-							/* Reply with number of threads. */
-							if (os_is_started()) {
-								remcomOutBuffer[2] = hex_asc_hi(number_of_tasks);
-								remcomOutBuffer[3] = hex_asc_lo(number_of_tasks);
-							}
-							else {
-								remcomOutBuffer[2] = hex_asc_hi(0);
-								remcomOutBuffer[3] = hex_asc_lo(1);
-							}
-							/* Done with the reply. */
-							remcomOutBuffer[4] = hex_asc_lo(1);
-							pos = 5;
-							/* Expects the argument thread id. */
-							for (; pos < (5 + HEXCHARS_IN_THREAD_ID); pos++)
-								remcomOutBuffer[pos] = remcomInBuffer[pos];
-							/* Reply with the thread identifiers. */
-							if (os_is_started()) {
-								/* Store the thread identifiers of all tasks. */
-								for (thread_id = 0; thread_id < number_of_tasks; thread_id++) {
-									nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
-									for (; pos < nextpos; pos ++)
-										remcomOutBuffer[pos] = hex_asc_lo(0);
-									remcomOutBuffer[pos++] = hex_asc_lo(thread_id);
-								}
-							}
-							else {
-								/* Store the thread identifier of the boot task. */
-								nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
-								for (; pos < nextpos; pos ++)
-									remcomOutBuffer[pos] = hex_asc_lo(0);
-								remcomOutBuffer[pos++] = hex_asc_lo(current_thread_c);
-							}
-							remcomOutBuffer[pos] = '\0';
-							break;
-						default:
-							/* Not supported: "" */
-							/* Request information about section offsets: qOffsets. */
-							remcomOutBuffer[0] = 0;
-							break;
-					}
-				}
-				break;
-#endif /* PROCESS_SUPPORT */
 				
 			default:
 				/* The stub should ignore other request and send an empty
-- 
1.7.0.4

