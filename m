Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaJaLNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:13:43 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51167 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbaJaLNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:13:40 -0400
Date: Fri, 31 Oct 2014 12:13:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20141031111332.GA26137@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: d785452c9972fac2808479eb561d5c426b6e7d3b Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Mostly tooling fixes, plus on the kernel side:

 - a revert for a newly introduced PMU driver which isn't
   complete yet and where we ran out of time with fixes (to be 
   tried again in v3.19) - this makes up for a large chunk of the 
   diffstat.

 - compilation warning fixes

 - a printk message fix

 - event_idx usage fixes/cleanups.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      perf: Fix typos in sample code in the perf_event.h header

Ingo Molnar (1):
      perf/x86/intel: Revert incomplete and undocumented Broadwell client support

Jiri Olsa (7):
      perf tools: Fix report -F abort for data without branch info
      perf tools: Fix report -F in_tx for data without branch info
      perf tools: Fix report -F mispredict for data without branch info
      perf tools: Fix report -F symbol_to for data without branch info
      perf tools: Fix report -F symbol_from for data without branch info
      perf tools: Fix report -F dso_to for data without branch info
      perf tools: Fix report -F dso_from for data without branch info

Kan Liang (1):
      perf diff: Add missing hists__init() call at tool start

Masami Hiramatsu (1):
      perf probe: Trivial typo fix for --demangle

Namhyung Kim (1):
      perf callchain: Use global caching provided by libunwind

Peter Zijlstra (2):
      perf: Fix and clean up initialization of pmu::event_idx
      perf/x86: Fix compile warnings for intel_uncore

Peter Zijlstra (Intel) (1):
      perf: Fix bogus kernel printk

Wang Nan (1):
      perf tools: Make CPUINFO_PROC an array to support different kernel versions


 arch/powerpc/perf/hv-24x7.c            |   6 --
 arch/powerpc/perf/hv-gpci.c            |   6 --
 arch/s390/kernel/perf_cpum_sf.c        |   6 --
 arch/x86/Kconfig                       |   4 +
 arch/x86/kernel/cpu/Makefile           |   7 +-
 arch/x86/kernel/cpu/perf_event.c       |  14 +--
 arch/x86/kernel/cpu/perf_event.h       |   1 -
 arch/x86/kernel/cpu/perf_event_intel.c | 173 +--------------------------------
 include/uapi/linux/perf_event.h        |  14 +--
 kernel/events/core.c                   |  15 +--
 kernel/events/hw_breakpoint.c          |   7 --
 tools/perf/builtin-diff.c              |   5 +
 tools/perf/builtin-probe.c             |   2 +-
 tools/perf/perf-sys.h                  |  30 +++---
 tools/perf/util/header.c               |  27 +++--
 tools/perf/util/sort.c                 | 102 ++++++++++++++-----
 tools/perf/util/thread.c               |   3 +
 tools/perf/util/unwind-libunwind.c     |  12 +++
 tools/perf/util/unwind.h               |   3 +
 19 files changed, 158 insertions(+), 279 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 6c8710dd90c9..dba34088da28 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -417,11 +417,6 @@ static int h_24x7_event_add(struct perf_event *event, int flags)
 	return 0;
 }
 
-static int h_24x7_event_idx(struct perf_event *event)
-{
-	return 0;
-}
-
 static struct pmu h_24x7_pmu = {
 	.task_ctx_nr = perf_invalid_context,
 
@@ -433,7 +428,6 @@ static struct pmu h_24x7_pmu = {
 	.start       = h_24x7_event_start,
 	.stop        = h_24x7_event_stop,
 	.read        = h_24x7_event_update,
-	.event_idx   = h_24x7_event_idx,
 };
 
 static int hv_24x7_init(void)
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 15fc76c93022..a051fe946c63 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -246,11 +246,6 @@ static int h_gpci_event_init(struct perf_event *event)
 	return 0;
 }
 
