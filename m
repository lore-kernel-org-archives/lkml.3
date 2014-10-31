Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbaJaLZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:25:30 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46735 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJaLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:25:28 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 07:25:27 EDT
Date: Fri, 31 Oct 2014 12:17:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20141031111751.GA28586@gmail.com>
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

   # HEAD: f3a7e1a9c464a32ee186ab91388313c82e7ce018 sched/dl: Fix preemption checks

Various scheduler fixes all over the place: three SCHED_DL fixes, 
three sched/numa fixes, two generic race fixes and a comment fix.

 Thanks,

	Ingo

------------------>
Chen Hanxiao (1):
      sched: Update comments for CLONE_NEWNS

Juri Lelli (2):
      sched/deadline: Don't replenish from a !SCHED_DEADLINE entity
      sched/deadline: Fix races between rt_mutex_setprio() and dl_task_timer()

Kirill Tkhai (4):
      sched: Fix race between task_group and sched_task_group
      sched/numa: Fix unsafe get_task_struct() in task_numa_assign()
      sched/fair: Fix division by zero sysctl_numa_balancing_scan_size
      sched/dl: Fix preemption checks

Oleg Nesterov (1):
      sched: stop the unbound recursion in preempt_schedule_context()

Yasuaki Ishimatsu (1):
      sched/fair: Care divide error in update_task_scan_period()


 arch/x86/include/asm/preempt.h |  1 +
 include/uapi/linux/sched.h     |  2 +-
 kernel/context_tracking.c      | 40 -----------------------------------
 kernel/sched/core.c            | 47 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/deadline.c        | 41 ++++++++++++++++++++++++++++--------
 kernel/sched/fair.c            | 21 ++++++++++++++-----
 kernel/sysctl.c                |  3 ++-
 7 files changed, 99 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 7024c12f7bfe..400873450e33 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -105,6 +105,7 @@ static __always_inline bool should_resched(void)
 # ifdef CONFIG_CONTEXT_TRACKING
     extern asmlinkage void ___preempt_schedule_context(void);
 #   define __preempt_schedule_context() asm ("call ___preempt_schedule_context")
+    extern asmlinkage void preempt_schedule_context(void);
 # endif
 #endif
 
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d7387d13..b932be9f5c5b 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -13,7 +13,7 @@
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
 #define CLONE_THREAD	0x00010000	/* Same thread group? */
-#define CLONE_NEWNS	0x00020000	/* New namespace group? */
+#define CLONE_NEWNS	0x00020000	/* New mount namespace group */
 #define CLONE_SYSVSEM	0x00040000	/* share system V SEM_UNDO semantics */
 #define CLONE_SETTLS	0x00080000	/* create a new TLS for the child */
 #define CLONE_PARENT_SETTID	0x00100000	/* set the TID in the parent */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 5664985c46a0..937ecdfdf258 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -107,46 +107,6 @@ void context_tracking_user_enter(void)
 }
 NOKPROBE_SYMBOL(context_tracking_user_enter);
 
-#ifdef CONFIG_PREEMPT
-/**
- * preempt_schedule_context - preempt_schedule called by tracing
- *
- * The tracing infrastructure uses preempt_enable_notrace to prevent
- * recursion and tracing preempt enabling caused by the tracing
- * infrastructure itself. But as tracing can happen in areas coming
- * from userspace or just about to enter userspace, a preempt enable
- * can occur before user_exit() is called. This will cause the scheduler
- * to be called when the system is still in usermode.
- *
- * To prevent this, the preempt_enable_notrace will use this function
- * instead of preempt_schedule() to exit user context if needed before
- * calling the scheduler.
- */
-asmlinkage __visible void __sched notrace preempt_schedule_context(void)
-{
-	enum ctx_state prev_ctx;
-
-	if (likely(!preemptible()))
-		return;
-
-	/*
-	 * Need to disable preemption in case user_exit() is traced
-	 * and the tracer calls preempt_enable_notrace() causing
-	 * an infinite recursion.
-	 */
-	preempt_disable_notrace();
-	prev_ctx = exception_enter();
-	preempt_enable_no_resched_notrace();
-
-	preempt_schedule();
-
-	preempt_disable_notrace();
-	exception_exit(prev_ctx);
-	preempt_enable_notrace();
-}
-EXPORT_SYMBOL_GPL(preempt_schedule_context);
-#endif /* CONFIG_PREEMPT */
-
 /**
  * context_tracking_user_exit - Inform the context tracking that the CPU is
  *                              exiting userspace mode and entering the kernel.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 44999505e1bf..240157c13ddc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2951,6 +2951,47 @@ asmlinkage __visible void __sched notrace preempt_schedule(void)
 }
 NOKPROBE_SYMBOL(preempt_schedule);
 EXPORT_SYMBOL(preempt_schedule);
+
+#ifdef CONFIG_CONTEXT_TRACKING
+/**
+ * preempt_schedule_context - preempt_schedule called by tracing
+ *
+ * The tracing infrastructure uses preempt_enable_notrace to prevent
+ * recursion and tracing preempt enabling caused by the tracing
+ * infrastructure itself. But as tracing can happen in areas coming
+ * from userspace or just about to enter userspace, a preempt enable
+ * can occur before user_exit() is called. This will cause the scheduler
+ * to be called when the system is still in usermode.
+ *
+ * To prevent this, the preempt_enable_notrace will use this function
+ * instead of preempt_schedule() to exit user context if needed before
+ * calling the scheduler.
+ */
+asmlinkage __visible void __sched notrace preempt_schedule_context(void)
+{
+	enum ctx_state prev_ctx;
+
+	if (likely(!preemptible()))
+		return;
+
+	do {
+		__preempt_count_add(PREEMPT_ACTIVE);
+		/*
+		 * Needs preempt disabled in case user_exit() is traced
+		 * and the tracer calls preempt_enable_notrace() causing
+		 * an infinite recursion.
+		 */
+		prev_ctx = exception_enter();
+		__schedule();
+		exception_exit(prev_ctx);
+
+		__preempt_count_sub(PREEMPT_ACTIVE);
+		barrier();
+	} while (need_resched());
+}
+EXPORT_SYMBOL_GPL(preempt_schedule_context);
+#endif /* CONFIG_CONTEXT_TRACKING */
+
 #endif /* CONFIG_PREEMPT */
 
 /*
@@ -7833,6 +7874,11 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
 	sched_offline_group(tg);
 }
 
+static void cpu_cgroup_fork(struct task_struct *task)
+{
+	sched_move_task(task);
+}
+
 static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
 				 struct cgroup_taskset *tset)
 {
@@ -8205,6 +8251,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_free	= cpu_cgroup_css_free,
 	.css_online	= cpu_cgroup_css_online,
 	.css_offline	= cpu_cgroup_css_offline,
+	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 256e577faf1b..5285332392d5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -518,12 +518,20 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	}
 
 	/*
-	 * We need to take care of a possible races here. In fact, the
-	 * task might have changed its scheduling policy to something
-	 * different from SCHED_DEADLINE or changed its reservation
-	 * parameters (through sched_setattr()).
+	 * We need to take care of several possible races here:
+	 *
+	 *   - the task might have changed its scheduling policy
+	 *     to something different than SCHED_DEADLINE
+	 *   - the task might have changed its reservation parameters
+	 *     (through sched_setattr())
+	 *   - the task might have been boosted by someone else and
+	 *     might be in the boosting/deboosting path
+	 *
+	 * In all this cases we bail out, as the task is already
+	 * in the runqueue or is going to be enqueued back anyway.
 	 */
