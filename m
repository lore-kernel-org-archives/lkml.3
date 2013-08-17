Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3HQU7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:59:09 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48593 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3HQU7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:59:06 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 6/8] watchdog: w83627hf: Add support for W83697HF and W83697UG
Date: Sat, 17 Aug 2013 13:58:44 -0700
Message-Id: <1376773126-2717-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major difference is that the watchdog control and counter registers
are different on both chips.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig        |    2 ++
 drivers/watchdog/w83627hf_wdt.c |   62 +++++++++++++++++++++++++++++++--------
 2 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 5d04ae4..9ec5f42 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -866,6 +866,8 @@ config W83627HF_WDT
 		W83637HF
 		W83667HG/HG-B
 		W83687THF
+		W83697HF
+		W83697UG
 		NCT6775
 		NCT6776
 		NCT6779
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index eb368f2..4c9f27a 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -45,10 +45,12 @@
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
 static int wdt_io;
+static int cr_wdt_timeout;	/* WDT timeout register */
+static int cr_wdt_control;	/* WDT control register */
 
-enum chips { w83627hf, w83627s, w83637hf, w83627thf, w83687thf,
-	     w83627ehf, w83627dhg, w83627uhg, w83667hg, w83627dhg_p, w83667hg_b,
-	     nct6775, nct6776, nct6779 };
+enum chips { w83627hf, w83627s, w83697hf, w83697ug, w83637hf, w83627thf,
+	     w83687thf, w83627ehf, w83627dhg, w83627uhg, w83667hg, w83627dhg_p,
+	     w83667hg_b, nct6775, nct6776, nct6779 };
 
 static int timeout;			/* in seconds */
 module_param(timeout, int, 0);
@@ -69,6 +71,8 @@ MODULE_PARM_DESC(timeout,
 
 #define W83627HF_ID		0x52
 #define W83627S_ID		0x59
+#define W83697HF_ID		0x60
+#define W83697UG_ID		0x68
 #define W83637HF_ID		0x70
 #define W83627THF_ID		0x82
 #define W83687THF_ID		0x85
@@ -82,6 +86,12 @@ MODULE_PARM_DESC(timeout,
 #define NCT6776_ID		0xc3
 #define NCT6779_ID		0xc5
 
+#define W83627HF_WDT_TIMEOUT	0xf6
+#define W83697HF_WDT_TIMEOUT	0xf4
+
+#define W83627HF_WDT_CONTROL	0xf5
+#define W83697HF_WDT_CONTROL	0xf3
+
 static void superio_outb(int reg, int val)
 {
 	outb(reg, WDT_EFER);
@@ -138,6 +148,17 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
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
@@ -146,10 +167,10 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 	case w83627dhg_p:
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
 		break;
@@ -170,25 +191,25 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 		 * Don't touch its configuration, and hope the BIOS
 		 * does the right thing.
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
 			wdog->timeout);
-		superio_outb(0xF6, wdog->timeout);
+		superio_outb(cr_wdt_timeout, wdog->timeout);
 	}
 
 	/* set second mode & disable keyboard turning off watchdog */
-	t = superio_inb(0xF5) & ~0x0C;
-	superio_outb(0xF5, t);
+	t = superio_inb(cr_wdt_control) & ~0x0C;
+	superio_outb(cr_wdt_control, t);
 
 	/* disable keyboard & mouse turning off watchdog */
 	t = superio_inb(0xF7) & ~0xC0;
@@ -208,7 +229,7 @@ static int wdt_set_time(unsigned int timeout)
 		return ret;
 
 	superio_select(W83627HF_LD_WDT);
-	superio_outb(0xF6, timeout);
+	superio_outb(cr_wdt_timeout, timeout);
 	superio_exit();
 
 	return 0;
@@ -242,7 +263,7 @@ static unsigned int wdt_get_time(struct watchdog_device *wdog)
 		return 0;
 
 	superio_select(W83627HF_LD_WDT);
-	timeleft = superio_inb(0xF6);
+	timeleft = superio_inb(cr_wdt_timeout);
 	superio_exit();
 
 	return timeleft;
@@ -300,6 +321,9 @@ static int wdt_find(int addr)
 	u8 val;
 	int ret;
 
+	cr_wdt_timeout = W83627HF_WDT_TIMEOUT;
+	cr_wdt_control = W83627HF_WDT_CONTROL;
+
 	ret = superio_enter();
 	if (ret)
 		return ret;
@@ -312,6 +336,16 @@ static int wdt_find(int addr)
 	case W83627S_ID:
 		ret = w83627s;
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
@@ -368,6 +402,8 @@ static int __init wdt_init(void)
 	const char * const chip_name[] = {
 		"W83627HF",
 		"W83627S",
+		"W83697HF",
+		"W83697UG",
 		"W83637HF",
 		"W83627THF",
 		"W83687THF",
-- 
1.7.9.7

