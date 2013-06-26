Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3FZHxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:53:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49569 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3FZHxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:53:19 -0400
Date: Wed, 26 Jun 2013 00:41:50 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: eranian@google.com, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>, ellerman@au1.ibm.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 2/3][v2] perf/Power7: Export MDTLB_SRC fields to
 userspace
Message-ID: <20130626074150.GB3741@us.ibm.com>
References: <20130626074106.GA3741@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626074106.GA3741@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13062607-3620-0000-0000-0000034A4947
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 25 Jun 2013 15:50:18 -0700
Subject: [RFC][PATCH 2/3][v2] perf/Power7: Export MDTLB_SRC fields to userspace

Power7 saves the "perf-event vector" information in the mmcra register.
Included in this event vector is a "marked-data-TLB source", MDTLB_SRC,
field which identifies where in the memory-hierarchy the data for a TLB
miss was eventually found.

Use the 'struct perf_mem_data_src' to export the MDTLB_SRC field to
user space.

The mapping between the Power7 hierarchy levels and the arch-neutral levels
is, unfortunately, not trivial. Some existing arch-neutral levels are unused
in Power (eg: TLB_L1, TLB_WK, TLB_OS). But, Power7 provides several other
levels for the MDTLB_SRC, so this patch proposes adding new arch-neutral
levels.

    Arch-neutral levels         Power7 levels
    -----------------------------------------------------------------------
    local    TLB_L2		local (same core) L2 (FROM_L2)
    local    TLB_L3		local (same core) L3 (FROM_L3)

    1-hop    TLB_REM_L2_CCE1*  different core on same chip (FROM_L2.1)
    1-hop    TLB_REM_L3_CCE1*  different core on same chip (FROM_L3.1)

    2-hops   TLB_REM_CCE2*	remote (different chip, same node) (FROM_RL2L3)
    3-hops   TLB_REM_CCE3*	distant (different node)  (FROM_DL2L3)

    1-hop    TLB_REM_RAM1*	unused
    2-hops   TLB_REM_RAM2*	remote (different chip, same node) (FROM_RMEM)
    3-hops   TLB_REM_RAM3*	distant (different node) (FROM_DMEM)

* proposed new levels.

As shown above, Power7 supports one extra level in the cache-hierarchy (i.e
total of 3-hops).  To maintain consistency in terminology (i.e 2-hops = remote,
3-hops = distant), we propose leaving the REM_RAM1 unused in Power7 and adding
another level, REM_RAM3.

Further, in the above REM_CCE1 case, Power7 can also identify if the data came
from the L2 or L3 cache of another core on the same chip. To describe this
add the levels:

	PERF_MEM_TLB_REM_L2_CCE1
	PERF_MEM_TLB_REM_L3_CCE1

Finally, in the REM_CCE1 and REM_CCE2 cases, Power7 also indicates whether
the entry found in the remote cache was modified (dirty). So we add a new
state

	PERF_MEM_TLB_CCE_DIRTY

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---

Changelog[v2]:
	- Address the MDTLB_SRC field before addressing the DCACHE_SRC field
	  since we can then keep the new ->mem_dtlb bits contigious.
	  (DCACHE_SRC needs a field, ->mem_xlvl in struct perf_mem_data_src
	  and will be added in the next patch)

 arch/powerpc/include/asm/perf_event_server.h |    2 +
 arch/powerpc/perf/core-book3s.c              |    4 ++
 arch/powerpc/perf/power7-pmu.c               |   64 ++++++++++++++++++++++++++
 include/uapi/linux/perf_event.h              |   14 +++++-
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index f265049..30488f5 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -37,6 +37,8 @@ struct power_pmu {
 	void            (*config_bhrb)(u64 pmu_bhrb_filter);
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
+	void		(*get_mem_data_src)(union perf_mem_data_src *dsrc,
+				struct pt_regs *regs);
 	u32		flags;
 	const struct attribute_group	**attr_groups;
 	int		n_generic;
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 29c6482..e0e0848 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1627,6 +1627,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			data.br_stack = &cpuhw->bhrb_stack;
 		}
 
+		if (event->attr.sample_type & PERF_SAMPLE_DATA_SRC &&
+				ppmu->get_mem_data_src)
+			ppmu->get_mem_data_src(&data.data_src, regs);
+
 		if (perf_event_overflow(event, &data, regs))
 			power_pmu_stop(event, 0);
 	}
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 3c475d6..c1cac96 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -209,6 +209,69 @@ static int power7_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 	return nalt;
 }
 
