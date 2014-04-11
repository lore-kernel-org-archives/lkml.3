Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbaDKJro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:47:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54867 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbaDKJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:46:09 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4 2/5] sched: s390: create a dedicated topology table
Date: Fri, 11 Apr 2014 11:44:38 +0200
Message-Id: <1397209481-28542-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BOOK level is only relevant for s390 so we create a dedicated topology table
with BOOK level and remove it from default table.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/s390/include/asm/topology.h | 11 +----------
 arch/s390/kernel/topology.c      | 20 ++++++++++++++++++++
 kernel/sched/core.c              |  3 ---
 3 files changed, 21 insertions(+), 13 deletions(-)

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
index 4b2e3e3..ceddd77 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -443,6 +443,23 @@ int topology_cpu_init(struct cpu *cpu)
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
+	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
 static int __init topology_init(void)
 {
 	if (!MACHINE_HAS_TOPOLOGY) {
@@ -452,6 +469,9 @@ static int __init topology_init(void)
 	set_topology_timer();
 out:
 	update_cpu_masks();
+
+	set_sched_topology(s390_topology);
+
 	return device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
 }
 device_initcall(topology_init);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0714574..b15b994 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6058,9 +6058,6 @@ static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_SCHED_MC
 	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
 #endif
-#ifdef CONFIG_SCHED_BOOK
-	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
-#endif
 	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
 	{ NULL, },
 };
-- 
1.9.1

