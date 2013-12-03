Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3LCJHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:07:41 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39260 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3LCJHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:07:07 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] sched: remove rq->cpu_load[load_idx] array
Date: Tue,  3 Dec 2013 17:05:54 +0800
Message-Id: <1386061556-28233-3-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since load_idx effect removed in load balance, we don't need the
load_idx decays in scheduler. that will save some process in sched_tick
and others places.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 arch/ia64/include/asm/topology.h  |  5 ---
 arch/metag/include/asm/topology.h |  5 ---
 arch/tile/include/asm/topology.h  |  6 ---
 include/linux/sched.h             |  5 ---
 include/linux/topology.h          |  8 ----
 kernel/sched/core.c               | 60 ++++++++-----------------
 kernel/sched/debug.c              |  6 +--
 kernel/sched/fair.c               | 79 +++++++++------------------------
 kernel/sched/proc.c               | 92 ++-------------------------------------
 kernel/sched/sched.h              |  3 +-
 10 files changed, 43 insertions(+), 226 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..54e5b17 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -55,11 +55,6 @@ void build_cpu_to_node_map(void);
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 2,			\
-	.busy_idx		= 2,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 8e9c0b3..d1d15cd 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -13,11 +13,6 @@
 	.busy_factor		= 32,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d15c0d8..05f6ffe 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -57,12 +57,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 	.busy_factor		= 64,					\
 	.imbalance_pct		= 125,					\
 	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7e35d4b..a23e02d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -815,11 +815,6 @@ struct sched_domain {
 	unsigned int busy_factor;	/* less balancing by factor if busy */
 	unsigned int imbalance_pct;	/* No balance until over watermark */
 	unsigned int cache_nice_tries;	/* Leave cache hot tasks for # tries */
-	unsigned int busy_idx;
-	unsigned int idle_idx;
-	unsigned int newidle_idx;
-	unsigned int wake_idx;
-	unsigned int forkexec_idx;
 	unsigned int smt_gain;
 
 	int nohz_idle;			/* NOHZ IDLE status */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 12ae6ce..863fad3 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -121,9 +121,6 @@ int arch_update_cpu_topology(void);
 	.busy_factor		= 64,					\
 	.imbalance_pct		= 125,					\
 	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
@@ -151,11 +148,6 @@ int arch_update_cpu_topology(void);
 	.busy_factor		= 64,					\
 	.imbalance_pct		= 125,					\
 	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..9528f75 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4279,61 +4279,42 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 	*tablep = NULL;
 }
 
-static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX-1;
-
 static void
 set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
-		umode_t mode, proc_handler *proc_handler,
-		bool load_idx)
+		umode_t mode, proc_handler *proc_handler)
 {
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
 	entry->mode = mode;
 	entry->proc_handler = proc_handler;
-
-	if (load_idx) {
-		entry->extra1 = &min_load_idx;
-		entry->extra2 = &max_load_idx;
-	}
 }
 
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(13);
+	struct ctl_table *table = sd_alloc_ctl_entry(8);
 
 	if (table == NULL)
 		return NULL;
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax, false);
+		sizeof(long), 0644, proc_doulongvec_minmax);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax, false);
-	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
-	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
-	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
-	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
-	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
-		sizeof(int), 0644, proc_dointvec_minmax, true);
-	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[9], "cache_nice_tries",
+		sizeof(long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[2], "busy_factor", &sd->busy_factor,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[3], "imbalance_pct", &sd->imbalance_pct,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[4], "cache_nice_tries",
 		&sd->cache_nice_tries,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[11], "name", sd->name,
-		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[12] is terminator */
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[5], "flags", &sd->flags,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[6], "name", sd->name,
+		CORENAME_MAX_SIZE, 0444, proc_dostring);
+	/* &table[7] is terminator */
 
 	return table;
 }
@@ -5425,11 +5406,6 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 		.busy_factor		= 32,
 		.imbalance_pct		= 125,
 		.cache_nice_tries	= 2,
-		.busy_idx		= 3,
-		.idle_idx		= 2,
-		.newidle_idx		= 0,
-		.wake_idx		= 0,
-		.forkexec_idx		= 0,
 
 		.flags			= 1*SD_LOAD_BALANCE
 					| 1*SD_BALANCE_NEWIDLE
