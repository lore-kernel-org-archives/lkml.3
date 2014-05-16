Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaEPVL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:11:56 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33679 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaEPVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:11:53 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 16 May 2014 17:15:49 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] perf, ARM: use common PMU interrupt disabled code
In-Reply-To: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the ARM perf code use the new common PMU interrupt disabled code.

This allows perf to work on ARM machines without a working PMU
interrupt (for example, raspberry pi).

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index a6bc431..4238bcb 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -410,7 +410,7 @@ __hw_perf_event_init(struct perf_event *event)
 	 */
 	hwc->config_base	    |= (unsigned long)mapping;
 
-	if (!hwc->sample_period) {
+	if (!is_sampling_event(event)) {
 		/*
 		 * For non-sampling runs, limit the sample_period to half
 		 * of the counter width. That way, the new counter value
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 51798d7..63d95fa 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -126,8 +126,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 	if (irqs < 1) {
-		pr_err("no irqs for PMUs defined\n");
-		return -ENODEV;
+		printk_once("no irqs for PMU defined, sampled events not supported\n");
+		return 0;
 	}
 
 	irq = platform_get_irq(pmu_device, 0);
@@ -191,6 +191,11 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 	/* Ensure the PMU has sane values out of reset. */
 	if (cpu_pmu->reset)
 		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+
+	/* If no interrupts available, set the corresponding capability flag */
+	if (platform_get_irq(cpu_pmu->plat_device, 0) <= 0) {
+		cpu_pmu->pmu.capabilities |= PERF_PMU_NO_INTERRUPT;
+	}
 }
 
 /*
