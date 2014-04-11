Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaDKLCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:02:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9939 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbaDKLCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:02:04 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <will.deacon@arm.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] ARM: perf: save/restore pmu registers in pm notifier
Date: Fri, 11 Apr 2014 19:01:23 +0800
Message-ID: <1397214083-30916-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_03:2014-04-11,2014-04-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404110180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This adds core support for saving and restoring CPU PMU registers
for suspend/resume support i.e. deeper C-states in cpuidle terms.
This patch adds support only to ARMv7 PMU registers save/restore.
It needs to be extended to xscale and ARMv6 if needed.

[Neil] We found that DS-5 not work on our CA7 based SoCs.
After debuging, found PMU registers were lost because of core power down.
Then i found Sudeep had a patch to fix it about two years ago but not in
the mainline, just port it.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm/include/asm/pmu.h       |   11 +++++++++
 arch/arm/kernel/perf_event_cpu.c |   30 +++++++++++++++++++++++-
 arch/arm/kernel/perf_event_v7.c  |   47 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index ae1919b..f37f048 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -62,6 +62,15 @@ struct pmu_hw_events {
 	raw_spinlock_t		pmu_lock;
 };
 
+struct cpupmu_regs {
+	u32 pmc;
+	u32 pmcntenset;
+	u32 pmuseren;
+	u32 pmintenset;
+	u32 pmxevttype[8];
+	u32 pmxevtcnt[8];
+};
+
 struct arm_pmu {
 	struct pmu	pmu;
 	cpumask_t	active_irqs;
@@ -83,6 +92,8 @@ struct arm_pmu {
 	int		(*request_irq)(struct arm_pmu *, irq_handler_t handler);
 	void		(*free_irq)(struct arm_pmu *);
 	int		(*map_event)(struct perf_event *event);
+	void		(*save_regs)(struct arm_pmu *, struct cpupmu_regs *);
+	void		(*restore_regs)(struct arm_pmu *, struct cpupmu_regs *);
 	int		num_events;
 	atomic_t	active_events;
 	struct mutex	reserve_mutex;
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 51798d7..934f49b 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -19,6 +19,7 @@
 #define pr_fmt(fmt) "CPU PMU: " fmt
 
 #include <linux/bitmap.h>
+#include <linux/cpu_pm.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
@@ -39,6 +40,7 @@ static DEFINE_PER_CPU(struct arm_pmu *, percpu_pmu);
 static DEFINE_PER_CPU(struct perf_event * [ARMPMU_MAX_HWEVENTS], hw_events);
 static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(ARMPMU_MAX_HWEVENTS)], used_mask);
 static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
+static DEFINE_PER_CPU(struct cpupmu_regs, cpu_pmu_regs);
 
 /*
  * Despite the names, these two functions are CPU-specific and are used
@@ -217,6 +219,24 @@ static struct notifier_block cpu_pmu_hotplug_notifier = {
 	.notifier_call = cpu_pmu_notify,
 };
 
+static int cpu_pmu_pm_notify(struct notifier_block *b,
+					unsigned long action, void *hcpu)
+{
+	int cpu = smp_processor_id();
+	struct cpupmu_regs *pmuregs = &per_cpu(cpu_pmu_regs, cpu);
+
+	if (action == CPU_PM_ENTER && cpu_pmu->save_regs)
+		cpu_pmu->save_regs(cpu_pmu, pmuregs);
+	else if (action == CPU_PM_EXIT && cpu_pmu->restore_regs)
+		cpu_pmu->restore_regs(cpu_pmu, pmuregs);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_pmu_pm_notifier = {
+	.notifier_call = cpu_pmu_pm_notify,
+};
+
 /*
  * PMU platform driver and devicetree bindings.
  */
@@ -349,9 +369,17 @@ static int __init register_pmu_driver(void)
 	if (err)
 		return err;
 
+	err = cpu_pm_register_notifier(&cpu_pmu_pm_notifier);
+	if (err) {
+		unregister_cpu_notifier(&cpu_pmu_hotplug_notifier);
+		return err;
+	}
+
 	err = platform_driver_register(&cpu_pmu_driver);
-	if (err)
+	if (err) {
+		cpu_pm_unregister_notifier(&cpu_pmu_pm_notifier);
 		unregister_cpu_notifier(&cpu_pmu_hotplug_notifier);
+	}
 
 	return err;
 }
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index f4ef398..29ae8f1 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -1237,6 +1237,51 @@ static void armv7_pmnc_dump_regs(struct arm_pmu *cpu_pmu)
 }
 #endif
 
+static void armv7pmu_save_regs(struct arm_pmu *cpu_pmu,
+					struct cpupmu_regs *regs)
+{
+	unsigned int cnt;
+	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (regs->pmc));
+	if (!(regs->pmc & ARMV7_PMNC_E))
+		return;
+
+	asm volatile("mrc p15, 0, %0, c9, c12, 1" : "=r" (regs->pmcntenset));
+	asm volatile("mrc p15, 0, %0, c9, c14, 0" : "=r" (regs->pmuseren));
+	asm volatile("mrc p15, 0, %0, c9, c14, 1" : "=r" (regs->pmintenset));
+	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (regs->pmxevtcnt[0]));
+	for (cnt = ARMV7_IDX_COUNTER0;
+			cnt <= ARMV7_IDX_COUNTER_LAST(cpu_pmu); cnt++) {
+		armv7_pmnc_select_counter(cnt);
+		asm volatile("mrc p15, 0, %0, c9, c13, 1"
+					: "=r"(regs->pmxevttype[cnt]));
+		asm volatile("mrc p15, 0, %0, c9, c13, 2"
+					: "=r"(regs->pmxevtcnt[cnt]));
+	}
+	return;
+}
+
+static void armv7pmu_restore_regs(struct arm_pmu *cpu_pmu,
+					struct cpupmu_regs *regs)
+{
+	unsigned int cnt;
+	if (!(regs->pmc & ARMV7_PMNC_E))
+		return;
+
+	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (regs->pmcntenset));
+	asm volatile("mcr p15, 0, %0, c9, c14, 0" : : "r" (regs->pmuseren));
+	asm volatile("mcr p15, 0, %0, c9, c14, 1" : : "r" (regs->pmintenset));
+	asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (regs->pmxevtcnt[0]));
+	for (cnt = ARMV7_IDX_COUNTER0;
+			cnt <= ARMV7_IDX_COUNTER_LAST(cpu_pmu); cnt++) {
+		armv7_pmnc_select_counter(cnt);
+		asm volatile("mcr p15, 0, %0, c9, c13, 1"
+					: : "r"(regs->pmxevttype[cnt]));
+		asm volatile("mcr p15, 0, %0, c9, c13, 2"
+					: : "r"(regs->pmxevtcnt[cnt]));
+	}
+	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (regs->pmc));
+}
+
 static void armv7pmu_enable_event(struct perf_event *event)
 {
 	unsigned long flags;
@@ -1528,6 +1573,8 @@ static void armv7pmu_init(struct arm_pmu *cpu_pmu)
 	cpu_pmu->start		= armv7pmu_start;
 	cpu_pmu->stop		= armv7pmu_stop;
 	cpu_pmu->reset		= armv7pmu_reset;
+	cpu_pmu->save_regs	= armv7pmu_save_regs;
+	cpu_pmu->restore_regs	= armv7pmu_restore_regs;
 	cpu_pmu->max_period	= (1LLU << 32) - 1;
 };
 
-- 
1.7.9.5

