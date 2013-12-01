Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3LALPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:15:49 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:47120 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3LALPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:15:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] m68k/amiga,atari: Fix specifying multiple debug= parameters
Date: Sun,  1 Dec 2013 12:15:39 +0100
Message-Id: <1385896539-18351-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit d6713b4091a99fa2af2fabdcd2f3fb97f32ecf2e ("m68k: early
parameter support"), the user can specify multiple debug consoles using the
"debug=" kernel command line parameter.
However, as there's only a single struct console object, which is reused,
it would actually register the same console object multiple times, causing
the following warning:

WARNING: CPU: 0 PID: 0 at kernel/printk/printk.c:2233 register_console+0x36/
console 'debug0' already registered

Make sure to register the console object only once, to avoid the warning.

Note that still only one console (the one corresponding to the last
"debug=" parameter) will be active at the same time, as the .write() method
of the already registered console object is overwritten by a subsequent
"debug=" parameter.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - Skip console registration in case of a non-NULL .write() method,
    instead of using separate console objects,
  - Add fix for Atari.

 arch/m68k/amiga/config.c |   19 ++++++++++++++-----
 arch/m68k/atari/debug.c  |    5 ++++-
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index c425fa6c2795..9625b7132227 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -620,6 +620,8 @@ static void amiga_mem_console_write(struct console *co, const char *s,
 
 static int __init amiga_savekmsg_setup(char *arg)
 {
+	bool registered;
+
 	if (!MACH_IS_AMIGA || strcmp(arg, "mem"))
 		return 0;
 
@@ -636,8 +638,10 @@ static int __init amiga_savekmsg_setup(char *arg)
 	savekmsg->magicptr = ZTWO_PADDR(savekmsg);
 	savekmsg->size = 0;
 
+	registered = !!amiga_console_driver.write;
 	amiga_console_driver.write = amiga_mem_console_write;
-	register_console(&amiga_console_driver);
+	if (!registered)
+		register_console(&amiga_console_driver);
 	return 0;
 }
 
@@ -719,11 +723,16 @@ void amiga_serial_gets(struct console *co, char *s, int len)
 
 static int __init amiga_debug_setup(char *arg)
 {
-	if (MACH_IS_AMIGA && !strcmp(arg, "ser")) {
-		/* no initialization required (?) */
-		amiga_console_driver.write = amiga_serial_console_write;
+	bool registered;
+
+	if (!MACH_IS_AMIGA || strcmp(arg, "ser"))
+		return 0;
+
+	/* no initialization required (?) */
+	registered = !!amiga_console_driver.write;
+	amiga_console_driver.write = amiga_serial_console_write;
+	if (!registered)
 		register_console(&amiga_console_driver);
-	}
 	return 0;
 }
 
diff --git a/arch/m68k/atari/debug.c b/arch/m68k/atari/debug.c
index a547ba9683d1..03cb5e08d7cf 100644
--- a/arch/m68k/atari/debug.c
+++ b/arch/m68k/atari/debug.c
@@ -287,6 +287,8 @@ static void __init atari_init_midi_port(int cflag)
 
 static int __init atari_debug_setup(char *arg)
 {
+	bool registered;
+
 	if (!MACH_IS_ATARI)
 		return 0;
 
@@ -294,6 +296,7 @@ static int __init atari_debug_setup(char *arg)
 		/* defaults to ser2 for a Falcon and ser1 otherwise */
 		arg = MACH_IS_FALCON ? "ser2" : "ser1";
 
+	registered = !!atari_console_driver.write;
 	if (!strcmp(arg, "ser1")) {
 		/* ST-MFP Modem1 serial port */
 		atari_init_mfp_port(B9600|CS8);
@@ -317,7 +320,7 @@ static int __init atari_debug_setup(char *arg)
 		sound_ym.wd_data = sound_ym.rd_data_reg_sel | 0x20; /* strobe H */
 		atari_console_driver.write = atari_par_console_write;
 	}
-	if (atari_console_driver.write)
+	if (atari_console_driver.write && !registered)
 		register_console(&atari_console_driver);
 
 	return 0;
-- 
1.7.9.5

