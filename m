Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3CVMbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:31:14 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64872 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab3CVM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:29:37 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v3 2/6] sched: add a new SD_SHARE_POWERDOMAIN flag for sched_domain
Date: Fri, 22 Mar 2013 13:25:51 +0100
Message-Id: <1363955155-18382-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new flag SD_SHARE_POWERDOMAIN is used to reflect whether groups of CPUs
in a sched_domain level can or not reach a different power state. If groups of
cores can be power gated independently, as an example, the flag should be
cleared at CPU level. This information is used to decide if it's worth packing
some tasks in a group of CPUs in order to power gated the other groups instead
of spreading the tasks. The default behavior of the scheduler is to spread
tasks so the flag is set into all sched_domains.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/ia64/include/asm/topology.h |    1 +
 arch/tile/include/asm/topology.h |    1 +
 include/linux/sched.h            |    1 +
 include/linux/topology.h         |    4 ++++
 kernel/sched/core.c              |    6 ++++++
 5 files changed, 13 insertions(+)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..6d0b617 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -65,6 +65,7 @@ void build_cpu_to_node_map(void);
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE,	\
+				| arch_sd_local_flags(0)\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d5e86c9..adc87102 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -71,6 +71,7 @@ static inline const struct cpumask *cpumask_of_node(int node)
 				| 0*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(0)		\
 				| 0*SD_SERIALIZE			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16b0d18..a82cdeb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -809,6 +809,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..3eab293 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,6 +99,8 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(SD_SHARE_CPUPOWER|\
+						SD_SHARE_PKG_RESOURCES) \
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				| arch_sd_sibling_asym_packing()	\
@@ -131,6 +133,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(SD_SHARE_PKG_RESOURCES)\
 				| 0*SD_SERIALIZE			\
 				,					\
 	.last_balance		= jiffies,				\
@@ -161,6 +164,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
+				| arch_sd_local_flags(0)		\
 				| 0*SD_SERIALIZE			\
 				| 1*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 54eaaa2..b827e0c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5938,6 +5938,11 @@ int __weak arch_sd_sibling_asym_packing(void)
        return 0*SD_ASYM_PACKING;
 }
 
+int __weak arch_sd_local_flags(int level)
+{
+	return 1*SD_SHARE_POWERDOMAIN;
+}
+
 /*
  * Initializers for schedule domains
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
@@ -6127,6 +6132,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_WAKE_AFFINE
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
+					| 1*SD_SHARE_POWERDOMAIN
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
 					| sd_local_flags(level)
-- 
1.7.9.5