-static int h_gpci_event_idx(struct perf_event *event)
-{
-	return 0;
-}
-
 static struct pmu h_gpci_pmu = {
 	.task_ctx_nr = perf_invalid_context,
 
@@ -262,7 +257,6 @@ static struct pmu h_gpci_pmu = {
 	.start       = h_gpci_event_start,
 	.stop        = h_gpci_event_stop,
 	.read        = h_gpci_event_update,
-	.event_idx   = h_gpci_event_idx,
 };
 
 static int hv_gpci_init(void)
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 08e761318c17..b878f12a9597 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1411,11 +1411,6 @@ static void cpumsf_pmu_del(struct perf_event *event, int flags)
 	perf_pmu_enable(event->pmu);
 }
 
-static int cpumsf_pmu_event_idx(struct perf_event *event)
-{
-	return event->hw.idx;
-}
-
 CPUMF_EVENT_ATTR(SF, SF_CYCLES_BASIC, PERF_EVENT_CPUM_SF);
 CPUMF_EVENT_ATTR(SF, SF_CYCLES_BASIC_DIAG, PERF_EVENT_CPUM_SF_DIAG);
 
@@ -1458,7 +1453,6 @@ static struct pmu cpumf_sampling = {
 	.stop	      = cpumsf_pmu_stop,
 	.read	      = cpumsf_pmu_read,
 
-	.event_idx    = cpumsf_pmu_event_idx,
 	.attr_groups  = cpumsf_pmu_attr_groups,
 };
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e88e07c..ded8a6774ac9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -142,6 +142,10 @@ config INSTRUCTION_DECODER
 	def_bool y
 	depends on KPROBES || PERF_EVENTS || UPROBES
 
+config PERF_EVENTS_INTEL_UNCORE
+	def_bool y
+	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI
+
 config OUTPUT_FORMAT
 	string
 	default "elf32-i386" if X86_32
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 01d5453b5502..e27b49d7c922 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -39,9 +39,12 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
 endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
+
+obj-$(CONFIG_PERF_EVENTS_INTEL_UNCORE)	+= perf_event_intel_uncore.o \
+					   perf_event_intel_uncore_snb.o \
+					   perf_event_intel_uncore_snbep.o \
+					   perf_event_intel_uncore_nhmex.o
 endif
 
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1b8299dd3d91..143e5f5dc855 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -243,8 +243,9 @@ static bool check_hw_exists(void)
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
-	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
-	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
+	printk("%sFailed to access perfctr msr (MSR %x is %Lx)\n",
+		boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR,
+		reg, val_new);
 
 	return false;
 }
@@ -444,12 +445,6 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
-	if (event->attr.sample_period && x86_pmu.limit_period) {
-		if (x86_pmu.limit_period(event, event->attr.sample_period) >
-				event->attr.sample_period)
-			return -EINVAL;
-	}
-
 	return x86_setup_perfctr(event);
 }
 
@@ -987,9 +982,6 @@ int x86_perf_event_set_period(struct perf_event *event)
 	if (left > x86_pmu.max_period)
 		left = x86_pmu.max_period;
 
-	if (x86_pmu.limit_period)
-		left = x86_pmu.limit_period(event, left);
-
 	per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d98a34d435d7..fc5eb390b368 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -445,7 +445,6 @@ struct x86_pmu {
 	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
 	bool		late_ack;
-	unsigned	(*limit_period)(struct perf_event *event, unsigned l);
 
 	/*
 	 * sysfs attrs
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a73947c53b65..944bf019b74f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -220,15 +220,6 @@ static struct event_constraint intel_hsw_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_bdw_event_constraints[] = {
-	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
-	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
-	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
-	INTEL_UEVENT_CONSTRAINT(0x148, 0x4),	/* L1D_PEND_MISS.PENDING */
-	INTEL_EVENT_CONSTRAINT(0xa3, 0x4),	/* CYCLE_ACTIVITY.* */
-	EVENT_CONSTRAINT_END
-};
-
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -424,126 +415,6 @@ static __initconst const u64 snb_hw_cache_event_ids
 
 };
 
