Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaEEIJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:09:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaEEII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078654"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 07/12 v1] CPU ConCurrency API for Workload Consolidation
Date: Mon,  5 May 2014 08:02:47 +0800
Message-Id: <1399248172-13871-8-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/concurrency.c |  562 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h       |   13 +
 2 files changed, 575 insertions(+)

diff --git a/kernel/sched/concurrency.c b/kernel/sched/concurrency.c
index 554c4d5..15563de 100644
--- a/kernel/sched/concurrency.c
+++ b/kernel/sched/concurrency.c
@@ -28,6 +28,25 @@ unsigned long sysctl_concurrency_decay_rate = 1UL;
  */
 static unsigned long cc_contrib_period = 10UL;
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+/*
+ * whether we use concurrency to select cpu to run
+ * the woken up task
+ */
+static unsigned long wc_wakeup = 1UL;
+
+/*
+ * concurrency lower than percentage of this number
+ * is capable of running wakee
+ */
+static unsigned long wc_wakeup_threshold = 80UL;
+
+/*
+ * aggressively push the task even it is hot
+ */
+static unsigned long wc_push_hot_task = 1UL;
+#endif
+
 /*
  * the concurrency is scaled up for decaying,
  * thus, concurrency 1 is effectively 2^cc_resolution (1024),
@@ -343,6 +362,9 @@ void init_cpu_concurrency(struct rq *rq)
 	rq->concurrency.nr_running = 0;
 	rq->concurrency.sum_timestamp = ULLONG_MAX;
 	rq->concurrency.contrib_timestamp = ULLONG_MAX;
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	rq->concurrency.unload = 0;
+#endif
 }
 
 /*
@@ -364,3 +386,543 @@ void update_cpu_concurrency(struct rq *rq)
 }
 
 #endif
+
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
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
+	threshold *= wc_wakeup_threshold;
+	threshold <<= SCHED_POWER_SHIFT;
+
+	if (sum <= threshold)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * we do not select idle, if the cc of the
+ * wakee and waker (in this order) is capable
+ * of handling the wakee task
+ */
+int workload_consolidation_wakeup(int prev, int target)
+{
+	if (!wc_wakeup) {
+		if (idle_cpu(target))
+			return target;
+
+		return nr_cpu_ids;
+	}
+
+	if (idle_cpu(prev) || cpu_cc_capable(prev))
+		return prev;
+
+	if (prev != target && (idle_cpu(target) || cpu_cc_capable(target)))
+		return target;
+
+	return nr_cpu_ids;
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
+struct sched_group *
+workload_consolidation_find_group(struct sched_domain *sd,
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
+			sd->asym_concurrency);
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
+ * workload_consolidation_cpu_shielded - return whether @cpu is shielded or not
+ *
+ * traverse downward the sched_domain tree when the sched_domain contains
+ * flag SD_ASYM_CONCURRENCY, each sd may have more than two groups, but
+ * we assume 1) every sched_group has the same weight, 2) every CPU has
+ * the same computing power
+ */
+int workload_consolidation_cpu_shielded(int cpu)
+{
+	struct sched_domain *sd;
+
+	sd = top_flag_domain(cpu, SD_ASYM_CONCURRENCY);
+
+	while (sd) {
+		int half, sg_weight, this_sg_nr;
+		u64 sd_cc;
+
+		if (!(sd->flags & SD_ASYM_CONCURRENCY)) {
+			sd = sd->child;
+			continue;
+		}
+
+		half = DIV_ROUND_CLOSEST(sd->total_groups, 2);
+		sg_weight = sd->groups->group_weight;
+		this_sg_nr = sd->group_number;
+
+		sd_cc = sched_domain_cc(sd);
+		sd_cc *= 100;
+
+		while (half) {
+			int cpus = sg_weight * half;
+			u64 threshold = __calc_cc_thr(cpus,
+				sd->asym_concurrency);
+
+			if (!__can_consolidate_cc(sd_cc, sd->span_weight,
+				threshold, cpus))
+				return 0;
+
+			if (this_sg_nr >= half)
+				return 1;
+
+			half /= 2;
+		}
+
+		sd = sd->child;
+	}
+
+	return 0;
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
+			sd->asym_concurrency);
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
+static DEFINE_PER_CPU(struct cpumask, nonshielded_cpumask);
+
+/*
+ * workload_consolidation_nonshielded_mask - return the nonshielded cpus in the @mask,
+ * which is unmasked by the shielded cpus
+ *
+ * traverse downward the sched_domain tree when the sched_domain contains
+ * flag SD_ASYM_CONCURRENCY, each sd may have more than two groups
+ */
+void workload_consolidation_nonshielded_mask(int cpu, struct cpumask *mask)
+{
+	struct sched_domain *sd;
+	struct cpumask *pcpu_mask = &per_cpu(nonshielded_cpumask, cpu);
+	int i;
+
+	sd = top_flag_domain(cpu, SD_ASYM_CONCURRENCY);
+
+	if (!sd)
+		return;
+
+	while (sd) {
+		struct sched_group *sg;
+		int this_sg_nr, ns_half;
+
+		if (!(sd->flags & SD_ASYM_CONCURRENCY)) {
+			sd = sd->child;
+			continue;
+		}
+
+		ns_half = __nonshielded_groups(sd);
+
+		if (!ns_half)
+			break;
+
+		cpumask_clear(pcpu_mask);
+		sg = sd->first_group;
+
+		for (i = 0; i < ns_half; ++i) {
+			cpumask_or(pcpu_mask, pcpu_mask,
+				sched_group_cpus(sg));
+			sg = sg->next;
+		}
+
+		cpumask_and(mask, mask, pcpu_mask);
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
+	if (sysctl_sched_migration_cost == -1)
+		return 1;
+
+	if (sysctl_sched_migration_cost == 0)
+		return 0;
+
+	if (wc_push_hot_task)
+		return 0;
+
+	/*
+	 * buddy candidates are cache hot:
+	 */
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+			(&p->se == p->se.cfs_rq->next ||
+			 &p->se == p->se.cfs_rq->last)) {
+		return 1;
+	}
+
+	delta = now - p->se.exec_start;
+
+	if (delta < (s64)sysctl_sched_migration_cost)
+		return 1;
+
+	return 0;
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
+void workload_consolidation_unload(struct cpumask *nonshielded)
+{
+	int src_cpu = nr_cpu_ids, dst_cpu, i;
+	u64 cpu_cc, min = ULLONG_MAX;
+	struct rq *rq;
+
+	for_each_cpu_not(i, nonshielded) {
+		if (i >= nr_cpu_ids)
+			break;
+
+		rq = cpu_rq(i);
+		if (rq->nr_running <= 0)
+			continue;
+
+		cpu_cc = rq->concurrency.sum_now * rq->cpu_power;
+		if (cpu_cc < min) {
+			min = cpu_cc;
+			src_cpu = i;
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
+#endif /* CONFIG_WORKLOAD_CONSOLIDATION */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 11b0c81..a9d46f0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -516,6 +516,11 @@ struct cpu_concurrency_t {
 	u64 sum_timestamp;
 	u64 contrib_timestamp;
 	unsigned long nr_running;
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	int unload;
+	int dst_cpu;
+	struct cpu_stop_work unload_work;
+#endif
 };
 #endif
 
@@ -1221,6 +1226,14 @@ extern void resched_cpu(int cpu);
 #ifdef CONFIG_CPU_CONCURRENCY
 extern void init_cpu_concurrency(struct rq *rq);
 extern void update_cpu_concurrency(struct rq *rq);
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+extern int workload_consolidation_wakeup(int prev, int target);
+extern struct sched_group *workload_consolidation_find_group(
+			struct sched_domain *sd, struct task_struct *p, int this_cpu);
+extern void workload_consolidation_unload(struct cpumask *nonshielded);
+extern int workload_consolidation_cpu_shielded(int cpu);
+extern void workload_consolidation_nonshielded_mask(int cpu, struct cpumask *mask);
+#endif
 #else
 static inline void init_cpu_concurrency(struct rq *rq) {}
 static inline void update_cpu_concurrency(struct rq *rq) {}
-- 
1.7.9.5

