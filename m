Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaEZWT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:19:56 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61825 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaEZWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:19:52 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 6/6] sched: final power vs capacity cleanup
Date: Mon, 26 May 2014 18:19:39 -0400
Message-id: <1401142779-6633-7-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better not to think about compute capacity as being equivalent
to "CPU power".  The upcoming "power aware" scheduler work may create
confusion with the notion of energy consumption if "power" is used too
liberally.

This contains the architecture visible changes.  Incidentally, only ARM
takes advantage of the available pow^H^H^Hcapacity scaling hooks and
therefore those changes outside kernel/sched/ are confined to one ARM
specific file.  The default arch_scale_smt_power() hook is not overridden
by anyone.

Replacements are as follows:

	arch_scale_freq_power  --> arch_scale_freq_capacity
	arch_scale_smt_power   --> arch_scale_smt_capacity
	SCHED_POWER_SCALE      --> SCHED_CAPACITY_SCALE
	SCHED_POWER_SHIFT      --> SCHED_CAPACITY_SHIFT

The local usage of "power" in arch/arm/kernel/topology.c is also changed
to "capacity" as appropriate.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/kernel/topology.c | 54 +++++++++++++++++++++---------------------
 include/linux/sched.h      |  6 ++---
 kernel/sched/core.c        |  6 ++---
 kernel/sched/fair.c        | 59 +++++++++++++++++++++++-----------------------
 4 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 71e1fec6d3..d42a7db222 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -26,30 +26,30 @@
 #include <asm/topology.h>
 
 /*
- * cpu power scale management
+ * cpu capacity scale management
  */
 
 /*
- * cpu power table
+ * cpu capacity table
  * This per cpu data structure describes the relative capacity of each core.
  * On a heteregenous system, cores don't have the same computation capacity
- * and we reflect that difference in the cpu_power field so the scheduler can
- * take this difference into account during load balance. A per cpu structure
- * is preferred because each CPU updates its own cpu_power field during the
- * load balance except for idle cores. One idle core is selected to run the
- * rebalance_domains for all idle cores and the cpu_power can be updated
- * during this sequence.
+ * and we reflect that difference in the cpu_capacity field so the scheduler
+ * can take this difference into account during load balance. A per cpu
+ * structure is preferred because each CPU updates its own cpu_capacity field
+ * during the load balance except for idle cores. One idle core is selected
+ * to run the rebalance_domains for all idle cores and the cpu_capacity can be
+ * updated during this sequence.
  */
 static DEFINE_PER_CPU(unsigned long, cpu_scale);
 
-unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
 {
 	return per_cpu(cpu_scale, cpu);
 }
 
-static void set_power_scale(unsigned int cpu, unsigned long power)
+static void set_capacity_scale(unsigned int cpu, unsigned long capacity)
 {
-	per_cpu(cpu_scale, cpu) = power;
+	per_cpu(cpu_scale, cpu) = capacity;
 }
 
 #ifdef CONFIG_OF
