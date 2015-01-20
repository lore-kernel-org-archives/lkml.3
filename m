Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbbATQXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:23:38 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51675 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbATQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:22:21 -0500
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
Subject: [RFC PATCH v3 4/8] rtc/mc13xxx: Update driver to address y2038/y2106 issues
Date: Tue, 20 Jan 2015 16:21:35 +0000
Message-Id: <1421770899-4136-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has a number of y2038/y2106 issues.

This patch resolves them by:
- Replace rtc_time_to_tm() with rtc_time64_to_tm()
- Change mc13xxx_rtc_set_mmss() to use rtc_class_ops's set_mmss64()

After this patch, the driver should not have any remaining
y2038/y2106 issues.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-mc13xxx.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 5bce904b..32df1d8 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -83,20 +83,19 @@ static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 			return ret;
 	} while (days1 != days2);
 
-	rtc_time_to_tm(days1 * SEC_PER_DAY + seconds, tm);
+	rtc_time64_to_tm((time64_t)days1 * SEC_PER_DAY + seconds, tm);
 
 	return rtc_valid_tm(tm);
 }
 
-static int mc13xxx_rtc_set_mmss(struct device *dev, unsigned long secs)
+static int mc13xxx_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
 	unsigned int seconds, days;
 	unsigned int alarmseconds;
 	int ret;
 
-	seconds = secs % SEC_PER_DAY;
-	days = secs / SEC_PER_DAY;
+	days = div_s64_rem(secs, SEC_PER_DAY, &seconds);
 
 	mc13xxx_lock(priv->mc13xxx);
 
@@ -159,7 +158,7 @@ static int mc13xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
 	unsigned seconds, days;
-	unsigned long s1970;
+	time64_t s1970;
 	int enabled, pending;
 	int ret;
 
@@ -189,10 +188,10 @@ out:
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
@@ -200,8 +199,8 @@ out:
 static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
-	unsigned long s1970;
-	unsigned seconds, days;
+	time64_t s1970;
+	u32 seconds, days;
 	int ret;
 
 	mc13xxx_lock(priv->mc13xxx);
@@ -215,20 +214,17 @@ static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
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
@@ -268,7 +264,7 @@ static irqreturn_t mc13xxx_rtc_update_handler(int irq, void *dev)
 
 static const struct rtc_class_ops mc13xxx_rtc_ops = {
 	.read_time = mc13xxx_rtc_read_time,
-	.set_mmss = mc13xxx_rtc_set_mmss,
+	.set_mmss64 = mc13xxx_rtc_set_mmss,
 	.read_alarm = mc13xxx_rtc_read_alarm,
 	.set_alarm = mc13xxx_rtc_set_alarm,
 	.alarm_irq_enable = mc13xxx_rtc_alarm_irq_enable,
-- 
1.9.1

