Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3J3OqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:46:04 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:37596 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3J3OqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:46:01 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2] ARC: Add perf support for ARC700 cores
Date: Wed, 30 Oct 2013 15:45:36 +0100
Message-Id: <1383144336-20802-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds basic perf support for ARC700 cores. Most PERF_COUNT_HW* events
are supported now.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
v2:
	updated comments to kernel coding standards
	renamed devicetree binding to snps,arc700-pmu
	added devicetree binding doc

 Documentation/devicetree/bindings/arc/pmu.txt |   15 ++
 arch/arc/boot/dts/angel4.dts                  |    4 +
 arch/arc/include/asm/perf_event.h             |  204 +++++++++++++++-
 arch/arc/kernel/Makefile                      |    1 +
 arch/arc/kernel/perf_event.c                  |  322 +++++++++++++++++++++++++
 5 files changed, 545 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arc/pmu.txt
 create mode 100644 arch/arc/kernel/perf_event.c

diff --git a/Documentation/devicetree/bindings/arc/pmu.txt b/Documentation/devicetree/bindings/arc/pmu.txt
new file mode 100644
index 0000000..d252d3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/arc/pmu.txt
@@ -0,0 +1,15 @@
+* ARC Performance Monitor Unit
+
+The ARC 700 can be configured with a pipeline performance monitor for counting
+CPU and cache events like cache misses and hits.
+
+Required properties:
+
+- compatible : should be
+	"snps,arc700-pmu"
+
+Example:
+
+pmu {
+        compatible = "snps,arc700-pmu";
+};
diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
index 4fb2d6f..bcf662d 100644
--- a/arch/arc/boot/dts/angel4.dts
+++ b/arch/arc/boot/dts/angel4.dts
@@ -67,5 +67,9 @@
 				reg = <1>;
 			};
 		};
+
+		arcpmu0: pmu {
+			compatible = "snps,arc700-pmu";
+		};
 	};
 };
