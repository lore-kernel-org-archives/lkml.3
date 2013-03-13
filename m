Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3CMGuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:50:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57949 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab3CMGut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:50:49 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <a.zummo@towertech.it>,
        "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Subject: [PATCH] rtc: omap: update to devm_* API
Date: Wed, 13 Mar 2013 12:21:04 +0530
Message-ID: <1363157464-9962-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com> 

Update the code to use devm_* API so that driver
core will manage resources.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
Applied on top of linux-next: 
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
with tag next-20130312.

:100644 100644 172cc5c... a1f9d30... M	drivers/rtc/rtc-omap.c
 drivers/rtc/rtc-omap.c |   45 +++++++++------------------------------------
 1 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 172cc5c..a1f9d30 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -324,7 +324,7 @@ MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
 
 static int __init omap_rtc_probe(struct platform_device *pdev)
 {
-	struct resource		*res, *mem;
+	struct resource		*res;
 	struct rtc_device	*rtc;
 	u8			reg, new_ctrl;
 	const struct platform_device_id *id_entry;
@@ -352,18 +352,9 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	mem = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!mem) {
-		pr_debug("%s: RTC registers at %08x are not free\n",
-			pdev->name, res->start);
-		return -EBUSY;
-	}
-
-	rtc_base = ioremap(res->start, resource_size(res));
-	if (!rtc_base) {
-		pr_debug("%s: RTC registers can't be mapped\n", pdev->name);
-		goto fail;
-	}
+	rtc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc_base))
+		return PTR_ERR(rtc_base);
 
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_enable(&pdev->dev);
@@ -375,7 +366,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		pr_debug("%s: can't register RTC device, err %ld\n",
@@ -383,7 +374,6 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		goto fail0;
 	}
 	platform_set_drvdata(pdev, rtc);
-	dev_set_drvdata(&rtc->dev, mem);
 
 	/* clear pending irqs, and set 1/second periodic,
 	 * which we'll use instead of update irqs
@@ -401,18 +391,18 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
-	if (request_irq(omap_rtc_timer, rtc_irq, 0,
+	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
 			dev_name(&rtc->dev), rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
-		goto fail1;
+		goto fail0;
 	}
 	if ((omap_rtc_timer != omap_rtc_alarm) &&
-		(request_irq(omap_rtc_alarm, rtc_irq, 0,
+		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
 			dev_name(&rtc->dev), rtc))) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
-		goto fail2;
+		goto fail0;
 	}
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
@@ -446,25 +436,16 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail2:
-	free_irq(omap_rtc_timer, rtc);
-fail1:
-	rtc_device_unregister(rtc);
 fail0:
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	iounmap(rtc_base);
-fail:
-	release_mem_region(mem->start, resource_size(mem));
 	return -EIO;
 }
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device	*rtc = platform_get_drvdata(pdev);
-	struct resource		*mem = dev_get_drvdata(&rtc->dev);
 	const struct platform_device_id *id_entry =
 				platform_get_device_id(pdev);
 
@@ -473,12 +454,6 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 	/* leave rtc running, but disable irqs */
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
-	free_irq(omap_rtc_timer, rtc);
-
-	if (omap_rtc_timer != omap_rtc_alarm)
-		free_irq(omap_rtc_alarm, rtc);
-
-	rtc_device_unregister(rtc);
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 
@@ -486,8 +461,6 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	iounmap(rtc_base);
-	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
-- 
1.7.4.1

