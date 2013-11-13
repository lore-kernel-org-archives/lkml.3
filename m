Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3KMUPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:15:13 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35021 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3KMUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:15:03 -0500
Date: Wed, 13 Nov 2013 21:14:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20131113201457.GA32125@gmail.com>
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

   # HEAD: 85b088e934b9943322bfe37077289ae60f1b3414 sched/fair: Avoid integer overflow

Four bugfixes and one performance fix.

 Thanks,

	Ingo

------------------>
Michael wang (1):
      sched: Fix endless sync_sched/rcu() loop inside _cpu_down()

Michal Nazarewicz (1):
      sched/fair: Avoid integer overflow

Peter Zijlstra (2):
      sched/numa: Cure update_numa_stats() vs. hotplug
      sched: Optimize task_sched_runtime()

Rik van Riel (1):
      sched/numa: Fix NULL pointer dereference in task_numa_migrate()


 kernel/cpu.c        |  5 ++++-
 kernel/sched/core.c | 14 ++++++++++++++
 kernel/sched/fair.c | 31 ++++++++++++++++++++++++++++---
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 63aa50d..2227b58 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -306,7 +306,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 				__func__, cpu);
 		goto out_release;
 	}
-	smpboot_park_threads(cpu);
 
 	/*
 	 * By now we've cleared cpu_active_mask, wait for all preempt-disabled
@@ -315,12 +314,16 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	 *
 	 * For CONFIG_PREEMPT we have preemptible RCU and its sync_rcu() might
 	 * not imply sync_sched(), so explicitly call both.
+	 *
+	 * Do sync before park smpboot threads to take care the rcu boost case.
 	 */
 #ifdef CONFIG_PREEMPT
 	synchronize_sched();
 #endif
 	synchronize_rcu();
 
+	smpboot_park_threads(cpu);
+
 	/*
 	 * So now all preempt/rcu users must observe !cpu_active().
 	 */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1deccd7..c180860 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2253,6 +2253,20 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	struct rq *rq;
 	u64 ns = 0;
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
+	/*
+	 * 64-bit doesn't need locks to atomically read a 64bit value.
+	 * So we have a optimization chance when the task's delta_exec is 0.
+	 * Reading ->on_cpu is racy, but this is ok.
+	 *
+	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
+	 * If we race with it entering cpu, unaccounted time is 0. This is
+	 * indistinguishable from the read occurring a few cycles earlier.
+	 */
+	if (!p->on_cpu)
+		return p->se.sum_exec_runtime;
+#endif
+
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df77c60..e8b652e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1000,7 +1000,7 @@ struct numa_stats {
  */
 static void update_numa_stats(struct numa_stats *ns, int nid)
 {
-	int cpu;
+	int cpu, cpus = 0;
 
 	memset(ns, 0, sizeof(*ns));
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
@@ -1009,8 +1009,21 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 		ns->nr_running += rq->nr_running;
 		ns->load += weighted_cpuload(cpu);
 		ns->power += power_of(cpu);
+
+		cpus++;
 	}
 
+	/*
+	 * If we raced with hotplug and there are no CPUs left in our mask
+	 * the @ns structure is NULL'ed and task_numa_compare() will
+	 * not find this node attractive.
+	 *
+	 * We'll either bail at !has_capacity, or we'll detect a huge imbalance
+	 * and bail there.
+	 */
+	if (!cpus)
+		return;
+
 	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->power;
 	ns->capacity = DIV_ROUND_CLOSEST(ns->power, SCHED_POWER_SCALE);
 	ns->has_capacity = (ns->nr_running < ns->capacity);
@@ -1201,9 +1214,21 @@ static int task_numa_migrate(struct task_struct *p)
 	 */
 	rcu_read_lock();
 	sd = rcu_dereference(per_cpu(sd_numa, env.src_cpu));
-	env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
+	if (sd)
+		env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
 	rcu_read_unlock();
 
+	/*
+	 * Cpusets can break the scheduler domain tree into smaller
+	 * balance domains, some of which do not cross NUMA boundaries.
+	 * Tasks that are "trapped" in such domains cannot be migrated
+	 * elsewhere, so there is no point in (re)trying.
+	 */
+	if (unlikely(!sd)) {
+		p->numa_preferred_nid = cpu_to_node(task_cpu(p));
+		return -EINVAL;
+	}
+
 	taskweight = task_weight(p, env.src_nid);
 	groupweight = group_weight(p, env.src_nid);
 	update_numa_stats(&env.src_stats, env.src_nid);
@@ -2153,7 +2178,7 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 	long contrib;
 
 	/* The fraction of a cpu used by this cfs_rq */
-	contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
+	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
 			  sa->runnable_avg_period + 1);
 	contrib -= cfs_rq->tg_runnable_contrib;
 
