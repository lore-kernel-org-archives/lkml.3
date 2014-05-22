Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaEVIKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:10:52 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58415 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaEVIKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:10:24 -0400
Date: Thu, 22 May 2014 10:10:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140522081017.GA22497@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 2b4cfe64dee0d84506b951d81bf55d9891744d25 sched/numa: Initialize newidle balance stats in sd_numa_init()

The biggest commit is an irqtime accounting loop latency fix, the rest 
are misc fixes all over the place: deadline scheduling, docs, numa, 
balancer and a bad to-idle latency fix.

 Thanks,

	Ingo

------------------>
Jason Low (2):
      sched: Fix updating rq->max_idle_balance_cost and rq->next_balance in idle_balance()
      sched/numa: Initialize newidle balance stats in sd_numa_init()

Juri Lelli (1):
      sched/deadline: Fix sched_yield() behavior

Li Zefan (1):
      sched/deadline: Fix memory leak

Masanari Iida (1):
      sched/docbook: Fix 'make htmldocs' warnings caused by missing description

Peter Zijlstra (1):
      sched: Skip double execution of pick_next_task_fair()

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Thomas Gleixner (1):
      sched: Sanitize irq accounting madness


 include/linux/sched.h      |  7 +++++--
 kernel/sched/core.c        | 15 +++++++++++++--
 kernel/sched/cpudeadline.c |  4 +---
 kernel/sched/cpupri.c      |  3 +--
 kernel/sched/cputime.c     | 32 ++++++++++++++++----------------
 kernel/sched/deadline.c    |  5 +++--
 kernel/sched/fair.c        | 16 ++++++++--------
 7 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..2a4298f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1153,9 +1153,12 @@ struct sched_dl_entity {
 	 *
 	 * @dl_boosted tells if we are boosted due to DI. If so we are
 	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section).
+	 * exit the critical section);
+	 *
+	 * @dl_yielded tells if task gave up the cpu before consuming
+	 * all its available runtime during the last job.
 	 */
-	int dl_throttled, dl_new, dl_boosted;
+	int dl_throttled, dl_new, dl_boosted, dl_yielded;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..13584f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2592,8 +2592,14 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p && p != RETRY_TASK))
-			return p;
+		if (unlikely(p == RETRY_TASK))
+			goto again;
+
+		/* assumes fair_sched_class->next == idle_sched_class */
+		if (unlikely(!p))
+			p = idle_sched_class.pick_next_task(rq, prev);
+
+		return p;
 	}
 
 again:
@@ -3124,6 +3130,7 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
+	dl_se->dl_yielded = 0;
 }
 
 static void __setscheduler_params(struct task_struct *p,
@@ -3639,6 +3646,7 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
  * sys_sched_setattr - same as above, but with extended sched_attr
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
+ * @flags: for future extension.
  */
 SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 			       unsigned int, flags)
@@ -3783,6 +3791,7 @@ err_size:
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
  * @size: sizeof(attr) for fwd/bwd comp.
+ * @flags: for future extension.
  */
 SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 		unsigned int, size, unsigned int, flags)
@@ -6017,6 +6026,8 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					,
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.max_newidle_lb_cost	= 0,
+		.next_decay_max_lb_cost	= jiffies,
 	};
 	SD_INIT_NAME(sd, NUMA);
 	sd->private = &tl->data;
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b9bb42..ab001b5 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -210,7 +210,5 @@ int cpudl_init(struct cpudl *cp)
  */
 void cpudl_cleanup(struct cpudl *cp)
 {
-	/*
-	 * nothing to do for the moment
-	 */
+	free_cpumask_var(cp->free_cpus);
 }
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 8b836b3..3031bac 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -70,8 +70,7 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 	int idx = 0;
 	int task_pri = convert_prio(p->prio);
 
