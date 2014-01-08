Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbaAHXAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:00:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54839 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbaAHW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:59:50 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: [PATCH 3/7] ARM: perf_event: Add basic support for Krait CPU PMUs
Date: Wed,  8 Jan 2014 14:59:40 -0800
Message-Id: <1389221984-10973-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic support for the Krait CPU PMU. This allows us to use
the architected functionality of the PMU.

This is based on code originally written by Ashwin Chaugule and
Neil Leeder [1].

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/kernel/perf_event_msm_krait.c?h=msm-3.4

Cc: Neil Leeder <nleeder@codeaurora.org>
Cc: Ashwin Chaugule <ashwinc@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/perf_event_cpu.c |   1 +
 arch/arm/kernel/perf_event_v7.c  | 165 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 58916ffa61e5..ab69abf14efd 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -239,6 +239,7 @@ static struct of_device_id cpu_pmu_of_device_ids[] = {
 	{.compatible = "arm,arm11mpcore-pmu",	.data = armv6mpcore_pmu_init},
 	{.compatible = "arm,arm1176-pmu",	.data = armv6pmu_init},
 	{.compatible = "arm,arm1136-pmu",	.data = armv6pmu_init},
+	{.compatible = "qcom,krait-pmu",	.data = krait_pmu_init},
 	{},
 };
 
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 039cffb053a7..ec86cf42d2ba 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -732,6 +732,138 @@ static const unsigned armv7_a7_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 };
 
 /*
+ * Krait HW events mapping
+ */
+static const unsigned krait_perf_map[PERF_COUNT_HW_MAX] = {
+	[PERF_COUNT_HW_CPU_CYCLES]	    = ARMV7_PERFCTR_CPU_CYCLES,
+	[PERF_COUNT_HW_INSTRUCTIONS]	    = ARMV7_PERFCTR_INSTR_EXECUTED,
+	[PERF_COUNT_HW_CACHE_REFERENCES]    = HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_CACHE_MISSES]	    = HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = ARMV7_PERFCTR_PC_WRITE,
+	[PERF_COUNT_HW_BRANCH_MISSES]	    = ARMV7_PERFCTR_PC_BRANCH_MIS_PRED,
+	[PERF_COUNT_HW_BUS_CYCLES]	    = ARMV7_PERFCTR_CLOCK_CYCLES,
+};
+
+static const unsigned krait_perf_map_no_branch[PERF_COUNT_HW_MAX] = {
+	[PERF_COUNT_HW_CPU_CYCLES]	    = ARMV7_PERFCTR_CPU_CYCLES,
+	[PERF_COUNT_HW_INSTRUCTIONS]	    = ARMV7_PERFCTR_INSTR_EXECUTED,
+	[PERF_COUNT_HW_CACHE_REFERENCES]    = HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_CACHE_MISSES]	    = HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_BRANCH_MISSES]	    = ARMV7_PERFCTR_PC_BRANCH_MIS_PRED,
+	[PERF_COUNT_HW_BUS_CYCLES]	    = ARMV7_PERFCTR_CLOCK_CYCLES,
+};
+
+static const unsigned krait_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
+					  [PERF_COUNT_HW_CACHE_OP_MAX]
+					  [PERF_COUNT_HW_CACHE_RESULT_MAX] = {
+	[C(L1D)] = {
+		/*
+		 * The performance counters don't differentiate between read
+		 * and write accesses/misses so this isn't strictly correct,
+		 * but it's the best we can do. Writes and reads get
+		 * combined.
+		 */
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= ARMV7_PERFCTR_L1_DCACHE_ACCESS,
+			[C(RESULT_MISS)]	= ARMV7_PERFCTR_L1_DCACHE_REFILL,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= ARMV7_PERFCTR_L1_DCACHE_ACCESS,
+			[C(RESULT_MISS)]	= ARMV7_PERFCTR_L1_DCACHE_REFILL,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(L1I)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(LL)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(DTLB)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(ITLB)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(BPU)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= ARMV7_PERFCTR_PC_BRANCH_PRED,
+			[C(RESULT_MISS)]	= ARMV7_PERFCTR_PC_BRANCH_MIS_PRED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= ARMV7_PERFCTR_PC_BRANCH_PRED,
+			[C(RESULT_MISS)]	= ARMV7_PERFCTR_PC_BRANCH_MIS_PRED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+};
+
+/*
  * Perf Events' indices
  */
 #define	ARMV7_IDX_CYCLE_COUNTER	0
@@ -1212,6 +1344,18 @@ static int armv7_a7_map_event(struct perf_event *event)
 				&armv7_a7_perf_cache_map, 0xFF);
 }
 
+static int krait_map_event(struct perf_event *event)
+{
+	return armpmu_map_event(event, &krait_perf_map,
+				&krait_perf_cache_map, 0xFFFFF);
+}
+
+static int krait_map_event_no_branch(struct perf_event *event)
+{
+	return armpmu_map_event(event, &krait_perf_map_no_branch,
+				&krait_perf_cache_map, 0xFFFFF);
+}
+
 static void armv7pmu_init(struct arm_pmu *cpu_pmu)
 {
 	cpu_pmu->handle_irq	= armv7pmu_handle_irq;
@@ -1283,6 +1427,22 @@ static int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
 	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
 	return 0;
 }
+
+static int krait_pmu_init(struct arm_pmu *cpu_pmu)
+{
+	u32 id = read_cpuid_id() & 0xffffff00;
+
+	armv7pmu_init(cpu_pmu);
+	cpu_pmu->name		= "ARMv7 Krait";
+	/* Some early versions of Krait don't support PC write events */
+	if (id == 0x511f0400 || id == 0x510f0600)
+		cpu_pmu->map_event	= krait_map_event_no_branch;
+	else
+		cpu_pmu->map_event	= krait_map_event;
+	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
+	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
+	return 0;
+}
 #else
 static inline int armv7_a8_pmu_init(struct arm_pmu *cpu_pmu)
 {
@@ -1308,4 +1468,9 @@ static inline int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
 {
 	return -ENODEV;
 }
+
+static inline int krait_pmu_init(struct arm_pmu *cpu_pmu)
+{
+	return -ENODEV;
+}
 #endif	/* CONFIG_CPU_V7 */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

