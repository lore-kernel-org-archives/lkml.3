Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3ICN5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:57:41 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55515 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915Ab3ICN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:57:39 -0400
Date: Tue, 3 Sep 2013 15:57:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.12
Message-ID: <20130903135735.GA27097@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   HEAD: 10866e62e8a6907d9072f10f9a0561db0c0cf50b sched/fair: Fix the sd_parent_degenerate() code

Various optimizations, cleanups and smaller fixes - no major changes in 
scheduler behavior.

 Thanks,

	Ingo

------------------>
Christoph Lameter (1):
      sched/cputime: Use this_cpu_add() in task_group_account_field()

Joonsoo Kim (3):
      sched: Remove one division operation in find_busiest_queue()
      sched: Factor out code to should_we_balance()
      sched: Clean-up struct sd_lb_stat

Kirill Tkhai (2):
      sched/__wake_up_sync_key(): Fix nr_exclusive tasks which lead to WF_SYNC clearing
      sched/fair: Cleanup: remove duplicate variable declaration

Peter Zijlstra (6):
      sched/fair: Shrink sg_lb_stats and play memset games
      sched/fair: Remove duplicate load_per_task computations
      sched/fair: Make group power more consistent
      sched/fair: Optimize find_busiest_queue()
      sched/fair: Rework and comment the group_imb code
      sched/fair: Fix the sd_parent_degenerate() code

Rik van Riel (1):
      sched/x86: Optimize switch_mm() for multi-threaded workloads

Tom Rini (1):
      numa: Mark __node_set() as __always_inline

Xiaotian Feng (1):
      cpumask: Fix cpumask leak in partition_sched_domains()

Xie XiuQi (1):
      generic-ipi: Kill unnecessary variable - csd_flags


 arch/x86/include/asm/mmu_context.h |  20 +-
 include/linux/nodemask.h           |  11 +-
 kernel/sched/core.c                |  17 +-
 kernel/sched/cputime.c             |   2 +-
 kernel/sched/fair.c                | 511 +++++++++++++++++++++----------------
 kernel/smp.c                       |  14 +-
 6 files changed, 326 insertions(+), 249 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index cdbf367..be12c53 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -45,22 +45,28 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
