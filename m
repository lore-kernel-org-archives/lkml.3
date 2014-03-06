Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaCFJpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:45:00 -0500
Received: from msa01.smtpout.orange.fr ([193.252.23.210]:54352 "EHLO
	msa.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCFJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:44:57 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 04:44:56 EST
Date: Thu, 6 Mar 2014 10:36:59 +0100
From: Marc van der Wal <x0r+kernel@x0r.fr>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] it87_wdt: Work around non-working CIR interrupts
Message-ID: <20140306093659.GA24854@freyja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc van der Wal <x0r+kernel@x0r.fr>

On some hardware platforms, the it87_wdt watchdog resets the machine
despite the watchdog daemon running and writing to /dev/watchdog.

This is due to Consumer IR buffer underrun interrupts being used as
triggers to reset the timer.  On some buggy hardware implementations
such as the iEi AFL-12A-N270 single-board computer, this method does 
not work.

However, resetting the timer by writing its original timeout value in
its configuration register over and over again suppresses the unwanted
reboots.

Add a module option (nocir), 0 by default in order not to break existing
setups.  Setting it to 1 enables the workaround.

Fixes bug #42801 <https://bugzilla.kernel.org/show_bug.cgi?id=42801>.
Tested primarily on Linux 3.5.7, applies cleanly on Linux 3.13.5.

Signed-off-by: Marc van der Wal <x0r+kernel@x0r.fr>
---

diff -rupN -X linux-3.13.5.orig/Documentation/dontdiff linux-3.13.5.orig/Documentation/watchdog/watchdog-parameters.txt linux-3.13.5/Documentation/watchdog/watchdog-parameters.txt
--- linux-3.13.5.orig/Documentation/watchdog/watchdog-parameters.txt	2014-02-22 22:35:30.000000000 +0100
+++ linux-3.13.5/Documentation/watchdog/watchdog-parameters.txt	2014-03-06 09:51:36.330134802 +0100
@@ -150,6 +150,8 @@ nowayout: Disable watchdog shutdown on c
 -------------------------------------------------
 it87_wdt:
 nogameport: Forbid the activation of game port, default=0
+nocir: Forbid the use of CIR (workaround for some buggy setups); set to 1 if
+system resets despite watchdog daemon running, default=0
 exclusive: Watchdog exclusive device open, default=1
 timeout: Watchdog timeout in seconds, default=60
 testmode: Watchdog test mode (1 = no reboot), default=0
diff -rupN -X linux-3.13.5.orig/Documentation/dontdiff linux-3.13.5.orig/drivers/watchdog/it87_wdt.c linux-3.13.5/drivers/watchdog/it87_wdt.c
--- linux-3.13.5.orig/drivers/watchdog/it87_wdt.c	2014-02-22 22:35:30.000000000 +0100
+++ linux-3.13.5/drivers/watchdog/it87_wdt.c	2014-03-06 10:17:34.429991556 +0100
@@ -54,6 +54,7 @@
 
 /* Defaults for Module Parameter */
 #define DEFAULT_NOGAMEPORT	0
+#define DEFAULT_NOCIR		0
 #define DEFAULT_EXCLUSIVE	1
 #define DEFAULT_TIMEOUT		60
 #define DEFAULT_TESTMODE	0
@@ -136,11 +137,13 @@
 #define WDTS_LOCKED	3
 #define WDTS_USE_GP	4
 #define WDTS_EXPECTED	5
+#define WDTS_USE_CIR	6
 
 static	unsigned int base, gpact, ciract, max_units, chip_type;
 static	unsigned long wdt_status;
 
 static	int nogameport = DEFAULT_NOGAMEPORT;
+static int nocir      = DEFAULT_NOCIR;
 static	int exclusive  = DEFAULT_EXCLUSIVE;
 static	int timeout    = DEFAULT_TIMEOUT;
 static	int testmode   = DEFAULT_TESTMODE;
@@ -149,6 +152,9 @@ static	bool nowayout   = DEFAULT_NOWAYOU
 module_param(nogameport, int, 0);
 MODULE_PARM_DESC(nogameport, "Forbid the activation of game port, default="
 		__MODULE_STRING(DEFAULT_NOGAMEPORT));
