Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3KWPjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:39:43 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:42481 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3KWPh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:27 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/10] posix-timers: Remove dead thread posix cpu timers caching
Date: Sat, 23 Nov 2013 16:37:11 +0100
Message-Id: <1385221040-24731-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task is exiting or has exited, its posix cpu timers
don't tick anymore and won't elapse further. It's too late
for them to expire.

So any further call to timer_gettime() on these timers will
return the same remaining expiry time.

The current code optimize this by caching the remaining delta
and storing it where we use to save the absolute expiration time.
This way, the future calls to timer_gettime() won't need to
compute the difference between the absolute expiration time and
the current time anymore.

Now this optimization doesn't seem to bring much value. Computing
the timer remaining delta is not very costly. Fetching the timer
value OTOH can be costly in two ways:

* CPUCLOCK_SCHED read requires to lock the target's rq. But some
optimizations are on the way to make task_sched_runtime() not holding
the rq lock of a non-running target.

* CPUCLOCK_VIRT/CPUCLOCK_PROF read simply consist in fetching
current->utime/current->stime except when the system uses full
dynticks cputime accounting. The latter requires a per task lock
in order to correctly compute user and system time. But once the
target is dead, this lock shouldn't be contended anyway.

All in one this caching doesn't seem to be justified.
Given that it complicates the code significantly for
few wins, let's remove it on single thread timers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c7f31aa..b803265 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -787,7 +787,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
 	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
-	int clear_dead;
 
 	/*
 	 * Easy part: convert the reload time.
@@ -801,6 +800,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	}
 
 	if (unlikely(p == NULL)) {
+		WARN_ON_ONCE(CPUCLOCK_PERTHREAD(timer->it_clock));
 		/*
 		 * This task already died and the timer will never fire.
 		 * In this case, expires is actually the dead value.
@@ -816,7 +816,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
-		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
 		if (unlikely(p->sighand == NULL)) {
@@ -832,22 +831,20 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			goto dead;
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead = (unlikely(p->exit_state) &&
-				      thread_group_empty(p));
+			if (unlikely(p->exit_state) && thread_group_empty(p)) {
+				read_unlock(&tasklist_lock);
+				/*
+				 * We've noticed that the thread is dead, but
+				 * not yet reaped.  Take this opportunity to
+				 * drop our task ref.
+				 */
+				clear_dead_task(timer, now);
+				goto dead;
+			}
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
@@ -1062,11 +1059,13 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long now;
 
-	if (unlikely(p == NULL))
+	if (unlikely(p == NULL)) {
+		WARN_ON_ONCE(CPUCLOCK_PERTHREAD(timer->it_clock));
 		/*
 		 * The task was cleaned up already, no future firings.
 		 */
 		goto out;
+	}
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
@@ -1074,10 +1073,9 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
-		if (unlikely(p->exit_state)) {
-			clear_dead_task(timer, now);
+		if (unlikely(p->exit_state))
 			goto out;
-		}
+
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
 		spin_lock(&p->sighand->siglock);
 	} else {
-- 
1.8.3.1

