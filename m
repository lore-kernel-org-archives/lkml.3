Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398Ab3JQTrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:47:04 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:36373 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab3JQTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:47:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] m68k/amiga: Fix specifying multiple debug= parameters
Date: Thu, 17 Oct 2013 21:46:52 +0200
Message-Id: <1382039212-26062-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit d6713b4091a99fa2af2fabdcd2f3fb97f32ecf2e ("m68k: early
parameter support"), the user can specify multiple debug consoles using the
"debug=" kernel command line parameter.
However, as the struct console object was shared, it would actually register
the same console object multiple times, causing the following warning:

WARNING: CPU: 0 PID: 0 at kernel/printk/printk.c:2233 register_console+0x36/0x2b6()
console 'debug0' already registered

Note that only the console corresponding to the last "debug=" parameter became
active, as the .write() method was overwritten before registration.

Use separate console objects to allow using multiple debug consoles.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Notes:
  1. This patch was only compile-tested.
  2. Do we want to fix it this way? Alternatives are:
       a. Reject a second debug= parameter by checking for a non-NULL .write()
          method
	  => only the first debug console will be used,
       b. Skip console registration in case of a non-NULL .write() method
          => only the last debug console will be used,
  3. Atari has a similar issue, with even more (4) debug consoles.

 arch/m68k/amiga/config.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 049ef8605314..b975eefba30f 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -107,12 +107,6 @@ static void amiga_mem_console_write(struct console *co, const char *b,
 static void amiga_heartbeat(int on);
 #endif
 
-static struct console amiga_console_driver = {
-	.name	= "debug",
-	.flags	= CON_PRINTBUFFER,
-	.index	= -1,
-};
-
 
     /*
      *  Motherboard Resources present in all Amiga models
@@ -624,6 +618,13 @@ static void amiga_mem_console_write(struct console *co, const char *s,
 	}
 }
 
+static struct console amiga_mem_console = {
+	.name	= "debug",
+	.write	= amiga_mem_console_write,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+};
+
 static int __init amiga_savekmsg_setup(char *arg)
 {
 	if (!MACH_IS_AMIGA || strcmp(arg, "mem"))
@@ -642,8 +643,7 @@ static int __init amiga_savekmsg_setup(char *arg)
 	savekmsg->magicptr = ZTWO_PADDR(savekmsg);
 	savekmsg->size = 0;
 
-	amiga_console_driver.write = amiga_mem_console_write;
-	register_console(&amiga_console_driver);
+	register_console(&amiga_mem_console);
 	return 0;
 }
 
@@ -723,12 +723,18 @@ void amiga_serial_gets(struct console *co, char *s, int len)
 }
 #endif
 
+static struct console amiga_serial_console = {
+	.name	= "debug",
+	.write	= amiga_serial_console_write,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+};
+
 static int __init amiga_debug_setup(char *arg)
 {
 	if (MACH_IS_AMIGA && !strcmp(arg, "ser")) {
 		/* no initialization required (?) */
-		amiga_console_driver.write = amiga_serial_console_write;
-		register_console(&amiga_console_driver);
+		register_console(&amiga_serial_console);
 	}
 	return 0;
 }
-- 
1.7.9.5

