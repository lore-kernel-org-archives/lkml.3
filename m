Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3EOVic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:38:32 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35077 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3EOVia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:38:30 -0400
From: Todd Poynor <toddpoynor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 1/2] alarmtimer: add functions for timerfd support
Date: Wed, 15 May 2013 14:38:11 -0700
Message-Id: <1368653892-18939-2-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368653892-18939-1-git-send-email-toddpoynor@google.com>
References: <1368653892-18939-1-git-send-email-toddpoynor@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions needed for hooking up alarmtimer to timerfd:

* alarm_restart: Similar to hrtimer_restart, restart an alarmtimer after
  the expires time has already been updated (as with alarm_forward).

* alarm_forward_now: Similar to hrtimer_forward_now, move the expires
  time forward to an interval from the current time of the associated clock.

* alarm_start_relative: Start an alarmtimer with an expires time relative to
  the current time of the associated clock.

* alarm_expires_remaining: Similar to hrtimer_expires_remaining, return the
  amount of time remaining until alarm expiry.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 include/linux/alarmtimer.h |  4 ++++
 kernel/time/alarmtimer.c   | 39 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
index 9069694..a899402 100644
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -44,10 +44,14 @@ struct alarm {
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 		enum alarmtimer_restart (*function)(struct alarm *, ktime_t));
 int alarm_start(struct alarm *alarm, ktime_t start);
+int alarm_start_relative(struct alarm *alarm, ktime_t start);
+void alarm_restart(struct alarm *alarm);
 int alarm_try_to_cancel(struct alarm *alarm);
 int alarm_cancel(struct alarm *alarm);
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval);
+ktime_t alarm_expires_remaining(const struct alarm *alarm);
 
 /* Provide way to access the rtc device being used by alarmtimers */
 struct rtc_device *alarmtimer_get_rtcdev(void);
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..3e5cba2 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -199,6 +199,12 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 
 }
 
+ktime_t alarm_expires_remaining(const struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	return ktime_sub(alarm->node.expires, base->gettime());
+}
+
 #ifdef CONFIG_RTC_CLASS
 /**
  * alarmtimer_suspend - Suspend time callback
@@ -305,7 +311,7 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 }
 
 /**
- * alarm_start - Sets an alarm to fire
+ * alarm_start - Sets an absolute alarm to fire
  * @alarm: ptr to alarm to set
  * @start: time to run the alarm
  */
@@ -325,6 +331,31 @@ int alarm_start(struct alarm *alarm, ktime_t start)
 }
 
 /**
+ * alarm_start_relative - Sets a relative alarm to fire
+ * @alarm: ptr to alarm to set
+ * @start: time relative to now to run the alarm
+ */
+int alarm_start_relative(struct alarm *alarm, ktime_t start)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+
+	start = ktime_add(start, base->gettime());
+	return alarm_start(alarm, start);
+}
+
+void alarm_restart(struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	unsigned long flags;
+
+	spin_lock_irqsave(&base->lock, flags);
+	hrtimer_set_expires(&alarm->timer, alarm->node.expires);
+	hrtimer_restart(&alarm->timer);
+	alarmtimer_enqueue(base, alarm);
+	spin_unlock_irqrestore(&base->lock, flags);
+}
+
+/**
  * alarm_try_to_cancel - Tries to cancel an alarm timer
  * @alarm: ptr to alarm to be canceled
  *
@@ -394,6 +425,12 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 	return overrun;
 }
 
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+
+	return alarm_forward(alarm, base->gettime(), interval);
+}
 
 
 
-- 
1.8.2.1