-static __initconst const u64 hsw_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(L1D ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x81d0, 	/* MEM_UOPS_RETIRED.ALL_LOADS */
-		[ C(RESULT_MISS)   ] = 0x151, 	/* L1D.REPLACEMENT */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x82d0, 	/* MEM_UOPS_RETIRED.ALL_STORES */
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x280, 	/* ICACHE.MISSES */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
-		[ C(RESULT_ACCESS) ] = 0x1b7,
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
-                   L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x1b7,
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x1b7, 	/* OFFCORE_RESPONSE:ALL_RFO */
-		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x1b7,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x81d0, 	/* MEM_UOPS_RETIRED.ALL_LOADS */
-		[ C(RESULT_MISS)   ] = 0x108, 	/* DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x82d0, 	/* MEM_UOPS_RETIRED.ALL_STORES */
-		[ C(RESULT_MISS)   ] = 0x149, 	/* DTLB_STORE_MISSES.MISS_CAUSES_A_WALK */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x6085, 	/* ITLB_MISSES.STLB_HIT */
-		[ C(RESULT_MISS)   ] = 0x185, 	/* ITLB_MISSES.MISS_CAUSES_A_WALK */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0xc4, 	/* BR_INST_RETIRED.ALL_BRANCHES */
-		[ C(RESULT_MISS)   ] = 0xc5, 	/* BR_MISP_RETIRED.ALL_BRANCHES */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
-};
-
-static __initconst const u64 hsw_hw_cache_extra_regs
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
-		[ C(RESULT_ACCESS) ] = 0x2d5,
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
-                   L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x3fbc0202d5ull,
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x122, 	/* OFFCORE_RESPONSE:ALL_RFO */
-		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x3fbc020122ull,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
-};
-
 static __initconst const u64 westmere_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -2034,24 +1905,6 @@ hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	return c;
 }
 
-/*
- * Broadwell:
- * The INST_RETIRED.ALL period always needs to have lowest
- * 6bits cleared (BDM57). It shall not use a period smaller
- * than 100 (BDM11). We combine the two to enforce
- * a min-period of 128.
- */
-static unsigned bdw_limit_period(struct perf_event *event, unsigned left)
-{
-	if ((event->hw.config & INTEL_ARCH_EVENT_MASK) ==
-			X86_CONFIG(.event=0xc0, .umask=0x01)) {
-		if (left < 128)
-			left = 128;
-		left &= ~0x3fu;
-	}
-	return left;
-}
-
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -2692,8 +2545,8 @@ __init int intel_pmu_init(void)
 	case 69: /* 22nm Haswell ULT */
 	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
 		x86_pmu.late_ack = true;
