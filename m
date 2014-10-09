Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaJITPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:15:11 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:39300 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaJITMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:12:32 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>,
        AnilKumar Ch <anilkumar@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 06/12] rtc: omap: use dev_info and dev_dbg
Date: Thu,  9 Oct 2014 21:06:28 +0200
Message-Id: <1412881594-25678-7-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_info and dev_dbg rather than pr_info and pr_debug.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index e50ffd7063f5..1c58920b0c88 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -392,13 +392,13 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	omap_rtc_timer = platform_get_irq(pdev, 0);
 	if (omap_rtc_timer <= 0) {
-		pr_debug("%s: no update irq?\n", pdev->name);
+		dev_dbg(&pdev->dev, "no update irq\n");
 		return -ENOENT;
 	}
 
 	omap_rtc_alarm = platform_get_irq(pdev, 1);
 	if (omap_rtc_alarm <= 0) {
-		pr_debug("%s: no alarm irq?\n", pdev->name);
+		dev_dbg(&pdev->dev, "no alarm irq\n");
 		return -ENOENT;
 	}
 
@@ -430,8 +430,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
 	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
-		pr_info("%s: RTC power up reset detected\n",
-			pdev->name);
+		dev_info(&pdev->dev, "RTC power up reset detected\n");
 		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
 	}
 	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
@@ -440,22 +439,22 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	/* handle periodic and alarm irqs */
 	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
 			dev_name(&pdev->dev), pdev)) {
-		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
-			pdev->name, omap_rtc_timer);
+		dev_dbg(&pdev->dev, "RTC timer interrupt IRQ%d already claimed\n",
+				omap_rtc_timer);
 		goto fail0;
 	}
 	if ((omap_rtc_timer != omap_rtc_alarm) &&
 		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
 			dev_name(&pdev->dev), pdev))) {
-		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
-			pdev->name, omap_rtc_alarm);
+		dev_dbg(&pdev->dev, "RTC alarm interrupt IRQ%d already claimed\n",
+				omap_rtc_alarm);
 		goto fail0;
 	}
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(OMAP_RTC_CTRL_REG);
 	if (reg & (u8) OMAP_RTC_CTRL_STOP)
-		pr_info("%s: already running\n", pdev->name);
+		dev_info(&pdev->dev, "already running\n");
 
 	/* force to 24 hour mode */
 	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
@@ -476,7 +475,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	 */
 
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
-		pr_info("%s: split power mode\n", pdev->name);
+		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
-- 
2.0.4

