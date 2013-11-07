Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3KGSQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:16:52 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55394 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3KGSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:16:45 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/6] posix-timers: Fix full dynticks CPUs kick on timer rescheduling
Date: Thu,  7 Nov 2013 19:16:31 +0100
Message-Id: <1383848191-30807-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383848191-30807-1-git-send-email-fweisbec@gmail.com>
References: <1383848191-30807-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A posix CPU timer can be rearmed while it is firing or after it is
notified with a signal. This can happen for example with timers that
were set with a non zero interval in timer_settime().

This rearming can happen in two places:

1) On timer firing time, which happens on the target's tick. If the timer
can't trigger a signal because it is ignored, it reschedules itself
to honour the timer interval.

2) On signal handling from the timer's notification target. This one
can be a different task than the timer's target itself. Once the
signal is notified, the notification target rearms the timer, again
to honour the timer interval.

When a timer is rearmed, we need to notify the full dynticks CPUs
in case they are running tasks that may have a share in elapsing this
timer.

The 1st case above is currently handled but we are missing the 2nd
case.

Lets handle both cases by moving the kick to the rearming common code
in posix_cpu_timer_schedule().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/posix-cpu-timers.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 35509c5..79747b7 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1091,7 +1091,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			put_task_struct(p);
 			timer->it.cpu.task = p = NULL;
 			timer->it.cpu.expires = 0;
-			goto out_unlock;
+			read_unlock(&tasklist_lock);
+			goto out;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
 			/*
 			 * We've noticed that the thread is dead, but
@@ -1100,7 +1101,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			 */
 			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead_task(timer, now);
-			goto out_unlock;
+			read_unlock(&tasklist_lock);
+			goto out;
 		}
 		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
@@ -1114,10 +1116,11 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	BUG_ON(!irqs_disabled());
 	arm_timer(timer);
 	spin_unlock(&p->sighand->siglock);
-
-out_unlock:
 	read_unlock(&tasklist_lock);
 
+	/* Kick full dynticks CPUs in case they need to tick on the new timer */
+	posix_cpu_timer_kick_nohz();
+
 out:
 	timer->it_overrun_last = timer->it_overrun;
 	timer->it_overrun = -1;
@@ -1257,13 +1260,6 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 			cpu_timer_fire(timer);
 		spin_unlock(&timer->it_lock);
 	}
-
-	/*
-	 * In case some timers were rescheduled after the queue got emptied,
-	 * wake up full dynticks CPUs.
-	 */
-	if (tsk->signal->cputimer.running)
-		posix_cpu_timer_kick_nohz();
 }
 
 /*
-- 
1.8.3.1

