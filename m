Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaCETc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:32:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59837 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaCETcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:32:25 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] rtc: pm8xxx: use devm_request_any_context_irq
Date: Wed,  5 Mar 2014 13:29:33 -0600
Message-Id: <1394047776-13827-4-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the devm_* variant of request_any_context_irq to allow for
elimination of remove().

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index f6d140a..ed3fe83 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -427,9 +427,10 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	}
 
 	/* Request the alarm IRQ */
-	rc = request_any_context_irq(rtc_dd->rtc_alarm_irq,
-				     pm8xxx_alarm_trigger, IRQF_TRIGGER_RISING,
-				     "pm8xxx_rtc_alarm", rtc_dd);
+	rc = devm_request_any_context_irq(&pdev->dev, rtc_dd->rtc_alarm_irq,
+					  pm8xxx_alarm_trigger,
+					  IRQF_TRIGGER_RISING,
+					  "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
 		return rc;
@@ -442,16 +443,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pm8xxx_rtc_remove(struct platform_device *pdev)
-{
-	struct pm8xxx_rtc *rtc_dd = platform_get_drvdata(pdev);
-
-	device_init_wakeup(&pdev->dev, 0);
-	free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
-
-	return 0;
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int pm8xxx_rtc_resume(struct device *dev)
 {
@@ -480,7 +471,6 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops,
 
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
-	.remove		= pm8xxx_rtc_remove,
 	.driver	= {
 		.name	= PM8XXX_RTC_DEV_NAME,
 		.owner	= THIS_MODULE,
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

