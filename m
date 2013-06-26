Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3FZXKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:10:04 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37586 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3FZXKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:10:02 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Zoran Markovic <zoran.markovic@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: [RFC PATCH] rtc: keep system awake until all expired RTC timers are handled
Date: Wed, 26 Jun 2013 16:09:13 -0700
Message-Id: <1372288153-4731-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation of RTC interface allows for system suspend to
occur in the following cases:
(a) if a timer is set in the past and rtc_timer_do_work() is scheduled
to handle it, and
(b) if rtc_timer_do_work() is called to handle expired timers whose
handlers implement a preemption point.

A pending suspend request may be honoured in the above cases causing
timer handling to be delayed until after the next resume. This is
undesirable since timer handlers may have time-critical code to execute.

This patch makes sure that the system stays awake until all expired
timers are handled.

Note that all calls to pm_stay_awake() are eventually paired with
the single pm_relax() call in rtc_timer_do_work(), which is launched
using schedule_work().

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arve Hjonnevag <arve@android.com>
Cc: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/rtc/interface.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 42bd57d..dace26e 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -72,6 +72,7 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 	} else
 		err = -EINVAL;
 
+	pm_stay_awake(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 	/* A timer might have just expired */
 	schedule_work(&rtc->irqwork);
@@ -113,6 +114,7 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 	else
 		err = -EINVAL;
 
+	pm_stay_awake(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 	/* A timer might have just expired */
 	schedule_work(&rtc->irqwork);
@@ -771,9 +773,10 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 		alarm.time = rtc_ktime_to_tm(timer->node.expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
-		if (err == -ETIME)
+		if (err == -ETIME) {
+			pm_stay_awake(rtc->dev.parent);
 			schedule_work(&rtc->irqwork);
-		else if (err) {
+		} else if (err) {
 			timerqueue_del(&rtc->timerqueue, &timer->node);
 			timer->enabled = 0;
 			return err;
@@ -818,8 +821,10 @@ static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
-		if (err == -ETIME)
+		if (err == -ETIME) {
+			pm_stay_awake(rtc->dev.parent);
 			schedule_work(&rtc->irqwork);
+		}
 	}
 }
 
@@ -845,7 +850,6 @@ void rtc_timer_do_work(struct work_struct *work)
 
 	mutex_lock(&rtc->ops_lock);
 again:
-	pm_relax(rtc->dev.parent);
 	__rtc_read_time(rtc, &tm);
 	now = rtc_tm_to_ktime(tm);
 	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
@@ -880,6 +884,7 @@ again:
 	} else
 		rtc_alarm_disable(rtc);
 
+	pm_relax(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 }
 
-- 
1.7.9.5

