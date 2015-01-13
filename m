Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbbAMPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:51:57 -0500
Received: from m15-111.126.com ([220.181.15.111]:38563 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbbAMPvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:51:31 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 4/9] rtc/ab3100: Update driver to address y2038/y2106 issues
Date: Tue, 13 Jan 2015 23:44:52 +0800
Message-Id: <1421163897-8020-5-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr48ZFW7Jw4kJF4UGFWUtwb_yoWrtw13pr
	43Kas8GF4ktr97urnYvr4kCry5Xw10q3yUKa93K3sI9wn8Grs8XF18Ca42k3W5JFykGF1x
	Kas5G3sFv3W5G3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jlUDJUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbijAiAv1GfT2gfQgAAsP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

This driver has a number of y2038/y2106 issues.

This patch resolves them by:
- Replace rtc_tm_to_time() with rtc_tm_to_time64()
- Replace rtc_time_to_tm() with rtc_time64_to_tm()
- Change ab3100_rtc_set_mmss() to use rtc_class_ops's set_mmss64()

After this patch, the driver should not have any remaining
y2038/y2106 issues.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-ab3100.c | 55 ++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index 1d0340f..9b725c5 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -43,21 +43,21 @@
 /*
  * RTC clock functions and device struct declaration
  */
-static int ab3100_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int ab3100_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	u8 regs[] = {AB3100_TI0, AB3100_TI1, AB3100_TI2,
 		     AB3100_TI3, AB3100_TI4, AB3100_TI5};
 	unsigned char buf[6];
-	u64 fat_time = (u64) secs * AB3100_RTC_CLOCK_RATE * 2;
+	u64 hw_counter = secs * AB3100_RTC_CLOCK_RATE * 2;
 	int err = 0;
 	int i;
 
-	buf[0] = (fat_time) & 0xFF;
-	buf[1] = (fat_time >> 8) & 0xFF;
-	buf[2] = (fat_time >> 16) & 0xFF;
-	buf[3] = (fat_time >> 24) & 0xFF;
-	buf[4] = (fat_time >> 32) & 0xFF;
-	buf[5] = (fat_time >> 40) & 0xFF;
+	buf[0] = (hw_counter) & 0xFF;
+	buf[1] = (hw_counter >> 8) & 0xFF;
+	buf[2] = (hw_counter >> 16) & 0xFF;
+	buf[3] = (hw_counter >> 24) & 0xFF;
+	buf[4] = (hw_counter >> 32) & 0xFF;
+	buf[5] = (hw_counter >> 40) & 0xFF;
 
 	for (i = 0; i < 6; i++) {
 		err = abx500_set_register_interruptible(dev, 0,
@@ -75,7 +75,7 @@ static int ab3100_rtc_set_mmss(struct device *dev, unsigned long secs)
 
 static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	unsigned long time;
+	time64_t time;
 	u8 rtcval;
 	int err;
 
@@ -88,7 +88,7 @@ static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		dev_info(dev, "clock not set (lost power)");
 		return -EINVAL;
 	} else {
-		u64 fat_time;
+		u64 hw_counter;
 		u8 buf[6];
 
 		/* Read out time registers */
@@ -98,22 +98,21 @@ static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		if (err != 0)
 			return err;
 
-		fat_time = ((u64) buf[5] << 40) | ((u64) buf[4] << 32) |
+		hw_counter = ((u64) buf[5] << 40) | ((u64) buf[4] << 32) |
 			((u64) buf[3] << 24) | ((u64) buf[2] << 16) |
 			((u64) buf[1] << 8) | (u64) buf[0];
-		time = (unsigned long) (fat_time /
-					(u64) (AB3100_RTC_CLOCK_RATE * 2));
+		time = hw_counter / (u64) (AB3100_RTC_CLOCK_RATE * 2);
 	}
 
-	rtc_time_to_tm(time, tm);
+	rtc_time64_to_tm(time, tm);
 
 	return rtc_valid_tm(tm);
 }
 
 static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
-	unsigned long time;
-	u64 fat_time;
+	time64_t time;
+	u64 hw_counter;
 	u8 buf[6];
 	u8 rtcval;
 	int err;
@@ -134,11 +133,11 @@ static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 						     AB3100_AL0, buf, 4);
 	if (err)
 		return err;
-	fat_time = ((u64) buf[3] << 40) | ((u64) buf[2] << 32) |
+	hw_counter = ((u64) buf[3] << 40) | ((u64) buf[2] << 32) |
 		((u64) buf[1] << 24) | ((u64) buf[0] << 16);
-	time = (unsigned long) (fat_time / (u64) (AB3100_RTC_CLOCK_RATE * 2));
+	time = hw_counter / (u64) (AB3100_RTC_CLOCK_RATE * 2);
 
-	rtc_time_to_tm(time, &alarm->time);
+	rtc_time64_to_tm(time, &alarm->time);
 
 	return rtc_valid_tm(&alarm->time);
 }
@@ -147,17 +146,17 @@ static int ab3100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	u8 regs[] = {AB3100_AL0, AB3100_AL1, AB3100_AL2, AB3100_AL3};
 	unsigned char buf[4];
-	unsigned long secs;
-	u64 fat_time;
+	time64_t secs;
+	u64 hw_counter;
 	int err;
 	int i;
 
-	rtc_tm_to_time(&alarm->time, &secs);
-	fat_time = (u64) secs * AB3100_RTC_CLOCK_RATE * 2;
-	buf[0] = (fat_time >> 16) & 0xFF;
-	buf[1] = (fat_time >> 24) & 0xFF;
-	buf[2] = (fat_time >> 32) & 0xFF;
-	buf[3] = (fat_time >> 40) & 0xFF;
+	secs = rtc_tm_to_time64(&alarm->time);
+	hw_counter = secs * AB3100_RTC_CLOCK_RATE * 2;
+	buf[0] = (hw_counter >> 16) & 0xFF;
+	buf[1] = (hw_counter >> 24) & 0xFF;
+	buf[2] = (hw_counter >> 32) & 0xFF;
+	buf[3] = (hw_counter >> 40) & 0xFF;
 
 	/* Set the alarm */
 	for (i = 0; i < 4; i++) {
@@ -193,7 +192,7 @@ static int ab3100_rtc_irq_enable(struct device *dev, unsigned int enabled)
 
 static const struct rtc_class_ops ab3100_rtc_ops = {
 	.read_time	= ab3100_rtc_read_time,
-	.set_mmss	= ab3100_rtc_set_mmss,
+	.set_mmss64	= ab3100_rtc_set_mmss,
 	.read_alarm	= ab3100_rtc_read_alarm,
 	.set_alarm	= ab3100_rtc_set_alarm,
 	.alarm_irq_enable = ab3100_rtc_irq_enable,
-- 
1.9.1


