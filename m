Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab3E1PyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:54:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:60847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934550Ab3E1Px6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="341393222"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Cris <linux-cris-kernel@axis.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] cris: kgdb: use native hex2bin
Date: Tue, 28 May 2013 18:53:52 +0300
Message-Id: <1369756432-5552-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369756432-5552-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
 <1369756432-5552-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/cris/arch-v10/kernel/kgdb.c | 50 ++++++----------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 37e6d2c..07bccd8 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -278,19 +278,11 @@ void putDebugChar (int val);
 
 void enableDebugIRQ (void);
 
-/* Returns the integer equivalent of a hexadecimal character. */
-static int hex (char ch);
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
 static char *mem2hex (char *buf, unsigned char *mem, int count);
 
-/* Convert the array, in hexadecimal representation, pointed to by buf into
-   binary representation. Put the result in mem, and return a pointer to
-   the character after the last byte written. */
-static unsigned char *hex2mem (unsigned char *mem, char *buf, int count);
-
 /* Put the content of the array, in binary representation, pointed to by buf
    into memory pointed to by mem, and return a pointer to
    the character after the last byte written. */
@@ -560,7 +552,7 @@ write_register (int regno, char *val)
 
         if (regno >= R0 && regno <= PC) {
 		/* 32-bit register with simple offset. */
-		hex2mem ((unsigned char *)current_reg + regno * sizeof(unsigned int),
+		hex2bin((unsigned char *)current_reg + regno * sizeof(unsigned int),
 			 val, sizeof(unsigned int));
 	}
         else if (regno == P0 || regno == VR || regno == P4 || regno == P8) {
@@ -570,12 +562,12 @@ write_register (int regno, char *val)
         else if (regno == CCR) {
 		/* 16 bit register with complex offset. (P4 is read-only, P6 is not implemented, 
                    and P7 (MOF) is 32 bits in ETRAX 100LX. */
-		hex2mem ((unsigned char *)&(current_reg->ccr) + (regno-CCR) * sizeof(unsigned short),
+		hex2bin((unsigned char *)&(current_reg->ccr) + (regno-CCR) * sizeof(unsigned short),
 			 val, sizeof(unsigned short));
 	}
 	else if (regno >= MOF && regno <= USP) {
 		/* 32 bit register with complex offset.  (P8 has been taken care of.) */
-		hex2mem ((unsigned char *)&(current_reg->ibr) + (regno-IBR) * sizeof(unsigned int),
+		hex2bin((unsigned char *)&(current_reg->ibr) + (regno-IBR) * sizeof(unsigned int),
 			 val, sizeof(unsigned int));
 	} 
         else {
@@ -595,7 +587,7 @@ write_stack_register (int thread_id, int regno, char *valptr)
 	stack_registers *d = (stack_registers *)stack_list[thread_id];
 	unsigned int val;
 	
-	hex2mem ((unsigned char *)&val, valptr, sizeof(unsigned int));
+	hex2bin((unsigned char *)&val, valptr, sizeof(unsigned int));
 	if (regno >= R0 && regno < SP) {
 		d->r[regno] = val;
 	}
@@ -659,18 +651,6 @@ read_register (char regno, unsigned int *valptr)
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
@@ -703,22 +683,6 @@ mem2hex(char *buf, unsigned char *mem, int count)
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
@@ -964,7 +928,7 @@ handle_exception (int sigval)
 				   Success: OK
 				   Failure: void. */
 #ifdef PROCESS_SUPPORT
-				hex2mem ((unsigned char *)&reg_g, &remcomInBuffer[1], sizeof(registers));
+				hex2bin((unsigned char *)&reg_g, &remcomInBuffer[1], sizeof(registers));
 				if (current_thread_g == executing_task) {
 					copy_registers (&reg, &reg_g, sizeof(registers));
 				}
@@ -972,7 +936,7 @@ handle_exception (int sigval)
 					copy_registers_to_stack(current_thread_g, &reg_g);
 				}
 #else
-				hex2mem((char *)&reg, &remcomInBuffer[1], sizeof(registers));
+				hex2bin((char *)&reg, &remcomInBuffer[1], sizeof(registers));
 #endif
 				gdb_cris_strcpy (remcomOutBuffer, "OK");
 				break;
@@ -1053,7 +1017,7 @@ handle_exception (int sigval)
 					int length = gdb_cris_strtol(lenptr+1, &dataptr, 16);
 					if (*lenptr == ',' && *dataptr == ':') {
 						if (remcomInBuffer[0] == 'M') {
-							hex2mem(addr, dataptr + 1, length);
+							hex2bin(addr, dataptr + 1, length);
 						}
 						else /* X */ {
 							bin2mem(addr, dataptr + 1, length);
-- 
1.8.2.rc0.22.gb3600c3