-		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-		memcpy(hw_cache_extra_regs, hsw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_snb();
 
@@ -2712,28 +2565,6 @@ __init int intel_pmu_init(void)
 		pr_cont("Haswell events, ");
 		break;
 
-	case 61: /* 14nm Broadwell Core-M */
-		x86_pmu.late_ack = true;
-		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-		memcpy(hw_cache_extra_regs, hsw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-
-		intel_pmu_lbr_init_snb();
-
-		x86_pmu.event_constraints = intel_bdw_event_constraints;
-		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
-		x86_pmu.extra_regs = intel_snbep_extra_regs;
-		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
-
-		x86_pmu.hw_config = hsw_hw_config;
-		x86_pmu.get_event_constraints = hsw_get_event_constraints;
-		x86_pmu.cpu_events = hsw_events_attrs;
-		x86_pmu.limit_period = bdw_limit_period;
-		pr_cont("Broadwell events, ");
-		break;
-
 	default:
 		switch (x86_pmu.version) {
 		case 1:
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9269de254874..9d845404d875 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -364,7 +364,7 @@ struct perf_event_mmap_page {
 	/*
 	 * Bits needed to read the hw events in user-space.
 	 *
-	 *   u32 seq, time_mult, time_shift, idx, width;
+	 *   u32 seq, time_mult, time_shift, index, width;
 	 *   u64 count, enabled, running;
 	 *   u64 cyc, time_offset;
 	 *   s64 pmc = 0;
@@ -383,11 +383,11 @@ struct perf_event_mmap_page {
 	 *       time_shift  = pc->time_shift;
 	 *     }
 	 *
-	 *     idx = pc->index;
+	 *     index = pc->index;
 	 *     count = pc->offset;
-	 *     if (pc->cap_usr_rdpmc && idx) {
+	 *     if (pc->cap_user_rdpmc && index) {
 	 *       width = pc->pmc_width;
-	 *       pmc = rdpmc(idx - 1);
+	 *       pmc = rdpmc(index - 1);
 	 *     }
 	 *
 	 *     barrier();
@@ -415,7 +415,7 @@ struct perf_event_mmap_page {
 	};
 
 	/*
-	 * If cap_usr_rdpmc this field provides the bit-width of the value
+	 * If cap_user_rdpmc this field provides the bit-width of the value
 	 * read using the rdpmc() or equivalent instruction. This can be used
 	 * to sign extend the result like:
 	 *
@@ -439,10 +439,10 @@ struct perf_event_mmap_page {
 	 *
 	 * Where time_offset,time_mult,time_shift and cyc are read in the
 	 * seqcount loop described above. This delta can then be added to
-	 * enabled and possible running (if idx), improving the scaling:
+	 * enabled and possible running (if index), improving the scaling:
 	 *
 	 *   enabled += delta;
-	 *   if (idx)
+	 *   if (index)
 	 *     running += delta;
 	 *
 	 *   quot = count / running;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1425d07018de..2b02c9fda790 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6071,11 +6071,6 @@ static int perf_swevent_init(struct perf_event *event)
 	return 0;
 }
 
-static int perf_swevent_event_idx(struct perf_event *event)
-{
-	return 0;
-}
-
 static struct pmu perf_swevent = {
 	.task_ctx_nr	= perf_sw_context,
 
@@ -6085,8 +6080,6 @@ static struct pmu perf_swevent = {
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-
-	.event_idx	= perf_swevent_event_idx,
 };
 
 #ifdef CONFIG_EVENT_TRACING
@@ -6204,8 +6197,6 @@ static struct pmu perf_tracepoint = {
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-
-	.event_idx	= perf_swevent_event_idx,
 };
 
 static inline void perf_tp_register(void)
@@ -6431,8 +6422,6 @@ static struct pmu perf_cpu_clock = {
 	.start		= cpu_clock_event_start,
 	.stop		= cpu_clock_event_stop,
 	.read		= cpu_clock_event_read,
-
-	.event_idx	= perf_swevent_event_idx,
 };
 
 /*
@@ -6511,8 +6500,6 @@ static struct pmu perf_task_clock = {
 	.start		= task_clock_event_start,
 	.stop		= task_clock_event_stop,
 	.read		= task_clock_event_read,
-
-	.event_idx	= perf_swevent_event_idx,
 };
 
 static void perf_pmu_nop_void(struct pmu *pmu)
@@ -6542,7 +6529,7 @@ static void perf_pmu_cancel_txn(struct pmu *pmu)
 
 static int perf_event_idx_default(struct perf_event *event)
 {
-	return event->hw.idx + 1;
+	return 0;
 }
 
 /*
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 1559fb0b9296..9803a6600d49 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -605,11 +605,6 @@ static void hw_breakpoint_stop(struct perf_event *bp, int flags)
 	bp->hw.state = PERF_HES_STOPPED;
 }
 
-static int hw_breakpoint_event_idx(struct perf_event *bp)
-{
-	return 0;
-}
-
 static struct pmu perf_breakpoint = {
 	.task_ctx_nr	= perf_sw_context, /* could eventually get its own */
 
@@ -619,8 +614,6 @@ static struct pmu perf_breakpoint = {
 	.start		= hw_breakpoint_start,
 	.stop		= hw_breakpoint_stop,
 	.read		= hw_breakpoint_pmu_read,
-
-	.event_idx	= hw_breakpoint_event_idx,
 };
 
 int __init init_hw_breakpoint(void)
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8c5c11ca8c53..25114c9a6801 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1142,6 +1142,11 @@ static int data_init(int argc, const char **argv)
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
+
 	perf_config(perf_default_config, NULL);
 
 	argc = parse_options(argc, argv, options, diff_usage, 0);
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 04412b4770a2..7af26acf06d9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -375,7 +375,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('x', "exec", NULL, "executable|path",
 			"target executable name or path", opt_set_target),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
-		    "Disable symbol demangling"),
+		    "Enable symbol demangling"),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
 	OPT_END()
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 937e4324ad94..a3b13d7dc1d4 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -13,7 +13,7 @@
 #define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
+#define CPUINFO_PROC	{"model name"}
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 336
 #endif
@@ -30,7 +30,7 @@
 #define wmb()		asm volatile("sfence" ::: "memory")
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
+#define CPUINFO_PROC	{"model name"}
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 298
 #endif
@@ -47,14 +47,14 @@
 #define mb()		asm volatile ("sync" ::: "memory")
 #define wmb()		asm volatile ("sync" ::: "memory")
 #define rmb()		asm volatile ("sync" ::: "memory")
-#define CPUINFO_PROC	"cpu"
+#define CPUINFO_PROC	{"cpu"}
 #endif
 
 #ifdef __s390__
 #define mb()		asm volatile("bcr 15,0" ::: "memory")
 #define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
-#define CPUINFO_PROC	"vendor_id"
+#define CPUINFO_PROC	{"vendor_id"}
 #endif
 
 #ifdef __sh__
@@ -67,14 +67,14 @@
 # define wmb()		asm volatile("" ::: "memory")
 # define rmb()		asm volatile("" ::: "memory")
 #endif
-#define CPUINFO_PROC	"cpu type"
+#define CPUINFO_PROC	{"cpu type"}
 #endif
 
 #ifdef __hppa__
 #define mb()		asm volatile("" ::: "memory")
 #define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"cpu"
+#define CPUINFO_PROC	{"cpu"}
 #endif
 
 #ifdef __sparc__
@@ -87,14 +87,14 @@
 #endif
 #define wmb()		asm volatile("":::"memory")
 #define rmb()		asm volatile("":::"memory")
-#define CPUINFO_PROC	"cpu"
+#define CPUINFO_PROC	{"cpu"}
 #endif
 
 #ifdef __alpha__
 #define mb()		asm volatile("mb" ::: "memory")
 #define wmb()		asm volatile("wmb" ::: "memory")
 #define rmb()		asm volatile("mb" ::: "memory")
-#define CPUINFO_PROC	"cpu model"
+#define CPUINFO_PROC	{"cpu model"}
 #endif
 
 #ifdef __ia64__
@@ -102,7 +102,7 @@
 #define wmb()		asm volatile ("mf" ::: "memory")
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
-#define CPUINFO_PROC	"model name"
+#define CPUINFO_PROC	{"model name"}
 #endif
 
 #ifdef __arm__
@@ -113,7 +113,7 @@
 #define mb()		((void(*)(void))0xffff0fa0)()
 #define wmb()		((void(*)(void))0xffff0fa0)()
 #define rmb()		((void(*)(void))0xffff0fa0)()
-#define CPUINFO_PROC	"Processor"
+#define CPUINFO_PROC	{"model name", "Processor"}
 #endif
 
 #ifdef __aarch64__
@@ -133,28 +133,28 @@
 				: "memory")
 #define wmb()	mb()
 #define rmb()	mb()
-#define CPUINFO_PROC	"cpu model"
+#define CPUINFO_PROC	{"cpu model"}
 #endif
 
 #ifdef __arc__
 #define mb()		asm volatile("" ::: "memory")
 #define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"Processor"
+#define CPUINFO_PROC	{"Processor"}
 #endif
 
 #ifdef __metag__
 #define mb()		asm volatile("" ::: "memory")
 #define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"CPU"
+#define CPUINFO_PROC	{"CPU"}
 #endif
 
 #ifdef __xtensa__
 #define mb()		asm volatile("memw" ::: "memory")
 #define wmb()		asm volatile("memw" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"core ID"
+#define CPUINFO_PROC	{"core ID"}
 #endif
 
 #ifdef __tile__
@@ -162,7 +162,7 @@
 #define wmb()		asm volatile ("mf" ::: "memory")
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
-#define CPUINFO_PROC    "model name"
+#define CPUINFO_PROC    {"model name"}
 #endif
 
 #define barrier() asm volatile ("" ::: "memory")
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ce0de00399da..26f5b2fe5dc8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -579,16 +579,12 @@ static int write_version(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, perf_version_string);
 }
 