-		/* stop flush ipis for the previous mm */
+		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 
-		/*
-		 * load the LDT, if the LDT is different:
-		 */
+		/* Load the LDT, if the LDT is different: */
 		if (unlikely(prev->context.ldt != next->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
-	else {
+	  else {
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
 
-		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
-			/* We were in lazy tlb mode and leave_mm disabled
+		if (!cpumask_test_cpu(cpu, mm_cpumask(next))) {
+			/*
+			 * On established mms, the mm_cpumask is only changed
+			 * from irq context, from ptep_clear_flush() while in
+			 * lazy tlb mode, and here. Irqs are blocked during
+			 * schedule, protecting us from simultaneous changes.
+			 */
+			cpumask_set_cpu(cpu, mm_cpumask(next));
+			/*
+			 * We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
 			 */
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 4e2cbfa..58b9a02 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -98,8 +98,17 @@
 typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
+/*
+ * The inline keyword gives the compiler room to decide to inline, or
+ * not inline a function as it sees best.  However, as these functions
+ * are called in both __init and non-__init functions, if they are not
+ * inlined we will end up with a section mis-match error (of the type of
+ * freeable items not being freed).  So we must use __always_inline here
+ * to fix the problem.  If other functions in the future also end up in
+ * this situation they will also need to be annotated as __always_inline
+ */
 #define node_set(node, dst) __node_set((node), &(dst))
-static inline void __node_set(int node, volatile nodemask_t *dstp)
+static __always_inline void __node_set(int node, volatile nodemask_t *dstp)
 {
 	set_bit(node, dstp->bits);
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..4da0f4b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2660,7 +2660,7 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 	if (unlikely(!q))
 		return;
 
-	if (unlikely(!nr_exclusive))
+	if (unlikely(nr_exclusive != 1))
 		wake_flags = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
@@ -4914,7 +4914,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_FORK |
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
-				SD_SHARE_PKG_RESOURCES);
+				SD_SHARE_PKG_RESOURCES |
+				SD_PREFER_SIBLING);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -5118,6 +5119,13 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
+			/*
+			 * Transfer SD_PREFER_SIBLING down in case of a
+			 * degenerate parent; the spans match for this
+			 * so the property transfers.
+			 */
+			if (parent->flags & SD_PREFER_SIBLING)
+				tmp->flags |= SD_PREFER_SIBLING;
 			destroy_sched_domain(parent, cpu);
 		} else
 			tmp = tmp->parent;
@@ -6184,8 +6192,9 @@ match1:
 		;
 	}
 
+	n = ndoms_cur;
 	if (doms_new == NULL) {
-		ndoms_cur = 0;
+		n = 0;
 		doms_new = &fallback_doms;
 		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
@@ -6193,7 +6202,7 @@ match1:
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
-		for (j = 0; j < ndoms_cur && !new_topology; j++) {
+		for (j = 0; j < n && !new_topology; j++) {
 			if (cpumask_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a7959e0..e89ccef 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -121,7 +121,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
 	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+	__this_cpu_add(kernel_cpustat.cpustat[index], tmp);
 
 	cpuacct_account_field(p, index, tmp);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9565645..dffb270 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4232,50 +4232,56 @@ static unsigned long task_h_load(struct task_struct *p)
 
 /********** Helpers for find_busiest_group ************************/
 /*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- * 		during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
-
-	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
-	unsigned long this_nr_running;
-	unsigned long this_has_capacity;
-	unsigned int  this_idle_cpus;
-
-	/* Statistics of the busiest group */
-	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
-	unsigned long busiest_nr_running;
-	unsigned long busiest_group_capacity;
-	unsigned long busiest_has_capacity;
-	unsigned int  busiest_group_weight;
-
-	int group_imb; /* Is there imbalance in this sd */
-};
-
-/*
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
 struct sg_lb_stats {
 	unsigned long avg_load; /*Avg load across the CPUs of the group */
 	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long group_capacity;
-	unsigned long idle_cpus;
-	unsigned long group_weight;
+	unsigned long load_per_task;
+	unsigned long group_power;
+	unsigned int sum_nr_running; /* Nr tasks running in the group */
+	unsigned int group_capacity;
+	unsigned int idle_cpus;
+	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
+/*
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ *		 during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest;	/* Busiest group in this sd */
+	struct sched_group *local;	/* Local group in this sd */
+	unsigned long total_load;	/* Total load of all groups in sd */
+	unsigned long total_pwr;	/* Total power of all groups in sd */
+	unsigned long avg_load;	/* Average load across all groups in sd */
+
+	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
+	struct sg_lb_stats local_stat;	/* Statistics of the local group */
+};
+
+static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
+{
+	/*
+	 * Skimp on the clearing to avoid duplicate work. We can avoid clearing
+	 * local_stat because update_sg_lb_stats() does a full clear/assignment.
+	 * We must however clear busiest_stat::avg_load because
+	 * update_sd_pick_busiest() reads this before assignment.
+	 */
+	*sds = (struct sd_lb_stats){
+		.busiest = NULL,
+		.local = NULL,
+		.total_load = 0UL,
+		.total_pwr = 0UL,
+		.busiest_stat = {
+			.avg_load = 0UL,
+		},
+	};
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4457,33 +4463,99 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	return 0;
 }
 
+/*
+ * Group imbalance indicates (and tries to solve) the problem where balancing
+ * groups is inadequate due to tsk_cpus_allowed() constraints.
+ *
+ * Imagine a situation of two groups of 4 cpus each and 4 tasks each with a
+ * cpumask covering 1 cpu of the first group and 3 cpus of the second group.
+ * Something like:
+ *
+ * 	{ 0 1 2 3 } { 4 5 6 7 }
+ * 	        *     * * *
+ *
+ * If we were to balance group-wise we'd place two tasks in the first group and
+ * two tasks in the second group. Clearly this is undesired as it will overload
+ * cpu 3 and leave one of the cpus in the second group unused.
+ *
+ * The current solution to this issue is detecting the skew in the first group
+ * by noticing it has a cpu that is overloaded while the remaining cpus are
+ * idle -- or rather, there's a distinct imbalance in the cpus; see
+ * sg_imbalanced().
+ *
+ * When this is so detected; this group becomes a candidate for busiest; see
+ * update_sd_pick_busiest(). And calculcate_imbalance() and
+ * find_busiest_group() avoid some of the usual balance conditional to allow it
+ * to create an effective group imbalance.
+ *
+ * This is a somewhat tricky proposition since the next run might not find the
+ * group imbalance and decide the groups need to be balanced again. A most
+ * subtle and fragile situation.
+ */
+
+struct sg_imb_stats {
+	unsigned long max_nr_running, min_nr_running;
+	unsigned long max_cpu_load, min_cpu_load;
+};
+
+static inline void init_sg_imb_stats(struct sg_imb_stats *sgi)
+{
+	sgi->max_cpu_load = sgi->max_nr_running = 0UL;
+	sgi->min_cpu_load = sgi->min_nr_running = ~0UL;
+}
+
+static inline void
+update_sg_imb_stats(struct sg_imb_stats *sgi,
+		    unsigned long load, unsigned long nr_running)
+{
+	if (load > sgi->max_cpu_load)
+		sgi->max_cpu_load = load;
+	if (sgi->min_cpu_load > load)
+		sgi->min_cpu_load = load;
+
+	if (nr_running > sgi->max_nr_running)
+		sgi->max_nr_running = nr_running;
+	if (sgi->min_nr_running > nr_running)
+		sgi->min_nr_running = nr_running;
+}
+
+static inline int
+sg_imbalanced(struct sg_lb_stats *sgs, struct sg_imb_stats *sgi)
+{
+	/*
+	 * Consider the group unbalanced when the imbalance is larger
+	 * than the average weight of a task.
+	 *
+	 * APZ: with cgroup the avg task weight can vary wildly and
+	 *      might not be a suitable number - should we keep a
+	 *      normalized nr_running number somewhere that negates
+	 *      the hierarchy?
+	 */
+	if ((sgi->max_cpu_load - sgi->min_cpu_load) >= sgs->load_per_task &&
+	    (sgi->max_nr_running - sgi->min_nr_running) > 1)
+		return 1;
+
+	return 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
  * @group: sched_group whose statistics are to be updated.
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
- * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, int *balance, struct sg_lb_stats *sgs)
+			int local_group, struct sg_lb_stats *sgs)
 {
-	unsigned long nr_running, max_nr_running, min_nr_running;
-	unsigned long load, max_cpu_load, min_cpu_load;
-	unsigned int balance_cpu = -1, first_idle_cpu = 0;
-	unsigned long avg_load_per_task = 0;
+	struct sg_imb_stats sgi;
+	unsigned long nr_running;
+	unsigned long load;
 	int i;
 
-	if (local_group)
-		balance_cpu = group_balance_cpu(group);
-
-	/* Tally up the load of all CPUs in the group */
-	max_cpu_load = 0;
-	min_cpu_load = ~0UL;
-	max_nr_running = 0;
-	min_nr_running = ~0UL;
+	init_sg_imb_stats(&sgi);
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -4492,24 +4564,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu &&
-					cpumask_test_cpu(i, sched_group_mask(group))) {
-				first_idle_cpu = 1;
-				balance_cpu = i;
-			}
-
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-			if (load > max_cpu_load)
-				max_cpu_load = load;
-			if (min_cpu_load > load)
-				min_cpu_load = load;
-
-			if (nr_running > max_nr_running)
-				max_nr_running = nr_running;
-			if (min_nr_running > nr_running)
-				min_nr_running = nr_running;
+			update_sg_imb_stats(&sgi, load, nr_running);
 		}
 
 		sgs->group_load += load;
@@ -4519,46 +4577,25 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			sgs->idle_cpus++;
 	}
 
