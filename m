Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaATMlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:41:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51772 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaATMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:08 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 09/11] sched: provide SD_ASYM_PACKING via topology info table
Date: Mon, 20 Jan 2014 12:39:46 +0000
Message-Id: <1390221588-20473-10-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:05.0644 (UTC) FILETIME=[BEE104C0:01CF15DC]
X-MC-Unique: 114012012400610101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCfS8F003798

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The provision of the sd topology flag SD_ASYM_PACKING is shifted from the
weak function arch_sd_sibling_asym_packing() towards an arch specific
topology info table.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/powerpc/kernel/smp.c |   34 +++++++++++++++++++++++++---------
 kernel/sched/core.c       |   13 -------------
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index c1cf4a1522d9..f8ba79dd9147 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -760,6 +760,30 @@ int setup_profiling_timer(unsigned int multiplier)
 	return 0;
 }
 
+#ifdef CONFIG_SCHED_SMT
+static inline int arch_cpu_smt_flags(int cpu)
+{
+	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+
+	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
+		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
+		flags |= SD_ASYM_PACKING;
+	}
+
+	return flags;
+}
+#endif
+
+static struct sched_domain_topology_info topology_info[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, arch_cpu_smt_flags, SD_NAME(SIBLING) },
+#endif
+#ifdef CONFIG_SCHED_MC
+	{ cpu_coregroup_mask, cpu_coregroup_flags, SD_NAME(MC) },
+#endif
+	{ cpu_cpu_mask, SD_NAME(CPU) },
+};
+
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 	cpumask_var_t old_mask;
@@ -784,15 +808,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
 	dump_numa_cpu_topology();
 
-}
-
-int arch_sd_sibling_asym_packing(void)
-{
-	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
-		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
-		return SD_ASYM_PACKING;
-	}
-	return 0;
+	set_sd_topology_info(topology_info, ARRAY_SIZE(topology_info));
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 79f34cc5f547..a3e945021e97 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5233,11 +5233,6 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
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
@@ -5662,14 +5657,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	if (sd->flags & SD_SHARE_CPUPOWER) {
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
-
-		/*
-		 * Call SMT specific arch topology function.
-		 * This goes away once the powerpc arch uses
-		 * the new interface for scheduler domain
-		 * setup.
-		 */
-		sd->flags |= arch_sd_sibling_asym_packing();
 	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
 		sd->cache_nice_tries = 1;
 		sd->busy_idx = 2;
-- 
1.7.9.5