+#define	POWER7_MMCRA_MDTLB_MISS		(0x1LL << 50)
+#define	POWER7_MMCRA_MDTLB_SRC_SHIFT	46
+#define	POWER7_MMCRA_MDTLB_SRC_MASK	(0xFLL << POWER7_MMCRA_MDTLB_SRC_SHIFT)
+
+/*
+ * Map MDTLB_SRC fields to the Linux memory hierarchy levels.
+ *
+ * Bits 14..17 in the MMCRA indicate the source of a marked-data-TLB miss,
+ * with of the 16 possible values referring to a specific source. Eg: if
+ * the 4-bits have the value 1 (0b0001), the mdtlb entry was found in the
+ * local L3 cache.
+ *
+ * We use the table, mdtlb_src_map, to map the value in this field, to
+ * PERF_MEM_TLB_L3, the arch-neutral representation of TLB L3 cache.
+ *
+ * Architecture neutral to Power7 hierarchy levels:
+ *	1-hop  = different core on same chip (L2.1 or L3.1)
+ *	2-hops = remote (different chip on same node, RL2L3, RMEM)
+ *	3-hops = distant (different node, DL2L3, DMEM)
+ */
+#define P(a, b)			PERF_MEM_S(a, b)
+#define TD(a, b)		(P(TLB, CCE_DIRTY) | P(a, b))
+
+static u64 mdtlb_src_map[] = {
+	P(TLB,  L2),			/* 00: FROM_L2 */
+	P(TLB,  L3),			/* 01: FROM_L3 */
+
+	P(TLB,  NA),			/* 02: Reserved */
+	P(TLB,  NA),			/* 03: Reserved */
+
+	P(TLB,  REM_L2_CCE1),		/* 04: FROM_L2.1_SHR */
+	TD(TLB, REM_L2_CCE1),		/* 05: FROM_L2.1_MOD */
+
+	P(TLB,  REM_L3_CCE1),		/* 06: FROM_L3.1_SHR */
+	TD(TLB, REM_L3_CCE1),		/* 07: FROM_L3.1_MOD */
+
+	P(TLB,  REM_CCE2),		/* 08: FROM_RL2L3_SHR */
+	TD(TLB, REM_CCE2),		/* 09: FROM_RL2L3_MOD */
+
+	P(TLB,  REM_CCE3),		/* 10: FROM_DL2L3_SHR */
+	TD(TLB, REM_CCE3),		/* 11: FROM_DL2L3_MOD */
+
+	P(TLB,  LOC_RAM),		/* 12: FROM_LMEM */
+	P(TLB,  REM_RAM2),		/* 13: FROM_RMEM */
+	P(TLB,  REM_RAM3),		/* 14: FROM_DMEM */
+
+	P(TLB,  NA),			/* 15: Reserved */
+};
+
+static void power7_get_mem_data_src(union perf_mem_data_src *dsrc,
+				struct pt_regs *regs)
+{
+	u64 idx;
+	u64 mmcra = regs->dsisr;
+
+	if (mmcra & POWER7_MMCRA_MDTLB_MISS) {
+		idx = mmcra & POWER7_MMCRA_MDTLB_SRC_MASK;
+		idx >>= POWER7_MMCRA_MDTLB_SRC_SHIFT;
+
+		dsrc->val |= mdtlb_src_map[idx];
+	}
+}
+
 /*
  * Returns 1 if event counts things relating to marked instructions
  * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
@@ -447,6 +510,7 @@ static struct power_pmu power7_pmu = {
 	.compute_mmcr		= power7_compute_mmcr,
 	.get_constraint		= power7_get_constraint,
 	.get_alternatives	= power7_get_alternatives,
+	.get_mem_data_src	= power7_get_mem_data_src,
 	.disable_pmc		= power7_disable_pmc,
 	.flags			= PPMU_ALT_SIPR,
 	.attr_groups		= power7_pmu_attr_groups,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 52697a3..815ee12 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -626,8 +626,8 @@ union perf_mem_data_src {
 			mem_lvl:14,	/* memory hierarchy level */
 			mem_snoop:5,	/* snoop mode */
 			mem_lock:2,	/* lock instr */
-			mem_dtlb:7,	/* tlb access */
-			mem_rsvd:31;
+			mem_dtlb:17,	/* tlb access */
+			mem_rsvd:21;
 	};
 };
 
@@ -678,6 +678,16 @@ union perf_mem_data_src {
 #define PERF_MEM_TLB_L2		0x10 /* L2 */
 #define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
 #define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
+#define PERF_MEM_TLB_L3		0x80
+#define PERF_MEM_TLB_REM_L2_CCE1	0x100	/* Remote L2 cache (1 hop) */
+#define PERF_MEM_TLB_REM_L3_CCE1	0x200	/* Remote L3 cache (1 hop) */
+#define PERF_MEM_TLB_REM_CCE2	0x400	/* Remote cache (2 hops) */
+#define PERF_MEM_TLB_REM_CCE3	0x800	/* Remote cache (3 hops) */
+#define PERF_MEM_TLB_LOC_RAM	0x1000	/* Local DRAM */
+#define PERF_MEM_TLB_REM_RAM1	0x2000	/* Remote DRAM (1 hop) */
+#define PERF_MEM_TLB_REM_RAM2	0x4000	/* Remote DRAM (2 hops) */
+#define PERF_MEM_TLB_REM_RAM3	0x8000	/* Remote DRAM (3 hops) */
+#define PERF_MEM_TLB_CCE_DIRTY	0x10000	/* Remote cache entry hit, but dirty */
 
 #define PERF_MEM_S(a, s) \
 	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
-- 
1.7.1

