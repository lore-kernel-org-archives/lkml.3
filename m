Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaJ2LE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:04:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaJ2LEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:04:54 -0400
Date: Wed, 29 Oct 2014 04:03:37 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-1776b10627e486dd431fe72d8d47e5a865cf65d1@git.kernel.org>
Cc: ak@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, acme@redhat.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        acme@redhat.com, peterz@infradead.org, torvalds@linux-foundation.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <1409683455-29168-3-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Revert incomplete and undocumented Broadwell client support
Git-Commit-ID: 1776b10627e486dd431fe72d8d47e5a865cf65d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1776b10627e486dd431fe72d8d47e5a865cf65d1
Gitweb:     http://git.kernel.org/tip/1776b10627e486dd431fe72d8d47e5a865cf65d1
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 29 Oct 2014 10:18:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 29 Oct 2014 11:07:58 +0100

perf/x86/intel: Revert incomplete and undocumented Broadwell client support

These patches:

  86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
  c46e665f0377 ("perf/x86: Add INST_RETIRED.ALL workarounds")
  fdda3c4aacec ("perf/x86/intel: Use Broadwell cache event list for Haswell")

introduced magic constants and unexplained changes:

  https://lkml.org/lkml/2014/10/28/1128
  https://lkml.org/lkml/2014/10/27/325
  https://lkml.org/lkml/2014/8/27/546
  https://lkml.org/lkml/2014/10/28/546

Peter Zijlstra has attempted to help out, to clean up the mess:

  https://lkml.org/lkml/2014/10/28/543

But has not received helpful and constructive replies which makes
me doubt wether it can all be finished in time until v3.18 is
released.

Despite various review feedback the author (Andi Kleen) has answered
only few of the review questions and has generally been uncooperative,
only giving replies when prompted repeatedly, and only giving minimal
answers instead of constructively explaining and helping along the effort.

That kind of behavior is not acceptable.

There's also a boot crash on Intel E5-1630 v3 CPUs reported for another
commit from Andi Kleen:

  e735b9db12d7 ("perf/x86/intel/uncore: Add Haswell-EP uncore support")

  https://lkml.org/lkml/2014/10/22/730

Which is not yet resolved. The uncore driver is independent in theory,
but the crash makes me worry about how well all these patches were
tested and makes me uneasy about the level of interminging that the
Broadwell and Haswell code has received by the commits above.

As a first step to resolve the mess revert the Broadwell client commits
back to the v3.17 version, before we run out of time and problematic
code hits a stable upstream kernel.

( If the Haswell-EP crash is not resolved via a simple fix then we'll have
  to revert the Haswell-EP uncore driver as well. )

The Broadwell client series has to be submitted in a clean fashion, with
single, well documented changes per patch. If they are submitted in time
and are accepted during review then they can possibly go into v3.19 but
will need additional scrutiny due to the rocky history of this patch set.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409683455-29168-3-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c       |   9 --
 arch/x86/kernel/cpu/perf_event.h       |   1 -
 arch/x86/kernel/cpu/perf_event_intel.c | 173 +--------------------------------
 3 files changed, 2 insertions(+), 181 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 66451a6..143e5f5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -445,12 +445,6 @@ int x86_pmu_hw_config(struct perf_event *event)
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
 
@@ -988,9 +982,6 @@ int x86_perf_event_set_period(struct perf_event *event)
 	if (left > x86_pmu.max_period)
 		left = x86_pmu.max_period;
 
-	if (x86_pmu.limit_period)
-		left = x86_pmu.limit_period(event, left);
-
 	per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d98a34d..fc5eb39 100644
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
index a73947c..944bf01 100644
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