-	/*
-	 * First idle cpu or the first cpu(busiest) in this sched group
-	 * is eligible for doing load balancing at this and above
-	 * domains. In the newly idle case, we will allow all the cpu's
-	 * to do the newly idle load balance.
-	 */
-	if (local_group) {
-		if (env->idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != env->dst_cpu) {
-				*balance = 0;
-				return;
-			}
-			update_group_power(env->sd, env->dst_cpu);
-		} else if (time_after_eq(jiffies, group->sgp->next_update))
-			update_group_power(env->sd, env->dst_cpu);
-	}
+	if (local_group && (env->idle != CPU_NEWLY_IDLE ||
+			time_after_eq(jiffies, group->sgp->next_update)))
+		update_group_power(env->sd, env->dst_cpu);
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
+	sgs->group_power = group->sgp->power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
 
-	/*
-	 * Consider the group unbalanced when the imbalance is larger
-	 * than the average weight of a task.
-	 *
-	 * APZ: with cgroup the avg task weight can vary wildly and
-	 *      might not be a suitable number - should we keep a
-	 *      normalized nr_running number somewhere that negates
-	 *      the hierarchy?
-	 */
 	if (sgs->sum_nr_running)
-		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
-	    (max_nr_running - min_nr_running) > 1)
-		sgs->group_imb = 1;
+	sgs->group_imb = sg_imbalanced(sgs, &sgi);
+
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
-						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(env->sd, group);
+
 	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
