Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3DPP0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:26:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55404 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3DPP0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:26:21 -0400
Message-ID: <1366125976.9604.2.camel@e103567-lin>
Subject: [RFC PATCH 2/3] sched: introduce compute capacity for CPUs, groups
 and domains
From: Chris Redpath <chris.redpath@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Alex Shi <alex.shi@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Todd Poynor <toddpoynor@google.com>
Date: Tue, 16 Apr 2013 16:26:16 +0100
In-Reply-To: <cover.1364298828.git.chris.redpath@arm.com>
References: <cover.1364298828.git.chris.redpath@arm.com>
References: <cover.1364298828.git.chris.redpath@arm.com>
In-Reply-To: <cover.1364298828.git.chris.redpath@arm.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 16 Apr 2013 15:26:17.0696 (UTC) FILETIME=[BD6F2600:01CE3AB6]
X-MC-Unique: 113041616262000601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the per-cpu compute capacity exported from topology
when CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY is active, place this
information alongside cpu_power in the scheduler and combine for the
various aggregating entities.

Change-Id: I4984c335bcdc128680e7459b3f86bb05e04593cc
---
 include/linux/sched.h        |    7 +++++
 include/trace/events/sched.h |   24 +++++++++++++++
 kernel/sched/core.c          |    2 ++
 kernel/sched/debug.c         |    3 ++
 kernel/sched/fair.c          |   69 ++++++++++++++++++++++++++++++++++++++----
 kernel/sched/sched.h         |    4 +++
 6 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7c64f30..f2ee59a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -863,6 +863,13 @@ struct sched_group_power {
 	unsigned int power, power_orig;
 	unsigned long next_update;
 	/*
+	 * Compute capacity of this group, where each CPU has a compute
+	 * capacity expressed as a value [0..SCHED_POWER_SCALE] against
+	 * the most powerful CPU in the system of capacity SCHED_POWER_SCALE.
+	 */
+	unsigned int compute_capacity;
+	unsigned int max_compute_capacity;
+	/*
 	 * Number of busy cpus in this group.
 	 */
 	atomic_t nr_busy_cpus;
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 8932919..45e27bc 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -985,6 +985,30 @@ TRACE_EVENT(sched_fsi,
 );
 
 /*
+ * Extra debug trace points
+ */
+TRACE_EVENT(sched_upd_cap,
+
+	TP_PROTO(int dst_cpu, unsigned long curr, unsigned long max ),
+
+	TP_ARGS(dst_cpu, curr, max ),
+
+	TP_STRUCT__entry(
+		__field(int,  dst_cpu)
+		__field(unsigned long,  curr)
+		__field(unsigned long,  max)
+	),
+
+	TP_fast_assign(
+		__entry->dst_cpu = dst_cpu;
+		__entry->curr = curr;
+		__entry->max = max;
+	),
+
+	TP_printk("cpu=%d curr=%lu max=%lu",
+			__entry->dst_cpu, __entry->curr, __entry->max)
+);
+/*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec7406d..e535222 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6940,6 +6940,8 @@ void __init sched_init(void)
 		rq->sd = NULL;
 		rq->rd = NULL;
 		rq->cpu_power = SCHED_POWER_SCALE;
+		rq->curr_compute_capacity = SCHED_POWER_SCALE;
+		rq->max_compute_capacity = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index b9d54d0..9102bb4 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -290,6 +290,9 @@ do {									\
 #define PN(x) \
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rq->x))
 
+	P(cpu_power);
+	P(curr_compute_capacity);
+	P(max_compute_capacity);
 	P(nr_running);
 	SEQ_printf(m, "  .%-30s: %lu\n", "load",
 		   rq->load.weight);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d9af9c1..f6bbe1e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1267,6 +1267,27 @@ static u32 __compute_runnable_contrib(u64 n)
 	return contrib + runnable_avg_yN_sum[n];
 }
 
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+#define SCHED_ARCH_SCALE_POWER_SHIFT 10
+#endif
+static inline unsigned long compute_capacity_of(int cpu)
+{
+	return cpu_rq(cpu)->curr_compute_capacity;
+}
+
+static inline unsigned long max_compute_capacity_of(int cpu)
+{
+	return cpu_rq(cpu)->max_compute_capacity;
+}
+
+static inline void update_cpu_capacity(int cpu)
+{
+	int tmp_capacity = arch_get_cpu_capacity(cpu);
+	int tmp_max_capacity = arch_get_max_cpu_capacity(cpu);
+	trace_sched_upd_cap(cpu, tmp_capacity, tmp_max_capacity);
+	cpu_rq(cpu)->max_compute_capacity = tmp_max_capacity;
+	cpu_rq(cpu)->curr_compute_capacity = tmp_capacity;
+}
 /*
  * We can represent the historical contribution to runnable average as the
  * coefficients of a geometric series.  To do this we sub-divide our runnable
@@ -4360,6 +4381,8 @@ struct sd_lb_stats {
 	unsigned long total_load;  /* Total load of all groups in sd */
 	unsigned long total_pwr;   /*	Total power of all groups in sd */
 	unsigned long avg_load;	   /* Average load across all groups in sd */
+	unsigned long total_cap;   /* Total current compute capacity of all groups in sd */
+	unsigned long total_maxcap; /* Total max compute capacity of all groups in sd */
 
 	/** Statistics of this group */
 	unsigned long this_load;
@@ -4388,7 +4411,9 @@ struct sg_lb_stats {
 	unsigned long group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long group_capacity;
+	unsigned long group_compute_capacity; /* current compute capacity of the group */
+	unsigned long group_max_compute_capacity; /* maximum compute capacity of the group */
+	unsigned long group_capacity; /* Nr tasks this group can handle before considered overloaded */
 	unsigned long idle_cpus;
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
@@ -4430,6 +4455,23 @@ unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return default_scale_freq_power(sd, cpu);
 }
+unsigned long __weak arch_cpu_capacity(int cpu)
+{
+	return SCHED_POWER_SCALE;
+}
+unsigned long __weak arch_max_cpu_capacity(int cpu)
+{
+	return SCHED_POWER_SCALE;
+}
+
+unsigned long __weak arch_get_cpu_capacity(int cpu)
+{
+	return SCHED_POWER_SCALE;
+}
+unsigned long __weak arch_get_max_cpu_capacity(int cpu)
+{
+	return SCHED_POWER_SCALE;
+}
 
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
@@ -4506,6 +4548,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		power = 1;
 
 	cpu_rq(cpu)->cpu_power = power;
+	update_cpu_capacity(cpu);
 	sdg->sgp->power = power;
 }
 