@@ -62,11 +62,11 @@ struct cpu_efficiency {
  * Table of relative efficiency of each processors
  * The efficiency value must fit in 20bit and the final
  * cpu_scale value must be in the range
- *   0 < cpu_scale < 3*SCHED_POWER_SCALE/2
+ *   0 < cpu_scale < 3*SCHED_CAPACITY_SCALE/2
  * in order to return at most 1 when DIV_ROUND_CLOSEST
  * is used to compute the capacity of a CPU.
  * Processors that are not defined in the table,
- * use the default SCHED_POWER_SCALE value for cpu_scale.
+ * use the default SCHED_CAPACITY_SCALE value for cpu_scale.
  */
 static const struct cpu_efficiency table_efficiency[] = {
 	{"arm,cortex-a15", 3891},
@@ -83,9 +83,9 @@ static unsigned long middle_capacity = 1;
  * Iterate all CPUs' descriptor in DT and compute the efficiency
  * (as per table_efficiency). Also calculate a middle efficiency
  * as close as possible to  (max{eff_i} - min{eff_i}) / 2
- * This is later used to scale the cpu_power field such that an
- * 'average' CPU is of middle power. Also see the comments near
- * table_efficiency[] and update_cpu_power().
+ * This is later used to scale the cpu_capacity field such that an
+ * 'average' CPU is of middle capacity. Also see the comments near
+ * table_efficiency[] and update_cpu_capacity().
  */
 static void __init parse_dt_topology(void)
 {
@@ -141,15 +141,15 @@ static void __init parse_dt_topology(void)
 	 * cpu_scale because all CPUs have the same capacity. Otherwise, we
 	 * compute a middle_capacity factor that will ensure that the capacity
 	 * of an 'average' CPU of the system will be as close as possible to
-	 * SCHED_POWER_SCALE, which is the default value, but with the
+	 * SCHED_CAPACITY_SCALE, which is the default value, but with the
 	 * constraint explained near table_efficiency[].
 	 */
 	if (4*max_capacity < (3*(max_capacity + min_capacity)))
 		middle_capacity = (min_capacity + max_capacity)
-				>> (SCHED_POWER_SHIFT+1);
+				>> (SCHED_CAPACITY_SHIFT+1);
 	else
 		middle_capacity = ((max_capacity / 3)
-				>> (SCHED_POWER_SHIFT-1)) + 1;
+				>> (SCHED_CAPACITY_SHIFT-1)) + 1;
 
 }
 
@@ -158,20 +158,20 @@ static void __init parse_dt_topology(void)
  * boot. The update of all CPUs is in O(n^2) for heteregeneous system but the
  * function returns directly for SMP system.
  */
-static void update_cpu_power(unsigned int cpu)
+static void update_cpu_capacity(unsigned int cpu)
 {
 	if (!cpu_capacity(cpu))
 		return;
 
-	set_power_scale(cpu, cpu_capacity(cpu) / middle_capacity);
+	set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
 
-	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
-		cpu, arch_scale_freq_power(NULL, cpu));
+	printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
+		cpu, arch_scale_freq_capacity(NULL, cpu));
 }
 
 #else
 static inline void parse_dt_topology(void) {}
-static inline void update_cpu_power(unsigned int cpuid) {}
+static inline void update_cpu_capacity(unsigned int cpuid) {}
 #endif
 
  /*
@@ -267,7 +267,7 @@ void store_cpu_topology(unsigned int cpuid)
 
 	update_siblings_masks(cpuid);
 
-	update_cpu_power(cpuid);
+	update_cpu_capacity(cpuid);
 
 	printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
 		cpuid, cpu_topology[cpuid].thread_id,
@@ -297,7 +297,7 @@ void __init init_cpu_topology(void)
 {
 	unsigned int cpu;
 
-	/* init core mask and power*/
+	/* init core mask and capacity */
 	for_each_possible_cpu(cpu) {
 		struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
 
@@ -307,7 +307,7 @@ void __init init_cpu_topology(void)
 		cpumask_clear(&cpu_topo->core_sibling);
 		cpumask_clear(&cpu_topo->thread_sibling);
 
-		set_power_scale(cpu, SCHED_POWER_SCALE);
+		set_capacity_scale(cpu, SCHED_CAPACITY_SCALE);
 	}
 	smp_wmb();
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 561f6f7369..c7f473a54d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -854,10 +854,10 @@ enum cpu_idle_type {
 };
 
 /*
- * Increase resolution of cpu_power calculations
+ * Increase resolution of cpu_capacity calculations
  */
