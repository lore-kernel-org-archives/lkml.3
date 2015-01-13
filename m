Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbbAMPvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:51:38 -0500
Received: from m15-111.126.com ([220.181.15.111]:38593 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbbAMPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:51:35 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 7/9] rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time() to use time64_t
Date: Tue, 13 Jan 2015 23:44:55 +0800
Message-Id: <1421163897-8020-8-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S10
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy7ur1UKw4xtw48Wry5twb_yoW5KFW5pF
	47GayrtFWktFyagw18Crsrur4rKw18tayIq3Z3J34S9r1rJrykKF95Kry0yrWrKaykG3Zx
	J3WrZFyFvw4UWF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-WrXUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbirwGAv0X9vn1ScQAAsJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

We want to convert mxc_rtc_set_mmss() to use rtc_class_ops's set_mmss64(),
but it uses get_alarm_or_time()/set_alarm_or_time() internal interfaces
which are y2038 unsafe.

So here as a separate patch, it converts these two internal interfaces
of "mxc" to use safe time64_t to make some preparations.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-mxc.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index a7b218f..83cba23 100644
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
 
@@ -175,12 +174,12 @@ static void set_alarm_or_time(struct device *dev, int time_alarm, u32 time)
  */
 static void rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 {
-	unsigned long time;
+	time64_t time;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
-	rtc_tm_to_time(alrm, &time);
+	time = rtc_tm_to_time64(alrm);
 
 	/* clear all the interrupt status bits */
 	writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
@@ -272,14 +271,14 @@ static int mxc_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
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
@@ -322,7 +321,7 @@ static int mxc_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
-	rtc_time_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
+	rtc_time64_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
 	alrm->pending = ((readw(ioaddr + RTC_RTCISR) & RTC_ALM_BIT)) ? 1 : 0;
 
 	return 0;
-- 
1.9.1


