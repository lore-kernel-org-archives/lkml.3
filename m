Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968155Ab3E3KU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:20:27 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54351 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968106Ab3E3KUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:20:18 -0400
Message-ID: <1369909215.23034.39.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: DEC: remove unbuildable promcon.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 30 May 2013 12:20:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2013 10:20:16.0236 (UTC) FILETIME=[4753B2C0:01CE5D1F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

promcon.o is built if CONFIG_PROM_CONSOLE is set. But there's no Kconfig
symbol PROM_CONSOLE, so promcon.c is unbuildable. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) There used to be a Kconfig symbol PROM_CONSOLE. But it was SPARC
specific and it was removed in v2.6.32, see commit 09d3f3f0e0 ("sparc:
Kill PROM console driver.").

2) Actually, it seems that it has never been possible to set
PROM_CONSOLE for MIPS ever since this file was added in v2.3.9. I guess
no-one noticed because (what seems to be) comparable functionality is
provided in arch/mips/dec/prom/console.c.

 arch/mips/dec/Makefile  |  1 -
 arch/mips/dec/promcon.c | 54 -------------------------------------------------
 2 files changed, 55 deletions(-)
 delete mode 100644 arch/mips/dec/promcon.c

diff --git a/arch/mips/dec/Makefile b/arch/mips/dec/Makefile
index 9eb2f9c..3d5d2c5 100644
--- a/arch/mips/dec/Makefile
+++ b/arch/mips/dec/Makefile
@@ -5,6 +5,5 @@
 obj-y		:= ecc-berr.o int-handler.o ioasic-irq.o kn01-berr.o \
 		   kn02-irq.o kn02xa-berr.o reset.o setup.o time.o
 
-obj-$(CONFIG_PROM_CONSOLE)	+= promcon.o
 obj-$(CONFIG_TC)		+= tc.o
 obj-$(CONFIG_CPU_HAS_WB)	+= wbflush.o
diff --git a/arch/mips/dec/promcon.c b/arch/mips/dec/promcon.c
deleted file mode 100644
index c239c25..0000000
--- a/arch/mips/dec/promcon.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * Wrap-around code for a console using the
- * DECstation PROM io-routines.
- *
- * Copyright (c) 1998 Harald Koerfgen
- */
-
-#include <linux/tty.h>
-#include <linux/ptrace.h>
-#include <linux/init.h>
-#include <linux/console.h>
-#include <linux/fs.h>
-
-#include <asm/dec/prom.h>
-
-static void prom_console_write(struct console *co, const char *s,
-			       unsigned count)
-{
-	unsigned i;
-
-	/*
-	 *    Now, do each character
-	 */
-	for (i = 0; i < count; i++) {
-		if (*s == 10)
-			prom_printf("%c", 13);
-		prom_printf("%c", *s++);
-	}
-}
-
-static int __init prom_console_setup(struct console *co, char *options)
-{
-	return 0;
-}
-
-static struct console sercons = {
-	.name	= "ttyS",
-	.write	= prom_console_write,
-	.setup	= prom_console_setup,
-	.flags	= CON_PRINTBUFFER,
-	.index	= -1,
-};
-
-/*
- *    Register console.
- */
-
-static int __init prom_console_init(void)
-{
-	register_console(&sercons);
-
-	return 0;
-}
-console_initcall(prom_console_init);
-- 
1.7.11.7