-#define SCHED_POWER_SHIFT	10
-#define SCHED_POWER_SCALE	(1L << SCHED_POWER_SHIFT)
+#define SCHED_CAPACITY_SHIFT	10
+#define SCHED_CAPACITY_SCALE	(1L << SCHED_CAPACITY_SHIFT)
 
 /*
  * sched-domains (multiprocessor balancing) declarations:
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1191b3937e..6d376d6560 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5273,7 +5273,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->sgc->capacity != SCHED_POWER_SCALE) {
+		if (group->sgc->capacity != SCHED_CAPACITY_SCALE) {
 			printk(KERN_CONT " (cpu_capacity = %d)",
 				group->sgc->capacity);
 		}
@@ -5739,7 +5739,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * domains and no possible iteration will get us here, we won't
 		 * die on a /0 trap.
 		 */
-		sg->sgc->capacity = SCHED_POWER_SCALE * cpumask_weight(sg_span);
+		sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
 		sg->sgc->capacity_orig = sg->sgc->capacity;
 
 		/*
@@ -6945,7 +6945,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_capacity = SCHED_POWER_SCALE;
+		rq->cpu_capacity = SCHED_CAPACITY_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da35147ac6..5b7e3465cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1062,9 +1062,9 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->compute_capacity;
+	ns->load = (ns->load * SCHED_CAPACITY_SCALE) / ns->compute_capacity;
 	ns->task_capacity =
-		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_POWER_SCALE);
+		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE);
 	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
 }
 
@@ -4368,7 +4368,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU capacity of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgc->capacity;
+		avg_load = (avg_load * SCHED_CAPACITY_SCALE) / group->sgc->capacity;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -5607,10 +5607,10 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 
 static unsigned long default_scale_capacity(struct sched_domain *sd, int cpu)
 {
-	return SCHED_POWER_SCALE;
+	return SCHED_CAPACITY_SCALE;
 }
 
-unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
 {
 	return default_scale_capacity(sd, cpu);
 }
@@ -5625,7 +5625,7 @@ static unsigned long default_scale_smt_capacity(struct sched_domain *sd, int cpu
 	return smt_gain;
 }
 
-unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
 {
 	return default_scale_smt_capacity(sd, cpu);
 }
@@ -5656,10 +5656,10 @@ static unsigned long scale_rt_capacity(int cpu)
 		available = total - avg;
 	}
 
-	if (unlikely((s64)total < SCHED_POWER_SCALE))
-		total = SCHED_POWER_SCALE;
+	if (unlikely((s64)total < SCHED_CAPACITY_SCALE))
+		total = SCHED_CAPACITY_SCALE;
 
-	total >>= SCHED_POWER_SHIFT;
+	total >>= SCHED_CAPACITY_SHIFT;
 
 	return div_u64(available, total);
 }
@@ -5667,29 +5667,29 @@ static unsigned long scale_rt_capacity(int cpu)
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
-	unsigned long capacity = SCHED_POWER_SCALE;
+	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
 		if (sched_feat(ARCH_POWER))
-			capacity *= arch_scale_smt_power(sd, cpu);
+			capacity *= arch_scale_smt_capacity(sd, cpu);
 		else
 			capacity *= default_scale_smt_capacity(sd, cpu);
 
-		capacity >>= SCHED_POWER_SHIFT;
+		capacity >>= SCHED_CAPACITY_SHIFT;
 	}
 
 	sdg->sgc->capacity_orig = capacity;
 
 	if (sched_feat(ARCH_POWER))
-		capacity *= arch_scale_freq_power(sd, cpu);
+		capacity *= arch_scale_freq_capacity(sd, cpu);
 	else
 		capacity *= default_scale_capacity(sd, cpu);
 
-	capacity >>= SCHED_POWER_SHIFT;
+	capacity >>= SCHED_CAPACITY_SHIFT;
 
 	capacity *= scale_rt_capacity(cpu);
-	capacity >>= SCHED_POWER_SHIFT;
+	capacity >>= SCHED_CAPACITY_SHIFT;
 
 	if (!capacity)
 		capacity = 1;
@@ -5778,7 +5778,7 @@ static inline int
 fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 {
 	/*
-	 * Only siblings can have significantly less than SCHED_POWER_SCALE
+	 * Only siblings can have significantly less than SCHED_CAPACITY_SCALE
 	 */
 	if (!(sd->flags & SD_SHARE_CPUPOWER))
 		return 0;
