Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3HJRx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:53:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40691 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab3HJRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:53:27 -0400
Date: Sat, 10 Aug 2013 10:52:57 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Stephane Eranian <eranian@google.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 7/7] powerpc/perf: Export Power7 memory hierarchy info to
 user space
Message-ID: <20130810175256.GH15551@us.ibm.com>
References: <20130810174831.GA15551@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130810174831.GA15551@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081017-4834-0000-0000-00000A060DBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 7/7] powerpc/perf: Export Power7 memory hierarchy info to user space.

On Power7, the DCACHE_SRC field in MMCRA register identify the memory
hierarchy level (eg: L1, L2 etc) from which a data-cache miss for a
marked instruction was satisfied.

Use the 'perf_mem_data_src' object to export this hierarchy level to user
space. Some memory hierarchy levels in Power7 don't map into the arch-neutral
levels. However, since newer generation of the processor (i.e. Power8) uses
fewer levels than in Power7, we don't really need to define new hierarchy
levels just for Power7.

We instead, map as many levels as possible and approximate the rest. See
comments near dcache-src_map[] in the patch.

The hierarchy level information could be used with 'perf record --data'
or 'perf mem' command to analyze application behavior.

Usage:

	perf mem record <application>
	perf mem report

	OR

	perf record --data <application>
	perf report -D

	Sample records contain a 'data_src' field which encodes the memory
	hierarchy level: Eg: data_src 0x442 indicates MEM_OP_LOAD, MEM_LVL_HIT,
	MEM_LVL_L2 (i.e load hit L2).

Cc: Stephane Eranian <eranian@google.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Thanks to input from Stephane Eranian and Michael Ellerman.

Changelog[v3]:
	[Michael Ellerman] If newer levels that we defined in [v2] are not
	needed for Power8, ignore the new levels for Power7 also, and
	approximate them.
	Separate the TLB level mapping to a separate patchset.

Changelog[v2]:
        [Stephane Eranian] Define new levels rather than ORing the L2 and L3
        with REM_CCE1 and REM_CCE2.
        [Stephane Eranian] allocate a bit PERF_MEM_XLVL_NA for architectures
        that don't use the ->mem_xlvl field.
        Insert the TLB patch ahead so the new TLB bits are contigous with
        existing TLB bits.

 arch/powerpc/perf/power7-pmu.c |   65 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 161861d..f8143d6 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -329,6 +329,70 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
 }
 
+#define POWER7_MMCRA_DCACHE_MISS	(0x1LL << 55)
+#define POWER7_MMCRA_DCACHE_SRC_SHIFT	51
+#define POWER7_MMCRA_DCACHE_SRC_MASK	(0xFLL << POWER7_MMCRA_DCACHE_SRC_SHIFT)
+
+#define P(a, b)		PERF_MEM_S(a, b)
+#define PLH(a, b)	(P(OP, LOAD) | P(LVL, HIT) | P(a, b))
+/*
+ * Map the Power7 DCACHE_SRC field (bits 9..12) in MMCRA register to the
+ * architecture-neutral memory hierarchy levels. For the levels in Power7
+ * that don't map to the arch-neutral levels, approximate to nearest
+ * level.
+ *
+ *	1-hop:	indicates another core on the same chip (2.1 and 3.1 levels).
+ *	2-hops:	indicates a different chip on same or different node (remote
+ *		and distant levels).
+ *
+ * For consistency with this interpretation of the hops, we dont use
+ * the REM_RAM1 level below.
+ *
+ * The *SHR and *MOD states of the cache are ignored/not exported to user.
+ *
+ * ### Levels marked with ### in comments below are approximated
+ */
+static u64 dcache_src_map[] = {
+	PLH(LVL, L2),			/* 00: FROM_L2 */
+	PLH(LVL, L3),			/* 01: FROM_L3 */
+
+	P(LVL, NA),			/* 02: Reserved */
+	P(LVL, NA),			/* 03: Reserved */
+
+	PLH(LVL, REM_CCE1),		/* 04: FROM_L2.1_SHR ### */
+	PLH(LVL, REM_CCE1),		/* 05: FROM_L2.1_MOD ### */
+
+	PLH(LVL, REM_CCE1),		/* 06: FROM_L3.1_SHR ### */
+	PLH(LVL, REM_CCE1),		/* 07: FROM_L3.1_MOD ### */
+
+	PLH(LVL, REM_CCE2),		/* 08: FROM_RL2L3_SHR ### */
+	PLH(LVL, REM_CCE2),		/* 09: FROM_RL2L3_MOD ### */
+
+	PLH(LVL, REM_CCE2),		/* 10: FROM_DL2L3_SHR ### */
+	PLH(LVL, REM_CCE2),		/* 11: FROM_DL2L3_MOD ### */
+
+	PLH(LVL, LOC_RAM),		/* 12: FROM_LMEM */
+	PLH(LVL, REM_RAM2),		/* 13: FROM_RMEM ### */
+	PLH(LVL, REM_RAM2),		/* 14: FROM_DMEM */
+
+	P(LVL, NA),			/* 15: Reserved */
+};
+
+static void power7_get_mem_data_src(union perf_mem_data_src *dsrc,
+			struct pt_regs *regs)
+{
+	u64 idx;
+	u64 mmcra = regs->dsisr;
+
+	if (mmcra & POWER7_MMCRA_DCACHE_MISS) {
+		idx = mmcra & POWER7_MMCRA_DCACHE_SRC_MASK;
+		idx >>= POWER7_MMCRA_DCACHE_SRC_SHIFT;
+
+		dsrc->val |= dcache_src_map[idx];
+	}
+}
+
+
 static int power7_generic_events[] = {
 	[PERF_COUNT_HW_CPU_CYCLES] =			PME_PM_CYC,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PME_PM_GCT_NOSLOT_CYC,
@@ -453,6 +517,7 @@ static struct power_pmu power7_pmu = {
 	.get_constraint		= power7_get_constraint,
 	.get_alternatives	= power7_get_alternatives,
 	.disable_pmc		= power7_disable_pmc,
+	.get_mem_data_src	= power7_get_mem_data_src,
 	.flags			= PPMU_ALT_SIPR,
 	.attr_groups		= power7_pmu_attr_groups,
 	.n_generic		= ARRAY_SIZE(power7_generic_events),
-- 
1.7.1

