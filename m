Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaCJSrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:47:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37163 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaCJSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:47:45 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-msm@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] rtc: pm8xxx: use devm_request_any_context_irq
Date: Mon, 10 Mar 2014 13:44:46 -0500
Message-Id: <1394477089-3996-4-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the devm_* variant of request_any_context_irq to allow for
elimination of remove().

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index cdc9dc2..91ac2e3 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -434,9 +434,10 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
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
@@ -449,16 +450,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
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
@@ -487,7 +478,6 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops,
 
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
-	.remove		= pm8xxx_rtc_remove,
 	.driver	= {
 		.name	= PM8XXX_RTC_DEV_NAME,
 		.owner	= THIS_MODULE,
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

