Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaKRLUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:20:37 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35478 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaKRLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:20:34 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 5/5] rtc/mc13xxx: Eliminate time problems
Date: Tue, 18 Nov 2014 19:15:20 +0800
Message-Id: <1416309320-7498-6-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
References: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an example to demonstrate how to make rtc drivers
of time-safe hardwares time-safe based on our foregoing work.

Provided mc13xxx_rtc_set_mmss() has been already converted to use
64-bit seconds which will be done in my future patches, now we can
easily tackle all time problems in rtc-mc13xxx.c(time-safe hardware):
- Replace rtc_time_to_tm() with rtc_time64_to_tm()
- Replace rtc_tm_to_time() with rtc_tm_to_time64()

Then, this driver can work properly with no time issues.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-mc13xxx.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 0765606..124996d 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -83,7 +83,7 @@ static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 			return ret;
 	} while (days1 != days2);
 
-	rtc_time_to_tm(days1 * SEC_PER_DAY + seconds, tm);
+	rtc_time64_to_tm((time64_t)days1 * SEC_PER_DAY + seconds, tm);
 
 	return rtc_valid_tm(tm);
 }
@@ -159,7 +159,7 @@ static int mc13xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
 	unsigned seconds, days;
-	unsigned long s1970;
+	time64_t s1970;
 	int enabled, pending;
 	int ret;
 
@@ -189,10 +189,10 @@ out:
 	alarm->enabled = enabled;
 	alarm->pending = pending;
 
-	s1970 = days * SEC_PER_DAY + seconds;
+	s1970 = (time64_t)days * SEC_PER_DAY + seconds;
 
-	rtc_time_to_tm(s1970, &alarm->time);
-	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
+	rtc_time64_to_tm(s1970, &alarm->time);
+	dev_dbg(dev, "%s: %lld\n", __func__, (long long)s1970);
 
 	return 0;
 }
@@ -200,8 +200,8 @@ out:
 static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
-	unsigned long s1970;
-	unsigned seconds, days;
+	time64_t s1970;
+	u32 seconds, days;
 	int ret;
 
 	mc13xxx_lock(priv->mc13xxx);
@@ -215,20 +215,17 @@ static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	if (unlikely(ret))
 		goto out;
 
-	ret = rtc_tm_to_time(&alarm->time, &s1970);
-	if (unlikely(ret))
-		goto out;
+	s1970 = rtc_tm_to_time64(&alarm->time);
 
-	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff",
-			s1970);
+	dev_dbg(dev, "%s: o%2.s %lld\n", __func__, alarm->enabled ? "n" : "ff",
+			(long long)s1970);
 
 	ret = mc13xxx_rtc_irq_enable_unlocked(dev, alarm->enabled,
 			MC13XXX_IRQ_TODA);
 	if (unlikely(ret))
 		goto out;
 
-	seconds = s1970 % SEC_PER_DAY;
-	days = s1970 / SEC_PER_DAY;
+	days = div_s64_rem(s1970, SEC_PER_DAY, &seconds);
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCDAYA, days);
 	if (unlikely(ret))
-- 
1.7.9.5

