Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbbAWDt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:49:28 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:39161 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbbAWDt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:49:27 -0500
Message-ID: <1421983913.4432.22.camel@j-VirtualBox>
Subject: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Jason Low <jason.low2@hp.com>
Date: Thu, 22 Jan 2015 19:31:53 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a database workload, we found a scalability issue
with itimers.

Much of the problem was caused by the thread_group_cputimer spinlock.
Each time we account for group system/user time, we need to obtain a
thread_group_cputimer's spinlock to update the timers. On larger
systems (such as a 16 socket machine), this caused more than 30% of
total time spent trying to obtain the kernel lock to update these
group timer stats.

This patch converts the timers to 64 bit atomic variables and use
atomic add to update them without a lock. With this patch, the percent
of total time spent updating thread group cputimer timers was reduced
from 30% down to less than 1%.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/init_task.h      |    7 +++--
 include/linux/sched.h          |   12 +++------
 kernel/fork.c                  |    5 +---
 kernel/sched/stats.h           |   14 +++--------
 kernel/time/posix-cpu-timers.c |   48 ++++++++++++++++++---------------------
 5 files changed, 35 insertions(+), 51 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 3037fc0..f593b38 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -50,9 +50,10 @@ extern struct fs_struct init_fs;
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
 	.cputimer	= { 						\
-		.cputime = INIT_CPUTIME,				\
-		.running = 0,						\
-		.lock = __RAW_SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
+		.utime = ATOMIC64_INIT(0),                              \
+		.stime = ATOMIC64_INIT(0),                              \
+		.sum_exec_runtime = ATOMIC64_INIT(0),                   \
+		.running = ATOMIC_INIT(0),                              \
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db31ef..0d73fd4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -588,9 +588,10 @@ struct task_cputime {
  * used for thread group CPU timer calculations.
  */
 struct thread_group_cputimer {
-	struct task_cputime cputime;
-	int running;
-	raw_spinlock_t lock;
+	atomic64_t utime;
+	atomic64_t stime;
+	atomic64_t sum_exec_runtime;
+	atomic_t running;
 };
 
 #include <linux/rwsem.h>
@@ -2942,11 +2943,6 @@ static __always_inline bool need_resched(void)
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
-static inline void thread_group_cputime_init(struct signal_struct *sig)
-{
-	raw_spin_lock_init(&sig->cputimer.lock);
-}
-
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff --git a/kernel/fork.c b/kernel/fork.c
index 4dc2dda..d511f99 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1037,13 +1037,10 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
 	unsigned long cpu_limit;
 
-	/* Thread group counters. */
-	thread_group_cputime_init(sig);
-
 	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 	if (cpu_limit != RLIM_INFINITY) {
 		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
-		sig->cputimer.running = 1;
+		atomic_set(&sig->cputimer.running, 1);
 	}
 
 	/* The timer lists. */
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 4ab7043..caeab5f 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -174,7 +174,7 @@ static inline bool cputimer_running(struct task_struct *tsk)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!atomic_read(&cputimer->running))
 		return false;
 
 	/*
@@ -215,9 +215,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 	if (!cputimer_running(tsk))
 		return;
 
-	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.utime += cputime;
-	raw_spin_unlock(&cputimer->lock);
+	atomic64_add(cputime, &cputimer->utime);
 }
 
 /**
@@ -238,9 +236,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 	if (!cputimer_running(tsk))
 		return;
 
-	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.stime += cputime;
-	raw_spin_unlock(&cputimer->lock);
+	atomic64_add(cputime, &cputimer->stime);
 }
 
 /**
@@ -261,7 +257,5 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer_running(tsk))
 		return;
 
-	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.sum_exec_runtime += ns;
-	raw_spin_unlock(&cputimer->lock);
+	atomic64_add(ns, &cputimer->sum_exec_runtime);
 }
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index a16b678..526789f 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -196,25 +196,24 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
-static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
+static void update_gt_cputime(struct thread_group_cputimer *a, struct task_cputime *b)
 {
-	if (b->utime > a->utime)
-		a->utime = b->utime;
+	if (b->utime > atomic64_read(&a->utime))
+		atomic64_set(&a->utime, b->utime);
 
-	if (b->stime > a->stime)
-		a->stime = b->stime;
+	if (b->stime > atomic64_read(&a->stime))
+		atomic64_set(&a->stime, b->stime);
 
-	if (b->sum_exec_runtime > a->sum_exec_runtime)
-		a->sum_exec_runtime = b->sum_exec_runtime;
+	if (b->sum_exec_runtime > atomic64_read(&a->sum_exec_runtime))
+		atomic64_set(&a->sum_exec_runtime, b->sum_exec_runtime);
 }
 
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 	struct task_cputime sum;
-	unsigned long flags;
 
-	if (!cputimer->running) {
+	if (!atomic_read(&cputimer->running)) {
 		/*
 		 * The POSIX timer interface allows for absolute time expiry
 		 * values through the TIMER_ABSTIME flag, therefore we have
@@ -222,13 +221,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * it.
 		 */
 		thread_group_cputime(tsk, &sum);
-		raw_spin_lock_irqsave(&cputimer->lock, flags);
-		cputimer->running = 1;
-		update_gt_cputime(&cputimer->cputime, &sum);
-	} else
-		raw_spin_lock_irqsave(&cputimer->lock, flags);
-	*times = cputimer->cputime;
-	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
+		atomic_set(&cputimer->running, 1);
+		update_gt_cputime(cputimer, &sum);
+	}
+
+	times->utime = atomic64_read(&cputimer->utime);
+	times->stime = atomic64_read(&cputimer->stime);
+	times->sum_exec_runtime = atomic64_read(&cputimer->sum_exec_runtime);
 }
 
 /*
@@ -582,7 +581,7 @@ bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk)
 	if (!task_cputime_zero(&tsk->cputime_expires))
 		return false;
 
-	if (tsk->signal->cputimer.running)
+	if (atomic_read(&tsk->signal->cputimer.running))
 		return false;
 
 	return true;
@@ -885,11 +884,8 @@ static void check_thread_timers(struct task_struct *tsk,
 static void stop_process_timers(struct signal_struct *sig)
 {
 	struct thread_group_cputimer *cputimer = &sig->cputimer;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&cputimer->lock, flags);
-	cputimer->running = 0;
-	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
+	atomic_set(&cputimer->running, 0);
 }
 
 static u32 onecputick;
@@ -1111,12 +1107,12 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	}
 
 	sig = tsk->signal;
-	if (sig->cputimer.running) {
+	if (atomic_read(&sig->cputimer.running)) {
 		struct task_cputime group_sample;
 
-		raw_spin_lock(&sig->cputimer.lock);
-		group_sample = sig->cputimer.cputime;
-		raw_spin_unlock(&sig->cputimer.lock);
+		group_sample.utime = atomic64_read(&sig->cputimer.utime);
+		group_sample.stime = atomic64_read(&sig->cputimer.stime);
+		group_sample.sum_exec_runtime = atomic64_read(&sig->cputimer.sum_exec_runtime);
 
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
@@ -1157,7 +1153,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * If there are any active process wide timers (POSIX 1.b, itimers,
 	 * RLIMIT_CPU) cputimer must be running.
 	 */
-	if (tsk->signal->cputimer.running)
+	if (atomic_read(&tsk->signal->cputimer.running))
 		check_process_timers(tsk, &firing);
 
 	/*
-- 
1.7.1



