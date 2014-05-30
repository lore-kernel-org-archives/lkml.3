Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbaE3Olk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:41:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:29743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbaE3Olf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548947099"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 10/16 v3] Workload Consolidation APIs
Date: Fri, 30 May 2014 14:36:06 +0800
Message-Id: <1401431772-14320-11-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, CPU CC is per CPU. To consolidate, the formula is based on a heuristic.
Suppose we have 2 CPUs, their task concurrency over time is ('-' means no
task, 'x' having tasks):

1)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---------xxxx---- (CC[1])

2)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---xxxx---------- (CC[1])

If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' = CC[0] +
CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2. For the cases in
between case 1 and 2 in terms of how xxx overlaps, the CC should be between
CC' and CC''. So, we uniformly use this condition for consolidation (suppose
we consolidate m CPUs to n CPUs, m > n):

(CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
consolidating_coefficient

The consolidating_coefficient could be like 100% or more or less.

TODO:
1) need sched statistics
2) whether or not to consolidate is decided every time we need it. Not efficient.
3) really want to be used for multi-socket machines, but the decision to consolidation
   is time-consuming if CPU number increase significantly, need to remedy this
4) make use of existing load balancing util functions, like move_one_task

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |  468 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 468 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5755746..0c188df 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2550,6 +2550,13 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 }
 
 static inline void update_cpu_concurrency(struct rq *rq);
