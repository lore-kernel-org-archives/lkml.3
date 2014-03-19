Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbaCSQYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:24:24 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42642 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbaCSQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:24:17 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 5/6] sched: ARM: create a dedicated scheduler topology table
Date: Wed, 19 Mar 2014 17:22:44 +0100
Message-Id: <1395246165-31150-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
References: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dedicated topology table for ARM which will create new level to
differentiate CPUs that can or not powergate independantly from others.

The patch gives an example of how to add domain that will take advantage of
SD_SHARE_POWERDOMAIN.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 0bc94b1..71e1fec 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -185,6 +185,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	return &cpu_topology[cpu].core_sibling;
 }
 
+/*
+ * The current assumption is that we can power gate each core independently.
+ * This will be superseded by DT binding once available.
+ */
+const struct cpumask *cpu_corepower_mask(int cpu)
+{
+	return &cpu_topology[cpu].thread_sibling;
+}
+
 static void update_siblings_masks(unsigned int cpuid)
 {
 	struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
@@ -266,6 +275,20 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].socket_id, mpidr);
 }
 
+static inline const int cpu_corepower_flags(void)
+{
+	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
+}
+
+static struct sched_domain_topology_level arm_topology[] = {
+#ifdef CONFIG_SCHED_MC
+	{ cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
+	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+#endif
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
 /*
  * init_cpu_topology is called at boot when only one cpu is running
  * which prevent simultaneous write access to cpu_topology array
@@ -289,4 +312,7 @@ void __init init_cpu_topology(void)
 	smp_wmb();
 
 	parse_dt_topology();
+
+	/* Set scheduler topology descriptor */
+	set_sched_topology(arm_topology);
 }
-- 
1.9.0