+module_param(nocir, int, 0);
+MODULE_PARM_DESC(nocir, "Forbid the use of Consumer IR interrupts to reset timer, default="
+		__MODULE_STRING(DEFAULT_NOCIR));
 module_param(exclusive, int, 0);
 MODULE_PARM_DESC(exclusive, "Watchdog exclusive device open, default="
 		__MODULE_STRING(DEFAULT_EXCLUSIVE));
@@ -258,9 +264,17 @@ static void wdt_keepalive(void)
 {
 	if (test_bit(WDTS_USE_GP, &wdt_status))
 		inb(base);
-	else
+	else if (test_bit(WDTS_USE_CIR, &wdt_status))
 		/* The timer reloads with around 5 msec delay */
 		outb(0x55, CIR_DR(base));
+	else {
+		if (superio_enter())
+			return;
+
+		superio_select(GPIO);
+		wdt_update_timeout();
+		superio_exit();
+	}
 	set_bit(WDTS_KEEPALIVE, &wdt_status);
 }
 
@@ -273,7 +287,7 @@ static int wdt_start(void)
 	superio_select(GPIO);
 	if (test_bit(WDTS_USE_GP, &wdt_status))
 		superio_outb(WDT_GAMEPORT, WDTCTRL);
-	else
+	else if (test_bit(WDTS_USE_CIR, &wdt_status))
 		superio_outb(WDT_CIRINT, WDTCTRL);
 	wdt_update_timeout();
 
@@ -660,7 +674,7 @@ static int __init it87_wdt_init(void)
 	}
 
 	/* If we haven't Gameport support, try to get CIR support */
-	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+	if (!nocir && !test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
 			if (gp_rreq_fail)
 				pr_err("I/O Address 0x%04x and 0x%04x already in use\n",
@@ -682,6 +696,7 @@ static int __init it87_wdt_init(void)
 			superio_select(GAMEPORT);
 			superio_outb(gpact, ACTREG);
 		}
+		set_bit(WDTS_USE_CIR, &wdt_status);
 	}
 
 	if (timeout < 1 || timeout > max_units * 60) {
@@ -707,7 +722,7 @@ static int __init it87_wdt_init(void)
 	}
 
 	/* Initialize CIR to use it as keepalive source */
-	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+	if (test_bit(WDTS_USE_CIR, &wdt_status)) {
 		outb(0x00, CIR_RCR(base));
 		outb(0xc0, CIR_TCR1(base));
 		outb(0x5c, CIR_TCR2(base));
@@ -717,9 +732,9 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	pr_info("Chip IT%04x revision %d initialized. timeout=%d sec (nowayout=%d testmode=%d exclusive=%d nogameport=%d)\n",
+	pr_info("Chip IT%04x revision %d initialized. timeout=%d sec (nowayout=%d testmode=%d exclusive=%d nogameport=%d nocir=%d)\n",
 		chip_type, chip_rev, timeout,
-		nowayout, testmode, exclusive, nogameport);
+		nowayout, testmode, exclusive, nogameport, nocir);
 
 	superio_exit();
 	return 0;
@@ -727,8 +742,10 @@ static int __init it87_wdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region:
-	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
-	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+	if (test_bit(WDTS_USE_GP, &wdt_status))
+		release_region(base, 1);
+	else if (test_bit(WDTS_USE_CIR, &wdt_status)) {
+		release_region(base, 8);
 		superio_select(CIR);
 		superio_outb(ciract, ACTREG);
 	}
@@ -754,7 +771,7 @@ static void __exit it87_wdt_exit(void)
 		if (test_bit(WDTS_USE_GP, &wdt_status)) {
 			superio_select(GAMEPORT);
 			superio_outb(gpact, ACTREG);
-		} else {
+		} else if (test_bit(WDTS_USE_CIR, &wdt_status)) {
 			superio_select(CIR);
 			superio_outb(ciract, ACTREG);
 		}
@@ -763,7 +780,11 @@ static void __exit it87_wdt_exit(void)
 
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
+
+	if (test_bit(WDTS_USE_GP, &wdt_status))
+		release_region(base, 1);
+	else if (test_bit(WDTS_USE_CIR, &wdt_status))
+		release_region(base, 8);
 }
 
 module_init(it87_wdt_init);
