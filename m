Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761105Ab3BLOxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:53:10 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:43011 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408Ab3BLOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/10] cris/kgdb: Kill forward declarations for static functions
Date: Tue, 12 Feb 2013 15:52:50 +0100
Message-Id: <1360680777-12622-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some functions around and kill forward declarations for static
functions. This fixes:

arch/cris/arch-v10/kernel/kgdb.c:255:13: warning: 'copy_registers_from_stack' declared 'static' but never defined [-Wunused-function]
arch/cris/arch-v10/kernel/kgdb.c:259:13: warning: 'copy_registers_to_stack' declared 'static' but never defined [-Wunused-function]
arch/cris/arch-v10/kernel/kgdb.c:267:12: warning: 'write_stack_register' declared 'static' but never defined [-Wunused-function]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |  406 +++++++++++++++----------------------
 1 files changed, 165 insertions(+), 241 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 6b64567..3c852b3 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -230,46 +230,6 @@ struct register_image
 	unsigned int    usp;   /* 0x66 User mode stack pointer */
 } registers;
 
-/************** Prototypes for local library functions ***********************/
-
-/* Copy of strcpy from libc. */
-static char *gdb_cris_strcpy (char *s1, const char *s2);
-
-/* Copy of strlen from libc. */
-static int gdb_cris_strlen (const char *s);
-
-/* Copy of memchr from libc. */
-static void *gdb_cris_memchr (const void *s, int c, int n);
-
-/* Copy of strtol from libc. Does only support base 16. */
-static int gdb_cris_strtol (const char *s, char **endptr, int base);
-
-/********************** Prototypes for local functions. **********************/
-/* Copy the content of a register image into another. The size n is
-   the size of the register image. Due to struct assignment generation of
-   memcpy in libc. */
-static void copy_registers (registers *dptr, registers *sptr, int n);
-
-/* Copy the stored registers from the stack. Put the register contents
-   of thread thread_id in the struct reg. */
-static void copy_registers_from_stack (int thread_id, registers *reg);
-
-/* Copy the registers to the stack. Put the register contents of thread
-   thread_id from struct reg to the stack. */
-static void copy_registers_to_stack (int thread_id, registers *reg);
-
-/* Write a value to a specified register regno in the register image
-   of the current thread. */
-static int write_register (int regno, char *val);
-
-/* Write a value to a specified register in the stack of a thread other
-   than the current thread. */
-static int write_stack_register(int thread_id, int regno, char *valptr);
-
-/* Read a value from a specified register in the register image. Returns the
-   status of the read operation. The register value is returned in valptr. */
-static int read_register (char regno, unsigned int *valptr);
-
 /* Serial port, reads one character. ETRAX 100 specific. from debugport.c */
 int getDebugChar (void);
 
@@ -278,42 +238,6 @@ void putDebugChar (int val);
 
 void enableDebugIRQ (void);
 
-/* Returns the integer equivalent of a hexadecimal character. */
-static int hex (char ch);
-
-/* Convert the memory, pointed to by mem into hexadecimal representation.
-   Put the result in buf, and return a pointer to the last character
-   in buf (null). */
-static char *mem2hex (char *buf, unsigned char *mem, int count);
-
-/* Convert the array, in hexadecimal representation, pointed to by buf into
-   binary representation. Put the result in mem, and return a pointer to
-   the character after the last byte written. */
-static unsigned char *hex2mem (unsigned char *mem, char *buf, int count);
-
-/* Put the content of the array, in binary representation, pointed to by buf
-   into memory pointed to by mem, and return a pointer to
-   the character after the last byte written. */
-static unsigned char *bin2mem (unsigned char *mem, unsigned char *buf, int count);
-
-/* Await the sequence $<data>#<checksum> and store <data> in the array buffer
-   returned. */
-static void getpacket (char *buffer);
-
-/* Send $<data>#<checksum> from the <data> in the array buffer. */
-static void putpacket (char *buffer);
-
-/* Build and send a response packet in order to inform the host the
-   stub is stopped. */
-static void stub_is_stopped (int sigval);
-
-/* All expected commands are sent from remote.c. Send a response according
-   to the description in remote.c. */
-static void handle_exception (int sigval);
-
-/* Performs a complete re-start from scratch. ETRAX specific. */
-static void kill_restart (void);
-
 /******************** Prototypes for global functions. ***********************/
 
 /* The string str is prepended with the GDB printout token and sent. */
@@ -500,164 +424,6 @@ gdb_cris_strtol (const char *s, char **endptr, int base)
 	return x;
 }
 
