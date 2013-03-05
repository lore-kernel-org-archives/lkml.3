Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab3CEEzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:55:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52531 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3CEEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:54:38 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 04 Mar 2013 22:54:34 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7/8] watchdog: w83627hf: Add support for W83697HF and W83697UG
Date: Mon,  4 Mar 2013 20:54:18 -0800
Message-Id: <1362459259-9733-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
References: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major difference is that the watchdog control and counter registers
are different on both chips.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig        |    2 ++
 drivers/watchdog/w83627hf_wdt.c |   60 +++++++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 346bc70..acdd347 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -868,6 +868,8 @@ config W83627HF_WDT
 		W83637HF
 		W83667HG-B
 		W83687THF
+		W83697HF
+		W83697UG
 		NCT6775
 		NCT6776
 
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index b23f296..2acac16 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -45,9 +45,11 @@
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
 static int wdt_io;
+static int cr_wdt_timeout;	/* WDT timeout register */
+static int cr_wdt_control;	/* WDT control register */
 
-enum chips { w83627hf, w83637hf, w83627thf, w83687thf, w83627ehf, w83627dhg,
-	     w83627uhg, w83667hg_b, nct6775, nct6776 };
+enum chips { w83627hf, w83697hf, w83697ug, w83637hf, w83627thf, w83687thf,
+	     w83627ehf, w83627dhg, w83627uhg, w83667hg_b, nct6775, nct6776 };
 
 /*
  *	Kernel methods.
@@ -61,6 +63,8 @@ enum chips { w83627hf, w83637hf, w83627thf, w83687thf, w83627ehf, w83627dhg,
 #define W83627HF_LD_WDT		0x08
 
 #define W83627HF_ID		0x52
+#define W83697HF_ID		0x60
+#define W83697UG_ID		0x68
 #define W83637HF_ID		0x70
 #define W83627THF_ID		0x82
 #define W83687THF_ID		0x85
@@ -71,6 +75,12 @@ enum chips { w83627hf, w83637hf, w83627thf, w83687thf, w83627ehf, w83627dhg,
 #define NCT6775_ID		0xb4
 #define NCT6776_ID		0xc3
 
+#define W83627HF_WDT_TIMEOUT	0xf6
+#define W83697HF_WDT_TIMEOUT	0xf4
+
+#define W83627HF_WDT_CONTROL	0xf5
+#define W83697HF_WDT_CONTROL	0xf3
+
 static void superio_outb(int reg, int val)
 {
 	outb(reg, WDT_EFER);
@@ -116,6 +126,17 @@ static void w83627hf_init(enum chips chip)
 		t = superio_inb(0x2B) & ~0x10;
 		superio_outb(0x2B, t); /* set GPIO24 to WDT0 */
 		break;
+	case w83697hf:
+		/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
+		t = superio_inb(0x29) & ~0x60;
+		t |= 0x20;
+		superio_outb(0x29, t);
+		break;
+	case w83697ug:
+		/* Set pin 118 to WDTO# mode */
+		t = superio_inb(0x2b) & ~0x04;
+		superio_outb(0x2b, t);
+		break;
 	case w83627thf:
 		t = (superio_inb(0x2B) & ~0x08) | 0x04;
 		superio_outb(0x2B, t); /* set GPIO3 to WDT0 */
@@ -125,10 +146,10 @@ static void w83627hf_init(enum chips chip)
 	case w83627uhg:
 		t = superio_inb(0x2D) & ~0x01; /* PIN77 -> WDT0# */
 		superio_outb(0x2D, t); /* set GPIO5 to WDT0 */
-		t = superio_inb(0xF5);
+		t = superio_inb(cr_wdt_control);
 		t |= 0x02;	/* enable the WDTO# output low pulse
 				 * to the KBRST# pin */
-		superio_outb(0xF5, t);
+		superio_outb(cr_wdt_control, t);
 		break;
 	case w83637hf:
 	case w83687thf:
@@ -140,25 +161,25 @@ static void w83627hf_init(enum chips chip)
 		 * These chips support more than one WDTO# output pin.
 		 * Don't touch it, and hope the BIOS does the right thing.
 		 */
-		t = superio_inb(0xF5);
+		t = superio_inb(cr_wdt_control);
 		t |= 0x02;	/* enable the WDTO# output low pulse
 				 * to the KBRST# pin */
-		superio_outb(0xF5, t);
+		superio_outb(cr_wdt_control, t);
 		break;
 	default:
 		break;
 	}
 
-	t = superio_inb(0xF6);
+	t = superio_inb(cr_wdt_timeout);
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
 			WATCHDOG_TIMEOUT);
-		superio_outb(0xf6, WATCHDOG_TIMEOUT);
+		superio_outb(cr_wdt_timeout, WATCHDOG_TIMEOUT);
 	}
 
 	/* set second mode & disable keyboard turning off watchdog */
-	t = superio_inb(0xF5) & ~0x0C;
-	superio_outb(0xF5, t);
+	t = superio_inb(cr_wdt_control) & ~0x0C;
+	superio_outb(cr_wdt_control, t);
 
 	/* disable keyboard & mouse turning off watchdog */
 	t = superio_inb(0xF7) & ~0xC0;
@@ -171,7 +192,7 @@ static int wdt_set_time(unsigned int timeout)
 {
 	superio_enter();
 	superio_select(W83627HF_LD_WDT);
-	superio_outb(0xF6, timeout);
+	superio_outb(cr_wdt_timeout, timeout);
 	superio_exit();
 	return 0;
 }
@@ -200,7 +221,7 @@ static unsigned int wdt_get_time(struct watchdog_device *wdog)
 
 	superio_enter();
 	superio_select(W83627HF_LD_WDT);
-	timeleft = superio_inb(0xF6);
+	timeleft = superio_inb(cr_wdt_timeout);
 	superio_exit();
 
 	return timeleft;
@@ -258,6 +279,9 @@ static int wdt_find(int addr)
 	u8 val;
 	int ret = -ENODEV;
 
+	cr_wdt_timeout = W83627HF_WDT_TIMEOUT;
+	cr_wdt_control = W83627HF_WDT_CONTROL;
+
 	superio_enter();
 	superio_select(W83627HF_LD_WDT);
 	val = superio_inb(0x20);
@@ -265,6 +289,16 @@ static int wdt_find(int addr)
 	case W83627HF_ID:
 		ret = w83627hf;
 		break;
+	case W83697HF_ID:
+		ret = w83697hf;
+		cr_wdt_timeout = W83697HF_WDT_TIMEOUT;
+		cr_wdt_control = W83697HF_WDT_CONTROL;
+		break;
+	case W83697UG_ID:
+		ret = w83697ug;
+		cr_wdt_timeout = W83697HF_WDT_TIMEOUT;
+		cr_wdt_control = W83697HF_WDT_CONTROL;
+		break;
 	case W83637HF_ID:
 		ret = w83637hf;
 		break;
@@ -309,6 +343,8 @@ static int __init wdt_init(void)
 	int chip;
 	const char * const chip_name[] = {
 		"W83627HF",
+		"W83697HF",
+		"W83697UG",
 		"W83637HF",
 		"W83627THF",
 		"W83687THF",
-- 
1.7.9.7