@@ -4580,7 +4617,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->max_load)
+	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
 	if (sgs->sum_nr_running > sgs->group_capacity)
@@ -4613,11 +4650,11 @@ static bool update_sd_pick_busiest(struct lb_env *env,
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env,
-					int *balance, struct sd_lb_stats *sds)
+					struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
-	struct sg_lb_stats sgs;
+	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
@@ -4626,17 +4663,17 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
+		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
-		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group, balance, &sgs);
-
-		if (local_group && !(*balance))
-			return;
+		if (local_group) {
+			sds->local = sg;
+			sgs = &sds->local_stat;
+		}
 
-		sds->total_load += sgs.group_load;
-		sds->total_pwr += sg->sgp->power;
+		memset(sgs, 0, sizeof(*sgs));
+		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -4648,26 +4685,17 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
-			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		if (prefer_sibling && !local_group &&
+				sds->local && sds->local_stat.group_has_capacity)
+			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
-		if (local_group) {
-			sds->this_load = sgs.avg_load;
-			sds->this = sg;
-			sds->this_nr_running = sgs.sum_nr_running;
-			sds->this_load_per_task = sgs.sum_weighted_load;
-			sds->this_has_capacity = sgs.group_has_capacity;
-			sds->this_idle_cpus = sgs.idle_cpus;
-		} else if (update_sd_pick_busiest(env, sds, sg, &sgs)) {
-			sds->max_load = sgs.avg_load;
+		/* Now, start updating sd_lb_stats */
+		sds->total_load += sgs->group_load;
+		sds->total_pwr += sgs->group_power;
+
+		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
-			sds->busiest_nr_running = sgs.sum_nr_running;
-			sds->busiest_idle_cpus = sgs.idle_cpus;
-			sds->busiest_group_capacity = sgs.group_capacity;
-			sds->busiest_load_per_task = sgs.sum_weighted_load;
-			sds->busiest_has_capacity = sgs.group_has_capacity;
-			sds->busiest_group_weight = sgs.group_weight;
-			sds->group_imb = sgs.group_imb;
+			sds->busiest_stat = *sgs;
 		}
 
 		sg = sg->next;
@@ -4712,7 +4740,8 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 		return 0;
 
 	env->imbalance = DIV_ROUND_CLOSEST(
-		sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
+		sds->busiest_stat.avg_load * sds->busiest_stat.group_power,
+		SCHED_POWER_SCALE);
 
 	return 1;
 }
@@ -4730,24 +4759,23 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
 	unsigned long scaled_busy_load_per_task;
+	struct sg_lb_stats *local, *busiest;
 
-	if (sds->this_nr_running) {
-		sds->this_load_per_task /= sds->this_nr_running;
-		if (sds->busiest_load_per_task >
-				sds->this_load_per_task)
-			imbn = 1;
-	} else {
-		sds->this_load_per_task =
-			cpu_avg_load_per_task(env->dst_cpu);
-	}
+	local = &sds->local_stat;
+	busiest = &sds->busiest_stat;
 
