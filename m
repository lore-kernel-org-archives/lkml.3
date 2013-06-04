Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3FDIwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:52:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:44085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab3FDIwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:52:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="scan'208";a="347746399"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] cris: kgdb: use native hex2bin
Date: Tue,  4 Jun 2013 11:51:54 +0300
Message-Id: <1370335914-31582-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are kernel native helpers to convert hex ascii to the binary format:
hex_to_bin() and hex2bin(). Thus, no need to reimplement them customly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c | 36 +++----------------------
 arch/cris/arch-v32/kernel/kgdb.c | 57 +++++++---------------------------------
 2 files changed, 14 insertions(+), 79 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 22d846b..dbd4ba8 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -413,18 +413,6 @@ gdb_cris_strtol (const char *s, char **endptr, int base)
 }
 
 /********************************** Packet I/O ******************************/
-/* Returns the integer equivalent of a hexadecimal character. */
-static int
-hex (char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return (ch - 'a' + 10);
-	if ((ch >= '0') && (ch <= '9'))
-		return (ch - '0');
-	if ((ch >= 'A') && (ch <= 'F'))
-		return (ch - 'A' + 10);
-	return (-1);
-}
 
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
@@ -455,22 +443,6 @@ mem2hex(char *buf, unsigned char *mem, int count)
 	return (buf);
 }
 
-/* Convert the array, in hexadecimal representation, pointed to by buf into
-   binary representation. Put the result in mem, and return a pointer to
-   the character after the last byte written. */
-static unsigned char*
-hex2mem (unsigned char *mem, char *buf, int count)
-{
-	int i;
-	unsigned char ch;
-	for (i = 0; i < count; i++) {
-		ch = hex (*buf++) << 4;
-		ch = ch + hex (*buf++);
-		*mem++ = ch;
-	}
-	return (mem);
-}
-
 /* Put the content of the array, in binary representation, pointed to by buf
    into memory pointed to by mem, and return a pointer to the character after
    the last byte written.
@@ -524,8 +496,8 @@ getpacket (char *buffer)
 		buffer[count] = '\0';
 		
 		if (ch == '#') {
-			xmitcsum = hex (getDebugChar ()) << 4;
-			xmitcsum += hex (getDebugChar ());
+			xmitcsum = hex_to_bin(getDebugChar()) << 4;
+			xmitcsum += hex_to_bin(getDebugChar());
 			if (checksum != xmitcsum) {
 				/* Wrong checksum */
 				putDebugChar ('-');
@@ -760,7 +732,7 @@ handle_exception (int sigval)
 				   Each byte of register data  is described by two hex digits.
 				   Success: OK
 				   Failure: void. */
-				hex2mem((char *)&cris_reg, &remcomInBuffer[1], sizeof(registers));
+				hex2bin((char *)&cris_reg, &remcomInBuffer[1], sizeof(registers));
 				gdb_cris_strcpy (remcomOutBuffer, "OK");
 				break;
 				