+static struct sched_group *wc_find_group(struct sched_domain *sd,
+	struct task_struct *p, int this_cpu);
+static void wc_unload(struct cpumask *nonshielded, struct sched_domain *sd);
+static void wc_nonshielded_mask(int cpu, struct sched_domain *sd,
+	struct cpumask *mask);
+static int cpu_cc_capable(int cpu);
+static inline struct sched_domain *top_flag_domain(int cpu, int flag);
 
 /*
  * Update the rq's load with the elapsed running time before entering
@@ -7726,6 +7733,12 @@ __init void init_sched_fair_class(void)
 unsigned int sysctl_sched_cc_sum_period = 26UL;
 
 /*
+ * concurrency lower than this threshold percentage of cc 1
+ * is capable of running wakee task, otherwise make it 0
+ */
+unsigned int sysctl_sched_cc_wakeup_threshold = 80UL;
+
+/*
  * the number of sum periods, after which the original
  * will be reduced/decayed to half. we now make it
  * unchangeable.
@@ -7740,6 +7753,11 @@ static const unsigned int cc_decay_rate = 1UL;
 static unsigned int cc_contrib_period = 10UL;
 
 /*
+ * aggressively push the task even it is hot
+ */
+static unsigned int wc_push_hot_task = 1UL;
+
+/*
  * the concurrency is scaled up for decaying,
  * thus, concurrency 1 is effectively 2^cc_resolution (1024),
  * which can be halved by 10 half-life periods
@@ -7982,4 +8000,454 @@ static void update_cpu_concurrency(struct rq *rq)
 	__update_concurrency(rq, now, cc);
 }
 
+/*
+ * whether cpu is capable of having more concurrency
+ */
+static int cpu_cc_capable(int cpu)
+{
+	u64 sum = cpu_rq(cpu)->concurrency.sum_now;
+	u64 threshold = cc_weight(1);
+
+	sum *= 100;
+	sum *= cpu_rq(cpu)->cpu_power;
+
+	threshold *= sysctl_sched_cc_wakeup_threshold;
+	threshold <<= SCHED_POWER_SHIFT;
+
+	if (sum <= threshold)
+		return 1;
+
+	return 0;
+}
+
+static inline u64 sched_group_cc(struct sched_group *sg)
+{
+	u64 sg_cc = 0;
+	int i;
+
+	for_each_cpu(i, sched_group_cpus(sg))
+		sg_cc += cpu_rq(i)->concurrency.sum_now *
+			cpu_rq(i)->cpu_power;
+
+	return sg_cc;
+}
+
+static inline u64 sched_domain_cc(struct sched_domain *sd)
+{
+	struct sched_group *sg = sd->groups;
+	u64 sd_cc = 0;
+
+	do {
+		sd_cc += sched_group_cc(sg);
+		sg = sg->next;
+	} while (sg != sd->groups);
+
+	return sd_cc;
+}
+
+static inline struct sched_group *
+find_lowest_cc_group(struct sched_group *sg, int span)
+{
+	u64 grp_cc, min = ULLONG_MAX;
+	struct sched_group *lowest = NULL;
+	int i;
+
+	for (i = 0; i < span; ++i) {
+		grp_cc = sched_group_cc(sg);
+
+		if (grp_cc < min) {
+			min = grp_cc;
+			lowest = sg;
+		}
+
+		sg = sg->next;
+	}
+
+	return lowest;
+}
+
+static inline u64 __calc_cc_thr(int cpus, unsigned int asym_cc)
+{
+	u64 thr = cpus;
+
+	thr *= cc_weight(1);
+	thr *= asym_cc;
+	thr <<= SCHED_POWER_SHIFT;
+
+	return thr;
+}
+
+/*
+ * can @src_cc of @src_nr cpus be consolidated
+ * to @dst_cc of @dst_nr cpus
+ */
+static inline int
+__can_consolidate_cc(u64 src_cc, int src_nr, u64 dst_cc, int dst_nr)
+{
+	dst_cc *= dst_nr;
+	src_nr -= dst_nr;
+
+	if (unlikely(src_nr <= 0))
+		return 0;
+
+	src_nr = ilog2(src_nr);
+	src_nr += dst_nr;
+	src_cc *= src_nr;
+
+	if (src_cc > dst_cc)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * find the group for asymmetric concurrency
+ * problem to address: traverse sd from top to down
+ */
+static struct sched_group * wc_find_group(struct sched_domain *sd,
+	struct task_struct *p, int this_cpu)
+{
+	int half, sg_weight, ns_half = 0;
+	struct sched_group *sg;
+	u64 sd_cc;
+
+	half = DIV_ROUND_CLOSEST(sd->total_groups, 2);
+	sg_weight = sd->groups->group_weight;
+
+	sd_cc = sched_domain_cc(sd);
+	sd_cc *= 100;
+
+	while (half) {
+		int allowed = 0, i;
+		int cpus = sg_weight * half;
+		u64 threshold = __calc_cc_thr(cpus,
+			sd->consolidating_coeff);
+
+		/*
+		 * we did not consider the added cc by this
+		 * wakeup (mostly from fork/exec)
+		 */
+		if (!__can_consolidate_cc(sd_cc, sd->span_weight,
+			threshold, cpus))
+			break;
+
+		sg = sd->first_group;
+		for (i = 0; i < half; ++i) {
+			/* if it has no cpus allowed */
+			if (!cpumask_intersects(sched_group_cpus(sg),
+					tsk_cpus_allowed(p)))
+				continue;
+
+			allowed = 1;
+			sg = sg->next;
+		}
+
+		if (!allowed)
+			break;
+
+		ns_half = half;
+		half /= 2;
+	}
+
+	if (!ns_half)
+		return NULL;
+
+	if (ns_half == 1)
+		return sd->first_group;
+
+	return find_lowest_cc_group(sd->first_group, ns_half);
+}
+
+/*
+ * top_flag_domain - return top sched_domain containing flag.
+ * @cpu:	the cpu whose highest level of sched domain is to
+ *		be returned.
+ * @flag:	the flag to check for the highest sched_domain
+ *		for the given cpu.
+ *
+ * returns the highest sched_domain of a cpu which contains the given flag.
+ * different from highest_flag_domain in that along the domain upward chain
+ * domain may or may not contain the flag.
+ */
+static inline struct sched_domain *top_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd, *hsd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & flag))
+			continue;
+		hsd = sd;
+	}
+
+	return hsd;
+}
+
+/*
+ * as of now, we have the following assumption
+ * 1) every sched_group has the same weight
+ * 2) every CPU has the same computing power
+ */
+static inline int __nonshielded_groups(struct sched_domain *sd)
+{
+	int half, sg_weight, ret = 0;
+	u64 sd_cc;
+
+	half = DIV_ROUND_CLOSEST(sd->total_groups, 2);
+	sg_weight = sd->groups->group_weight;
+
+	sd_cc = sched_domain_cc(sd);
+	sd_cc *= 100;
+
+	while (half) {
+		int cpus = sg_weight * half;
+		u64 threshold = __calc_cc_thr(cpus,
+			sd->consolidating_coeff);
+
+		if (!__can_consolidate_cc(sd_cc, sd->span_weight,
+			threshold, cpus))
+			return ret;
+
+		ret = half;
+		half /= 2;
+	}
+
+	return ret;
+}
+
+/*
+ * wc_nonshielded_mask - return the nonshielded cpus in the @mask,
+ * which is unmasked by the shielded cpus
+ *
+ * traverse downward the sched_domain tree when the sched_domain contains
+ * flag SD_WORKLOAD_CONSOLIDATION, each sd may have more than two groups
+ */
+static void
+wc_nonshielded_mask(int cpu, struct sched_domain *sd, struct cpumask *mask)
+{
+	struct cpumask *nonshielded_cpus = __get_cpu_var(local_cpu_mask);
+	int i;
+
+	while (sd) {
+		struct sched_group *sg;
+		int this_sg_nr, ns_half;
+
+		if (!(sd->flags & SD_WORKLOAD_CONSOLIDATION)) {
+			sd = sd->child;
+			continue;
+		}
+
+		ns_half = __nonshielded_groups(sd);
+
+		if (!ns_half)
+			break;
+
+		cpumask_clear(nonshielded_cpus);
+		sg = sd->first_group;
+
+		for (i = 0; i < ns_half; ++i) {
+			cpumask_or(nonshielded_cpus, nonshielded_cpus,
+				sched_group_cpus(sg));
+			sg = sg->next;
+		}
+
+		cpumask_and(mask, mask, nonshielded_cpus);
+
+		this_sg_nr = sd->group_number;
+		if (this_sg_nr)
+			break;
+
+		sd = sd->child;
+	}
+}
+
+static int cpu_task_hot(struct task_struct *p, u64 now)
+{
+	s64 delta;
+
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
+	if (wc_push_hot_task)
+		return 0;
+
+	/*
+	 * Buddy candidates are cache hot:
+	 */
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+			(&p->se == cfs_rq_of(&p->se)->next ||
+			 &p->se == cfs_rq_of(&p->se)->last))
+		return 1;
+
+	if (sysctl_sched_migration_cost == -1)
+		return 1;
+	if (sysctl_sched_migration_cost == 0)
+		return 0;
+
+	delta = now - p->se.exec_start;
+
+	return delta < (s64)sysctl_sched_migration_cost;
+}
+
+static int
+cpu_move_task(struct task_struct *p, struct rq *src_rq, struct rq *dst_rq)
+{
+	/*
+	 * we do not migrate tasks that are:
+	 * 1) running (obviously), or
+	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
+	 * 3) are cache-hot on their current CPU.
+	 */
+	if (!cpumask_test_cpu(dst_rq->cpu, tsk_cpus_allowed(p)))
+		return 0;
+
+	if (task_running(src_rq, p))
+		return 0;
+
+	/*
+	 * aggressive migration if task is cache cold
+	 */
+	if (!cpu_task_hot(p, src_rq->clock_task)) {
+		/*
+		 * move a task
+		 */
+		deactivate_task(src_rq, p, 0);
+		set_task_cpu(p, dst_rq->cpu);
+		activate_task(dst_rq, p, 0);
+		check_preempt_curr(dst_rq, p, 0);
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * __unload_cpu_work is run by src cpu stopper, which pushes running
+ * tasks off src cpu onto dst cpu
+ */
+static int __unload_cpu_work(void *data)
+{
+	struct rq *src_rq = data;
+	int src_cpu = cpu_of(src_rq);
+	struct cpu_concurrency_t *cc = &src_rq->concurrency;
+	struct rq *dst_rq = cpu_rq(cc->dst_cpu);
+
+	struct list_head *tasks = &src_rq->cfs_tasks;
+	struct task_struct *p, *n;
+	int pushed = 0;
+	int nr_migrate_break = 1;
+
+	raw_spin_lock_irq(&src_rq->lock);
+
+	/* make sure the requested cpu hasn't gone down in the meantime */
+	if (unlikely(src_cpu != smp_processor_id() || !cc->unload))
+		goto out_unlock;
+
+	/* Is there any task to move? */
+	if (src_rq->nr_running <= 1)
+		goto out_unlock;
+
+	double_lock_balance(src_rq, dst_rq);
+
+	list_for_each_entry_safe(p, n, tasks, se.group_node) {
+
+		if (!cpu_move_task(p, src_rq, dst_rq))
+			continue;
+
+		pushed++;
+
+		if (pushed >= nr_migrate_break)
+			break;
+	}
+
+	double_unlock_balance(src_rq, dst_rq);
+out_unlock:
+	cc->unload = 0;
+	raw_spin_unlock_irq(&src_rq->lock);
+
+	return 0;
+}
+
+/*
+ * unload src_cpu to dst_cpu
+ */
+static void unload_cpu(int src_cpu, int dst_cpu)
+{
+	unsigned long flags;
+	struct rq *src_rq = cpu_rq(src_cpu);
+	struct cpu_concurrency_t *cc = &src_rq->concurrency;
+	int unload = 0;
+
+	raw_spin_lock_irqsave(&src_rq->lock, flags);
+
+	if (!cc->unload) {
+		cc->unload = 1;
+		cc->dst_cpu = dst_cpu;
+		unload = 1;
+	}
+
+	raw_spin_unlock_irqrestore(&src_rq->lock, flags);
+
+	if (unload)
+		stop_one_cpu_nowait(src_cpu, __unload_cpu_work, src_rq,
+			&cc->unload_work);
+}
+
+static inline int find_lowest_cc_cpu(struct cpumask *mask)
+{
+	u64 cpu_cc, min = ULLONG_MAX;
+	int i, lowest = nr_cpu_ids;
+	struct rq *rq;
+
+	for_each_cpu(i, mask) {
+		rq = cpu_rq(i);
+		cpu_cc = rq->concurrency.sum_now * rq->cpu_power;
+
+		if (cpu_cc < min) {
+			min = cpu_cc;
+			lowest = i;
+		}
+	}
+
+	return lowest;
+}
+
+/*
+ * find the lowest cc cpu in shielded and nonshielded cpus,
+ * aggressively unload the shielded to the nonshielded
+ */
+static void wc_unload(struct cpumask *nonshielded, struct sched_domain *sd)
+{
+	int src_cpu = nr_cpu_ids, dst_cpu, cpu = smp_processor_id();
+	struct cpumask *shielded_cpus = __get_cpu_var(local_cpu_mask);
+	u64 cpu_cc, min = ULLONG_MAX;
+	struct rq *rq;
+
+	cpumask_andnot(shielded_cpus, sched_domain_span(sd), nonshielded);
+
+	for_each_cpu(cpu, shielded_cpus) {
+		rq = cpu_rq(cpu);
+		if (rq->nr_running <= 0)
+			continue;
+
+		cpu_cc = rq->concurrency.sum_now * rq->cpu_power;
+		if (cpu_cc < min) {
+			min = cpu_cc;
+			src_cpu = cpu;
+		}
+	}
+
+	if (src_cpu >= nr_cpu_ids)
+		return;
+
+	dst_cpu = find_lowest_cc_cpu(nonshielded);
+	if (dst_cpu >= nr_cpu_ids)
+		return;
+
+	if (src_cpu != dst_cpu)
+		unload_cpu(src_cpu, dst_cpu);
+}
+
 #endif /* CONFIG_SMP */
-- 
1.7.9.5

