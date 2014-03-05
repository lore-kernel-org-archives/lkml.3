Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaCEHT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:19:29 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44003 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaCEHT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:19:26 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 6/6] sched: ARM: create a dedicated scheduler topology table
Date: Wed,  5 Mar 2014 15:18:26 +0800
Message-Id: <1394003906-11630-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dedicated topology table for ARM which will create new level to
differentiate CPUs that can or not powergate independantly from others.

The patch gives an example of how to add domain that will take advantage of
SD_SHARE_POWERDOMAIN.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 0bc94b1..ae8ffbc 100644
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
 
+static struct sched_domain_topology_level arm_topology[] = {
+#ifdef CONFIG_SCHED_MC
+	{ cpu_corepower_mask, SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN, SD_INIT_NAME(GMC) },
+	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(MC) },
+#endif
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
+static void __init set_sched_topology(void)
+{
+	sched_domain_topology = arm_topology;
+}
+
 /*
  * init_cpu_topology is called at boot when only one cpu is running
  * which prevent simultaneous write access to cpu_topology array
@@ -289,4 +312,7 @@ void __init init_cpu_topology(void)
 	smp_wmb();
 
 	parse_dt_topology();
+
+	/* Set scheduler topology descriptor */
+	set_sched_topology();
 }
-- 
1.7.9.5