@@ -835,7 +807,7 @@ handle_exception (int sigval)
 					int length = gdb_cris_strtol(lenptr+1, &dataptr, 16);
 					if (*lenptr == ',' && *dataptr == ':') {
 						if (remcomInBuffer[0] == 'M') {
-							hex2mem(addr, dataptr + 1, length);
+							hex2bin(addr, dataptr + 1, length);
 						}
 						else /* X */ {
 							bin2mem(addr, dataptr + 1, length);
diff --git a/arch/cris/arch-v32/kernel/kgdb.c b/arch/cris/arch-v32/kernel/kgdb.c
index b06813a..590c11b 100644
--- a/arch/cris/arch-v32/kernel/kgdb.c
+++ b/arch/cris/arch-v32/kernel/kgdb.c
@@ -384,19 +384,11 @@ int getDebugChar(void);
 /* Serial port, writes one character. ETRAX 100 specific. from debugport.c */
 void putDebugChar(int val);
 
-/* Returns the integer equivalent of a hexadecimal character. */
-static int hex(char ch);
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
 static char *mem2hex(char *buf, unsigned char *mem, int count);
 
-/* Convert the array, in hexadecimal representation, pointed to by buf into
-   binary representation. Put the result in mem, and return a pointer to
-   the character after the last byte written. */
-static unsigned char *hex2mem(unsigned char *mem, char *buf, int count);
-
 /* Put the content of the array, in binary representation, pointed to by buf
    into memory pointed to by mem, and return a pointer to
    the character after the last byte written. */
@@ -547,7 +539,7 @@ write_register(int regno, char *val)
 
         if (regno >= R0 && regno <= ACR) {
 		/* Consecutive 32-bit registers. */
-		hex2mem((unsigned char *)&reg.r0 + (regno - R0) * sizeof(unsigned int),
+		hex2bin((unsigned char *)&reg.r0 + (regno - R0) * sizeof(unsigned int),
 			val, sizeof(unsigned int));
 
 	} else if (regno == BZ || regno == VR || regno == WZ || regno == DZ) {
@@ -557,15 +549,15 @@ write_register(int regno, char *val)
 	} else if (regno == PID) {
 		/* 32-bit register. (Even though we already checked SRS and WZ, we cannot
 		   combine this with the EXS - SPC write since SRS and WZ have different size.) */
-		hex2mem((unsigned char *)&reg.pid, val, sizeof(unsigned int));
+		hex2bin((unsigned char *)&reg.pid, val, sizeof(unsigned int));
 
 	} else if (regno == SRS) {
 		/* 8-bit register. */
-		hex2mem((unsigned char *)&reg.srs, val, sizeof(unsigned char));
+		hex2bin((unsigned char *)&reg.srs, val, sizeof(unsigned char));
 
 	} else if (regno >= EXS && regno <= SPC) {
 		/* Consecutive 32-bit registers. */
-		hex2mem((unsigned char *)&reg.exs + (regno - EXS) * sizeof(unsigned int),
+		hex2bin((unsigned char *)&reg.exs + (regno - EXS) * sizeof(unsigned int),
 			 val, sizeof(unsigned int));
 
        } else if (regno == PC) {
@@ -574,7 +566,7 @@ write_register(int regno, char *val)
 
        } else if (regno >= S0 && regno <= S15) {
                /* 32-bit registers. */
-               hex2mem((unsigned char *)&sreg.s0_0 + (reg.srs * 16 * sizeof(unsigned int)) + (regno - S0) * sizeof(unsigned int), val, sizeof(unsigned int));
+               hex2bin((unsigned char *)&sreg.s0_0 + (reg.srs * 16 * sizeof(unsigned int)) + (regno - S0) * sizeof(unsigned int), val, sizeof(unsigned int));
 	} else {
 		/* Non-existing register. */
 		status = E05;
@@ -630,19 +622,6 @@ read_register(char regno, unsigned int *valptr)
 }
 
 /********************************** Packet I/O ******************************/
-/* Returns the integer equivalent of a hexadecimal character. */
-static int
-hex(char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return (ch - 'a' + 10);
-	if ((ch >= '0') && (ch <= '9'))
-		return (ch - '0');
-	if ((ch >= 'A') && (ch <= 'F'))
-		return (ch - 'A' + 10);
-	return -1;
-}
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
@@ -689,22 +668,6 @@ mem2hex_nbo(char *buf, unsigned char *mem, int count)
 	return buf;
 }
 
-/* Convert the array, in hexadecimal representation, pointed to by buf into
-   binary representation. Put the result in mem, and return a pointer to
-   the character after the last byte written. */
-static unsigned char*
-hex2mem(unsigned char *mem, char *buf, int count)
-{
-	int i;
-	unsigned char ch;
-	for (i = 0; i < count; i++) {
-		ch = hex (*buf++) << 4;
-		ch = ch + hex (*buf++);
-		*mem++ = ch;
-	}
-	return mem;
-}
-
 /* Put the content of the array, in binary representation, pointed to by buf
    into memory pointed to by mem, and return a pointer to the character after
    the last byte written.
@@ -763,8 +726,8 @@ getpacket(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(getDebugChar()) << 4;
-			xmitcsum += hex(getDebugChar());
+			xmitcsum = hex_to_bin(getDebugChar()) << 4;
+			xmitcsum += hex_to_bin(getDebugChar());
 			if (checksum != xmitcsum) {
 				/* Wrong checksum */
 				putDebugChar('-');
@@ -1306,9 +1269,9 @@ handle_exception(int sigval)
 				   Success: OK
 				   Failure: void. */
 				/* General and special registers. */
-				hex2mem((char *)&reg, &input_buffer[1], sizeof(registers));
+				hex2bin((char *)&reg, &input_buffer[1], sizeof(registers));
 				/* Support registers. */
-				hex2mem((char *)&sreg + (reg.srs * 16 * sizeof(unsigned int)),
+				hex2bin((char *)&sreg + (reg.srs * 16 * sizeof(unsigned int)),
 					&input_buffer[1] + sizeof(registers),
 					16 * sizeof(unsigned int));
 				gdb_cris_strcpy(output_buffer, "OK");
@@ -1389,7 +1352,7 @@ handle_exception(int sigval)
 					int len = gdb_cris_strtol(lenptr+1, &dataptr, 16);
 					if (*lenptr == ',' && *dataptr == ':') {
 						if (input_buffer[0] == 'M') {
-							hex2mem(addr, dataptr + 1, len);
+							hex2bin(addr, dataptr + 1, len);
 						} else /* X */ {
 							bin2mem(addr, dataptr + 1, len);
 						}
-- 
1.8.2.rc0.22.gb3600c3

