Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaATMmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:42:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51638 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaATMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:06 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 04/11] sched: replace SD_INIT_FUNC with sd_init()
Date: Mon, 20 Jan 2014 12:39:41 +0000
Message-Id: <1390221588-20473-5-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:03.0363 (UTC) FILETIME=[BD84F730:01CF15DC]
X-MC-Unique: 114012012400404101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCgoO9003818

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch incorporates struct sched_domain_topology_info info into struct
sched_domain_topology_level.  It updates sd_init_numa() to reflect the
change that conventional (SMT, MC, BOOK, CPU)  level initialization relies
on the topology_info[] array and not on the default_topology[] any more.

Moreover a counterpart function sched_init_conv() is introduced to handle
the allocation of the topology array for a !CONFIG_NUMA system.

The patch deletes the default topology array default_topology[] and the
SD_INIT_FUNC() macro which are not used any more. The function
sd_local_flags() is deleted too and the appropriate functionality is
directly incorporated into the NUMA specific condition path in sd_init().

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |  247 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 135 insertions(+), 112 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 523bb43756d6..90aa7c3d3a00 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5006,15 +5006,10 @@ enum s_alloc {
 	sa_none,
 };
 
-struct sched_domain_topology_level;
-
-typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
-
 #define SDTL_OVERLAP	0x01
 
 struct sched_domain_topology_level {
-	sched_domain_init_f init;
-	sched_domain_mask_f mask;
+	struct sched_domain_topology_info info;
 	int		    flags;
 	int		    numa_level;
 	struct sd_data      data;
@@ -5254,28 +5249,6 @@ int __weak arch_sd_sibling_asym_packing(void)
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
 
@@ -5364,23 +5337,6 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 }
 
 /*
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
-/*
  * Topology info list, bottom-up.
  */
 static struct sched_domain_topology_info default_topology_info[] = {
@@ -5394,10 +5350,9 @@ static struct sched_domain_topology_info default_topology_info[] = {
 	{ cpu_book_mask, },
 #endif
 	{ cpu_cpu_mask, },
-	{ NULL, },
 };
 
-static struct sched_domain_topology_level *sched_domain_topology = default_topology;
+static struct sched_domain_topology_level *sched_domain_topology;
 static struct sched_domain_topology_info *sched_domain_topology_info =
 		default_topology_info;
 static unsigned int sched_domain_topology_info_size =
@@ -5411,7 +5366,7 @@ set_sd_topology_info(struct sched_domain_topology_info *ti, unsigned int s)
 }
 
 #define for_each_sd_topology(tl)			\
-	for (tl = sched_domain_topology; tl->init; tl++)
+	for (tl = sched_domain_topology; tl->info.mask; tl++)
 
 #ifdef CONFIG_NUMA
 
@@ -5420,61 +5375,6 @@ static int *sched_domains_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 
-static inline int sd_local_flags(int level)
-{
-	if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
-		return 0;
-
-	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
-}
-
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
@@ -5520,6 +5420,7 @@ static void sched_init_numa(void)
 {
 	int next_distance, curr_distance = node_distance(0, 0);
 	struct sched_domain_topology_level *tl;
+	struct sched_domain_topology_info *ti = sched_domain_topology_info;
 	int level = 0;
 	int i, j, k;
 
@@ -5618,24 +5519,29 @@ static void sched_init_numa(void)
 		}
 	}
 
-	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
-			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
+	/*
+	 * An extra empty struct sched_domain_topology_level element at the end
+	 * of the array is needed to let for_each_sd_topology() work correctly.
+	 */
+	tl = kzalloc((sched_domain_topology_info_size + level + 1) *
+			sizeof(struct sched_domain_topology_level),
+			GFP_KERNEL);
 	if (!tl)
 		return;
 
 	/*
-	 * Copy the default topology bits..
+	 * Copy the topology info bits..
 	 */
-	for (i = 0; default_topology[i].init; i++)
-		tl[i] = default_topology[i];
+	for (i = 0; i < sched_domain_topology_info_size; i++)
+		tl[i].info = ti[i];
 
 	/*
 	 * .. and append 'j' levels of NUMA goodness.
 	 */
 	for (j = 0; j < level; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
-			.init = sd_numa_init,
-			.mask = sd_numa_mask,
+			.info.mask = sd_numa_mask,
+			.info.flags = SD_NUMA,
 			.flags = SDTL_OVERLAP,
 			.numa_level = j,
 		};
@@ -5646,6 +5552,10 @@ static void sched_init_numa(void)
 	sched_domains_numa_levels = level;
 }
 
