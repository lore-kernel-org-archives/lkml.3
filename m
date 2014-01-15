Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaAOR4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:56:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44909 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaAORzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:40 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: [PATCH v2 5/7] ARM: perf_event: Fully support Krait CPU PMU events
Date: Wed, 15 Jan 2014 09:55:33 -0800
Message-Id: <1389808535-23852-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krait supports a set of performance monitor region event
selection registers (PMRESR) sitting behind a cp15 based
interface that extend the architected PMU events to include Krait
CPU and Venum VFP specific events. To use these events the user
is expected to program the region register (PMRESRn) with the
event code shifted into the group they care about and then point
the PMNx event at that region+group combo by writing a
PMRESRn_GROUPx event. Add support for this hardware.

Note: the raw event number is a pure software construct that
allows us to map the multi-dimensional number space of regions,
groups, and event codes into a flat event number space suitable
for use by the perf framework.

This is based on code originally written by Ashwin Chaugule and
Neil Leeder [1].

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/kernel/perf_event_msm_krait.c?h=msm-3.4

Cc: Neil Leeder <nleeder@codeaurora.org>
Cc: Ashwin Chaugule <ashwinc@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/perf_event_v7.c | 398 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 392 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 16386b1d27a8..daa675529c12 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -18,6 +18,10 @@
 
 #ifdef CONFIG_CPU_V7
 