@@ -4514,6 +4557,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
 	unsigned long power;
+	unsigned long compute_capacity, max_compute_capacity;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -4526,6 +4570,8 @@ void update_group_power(struct sched_domain *sd, int cpu)
 	}
 
 	power = 0;
+	compute_capacity = 0;
+	max_compute_capacity = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -4533,8 +4579,11 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 * span the current group.
 		 */
 
-		for_each_cpu(cpu, sched_group_cpus(sdg))
+		for_each_cpu(cpu, sched_group_cpus(sdg)) {
 			power += power_of(cpu);
+			compute_capacity += compute_capacity_of(cpu);
+			max_compute_capacity += max_compute_capacity_of(cpu);
+		}
 	} else  {
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
@@ -4544,11 +4593,15 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		group = child->groups;
 		do {
 			power += group->sgp->power;
+			compute_capacity += group->sgp->compute_capacity;
+			max_compute_capacity += group->sgp->max_compute_capacity;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
 	sdg->sgp->power_orig = sdg->sgp->power = power;
+	sdg->sgp->compute_capacity = compute_capacity;
+	sdg->sgp->max_compute_capacity = max_compute_capacity;
 }
 
 /*
@@ -4639,6 +4692,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
+		sgs->group_compute_capacity += compute_capacity_of(i);
+		sgs->group_max_compute_capacity += max_compute_capacity_of(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
@@ -4774,6 +4829,8 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += sg->sgp->power;
+		sds->total_cap += sg->sgp->compute_capacity;
+		sds->total_maxcap += sg->sgp->compute_capacity;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -5122,12 +5179,12 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power,
+		unsigned long task_capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
 		unsigned long wl;
 
-		if (!capacity)
-			capacity = fix_small_capacity(env->sd, group);
+		if (!task_capacity)
+			task_capacity = fix_small_capacity(env->sd, group);
 
 		if (!cpumask_test_cpu(i, env->cpus))
 			continue;
@@ -5151,7 +5208,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (task_capacity && rq->nr_running == 1 && wl > env->imbalance)
 			continue;
 
 		/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6f8976b..0946f40 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -412,6 +412,10 @@ struct rq {
 
 	unsigned long cpu_power;
 
+	/* CPU compute capacity estimation */
+	unsigned long max_compute_capacity;
+	unsigned long curr_compute_capacity;
+
 	unsigned char idle_balance;
 	/* For active balancing */
 	int post_schedule;
-- 
1.7.9.5



