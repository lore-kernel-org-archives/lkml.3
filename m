Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462AbaJURpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:45:06 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:56836 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357AbaJURoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:54 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 04/20] rtc: omap: clean up probe error handling
Date: Tue, 21 Oct 2014 19:37:50 +0200
Message-Id: <1413913086-12730-5-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some debug messages and return errors from subsystems rather than
always fail with -EIO.

Note that the class-registration error has already been logged by rtc
core.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 813d475fe7c6..6b10db5a5702 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -379,6 +379,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	u8			reg, new_ctrl;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
+	int ret;
 
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
 	if (of_id)
@@ -391,16 +392,12 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	}
 
 	omap_rtc_timer = platform_get_irq(pdev, 0);
-	if (omap_rtc_timer <= 0) {
-		pr_debug("%s: no update irq?\n", pdev->name);
+	if (omap_rtc_timer <= 0)
 		return -ENOENT;
-	}
 
 	omap_rtc_alarm = platform_get_irq(pdev, 1);
-	if (omap_rtc_alarm <= 0) {
-		pr_debug("%s: no alarm irq?\n", pdev->name);
+	if (omap_rtc_alarm <= 0)
 		return -ENOENT;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	rtc_base = devm_ioremap_resource(&pdev->dev, res);
@@ -421,9 +418,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		pr_debug("%s: can't register RTC device, err %ld\n",
-			pdev->name, PTR_ERR(rtc));
-		goto fail0;
+		ret = PTR_ERR(rtc);
+		goto err;
 	}
 	platform_set_drvdata(pdev, rtc);
 
@@ -451,18 +447,16 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
-	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
-			dev_name(&rtc->dev), rtc)) {
-		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
-			pdev->name, omap_rtc_timer);
-		goto fail0;
-	}
-	if ((omap_rtc_timer != omap_rtc_alarm) &&
-		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
-			dev_name(&rtc->dev), rtc))) {
-		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
-			pdev->name, omap_rtc_alarm);
-		goto fail0;
+	ret = devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
+			dev_name(&rtc->dev), rtc);
+	if (ret)
+		goto err;
+
+	if (omap_rtc_timer != omap_rtc_alarm) {
+		ret = devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
+				dev_name(&rtc->dev), rtc);
+		if (ret)
+			goto err;
 	}
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
@@ -496,13 +490,14 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail0:
+err:
 	device_init_wakeup(&pdev->dev, false);
 	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	return -EIO;
+
+	return ret;
 }
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
-- 
2.0.4

