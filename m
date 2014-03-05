Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaCEHTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:19:16 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51571 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaCEHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:19:13 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 3/6] sched: s390: create a dedicated topology table
Date: Wed,  5 Mar 2014 15:18:23 +0800
Message-Id: <1394003906-11630-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BOOK level is only relevant for s390 so we create a dedicated topology table
with BOOK level and remove it from default table.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/s390/include/asm/topology.h |   11 +----------
 arch/s390/kernel/topology.c      |   25 +++++++++++++++++++++++++
 kernel/sched/core.c              |    3 ---
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 07763bd..56af530 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -26,21 +26,12 @@ extern struct cpu_topology_s390 cpu_topology[NR_CPUS];
 
 #define mc_capable() 1
 
-static inline const struct cpumask *cpu_coregroup_mask(int cpu)
-{
-	return &cpu_topology[cpu].core_mask;
-}
-
-static inline const struct cpumask *cpu_book_mask(int cpu)
-{
-	return &cpu_topology[cpu].book_mask;
-}
-
 int topology_cpu_init(struct cpu *);
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);
 void store_topology(struct sysinfo_15_1_x *info);
 void topology_expect_change(void);
+const struct cpumask *cpu_coregroup_mask(int cpu);
 
 #else /* CONFIG_SCHED_BOOK */
 
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 4b2e3e3..8a7ac47 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -443,6 +443,28 @@ int topology_cpu_init(struct cpu *cpu)
 	return sysfs_create_group(&cpu->dev.kobj, &topology_cpu_attr_group);
 }
 
+const struct cpumask *cpu_coregroup_mask(int cpu)
+{
+	return &cpu_topology[cpu].core_mask;
+}
+
+static const struct cpumask *cpu_book_mask(int cpu)
+{
+	return &cpu_topology[cpu].book_mask;
+}
+
+static struct sched_domain_topology_level s390_topology[] = {
+	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(MC) },
+	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
+static void __init set_sched_topology(void)
+{
+	sched_domain_topology = s390_topology;
+}
+
 static int __init topology_init(void)
 {
 	if (!MACHINE_HAS_TOPOLOGY) {
@@ -452,6 +474,9 @@ static int __init topology_init(void)
 	set_topology_timer();
 out:
 	update_cpu_masks();
+
+	set_sched_topology();
+
 	return device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
 }
 device_initcall(topology_init);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6f6a8f0..3479467 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6043,9 +6043,6 @@ static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_SCHED_MC
 	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(MC) },
 #endif
-#ifdef CONFIG_SCHED_BOOK
-	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
-#endif
 	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
 	{ NULL, },
 };
-- 
1.7.9.5

