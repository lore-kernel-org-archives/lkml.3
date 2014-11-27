Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaK0MDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:03:23 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62969 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaK0MDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:03:20 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [RFC PATCH 1/4] rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time() to use time64_t
Date: Thu, 27 Nov 2014 20:02:37 +0800
Message-Id: <1417089760-26848-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to convert y2038 unsafe rtc_class_ops.set_mmss() and all its
users to use time64_t. mxc_rtc_set_mmss() in "mxc" driver is one of
its users, but it uses get_alarm_or_time()/set_alarm_or_time() internal
interfaces which are also y2038 unsafe.

So here as a separate patch, it converts these two internal interfaces
of "mxc" to use safe time64_t first, so as to make some preparations
for the rtc_class_ops.set_mmss() conversion.

Currently, "mxc" is the only driver with such issue.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-mxc.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 419874f..07bff34 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -106,7 +106,7 @@ static inline int is_imx1_rtc(struct rtc_plat_data *data)
  * This function is used to obtain the RTC time or the alarm value in
  * second.
  */
-static u32 get_alarm_or_time(struct device *dev, int time_alarm)
+static time64_t get_alarm_or_time(struct device *dev, int time_alarm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
@@ -129,29 +129,28 @@ static u32 get_alarm_or_time(struct device *dev, int time_alarm)
 	hr = hr_min >> 8;
 	min = hr_min & 0xff;
 
-	return (((day * 24 + hr) * 60) + min) * 60 + sec;
+	return ((((time64_t)day * 24 + hr) * 60) + min) * 60 + sec;
 }
 
 /*
  * This function sets the RTC alarm value or the time value.
  */
-static void set_alarm_or_time(struct device *dev, int time_alarm, u32 time)
+static void set_alarm_or_time(struct device *dev, int time_alarm, time64_t time)
 {
-	u32 day, hr, min, sec, temp;
+	u32 tod, day, hr, min, sec, temp;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
-	day = time / 86400;
-	time -= day * 86400;
+	day = div_s64_rem(time, 86400, &tod);
 
 	/* time is within a day now */
-	hr = time / 3600;
-	time -= hr * 3600;
+	hr = tod / 3600;
+	tod -= hr * 3600;
 
 	/* time is within an hour now */
-	min = time / 60;
-	sec = time - min * 60;
+	min = tod / 60;
+	sec = tod - min * 60;
 
 	temp = (hr << 8) + min;
 
@@ -176,20 +175,20 @@ static void set_alarm_or_time(struct device *dev, int time_alarm, u32 time)
 static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 {
 	struct rtc_time alarm_tm, now_tm;
-	unsigned long now, time;
+	time64_t now, time;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
 	now = get_alarm_or_time(dev, MXC_RTC_TIME);
-	rtc_time_to_tm(now, &now_tm);
+	rtc_time64_to_tm(now, &now_tm);
 	alarm_tm.tm_year = now_tm.tm_year;
 	alarm_tm.tm_mon = now_tm.tm_mon;
 	alarm_tm.tm_mday = now_tm.tm_mday;
 	alarm_tm.tm_hour = alrm->tm_hour;
 	alarm_tm.tm_min = alrm->tm_min;
 	alarm_tm.tm_sec = alrm->tm_sec;
-	rtc_tm_to_time(&alarm_tm, &time);
+	time = rtc_tm_to_time64(&alarm_tm);
 
 	/* clear all the interrupt status bits */
 	writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
@@ -283,14 +282,14 @@ static int mxc_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
  */
 static int mxc_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	u32 val;
+	time64_t val;
 
 	/* Avoid roll-over from reading the different registers */
 	do {
 		val = get_alarm_or_time(dev, MXC_RTC_TIME);
 	} while (val != get_alarm_or_time(dev, MXC_RTC_TIME));
 
-	rtc_time_to_tm(val, tm);
+	rtc_time64_to_tm(val, tm);
 
 	return 0;
 }
@@ -333,7 +332,7 @@ static int mxc_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
-	rtc_time_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
+	rtc_time64_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
 	alrm->pending = ((readw(ioaddr + RTC_RTCISR) & RTC_ALM_BIT)) ? 1 : 0;
 
 	return 0;
-- 
1.7.9.5

