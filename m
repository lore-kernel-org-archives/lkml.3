Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaAORzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:55:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44879 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaAORzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/7] ARM: perf_event: Support percpu irqs for the CPU PMU
Date: Wed, 15 Jan 2014 09:55:29 -0800
Message-Id: <1389808535-23852-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPU PMUs are wired up with one PPI for all the CPUs instead
of with a different SPI for each CPU. Add support for these
devices.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/perf_event.c     | 14 ++++--
 arch/arm/kernel/perf_event_cpu.c | 97 ++++++++++++++++++++++++++++------------
 2 files changed, 80 insertions(+), 31 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 789d846a9184..e76750980b38 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -16,6 +16,8 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/uaccess.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 
 #include <asm/irq_regs.h>
 #include <asm/pmu.h>
@@ -295,9 +297,15 @@ validate_group(struct perf_event *event)
 
 static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
 {
-	struct arm_pmu *armpmu = (struct arm_pmu *) dev;
-	struct platform_device *plat_device = armpmu->plat_device;
-	struct arm_pmu_platdata *plat = dev_get_platdata(&plat_device->dev);
+	struct arm_pmu *armpmu;
+	struct platform_device *plat_device;
+	struct arm_pmu_platdata *plat;
+
+	if (irq_is_percpu(irq))
+		dev = *(struct arm_pmu_cpu **)dev;
+	armpmu = dev;
+	plat_device = armpmu->plat_device;
+	plat = dev_get_platdata(&plat_device->dev);
 
 	if (plat && plat->handle_irq)
 		return plat->handle_irq(irq, dev, armpmu->handle_irq);
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 20d553c9f5e2..6efd8aab15df 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -25,6 +25,8 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 
 #include <asm/cputype.h>
 #include <asm/irq_regs.h>
@@ -33,6 +35,7 @@
 /* Set at runtime when we know what CPU type we are. */
 static struct arm_pmu *cpu_pmu;
 
+static DEFINE_PER_CPU(struct arm_pmu *, percpu_pmu);
 static DEFINE_PER_CPU(struct perf_event * [ARMPMU_MAX_HWEVENTS], hw_events);
 static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(ARMPMU_MAX_HWEVENTS)], used_mask);
 static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
@@ -71,6 +74,26 @@ static struct pmu_hw_events *cpu_pmu_get_cpu_events(void)
 	return this_cpu_ptr(&cpu_hw_events);
 }
 
+static void cpu_pmu_enable_percpu_irq(void *data)
+{
+	struct arm_pmu *cpu_pmu = data;
+	struct platform_device *pmu_device = cpu_pmu->plat_device;
+	int irq = platform_get_irq(pmu_device, 0);
+
+	enable_percpu_irq(irq, IRQ_TYPE_NONE);
+	cpumask_set_cpu(smp_processor_id(), &cpu_pmu->active_irqs);
+}
+
+static void cpu_pmu_disable_percpu_irq(void *data)
+{
+	struct arm_pmu *cpu_pmu = data;
+	struct platform_device *pmu_device = cpu_pmu->plat_device;
+	int irq = platform_get_irq(pmu_device, 0);
+
+	cpumask_clear_cpu(smp_processor_id(), &cpu_pmu->active_irqs);
+	disable_percpu_irq(irq);
+}
+
 static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 {
 	int i, irq, irqs;
@@ -78,12 +101,18 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 
-	for (i = 0; i < irqs; ++i) {
-		if (!cpumask_test_and_clear_cpu(i, &cpu_pmu->active_irqs))
-			continue;
-		irq = platform_get_irq(pmu_device, i);
-		if (irq >= 0)
-			free_irq(irq, cpu_pmu);
+	irq = platform_get_irq(pmu_device, 0);
+	if (irq >= 0 && irq_is_percpu(irq)) {
+		on_each_cpu(cpu_pmu_disable_percpu_irq, cpu_pmu, 1);
+		free_percpu_irq(irq, &percpu_pmu);
+	} else {
+		for (i = 0; i < irqs; ++i) {
+			if (!cpumask_test_and_clear_cpu(i, &cpu_pmu->active_irqs))
+				continue;
+			irq = platform_get_irq(pmu_device, i);
+			if (irq >= 0)
+				free_irq(irq, cpu_pmu);
+		}
 	}
 }
 
@@ -101,33 +130,44 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < irqs; ++i) {
-		err = 0;
-		irq = platform_get_irq(pmu_device, i);
-		if (irq < 0)
-			continue;
-
-		/*
-		 * If we have a single PMU interrupt that we can't shift,
-		 * assume that we're running on a uniprocessor machine and
-		 * continue. Otherwise, continue without this interrupt.
-		 */
-		if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
-			pr_warning("unable to set irq affinity (irq=%d, cpu=%u)\n",
-				    irq, i);
-			continue;
-		}
-
-		err = request_irq(irq, handler,
-				  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
-				  cpu_pmu);
+	irq = platform_get_irq(pmu_device, 0);
+	if (irq >= 0 && irq_is_percpu(irq)) {
+		err = request_percpu_irq(irq, handler, "arm-pmu", &percpu_pmu);
 		if (err) {
 			pr_err("unable to request IRQ%d for ARM PMU counters\n",
 				irq);
 			return err;
 		}
-
-		cpumask_set_cpu(i, &cpu_pmu->active_irqs);
+		on_each_cpu(cpu_pmu_enable_percpu_irq, cpu_pmu, 1);
+	} else {
+		for (i = 0; i < irqs; ++i) {
+			err = 0;
+			irq = platform_get_irq(pmu_device, i);
+			if (irq < 0)
+				continue;
+
+			/*
+			 * If we have a single PMU interrupt that we can't shift,
+			 * assume that we're running on a uniprocessor machine and
+			 * continue. Otherwise, continue without this interrupt.
+			 */
+			if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
+				pr_warning("unable to set irq affinity (irq=%d, cpu=%u)\n",
+					    irq, i);
+				continue;
+			}
+
+			err = request_irq(irq, handler,
+					  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
+					  cpu_pmu);
+			if (err) {
+				pr_err("unable to request IRQ%d for ARM PMU counters\n",
+					irq);
+				return err;
+			}
+
+			cpumask_set_cpu(i, &cpu_pmu->active_irqs);
+		}
 	}
 
 	return 0;
@@ -141,6 +181,7 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 		events->events = per_cpu(hw_events, cpu);
 		events->used_mask = per_cpu(used_mask, cpu);
 		raw_spin_lock_init(&events->pmu_lock);
+		per_cpu(percpu_pmu, cpu) = cpu_pmu;
 	}
 
 	cpu_pmu->get_hw_events	= cpu_pmu_get_cpu_events;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