-	if (!dl_task(p) || dl_se->dl_new)
+	if (!dl_task(p) || dl_se->dl_new ||
+	    dl_se->dl_boosted || !dl_se->dl_throttled)
 		goto unlock;
 
 	sched_clock_tick();
@@ -532,7 +540,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	dl_se->dl_yielded = 0;
 	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
-		if (task_has_dl_policy(rq->curr))
+		if (dl_task(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
 		else
 			resched_curr(rq);
@@ -847,8 +855,19 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 	 * smaller than our one... OTW we keep our runtime and
 	 * deadline.
 	 */
-	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio))
+	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio)) {
 		pi_se = &pi_task->dl;
+	} else if (!dl_prio(p->normal_prio)) {
+		/*
+		 * Special case in which we have a !SCHED_DEADLINE task
+		 * that is going to be deboosted, but exceedes its
+		 * runtime while doing so. No point in replenishing
+		 * it, as it's going to return back to its original
+		 * scheduling class after this.
+		 */
+		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
+		return;
+	}
 
 	/*
 	 * If p is throttled, we do nothing. In fact, if it exhausted
@@ -1607,8 +1626,12 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 			/* Only reschedule if pushing failed */
 			check_resched = 0;
 #endif /* CONFIG_SMP */
-		if (check_resched && task_has_dl_policy(rq->curr))
-			check_preempt_curr_dl(rq, p, 0);
+		if (check_resched) {
+			if (dl_task(rq->curr))
+				check_preempt_curr_dl(rq, p, 0);
+			else
+				resched_curr(rq);
+		}
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf3e708..34baa60f8a7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -828,11 +828,12 @@ static unsigned int task_nr_scan_windows(struct task_struct *p)
 
 static unsigned int task_scan_min(struct task_struct *p)
 {
+	unsigned int scan_size = ACCESS_ONCE(sysctl_numa_balancing_scan_size);
 	unsigned int scan, floor;
 	unsigned int windows = 1;
 
-	if (sysctl_numa_balancing_scan_size < MAX_SCAN_WINDOW)
-		windows = MAX_SCAN_WINDOW / sysctl_numa_balancing_scan_size;
+	if (scan_size < MAX_SCAN_WINDOW)
+		windows = MAX_SCAN_WINDOW / scan_size;
 	floor = 1000 / windows;
 
 	scan = sysctl_numa_balancing_scan_period_min / task_nr_scan_windows(p);
@@ -1164,9 +1165,19 @@ static void task_numa_compare(struct task_numa_env *env,
 	long moveimp = imp;
 
 	rcu_read_lock();
-	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+
+	raw_spin_lock_irq(&dst_rq->lock);
+	cur = dst_rq->curr;
+	/*
+	 * No need to move the exiting task, and this ensures that ->curr
+	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
+	 * is safe under RCU read lock.
+	 * Note that rcu_read_lock() itself can't protect from the final
+	 * put_task_struct() after the last schedule().
+	 */
+	if ((cur->flags & PF_EXITING) || is_idle_task(cur))
 		cur = NULL;
+	raw_spin_unlock_irq(&dst_rq->lock);
 
 	/*
 	 * "imp" is the fault differential for the source task between the
@@ -1520,7 +1531,7 @@ static void update_task_scan_period(struct task_struct *p,
 		 * scanning faster if shared accesses dominate as it may
 		 * simply bounce migrations uselessly
 		 */
-		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
+		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared + 1));
 		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
 	}
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4aada6d9fe74..15f2511a1b7c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -387,7 +387,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_numa_balancing_scan_size,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "numa_balancing",
