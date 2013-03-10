Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3CJXPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:15:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61035 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3CJXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:15:07 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 10 Mar 2013 18:15:04 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 2/7] watchdog: w83627hf: Enable watchdog only once
Date: Sun, 10 Mar 2013 16:14:55 -0700
Message-Id: <1362957300-18223-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unnecessary to enable the logical device and WDT0 each time
the watchdog is accessed. Do it only once during initialization.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: No change

 drivers/watchdog/w83627hf_wdt.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 51a22ab..bb19368 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -66,28 +66,10 @@ MODULE_PARM_DESC(timeout,
 
 static void w83627hf_select_wd_register(void)
 {
-	unsigned char c;
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
 	outb_p(0x87, WDT_EFER); /* Again according to manual */
-
-	outb(0x20, WDT_EFER);	/* check chip version	*/
-	c = inb(WDT_EFDR);
-	if (c == 0x82) {	/* W83627THF		*/
-		outb_p(0x2b, WDT_EFER); /* select GPIO3 */
-		c = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
-		outb_p(0x2b, WDT_EFER);
-		outb_p(c, WDT_EFDR);	/* set GPIO3 to WDT0 */
-	} else if (c == 0x88 || c == 0xa0) {	/* W83627EHF / W83627DHG */
-		outb_p(0x2d, WDT_EFER); /* select GPIO5 */
-		c = inb_p(WDT_EFDR) & ~0x01; /* PIN77 -> WDT0# */
-		outb_p(0x2d, WDT_EFER);
-		outb_p(c, WDT_EFDR); /* set GPIO5 to WDT0 */
-	}
-
 	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
 	outb_p(0x08, WDT_EFDR); /* select logical device 8 (GPIO2) */
-	outb_p(0x30, WDT_EFER); /* select CR30 */
-	outb_p(0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
 }
 
 static void w83627hf_unselect_wd_register(void)
@@ -104,6 +86,23 @@ static void w83627hf_init(struct watchdog_device *wdog)
 
 	w83627hf_select_wd_register();
 
+	outb(0x20, WDT_EFER);	/* check chip version	*/
+	t = inb(WDT_EFDR);
+	if (t == 0x82) {	/* W83627THF		*/
+		outb_p(0x2b, WDT_EFER); /* select GPIO3 */
+		t = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
+		outb_p(0x2b, WDT_EFER);
+		outb_p(t, WDT_EFDR);	/* set GPIO3 to WDT0 */
+	} else if (t == 0x88 || t == 0xa0) {	/* W83627EHF / W83627DHG */
+		outb_p(0x2d, WDT_EFER); /* select GPIO5 */
+		t = inb_p(WDT_EFDR) & ~0x01; /* PIN77 -> WDT0# */
+		outb_p(0x2d, WDT_EFER);
+		outb_p(t, WDT_EFDR); /* set GPIO5 to WDT0 */
+	}
+
+	outb_p(0x30, WDT_EFER); /* select CR30 */
+	outb_p(0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
+
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
-- 
1.7.9.7

