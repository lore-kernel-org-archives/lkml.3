Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbbA1ERG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:17:06 -0500
Received: from mail.kernel.org ([198.145.29.136]:37966 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761020AbbA1ERC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:02 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        John Stultz <john.stultz@linaro.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 39/91] alarmtimer: Lock k_itimer during timer callback
Date: Wed, 28 Jan 2015 12:07:24 +0800
Message-Id: <1422418236-12852-77-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Larocque <rlarocque@google.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/time/alarmtimer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index c870118..3ce9262 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -454,8 +454,12 @@ static enum alarmtimer_type clock2alarm(clockid_t clockid)
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
@@ -465,9 +469,11 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
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

