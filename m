Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaIJBbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:31:42 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42607 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaIJBbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:31:39 -0400
From: Richard Larocque <rlarocque@google.com>
To: tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>
Subject: [PATCH 3/3] alarmtimer: Lock k_itimer during timer callback
Date: Tue,  9 Sep 2014 18:31:05 -0700
Message-Id: <1410312665-25381-4-git-send-email-rlarocque@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410312665-25381-1-git-send-email-rlarocque@google.com>
References: <1410312665-25381-1-git-send-email-rlarocque@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locks the k_itimer's it_lock member when handling the alarm timer's
expiry callback.

The regular posix timers defined in posix-timers.c have this lock held
during timout processing because their callbacks are routed through
posix_timer_fn().  The alarm timers follow a different path, so they
ought to grab the lock somewhere else.

Signed-off-by: Richard Larocque <rlarocque@google.com>
---

I'm not at all sure this makes sense.  Feel free to drop this patch if the
extra locking is wrong or unnecessary.  It's here for discussion purposes only.

It's not entirely clear to me what the it_lock is supposed to protect, but it
does seem very odd that the alarm timers don't hold it when their callback is
in progress, while the regular timers do hold it.

The comments at the top of the file specify that the it_lock should not be
modified by timer code, but I'm not sure that's applicable if the timer code
doesn't leverage posix_timer_fn().  Since the alarm timer's call to
posix_event_timer() goes through alarm_handle_timer() instead, nothing actually
grabs that lock before the call to posix_event_timer().

 kernel/time/alarmtimer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 091d660..5f5e5c9 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -464,8 +464,12 @@ static enum alarmtimer_type clock2alarm(clockid_t clockid)
 static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 							ktime_t now)
 {
+	unsigned long flags;
 	struct k_itimer *ptr = container_of(alarm, struct k_itimer,
 						it.alarm.alarmtimer);
+	enum alarmtimer_restart result = ALARMTIMER_NORESTART;
+
+	spin_lock_irqsave(&ptr->it_lock, flags);
 	if ((ptr->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
 		if (posix_timer_event(ptr, 0) != 0)
 			ptr->it_overrun++;
@@ -475,9 +479,11 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 	if (ptr->it.alarm.interval.tv64) {
 		ptr->it_overrun += alarm_forward(alarm, now,
 						ptr->it.alarm.interval);
-		return ALARMTIMER_RESTART;
+		result = ALARMTIMER_RESTART;
 	}
-	return ALARMTIMER_NORESTART;
+	spin_unlock_irqrestore(&ptr->it_lock, flags);
+
+	return result;
 }
 
 /**
-- 
2.1.0.rc2.206.gedb03e5

