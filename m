Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3HQU7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:59:05 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47699 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3HQU7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:59:01 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 4/8] watchdog: w83627hf: Use helper functions to access superio registers
Date: Sat, 17 Aug 2013 13:58:42 -0700
Message-Id: <1376773126-2717-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions named similar to other drivers to access
superio registers.

Request memory region only when needed, and use request_muxed_region().
This lets other devices (hwmon, gpio) use the same region.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/w83627hf_wdt.c |  132 ++++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 56 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 13bad31..04cf20f 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -64,80 +64,102 @@ MODULE_PARM_DESC(timeout,
 							(same as EFER) */
 #define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
 
-static void w83627hf_select_wd_register(void)
+#define W83627HF_LD_WDT		0x08
+
+static void superio_outb(int reg, int val)
+{
+	outb(reg, WDT_EFER);
+	outb(val, WDT_EFDR);
+}
+
+static inline int superio_inb(int reg)
+{
+	outb(reg, WDT_EFER);
+	return inb(WDT_EFDR);
+}
+
+static int superio_enter(void)
 {
+	if (!request_muxed_region(wdt_io, 2, WATCHDOG_NAME))
+		return -EBUSY;
+
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
 	outb_p(0x87, WDT_EFER); /* Again according to manual */
-	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
-	outb_p(0x08, WDT_EFDR); /* select logical device 8 (GPIO2) */
+
+	return 0;
 }
 
-static void w83627hf_unselect_wd_register(void)
+static void superio_select(int ld)
+{
+	superio_outb(0x07, ld);
+}
+
+static void superio_exit(void)
 {
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
+	release_region(wdt_io, 2);
 }
 
 /* tyan motherboards seem to set F5 to 0x4C ?
  * So explicitly init to appropriate value. */
 
-static void w83627hf_init(struct watchdog_device *wdog)
+static int w83627hf_init(struct watchdog_device *wdog)
 {
+	int ret;
 	unsigned char t;
 
-	w83627hf_select_wd_register();
+	ret = superio_enter();
+	if (ret)
+		return ret;
 
-	outb(0x20, WDT_EFER);	/* check chip version	*/
-	t = inb(WDT_EFDR);
+	superio_select(W83627HF_LD_WDT);
+	t = superio_inb(0x20);	/* check chip version	*/
 	if (t == 0x82) {	/* W83627THF		*/
-		outb_p(0x2b, WDT_EFER); /* select GPIO3 */
-		t = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
-		outb_p(0x2b, WDT_EFER);
-		outb_p(t, WDT_EFDR);	/* set GPIO3 to WDT0 */
+		t = (superio_inb(0x2b) & 0xf7);
+		superio_outb(0x2b, t | 0x04); /* set GPIO3 to WDT0 */
 	} else if (t == 0x88 || t == 0xa0) {	/* W83627EHF / W83627DHG */
-		outb_p(0x2d, WDT_EFER); /* select GPIO5 */
-		t = inb_p(WDT_EFDR) & ~0x01; /* PIN77 -> WDT0# */
-		outb_p(0x2d, WDT_EFER);
-		outb_p(t, WDT_EFDR); /* set GPIO5 to WDT0 */
+		t = superio_inb(0x2d);
+		superio_outb(0x2d, t & ~0x01);	/* set GPIO5 to WDT0 */
 	}
 
-	outb_p(0x30, WDT_EFER); /* select CR30 */
-	t = inb(WDT_EFDR);
+	/* set CR30 bit 0 to activate GPIO2 */
+	t = superio_inb(0x30);
 	if (!(t & 0x01))
-		outb_p(t | 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
+		superio_outb(0x30, t | 0x01);
 
-	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
-	t = inb_p(WDT_EFDR);      /* read CRF6 */
+	t = superio_inb(0xF6);
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
 			wdog->timeout);
-		outb_p(wdog->timeout, WDT_EFDR);	/* Write back to CRF6 */
+		superio_outb(0xF6, wdog->timeout);
 	}
 
-	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
-	t = inb_p(WDT_EFDR);      /* read CRF5 */
-	t &= ~0x0C;               /* set second mode & disable keyboard
-				    turning off watchdog */
-	t |= 0x02;		  /* enable the WDTO# output low pulse
-				    to the KBRST# pin (PIN60) */
-	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
-
-	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
-	t = inb_p(WDT_EFDR);      /* read CRF7 */
-	t &= ~0xC0;               /* disable keyboard & mouse turning off
-				    watchdog */
-	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
-
-	w83627hf_unselect_wd_register();
+	/* set second mode & disable keyboard turning off watchdog */
+	t = superio_inb(0xF5) & ~0x0C;
+	/* enable the WDTO# output low pulse to the KBRST# pin */
+	t |= 0x02;
+	superio_outb(0xF5, t);
+
+	/* disable keyboard & mouse turning off watchdog */
+	t = superio_inb(0xF7) & ~0xC0;
+	superio_outb(0xF7, t);
+
+	superio_exit();
+
+	return 0;
 }
 
 static int wdt_set_time(unsigned int timeout)
 {
-	w83627hf_select_wd_register();
+	int ret;
 
-	outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
-	outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF6 */
+	ret = superio_enter();
+	if (ret)
+		return ret;
 
-	w83627hf_unselect_wd_register();
+	superio_select(W83627HF_LD_WDT);
+	superio_outb(0xF6, timeout);
+	superio_exit();
 
 	return 0;
 }
@@ -163,13 +185,15 @@ static int wdt_set_timeout(struct watchdog_device *wdog, unsigned int timeout)
 static unsigned int wdt_get_time(struct watchdog_device *wdog)
 {
 	unsigned int timeleft;
+	int ret;
 
-	w83627hf_select_wd_register();
-
-	outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
-	timeleft = inb_p(WDT_EFDR); /* Read Timeout counter to CRF6 */
+	ret = superio_enter();
+	if (ret)
+		return 0;
 
-	w83627hf_unselect_wd_register();
+	superio_select(W83627HF_LD_WDT);
+	timeleft = superio_inb(0xF6);
+	superio_exit();
 
 	return timeleft;
 }
@@ -228,20 +252,19 @@ static int __init wdt_init(void)
 
 	pr_info("WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising\n");
 
-	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		pr_err("I/O address 0x%04x already in use\n", wdt_io);
-		return -EIO;
-	}
-
 	watchdog_init_timeout(&wdt_dev, timeout, NULL);
 	watchdog_set_nowayout(&wdt_dev, nowayout);
 
-	w83627hf_init(&wdt_dev);
+	ret = w83627hf_init(&wdt_dev);
+	if (ret) {
+		pr_err("failed to initialize watchdog (err=%d)\n", ret);
+		return ret;
+	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
 		pr_err("cannot register reboot notifier (err=%d)\n", ret);
-		goto unreg_regions;
+		return ret;
 	}
 
 	ret = watchdog_register_device(&wdt_dev);
@@ -255,8 +278,6 @@ static int __init wdt_init(void)
 
 unreg_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
-unreg_regions:
-	release_region(wdt_io, 1);
 	return ret;
 }
 
@@ -264,7 +285,6 @@ static void __exit wdt_exit(void)
 {
 	watchdog_unregister_device(&wdt_dev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(wdt_io, 1);
 }
 
 module_init(wdt_init);
-- 
1.7.9.7

