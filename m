Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaCGEmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:42:49 -0500
Received: from mail-pb0-f74.google.com ([209.85.160.74]:51012 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaCGEmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:42:47 -0500
From: Venkatesh Srinivas <venkateshs@google.com>
To: eranian@google.com, linux-kernel@vger.kernel.org
Cc: Venkatesh Srinivas <venkateshs@google.com>
Subject: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL PMU.
Date: Thu,  6 Mar 2014 20:42:44 -0800
Message-Id: <1394167364-2389-1-git-send-email-venkateshs@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUs which should support the RAPL counters according to
Family/Model/Stepping may still issue #GP when attempting to access
the RAPL MSRs. This may happen when Linux is running under KVM and
we are passing-through host F/M/S data, for example. Use rdmsrl_safe
to first access the RAPL_POWER_UNIT MSR; if this fails, do not
attempt to use this PMU.

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 5ad35ad..95700e5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -511,6 +511,7 @@ static int rapl_cpu_prepare(int cpu)
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
 	u64 ms;
+	u64 msr_rapl_power_unit_bits;
 
 	if (pmu)
 		return 0;
@@ -518,6 +519,9 @@ static int rapl_cpu_prepare(int cpu)
 	if (phys_id < 0)
 		return -1;
 
+	if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
+		return -1;
+
 	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
 	if (!pmu)
 		return -1;
@@ -531,8 +535,7 @@ static int rapl_cpu_prepare(int cpu)
 	 *
 	 * we cache in local PMU instance
 	 */
-	rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
-	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
+	pmu->hw_unit = (msr_rapl_power_unit_bits >> 8) & 0x1FULL;
 	pmu->pmu = &rapl_pmu_class;
 
 	/*
@@ -649,7 +652,9 @@ static int __init rapl_pmu_init(void)
 	get_online_cpus();
 
 	for_each_online_cpu(cpu) {
-		rapl_cpu_prepare(cpu);
+		ret = rapl_cpu_prepare(cpu);
+		if (ret)
+			goto out;
 		rapl_cpu_init(cpu);
 	}
 
@@ -672,6 +677,7 @@ static int __init rapl_pmu_init(void)
 		hweight32(rapl_cntr_mask),
 		ktime_to_ms(pmu->timer_interval));
 
+out:
 	put_online_cpus();
 
 	return 0;
-- 
1.9.0.279.gdc9e3eb