-static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
-		       struct perf_evlist *evlist __maybe_unused)
+static int __write_cpudesc(int fd, const char *cpuinfo_proc)
 {
-#ifndef CPUINFO_PROC
-#define CPUINFO_PROC NULL
-#endif
 	FILE *file;
 	char *buf = NULL;
 	char *s, *p;
-	const char *search = CPUINFO_PROC;
+	const char *search = cpuinfo_proc;
 	size_t len = 0;
 	int ret = -1;
 
@@ -638,6 +634,25 @@ static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
 	return ret;
 }
 
+static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
+		       struct perf_evlist *evlist __maybe_unused)
+{
+#ifndef CPUINFO_PROC
+#define CPUINFO_PROC {"model name", }
+#endif
+	const char *cpuinfo_procs[] = CPUINFO_PROC;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cpuinfo_procs); i++) {
+		int ret;
+		ret = __write_cpudesc(fd, cpuinfo_procs[i]);
+		if (ret >= 0)
+			return ret;
+	}
+	return -1;
+}
+
+
 static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
 			struct perf_evlist *evlist __maybe_unused)
 {
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 4906cd81cb56..9402885a77f3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -373,6 +373,9 @@ struct sort_entry sort_cpu = {
 static int64_t
 sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return _sort__dso_cmp(left->branch_info->from.map,
 			      right->branch_info->from.map);
 }
@@ -380,13 +383,19 @@ sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__dso_from_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->branch_info->from.map,
-					 bf, size, width);
+	if (he->branch_info)
+		return _hist_entry__dso_snprintf(he->branch_info->from.map,
+						 bf, size, width);
+	else
+		return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 static int64_t
 sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return _sort__dso_cmp(left->branch_info->to.map,
 			      right->branch_info->to.map);
 }