-	if (task_pri >= MAX_RT_PRIO)
-		return 0;
+	BUG_ON(task_pri >= CPUPRI_NR_PRIORITIES);
 
 	for (idx = 0; idx < task_pri; idx++) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a95097c..72fdf06 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -332,50 +332,50 @@ out:
  * softirq as those do not count in task exec_runtime any more.
  */
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq)
+					 struct rq *rq, int ticks)
 {
-	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	cputime_t scaled = cputime_to_scaled(cputime_one_jiffy);
+	u64 cputime = (__force u64) cputime_one_jiffy;
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
+	cputime *= ticks;
+	scaled *= ticks;
+
 	if (irqtime_account_hi_update()) {
-		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
+		cpustat[CPUTIME_IRQ] += cputime;
 	} else if (irqtime_account_si_update()) {
-		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
+		cpustat[CPUTIME_SOFTIRQ] += cputime;
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					CPUTIME_SOFTIRQ);
+		__account_system_time(p, cputime, scaled, CPUTIME_SOFTIRQ);
 	} else if (user_tick) {
-		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+		account_user_time(p, cputime, scaled);
 	} else if (p == rq->idle) {
-		account_idle_time(cputime_one_jiffy);
+		account_idle_time(cputime);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
-		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
+		account_guest_time(p, cputime, scaled);
 	} else {
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					CPUTIME_SYSTEM);
+		__account_system_time(p, cputime, scaled,	CPUTIME_SYSTEM);
 	}
 }
 
 static void irqtime_account_idle_ticks(int ticks)
 {
-	int i;
 	struct rq *rq = this_rq();
 
-	for (i = 0; i < ticks; i++)
-		irqtime_account_process_tick(current, 0, rq);
+	irqtime_account_process_tick(current, 0, rq, ticks);
 }
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
 static inline void irqtime_account_idle_ticks(int ticks) {}
 static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq) {}
+						struct rq *rq, int nr_ticks) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 /*
@@ -464,7 +464,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
 		return;
 
 	if (sched_clock_irqtime) {
-		irqtime_account_process_tick(p, user_tick, rq);
+		irqtime_account_process_tick(p, user_tick, rq, 1);
 		return;
 	}
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b080957..800e99b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -528,6 +528,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	sched_clock_tick();
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
+	dl_se->dl_yielded = 0;
 	if (p->on_rq) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (task_has_dl_policy(rq->curr))
@@ -893,10 +894,10 @@ static void yield_task_dl(struct rq *rq)
 	 * We make the task go to sleep until its current deadline by
 	 * forcing its runtime to zero. This way, update_curr_dl() stops
 	 * it and the bandwidth timer will wake it up and will give it
-	 * new scheduling parameters (thanks to dl_new=1).
+	 * new scheduling parameters (thanks to dl_yielded=1).
 	 */
 	if (p->dl.runtime > 0) {
-		rq->curr->dl.dl_new = 1;
+		rq->curr->dl.dl_yielded = 1;
 		p->dl.runtime = 0;
 	}
 	update_curr_dl(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..0fdb96d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6653,6 +6653,7 @@ static int idle_balance(struct rq *this_rq)
 	int this_cpu = this_rq->cpu;
 
 	idle_enter_fair(this_rq);
+
 	/*
 	 * We must set idle_stamp _before_ calling idle_balance(), such that we
 	 * measure the duration of idle_balance() as idle time.
@@ -6705,14 +6706,16 @@ static int idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
+
 	/*
-	 * While browsing the domains, we released the rq lock.
-	 * A task could have be enqueued in the meantime
+	 * While browsing the domains, we released the rq lock, a task could
+	 * have been enqueued in the meantime. Since we're not going idle,
+	 * pretend we pulled a task.
 	 */
-	if (this_rq->cfs.h_nr_running && !pulled_task) {
+	if (this_rq->cfs.h_nr_running && !pulled_task)
 		pulled_task = 1;
-		goto out;
-	}
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6722,9 +6725,6 @@ static int idle_balance(struct rq *this_rq)
 		this_rq->next_balance = next_balance;
 	}
 
-	if (curr_cost > this_rq->max_idle_balance_cost)
-		this_rq->max_idle_balance_cost = curr_cost;
-
 out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
