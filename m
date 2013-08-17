Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3HQVAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 17:00:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47630 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3HQU7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:59:03 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 5/8] watchdog: w83627hf: Auto-detect IO address and supported chips
Date: Sat, 17 Aug 2013 13:58:43 -0700
Message-Id: <1376773126-2717-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of requiring the user to provide an IO address per module
parameter, auto-detect it as well as supported chips.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig        |   15 +++-
 drivers/watchdog/w83627hf_wdt.c |  182 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 173 insertions(+), 24 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index c73db85..5d04ae4 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -856,13 +856,20 @@ config VIA_WDT
 	Most people will say N.
 
 config W83627HF_WDT
-	tristate "W83627HF/W83627DHG Watchdog Timer"
+	tristate "Watchdog timer for W83627HF/W83627DHG and compatibles"
 	depends on X86
 	select WATCHDOG_CORE
 	---help---
-	  This is the driver for the hardware watchdog on the W83627HF chipset
-	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
-	  (and likely others). The driver also supports the W83627DHG chip.
+	  This is the driver for the hardware watchdog on the following
+	  Super I/O chips.
+		W83627DHG/DHG-P/EHF/EHG/F/G/HF/S/SF/THF/UHG/UG
+		W83637HF
+		W83667HG/HG-B
+		W83687THF
+		NCT6775
+		NCT6776
+		NCT6779
+
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 04cf20f..eb368f2 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -44,10 +44,11 @@
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
-/* You must set this - there is no sane way to probe for this board. */
-static int wdt_io = 0x2E;
-module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
+static int wdt_io;
+
+enum chips { w83627hf, w83627s, w83637hf, w83627thf, w83687thf,
+	     w83627ehf, w83627dhg, w83627uhg, w83667hg, w83627dhg_p, w83667hg_b,
+	     nct6775, nct6776, nct6779 };
 
 static int timeout;			/* in seconds */
 module_param(timeout, int, 0);
@@ -66,6 +67,21 @@ MODULE_PARM_DESC(timeout,
 
 #define W83627HF_LD_WDT		0x08
 
+#define W83627HF_ID		0x52
+#define W83627S_ID		0x59
+#define W83637HF_ID		0x70
+#define W83627THF_ID		0x82
+#define W83687THF_ID		0x85
+#define W83627EHF_ID		0x88
+#define W83627DHG_ID		0xa0
+#define W83627UHG_ID		0xa2
+#define W83667HG_ID		0xa5
+#define W83627DHG_P_ID		0xb0
+#define W83667HG_B_ID		0xb3
+#define NCT6775_ID		0xb4
+#define NCT6776_ID		0xc3
+#define NCT6779_ID		0xc5
+
 static void superio_outb(int reg, int val)
 {
 	outb(reg, WDT_EFER);
@@ -100,10 +116,7 @@ static void superio_exit(void)
 	release_region(wdt_io, 2);
 }
 
-/* tyan motherboards seem to set F5 to 0x4C ?
- * So explicitly init to appropriate value. */
-
-static int w83627hf_init(struct watchdog_device *wdog)
+static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 {
 	int ret;
 	unsigned char t;
@@ -113,20 +126,59 @@ static int w83627hf_init(struct watchdog_device *wdog)
 		return ret;
 
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
+	case w83627s:
+		t = superio_inb(0x2B) & ~0x10;
+		superio_outb(0x2B, t); /* set GPIO24 to WDT0 */
+		break;
+	case w83627thf:
+		t = (superio_inb(0x2B) & ~0x08) | 0x04;
+		superio_outb(0x2B, t); /* set GPIO3 to WDT0 */
+		break;
+	case w83627dhg:
+	case w83627dhg_p:
+		t = superio_inb(0x2D) & ~0x01; /* PIN77 -> WDT0# */
+		superio_outb(0x2D, t); /* set GPIO5 to WDT0 */
+		t = superio_inb(0xF5);
+		t |= 0x02;	/* enable the WDTO# output low pulse
+				 * to the KBRST# pin */
+		superio_outb(0xF5, t);
+		break;
+	case w83637hf:
+		break;
+	case w83687thf:
+		t = superio_inb(0x2C) & ~0x80; /* PIN47 -> WDT0# */
+		superio_outb(0x2C, t);
+		break;
+	case w83627ehf:
+	case w83627uhg:
+	case w83667hg:
+	case w83667hg_b:
+	case nct6775:
+	case nct6776:
+	case nct6779:
+		/*
+		 * These chips have a fixed WDTO# output pin (W83627UHG),
+		 * or support more than one WDTO# output pin.
+		 * Don't touch its configuration, and hope the BIOS
+		 * does the right thing.
+		 */
+		t = superio_inb(0xF5);
+		t |= 0x02;	/* enable the WDTO# output low pulse
+				 * to the KBRST# pin */
+		superio_outb(0xF5, t);
+		break;
+	default:
+		break;
+	}
+
 	t = superio_inb(0xF6);
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
@@ -136,8 +188,6 @@ static int w83627hf_init(struct watchdog_device *wdog)
 
 	/* set second mode & disable keyboard turning off watchdog */
 	t = superio_inb(0xF5) & ~0x0C;
-	/* enable the WDTO# output low pulse to the KBRST# pin */
-	t |= 0x02;
 	superio_outb(0xF5, t);
 
 	/* disable keyboard & mouse turning off watchdog */
@@ -245,17 +295,109 @@ static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
+static int wdt_find(int addr)
+{
+	u8 val;
+	int ret;
+
+	ret = superio_enter();
+	if (ret)
+		return ret;
+	superio_select(W83627HF_LD_WDT);
+	val = superio_inb(0x20);
+	switch (val) {
+	case W83627HF_ID:
+		ret = w83627hf;
+		break;
+	case W83627S_ID:
+		ret = w83627s;
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
+	case W83627DHG_P_ID:
+		ret = w83627dhg_p;
+		break;
+	case W83627UHG_ID:
+		ret = w83627uhg;
+		break;
+	case W83667HG_ID:
+		ret = w83667hg;
+		break;
+	case W83667HG_B_ID:
+		ret = w83667hg_b;
+		break;
+	case NCT6775_ID:
+		ret = nct6775;
+		break;
+	case NCT6776_ID:
+		ret = nct6776;
+		break;
+	case NCT6779_ID:
+		ret = nct6779;
+		break;
+	case 0xff:
+		ret = -ENODEV;
+		break;
+	default:
+		ret = -ENODEV;
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
+		"W83627S",
+		"W83637HF",
+		"W83627THF",
+		"W83687THF",
+		"W83627EHF",
+		"W83627DHG",
+		"W83627UHG",
+		"W83667HG",
+		"W83667DHG-P",
+		"W83667HG-B",
+		"NCT6775",
+		"NCT6776",
+		"NCT6779",
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
+	pr_info("WDT driver for %s Super I/O chip initialising\n",
+		chip_name[chip]);
 
 	watchdog_init_timeout(&wdt_dev, timeout, NULL);
 	watchdog_set_nowayout(&wdt_dev, nowayout);
 
-	ret = w83627hf_init(&wdt_dev);
+	ret = w83627hf_init(&wdt_dev, chip);
 	if (ret) {
 		pr_err("failed to initialize watchdog (err=%d)\n", ret);
 		return ret;
-- 
1.7.9.7

