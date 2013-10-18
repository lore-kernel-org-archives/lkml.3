Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3JRLyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:07 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52098 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3JRLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:45 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for sched_domain init
Date: Fri, 18 Oct 2013 13:52:15 +0200
Message-Id: <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function arch_sd_local_flags is used to set flags in sched_domains
according to the platform architecture. A new flag SD_SHARE_POWERDOMAIN is
also created to reflect whether groups of CPUs in a sched_domain level can or
not reach different power state. As an example, the flag should be cleared at
CPU level if groups of cores can be power gated independently. This information
is used to decide if it's worth packing some tasks in a group of CPUs in order
to power gate the other groups instead of spreading the tasks. The default
behavior of the scheduler is to spread tasks across CPUs and groups of CPUs so
the flag is set into all sched_domains.

The cpu parameter of arch_sd_local_flags can be used by architecture to fine
tune the scheduler domain flags. As an example SD_SHARE_POWERDOMAIN flag can be
set differently for groups of CPUs according to DT information

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/ia64/include/asm/topology.h |    3 ++-
 arch/tile/include/asm/topology.h |    3 ++-
 include/linux/sched.h            |    1 +
 include/linux/topology.h         |   11 ++++++++---
 kernel/sched/core.c              |   10 ++++++++--
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..4844896 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -46,7 +46,7 @@
 
 void build_cpu_to_node_map(void);
 
-#define SD_CPU_INIT (struct sched_domain) {		\
+#define SD_CPU_INIT(cpu) (struct sched_domain) {	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
@@ -65,6 +65,7 @@ void build_cpu_to_node_map(void);
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE,	\
+				| arch_sd_local_flags(0, cpu)\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d15c0d8..6f7a97d 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -51,7 +51,7 @@ static inline const struct cpumask *cpumask_of_node(int node)
  */
 
 /* sched_domains SD_CPU_INIT for TILE architecture */
-#define SD_CPU_INIT (struct sched_domain) {				\
+#define SD_CPU_INIT(cpu) (struct sched_domain) {			\
 	.min_interval		= 4,					\
 	.max_interval		= 128,					\
 	.busy_factor		= 64,					\
@@ -71,6 +71,7 @@ static inline const struct cpumask *cpumask_of_node(int node)
 				| 0*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(0, cpu)		\
 				| 0*SD_SERIALIZE			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6682da3..2004cdb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -763,6 +763,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..f3cd3c2 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -85,7 +85,7 @@ int arch_update_cpu_topology(void);
 #define ARCH_HAS_SCHED_WAKE_IDLE
 /* Common values for SMT siblings */
 #ifndef SD_SIBLING_INIT
-#define SD_SIBLING_INIT (struct sched_domain) {				\
+#define SD_SIBLING_INIT(cpu) (struct sched_domain) {			\
 	.min_interval		= 1,					\
 	.max_interval		= 2,					\
 	.busy_factor		= 64,					\
@@ -99,6 +99,8 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(SD_SHARE_CPUPOWER|\
+					SD_SHARE_PKG_RESOURCES, cpu)	\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				| arch_sd_sibling_asym_packing()	\
@@ -113,7 +115,7 @@ int arch_update_cpu_topology(void);
 #ifdef CONFIG_SCHED_MC
 /* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
 #ifndef SD_MC_INIT
-#define SD_MC_INIT (struct sched_domain) {				\
+#define SD_MC_INIT(cpu) (struct sched_domain) {				\
 	.min_interval		= 1,					\
 	.max_interval		= 4,					\
 	.busy_factor		= 64,					\
@@ -131,6 +133,8 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(			\
+					SD_SHARE_PKG_RESOURCES, cpu)	\
 				| 0*SD_SERIALIZE			\
 				,					\
 	.last_balance		= jiffies,				\
@@ -141,7 +145,7 @@ int arch_update_cpu_topology(void);
 
 /* Common values for CPUs */
 #ifndef SD_CPU_INIT
-#define SD_CPU_INIT (struct sched_domain) {				\
+#define SD_CPU_INIT(cpu) (struct sched_domain) {			\
 	.min_interval		= 1,					\
 	.max_interval		= 4,					\
 	.busy_factor		= 64,					\
@@ -161,6 +165,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(0, cpu)		\
 				| 0*SD_SERIALIZE			\
 				| 1*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..735e964 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5460,6 +5460,11 @@ int __weak arch_sd_sibling_asym_packing(void)
        return 0*SD_ASYM_PACKING;
 }
 
+int __weak arch_sd_local_flags(int level, int cpu)
+{
+	return 1*SD_SHARE_POWERDOMAIN;
+}
+
 /*
  * Initializers for schedule domains
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
@@ -5473,10 +5478,10 @@ int __weak arch_sd_sibling_asym_packing(void)
 
 #define SD_INIT_FUNC(type)						\
 static noinline struct sched_domain *					\
-sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
+sd_init_##type(struct sched_domain_topology_level *tl, int cpu)		\
 {									\
 	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
-	*sd = SD_##type##_INIT;						\
+	*sd = SD_##type##_INIT(cpu);					\
 	SD_INIT_NAME(sd, type);						\
 	sd->private = &tl->data;					\
 	return sd;							\
@@ -5652,6 +5657,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_WAKE_AFFINE
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
+					| 1*SD_SHARE_POWERDOMAIN
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
 					| sd_local_flags(level)
-- 
1.7.9.5