+#include <asm/cp15.h>
+#include <asm/vfp.h>
+#include "../vfp/vfpinstr.h"
+
 /*
  * Common ARMv7 event types
  *
@@ -109,6 +113,20 @@ enum armv7_a15_perf_types {
 	ARMV7_A15_PERFCTR_PC_WRITE_SPEC			= 0x76,
 };
 
+/* ARMv7 Krait specific event types */
+enum krait_perf_types {
+	KRAIT_PMRESR0_GROUP0				= 0xcc,
+	KRAIT_PMRESR1_GROUP0				= 0xd0,
+	KRAIT_PMRESR2_GROUP0				= 0xd4,
+	KRAIT_VPMRESR0_GROUP0				= 0xd8,
+
+	KRAIT_PERFCTR_L1_ICACHE_ACCESS			= 0x10011,
+	KRAIT_PERFCTR_L1_ICACHE_MISS			= 0x10010,
+
+	KRAIT_PERFCTR_L1_ITLB_ACCESS			= 0x12222,
+	KRAIT_PERFCTR_L1_DTLB_ACCESS			= 0x12210,
+};
+
 /*
  * Cortex-A8 HW events mapping
  *
@@ -779,8 +797,8 @@ static const unsigned krait_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 	[C(L1I)] = {
 		[C(OP_READ)] = {
-			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
-			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_ACCESS)]	= KRAIT_PERFCTR_L1_ICACHE_ACCESS,
+			[C(RESULT_MISS)]	= KRAIT_PERFCTR_L1_ICACHE_MISS,
 		},
 		[C(OP_WRITE)] = {
 			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
@@ -807,11 +825,11 @@ static const unsigned krait_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 	[C(DTLB)] = {
 		[C(OP_READ)] = {
-			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_ACCESS)]	= KRAIT_PERFCTR_L1_DTLB_ACCESS,
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 		[C(OP_WRITE)] = {
-			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_ACCESS)]	= KRAIT_PERFCTR_L1_DTLB_ACCESS,
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 		[C(OP_PREFETCH)] = {
@@ -821,11 +839,11 @@ static const unsigned krait_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 	[C(ITLB)] = {
 		[C(OP_READ)] = {
-			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_ACCESS)]	= KRAIT_PERFCTR_L1_ITLB_ACCESS,
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 		[C(OP_WRITE)] = {
-			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_ACCESS)]	= KRAIT_PERFCTR_L1_ITLB_ACCESS,
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 		[C(OP_PREFETCH)] = {
@@ -1428,6 +1446,369 @@ static int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
 	return 0;
 }
 
+/*
+ * Krait Performance Monitor Region Event Selection Register (PMRESRn)
+ *
+ *            31   30     24     16     8      0
+ *            +--------------------------------+
+ *  PMRESR0   | EN |  CC  |  CC  |  CC  |  CC  |   N = 1, R = 0
+ *            +--------------------------------+
+ *  PMRESR1   | EN |  CC  |  CC  |  CC  |  CC  |   N = 1, R = 1
+ *            +--------------------------------+
+ *  PMRESR2   | EN |  CC  |  CC  |  CC  |  CC  |   N = 1, R = 2
+ *            +--------------------------------+
+ *  VPMRESR0  | EN |  CC  |  CC  |  CC  |  CC  |   N = 2, R = ?
+ *            +--------------------------------+
+ *              EN | G=3  | G=2  | G=1  | G=0
+ *
+ *  Event Encoding:
+ *
+ *      hwc->config_base = 0xNRCCG
+ *
+ *      N  = prefix, 1 for Krait CPU (PMRESRn), 2 for Venum VFP (VPMRESR)
+ *      R  = region register
+ *      CC = class of events the group G is choosing from
+ *      G  = group or particular event
+ *
+ *  Example: 0x12021 is a Krait CPU event in PMRESR2's group 1 with code 2
+ *
+ *  A region (R) corresponds to a piece of the CPU (execution unit, instruction
+ *  unit, etc.) while the event code (CC) corresponds to a particular class of
+ *  events (interrupts for example). An event code is broken down into
+ *  groups (G) that can be mapped into the PMU (irq, fiqs, and irq+fiqs for
+ *  example).
+ */
+
+#define KRAIT_EVENT		(1 << 16)
+#define VENUM_EVENT		(2 << 16)
+#define KRAIT_EVENT_MASK	(KRAIT_EVENT | VENUM_EVENT)
+#define PMRESRn_EN		BIT(31)
+#define NUM_PMRESR	(KRAIT_VPMRESR0_GROUP0 + 4 - KRAIT_PMRESR0_GROUP0)
+
+static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(NUM_PMRESR)], pmresrn_used);
+
+static u32 krait_read_pmresrn(int n)
+{
+	u32 val;
+
+	switch (n) {
+	case 0:
+		asm volatile("mrc p15, 1, %0, c9, c15, 0" : "=r" (val));
+		break;
+	case 1:
+		asm volatile("mrc p15, 1, %0, c9, c15, 1" : "=r" (val));
+		break;
+	case 2:
+		asm volatile("mrc p15, 1, %0, c9, c15, 2" : "=r" (val));
+		break;
+	default:
+		BUG(); /* Should be validated in krait_pmu_get_event_idx() */
+	}
+
+	return val;
+}
+
+static void krait_write_pmresrn(int n, u32 val)
+{
+	switch (n) {
+	case 0:
+		asm volatile("mcr p15, 1, %0, c9, c15, 0" : : "r" (val));
+		break;
+	case 1:
+		asm volatile("mcr p15, 1, %0, c9, c15, 1" : : "r" (val));
+		break;
+	case 2:
+		asm volatile("mcr p15, 1, %0, c9, c15, 2" : : "r" (val));
+		break;
+	default:
+		BUG(); /* Should be validated in krait_pmu_get_event_idx() */
+	}
+}
+
+static u32 krait_read_vpmresr0(void)
+{
+	u32 val;
+	asm volatile("mrc p10, 7, %0, c11, c0, 0" : "=r" (val));
+	return val;
+}
+
+static void krait_write_vpmresr0(u32 val)
+{
+	asm volatile("mcr p10, 7, %0, c11, c0, 0" : : "r" (val));
+}
+
+static void krait_pre_vpmresr0(u32 *venum_orig_val, u32 *fp_orig_val)
+{
+	u32 venum_new_val;
+	u32 fp_new_val;
+
+	/* CPACR Enable CP10 and CP11 access */
+	*venum_orig_val = get_copro_access();
+	venum_new_val = *venum_orig_val | CPACC_SVC(10) | CPACC_SVC(11);
+	set_copro_access(venum_new_val);
+
+	/* Enable FPEXC */
+	*fp_orig_val = fmrx(FPEXC);
+	fp_new_val = *fp_orig_val | FPEXC_EN;
+	fmxr(FPEXC, fp_new_val);
+}
+
+static void krait_post_vpmresr0(u32 venum_orig_val, u32 fp_orig_val)
+{
+	/* Restore FPEXC */
+	fmxr(FPEXC, fp_orig_val);
+	isb();
+	/* Restore CPACR */
+	set_copro_access(venum_orig_val);
+}
+
+static u32 krait_get_pmresrn_event(int region)
+{
+	static const u32 pmresrn_table[] = { KRAIT_PMRESR0_GROUP0,
+					     KRAIT_PMRESR1_GROUP0,
+					     KRAIT_PMRESR2_GROUP0 };
+	return pmresrn_table[region];
+}
+
+static void krait_evt_setup(int idx, u32 config_base)
+{
+	u32 val;
+	u32 mask;
+	u32 vval, fval;
+	unsigned int region;
+	unsigned int group;
+	unsigned int code;
+	unsigned int group_shift;
+	bool venum_event;
+
+	venum_event = !!(config_base & VENUM_EVENT);
+	region = (config_base >> 12) & 0xf;
+	code   = (config_base >> 4) & 0xff;
+	group  = (config_base >> 0)  & 0xf;
+
+	group_shift = group * 8;
+	mask = 0xff << group_shift;
+
+	/* Configure evtsel for the region and group */
+	if (venum_event)
+		val = KRAIT_VPMRESR0_GROUP0;
+	else
+		val = krait_get_pmresrn_event(region);
+	val += group;
+	/* Mix in mode-exclusion bits */
+	val |= config_base & (ARMV7_EXCLUDE_USER | ARMV7_EXCLUDE_PL1);
+	armv7_pmnc_write_evtsel(idx, val);
+
+	asm volatile("mcr p15, 0, %0, c9, c15, 0" : : "r" (0));
+
+	if (venum_event) {
+		krait_pre_vpmresr0(&vval, &fval);
+		val = krait_read_vpmresr0();
+		val &= ~mask;
+		val |= code << group_shift;
+		val |= PMRESRn_EN;
+		krait_write_vpmresr0(val);
+		krait_post_vpmresr0(vval, fval);
+	} else {
+		val = krait_read_pmresrn(region);
+		val &= ~mask;
+		val |= code << group_shift;
+		val |= PMRESRn_EN;
+		krait_write_pmresrn(region, val);
+	}
+}
+
+static u32 krait_clear_pmresrn_group(u32 val, int group)
+{
+	u32 mask;
+	int group_shift;
+
+	group_shift = group * 8;
+	mask = 0xff << group_shift;
+	val &= ~mask;
+
+	/* Don't clear enable bit if entire region isn't disabled */
+	if (val & ~PMRESRn_EN)
+		return val |= PMRESRn_EN;
+
+	return 0;
+}
+
+static void krait_clearpmu(u32 config_base)
+{
+	u32 val;
+	u32 vval, fval;
+	unsigned int region;
+	unsigned int group;
+	bool venum_event;
+
+	venum_event = !!(config_base & VENUM_EVENT);
+	region = (config_base >> 12) & 0xf;
+	group  = (config_base >> 0)  & 0xf;
+
+	if (venum_event) {
+		krait_pre_vpmresr0(&vval, &fval);
+		val = krait_read_vpmresr0();
+		val = krait_clear_pmresrn_group(val, group);
+		krait_write_vpmresr0(val);
+		krait_post_vpmresr0(vval, fval);
+	} else {
+		val = krait_read_pmresrn(region);
+		val = krait_clear_pmresrn_group(val, group);
+		krait_write_pmresrn(region, val);
+	}
+}
+
+static void krait_pmu_disable_event(struct perf_event *event)
+{
+	unsigned long flags;
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+	struct pmu_hw_events *events = cpu_pmu->get_hw_events();
+
+	/* Disable counter and interrupt */
+	raw_spin_lock_irqsave(&events->pmu_lock, flags);
+
+	/* Disable counter */
+	armv7_pmnc_disable_counter(idx);
+
+	/*
+	 * Clear pmresr code (if destined for PMNx counters)
+	 */
+	if (hwc->config_base & KRAIT_EVENT_MASK)
+		krait_clearpmu(hwc->config_base);
+
+	/* Disable interrupt for this counter */
+	armv7_pmnc_disable_intens(idx);
+
+	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
+}
+
+static void krait_pmu_enable_event(struct perf_event *event)
+{
+	unsigned long flags;
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+	struct pmu_hw_events *events = cpu_pmu->get_hw_events();
+
+	/*
+	 * Enable counter and interrupt, and set the counter to count
+	 * the event that we're interested in.
+	 */
+	raw_spin_lock_irqsave(&events->pmu_lock, flags);
+
+	/* Disable counter */
+	armv7_pmnc_disable_counter(idx);
+
+	/*
+	 * Set event (if destined for PMNx counters)
+	 * We set the event for the cycle counter because we
+	 * have the ability to perform event filtering.
+	 */
+	if (hwc->config_base & KRAIT_EVENT_MASK)
+		krait_evt_setup(idx, hwc->config_base);
+	else
+		armv7_pmnc_write_evtsel(idx, hwc->config_base);
+
+	/* Enable interrupt for this counter */
+	armv7_pmnc_enable_intens(idx);
+
+	/* Enable counter */
+	armv7_pmnc_enable_counter(idx);
+
+	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
+}
+
+static void krait_pmu_reset(void *info)
+{
+	u32 vval, fval;
+
+	armv7pmu_reset(info);
+
+	/* Clear all pmresrs */
+	krait_write_pmresrn(0, 0);
+	krait_write_pmresrn(1, 0);
+	krait_write_pmresrn(2, 0);
+
+	krait_pre_vpmresr0(&vval, &fval);
+	krait_write_vpmresr0(0);
+	krait_post_vpmresr0(vval, fval);
+}
+
+/*
+ * We check for column exclusion constraints here.
+ * Two events cant use the same group within a pmresr register.
+ */
+static int krait_pmu_get_event_idx(struct pmu_hw_events *cpuc,
+				   struct perf_event *event)
+{
+	int idx;
+	int bit;
+	unsigned int prefix;
+	unsigned int region;
+	unsigned int code;
+	unsigned int group;
+	bool krait_event;
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned long *bitmap = this_cpu_ptr(pmresrn_used);
+
+	region = (hwc->config_base >> 12) & 0xf;
+	code   = (hwc->config_base >> 4) & 0xff;
+	group  = (hwc->config_base >> 0) & 0xf;
+	krait_event = !!(hwc->config_base & KRAIT_EVENT_MASK);
+
+	if (krait_event) {
+		/* Ignore invalid events */
+		if (group > 3 || region > 2)
+			return -EINVAL;
+		prefix = hwc->config_base & KRAIT_EVENT_MASK;
+		if (prefix != KRAIT_EVENT && prefix != VENUM_EVENT)
+			return -EINVAL;
+		if (prefix == VENUM_EVENT && (code & 0xe0))
+			return -EINVAL;
+
+		if (prefix == VENUM_EVENT)
+			bit = KRAIT_VPMRESR0_GROUP0;
+		else
+			bit = krait_get_pmresrn_event(region);
+		bit -= krait_get_pmresrn_event(0);
+		bit += group;
+
+		if (test_and_set_bit(bit, bitmap))
+			return -EAGAIN;
+	}
+
+	idx = armv7pmu_get_event_idx(cpuc, event);
+	if (idx < 0 && krait_event)
+		clear_bit(bit, bitmap);
+
+	return idx;
+}
+
+static void krait_pmu_clear_event_idx(struct perf_event *event)
+{
+	int bit;
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int region;
+	unsigned int group;
+	bool krait_event;
+	unsigned long *bitmap = this_cpu_ptr(pmresrn_used);
+
+	region = (hwc->config_base >> 12) & 0xf;
+	group  = (hwc->config_base >> 0) & 0xf;
+	krait_event = !!(hwc->config_base & KRAIT_EVENT_MASK);
+
+	if (krait_event) {
+		if (hwc->config_base & VENUM_EVENT)
+			bit = KRAIT_VPMRESR0_GROUP0;
+		else
+			bit = krait_get_pmresrn_event(region);
+		bit -= krait_get_pmresrn_event(0);
+		bit += group;
+		clear_bit(bit, bitmap);
+	}
+}
+
 static int krait_pmu_init(struct arm_pmu *cpu_pmu)
 {
 	armv7pmu_init(cpu_pmu);
@@ -1440,6 +1821,11 @@ static int krait_pmu_init(struct arm_pmu *cpu_pmu)
 		cpu_pmu->map_event = krait_map_event;
 	cpu_pmu->num_events	= armv7_read_num_pmnc_events();
 	cpu_pmu->set_event_filter = armv7pmu_set_event_filter;
+	cpu_pmu->reset		= krait_pmu_reset;
+	cpu_pmu->enable		= krait_pmu_enable_event;
+	cpu_pmu->disable	= krait_pmu_disable_event;
+	cpu_pmu->get_event_idx	= krait_pmu_get_event_idx;
+	cpu_pmu->clear_event_idx = krait_pmu_clear_event_idx;
 	return 0;
 }
 #else
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