-	scaled_busy_load_per_task = sds->busiest_load_per_task
-					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->sgp->power;
+	if (!local->sum_nr_running)
+		local->load_per_task = cpu_avg_load_per_task(env->dst_cpu);
+	else if (busiest->load_per_task > local->load_per_task)
+		imbn = 1;
 
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
-			(scaled_busy_load_per_task * imbn)) {
-		env->imbalance = sds->busiest_load_per_task;
+	scaled_busy_load_per_task =
+		(busiest->load_per_task * SCHED_POWER_SCALE) /
+		busiest->group_power;
+
+	if (busiest->avg_load - local->avg_load + scaled_busy_load_per_task >=
+	    (scaled_busy_load_per_task * imbn)) {
+		env->imbalance = busiest->load_per_task;
 		return;
 	}
 
@@ -4757,34 +4785,37 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	 * moving them.
 	 */
 
-	pwr_now += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load);
-	pwr_now += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load);
+	pwr_now += busiest->group_power *
+			min(busiest->load_per_task, busiest->avg_load);
+	pwr_now += local->group_power *
+			min(local->load_per_task, local->avg_load);
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->sgp->power;
-	if (sds->max_load > tmp)
-		pwr_move += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load - tmp);
+	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
+		busiest->group_power;
+	if (busiest->avg_load > tmp) {
+		pwr_move += busiest->group_power *
+			    min(busiest->load_per_task,
+				busiest->avg_load - tmp);
+	}
 
 	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->sgp->power <
-		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
-	else
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->sgp->power;
-	pwr_move += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load + tmp);
+	if (busiest->avg_load * busiest->group_power <
+	    busiest->load_per_task * SCHED_POWER_SCALE) {
+		tmp = (busiest->avg_load * busiest->group_power) /
+		      local->group_power;
+	} else {
+		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
+		      local->group_power;
+	}
+	pwr_move += local->group_power *
+		    min(local->load_per_task, local->avg_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
-		env->imbalance = sds->busiest_load_per_task;
+		env->imbalance = busiest->load_per_task;
 }
 
 /**
@@ -4796,11 +4827,18 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
+	struct sg_lb_stats *local, *busiest;
+
+	local = &sds->local_stat;
+	busiest = &sds->busiest_stat;
 
-	sds->busiest_load_per_task /= sds->busiest_nr_running;
-	if (sds->group_imb) {
-		sds->busiest_load_per_task =
-			min(sds->busiest_load_per_task, sds->avg_load);
+	if (busiest->group_imb) {
+		/*
+		 * In the group_imb case we cannot rely on group-wide averages
+		 * to ensure cpu-load equilibrium, look at wider averages. XXX
+		 */
+		busiest->load_per_task =
+			min(busiest->load_per_task, sds->avg_load);
 	}
 
 	/*
@@ -4808,21 +4846,22 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (sds->max_load < sds->avg_load) {
+	if (busiest->avg_load < sds->avg_load) {
 		env->imbalance = 0;
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (!sds->group_imb) {
+	if (!busiest->group_imb) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
+		 * Except of course for the group_imb case, since then we might
+		 * have to drop below capacity to reach cpu-load equilibrium.
 		 */
-		load_above_capacity = (sds->busiest_nr_running -
-						sds->busiest_group_capacity);
+		load_above_capacity =
+			(busiest->sum_nr_running - busiest->group_capacity);
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-
-		load_above_capacity /= sds->busiest->sgp->power;
+		load_above_capacity /= busiest->group_power;
 	}
 
 	/*
@@ -4832,15 +4871,14 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * we also don't want to reduce the group load below the group capacity
 	 * (so that we can implement power-savings policies etc). Thus we look
 	 * for the minimum possible imbalance.
-	 * Be careful of negative numbers as they'll appear as very large values
-	 * with unsigned longs.
 	 */