@@ -5843,11 +5843,11 @@ static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *gro
 	cpus = group->group_weight;
 
 	/* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
-	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, capacity_orig);
+	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, capacity_orig);
 	capacity_factor = cpus / smt; /* cores */
 
 	capacity_factor = min_t(unsigned,
-		capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_POWER_SCALE));
+		capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE));
 	if (!capacity_factor)
 		capacity_factor = fix_small_capacity(env->sd, group);
 
@@ -5893,7 +5893,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 	/* Adjust by relative CPU capacity of the group */
 	sgs->group_capacity = group->sgc->capacity;
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_capacity;
+	sgs->avg_load = (sgs->group_load*SCHED_CAPACITY_SCALE) / sgs->group_capacity;
 
 	if (sgs->sum_nr_running)
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
@@ -6087,7 +6087,7 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 
 	env->imbalance = DIV_ROUND_CLOSEST(
 		sds->busiest_stat.avg_load * sds->busiest_stat.group_capacity,
-		SCHED_POWER_SCALE);
+		SCHED_CAPACITY_SCALE);
 
 	return 1;
 }
@@ -6116,7 +6116,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 		imbn = 1;
 
 	scaled_busy_load_per_task =
-		(busiest->load_per_task * SCHED_POWER_SCALE) /
+		(busiest->load_per_task * SCHED_CAPACITY_SCALE) /
 		busiest->group_capacity;
 
 	if (busiest->avg_load + scaled_busy_load_per_task >=
@@ -6135,7 +6135,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 			min(busiest->load_per_task, busiest->avg_load);
 	capa_now += local->group_capacity *
 			min(local->load_per_task, local->avg_load);
-	capa_now /= SCHED_POWER_SCALE;
+	capa_now /= SCHED_CAPACITY_SCALE;
 
 	/* Amount of load we'd subtract */
 	if (busiest->avg_load > scaled_busy_load_per_task) {
@@ -6146,16 +6146,16 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 
 	/* Amount of load we'd add */
 	if (busiest->avg_load * busiest->group_capacity <
-	    busiest->load_per_task * SCHED_POWER_SCALE) {
+	    busiest->load_per_task * SCHED_CAPACITY_SCALE) {
 		tmp = (busiest->avg_load * busiest->group_capacity) /
 		      local->group_capacity;
 	} else {
-		tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
+		tmp = (busiest->load_per_task * SCHED_CAPACITY_SCALE) /
 		      local->group_capacity;
 	}
 	capa_move += local->group_capacity *
 		    min(local->load_per_task, local->avg_load + tmp);
-	capa_move /= SCHED_POWER_SCALE;
+	capa_move /= SCHED_CAPACITY_SCALE;
 
 	/* Move if we gain throughput */
 	if (capa_move > capa_now)
@@ -6205,7 +6205,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		load_above_capacity =
 			(busiest->sum_nr_running - busiest->group_capacity_factor);
 
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
+		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
 		load_above_capacity /= busiest->group_capacity;
 	}
 
@@ -6223,7 +6223,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	env->imbalance = min(
 		max_pull * busiest->group_capacity,
 		(sds->avg_load - local->avg_load) * local->group_capacity
-	) / SCHED_POWER_SCALE;
+	) / SCHED_CAPACITY_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -6277,7 +6277,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	if (!sds.busiest || busiest->sum_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_capacity;
+	sds.avg_load = (SCHED_CAPACITY_SCALE * sds.total_load)
+						/ sds.total_capacity;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
@@ -6376,7 +6377,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 			continue;
 
 		capacity = capacity_of(i);
-		capacity_factor = DIV_ROUND_CLOSEST(capacity, SCHED_POWER_SCALE);
+		capacity_factor = DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE);
 		if (!capacity_factor)
 			capacity_factor = fix_small_capacity(env->sd, group);
 
-- 
1.8.4.108.g55ea5f6

