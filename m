Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaKTH5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:57:14 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34703 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaKTH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:57:12 -0500
Date: Thu, 20 Nov 2014 08:57:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20141120075706.GA4424@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 6e998916dfe327e785e7c2447959b2c1a3ea4930 sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency

Misc fixes: two NUMA fixes, two cputime fixes and an RCU/lockdep 
fix.

 Thanks,

	Ingo

------------------>
Andrey Ryabinin (1):
      sched/numa: Fix out of bounds read in sched_init_numa()

Kirill Tkhai (1):
      sched: Remove lockdep check in sched_move_task()

Peter Zijlstra (2):
      sched/numa: Avoid selecting oneself as swap target
      sched/cputime: Fix cpu_timer_sample_group() double accounting

Stanislaw Gruszka (1):
      sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency


 include/linux/kernel_stat.h    |  5 ----
 kernel/sched/core.c            | 63 ++++++++++++++----------------------------
 kernel/sched/deadline.c        |  2 ++
 kernel/sched/fair.c            | 14 ++++++++++
 kernel/sched/rt.c              |  2 ++
 kernel/sched/sched.h           |  2 ++
 kernel/time/posix-cpu-timers.c |  2 +-
 7 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8422b4ed6882..b9376cd5a187 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -77,11 +77,6 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 	return kstat_cpu(cpu).irqs_sum;
 }
 
-/*
- * Lock/unlock the current runqueue - to extract task statistics:
- */
-extern unsigned long long task_delta_exec(struct task_struct *);
-
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c13ddc..24beb9bb4c3e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2475,44 +2475,6 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
 
 /*
- * Return any ns on the sched_clock that have not yet been accounted in
- * @p in case that task is currently running.
- *
- * Called with task_rq_lock() held on @rq.
- */
-static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
-{
-	u64 ns = 0;
-
-	/*
-	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
-	 * project cycles that may never be accounted to this
-	 * thread, breaking clock_gettime().
-	 */
-	if (task_current(rq, p) && task_on_rq_queued(p)) {
-		update_rq_clock(rq);
-		ns = rq_clock_task(rq) - p->se.exec_start;
-		if ((s64)ns < 0)
-			ns = 0;
-	}
-
-	return ns;
-}
-
-unsigned long long task_delta_exec(struct task_struct *p)
-{
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns = 0;
-
-	rq = task_rq_lock(p, &flags);
-	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
  * Return accounted runtime for the task.
  * In case the task is currently running, return the runtime plus current's
  * pending runtime that have not been accounted yet.
@@ -2521,7 +2483,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-	u64 ns = 0;
+	u64 ns;
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
 	/*
@@ -2540,7 +2502,16 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 #endif
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	/*
+	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
+	 * project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && task_on_rq_queued(p)) {
+		update_rq_clock(rq);
+		p->sched_class->update_curr(rq);
+	}
+	ns = p->se.sum_exec_runtime;
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
@@ -6368,6 +6339,10 @@ static void sched_init_numa(void)
 		if (!sched_debug())
 			break;
 	}
+
+	if (!level)
+		return;
+
 	/*
 	 * 'level' contains the number of unique distances, excluding the
 	 * identity distance node_distance(i,i).
@@ -7444,8 +7419,12 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		put_prev_task(rq, tsk);
 
-	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
-				lockdep_is_held(&tsk->sighand->siglock)),
+	/*
+	 * All callers are synchronized by task_rq_lock(); we do not use RCU
+	 * which is pointless here. Thus, we pass "true" to task_css_check()
+	 * to prevent lockdep warnings.
+	 */
+	tg = container_of(task_css_check(tsk, cpu_cgrp_id, true),
 			  struct task_group, css);
 	tg = autogroup_task_group(tsk, tg);
 	tsk->sched_task_group = tg;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5285332392d5..28fa9d9e9201 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1701,4 +1701,6 @@ const struct sched_class dl_sched_class = {
 	.prio_changed           = prio_changed_dl,
 	.switched_from		= switched_from_dl,
 	.switched_to		= switched_to_dl,
+
+	.update_curr		= update_curr_dl,
 };
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34baa60f8a7b..ef2b104b254c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -726,6 +726,11 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
+static void update_curr_fair(struct rq *rq)
+{
+	update_curr(cfs_rq_of(&rq->curr->se));
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -1180,6 +1185,13 @@ static void task_numa_compare(struct task_numa_env *env,
 	raw_spin_unlock_irq(&dst_rq->lock);
 
 	/*
+	 * Because we have preemption enabled we can get migrated around and
+	 * end try selecting ourselves (current == env->p) as a swap candidate.
+	 */
+	if (cur == env->p)
+		goto unlock;
+
+	/*
 	 * "imp" is the fault differential for the source task between the
 	 * source and destination node. Calculate the total differential for
 	 * the source task and potential destination task. The more negative
@@ -7949,6 +7961,8 @@ const struct sched_class fair_sched_class = {
 
 	.get_rr_interval	= get_rr_interval_fair,
 
+	.update_curr		= update_curr_fair,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d024e6ce30ba..20bca398084a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2128,6 +2128,8 @@ const struct sched_class rt_sched_class = {
 
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
+
+	.update_curr		= update_curr_rt,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c8434d1..2df8ef067cc5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1135,6 +1135,8 @@ struct sched_class {
 	unsigned int (*get_rr_interval) (struct rq *rq,
 					 struct task_struct *task);
 
+	void (*update_curr) (struct rq *rq);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 492b986195d5..a16b67859e2a 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -553,7 +553,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
-		*sample = cputime.sum_exec_runtime + task_delta_exec(p);
+		*sample = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
