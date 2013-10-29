Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3J2K4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:56:08 -0400
Received: from 19.mo6.mail-out.ovh.net ([188.165.56.177]:38282 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349Ab3J2K4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:56:06 -0400
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 06:56:06 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] watchdog: at91sam9_wdt: various fixes
Date: Tue, 29 Oct 2013 11:37:33 +0100
Message-Id: <1383043053-3520-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131029075028.GF19704@spo001.leaseweb.com>
References: <20131029075028.GF19704@spo001.leaseweb.com>
X-Ovh-Tracer-Id: 10360249469713873080
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the secs_to_ticks macro in case 0 is passed as an argument.

Rework the heartbeat calculation to increase the security margin of the
watchdog reset timer.

Use the min_heartbeat value instead of the calculated heartbeat value for
the first watchdog reset.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/watchdog/at91sam9_wdt.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 9bd089e..f1b59f1 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -51,7 +51,7 @@
 #define ticks_to_hz_rounddown(t)	((((t) + 1) * HZ) >> 8)
 #define ticks_to_hz_roundup(t)		(((((t) + 1) * HZ) + 255) >> 8)
 #define ticks_to_secs(t)		(((t) + 1) >> 8)
-#define secs_to_ticks(s)		(((s) << 8) - 1)
+#define secs_to_ticks(s)		(s ? (((s) << 8) - 1) : 0)
 
 #define WDT_MR_RESET	0x3FFF2FFF
 
@@ -61,6 +61,11 @@
 /* Watchdog max delta/value in secs */
 #define WDT_COUNTER_MAX_SECS	ticks_to_secs(WDT_COUNTER_MAX_TICKS)
 
+/* Watchdog heartbeat shift used for security margin:
+ * we'll try to rshift the heartbeat value with this value to secure
+ * the watchdog reset. */
+#define WDT_HEARTBEAT_SHIFT	2
+
 /* Hardware timeout in seconds */
 #define WDT_HW_TIMEOUT 2
 
@@ -158,7 +163,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 	int err;
 	u32 mask = wdt->mr_mask;
 	unsigned long min_heartbeat = 1;
+	unsigned long max_heartbeat;
 	struct device *dev = &pdev->dev;
+	int shift;
 
 	tmp = wdt_read(wdt, AT91_WDT_MR);
 	if ((tmp & mask) != (wdt->mr & mask)) {
@@ -181,23 +188,27 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 	if (delta < value)
 		min_heartbeat = ticks_to_hz_roundup(value - delta);
 
-	wdt->heartbeat = ticks_to_hz_rounddown(value);
-	if (!wdt->heartbeat) {
+	max_heartbeat = ticks_to_hz_rounddown(value);
+	if (!max_heartbeat) {
 		dev_err(dev,
 			"heartbeat is too small for the system to handle it correctly\n");
 		return -EINVAL;
 	}
 
-	if (wdt->heartbeat < min_heartbeat + 4) {
+	for (shift = WDT_HEARTBEAT_SHIFT; shift > 0; shift--) {
+		if ((max_heartbeat >> shift) < min_heartbeat)
+			continue;
+
+		wdt->heartbeat = max_heartbeat >> shift;
+		break;
+	}
+
+	if (!shift)
 		wdt->heartbeat = min_heartbeat;
+
+	if (max_heartbeat < min_heartbeat + 4)
 		dev_warn(dev,
 			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
-		if (wdt->heartbeat < 4)
-			dev_warn(dev,
-				 "heartbeat might be too small for the system to handle it correctly\n");
-	} else {
-		wdt->heartbeat -= 4;
-	}
 
 	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
 		err = request_irq(wdt->irq, wdt_interrupt,
@@ -213,7 +224,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 			 tmp & wdt->mr_mask, wdt->mr & wdt->mr_mask);
 
 	setup_timer(&wdt->timer, at91_ping, (unsigned long)wdt);
-	mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
+	/* Use min_heartbeat the first time because the watchdog timer might
+	 * be running for a long time when we reach this init function. */
+	mod_timer(&wdt->timer, jiffies + min_heartbeat);
 
 	/* Try to set timeout from device tree first */
 	if (watchdog_init_timeout(&wdt->wdd, 0, dev))
-- 
1.7.9.5