-	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
+	max_pull = min(busiest->avg_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	env->imbalance = min(max_pull * sds->busiest->sgp->power,
-		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
-			/ SCHED_POWER_SCALE;
+	env->imbalance = min(
+		max_pull * busiest->group_power,
+		(sds->avg_load - local->avg_load) * local->group_power
+	) / SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -4848,9 +4886,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (env->imbalance < sds->busiest_load_per_task)
+	if (env->imbalance < busiest->load_per_task)
 		return fix_small_imbalance(env, sds);
-
 }
 
 /******* find_busiest_group() helpers end here *********************/
@@ -4866,69 +4903,62 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  * to restore balance.
  *
  * @env: The load balancing environment.
- * @balance: Pointer to a variable indicating if this_cpu
- *	is the appropriate cpu to perform load balancing at this_level.
  *
  * Returns:	- the busiest group if imbalance exists.
  *		- If no imbalance and user has opted for power-savings balance,
  *		   return the least loaded group whose CPUs can be
  *		   put to idle by rebalancing its tasks onto our group.
  */
-static struct sched_group *
-find_busiest_group(struct lb_env *env, int *balance)
+static struct sched_group *find_busiest_group(struct lb_env *env)
 {
+	struct sg_lb_stats *local, *busiest;
 	struct sd_lb_stats sds;
 
-	memset(&sds, 0, sizeof(sds));
+	init_sd_lb_stats(&sds);
 
 	/*
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(env, balance, &sds);
-
-	/*
-	 * this_cpu is not the appropriate cpu to perform load balancing at
-	 * this level.
-	 */
-	if (!(*balance))
-		goto ret;
+	update_sd_lb_stats(env, &sds);
+	local = &sds.local_stat;
+	busiest = &sds.busiest_stat;
 
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
 
 	/* There is no busy sibling group to pull tasks from */
-	if (!sds.busiest || sds.busiest_nr_running == 0)
+	if (!sds.busiest || busiest->sum_nr_running == 0)
 		goto out_balanced;
 
 	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
-	 * work because they assumes all things are equal, which typically
+	 * work because they assume all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
-	if (sds.group_imb)
+	if (busiest->group_imb)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
-			!sds.busiest_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && local->group_has_capacity &&
+	    !busiest->group_has_capacity)
 		goto force_balance;
 
 	/*
 	 * If the local group is more busy than the selected busiest group
 	 * don't try and pull any tasks.
 	 */
-	if (sds.this_load >= sds.max_load)
+	if (local->avg_load >= busiest->avg_load)
 		goto out_balanced;
 
 	/*
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	if (sds.this_load >= sds.avg_load)
+	if (local->avg_load >= sds.avg_load)
 		goto out_balanced;
 
 	if (env->idle == CPU_IDLE) {
@@ -4938,15 +4968,16 @@ find_busiest_group(struct lb_env *env, int *balance)
 		 * there is no imbalance between this and busiest group
 		 * wrt to idle cpu's, it is balanced.
 		 */
-		if ((sds.this_idle_cpus <= sds.busiest_idle_cpus + 1) &&
-		    sds.busiest_nr_running <= sds.busiest_group_weight)
+		if ((local->idle_cpus < busiest->idle_cpus) &&
+		    busiest->sum_nr_running <= busiest->group_weight)
 			goto out_balanced;
 	} else {
 		/*
 		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
 		 * imbalance_pct to be conservative.
 		 */
-		if (100 * sds.max_load <= env->sd->imbalance_pct * sds.this_load)
+		if (100 * busiest->avg_load <=
+				env->sd->imbalance_pct * local->avg_load)
 			goto out_balanced;
 	}
 
@@ -4956,7 +4987,6 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
-ret:
 	env->imbalance = 0;
 	return NULL;
 }
@@ -4968,10 +4998,10 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	unsigned long busiest_load = 0, busiest_power = 1;
 	int i;
 
