Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbbATQWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:22:25 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:41967 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbbATQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:22:23 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 7/8] rtc/mxc: Update driver to address y2038/y2106 issues
Date: Tue, 20 Jan 2015 16:21:38 +0000
Message-Id: <1421770899-4136-8-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has a number of y2038/y2106 issues.

This patch resolves them by:
- Replace rtc_time_to_tm() with rtc_time64_to_tm()
- Replace rtc_tm_to_time() with rtc_tm_to_time64()
- Change mxc_rtc_set_mmss() to use rtc_class_ops's set_mmss64()

After this patch, the driver should not have any remaining
y2038/y2106 issues.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-mxc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 83cba23..09d422b 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -286,7 +286,7 @@ static int mxc_rtc_read_time(struct device *dev, struct rtc_time *tm)
 /*
  * This function sets the internal RTC time based on tm in Gregorian date.
  */
-static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
+static int mxc_rtc_set_mmss(struct device *dev, time64_t time)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
@@ -297,9 +297,9 @@ static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 	if (is_imx1_rtc(pdata)) {
 		struct rtc_time tm;
 
-		rtc_time_to_tm(time, &tm);
+		rtc_time64_to_tm(time, &tm);
 		tm.tm_year = 70;
-		rtc_tm_to_time(&tm, &time);
+		time = rtc_tm_to_time64(&tm);
 	}
 
 	/* Avoid roll-over from reading the different registers */
@@ -347,7 +347,7 @@ static int mxc_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 static struct rtc_class_ops mxc_rtc_ops = {
 	.release		= mxc_rtc_release,
 	.read_time		= mxc_rtc_read_time,
-	.set_mmss		= mxc_rtc_set_mmss,
+	.set_mmss64		= mxc_rtc_set_mmss,
 	.read_alarm		= mxc_rtc_read_alarm,
 	.set_alarm		= mxc_rtc_set_alarm,
 	.alarm_irq_enable	= mxc_rtc_alarm_irq_enable,
-- 
1.9.1