+static void sched_init_conv(void)
+{
+}
+
 static void sched_domains_numa_masks_set(int cpu)
 {
 	int i, j;
@@ -5698,6 +5608,31 @@ static inline void sched_init_numa(void)
 {
 }
 
+static void sched_init_conv(void)
+{
+	struct sched_domain_topology_level *tl;
+	struct sched_domain_topology_info *ti = sched_domain_topology_info;
+	int i;
+
+	/*
+	 * An extra empty struct sched_domain_topology_level element at the end
+	 * of the array is needed to let for_each_sd_topology() work correctly.
+	 */
+	tl = kzalloc((sched_domain_topology_info_size + 1) *
+		sizeof(struct sched_domain_topology_level),
+		GFP_KERNEL);
+	if (!tl)
+		return;
+
+	/*
+	 * Copy the topology info bits..
+	 */
+	for (i = 0; i < sched_domain_topology_info_size; i++)
+		tl[i].info = ti[i];
+
+	sched_domain_topology = tl;
+}
+
 static int sched_domains_numa_masks_update(struct notifier_block *nfb,
 					   unsigned long action,
 					   void *hcpu)
@@ -5706,6 +5641,93 @@ static int sched_domains_numa_masks_update(struct notifier_block *nfb,
 }
 #endif /* CONFIG_NUMA */
 
+static struct sched_domain *
+sd_init(struct sched_domain_topology_level *tl, int cpu)
+{
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
+	int sd_weight;
+
+#ifdef CONFIG_NUMA
+	/*
+	 * Ugly hack to pass state to sd_numa_mask()...
+	 */
+	sched_domains_curr_level = tl->numa_level;
+#endif
+
+	sd_weight = cpumask_weight(tl->info.mask(cpu));
+
+	if (WARN_ONCE(tl->info.flags & ~TOPOLOGY_SD_FLAGS,
+			"wrong flags in topology info\n"))
+		tl->info.flags &= ~TOPOLOGY_SD_FLAGS;
+
+	*sd = (struct sched_domain){
+				.min_interval  = sd_weight,
+				.max_interval  = 2*sd_weight,
+				.busy_factor   = 64,
+				.imbalance_pct = 125,
+
+				.flags =  1*SD_LOAD_BALANCE
+						| 1*SD_BALANCE_NEWIDLE
+						| 1*SD_BALANCE_EXEC
+						| 1*SD_BALANCE_FORK
+						| 1*SD_WAKE_AFFINE
+						| tl->info.flags
+						,
+
+				.last_balance     = jiffies,
+				.balance_interval = sd_weight,
+	};
+
+	/*
+	 * Convert topological properties into behaviour.
+	 */
+
+	if (sd->flags & SD_SHARE_CPUPOWER) {
+		sd->imbalance_pct = 110;
+		sd->smt_gain = 1178; /* ~15% */
+
+		/*
+		 * Call SMT specific arch topology function.
+		 * This goes away once the powerpc arch uses
+		 * the new interface for scheduler domain
+		 * setup.
+		 */
+		sd->flags |= arch_sd_sibling_asym_packing();
+
+		SD_INIT_NAME(sd, SMT);
+	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+
+		SD_INIT_NAME(sd, MC);
+#ifdef CONFIG_NUMA
+	} else if (sd->flags & SD_NUMA) {
+		sd->busy_factor = 32,
+		sd->cache_nice_tries = 2;
+		sd->busy_idx = 3;
+		sd->idle_idx = 2;
+		sd->flags |= SD_SERIALIZE;
+		if (sched_domains_numa_distance[tl->numa_level]
+				> RECLAIM_DISTANCE) {
+			sd->flags &= ~(SD_BALANCE_EXEC |
+				       SD_BALANCE_FORK |
+				       SD_WAKE_AFFINE);
+		}
+#endif
+	} else {
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+		sd->idle_idx = 1;
+		sd->flags |= SD_PREFER_SIBLING;
+
+		SD_INIT_NAME(sd, CPU);
+	}
+
+	sd->private = &tl->data;
+
+	return sd;
+}
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
@@ -5795,11 +5817,11 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 		struct sched_domain *child, int cpu)
 {
-	struct sched_domain *sd = tl->init(tl, cpu);
+	struct sched_domain *sd = sd_init(tl, cpu);
 	if (!sd)
 		return child;
 
-	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
+	cpumask_and(sched_domain_span(sd), cpu_map, tl->info.mask(cpu));
 	if (child) {
 		sd->level = child->level + 1;
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
@@ -6138,6 +6160,7 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
+	sched_init_conv();
 	sched_init_numa();
 
 	/*
-- 
1.7.9.5