@@ -6178,7 +6154,7 @@ DECLARE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 void __init sched_init(void)
 {
-	int i, j;
+	int i;
 	unsigned long alloc_size = 0, ptr;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -6279,9 +6255,7 @@ void __init sched_init(void)
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
-		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
-			rq->cpu_load[j] = 0;
-
+		rq->cpu_load = 0;
 		rq->last_load_update_tick = jiffies;
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 5c34d18..675be71 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -303,11 +303,7 @@ do {									\
 	PN(next_balance);
 	SEQ_printf(m, "  .%-30s: %ld\n", "curr->pid", (long)(task_pid_nr(rq->curr)));
 	PN(clock);
-	P(cpu_load[0]);
-	P(cpu_load[1]);
-	P(cpu_load[2]);
-	P(cpu_load[3]);
-	P(cpu_load[4]);
+	P(cpu_load);
 #undef P
 #undef PN
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ce683aa..bccdd89 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -977,8 +977,8 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 }
 
 static unsigned long weighted_cpuload(const int cpu);
-static unsigned long source_load(int cpu, int type);
-static unsigned long target_load(int cpu, int type);
+static unsigned long source_load(int cpu);
+static unsigned long target_load(int cpu);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3794,30 +3794,30 @@ static unsigned long weighted_cpuload(const int cpu)
  * We want to under-estimate the load of migration sources, to
  * balance conservatively.
  */
-static unsigned long source_load(int cpu, int type)
+static unsigned long source_load(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (!sched_feat(LB_BIAS))
 		return total;
 
-	return min(rq->cpu_load[type-1], total);
+	return min(rq->cpu_load, total);
 }
 
 /*
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu, int type)
+static unsigned long target_load(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (!sched_feat(LB_BIAS))
 		return total;
 
-	return max(rq->cpu_load[type-1], total);
+	return max(rq->cpu_load, total);
 }
 
 static unsigned long power_of(int cpu)
@@ -4017,7 +4017,7 @@ static int wake_wide(struct task_struct *p)
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
-	int idx, this_cpu, prev_cpu;
+	int this_cpu, prev_cpu;
 	unsigned long tl_per_task;
 	struct task_group *tg;
 	unsigned long weight;
@@ -4030,11 +4030,10 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	if (wake_wide(p))
 		return 0;
 
-	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+	load	  = source_load(prev_cpu);
+	this_load = target_load(this_cpu);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4090,7 +4089,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
+	     this_load + target_load(prev_cpu) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4109,8 +4108,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  * domain.
  */
 static struct sched_group *
-find_idlest_group(struct sched_domain *sd, struct task_struct *p,
-		  int this_cpu, int load_idx)
+find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
@@ -4135,9 +4133,9 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
-				load = source_load(i, load_idx);
+				load = source_load(i);
 			else
-				load = target_load(i, load_idx);
+				load = target_load(i);
 
 			avg_load += load;
 		}
@@ -4283,7 +4281,6 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	}
 
 	while (sd) {
-		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
 
@@ -4292,10 +4289,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			continue;
 		}
 
-		if (sd_flag & SD_BALANCE_WAKE)
-			load_idx = sd->wake_idx;
-
-		group = find_idlest_group(sd, p, cpu, load_idx);
+		group = find_idlest_group(sd, p, cpu);
 		if (!group) {
 			sd = sd->child;
 			continue;
@@ -5238,34 +5232,6 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 	};
 }
 
-/**
- * get_sd_load_idx - Obtain the load index for a given sched domain.
- * @sd: The sched_domain whose load_idx is to be obtained.
- * @idle: The idle status of the CPU for whose sd load_idx is obtained.
- *
- * Return: The load index.
- */
-static inline int get_sd_load_idx(struct sched_domain *sd,
-					enum cpu_idle_type idle)
-{
-	int load_idx;
-
-	switch (idle) {
-	case CPU_NOT_IDLE:
-		load_idx = sd->busy_idx;
-		break;
-
-	case CPU_NEWLY_IDLE:
-		load_idx = sd->newidle_idx;
-		break;
-	default:
-		load_idx = sd->idle_idx;
-		break;
-	}
-
-	return load_idx;
-}
-
 static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -5492,12 +5458,11 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
  * @group: sched_group whose statistics are to be updated.
- * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
  * @sgs: variable to hold the statistics for this group.
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
-			struct sched_group *group, int load_idx,
+			struct sched_group *group,
 			int local_group, struct sg_lb_stats *sgs)
 {
 	unsigned long nr_running;
@@ -5513,9 +5478,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
-			load = target_load(i, load_idx);
+			load = target_load(i);
 		else
-			load = source_load(i, load_idx);
+			load = source_load(i);
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += nr_running;
@@ -5628,13 +5593,11 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats tmp_sgs;
-	int load_idx, prefer_sibling = 0;
+	int prefer_sibling = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	load_idx = 0;
-
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
@@ -5649,7 +5612,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 				update_group_power(env->sd, env->dst_cpu);
 		}
 
