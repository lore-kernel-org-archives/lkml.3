Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3KFMIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:08:31 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:53639 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756580Ab3KFMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:08:28 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        Vinayak Kale <vkale@apm.com>, Tuan Phan <tphan@apm.com>
Subject: [PATCH 2/2] arm64: perf: add support for percpu pmu interrupt
Date: Wed,  6 Nov 2013 17:37:37 +0530
Message-Id: <1383739658-10036-3-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383739658-10036-1-git-send-email-vkale@apm.com>
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for irq registration when pmu interrupt is percpu.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
---
 arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
 1 file changed, 81 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index cea1594..e60dae3 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -44,6 +44,7 @@
 static DEFINE_PER_CPU(struct perf_event * [ARMPMU_MAX_HWEVENTS], hw_events);
 static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(ARMPMU_MAX_HWEVENTS)], used_mask);
 static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
+static bool is_percpuirq;
 
 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
 
@@ -363,22 +364,51 @@ validate_group(struct perf_event *event)
 }
 
 static void
+armpmu_disable_percpu_irq(void *data)
+{
+	struct arm_pmu *armpmu = (struct arm_pmu *)data;
+	struct platform_device *pmu_device = armpmu->plat_device;
+	int irq = platform_get_irq(pmu_device, 0);
+
+	cpumask_test_and_clear_cpu(smp_processor_id(), &armpmu->active_irqs);
+	disable_percpu_irq(irq);
+}
+
+static void
 armpmu_release_hardware(struct arm_pmu *armpmu)
 {
 	int i, irq, irqs;
 	struct platform_device *pmu_device = armpmu->plat_device;
 
-	irqs = min(pmu_device->num_resources, num_possible_cpus());
+	irq = platform_get_irq(pmu_device, 0);
 
-	for (i = 0; i < irqs; ++i) {
-		if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
-			continue;
-		irq = platform_get_irq(pmu_device, i);
-		if (irq >= 0)
-			free_irq(irq, armpmu);
+	if (is_percpuirq) {
+		on_each_cpu(armpmu_disable_percpu_irq, (void *)armpmu, 1);
+		free_percpu_irq(irq, &cpu_hw_events);
+	} else {
+		irqs = min(pmu_device->num_resources, num_possible_cpus());
+
+		for (i = 0; i < irqs; ++i) {
+			if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
+				continue;
+			irq = platform_get_irq(pmu_device, i);
+			if (irq >= 0)
+				free_irq(irq, armpmu);
+		}
 	}
 }
 
+static void
+armpmu_enable_percpu_irq(void *data)
+{
+	struct arm_pmu *armpmu = (struct arm_pmu *)data;
+	struct platform_device *pmu_device = armpmu->plat_device;
+	int irq = platform_get_irq(pmu_device, 0);
+
+	enable_percpu_irq(irq, 0);
+	cpumask_set_cpu(smp_processor_id(), &armpmu->active_irqs);
+}
+
 static int
 armpmu_reserve_hardware(struct arm_pmu *armpmu)
 {
@@ -396,34 +426,57 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < irqs; ++i) {
-		err = 0;
-		irq = platform_get_irq(pmu_device, i);
-		if (irq < 0)
-			continue;
+	irq = platform_get_irq(pmu_device, 0);
 
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
+	/*
+	 * Try 'request_percpu_irq' first. If it's return value indicates
+	 * that irq is not percpu then try 'request_irq'
+	 */
+	err = request_percpu_irq(irq, armpmu->handle_irq,
+			"arm-pmu", &cpu_hw_events);
+	if (err != -EPERM) {
+		is_percpuirq = true;
 
-		err = request_irq(irq, armpmu->handle_irq,
-				  IRQF_NOBALANCING,
-				  "arm-pmu", armpmu);
 		if (err) {
-			pr_err("unable to request IRQ%d for ARM PMU counters\n",
-				irq);
+			pr_err("unable to request percpu IRQ%d for ARM PMU counters\n",
+					irq);
 			armpmu_release_hardware(armpmu);
 			return err;
 		}
 
-		cpumask_set_cpu(i, &armpmu->active_irqs);
+		on_each_cpu(armpmu_enable_percpu_irq, (void *)armpmu, 1);
+	} else {
+		is_percpuirq = false;
+
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
+						irq, i);
+				continue;
+			}
+
+			err = request_irq(irq, armpmu->handle_irq,
+					IRQF_NOBALANCING,
+					"arm-pmu", armpmu);
+			if (err) {
+				pr_err("unable to request IRQ%d for ARM PMU counters\n",
+						irq);
+				armpmu_release_hardware(armpmu);
+				return err;
+			}
+
+			cpumask_set_cpu(i, &armpmu->active_irqs);
+		}
 	}
 
 	return 0;
-- 
1.7.9.5

