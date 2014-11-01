Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaKAWx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sharvil Nanavati" <sharvil@google.com>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Richard Larocque" <rlarocque@google.com>,
        "John Stultz" <john.stultz@linaro.org>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.635162598@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 049/102] alarmtimer: Lock k_itimer during timer callback
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/alarmtimer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -448,8 +448,12 @@ static enum alarmtimer_type clock2alarm(
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
@@ -459,9 +463,11 @@ static enum alarmtimer_restart alarm_han
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