@@ -394,8 +403,11 @@ sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__dso_to_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->branch_info->to.map,
-					 bf, size, width);
+	if (he->branch_info)
+		return _hist_entry__dso_snprintf(he->branch_info->to.map,
+						 bf, size, width);
+	else
+		return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 static int64_t
@@ -404,6 +416,12 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct addr_map_symbol *from_l = &left->branch_info->from;
 	struct addr_map_symbol *from_r = &right->branch_info->from;
 
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
+	from_l = &left->branch_info->from;
+	from_r = &right->branch_info->from;
+
 	if (!from_l->sym && !from_r->sym)
 		return _sort__addr_cmp(from_l->addr, from_r->addr);
 
@@ -413,8 +431,13 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 static int64_t
 sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct addr_map_symbol *to_l = &left->branch_info->to;
-	struct addr_map_symbol *to_r = &right->branch_info->to;
+	struct addr_map_symbol *to_l, *to_r;
+
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
+	to_l = &left->branch_info->to;
+	to_r = &right->branch_info->to;
 
 	if (!to_l->sym && !to_r->sym)
 		return _sort__addr_cmp(to_l->addr, to_r->addr);
@@ -425,19 +448,27 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__sym_from_snprintf(struct hist_entry *he, char *bf,
 					 size_t size, unsigned int width)
 {
-	struct addr_map_symbol *from = &he->branch_info->from;
-	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
-					 he->level, bf, size, width);
+	if (he->branch_info) {
+		struct addr_map_symbol *from = &he->branch_info->from;
 
+		return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
+						 he->level, bf, size, width);
+	}
+
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 static int hist_entry__sym_to_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
-	struct addr_map_symbol *to = &he->branch_info->to;
-	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
-					 he->level, bf, size, width);
+	if (he->branch_info) {
+		struct addr_map_symbol *to = &he->branch_info->to;
 
+		return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
+						 he->level, bf, size, width);
+	}
+
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 struct sort_entry sort_dso_from = {
@@ -471,11 +502,13 @@ struct sort_entry sort_sym_to = {
 static int64_t
 sort__mispredict_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	const unsigned char mp = left->branch_info->flags.mispred !=
-					right->branch_info->flags.mispred;
-	const unsigned char p = left->branch_info->flags.predicted !=
-					right->branch_info->flags.predicted;
+	unsigned char mp, p;
+
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
 
+	mp = left->branch_info->flags.mispred != right->branch_info->flags.mispred;
+	p  = left->branch_info->flags.predicted != right->branch_info->flags.predicted;
 	return mp || p;
 }
 
@@ -483,10 +516,12 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width){
 	static const char *out = "N/A";
 
-	if (he->branch_info->flags.predicted)
-		out = "N";
-	else if (he->branch_info->flags.mispred)
-		out = "Y";
+	if (he->branch_info) {
+		if (he->branch_info->flags.predicted)
+			out = "N";
+		else if (he->branch_info->flags.mispred)
+			out = "Y";
+	}
 
 	return repsep_snprintf(bf, size, "%-*.*s", width, width, out);
 }
