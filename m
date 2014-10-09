Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbaJIVLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaJIVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        Richard Larocque <rlarocque@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 065/163] alarmtimer: Lock k_itimer during timer callback
Date: Thu,  9 Oct 2014 14:01:30 -0700
Message-Id: <1412888588-26755-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Larocque <rlarocque@google.com>

commit 474e941bed9262f5fa2394f9a4a67e24499e5926 upstream.

Locks the k_itimer's it_lock member when handling the alarm timer's
expiry callback.

The regular posix timers defined in posix-timers.c have this lock held
during timout processing because their callbacks are routed through
posix_timer_fn().  The alarm timers follow a different path, so they
ought to grab the lock somewhere else.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: Richard Larocque <rlarocque@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/time/alarmtimer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f7bdb14..cd45a07 100644
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

