Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaKGQ1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48323 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbaKGQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:29 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 09/11] arm: perf: parse cpu affinity from dt
Date: Fri,  7 Nov 2014 16:25:34 +0000
Message-Id: <1415377536-12841-10-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current way we read interrupts form devicetree assumes that
interrupts are in increasing order of logical cpu id (MPIDR.Aff{2,1,0}),
and that these logical ids are in a contiguous block. This may not be
the case in general - after a kexec cpu ids may be arbitrarily assigned,
and multi-cluster systems do not have a contiguous range of cpu ids.

This patch parses cpu affinity information for interrupts from an
optional "interrupts-affinity" devicetree property described in the
devicetree binding document. Support for existing dts and board files
remains.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/include/asm/pmu.h       |  12 +++
 arch/arm/kernel/perf_event_cpu.c | 196 +++++++++++++++++++++++++++++----------
 2 files changed, 161 insertions(+), 47 deletions(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index b630a44..92fc1da 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -12,6 +12,7 @@
 #ifndef __ARM_PMU_H__
 #define __ARM_PMU_H__
 
+#include <linux/cpumask.h>
 #include <linux/interrupt.h>
 #include <linux/perf_event.h>
 
@@ -89,6 +90,15 @@ struct pmu_hw_events {
 	struct arm_pmu		*percpu_pmu;
 };
 
+/*
+ * For systems with heterogeneous PMUs, we need to know which CPUs each
+ * (possibly percpu) IRQ targets. Map between them with an array of these.
+ */
+struct cpu_irq {
+	cpumask_t cpus;
+	int irq;
+};
+
 struct arm_pmu {
 	struct pmu	pmu;
 	cpumask_t	active_irqs;
@@ -118,6 +128,8 @@ struct arm_pmu {
 	struct platform_device	*plat_device;
 	struct pmu_hw_events	__percpu *hw_events;
 	struct notifier_block	hotplug_nb;
+	int		nr_irqs;
+	struct cpu_irq *irq_map;
 };
 
 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index dfcaba5..f09c8a0 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -85,20 +85,27 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 	struct platform_device *pmu_device = cpu_pmu->plat_device;
 	struct pmu_hw_events __percpu *hw_events = cpu_pmu->hw_events;
 
-	irqs = min(pmu_device->num_resources, num_possible_cpus());
+	irqs = cpu_pmu->nr_irqs;
 
-	irq = platform_get_irq(pmu_device, 0);
-	if (irq >= 0 && irq_is_percpu(irq)) {
-		on_each_cpu(cpu_pmu_disable_percpu_irq, &irq, 1);
-		free_percpu_irq(irq, &hw_events->percpu_pmu);
-	} else {
-		for (i = 0; i < irqs; ++i) {
-			if (!cpumask_test_and_clear_cpu(i, &cpu_pmu->active_irqs))
-				continue;
-			irq = platform_get_irq(pmu_device, i);
-			if (irq >= 0)
-				free_irq(irq, per_cpu_ptr(&hw_events->percpu_pmu, i));
+	for (i = 0; i < irqs; i++) {
+		struct cpu_irq *map = &cpu_pmu->irq_map[i];
+		irq = map->irq;
+
+		if (irq <= 0)
+			continue;
+
+		if (irq_is_percpu(irq)) {
+			on_each_cpu(cpu_pmu_disable_percpu_irq, &irq, 1);
+			free_percpu_irq(irq, &hw_events->percpu_pmu);
+			return;
 		}
+
+		if (!cpumask_test_and_clear_cpu(i, &cpu_pmu->active_irqs))
+			continue;
+
+		irq = platform_get_irq(pmu_device, i);
+		if (irq >= 0)
+			free_irq(irq, per_cpu_ptr(&hw_events->percpu_pmu, i));
 	}
 }
 
@@ -111,51 +118,52 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 	if (!pmu_device)
 		return -ENODEV;
 
-	irqs = min(pmu_device->num_resources, num_possible_cpus());
+	irqs = cpu_pmu->nr_irqs;
 	if (irqs < 1) {
 		printk_once("perf/ARM: No irqs for PMU defined, sampling events not supported\n");
 		return 0;
 	}
 
-	irq = platform_get_irq(pmu_device, 0);
-	if (irq >= 0 && irq_is_percpu(irq)) {
-		err = request_percpu_irq(irq, handler, "arm-pmu",
-					 &hw_events->percpu_pmu);
-		if (err) {
-			pr_err("unable to request IRQ%d for ARM PMU counters\n",
-				irq);
-			return err;
-		}
-		on_each_cpu(cpu_pmu_enable_percpu_irq, &irq, 1);
-	} else {
-		for (i = 0; i < irqs; ++i) {
-			err = 0;
-			irq = platform_get_irq(pmu_device, i);
-			if (irq < 0)
-				continue;
-
-			/*
-			 * If we have a single PMU interrupt that we can't shift,
-			 * assume that we're running on a uniprocessor machine and
-			 * continue. Otherwise, continue without this interrupt.
-			 */
-			if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
-				pr_warn("unable to set irq affinity (irq=%d, cpu=%u)\n",
-					irq, i);
-				continue;
-			}
+	for (i = 0; i < irqs; i++) {
+		struct cpu_irq *map = &cpu_pmu->irq_map[i];
+		irq = map->irq;
 
-			err = request_irq(irq, handler,
-					  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
-					  per_cpu_ptr(&hw_events->percpu_pmu, i));
+		if (irq <= 0)
+			continue;
+
+		if (irq_is_percpu(map->irq)) {
+			err = request_percpu_irq(irq, handler, "arm-pmu",
+						 &hw_events->percpu_pmu);
 			if (err) {
 				pr_err("unable to request IRQ%d for ARM PMU counters\n",
 					irq);
 				return err;
 			}
+			on_each_cpu(cpu_pmu_enable_percpu_irq, &irq, 1);
+			return 0;
+		}
+
+		/*
+		 * If we have a single PMU interrupt that we can't shift,
+		 * assume that we're running on a uniprocessor machine and
+		 * continue. Otherwise, continue without this interrupt.
+		 */
+		if (irq_set_affinity(irq, &map->cpus) && irqs > 1) {
+			pr_warn("unable to set irq affinity (irq=%d, cpu=%u)\n",
+				irq, cpumask_first(&map->cpus));
+			continue;
+		}
 
-			cpumask_set_cpu(i, &cpu_pmu->active_irqs);
+		err = request_irq(irq, handler,
+				  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
+				  per_cpu_ptr(&hw_events->percpu_pmu, i));
+		if (err) {
+			pr_err("unable to request IRQ%d for ARM PMU counters\n",
+				irq);
+			return err;
 		}
+
+		cpumask_set_cpu(i, &cpu_pmu->active_irqs);
 	}
 
 	return 0;
@@ -421,6 +429,97 @@ static int arm_dt_affine_get_mask(struct device_node *node, char *prop,
 	return ret;
 }
 
+static int cpu_pmu_parse_interrupt(struct arm_pmu *pmu, int idx)
+{
+	struct cpu_irq *map = &pmu->irq_map[idx];
+	struct platform_device *pdev = pmu->plat_device;
+	struct device_node *np = pdev->dev.of_node;
+
+	map->irq = platform_get_irq(pdev, idx);
+	if (map->irq <= 0)
+		return -ENOENT;
+
+	cpumask_clear(&map->cpus);
+
+	if (!of_property_read_bool(np, "interrupts-affinity")) {
+		/*
+		 * If we don't have any affinity information, assume a
+		 * homogeneous system. We assume that CPUs are ordered as in
+		 * the DT, even in the absence of affinity information.
+		 */
+		if (irq_is_percpu(map->irq))
+			cpumask_setall(&map->cpus);
+		else
+			cpumask_set_cpu(idx, &map->cpus);
+	} else {
+		return arm_dt_affine_get_mask(np, "interrupts-affinity", idx,
+					      &map->cpus);
+	}
+
+	return 0;
+}
+
+static int cpu_pmu_parse_interrupts(struct arm_pmu *pmu)
+{
+	struct platform_device *pdev = pmu->plat_device;
+	int ret;
+	int i, irqs;
+
+	/*
+	 * Figure out how many IRQs there are. This may be larger than NR_CPUS,
+	 * and this may be in any arbitrary order...
+	 */
+	for (irqs = 0; platform_get_irq(pdev, irqs) > 0; irqs++);
+	if (!irqs) {
+		pr_warn("Unable to find interrupts\n");
+		return -EINVAL;
+	}
+
+	pmu->nr_irqs = irqs;
+	pmu->irq_map = kmalloc_array(irqs, sizeof(*pmu->irq_map), GFP_KERNEL);
+	if (!pmu->irq_map) {
+		pr_warn("Unable to allocate irqmap data\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Some platforms are insane enough to mux all the PMU IRQs into a
+	 * single IRQ. To enable handling of those cases, assume that if we
+	 * have a single interrupt it targets all CPUs.
+	 */
+	if (irqs == 1 && num_possible_cpus() > 1) {
+		cpumask_copy(&pmu->irq_map[0].cpus, cpu_present_mask);
+	} else {
+		for (i = 0; i < irqs; i++) {
+			ret = cpu_pmu_parse_interrupt(pmu, i);
+			if (ret)
+				goto out_free;
+		}
+	}
+
+	if (of_property_read_bool(pdev->dev.of_node, "interrupts-affinity")) {
+		/* The PMU can work on any CPU it has an interrupt. */
+		for (i = 0; i < irqs; i++) {
+			struct cpu_irq *map = &pmu->irq_map[i];
+			cpumask_or(&pmu->supported_cpus, &pmu->supported_cpus,
+				   &map->cpus);
+		}
+	} else {
+		/*
+		 * Without affintiy info, assume a homogeneous system with
+		 * potentially missing interrupts, to keep existing DTBs
+		 * working.
+		 */
+		cpumask_setall(&pmu->supported_cpus);
+	}
+
+	return 0;
+
+out_free:
+	kfree(pmu->irq_map);
+	return ret;
+}
+
 static int cpu_pmu_device_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
@@ -443,8 +542,9 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 	cpu_pmu = pmu;
 	cpu_pmu->plat_device = pdev;
 
-	/* Assume by default that we're on a homogeneous system */
-	cpumask_setall(&pmu->supported_cpus);
+	ret = cpu_pmu_parse_interrupts(pmu);
+	if (ret)
+		goto out_free_pmu;
 
 	if (node && (of_id = of_match_node(cpu_pmu_of_device_ids, pdev->dev.of_node))) {
 		init_fn = of_id->data;
@@ -471,8 +571,10 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 out_destroy:
 	cpu_pmu_destroy(cpu_pmu);
 out_free:
-	pr_info("failed to register PMU devices!\n");
+	kfree(pmu->irq_map);
+out_free_pmu:
 	kfree(pmu);
+	pr_info("failed to register PMU devices!\n");
 	return ret;
 }
 
-- 
1.9.1

