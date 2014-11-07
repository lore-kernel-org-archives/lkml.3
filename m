Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaKGQ1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48310 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbaKGQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:10 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 06/11] arm: perf: probe number of counters on affine CPUs
Date: Fri,  7 Nov 2014 16:25:31 +0000
Message-Id: <1415377536-12841-7-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In heterogeneous systems, the number of counters may differ across
clusters. To find the number of counters for a cluster, we must probe
the PMU from a CPU in that cluster.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/perf_event_v7.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index fa76b25..dccd108 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -994,15 +994,22 @@ static void armv7pmu_init(struct arm_pmu *cpu_pmu)
 	cpu_pmu->max_period	= (1LLU << 32) - 1;
 };
 
-static u32 armv7_read_num_pmnc_events(void)
+static void armv7_read_num_pmnc_events(void *info)
 {
-	u32 nb_cnt;
+	int *nb_cnt = info;
 
 	/* Read the nb of CNTx counters supported from PMNC */
-	nb_cnt = (armv7_pmnc_read() >> ARMV7_PMNC_N_SHIFT) & ARMV7_PMNC_N_MASK;
+	*nb_cnt = (armv7_pmnc_read() >> ARMV7_PMNC_N_SHIFT) & ARMV7_PMNC_N_MASK;
 
-	/* Add the CPU cycles counter and return */
-	return nb_cnt + 1;
+	/* Add the CPU cycles counter */
+	*nb_cnt += 1;
+}
+
+static int armv7_probe_num_events(struct arm_pmu *arm_pmu)
+{
+	return smp_call_function_any(&arm_pmu->supported_cpus,
+				     armv7_read_num_pmnc_events,
+				     &arm_pmu->num_events, 1);
 }
 
 static int armv7_a8_pmu_init(struct arm_pmu *cpu_pmu)
@@ -1010,8 +1017,7 @@ static int armv7_a8_pmu_init(struct arm_pmu *cpu_pmu)
 	armv7pmu_init(cpu_pmu);
 	cpu_pmu->name		= "armv7_cortex_a8";
 	cpu_pmu->map_event	= armv7_a8_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
-	return 0;
+	return armv7_probe_num_events(cpu_pmu);
 }
 
 static int armv7_a9_pmu_init(struct arm_pmu *cpu_pmu)
@@ -1019,8 +1025,7 @@ static int armv7_a9_pmu_init(struct arm_pmu *cpu_pmu)
 	armv7pmu_init(cpu_pmu);
 	cpu_pmu->name		= "armv7_cortex_a9";
 	cpu_pmu->map_event	= armv7_a9_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
-	return 0;
+	return armv7_probe_num_events(cpu_pmu);
 }
 
 static int armv7_a5_pmu_init(struct arm_pmu *cpu_pmu)
@@ -1028,8 +1033,7 @@ static int armv7_a5_pmu_init(struct arm_pmu *cpu_pmu)
 	armv7pmu_init(cpu_pmu);
 	cpu_pmu->name		= "armv7_cortex_a5";
 	cpu_pmu->map_event	= armv7_a5_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
-	return 0;
+	return armv7_probe_num_events(cpu_pmu);
 }
 
 static int armv7_a15_pmu_init(struct arm_pmu *cpu_pmu)
@@ -1037,9 +1041,8 @@ static int armv7_a15_pmu_init(struct arm_pmu *cpu_pmu)
 	armv7pmu_init(cpu_pmu);
 	cpu_pmu->name		= "armv7_cortex_a15";
 	cpu_pmu->map_event	= armv7_a15_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
 	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
-	return 0;
+	return armv7_probe_num_events(cpu_pmu);
 }
 
 static int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
@@ -1047,9 +1050,8 @@ static int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
 	armv7pmu_init(cpu_pmu);
 	cpu_pmu->name		= "armv7_cortex_a7";
 	cpu_pmu->map_event	= armv7_a7_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
 	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
-	return 0;
+	return armv7_probe_num_events(cpu_pmu);
 }
 
 static int armv7_a12_pmu_init(struct arm_pmu *cpu_pmu)
@@ -1057,16 +1059,15 @@ static int armv7_a12_pmu_init(struct arm_pmu *cpu_pmu)
 	armv7pmu_init(cpu_pmu);
 	cpu_pmu->name		= "armv7_cortex_a12";
 	cpu_pmu->map_event	= armv7_a12_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
 	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
-	return 0;
+	return armv7_probe_num_events(cpu_pmu);
 }
 
 static int armv7_a17_pmu_init(struct arm_pmu *cpu_pmu)
 {
-	armv7_a12_pmu_init(cpu_pmu);
+	int ret = armv7_a12_pmu_init(cpu_pmu);
 	cpu_pmu->name = "armv7_cortex_a17";
-	return 0;
+	return ret;
 }
 
 /*
@@ -1453,7 +1454,7 @@ static int krait_pmu_init(struct arm_pmu *cpu_pmu)
 		cpu_pmu->map_event = krait_map_event_no_branch;
 	else
 		cpu_pmu->map_event = krait_map_event;
-	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
+	cpu_pmu->num_events	= armv7_probe_num_events(cpu_pmu);
 	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
 	cpu_pmu->reset		= krait_pmu_reset;
 	cpu_pmu->enable		= krait_pmu_enable_event;
-- 
1.9.1

