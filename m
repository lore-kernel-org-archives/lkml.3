Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaKGQ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48336 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbaKGQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:54 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 10/11] arm: perf: remove singleton PMU restriction
Date: Fri,  7 Nov 2014 16:25:35 +0000
Message-Id: <1415377536-12841-11-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can describe PMUs in heterogeneous systems, the only item in
the way of perf support for big.LITTLE is the singleton cpu_pmu variable
used for OProfile compatibility.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/kernel/perf_event_cpu.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index f09c8a0..09de0e6 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -34,7 +34,7 @@
 #include <asm/pmu.h>
 
 /* Set at runtime when we know what CPU type we are. */
-static struct arm_pmu *cpu_pmu;
+static struct arm_pmu *__oprofile_cpu_pmu;
 
 /*
  * Despite the names, these two functions are CPU-specific and are used
@@ -42,10 +42,10 @@ static struct arm_pmu *cpu_pmu;
  */
 const char *perf_pmu_name(void)
 {
-	if (!cpu_pmu)
+	if (!__oprofile_cpu_pmu)
 		return NULL;
 
-	return cpu_pmu->name;
+	return __oprofile_cpu_pmu->name;
 }
 EXPORT_SYMBOL_GPL(perf_pmu_name);
 
@@ -53,8 +53,8 @@ int perf_num_counters(void)
 {
 	int max_events = 0;
 
-	if (cpu_pmu != NULL)
-		max_events = cpu_pmu->num_events;
+	if (__oprofile_cpu_pmu != NULL)
+		max_events = __oprofile_cpu_pmu->num_events;
 
 	return max_events;
 }
@@ -528,19 +528,16 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 	struct arm_pmu *pmu;
 	int ret = -ENODEV;
 
-	if (cpu_pmu) {
-		pr_info("attempt to register multiple PMU devices!\n");
-		return -ENOSPC;
-	}
-
 	pmu = kzalloc(sizeof(struct arm_pmu), GFP_KERNEL);
 	if (!pmu) {
 		pr_info("failed to allocate PMU device!\n");
 		return -ENOMEM;
 	}
 
-	cpu_pmu = pmu;
-	cpu_pmu->plat_device = pdev;
+	if (!__oprofile_cpu_pmu)
+		__oprofile_cpu_pmu = pmu;
+
+	pmu->plat_device = pdev;
 
 	ret = cpu_pmu_parse_interrupts(pmu);
 	if (ret)
@@ -558,18 +555,18 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
-	ret = cpu_pmu_init(cpu_pmu);
+	ret = cpu_pmu_init(pmu);
 	if (ret)
 		goto out_free;
 
-	ret = armpmu_register(cpu_pmu, -1);
+	ret = armpmu_register(pmu, -1);
 	if (ret)
 		goto out_destroy;
 
 	return 0;
 
 out_destroy:
-	cpu_pmu_destroy(cpu_pmu);
+	cpu_pmu_destroy(pmu);
 out_free:
 	kfree(pmu->irq_map);
 out_free_pmu:
-- 
1.9.1

