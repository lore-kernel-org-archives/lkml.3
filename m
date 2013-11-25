Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3KYJqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:46:30 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:42484 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751152Ab3KYJq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:46:27 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        sboyd@codeaurora.org, marc.zyngier@arm.com,
        Vinayak Kale <vkale@apm.com>, Tuan Phan <tphan@apm.com>
Subject: [PATCH V5 2/2] arm64: perf: add support for percpu pmu interrupt
Date: Mon, 25 Nov 2013 15:15:53 +0530
Message-Id: <1385372753-7396-3-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385372753-7396-1-git-send-email-vkale@apm.com>
References: <1385372753-7396-1-git-send-email-vkale@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for irq registration when pmu interrupt is percpu.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
---
 arch/arm64/kernel/perf_event.c |  108 ++++++++++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index cea1594..a2efab3 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -22,6 +22,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/perf_event.h>
@@ -363,22 +364,55 @@ validate_group(struct perf_event *event)
 }
 
 static void
+armpmu_disable_percpu_irq(void *data)
+{
+	struct arm_pmu *armpmu = data;
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
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
+	if (irqs < 1)
+		return;
 
-	for (i = 0; i < irqs; ++i) {
-		if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
-			continue;
-		irq = platform_get_irq(pmu_device, i);
-		if (irq >= 0)
-			free_irq(irq, armpmu);
+	irq = platform_get_irq(pmu_device, 0);
+	if (irq <= 0)
+		return;
+
+	if (irq_is_percpu(irq)) {
+		on_each_cpu(armpmu_disable_percpu_irq, armpmu, 1);
+		free_percpu_irq(irq, &cpu_hw_events);
+	} else {
+		for (i = 0; i < irqs; ++i) {
+			if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
+				continue;
+			irq = platform_get_irq(pmu_device, i);
+			if (irq > 0)
+				free_irq(irq, armpmu);
+		}
 	}
 }
 
+static void
+armpmu_enable_percpu_irq(void *data)
+{
+	struct arm_pmu *armpmu = data;
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
@@ -396,34 +430,54 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < irqs; ++i) {
-		err = 0;
-		irq = platform_get_irq(pmu_device, i);
-		if (irq < 0)
-			continue;
+	irq = platform_get_irq(pmu_device, 0);
+	if (irq <= 0) {
+		pr_err("failed to get valid irq for PMU device\n");
+		return -ENODEV;
+	}
 
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
+	if (irq_is_percpu(irq)) {
+		err = request_percpu_irq(irq, armpmu->handle_irq,
+				"arm-pmu", &cpu_hw_events);
 
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
+		on_each_cpu(armpmu_enable_percpu_irq, armpmu, 1);
+	} else {
+		for (i = 0; i < irqs; ++i) {
+			err = 0;
+			irq = platform_get_irq(pmu_device, i);
+			if (irq <= 0)
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

