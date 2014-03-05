Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaCEHTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:19:12 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64914 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaCEHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:19:08 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 2/6] sched: rework of sched_domain topology definition
Date: Wed,  5 Mar 2014 15:18:22 +0800
Message-Id: <1394003906-11630-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We replace the old way to configure the scheduler topology with a new method
which enables a platform to declare additionnal level (if needed).

We still have a default topology table definition that can be used by platform
that don't want more level than the SMT, MC, CPU and NUMA ones. This table can
be overwritten by an arch which wants to add new level where a load balance
make sense like BOOK or powergating level.

For each level, we need a function pointer that returns cpumask for each cpu,
the flags configuration and a name. Each level must be a subset on
the next one. The build sequence of the sched_domain will take care of
removing useless levels like those with 1 CPU and those with the same CPU span
and relevant information for load balancing than its child .

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/ia64/include/asm/topology.h |   24 ----
 arch/s390/include/asm/topology.h |    2 -
 arch/tile/include/asm/topology.h |   33 ------
 include/linux/sched.h            |   29 +++++
 include/linux/topology.h         |  128 +++------------------
 kernel/sched/core.c              |  227 +++++++++++++++++++-------------------
 6 files changed, 156 insertions(+), 287 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..20d12fa 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -46,30 +46,6 @@
 
 void build_cpu_to_node_map(void);
 
-#define SD_CPU_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 2,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 05425b1..07763bd 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -64,8 +64,6 @@ static inline void s390_init_cpu_topology(void)
 };
 #endif
 
-#define SD_BOOK_INIT	SD_CPU_INIT
-
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_S390_TOPOLOGY_H */
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d15c0d8..9383118 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -44,39 +44,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 /* For now, use numa node -1 for global allocation. */
 #define pcibus_to_node(bus)		((void)(bus), -1)
 
-/*
- * TILE architecture has many cores integrated in one processor, so we need
- * setup bigger balance_interval for both CPU/NODE scheduling domains to
- * reduce process scheduling costs.
- */
-
-/* sched_domains SD_CPU_INIT for TILE architecture */
-#define SD_CPU_INIT (struct sched_domain) {				\
-	.min_interval		= 4,					\
-	.max_interval		= 128,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 32,					\
-}
-
 /* By definition, we create nodes based on online memory. */
 #define node_has_online_mem(nid) 1
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 825ed83..dbc35dd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -976,6 +976,35 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
+typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+
+#define SDTL_OVERLAP	0x01
+
+struct sd_data {
+	struct sched_domain **__percpu sd;
+	struct sched_group **__percpu sg;
+	struct sched_group_power **__percpu sgp;
+};
+
+struct sched_domain_topology_level {
+	sched_domain_mask_f mask;
+	int		    sd_flags;
+	int		    flags;
+	int		    numa_level;
+	struct sd_data      data;
+#ifdef CONFIG_SCHED_DEBUG
+	char                *name;
+#endif
+};
+
+extern struct sched_domain_topology_level *sched_domain_topology;
+
+#ifdef CONFIG_SCHED_DEBUG
+# define SD_INIT_NAME(type)		.name = #type
+#else
+# define SD_INIT_NAME(type)
+#endif
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 12ae6ce..3a9db05 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -66,121 +66,6 @@ int arch_update_cpu_topology(void);
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
 #endif
 
-/*
- * Below are the 3 major initializers used in building sched_domains:
- * SD_SIBLING_INIT, for SMT domains
- * SD_CPU_INIT, for SMP domains
- *
- * Any architecture that cares to do any tuning to these values should do so
- * by defining their own arch-specific initializer in include/asm/topology.h.
- * A definition there will automagically override these default initializers
- * and allow arch-specific performance tuning of sched_domains.
- * (Only non-zero and non-null fields need be specified.)
- */
-
-#ifdef CONFIG_SCHED_SMT
-/* MCD - Do we really need this?  It is always on if CONFIG_SCHED_SMT is,
- * so can't we drop this in favor of CONFIG_SCHED_SMT?
- */
-#define ARCH_HAS_SCHED_WAKE_IDLE
-/* Common values for SMT siblings */
-#ifndef SD_SIBLING_INIT
-#define SD_SIBLING_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 2,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 110,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_SHARE_CPUPOWER			\
-				| 1*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				| arch_sd_sibling_asym_packing()	\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.smt_gain		= 1178,	/* 15% */			\
-	.max_newidle_lb_cost	= 0,					\
-	.next_decay_max_lb_cost	= jiffies,				\
-}
-#endif
-#endif /* CONFIG_SCHED_SMT */
-
-#ifdef CONFIG_SCHED_MC
-/* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
-#ifndef SD_MC_INIT
-#define SD_MC_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 4,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 1*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.max_newidle_lb_cost	= 0,					\
-	.next_decay_max_lb_cost	= jiffies,				\
-}
-#endif
-#endif /* CONFIG_SCHED_MC */
-
-/* Common values for CPUs */
-#ifndef SD_CPU_INIT
-#define SD_CPU_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 4,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				| 1*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.max_newidle_lb_cost	= 0,					\
-	.next_decay_max_lb_cost	= jiffies,				\
-}
-#endif
-
-#ifdef CONFIG_SCHED_BOOK
-#ifndef SD_BOOK_INIT
-#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
-#endif
-#endif /* CONFIG_SCHED_BOOK */
-
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DECLARE_PER_CPU(int, numa_node);
 