diff --git a/arch/arc/include/asm/perf_event.h b/arch/arc/include/asm/perf_event.h
index 115ad96..cbf755e 100644
--- a/arch/arc/include/asm/perf_event.h
+++ b/arch/arc/include/asm/perf_event.h
@@ -1,5 +1,7 @@
 /*
- * Copyright (C) 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ * Linux performance counter support for ARC
+ *
+ * Copyright (C) 2011-2013 Synopsys, Inc. (www.synopsys.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -10,4 +12,204 @@
 #ifndef __ASM_PERF_EVENT_H
 #define __ASM_PERF_EVENT_H
 
+/* real maximum varies per CPU, this is the maximum supported by the driver */
+#define ARC_PMU_MAX_HWEVENTS	64
+
+#define ARC_REG_CC_BUILD	0xF6
+#define ARC_REG_CC_INDEX	0x240
+#define ARC_REG_CC_NAME0	0x241
+#define ARC_REG_CC_NAME1	0x242
+
+#define ARC_REG_PCT_BUILD	0xF5
+#define ARC_REG_PCT_COUNTL	0x250
+#define ARC_REG_PCT_COUNTH	0x251
+#define ARC_REG_PCT_SNAPL	0x252
+#define ARC_REG_PCT_SNAPH	0x253
+#define ARC_REG_PCT_CONFIG	0x254
+#define ARC_REG_PCT_CONTROL	0x255
+#define ARC_REG_PCT_INDEX	0x256
+
+#define ARC_REG_PCT_CONTROL_CC	(1 << 16)	/* clear counts */
+#define ARC_REG_PCT_CONTROL_SN	(1 << 17)	/* snapshot */
+
+struct arc_reg_pct_build {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int m:8, c:8, r:6, s:2, v:8;
+#else
+	unsigned int v:8, s:2, r:6, c:8, m:8;
+#endif
+};
+
+struct arc_reg_cc_build {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int c:16, r:8, v:8;
+#else
+	unsigned int v:8, r:8, c:16;
+#endif
+};
+
+#define PERF_COUNT_ARC_DCLM	(PERF_COUNT_HW_MAX + 0)
+#define PERF_COUNT_ARC_DCSM	(PERF_COUNT_HW_MAX + 1)
+#define PERF_COUNT_ARC_ICM	(PERF_COUNT_HW_MAX + 2)
+#define PERF_COUNT_ARC_BPOK	(PERF_COUNT_HW_MAX + 3)
+#define PERF_COUNT_ARC_EDTLB	(PERF_COUNT_HW_MAX + 4)
+#define PERF_COUNT_ARC_EITLB	(PERF_COUNT_HW_MAX + 5)
+#define PERF_COUNT_ARC_HW_MAX	(PERF_COUNT_HW_MAX + 6)
+
+/*
+ * The "generalized" performance events seem to really be a copy
+ * of the available events on x86 processors; the mapping to ARC
+ * events is not always possible 1-to-1. Fortunately, there doesn't
+ * seem to be an exact definition for these events, so we can cheat
+ * a bit where necessary.
+ *
+ * In particular, the following PERF events may behave a bit differently
+ * compared to other architectures:
+ *
+ * PERF_COUNT_HW_CPU_CYCLES
+ *	Cycles not in halted state
+ *
+ * PERF_COUNT_HW_REF_CPU_CYCLES
+ *	Reference cycles not in halted state, same as PERF_COUNT_HW_CPU_CYCLES
+ *	for now as we don't do Dynamic Voltage/Frequency Scaling (yet)
+ *
+ * PERF_COUNT_HW_BUS_CYCLES
+ *	Unclear what this means, Intel uses 0x013c, which according to
+ *	their datasheet means "unhalted reference cycles". It sounds similar
+ *	to PERF_COUNT_HW_REF_CPU_CYCLES, and we use the same counter for it.
+ *
+ * PERF_COUNT_HW_STALLED_CYCLES_BACKEND
+ * PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
+ *	The ARC 700 can either measure stalls per pipeline stage, or all stalls
+ *	combined; for now we assign all stalls to STALLED_CYCLES_BACKEND
+ *	and all pipeline flushes (e.g. caused by mispredicts, etc.) to
+ *	STALLED_CYCLES_FRONTEND.
+ *
+ *	We could start multiple performance counters and combine everything
+ *	afterwards, but that makes it complicated.
+ *
+ *	Note that I$ cache misses aren't counted by either of the two!
+ */
+
+static const char * const arc_pmu_ev_hw_map[] = {
+	[PERF_COUNT_HW_CPU_CYCLES] = "crun",
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = "crun",
+	[PERF_COUNT_HW_BUS_CYCLES] = "crun",
+	[PERF_COUNT_HW_INSTRUCTIONS] = "iall",
+	[PERF_COUNT_HW_BRANCH_MISSES] = "bpfail",
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = "ijmp",
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = "bflush",
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = "bstall",
+	[PERF_COUNT_ARC_DCLM] = "dclm",
+	[PERF_COUNT_ARC_DCSM] = "dcsm",
+	[PERF_COUNT_ARC_ICM] = "icm",
+	[PERF_COUNT_ARC_BPOK] = "bpok",
+	[PERF_COUNT_ARC_EDTLB] = "edtlb",
+	[PERF_COUNT_ARC_EITLB] = "eitlb",
+};
+
+#define C(_x)			PERF_COUNT_HW_CACHE_##_x
+#define CACHE_OP_UNSUPPORTED	0xffff
+
+static const unsigned arc_pmu_cache_map[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= PERF_COUNT_ARC_DCLM,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= PERF_COUNT_ARC_DCSM,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
+	[C(L1I)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= PERF_COUNT_ARC_ICM,
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
+			[C(RESULT_MISS)]	= PERF_COUNT_ARC_EDTLB,
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
+			[C(RESULT_MISS)]	= PERF_COUNT_ARC_EITLB,
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
+			[C(RESULT_ACCESS)] = PERF_COUNT_HW_BRANCH_INSTRUCTIONS,
+			[C(RESULT_MISS)]	= PERF_COUNT_HW_BRANCH_MISSES,
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
 #endif /* __ASM_PERF_EVENT_H */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index c242ef0..8004b4f 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_KPROBES)      		+= kprobes.o
 obj-$(CONFIG_ARC_MISALIGN_ACCESS) 	+= unaligned.o
 obj-$(CONFIG_KGDB)			+= kgdb.o
 obj-$(CONFIG_ARC_METAWARE_HLINK)	+= arc_hostlink.o
+obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
new file mode 100644
index 0000000..759e5f3
--- /dev/null
+++ b/arch/arc/kernel/perf_event.c
@@ -0,0 +1,322 @@
+/*
+ * Linux performance counter support for ARC700 series
+ *
+ * Copyright (C) 2013 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This code is inspired by the perf support of various other architectures.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/perf_event.h>
+#include <linux/platform_device.h>
+#include <asm/arcregs.h>
+
+struct arc_pmu {
+	struct pmu	pmu;
+	int		counter_size;	/* in bits */
+	int		n_counters;
+	unsigned long	used_mask[BITS_TO_LONGS(ARC_PMU_MAX_HWEVENTS)];
+	int		ev_hw_idx[PERF_COUNT_ARC_HW_MAX];
+};
+
+/* read counter #idx; note that counter# != event# on ARC! */
+static uint64_t arc_pmu_read_counter(int idx)
+{
+	uint32_t tmp;
+	uint64_t result;
+
+	/*
+	 * ARC supports making 'snapshots' of the counters, so we don't
+	 * need to care about counters wrapping to 0 underneath our feet
+	 */
+	write_aux_reg(ARC_REG_PCT_INDEX, idx);
+	tmp = read_aux_reg(ARC_REG_PCT_CONTROL);
+	write_aux_reg(ARC_REG_PCT_CONTROL, tmp | ARC_REG_PCT_CONTROL_SN);
+	result = (uint64_t) (read_aux_reg(ARC_REG_PCT_SNAPH)) << 32;
+	result |= read_aux_reg(ARC_REG_PCT_SNAPL);
+
+	return result;
+}
+
+static void arc_perf_event_update(struct perf_event *event,
+				  struct hw_perf_event *hwc, int idx)
+{
+	struct arc_pmu *arc_pmu = container_of(event->pmu, struct arc_pmu, pmu);
+	uint64_t prev_raw_count, new_raw_count;
+	int64_t delta;
+
+	do {
+		prev_raw_count = local64_read(&hwc->prev_count);
+		new_raw_count = arc_pmu_read_counter(idx);
+	} while (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
+				 new_raw_count) != prev_raw_count);
+
+	delta = (new_raw_count - prev_raw_count) &
+		((1ULL << arc_pmu->counter_size) - 1ULL);
+
+	local64_add(delta, &event->count);
+	local64_sub(delta, &hwc->period_left);
+}
+
+static void arc_pmu_read(struct perf_event *event)
+{
+	arc_perf_event_update(event, &event->hw, event->hw.idx);
+}
+
+static int arc_pmu_cache_event(u64 config)
+{
+	unsigned int cache_type, cache_op, cache_result;
+	int ret;
+
+	cache_type	= (config >>  0) & 0xff;
+	cache_op	= (config >>  8) & 0xff;
+	cache_result	= (config >> 16) & 0xff;
+	if (cache_type >= PERF_COUNT_HW_CACHE_MAX)
+		return -EINVAL;
+	if (cache_type >= PERF_COUNT_HW_CACHE_OP_MAX)
+		return -EINVAL;
+	if (cache_type >= PERF_COUNT_HW_CACHE_RESULT_MAX)
+		return -EINVAL;
+
+	ret = arc_pmu_cache_map[cache_type][cache_op][cache_result];
+
+	if (ret == CACHE_OP_UNSUPPORTED)
+		return -ENOENT;
+
+	return ret;
+}
+
+/* initializes hw_perf_event structure if event is supported */
+static int arc_pmu_event_init(struct perf_event *event)
+{
+	struct arc_pmu *arc_pmu = container_of(event->pmu, struct arc_pmu, pmu);
+	struct hw_perf_event *hwc = &event->hw;
+	int ret;
+
+	switch (event->attr.type) {
+	case PERF_TYPE_HARDWARE:
+		if (event->attr.config >= PERF_COUNT_HW_MAX)
+			return -ENOENT;
+		if (arc_pmu->ev_hw_idx[event->attr.config] < 0)
+			return -ENOENT;
+		hwc->config = arc_pmu->ev_hw_idx[event->attr.config];
+		pr_debug("initializing event %d with cfg %d\n",
+			 (int) event->attr.config, (int) hwc->config);
+		return 0;
+	case PERF_TYPE_HW_CACHE:
+		ret = arc_pmu_cache_event(event->attr.config);
+		if (ret < 0)
+			return ret;
+		hwc->config = arc_pmu->ev_hw_idx[ret];
+		return 0;
+	default:
+		return -ENOENT;
+	}
+}
+
+/* starts all counters */
+static void arc_pmu_enable(struct pmu *pmu)
+{
+	uint32_t tmp;
+	tmp = read_aux_reg(ARC_REG_PCT_CONTROL);
+	write_aux_reg(ARC_REG_PCT_CONTROL, (tmp & 0xffff0000) | 0x1);
+}
+
+/* stops all counters */
+static void arc_pmu_disable(struct pmu *pmu)
+{
+	uint32_t tmp;
+	tmp = read_aux_reg(ARC_REG_PCT_CONTROL);
+	write_aux_reg(ARC_REG_PCT_CONTROL, (tmp & 0xffff0000) | 0x0);
+}
+
+/*
+ * Assigns hardware counter to hardware condition.
+ * Note that there is no separate start/stop mechanism;
+ * stopping is achieved by assigning the 'never' condition
+ */
+static void arc_pmu_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	if (WARN_ON_ONCE(idx == -1))
+		return;
+
+	if (flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
+
+	event->hw.state = 0;
+
+	/* enable ARC pmu here */
+	write_aux_reg(ARC_REG_PCT_INDEX, idx);
+	write_aux_reg(ARC_REG_PCT_CONFIG, hwc->config);
+}
+
+static void arc_pmu_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	if (!(event->hw.state & PERF_HES_STOPPED)) {
+		/* stop ARC pmu here */
+		write_aux_reg(ARC_REG_PCT_INDEX, idx);
+
+		/* condition code #0 is always "never" */
+		write_aux_reg(ARC_REG_PCT_CONFIG, 0);
+
+		event->hw.state |= PERF_HES_STOPPED;
+	}
+
+	if ((flags & PERF_EF_UPDATE) &&
+	    !(event->hw.state & PERF_HES_UPTODATE)) {
+		arc_perf_event_update(event, &event->hw, idx);
+		event->hw.state |= PERF_HES_UPTODATE;
+	}
+}
+
+static void arc_pmu_del(struct perf_event *event, int flags)
+{
+	struct arc_pmu *arc_pmu = container_of(event->pmu, struct arc_pmu, pmu);
+
+	arc_pmu_stop(event, PERF_EF_UPDATE);
+	__clear_bit(event->hw.idx, arc_pmu->used_mask);
+
+	perf_event_update_userpage(event);
+}
+
+/* allocate hardware counter and optionally start counting */
+static int arc_pmu_add(struct perf_event *event, int flags)
+{
+	struct arc_pmu *arc_pmu = container_of(event->pmu, struct arc_pmu, pmu);
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	if (__test_and_set_bit(idx, arc_pmu->used_mask)) {
+		idx = find_first_zero_bit(arc_pmu->used_mask,
+					  arc_pmu->n_counters);
+		if (idx == arc_pmu->n_counters)
+			return -EAGAIN;
+
+		__set_bit(idx, arc_pmu->used_mask);
+		hwc->idx = idx;
+	}
+
+	write_aux_reg(ARC_REG_PCT_INDEX, idx);
+	write_aux_reg(ARC_REG_PCT_CONFIG, 0);
+	write_aux_reg(ARC_REG_PCT_COUNTL, 0);
+	write_aux_reg(ARC_REG_PCT_COUNTH, 0);
+	local64_set(&hwc->prev_count, 0);
+
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+	if (flags & PERF_EF_START)
+		arc_pmu_start(event, PERF_EF_RELOAD);
+
+	perf_event_update_userpage(event);
+
+	return 0;
+}
+
+static int arc_pmu_device_probe(struct platform_device *pdev)
+{
+	struct arc_pmu *arc_pmu;
+	struct arc_reg_pct_build pct_bcr;
+	struct arc_reg_cc_build cc_bcr;
+	int i, j, ret;
+
+	union cc_name {
+		struct {
+			uint32_t word0, word1;
+			char sentinel;
+		} indiv;
+		char str[9];
+	} cc_name;
+
+
+	READ_BCR(ARC_REG_PCT_BUILD, pct_bcr);
+	if (!pct_bcr.v) {
+		pr_err("This core does not have performance counters!\n");
+		return -ENODEV;
+	}
+
+	arc_pmu = devm_kzalloc(&pdev->dev, sizeof(struct arc_pmu),
+			       GFP_KERNEL);
+	if (!arc_pmu)
+		return -ENOMEM;
+
+	arc_pmu->n_counters = pct_bcr.c;
+	BUG_ON(arc_pmu->n_counters > ARC_PMU_MAX_HWEVENTS);
+
+	arc_pmu->counter_size = 32 + (pct_bcr.s << 4);
+	pr_info("ARC PMU found with %d counters of size %d bits\n",
+		arc_pmu->n_counters, arc_pmu->counter_size);
+
+	READ_BCR(ARC_REG_CC_BUILD, cc_bcr);
+
+	if (!cc_bcr.v)
+		pr_err("Strange! Performance counters exist, but no countable conditions?\n");
+
+	pr_info("ARC PMU has %d countable conditions\n", cc_bcr.c);
+
+	cc_name.str[8] = 0;
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++)
+		arc_pmu->ev_hw_idx[i] = -1;
+
+	for (j = 0; j < cc_bcr.c; j++) {
+		write_aux_reg(ARC_REG_CC_INDEX, j);
+		cc_name.indiv.word0 = read_aux_reg(ARC_REG_CC_NAME0);
+		cc_name.indiv.word1 = read_aux_reg(ARC_REG_CC_NAME1);
+		for (i = 0; i < ARRAY_SIZE(arc_pmu_ev_hw_map); i++) {
+			if (arc_pmu_ev_hw_map[i] &&
+			    !strcmp(arc_pmu_ev_hw_map[i], cc_name.str) &&
+			    strlen(arc_pmu_ev_hw_map[i])) {
+				pr_debug("mapping %d to idx %d with name %s\n",
+					 i, j, cc_name.str);
+				arc_pmu->ev_hw_idx[i] = j;
+			}
+		}
+	}
+
+	arc_pmu->pmu = (struct pmu) {
+		.pmu_enable	= arc_pmu_enable,
+		.pmu_disable	= arc_pmu_disable,
+		.event_init	= arc_pmu_event_init,
+		.add		= arc_pmu_add,
+		.del		= arc_pmu_del,
+		.start		= arc_pmu_start,
+		.stop		= arc_pmu_stop,
+		.read		= arc_pmu_read,
+	};
+
+	ret = perf_pmu_register(&arc_pmu->pmu, pdev->name, PERF_TYPE_RAW);
+
+	return ret;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id arc_pmu_match[] = {
+	{ .compatible = "snps,arc700-pmu" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, arc_pmu_match);
+#endif
+
+static struct platform_driver arc_pmu_driver = {
+	.driver	= {
+		.name		= "arc700-pmu",
+		.of_match_table = of_match_ptr(arc_pmu_match),
+	},
+	.probe		= arc_pmu_device_probe,
+};
+
+module_platform_driver(arc_pmu_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mischa Jonker <mjonker@synopsys.com>");
+MODULE_DESCRIPTION("ARC PMU driver");
-- 
1.7.9.5