-/********************************* Register image ****************************/
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
-#ifdef PROCESS_SUPPORT
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
-/* Write a value to a specified register in the register image of the current
-   thread. Returns status code SUCCESS, E02 or E05. */
-static int
-write_register (int regno, char *val)
-{
-	int status = SUCCESS;
-	registers *current_reg = &reg;
-
-        if (regno >= R0 && regno <= PC) {
-		/* 32-bit register with simple offset. */
-		hex2mem ((unsigned char *)current_reg + regno * sizeof(unsigned int),
-			 val, sizeof(unsigned int));
-	}
-        else if (regno == P0 || regno == VR || regno == P4 || regno == P8) {
-		/* Do not support read-only registers. */
-		status = E02;
-	}
-        else if (regno == CCR) {
-		/* 16 bit register with complex offset. (P4 is read-only, P6 is not implemented, 
-                   and P7 (MOF) is 32 bits in ETRAX 100LX. */
-		hex2mem ((unsigned char *)&(current_reg->ccr) + (regno-CCR) * sizeof(unsigned short),
-			 val, sizeof(unsigned short));
-	}
-	else if (regno >= MOF && regno <= USP) {
-		/* 32 bit register with complex offset.  (P8 has been taken care of.) */
-		hex2mem ((unsigned char *)&(current_reg->ibr) + (regno-IBR) * sizeof(unsigned int),
-			 val, sizeof(unsigned int));
-	} 
-        else {
-		/* Do not support nonexisting or unimplemented registers (P2, P3, and P6). */
-		status = E05;
-	}
-	return status;
-}
-
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
-/* Read a value from a specified register in the register image. Returns the
-   value in the register or -1 for non-implemented registers.
-   Should check consistency_status after a call which may be E05 after changes
-   in the implementation. */
-static int
-read_register (char regno, unsigned int *valptr)
-{
-	registers *current_reg = &reg;
-
-	if (regno >= R0 && regno <= PC) {
-		/* 32-bit register with simple offset. */
-		*valptr = *(unsigned int *)((char *)current_reg + regno * sizeof(unsigned int));
-                return SUCCESS;
-	}
-	else if (regno == P0 || regno == VR) {
-		/* 8 bit register with complex offset. */
-		*valptr = (unsigned int)(*(unsigned char *)
-                                         ((char *)&(current_reg->p0) + (regno-P0) * sizeof(char)));
-                return SUCCESS;
-	}
-	else if (regno == P4 || regno == CCR) {
-		/* 16 bit register with complex offset. */
-		*valptr = (unsigned int)(*(unsigned short *)
-                                         ((char *)&(current_reg->p4) + (regno-P4) * sizeof(unsigned short)));
-                return SUCCESS;
-	}
-	else if (regno >= MOF && regno <= USP) {
-		/* 32 bit register with complex offset. */
-		*valptr = *(unsigned int *)((char *)&(current_reg->p8)
-                                            + (regno-P8) * sizeof(unsigned int));
-                return SUCCESS;
-	}
-	else {
-		/* Do not support nonexisting or unimplemented registers (P2, P3, and P6). */
-		consistency_status = E05;
-		return E05;
-	}
-}
-
 /********************************** Packet I/O ******************************/
 /* Returns the integer equivalent of a hexadecimal character. */
 static int
@@ -843,6 +609,164 @@ putDebugString (const unsigned char *str, int length)
         putpacket(remcomOutBuffer);
 }
 
