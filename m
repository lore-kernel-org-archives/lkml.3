Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3C3NQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:16:07 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47441 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab3C3NPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:15:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/3] posix_timers: Remove dead task timer expiry caching
Date: Sat, 30 Mar 2013 14:15:31 +0100
Message-Id: <1364649331-30940-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading a timer sample, posix_cpu_timer_get() and
posix_cpu_timer_schedule() both perform a caching of the timer
expiry time by converting its value from absolute to relative
if the task has exited.

The reason for this caching is not clear though, it could be:

1) For performance reasons: no need to calculate the delta after
the task has died, its cputime won't change anymore. We can
thus avoid some locking (sighand, tasklist_lock, rq->lock for
task_delta_exec(), ...), and various operations to calculate
the sample...

2) To keep the remaining delta for the timer available after the
task has died. When it gets reaped, its sighand disappears, so
accessing the process wide cputime through tsk->signal is probably
not safe.

Now, is the first reason really worth it? I have no idea if it is
a case we really want to optimize.

Considering the second reason, we return a disarmed zero'ed timer
when tsk->sighand == NULL. So if this is an assumed reason, it's
broken. And this case only concern process wide timers that
have their group leader reaped. The posix cpu timer shouldn't even
be available anymore at that time. Unless the group leader changed
since we called posix_cpu_timer_create() after an exec?

Anyway for now I'm sending this as an RFC because there may well
be subtle things I left behind.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/posix-cpu-timers.c |   67 +-------------------------------------------
 1 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 877439b..2388062 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -436,23 +436,6 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
-{
-	struct cpu_timer_list *timer = &itimer->it.cpu;
-
-	/*
-	 * That's all for this thread or process.
-	 * We leave our residual in expires to be reported.
-	 */
-	put_task_struct(timer->task);
-	timer->task = NULL;
-	if (timer->expires < now) {
-		timer->expires = 0;
-	} else {
-		timer->expires -= now;
-	}
-}
-
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 {
 	return expires == 0 || expires > new_exp;
@@ -737,7 +720,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
 	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
-	int clear_dead;
 
 	/*
 	 * Easy part: convert the reload time.
@@ -750,23 +732,11 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		return;
 	}
 
-	if (unlikely(p == NULL)) {
-		/*
-		 * This task already died and the timer will never fire.
-		 * In this case, expires is actually the dead value.
-		 */
-	dead:
-		sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
-				   &itp->it_value);
-		return;
-	}
-
 	/*
 	 * Sample the clock to take the difference with the expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
-		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
 		if (unlikely(p->sighand == NULL)) {
@@ -775,29 +745,16 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			 * We can't even collect a sample any more.
 			 * Call the timer disarmed, nothing else to do.
 			 */
-			put_task_struct(p);
-			timer->it.cpu.task = NULL;
 			timer->it.cpu.expires = 0;
+			itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
 			read_unlock(&tasklist_lock);
-			goto dead;
+			return;
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead = (unlikely(p->exit_state) &&
-				      thread_group_empty(p));
 		}
 		read_unlock(&tasklist_lock);
 	}
 
-	if (unlikely(clear_dead)) {
-		/*
-		 * We've noticed that the thread is dead, but
-		 * not yet reaped.  Take this opportunity to
-		 * drop our task ref.
-		 */
-		clear_dead_task(timer, now);
-		goto dead;
-	}
-
 	if (now < timer->it.cpu.expires) {
 		sample_to_timespec(timer->it_clock,
 				   timer->it.cpu.expires - now,
@@ -1027,22 +984,12 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long now;
 
-	if (unlikely(p == NULL))
-		/*
-		 * The task was cleaned up already, no future firings.
-		 */
-		goto out;
-
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
-		if (unlikely(p->exit_state)) {
-			clear_dead_task(timer, now);
-			goto out;
-		}
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
 		spin_lock(&p->sighand->siglock);
 	} else {
@@ -1056,15 +1003,6 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			timer->it.cpu.task = p = NULL;
 			timer->it.cpu.expires = 0;
 			goto out_unlock;
-		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
-			/*
-			 * We've noticed that the thread is dead, but
-			 * not yet reaped.  Take this opportunity to
-			 * drop our task ref.
-			 */
-			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead_task(timer, now);
-			goto out_unlock;
 		}
 		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
@@ -1082,7 +1020,6 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 out_unlock:
 	read_unlock(&tasklist_lock);
 
-out:
 	timer->it_overrun_last = timer->it_overrun;
 	timer->it_overrun = -1;
 	++timer->it_requeue_pending;
-- 
1.7.5.4

