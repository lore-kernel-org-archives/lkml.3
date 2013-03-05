Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab3CEEyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:54:41 -0500
Received: from mail.active-venture.com ([67.228.131.205]:60349 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab3CEEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:54:34 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 04 Mar 2013 22:54:33 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5/8] watchdog: w83627hf: Auto-detect IO address and supported chips
Date: Mon,  4 Mar 2013 20:54:16 -0800
Message-Id: <1362459259-9733-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
References: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of requiring the user to provide an IO address per module
parameter, auto-detect it as well as supported chips.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/w83627hf_wdt.c |  121 ++++++++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 20 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 8ae71fb..3a2ba30 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -44,10 +44,10 @@
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
-/* You must set this - there is no sane way to probe for this board. */
-static int wdt_io = 0x2E;
-module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
+static int wdt_io;
+
+enum chips { w83627hf, w83637hf, w83627thf, w83687thf, w83627ehf, w83627dhg,
+	     w83627uhg };
 
 /*
  *	Kernel methods.
@@ -60,6 +60,14 @@ MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
 #define W83627HF_LD_WDT		0x08
 
+#define W83627HF_ID		0x52
+#define W83637HF_ID		0x70
+#define W83627THF_ID		0x82
+#define W83687THF_ID		0x85
+#define W83627EHF_ID		0x88
+#define W83627DHG_ID		0xa0
+#define W83627UHG_ID		0xa2
+
 static void superio_outb(int reg, int val)
 {
 	outb(reg, WDT_EFER);
@@ -88,29 +96,44 @@ static void superio_exit(void)
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
 }
 
-/* tyan motherboards seem to set F5 to 0x4C ?
- * So explicitly init to appropriate value. */
-
-static void w83627hf_init(void)
+static void w83627hf_init(enum chips chip)
 {
 	unsigned char t;
 
 	superio_enter();
 	superio_select(W83627HF_LD_WDT);
-	t = superio_inb(0x20);	/* check chip version	*/
-	if (t == 0x82) {	/* W83627THF		*/
-		t = (superio_inb(0x2b) & 0xf7);
-		superio_outb(0x2b, t | 0x04); /* set GPIO3 to WDT0 */
-	} else if (t == 0x88 || t == 0xa0) {	/* W83627EHF / W83627DHG */
-		t = superio_inb(0x2d);
-		superio_outb(0x2d, t & ~0x01);	/* set GPIO5 to WDT0 */
-	}
 
 	/* set CR30 bit 0 to activate GPIO2 */
 	t = superio_inb(0x30);
 	if (!(t & 0x01))
 		superio_outb(0x30, t | 0x01);
 
+	switch (chip) {
+	case w83627hf:
+		t = superio_inb(0x2B) & ~0x10;
+		superio_outb(0x2B, t); /* set GPIO24 to WDT0 */
+		break;
+	case w83627thf:
+		t = (superio_inb(0x2B) & ~0x08) | 0x04;
+		superio_outb(0x2B, t); /* set GPIO3 to WDT0 */
+		break;
+	case w83627ehf:
+	case w83627dhg:
+	case w83627uhg:
+		t = superio_inb(0x2D) & ~0x01; /* PIN77 -> WDT0# */
+		superio_outb(0x2D, t); /* set GPIO5 to WDT0 */
+		t = superio_inb(0xF5);
+		t |= 0x02;	/* enable the WDTO# output low pulse
+				 * to the KBRST# pin */
+		superio_outb(0xF5, t);
+		break;
+	case w83637hf:
+	case w83687thf:
+		break;
+	default:
+		break;
+	}
+
 	t = superio_inb(0xF6);
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
@@ -120,8 +143,6 @@ static void w83627hf_init(void)
 
 	/* set second mode & disable keyboard turning off watchdog */
 	t = superio_inb(0xF5) & ~0x0C;
-	/* enable the WDTO# output low pulse to the KBRST# pin */
-	t |= 0x02;
 	superio_outb(0xF5, t);
 
 	/* disable keyboard & mouse turning off watchdog */
@@ -217,19 +238,79 @@ static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
+static int wdt_find(int addr)
+{
+	u8 val;
+	int ret = -ENODEV;
+
+	superio_enter();
+	superio_select(W83627HF_LD_WDT);
+	val = superio_inb(0x20);
+	switch (val) {
+	case W83627HF_ID:
+		ret = w83627hf;
+		break;
+	case W83637HF_ID:
+		ret = w83637hf;
+		break;
+	case W83627THF_ID:
+		ret = w83627thf;
+		break;
+	case W83687THF_ID:
+		ret = w83687thf;
+		break;
+	case W83627EHF_ID:
+		ret = w83627ehf;
+		break;
+	case W83627DHG_ID:
+		ret = w83627dhg;
+		break;
+	case W83627UHG_ID:
+		ret = w83627uhg;
+		break;
+	case 0xff:
+		break;
+	default:
+		pr_err("Unsupported chip ID: 0x%02x\n", val);
+		break;
+	}
+	superio_exit();
+	return ret;
+}
+
 static int __init wdt_init(void)
 {
 	int ret;
 	bool nowayout = WATCHDOG_NOWAYOUT;
+	int chip;
+	const char * const chip_name[] = {
+		"W83627HF",
+		"W83637HF",
+		"W83627THF",
+		"W83687THF",
+		"W83627EHF",
+		"W83627DHG",
+		"W83627UHG",
+	};
+
+	wdt_io = 0x2e;
+	chip = wdt_find(0x2e);
+	if (chip < 0) {
+		wdt_io = 0x4e;
+		chip = wdt_find(0x4e);
+		if (chip < 0)
+			return chip;
+	}
 
-	pr_info("WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising\n");
+	pr_info("WDT driver for %s Super I/O chip initialising, nowayout=%d\n",
+		chip_name[chip], nowayout);
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
 		pr_err("I/O address 0x%04x already in use\n", wdt_io);
 		return -EIO;
 	}
 
-	w83627hf_init();
+	w83627hf_init(chip);
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-- 
1.7.9.7