-	for_each_cpu(i, sched_group_cpus(group)) {
+	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		unsigned long power = power_of(i);
 		unsigned long capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
@@ -4980,9 +5010,6 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
 
-		if (!cpumask_test_cpu(i, env->cpus))
-			continue;
-
 		rq = cpu_rq(i);
 		wl = weighted_cpuload(i);
 
@@ -4998,11 +5025,15 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * the weighted_cpuload() scaled with the cpu power, so that
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
+		 *
+		 * Thus we're looking for max(wl_i / power_i), crosswise
+		 * multiplication to rid ourselves of the division works out
+		 * to: wl_i * power_j > wl_j * power_i;  where j is our
+		 * previous maximum.
 		 */
-		wl = (wl * SCHED_POWER_SCALE) / power;
-
-		if (wl > max_load) {
-			max_load = wl;
+		if (wl * busiest_power > busiest_load * power) {
+			busiest_load = wl;
+			busiest_power = power;
 			busiest = rq;
 		}
 	}
@@ -5039,13 +5070,47 @@ static int need_active_balance(struct lb_env *env)
 
 static int active_load_balance_cpu_stop(void *data);
 
+static int should_we_balance(struct lb_env *env)
+{
+	struct sched_group *sg = env->sd->groups;
+	struct cpumask *sg_cpus, *sg_mask;
+	int cpu, balance_cpu = -1;
+
+	/*
+	 * In the newly idle case, we will allow all the cpu's
+	 * to do the newly idle load balance.
+	 */
+	if (env->idle == CPU_NEWLY_IDLE)
+		return 1;
+
+	sg_cpus = sched_group_cpus(sg);
+	sg_mask = sched_group_mask(sg);
+	/* Try to find first idle cpu */
+	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
+		if (!cpumask_test_cpu(cpu, sg_mask) || !idle_cpu(cpu))
+			continue;
+
+		balance_cpu = cpu;
+		break;
+	}
+
+	if (balance_cpu == -1)
+		balance_cpu = group_balance_cpu(sg);
+
+	/*
+	 * First idle cpu or the first cpu(busiest) in this sched group
+	 * is eligible for doing load balancing at this and above domains.
+	 */
+	return balance_cpu != env->dst_cpu;
+}
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance)
+			int *continue_balancing)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
 	struct sched_group *group;
@@ -5075,11 +5140,12 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(&env, balance);
-
-	if (*balance == 0)
+	if (!should_we_balance(&env)) {
+		*continue_balancing = 0;
 		goto out_balanced;
+	}
 
+	group = find_busiest_group(&env);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[idle]);
 		goto out_balanced;
@@ -5292,7 +5358,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
-		int balance = 1;
+		int continue_balancing = 1;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -5300,7 +5366,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
-						   sd, CPU_NEWLY_IDLE, &balance);
+						   sd, CPU_NEWLY_IDLE,
+						   &continue_balancing);
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5538,7 +5605,7 @@ void update_max_interval(void)
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
-	int balance = 1;
+	int continue_balancing = 1;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
@@ -5570,7 +5637,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
+			if (load_balance(cpu, rq, sd, idle, &continue_balancing)) {
 				/*
 				 * The LBF_SOME_PINNED logic could have changed
 				 * env->dst_cpu, so we can't know our idle
@@ -5593,7 +5660,7 @@ out:
 		 * CPU in our sched group which is doing load balancing more
 		 * actively.
 		 */
-		if (!balance)
+		if (!continue_balancing)
 			break;
 	}
 	rcu_read_unlock();
@@ -5889,11 +5956,9 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	* and ensure we don't carry in an old decay_count if we
 	* switch back.
 	*/
-	if (p->se.avg.decay_count) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
-		__synchronize_entity_decay(&p->se);
-		subtract_blocked_load_contrib(cfs_rq,
-				p->se.avg.load_avg_contrib);
+	if (se->avg.decay_count) {
+		__synchronize_entity_decay(se);
+		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
 	}
 #endif
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..7332697 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -186,25 +186,13 @@ void generic_smp_call_function_single_interrupt(void)
 
 	while (!list_empty(&list)) {
 		struct call_single_data *csd;
-		unsigned int csd_flags;
 
 		csd = list_entry(list.next, struct call_single_data, list);
 		list_del(&csd->list);
 
-		/*
-		 * 'csd' can be invalid after this call if flags == 0
-		 * (when called through generic_exec_single()),
-		 * so save them away before making the call:
-		 */
-		csd_flags = csd->flags;
-
 		csd->func(csd->info);
 
-		/*
-		 * Unlocked CSDs are valid through generic_exec_single():
-		 */
-		if (csd_flags & CSD_FLAG_LOCK)
-			csd_unlock(csd);
+		csd_unlock(csd);
 	}
 }
 
