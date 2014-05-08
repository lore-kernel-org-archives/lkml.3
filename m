Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaEHKou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:44:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaEHKos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:44:48 -0400
Date: Thu, 8 May 2014 03:43:44 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-2dfd747629e65f89d2dbceb92fffc763f66228b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        peterz@infradead.org, phacht@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, phacht@linux.vnet.ibm.com,
        heiko.carstens@de.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de
In-Reply-To: <1397209481-28542-3-git-send-email-vincent.guittot@linaro.org>
References: <1397209481-28542-3-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, s390: Create a dedicated topology table
Git-Commit-ID: 2dfd747629e65f89d2dbceb92fffc763f66228b2
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

Commit-ID:  2dfd747629e65f89d2dbceb92fffc763f66228b2
Gitweb:     http://git.kernel.org/tip/2dfd747629e65f89d2dbceb92fffc763f66228b2
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Fri, 11 Apr 2014 11:44:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:50 +0200

sched, s390: Create a dedicated topology table

BOOK level is only relevant for s390 so we create a dedicated topology table
with BOOK level and remove it from default table.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: cmetcalf@tilera.com
Cc: benh@kernel.crashing.org
Cc: dietmar.eggemann@arm.com
Cc: preeti@linux.vnet.ibm.com
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Link: http://lkml.kernel.org/r/1397209481-28542-3-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 6298fed..1860ad3 100644
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
@@ -451,6 +468,9 @@ static int __init topology_init(void)
 	}
 	set_topology_timer();
 out:
+
+	set_sched_topology(s390_topology);
+
 	return device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
 }
 device_initcall(topology_init);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7d332b7..e59e5ae 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6024,9 +6024,6 @@ static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_SCHED_MC
 	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
 #endif
-#ifdef CONFIG_SCHED_BOOK
-	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
-#endif
 	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
 	{ NULL, },
 };
