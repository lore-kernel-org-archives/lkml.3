Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaFYIoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:44:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:15876 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbaFYIk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:40:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="449717491"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RFC PATCH 5/9 v4] Workload Consolidation: Consolidating workload to a subset of CPUs if possible
Date: Wed, 25 Jun 2014 08:36:04 +0800
Message-Id: <1403656568-32445-6-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
References: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU CC is a per CPU metric. To determine whether to consolidate or not,
the formula is based on a heuristic. Suppose we have 2 CPUs, their task
concurrency over time is ('-' means no task, 'x' having tasks):

1)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---------xxxx---- (CC[1])

2)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---xxxx---------- (CC[1])

If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' = CC[0] +
CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2. For the cases in
between case 1 and 2 in terms of how xxx overlaps, the CC should be between
CC' and CC''. So, we uniformly use the following formula: (suppose we consolidate
m CPUs to n CPUs, m > n):

(CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
consolidating_coefficient

The consolidating_coefficient could be like 100 (%) or more or less.

TODO:
1) need sched statistics
2) whether or not to consolidate is decided every time we need it. Not efficient.
3) really want to be used for multi-socket machines, but the decision to consolidation
   is time-consuming if CPU number increase significantly, need to remedy this

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |  332 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 332 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c4270cf..7f80058 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6749,6 +6749,8 @@ update_next_balance(struct sched_domain *sd, int cpu_busy, unsigned long *next_b
 		*next_balance = next;
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
+
 /*
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
@@ -7805,6 +7807,12 @@ void print_cfs_stats(struct seq_file *m, int cpu)
 __init void init_sched_fair_class(void)
 {
 #ifdef CONFIG_SMP
+	unsigned int i;
+	for_each_possible_cpu(i) {
+		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
+					GFP_KERNEL, cpu_to_node(i));
+	}
+
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ_COMMON
@@ -7841,4 +7849,328 @@ static void update_cpu_concurrency(struct rq *rq)
 		sa->load_avg_contrib /= (sa->runnable_avg_period + 1);
 	}
 }
+
+static inline u32 cc_weight(unsigned int nr_running)
+{
+   return nr_running << NICE_0_SHIFT;
+}
+
+static inline unsigned long get_cpu_concurrency(int cpu)
+{
+	return cpu_rq(cpu)->avg.load_avg_contrib;
+}
+
+static inline u64 sched_group_cc(struct sched_group *sg)
+{
+	u64 sg_cc = 0;
+	int i;
+
+	for_each_cpu(i, sched_group_cpus(sg))
+		sg_cc += get_cpu_concurrency(i) * capacity_of(i);
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
+	thr <<= SCHED_CAPACITY_SHIFT;
+
+	return thr;
+}
+
+/*
+ * Can @src_cc of @src_nr CPUs be consolidated to @dst_cc of @dst_nr CPUs
+ *
+ * CC is per CPU average. The cosnolidated CC depends on the overlapped
+ * running of the CPUs before consolidation. Suppose we have 2 CPUs,
+ * their CC over time is ('-' means idle, 'x' means running):
+ *
+ * Case 1
+ * CPU0: ---xxxx---------- (CC[0])
+ * CPU1: ---------xxxx---- (CC[1])
+ *
+ * Case 2
+ * CPU0: ---xxxx---------- (CC[0])
+ * CPU1: ---xxxx---------- (CC[1])
+ *
+ * If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' =
+ * CC[0] + CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2.
+ * For the cases in between case 1 and 2 in terms of how xxx overlaps,
+ * the CC should be between CC' and CC''. So, we use this heuristic to
+ * calc consolidated CC (suppose we consolidate m CPUs to n CPUs, m > n):
+ *
+ * (CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 *
+ * n) * n * consolidating_coefficient
+ *
+ * The consolidating_coefficient could be like 100% or more or less.
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
+ * find the consolidated group according to the CC of this domain's CPUs
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
+ * For the majority of architectures, we have the following assumption:
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
+ * if we decide to move workload from CPUx to CPUy (consolidating workload
+ * to CPUy), then we call CPUx nonshielded and CPUy shielded in the following.
+ *
+ * wc_nonshielded_mask - return the nonshielded CPUs in the @mask.
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
+/*
+ * unload src_cpu to dst_cpu
+ */
+static void unload_cpu(int src_cpu, int dst_cpu)
+{
+	unsigned long flags;
+	struct rq *src_rq = cpu_rq(src_cpu);
+	int unload = 0;
+
+	raw_spin_lock_irqsave(&src_rq->lock, flags);
+
+	if (!src_rq->active_balance) {
+		src_rq->active_balance = 1;
+		src_rq->push_cpu = dst_cpu;
+		unload = 1;
+	}
+
+	raw_spin_unlock_irqrestore(&src_rq->lock, flags);
+
+	if (unload)
+		stop_one_cpu_nowait(src_cpu, active_load_balance_cpu_stop,
+			src_rq, &src_rq->active_balance_work);
+}
+
+static inline int find_lowest_cc_cpu(struct cpumask *mask)
+{
+	u64 cpu_cc, min = ULLONG_MAX;
+	int i, lowest = nr_cpu_ids;
+
+	for_each_cpu(i, mask) {
+		cpu_cc = get_cpu_concurrency(i) * capacity_of(i);
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
+
+	cpumask_andnot(shielded_cpus, sched_domain_span(sd), nonshielded);
+
+	for_each_cpu(cpu, shielded_cpus) {
+		if (cpu_rq(cpu)->nr_running <= 0)
+			continue;
+
+		cpu_cc = get_cpu_concurrency(cpu) * capacity_of(cpu);
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

