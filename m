Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbbAMPrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:47:33 -0500
Received: from m15-111.126.com ([220.181.15.111]:37351 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbbAMPqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:39 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 8/9] rtc/mxc: Update driver to address y2038/y2106 issues
Date: Tue, 13 Jan 2015 23:44:56 +0800
Message-Id: <1421163897-8020-9-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S11
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr4UKw4UCr1ftF1rAr4fZrb_yoW8CFWrpF
	srCayDJFs7Kr9Ig3WkGF4kCF1fG3W0qrW8Kr15KanY9w1rXFykJFy8CrWUtry5Ja4kCa13
	Ww15Cw1Yv3W5CaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jdNVgUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbigQKAv1E0a1uClwAAs8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

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


