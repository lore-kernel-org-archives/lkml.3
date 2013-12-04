Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3LDKK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:10:26 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:41746 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755534Ab3LDKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:10:20 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        sboyd@codeaurora.org, marc.zyngier@arm.com,
        Vinayak Kale <vkale@apm.com>, Tuan Phan <tphan@apm.com>
Subject: [PATCH V7 2/2] arm64: perf: add support for percpu pmu interrupt
Date: Wed,  4 Dec 2013 15:39:51 +0530
Message-Id: <1386151791-4881-3-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386151791-4881-1-git-send-email-vkale@apm.com>
References: <1386151791-4881-1-git-send-email-vkale@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for irq registration when pmu interrupt is percpu.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
---
 arch/arm64/kernel/perf_event.c |  108 +++++++++++++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index cea1594..d8e6667 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -22,6 +22,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/perf_event.h>
@@ -363,26 +364,52 @@ validate_group(struct perf_event *event)
 }
 
 static void
+armpmu_disable_percpu_irq(void *data)
+{
+	disable_percpu_irq((long)data);
+}
+
+static void
 armpmu_release_hardware(struct arm_pmu *armpmu)
 {
-	int i, irq, irqs;
+	int irq;
+	unsigned int i, irqs;
 	struct platform_device *pmu_device = armpmu->plat_device;
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
+	if (!irqs)
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
+		cpumask_clear(&armpmu->active_irqs);
+		on_each_cpu(armpmu_disable_percpu_irq, (void *)(long)irq, 1);
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
+	enable_percpu_irq((long)data, IRQ_TYPE_NONE);
+}
+
 static int
 armpmu_reserve_hardware(struct arm_pmu *armpmu)
 {
-	int i, err, irq, irqs;
+	int err, irq;
+	unsigned int i, irqs;
 	struct platform_device *pmu_device = armpmu->plat_device;
 
 	if (!pmu_device) {
@@ -391,39 +418,60 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
 	}
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
-	if (irqs < 1) {
+	if (!irqs) {
 		pr_err("no irqs for PMUs defined\n");
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
+		on_each_cpu(armpmu_enable_percpu_irq, (void *)(long)irq, 1);
+		cpumask_setall(&armpmu->active_irqs);
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

