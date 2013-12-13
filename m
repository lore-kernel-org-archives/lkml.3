Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3LMMMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:12:03 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50937 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3LMMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:25 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 7/8] sched: replace topology level init func ptr with sd_init
Date: Fri, 13 Dec 2013 12:11:27 +0000
Message-Id: <1386936688-29113-8-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:22.0507 (UTC) FILETIME=[701CADB0:01CEF7FC]
X-MC-Unique: 113121312112402501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCC9n6009914

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch replaces the call to the sched_domain_topology_level
initialization function pointer tl->init() with a call to sd_init() in
build_sched_domain().  It sets the cpu mask and the flags for each
conventional scheduler domain level (i.e. the one without SD_NUMA topology
flag) in sched_alloc() and adds SD_NUMA to all NUMA levels.
Since the sched_domain_topology_level initialization function pointer, the
default_topology[] array and default SD_FOO_INIT macros are not used
any more, the patch deletes them.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/topology.h |  115 ----------------------------------------------
 kernel/sched/core.c      |  108 ++++---------------------------------------
 2 files changed, 10 insertions(+), 213 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index d147f63c2b1f..57301fd96fdb 100644
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
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 897ff9222cab..3bb8e3e2e58a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5005,14 +5005,9 @@ enum s_alloc {
 	sa_none,
 };
 
-struct sched_domain_topology_level;
-
-typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
-
 #define SDTL_OVERLAP	0x01
 
 struct sched_domain_topology_level {
-	sched_domain_init_f init;
 	sched_domain_mask_f mask;
 	int		    flags;
 	int		    numa_level;
@@ -5252,28 +5247,6 @@ int __weak arch_sd_sibling_asym_packing(void)
 # define SD_INIT_NAME(sd, type)		do { } while (0)
 #endif
 
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
 
@@ -5361,24 +5334,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 }
 
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
+static struct sched_domain_topology_level *sched_domain_topology;
 static int sched_domains_levels;
 
 #ifdef CONFIG_NUMA
@@ -5396,53 +5352,6 @@ static inline int sd_local_flags(int level)
 	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
 }
 
-static struct sched_domain *
-sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
-{
-	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
-	int level = tl->numa_level;
-	int sd_weight = cpumask_weight(
-			sched_domains_numa_masks[level][cpu_to_node(cpu)]);
-
-	*sd = (struct sched_domain){
-		.min_interval		= sd_weight,
-		.max_interval		= 2*sd_weight,
-		.busy_factor		= 32,
-		.imbalance_pct		= 125,
-		.cache_nice_tries	= 2,
-		.busy_idx		= 3,
-		.idle_idx		= 2,
-		.newidle_idx		= 0,
-		.wake_idx		= 0,
-		.forkexec_idx		= 0,
-
-		.flags			= 1*SD_LOAD_BALANCE
-					| 1*SD_BALANCE_NEWIDLE
-					| 0*SD_BALANCE_EXEC
-					| 0*SD_BALANCE_FORK
-					| 0*SD_BALANCE_WAKE
-					| 0*SD_WAKE_AFFINE
-					| 0*SD_SHARE_CPUPOWER
-					| 0*SD_SHARE_PKG_RESOURCES
-					| 1*SD_SERIALIZE
-					| 0*SD_PREFER_SIBLING
-					| 1*SD_NUMA
-					| sd_local_flags(level)
-					,
-		.last_balance		= jiffies,
-		.balance_interval	= sd_weight,
-	};
-	SD_INIT_NAME(sd, NUMA);
-	sd->private = &tl->data;
-
-	/*
-	 * Ugly hack to pass state to sd_numa_mask()...
-	 */
-	sched_domains_curr_level = tl->numa_level;
-
-	return sd;
-}
-
 static const struct cpumask *sd_numa_mask(int cpu)
 {
 	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
@@ -5742,10 +5651,14 @@ static void sched_alloc(void)
 	sched_domain_topology = tl;
 
 	/*
-	 * Copy the default topology bits..
+	 * Setup non NUMA levels
 	 */
-	for (i = 0; default_topology[i].init; i++)
-		tl[i] = default_topology[i];
+	for (i = 0; i < sched_domains_levels; i++) {
+		tl[i] = (struct sched_domain_topology_level) {
+			.mask = arch_sd_mask(i),
+			.flags = arch_sd_flags(i),
+		};
+	}
 
 #ifdef CONFIG_NUMA
 	/*
@@ -5753,9 +5666,8 @@ static void sched_alloc(void)
 	 */
 	for (j = 0; j < level; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
-			.init = sd_numa_init,
 			.mask = sd_numa_mask,
-			.flags = SDTL_OVERLAP,
+			.flags = SD_NUMA | SDTL_OVERLAP,
 			.numa_level = j,
 		};
 	}
@@ -5854,7 +5766,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 		struct sched_domain *child, int cpu)
 {
-	struct sched_domain *sd = tl->init(tl, cpu);
+	struct sched_domain *sd = sd_init(tl, cpu);
 	if (!sd)
 		return child;
 
-- 
1.7.9.5