-		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
+		update_sg_lb_stats(env, sg, local_group, sgs);
 
 		if (local_group)
 			goto next_group;
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 16f5a30..a2435c5 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -11,7 +11,7 @@
 unsigned long this_cpu_load(void)
 {
 	struct rq *this = this_rq();
-	return this->cpu_load[0];
+	return this->cpu_load;
 }
 
 
@@ -398,105 +398,19 @@ static void calc_load_account_active(struct rq *this_rq)
  * End of global load-average stuff
  */
 
-/*
- * The exact cpuload at various idx values, calculated at every tick would be
- * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
- *
- * If a cpu misses updates for n-1 ticks (as it was idle) and update gets called
- * on nth tick when cpu may be busy, then we have:
- * load = ((2^idx - 1) / 2^idx)^(n-1) * load
- * load = (2^idx - 1) / 2^idx) * load + 1 / 2^idx * cur_load
- *
- * decay_load_missed() below does efficient calculation of
- * load = ((2^idx - 1) / 2^idx)^(n-1) * load
- * avoiding 0..n-1 loop doing load = ((2^idx - 1) / 2^idx) * load
- *
- * The calculation is approximated on a 128 point scale.
- * degrade_zero_ticks is the number of ticks after which load at any
- * particular idx is approximated to be zero.
- * degrade_factor is a precomputed table, a row for each load idx.
- * Each column corresponds to degradation factor for a power of two ticks,
- * based on 128 point scale.
- * Example:
- * row 2, col 3 (=12) says that the degradation at load idx 2 after
- * 8 ticks is 12/128 (which is an approximation of exact factor 3^8/4^8).
- *
- * With this power of 2 load factors, we can degrade the load n times
- * by looking at 1 bits in n and doing as many mult/shift instead of
- * n mult/shifts needed by the exact degradation.
- */
-#define DEGRADE_SHIFT		7
-static const unsigned char
-		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
-static const unsigned char
-		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
-					{0, 0, 0, 0, 0, 0, 0, 0},
-					{64, 32, 8, 0, 0, 0, 0, 0},
-					{96, 72, 40, 12, 1, 0, 0},
-					{112, 98, 75, 43, 15, 1, 0},
-					{120, 112, 98, 76, 45, 16, 2} };
 
 /*
- * Update cpu_load for any missed ticks, due to tickless idle. The backlog
- * would be when CPU is idle and so we just decay the old load without
- * adding any new load.
- */
-static unsigned long
-decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
-{
-	int j = 0;
-
-	if (!missed_updates)
-		return load;
-
-	if (missed_updates >= degrade_zero_ticks[idx])
-		return 0;
-
-	if (idx == 1)
-		return load >> missed_updates;
-
-	while (missed_updates) {
-		if (missed_updates % 2)
-			load = (load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
-
-		missed_updates >>= 1;
-		j++;
-	}
-	return load;
-}
-
-/*
- * Update rq->cpu_load[] statistics. This function is usually called every
+ * Update rq->cpu_load statistics. This function is usually called every
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
 static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 			      unsigned long pending_updates)
 {
-	int i, scale;
-
 	this_rq->nr_load_updates++;
 
 	/* Update our load: */
-	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
-	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
-		unsigned long old_load, new_load;
-
-		/* scale is effectively 1 << i now, and >> i divides by scale */
-
-		old_load = this_rq->cpu_load[i];
-		old_load = decay_load_missed(old_load, pending_updates - 1, i);
-		new_load = this_load;
-		/*
-		 * Round up the averaging division if load is increasing. This
-		 * prevents us from getting stuck on 9 if the load is 10, for
-		 * example.
-		 */
-		if (new_load > old_load)
-			new_load += scale - 1;
-
-		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
-	}
+	this_rq->cpu_load = this_load; /* Fasttrack for idx 0 */
 
 	sched_avg_update(this_rq);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b2..01f6e7a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -413,8 +413,7 @@ struct rq {
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
 #endif
-	#define CPU_LOAD_IDX_MAX 5
-	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long cpu_load;
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ_COMMON
 	u64 nohz_stamp;
-- 
1.8.1.2

