Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaEHKuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:50:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaEHKub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:50:31 -0400
Date: Thu, 8 May 2014 03:43:56 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-607b45e9a216e89a63351556e488eea06be0ff48@git.kernel.org>
Cc: mingo@kernel.org, hegdevasant@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        mpe@ellerman.id.au, robh+dt@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        grant.likely@linaro.org, paulus@samba.org, afleming@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, toshi.kani@hp.com,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        hegdevasant@linux.vnet.ibm.com, peterz@infradead.org,
        mpe@ellerman.id.au, robh+dt@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        grant.likely@linaro.org, paulus@samba.org, afleming@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, toshi.kani@hp.com,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, paul.gortmaker@windriver.com
In-Reply-To: <1397209481-28542-4-git-send-email-vincent.guittot@linaro.org>
References: <1397209481-28542-4-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, powerpc:
  Create a dedicated topology table
Git-Commit-ID: 607b45e9a216e89a63351556e488eea06be0ff48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  607b45e9a216e89a63351556e488eea06be0ff48
Gitweb:     http://git.kernel.org/tip/607b45e9a216e89a63351556e488eea06be0ff48
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Fri, 11 Apr 2014 11:44:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:51 +0200

sched, powerpc: Create a dedicated topology table

Create a dedicated topology table for handling asymetric feature of powerpc.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Fleming <afleming@freescale.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
Cc: schwidefsky@de.ibm.com
Cc: cmetcalf@tilera.com
Cc: dietmar.eggemann@arm.com
Cc: devicetree@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1397209481-28542-4-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/kernel/smp.c | 31 +++++++++++++++++++++++--------
 include/linux/sched.h     |  2 --
 kernel/sched/core.c       |  6 ------
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index e2a4232..10ffffe 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -766,6 +766,28 @@ int setup_profiling_timer(unsigned int multiplier)
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
@@ -790,15 +812,8 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
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
index 656b035..439a153 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -877,8 +877,6 @@ enum cpu_idle_type {
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
-extern int __weak arch_sd_sibiling_asym_packing(void);
-
 #ifdef CONFIG_SCHED_SMT
 static inline const int cpu_smt_flags(void)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e59e5ae..7e348e2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5796,11 +5796,6 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
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
@@ -5981,7 +5976,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	if (sd->flags & SD_SHARE_CPUPOWER) {
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
-		sd->flags |= arch_sd_sibling_asym_packing();
 
 	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
 		sd->imbalance_pct = 117;