+/********************************* Register image ****************************/
+/* Copy the content of a register image into another. The size n is
+   the size of the register image. Due to struct assignment generation of
+   memcpy in libc. */
+static void
+copy_registers (registers *dptr, registers *sptr, int n)
+{
+	unsigned char *dreg;
+	unsigned char *sreg;
+	
+	for (dreg = (unsigned char*)dptr, sreg = (unsigned char*)sptr; n > 0; n--)
+		*dreg++ = *sreg++;
+}
+
+#ifdef PROCESS_SUPPORT
+/* Copy the stored registers from the stack. Put the register contents
+   of thread thread_id in the struct reg. */
+static void
+copy_registers_from_stack (int thread_id, registers *regptr)
+{
+	int j;
+	stack_registers *s = (stack_registers *)stack_list[thread_id];
+	unsigned int *d = (unsigned int *)regptr;
+	
+	for (j = 13; j >= 0; j--)
+		*d++ = s->r[j];
+	regptr->sp = (unsigned int)stack_list[thread_id];
+	regptr->pc = s->pc;
+	regptr->dccr = s->dccr;
+	regptr->srp = s->srp;
+}
+
+/* Copy the registers to the stack. Put the register contents of thread
+   thread_id from struct reg to the stack. */
+static void
+copy_registers_to_stack (int thread_id, registers *regptr)
+{
+	int i;
+	stack_registers *d = (stack_registers *)stack_list[thread_id];
+	unsigned int *s = (unsigned int *)regptr;
+	
+	for (i = 0; i < 14; i++) {
+		d->r[i] = *s++;
+	}
+	d->pc = regptr->pc;
+	d->dccr = regptr->dccr;
+	d->srp = regptr->srp;
+}
+#endif
+
+/* Write a value to a specified register in the register image of the current
+   thread. Returns status code SUCCESS, E02 or E05. */
+static int
+write_register (int regno, char *val)
+{
+	int status = SUCCESS;
+	registers *current_reg = &reg;
+
+        if (regno >= R0 && regno <= PC) {
+		/* 32-bit register with simple offset. */
+		hex2mem ((unsigned char *)current_reg + regno * sizeof(unsigned int),
+			 val, sizeof(unsigned int));
+	}
+        else if (regno == P0 || regno == VR || regno == P4 || regno == P8) {
+		/* Do not support read-only registers. */
+		status = E02;
+	}
+        else if (regno == CCR) {
+		/* 16 bit register with complex offset. (P4 is read-only, P6 is not implemented, 
+                   and P7 (MOF) is 32 bits in ETRAX 100LX. */
+		hex2mem ((unsigned char *)&(current_reg->ccr) + (regno-CCR) * sizeof(unsigned short),
+			 val, sizeof(unsigned short));
+	}
+	else if (regno >= MOF && regno <= USP) {
+		/* 32 bit register with complex offset.  (P8 has been taken care of.) */
+		hex2mem ((unsigned char *)&(current_reg->ibr) + (regno-IBR) * sizeof(unsigned int),
+			 val, sizeof(unsigned int));
+	} 
+        else {
+		/* Do not support nonexisting or unimplemented registers (P2, P3, and P6). */
+		status = E05;
+	}
+	return status;
+}
+
+#ifdef PROCESS_SUPPORT
+/* Write a value to a specified register in the stack of a thread other
+   than the current thread. Returns status code SUCCESS or E07. */
+static int
+write_stack_register (int thread_id, int regno, char *valptr)
+{
+	int status = SUCCESS;
+	stack_registers *d = (stack_registers *)stack_list[thread_id];
+	unsigned int val;
+	
+	hex2mem ((unsigned char *)&val, valptr, sizeof(unsigned int));
+	if (regno >= R0 && regno < SP) {
+		d->r[regno] = val;
+	}
+	else if (regno == SP) {
+		stack_list[thread_id] = val;
+	}
+	else if (regno == PC) {
+		d->pc = val;
+	}
+	else if (regno == SRP) {
+		d->srp = val;
+	}
+	else if (regno == DCCR) {
+		d->dccr = val;
+	}
+	else {
+		/* Do not support registers in the current thread. */
+		status = E07;
+	}
+	return status;
+}
+#endif
+
+/* Read a value from a specified register in the register image. Returns the
+   value in the register or -1 for non-implemented registers.
+   Should check consistency_status after a call which may be E05 after changes
+   in the implementation. */
+static int
+read_register (char regno, unsigned int *valptr)
+{
+	registers *current_reg = &reg;
+
+	if (regno >= R0 && regno <= PC) {
+		/* 32-bit register with simple offset. */
+		*valptr = *(unsigned int *)((char *)current_reg + regno * sizeof(unsigned int));
+                return SUCCESS;
+	}
+	else if (regno == P0 || regno == VR) {
+		/* 8 bit register with complex offset. */
+		*valptr = (unsigned int)(*(unsigned char *)
+                                         ((char *)&(current_reg->p0) + (regno-P0) * sizeof(char)));
+                return SUCCESS;
+	}
+	else if (regno == P4 || regno == CCR) {
+		/* 16 bit register with complex offset. */
+		*valptr = (unsigned int)(*(unsigned short *)
+                                         ((char *)&(current_reg->p4) + (regno-P4) * sizeof(unsigned short)));
+                return SUCCESS;
+	}
+	else if (regno >= MOF && regno <= USP) {
+		/* 32 bit register with complex offset. */
+		*valptr = *(unsigned int *)((char *)&(current_reg->p8)
+                                            + (regno-P8) * sizeof(unsigned int));
+                return SUCCESS;
+	}
+	else {
+		/* Do not support nonexisting or unimplemented registers (P2, P3, and P6). */
+		consistency_status = E05;
+		return E05;
+	}
+}
+
 /********************************** Handle exceptions ************************/
 /* Build and send a response packet in order to inform the host the
    stub is stopped. TAAn...:r...;n...:r...;n...:r...;
@@ -916,6 +840,13 @@ stub_is_stopped(int sigval)
 	putpacket (remcomOutBuffer);
 }
 
+/* Performs a complete re-start from scratch. */
+static void
+kill_restart (void)
+{
+	machine_restart("");
+}
+
 /* All expected commands are sent from remote.c. Send a response according
    to the description in remote.c. */
 static void
@@ -1252,13 +1183,6 @@ handle_exception (int sigval)
 	}
 }
 
-/* Performs a complete re-start from scratch. */
-static void
-kill_restart ()
-{
-	machine_restart("");
-}
-
 /********************************** Breakpoint *******************************/
 /* The hook for both a static (compiled) and a dynamic breakpoint set by GDB.
    An internal stack is used by the stub. The register image of the caller is
-- 
1.7.0.4

