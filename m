Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbbAVCcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:32:10 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47035 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbbAVCcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:32:07 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 1/5] drivers/rtc/interface.c: Update code to use y2038-safe time interfaces
Date: Thu, 22 Jan 2015 02:31:51 +0000
Message-Id: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, interface.c uses y2038 problematic rtc_tm_to_time()
and rtc_time_to_tm(). So replace them with their corresponding
y2038-safe versions: rtc_tm_to_time64() and rtc_time64_to_tm().

Reviewed-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/interface.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index db44df8..c6be2bb 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -76,10 +76,8 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 		time64_t secs64 = rtc_tm_to_time64(tm);
 		err = rtc->ops->set_mmss64(rtc->dev.parent, secs64);
 	} else if (rtc->ops->set_mmss) {
-		unsigned long secs;
-		err = rtc_tm_to_time(tm, &secs);
-		if (err == 0)
-			err = rtc->ops->set_mmss(rtc->dev.parent, secs);
+		time64_t secs64 = rtc_tm_to_time64(tm);
+		err = rtc->ops->set_mmss(rtc->dev.parent, secs64);
 	} else
 		err = -EINVAL;
 
@@ -110,7 +108,7 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 
 		err = rtc->ops->read_time(rtc->dev.parent, &old);
 		if (err == 0) {
-			rtc_time_to_tm(secs, &new);
+			rtc_time64_to_tm(secs, &new);
 
 			/*
 			 * avoid writing when we're going to change the day of
@@ -162,7 +160,7 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	int err;
 	struct rtc_time before, now;
 	int first_time = 1;
-	unsigned long t_now, t_alm;
+	time64_t t_now, t_alm;
 	enum { none, day, month, year } missing = none;
 	unsigned days;
 
@@ -263,8 +261,8 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	}
 
 	/* with luck, no rollover is needed */
-	rtc_tm_to_time(&now, &t_now);
-	rtc_tm_to_time(&alarm->time, &t_alm);
+	t_now = rtc_tm_to_time64(&now);
+	t_alm = rtc_tm_to_time64(&alarm->time);
 	if (t_now < t_alm)
 		goto done;
 
@@ -278,7 +276,7 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	case day:
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
 		t_alm += 24 * 60 * 60;
-		rtc_time_to_tm(t_alm, &alarm->time);
+		rtc_time64_to_tm(t_alm, &alarm->time);
 		break;
 
 	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
@@ -351,19 +349,19 @@ EXPORT_SYMBOL_GPL(rtc_read_alarm);
 static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	struct rtc_time tm;
-	long now, scheduled;
+	time64_t now, scheduled;
 	int err;
 
 	err = rtc_valid_tm(&alarm->time);
 	if (err)
 		return err;
-	rtc_tm_to_time(&alarm->time, &scheduled);
+	scheduled = rtc_tm_to_time64(&alarm->time);
 
 	/* Make sure we're not setting alarms in the past */
 	err = __rtc_read_time(rtc, &tm);
 	if (err)
 		return err;
-	rtc_tm_to_time(&tm, &now);
+	now = rtc_tm_to_time64(&tm);
 	if (scheduled <= now)
 		return -ETIME;
 	/*
-- 
1.9.1

