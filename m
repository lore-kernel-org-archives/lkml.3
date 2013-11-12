Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3KLKDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:03:40 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10310 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3KLKDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:03:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Nov 2013 02:01:54 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] drivers/rtc/rtc-as3722: use devm for rtc and irq registration
Date: Tue, 12 Nov 2013 15:32:02 +0530
Message-ID: <1384250522-26791-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* calls for rtc and irq registration and get rid of
remove callback for platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-as3722.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/rtc-as3722.c b/drivers/rtc/rtc-as3722.c
index 9cfa817..4af0169 100644
--- a/drivers/rtc/rtc-as3722.c
+++ b/drivers/rtc/rtc-as3722.c
@@ -198,7 +198,7 @@ static int as3722_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	as3722_rtc->rtc = rtc_device_register("as3722", &pdev->dev,
+	as3722_rtc->rtc = devm_rtc_device_register(&pdev->dev, "as3722-rtc",
 				&as3722_rtc_ops, THIS_MODULE);
 	if (IS_ERR(as3722_rtc->rtc)) {
 		ret = PTR_ERR(as3722_rtc->rtc);
@@ -209,28 +209,16 @@ static int as3722_rtc_probe(struct platform_device *pdev)
 	as3722_rtc->alarm_irq = platform_get_irq(pdev, 0);
 	dev_info(&pdev->dev, "RTC interrupt %d\n", as3722_rtc->alarm_irq);
 
-	ret = request_threaded_irq(as3722_rtc->alarm_irq, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, as3722_rtc->alarm_irq, NULL,
 			as3722_alarm_irq, IRQF_ONESHOT | IRQF_EARLY_RESUME,
 			"rtc-alarm", as3722_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 				as3722_rtc->alarm_irq, ret);
-		goto scrub;
+		return ret;
 	}
 	disable_irq(as3722_rtc->alarm_irq);
 	return 0;
-scrub:
-	rtc_device_unregister(as3722_rtc->rtc);
-	return ret;
-}
-
-static int as3722_rtc_remove(struct platform_device *pdev)
-{
-	struct as3722_rtc *as3722_rtc = platform_get_drvdata(pdev);
-
-	free_irq(as3722_rtc->alarm_irq, as3722_rtc);
-	rtc_device_unregister(as3722_rtc->rtc);
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -260,7 +248,6 @@ static const struct dev_pm_ops as3722_rtc_pm_ops = {
 
 static struct platform_driver as3722_rtc_driver = {
 	.probe = as3722_rtc_probe,
-	.remove = as3722_rtc_remove,
 	.driver = {
 		.name = "as3722-rtc",
 		.pm = &as3722_rtc_pm_ops,
-- 
1.7.1.1

