Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaKGQ1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:02 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48294 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbaKGQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:00 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 03/11] arm: perf: treat PMUs as CPU affine
Date: Fri,  7 Nov 2014 16:25:28 +0000
Message-Id: <1415377536-12841-4-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multi-cluster systems, the PMUs can be different across clusters, and
so our logical PMU may not be able to schedule events on all CPUs.

This patch adds a cpumask to encode which CPUs a PMU driver supports
controlling events for, and limits the driver to scheduling events on
those CPUs, and enabling and disabling the physical PMUs on those CPUs.
Currently the cpumask is set to match all CPUs.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/include/asm/pmu.h       |  1 +
 arch/arm/kernel/perf_event.c     | 25 +++++++++++++++++++++++++
 arch/arm/kernel/perf_event_cpu.c | 10 +++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index b1596bd..b630a44 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -92,6 +92,7 @@ struct pmu_hw_events {
 struct arm_pmu {
 	struct pmu	pmu;
 	cpumask_t	active_irqs;
+	cpumask_t	supported_cpus;
 	char		*name;
 	irqreturn_t	(*handle_irq)(int irq_num, void *dev);
 	void		(*enable)(struct perf_event *event);
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index e34934f..9ad21ab 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -11,6 +11,7 @@
  */
 #define pr_fmt(fmt) "hw perfevents: " fmt
 
+#include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -223,6 +224,10 @@ armpmu_add(struct perf_event *event, int flags)
 	int idx;
 	int err = 0;
 
+	/* An event following a process won't be stopped earlier */
+	if (!cpumask_test_cpu(smp_processor_id(), &armpmu->supported_cpus))
+		return -ENOENT;
+
 	perf_pmu_disable(event->pmu);
 
 	/* If we don't have a space for the counter then finish early. */
@@ -439,6 +444,17 @@ static int armpmu_event_init(struct perf_event *event)
 	int err = 0;
 	atomic_t *active_events = &armpmu->active_events;
 
+	/*
+	 * Reject CPU-affine events for CPUs that are of a different class to
+	 * that which this PMU handles. Process-following events (where
+	 * event->cpu == -1) can be migrated between CPUs, and thus we have to
+	 * reject them later (in armpmu_add) if they're scheduled on a
+	 * different class of CPU.
+	 */
+	if (event->cpu != -1 &&
+		!cpumask_test_cpu(event->cpu, &armpmu->supported_cpus))
+		return -ENOENT;
+
 	/* does not support taken branch sampling */
 	if (has_branch_stack(event))
 		return -EOPNOTSUPP;
@@ -474,6 +490,10 @@ static void armpmu_enable(struct pmu *pmu)
 	struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
 	int enabled = bitmap_weight(hw_events->used_mask, armpmu->num_events);
 
+	/* For task-bound events we may be called on other CPUs */
+	if (!cpumask_test_cpu(smp_processor_id(), &armpmu->supported_cpus))
+		return;
+
 	if (enabled)
 		armpmu->start(armpmu);
 }
@@ -481,6 +501,11 @@ static void armpmu_enable(struct pmu *pmu)
 static void armpmu_disable(struct pmu *pmu)
 {
 	struct arm_pmu *armpmu = to_arm_pmu(pmu);
+
+	/* For task-bound events we may be called on other CPUs */
+	if (!cpumask_test_cpu(smp_processor_id(), &armpmu->supported_cpus))
+		return;
+
 	armpmu->stop(armpmu);
 }
 
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 59c0642..ce35149 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -169,11 +169,15 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 static int cpu_pmu_notify(struct notifier_block *b, unsigned long action,
 			  void *hcpu)
 {
+	int cpu = (unsigned long)hcpu;
 	struct arm_pmu *pmu = container_of(b, struct arm_pmu, hotplug_nb);
 
 	if ((action & ~CPU_TASKS_FROZEN) != CPU_STARTING)
 		return NOTIFY_DONE;
 
+	if (!cpumask_test_cpu(cpu, &pmu->supported_cpus))
+		return NOTIFY_DONE;
+
 	if (pmu->reset)
 		pmu->reset(pmu);
 	else
@@ -209,7 +213,8 @@ static int cpu_pmu_init(struct arm_pmu *cpu_pmu)
 
 	/* Ensure the PMU has sane values out of reset. */
 	if (cpu_pmu->reset)
-		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+		on_each_cpu_mask(&cpu_pmu->supported_cpus, cpu_pmu->reset,
+			 cpu_pmu, 1);
 
 	/* If no interrupts available, set the corresponding capability flag */
 	if (!platform_get_irq(cpu_pmu->plat_device, 0))
@@ -311,6 +316,9 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 	cpu_pmu = pmu;
 	cpu_pmu->plat_device = pdev;
 
+	/* Assume by default that we're on a homogeneous system */
+	cpumask_setall(&pmu->supported_cpus);
+
 	if (node && (of_id = of_match_node(cpu_pmu_of_device_ids, pdev->dev.of_node))) {
 		init_fn = of_id->data;
 		ret = init_fn(pmu);
-- 
1.9.1

