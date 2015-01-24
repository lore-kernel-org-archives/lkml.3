Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbbAXBpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:45:31 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56131 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbbAXBoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4/8] rtc: Update interface.c to use y2038-safe time interfaces
Date: Fri, 23 Jan 2015 17:43:56 -0800
Message-Id: <1422063840-2837-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

Currently, interface.c uses y2038 problematic rtc_tm_to_time()
and rtc_time_to_tm(). So replace them with their corresponding
y2038-safe versions: rtc_tm_to_time64() and rtc_time64_to_tm().

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/interface.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 45bfc28ee..37215cf 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -73,10 +73,8 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 	else if (rtc->ops->set_time)
 		err = rtc->ops->set_time(rtc->dev.parent, tm);
 	else if (rtc->ops->set_mmss) {
-		unsigned long secs;
-		err = rtc_tm_to_time(tm, &secs);
-		if (err == 0)
-			err = rtc->ops->set_mmss(rtc->dev.parent, secs);
+		time64_t secs64 = rtc_tm_to_time64(tm);
+		err = rtc->ops->set_mmss(rtc->dev.parent, secs64);
 	} else
 		err = -EINVAL;
 
@@ -105,7 +103,7 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 
 		err = rtc->ops->read_time(rtc->dev.parent, &old);
 		if (err == 0) {
-			rtc_time_to_tm(secs, &new);
+			rtc_time64_to_tm(secs, &new);
 
 			/*
 			 * avoid writing when we're going to change the day of
@@ -157,7 +155,7 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	int err;
 	struct rtc_time before, now;
 	int first_time = 1;
-	unsigned long t_now, t_alm;
+	time64_t t_now, t_alm;
 	enum { none, day, month, year } missing = none;
 	unsigned days;
 
@@ -258,8 +256,8 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	}
 
 	/* with luck, no rollover is needed */
-	rtc_tm_to_time(&now, &t_now);
-	rtc_tm_to_time(&alarm->time, &t_alm);
+	t_now = rtc_tm_to_time64(&now);
+	t_alm = rtc_tm_to_time64(&alarm->time);
 	if (t_now < t_alm)
 		goto done;
 
@@ -273,7 +271,7 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	case day:
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
 		t_alm += 24 * 60 * 60;
-		rtc_time_to_tm(t_alm, &alarm->time);
+		rtc_time64_to_tm(t_alm, &alarm->time);
 		break;
 
 	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
@@ -346,19 +344,19 @@ EXPORT_SYMBOL_GPL(rtc_read_alarm);
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

