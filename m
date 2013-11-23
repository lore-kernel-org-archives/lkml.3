Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3KWPhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:37:48 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61918 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3KWPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:37 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/10] posix-timers: Remove remaining uses of tasklist_lock
Date: Sat, 23 Nov 2013 16:37:19 +0100
Message-Id: <1385221040-24731-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remaining uses of tasklist_lock were mostly about synchronizing
against sighand modifications, getting coherent and safe group samples
and also thread/process wide timers list handling.

All of this is already safely synchronizable with the target's
sighand lock. Let's use it on these places instead.

Also update the comments about locking.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 74 ++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 302e80e..8c75408 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -233,7 +233,8 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 
 /*
  * Sample a process (thread group) clock for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
+ * Must be called with task sighand lock held for safe while_each_thread()
+ * traversal.
  */
 static int cpu_clock_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
@@ -455,8 +456,7 @@ static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 
 /*
  * Insert the timer on the appropriate list before any timers that
- * expire later.  This must be called with the tasklist_lock held
- * for reading, interrupts disabled and p->sighand->siglock taken.
+ * expire later.  This must be called with the sighand lock held.
  */
 static void arm_timer(struct k_itimer *timer)
 {
@@ -547,7 +547,8 @@ static void cpu_timer_fire(struct k_itimer *timer)
 
 /*
  * Sample a process (thread group) timer for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
+ * Must be called with task sighand lock held for safe while_each_thread()
+ * traversal.
  */
 static int cpu_timer_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
@@ -609,9 +610,11 @@ static inline void posix_cpu_timer_kick_nohz(void) { }
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
+static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 			       struct itimerspec *new, struct itimerspec *old)
 {
+	unsigned long flags;
+	struct sighand_struct *sighand;
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long old_expires, new_expires, old_incr, val;
 	int ret;
@@ -620,14 +623,16 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 
 	new_expires = timespec_to_sample(timer->it_clock, &new->it_value);
 
-	read_lock(&tasklist_lock);
 	/*
-	 * We need the tasklist_lock to protect against reaping that
-	 * clears p->sighand.  If p has just been reaped, we can no
+	 * Protect against sighand release/switch in exit/exec and p->cpu_timers
+	 * and p->signal->cpu_timers read/write in arm_timer()
+	 */
+	sighand = lock_task_sighand(p, &flags);
+	/*
+	 * If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
-	if (unlikely(p->sighand == NULL)) {
-		read_unlock(&tasklist_lock);
+	if (unlikely(sighand == NULL)) {
 		return -ESRCH;
 	}
 
@@ -638,7 +643,6 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 
 	ret = 0;
 	old_incr = timer->it.cpu.incr;
-	spin_lock(&p->sighand->siglock);
 	old_expires = timer->it.cpu.expires;
 	if (unlikely(timer->it.cpu.firing)) {
 		timer->it.cpu.firing = -1;
@@ -695,12 +699,11 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		 * disable this firing since we are already reporting
 		 * it as an overrun (thanks to bump_cpu_timer above).
 		 */
-		spin_unlock(&p->sighand->siglock);
-		read_unlock(&tasklist_lock);
+		unlock_task_sighand(p, &flags);
 		goto out;
 	}
 
-	if (new_expires != 0 && !(flags & TIMER_ABSTIME)) {
+	if (new_expires != 0 && !(timer_flags & TIMER_ABSTIME)) {
 		new_expires += val;
 	}
 
@@ -714,9 +717,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		arm_timer(timer);
 	}
 
-	spin_unlock(&p->sighand->siglock);
-	read_unlock(&tasklist_lock);
-
+	unlock_task_sighand(p, &flags);
 	/*
 	 * Install the new reload setting, and
 	 * set up the signal and overrun bookkeeping.
@@ -778,8 +779,16 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 	} else {
-		read_lock(&tasklist_lock);
-		if (unlikely(p->sighand == NULL)) {
+		struct sighand_struct *sighand;
+		unsigned long flags;
+
+		/*
+		 * Protect against sighand release/switch in exit/exec and
+		 * also make timer sampling safe if it ends up calling
+		 * thread_group_cputime().
+		 */
+		sighand = lock_task_sighand(p, &flags);
+		if (unlikely(sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
@@ -788,11 +797,10 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			timer->it.cpu.expires = 0;
 			sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
 					   &itp->it_value);
-			read_unlock(&tasklist_lock);
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
+			unlock_task_sighand(p, &flags);
 		}
-		read_unlock(&tasklist_lock);
 	}
 
 	if (now < timer->it.cpu.expires) {
@@ -1006,6 +1014,8 @@ static void check_process_timers(struct task_struct *tsk,
  */
 void posix_cpu_timer_schedule(struct k_itimer *timer)
 {
+	struct sighand_struct *sighand;
+	unsigned long flags;
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long now;
 
@@ -1020,26 +1030,31 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 		if (unlikely(p->exit_state))
 			goto out;
 
-		read_lock(&tasklist_lock); /* arm_timer needs it.  */
-		spin_lock(&p->sighand->siglock);
+		/* Protect timer list r/w in arm_timer() */
+		sighand = lock_task_sighand(p, &flags);
+		if (!sighand)
+			goto out;
 	} else {
-		read_lock(&tasklist_lock);
-		if (unlikely(p->sighand == NULL)) {
+		/*
+		 * Protect arm_timer() and timer sampling in case of call to
+		 * thread_group_cputime().
+		 */
+		sighand = lock_task_sighand(p, &flags);
+		if (unlikely(sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
 			 */
 			timer->it.cpu.expires = 0;
-			goto out_unlock;
+			goto out;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
 			/* Optimizations: if the process is dying, no need to rearm */
 			cpu_timer_sample_group(timer->it_clock, p, &now);
 			goto out_unlock;
 		}
-		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
-		/* Leave the tasklist_lock locked for the call below.  */
+		/* Leave the sighand locked for the call below.  */
 	}
 
 	/*
@@ -1047,10 +1062,9 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	 */
 	BUG_ON(!irqs_disabled());
 	arm_timer(timer);
-	spin_unlock(&p->sighand->siglock);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	unlock_task_sighand(p, &flags);
 
 out:
 	timer->it_overrun_last = timer->it_overrun;
-- 
1.8.3.1