@@ -295,4 +180,17 @@ static inline int cpu_to_mem(int cpu)
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
+#ifdef CONFIG_SCHED_SMT
+static inline const struct cpumask *cpu_smt_mask(int cpu)
+{
+	return topology_thread_cpumask(cpu);
+}
+#endif
+
+static inline const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
+
+
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee8004c..6f6a8f0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5588,17 +5588,6 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-static const struct cpumask *cpu_cpu_mask(int cpu)
-{
-	return cpumask_of_node(cpu_to_node(cpu));
-}
-
-struct sd_data {
-	struct sched_domain **__percpu sd;
-	struct sched_group **__percpu sg;
-	struct sched_group_power **__percpu sgp;
-};
-
 struct s_data {
 	struct sched_domain ** __percpu sd;
 	struct root_domain	*rd;
@@ -5611,21 +5600,6 @@ enum s_alloc {
 	sa_none,
 };
 
-struct sched_domain_topology_level;
-
-typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
-typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
-
-#define SDTL_OVERLAP	0x01
-
-struct sched_domain_topology_level {
-	sched_domain_init_f init;
-	sched_domain_mask_f mask;
-	int		    flags;
-	int		    numa_level;
-	struct sd_data      data;
-};
-
 /*
  * Build an iteration mask that can exclude certain CPUs from the upwards
  * domain traversal.
@@ -5854,34 +5828,6 @@ int __weak arch_sd_sibling_asym_packing(void)
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
  */
 
-#ifdef CONFIG_SCHED_DEBUG
-# define SD_INIT_NAME(sd, type)		sd->name = #type
-#else
-# define SD_INIT_NAME(sd, type)		do { } while (0)
-#endif
-
-#define SD_INIT_FUNC(type)						\
-static noinline struct sched_domain *					\
-sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
-{									\
-	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
-	*sd = SD_##type##_INIT;						\
-	SD_INIT_NAME(sd, type);						\
-	sd->private = &tl->data;					\
-	return sd;							\
-}
-
-SD_INIT_FUNC(CPU)
-#ifdef CONFIG_SCHED_SMT
- SD_INIT_FUNC(SIBLING)
-#endif
-#ifdef CONFIG_SCHED_MC
- SD_INIT_FUNC(MC)
-#endif
-#ifdef CONFIG_SCHED_BOOK
- SD_INIT_FUNC(BOOK)
-#endif
-
 static int default_relax_domain_level = -1;
 int sched_domain_level_max;
 
@@ -5969,97 +5915,148 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 }
 
-#ifdef CONFIG_SCHED_SMT
-static const struct cpumask *cpu_smt_mask(int cpu)
-{
-	return topology_thread_cpumask(cpu);
-}
-#endif
-
-/*
- * Topology list, bottom-up.
- */
-static struct sched_domain_topology_level default_topology[] = {
-#ifdef CONFIG_SCHED_SMT
-	{ sd_init_SIBLING, cpu_smt_mask, },
-#endif
-#ifdef CONFIG_SCHED_MC
-	{ sd_init_MC, cpu_coregroup_mask, },
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	{ sd_init_BOOK, cpu_book_mask, },
-#endif
-	{ sd_init_CPU, cpu_cpu_mask, },
-	{ NULL, },
-};
-
-static struct sched_domain_topology_level *sched_domain_topology = default_topology;
-
-#define for_each_sd_topology(tl)			\
-	for (tl = sched_domain_topology; tl->init; tl++)
+static int sched_domains_curr_level;
 
 #ifdef CONFIG_NUMA
-
 static int sched_domains_numa_levels;
 static int *sched_domains_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
-static int sched_domains_curr_level;
-
-static inline int sd_local_flags(int level)
-{
-	if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
-		return 0;
+#endif
 
-	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
-}
+/*
+ * SD_flags allowed in topology descriptions.
+ *
+ * SD_SHARE_CPUPOWER      - describes SMT topologies
+ * SD_SHARE_PKG_RESOURCES - describes shared caches
+ * SD_NUMA                - describes NUMA topologies
+ *
+ * Odd one out:
+ * SD_ASYM_PACKING        - describes SMT quirks
+ */
+#define TOPOLOGY_SD_FLAGS		\
+	(SD_SHARE_CPUPOWER |		\
+	 SD_SHARE_PKG_RESOURCES |	\
+	 SD_NUMA |			\
+	 SD_ASYM_PACKING)
 
 static struct sched_domain *
-sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
+sd_init(struct sched_domain_topology_level *tl, int cpu)
 {
 	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
-	int level = tl->numa_level;
-	int sd_weight = cpumask_weight(
-			sched_domains_numa_masks[level][cpu_to_node(cpu)]);
+	int sd_weight;
+
+	/*
+	 * Ugly hack to pass state to sd_numa_mask()...
+	 */
+	sched_domains_curr_level = tl->numa_level;
+
+	sd_weight = cpumask_weight(tl->mask(cpu));
+
+	if (WARN_ONCE(tl->sd_flags & ~TOPOLOGY_SD_FLAGS,
+			"wrong sd_flags in topology description\n"))
+		tl->sd_flags &= ~TOPOLOGY_SD_FLAGS;
 
 	*sd = (struct sched_domain){
 		.min_interval		= sd_weight,
 		.max_interval		= 2*sd_weight,
 		.busy_factor		= 32,
 		.imbalance_pct		= 125,
-		.cache_nice_tries	= 2,
-		.busy_idx		= 3,
-		.idle_idx		= 2,
+
+		.cache_nice_tries	= 0,
+		.busy_idx		= 0,
+		.idle_idx		= 0,
 		.newidle_idx		= 0,
 		.wake_idx		= 0,
 		.forkexec_idx		= 0,
 
 		.flags			= 1*SD_LOAD_BALANCE
 					| 1*SD_BALANCE_NEWIDLE
-					| 0*SD_BALANCE_EXEC
-					| 0*SD_BALANCE_FORK
+					| 1*SD_BALANCE_EXEC
+					| 1*SD_BALANCE_FORK
 					| 0*SD_BALANCE_WAKE
-					| 0*SD_WAKE_AFFINE
+					| 1*SD_WAKE_AFFINE
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
-					| 1*SD_SERIALIZE
+					| 0*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
-					| 1*SD_NUMA
-					| sd_local_flags(level)
+					| 0*SD_NUMA
+					| tl->sd_flags
 					,
+
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.smt_gain		= 0,
+		.max_newidle_lb_cost	= 0,
+		.next_decay_max_lb_cost	= jiffies,
+#ifdef CONFIG_SCHED_DEBUG
+		.name			= tl->name,
+#endif
 	};
-	SD_INIT_NAME(sd, NUMA);
-	sd->private = &tl->data;
 
 	/*
-	 * Ugly hack to pass state to sd_numa_mask()...
+	 * Convert topological properties into behaviour.
 	 */
-	sched_domains_curr_level = tl->numa_level;
+
+	if (sd->flags & SD_SHARE_CPUPOWER) {
+		sd->imbalance_pct = 110;
+		sd->smt_gain = 1178; /* ~15% */
+		sd->flags |= arch_sd_sibling_asym_packing();
+
+	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
+		sd->imbalance_pct = 117;
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+
+#ifdef CONFIG_NUMA
+	} else if (sd->flags & SD_NUMA) {
+		sd->cache_nice_tries = 2;
+		sd->busy_idx = 3;
+		sd->idle_idx = 2;
+
+		sd->flags |= SD_SERIALIZE;
+		if (sched_domains_numa_distance[tl->numa_level] > RECLAIM_DISTANCE) {
+			sd->flags &= ~(SD_BALANCE_EXEC |
+				       SD_BALANCE_FORK |
+				       SD_WAKE_AFFINE);
+		}
+
+#endif
+	} else {
+		sd->flags |= SD_PREFER_SIBLING;
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+		sd->idle_idx = 1;
+	}
+
+	sd->private = &tl->data;
 
 	return sd;
 }
 
+/*
+ * Topology list, bottom-up.
+ */
+static struct sched_domain_topology_level default_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(SMT) },
+#endif
+#ifdef CONFIG_SCHED_MC
+	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(MC) },
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
+#endif
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
+struct sched_domain_topology_level *sched_domain_topology = default_topology;
+
+#define for_each_sd_topology(tl)			\
+	for (tl = sched_domain_topology; tl->mask; tl++)
+
+#ifdef CONFIG_NUMA
+
 static const struct cpumask *sd_numa_mask(int cpu)
 {
 	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
@@ -6203,7 +6200,10 @@ static void sched_init_numa(void)
 		}
 	}
 
-	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
+	/* Compute default topology size */
+	for (i = 0; sched_domain_topology[i].mask; i++);
+
+	tl = kzalloc((i + level) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
@@ -6211,18 +6211,19 @@ static void sched_init_numa(void)
 	/*
 	 * Copy the default topology bits..
 	 */
-	for (i = 0; default_topology[i].init; i++)
-		tl[i] = default_topology[i];
+	for (i = 0; sched_domain_topology[i].mask; i++)
+		tl[i] = sched_domain_topology[i];
 
 	/*
 	 * .. and append 'j' levels of NUMA goodness.
 	 */
 	for (j = 0; j < level; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
-			.init = sd_numa_init,
 			.mask = sd_numa_mask,
+			.sd_flags = SD_NUMA,
 			.flags = SDTL_OVERLAP,
 			.numa_level = j,
+			SD_INIT_NAME(NUMA)
 		};
 	}
 
@@ -6380,7 +6381,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 		struct sched_domain *child, int cpu)
 {
-	struct sched_domain *sd = tl->init(tl, cpu);
+	struct sched_domain *sd = sd_init(tl, cpu);
 	if (!sd)
 		return child;
 
-- 
1.7.9.5