@@ -989,6 +1024,9 @@ struct sort_entry sort_mem_dcacheline = {
 static int64_t
 sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return left->branch_info->flags.abort !=
 		right->branch_info->flags.abort;
 }
@@ -996,10 +1034,15 @@ sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__abort_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	static const char *out = ".";
+	static const char *out = "N/A";
+
+	if (he->branch_info) {
+		if (he->branch_info->flags.abort)
+			out = "A";
+		else
+			out = ".";
+	}
 
-	if (he->branch_info->flags.abort)
-		out = "A";
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
@@ -1013,6 +1056,9 @@ struct sort_entry sort_abort = {
 static int64_t
 sort__in_tx_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return left->branch_info->flags.in_tx !=
 		right->branch_info->flags.in_tx;
 }
@@ -1020,10 +1066,14 @@ sort__in_tx_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__in_tx_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	static const char *out = ".";
+	static const char *out = "N/A";
 
-	if (he->branch_info->flags.in_tx)
-		out = "T";
+	if (he->branch_info) {
+		if (he->branch_info->flags.in_tx)
+			out = "T";
+		else
+			out = ".";
+	}
 
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 2b7b2d91c016..c41411726c7a 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -117,6 +117,9 @@ int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		if (!new)
 			return -ENOMEM;
 		list_add(&new->list, &thread->comm_list);
+
+		if (exec)
+			unwind__flush_access(thread);
 	}
 
 	thread->comm_set = true;
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index e060386165c5..4d45c0dfe343 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -539,11 +539,23 @@ int unwind__prepare_access(struct thread *thread)
 		return -ENOMEM;
 	}
 
+	unw_set_caching_policy(addr_space, UNW_CACHE_GLOBAL);
 	thread__set_priv(thread, addr_space);
 
 	return 0;
 }
 
+void unwind__flush_access(struct thread *thread)
+{
+	unw_addr_space_t addr_space;
+
+	if (callchain_param.record_mode != CALLCHAIN_DWARF)
+		return;
+
+	addr_space = thread__priv(thread);
+	unw_flush_cache(addr_space, 0, 0);
+}
+
 void unwind__finish_access(struct thread *thread)
 {
 	unw_addr_space_t addr_space;
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index c17c4855bdbc..f50b737235eb 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -23,6 +23,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 #ifdef HAVE_LIBUNWIND_SUPPORT
 int libunwind__arch_reg_id(int regnum);
 int unwind__prepare_access(struct thread *thread);
+void unwind__flush_access(struct thread *thread);
 void unwind__finish_access(struct thread *thread);
 #else
 static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
@@ -30,6 +31,7 @@ static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
 	return 0;
 }
 
+static inline void unwind__flush_access(struct thread *thread __maybe_unused) {}
 static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif
 #else
@@ -49,6 +51,7 @@ static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
 	return 0;
 }
 
+static inline void unwind__flush_access(struct thread *thread __maybe_unused) {}
 static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
