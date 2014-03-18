Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaCRR7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:59:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46903 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbaCRR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:57:41 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 4/7] sched: powerpc: create a dedicated topology table
Date: Tue, 18 Mar 2014 18:56:46 +0100
Message-Id: <1395165409-18055-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dedicated topology table for handling asymetric feature of powerpc.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/powerpc/kernel/smp.c | 31 +++++++++++++++++++++++--------
 include/linux/sched.h     |  2 --
 kernel/sched/core.c       |  6 ------
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index ac2621a..c9cade5 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -755,6 +755,28 @@ int setup_profiling_timer(unsigned int multiplier)
 	return 0;
 }
 
+#ifdef CONFIG_SCHED_SMT
+/* cpumask of CPUs with asymetric SMT dependancy */
+static const int powerpc_smt_flags(void)
+{
+	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+
+	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
+		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
+		flags |= SD_ASYM_PACKING;
+	}
+	return flags;
+}
+#endif
+
+static struct sched_domain_topology_level powerpc_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, powerpc_smt_flags, SD_INIT_NAME(SMT) },
+#endif
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 	cpumask_var_t old_mask;
@@ -779,15 +801,8 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
 	dump_numa_cpu_topology();
 
-}
+	set_sched_topology(powerpc_topology);
 
-int arch_sd_sibling_asym_packing(void)
-{
-	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
-		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
-		return SD_ASYM_PACKING;
-	}
-	return 0;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4db592a..6479de4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -868,8 +868,6 @@ enum cpu_idle_type {
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
-extern int __weak arch_sd_sibiling_asym_packing(void);
-
 #ifdef CONFIG_SCHED_SMT
 static inline const int cpu_smt_flags(void)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f2bfa76..0b51ee3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5833,11 +5833,6 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
 }
 
-int __weak arch_sd_sibling_asym_packing(void)
-{
-       return 0*SD_ASYM_PACKING;
-}
-
 /*
  * Initializers for schedule domains
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
@@ -6018,7 +6013,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	if (sd->flags & SD_SHARE_CPUPOWER) {
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
-		sd->flags |= arch_sd_sibling_asym_packing();
 
 	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
 		sd->imbalance_pct = 117;
-- 
1.9.0

