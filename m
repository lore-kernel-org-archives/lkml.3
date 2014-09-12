Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaILVWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:22:46 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47840 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaILVWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:22:42 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Richard Larocque <rlarocque@google.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4/4] alarmtimer: Lock k_itimer during timer callback
Date: Fri, 12 Sep 2014 14:22:24 -0700
Message-Id: <1410556944-14944-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
References: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Larocque <rlarocque@google.com>

Locks the k_itimer's it_lock member when handling the alarm timer's
expiry callback.

The regular posix timers defined in posix-timers.c have this lock held
during timout processing because their callbacks are routed through
posix_timer_fn().  The alarm timers follow a different path, so they
ought to grab the lock somewhere else.

Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: Richard Larocque <rlarocque@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 41a9253..a7077d3 100644
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
1.9.1

