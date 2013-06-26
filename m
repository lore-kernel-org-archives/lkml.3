Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3FZHn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:43:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49750 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3FZHnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:43:24 -0400
Date: Wed, 26 Jun 2013 00:42:27 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: eranian@google.com, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>, ellerman@au1.ibm.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 3/3] perf/Power7: Export DCACHE_SRC field to userspace
Message-ID: <20130626074226.GC3741@us.ibm.com>
References: <20130626074106.GA3741@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626074106.GA3741@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062607-7182-0000-0000-000007865B1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 25 Jun 2013 17:12:02 -0700
Subject: [RFC][PATCH 3/3] perf/Power7: Export DCACHE_SRC field to userspace

On Power7, the DCACHE_SRC field (bits 9..12), in the MMCRA register
identify the source from which a data-cache-miss for a marked instruction
was satisified.

Map this source to the architecture-neutral memory hierarchy levels
and add to the sample record so the source information is available to
user space.

    Arch-neutral levels         Power7 levels
    -----------------------------------------------------------------------
    local    LVL_L2		local (same core) L2 (FROM_L2)
    local    LVL_L3		local (same core) L3 (FROM_L3)

    1-hop    XLVL_REM_L2_CCE1*  different core on same chip (FROM_L2.1)
    1-hop    XLVL_REM_L3_CCE1*  different core on same chip (FROM_L3.1)

    2-hops   LVL_REM_CCE2	remote (different chip, same node) (FROM_RL2L3)
    3-hops   XLVL_REM_CCE3*	distant (different node)  (FROM_DL2L3)

    1-hop    LVL_REM_RAM1	unused
    2-hops   LVL_REM_RAM2	remote (different chip, same node) (FROM_RMEM)

    3-hops   XLVL_REM_RAM3*	distant (different node) (FROM_DMEM)

As shown above, Power7 supports one extra level in the cache-hierarchy (i.e
total of 3-hops).  To maintain consistency in terminology (i.e 2-hops = remote,
3-hops = distant), we propose leaving the REM_RAM1 unused in Power7 and adding
another level, REM_CCE3 and REM_RAM3.

Further, in the REM_CCE1 case, Power7 can also identify if the data came from
the L2 or L3 cache of another core on the same chip. To describe this add the
levels:

	PERF_MEM_XLVL_REM_L2_CCE1
	PERF_MEM_XLVL_REM_L3_CCE1

Finally, in the REM_CCE1 and REM_CCE2 cases, Power7 also indicates whether
the entry found in the remote cache was modified (dirty). So we add a new
state

	PERF_MEM_XLVL_CCE_DIRTY

Testing:

memarray is a simple test case that creates a large 2D array and accesses
elements in the array in strides of varying length. Using the perf event
PM_MRK_LD_MISS_L1_CYC (r4003e) with memarrary, we get samples like:

        4989704543010 0x1470 [0x38]: PERF_RECORD_SAMPLE(IP, 1): 10816/10816:
        0xc0000000001ef514 period: 1 addr: 0xc0000001e64538d8
         . data_src: 0x400
         ... thread: memarray:10816
         ...... dso: [kernel.kallsyms]

        4990265034542 0x9a00 [0x38]: PERF_RECORD_SAMPLE(IP, 3): 10816/10816:
        0x54696c period: 2996 addr: 0x8000000064a3001a
         . data_src: 0x800
         ... thread: memarray:10816
         ...... dso: [hypervisor]

        4990505534586 0xd2e0 [0x38]: PERF_RECORD_SAMPLE(IP, 1): 10816/10816:
        0xc00000000019bb28 period: 2979 addr: 0xc0000001fffaba40
         . data_src: 0x200000000000
         ... thread: memarray:10816
         ...... dso: [kernel.kallsyms]

where, the 'data_src' values indicate:

        0x400           PERF_MEM_LVL_L2,		FROM_L2
        0x800           PERF_MEM_LVL_L3,		FROM_L3
        0x200000000000  PERF_MEM_XLVL_REM_L2_CCE1	FROM_L2.1_SHR

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---

Changelog[v2]:
	[Stephane Eranian] Define new levels rather than ORing the L2 and L3
	with REM_CCE1 and REM_CCE2.
	[Stephane Eranian] allocate a bit PERF_MEM_XLVL_NA for architectures
	that don't use the ->mem_xlvl field.
	Insert the TLB patch ahead so the new TLB bits are contigous with
	existing TLB bits.

 arch/powerpc/perf/power7-pmu.c  |   44 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/perf_event.h |   13 ++++++++++-
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index c1cac96..8cb4cbc 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -209,6 +209,10 @@ static int power7_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 	return nalt;
 }
 
+#define POWER7_MMCRA_DCACHE_MISS        (0x1LL << 55)
+#define POWER7_MMCRA_DCACHE_SRC_SHIFT   51
+#define POWER7_MMCRA_DCACHE_SRC_MASK    (0xFLL << POWER7_MMCRA_DCACHE_SRC_SHIFT)
+
 #define	POWER7_MMCRA_MDTLB_MISS		(0x1LL << 50)
 #define	POWER7_MMCRA_MDTLB_SRC_SHIFT	46
 #define	POWER7_MMCRA_MDTLB_SRC_MASK	(0xFLL << POWER7_MMCRA_MDTLB_SRC_SHIFT)
@@ -231,6 +235,7 @@ static int power7_get_alternatives(u64 event, unsigned int flags, u64 alt[])
  */
 #define P(a, b)			PERF_MEM_S(a, b)
 #define TD(a, b)		(P(TLB, CCE_DIRTY) | P(a, b))
+#define XD(a, b)		(P(XLVL, CCE_DIRTY) | P(a, b))
 
 static u64 mdtlb_src_map[] = {
 	P(TLB,  L2),			/* 00: FROM_L2 */
@@ -258,6 +263,37 @@ static u64 mdtlb_src_map[] = {
 	P(TLB,  NA),			/* 15: Reserved */
 };
 
+/*
+ * Similar to mdtlb_src_map[] table above, use dcache_src_map[] to map
+ * the Power7 DCACHE_SRC field (bits 9..12) in MMCRA register to the
+ * Linux memory hierarchy levels.
+ */
+static u64 dcache_src_map[] = {
+	P(LVL,   L2),			/* 00: FROM_L2 */
+	P(LVL,   L3),			/* 01: FROM_L3 */
+
+	P(LVL,   NA),			/* 02: Reserved */
+	P(LVL,   NA),			/* 03: Reserved */
+
+	P(XLVL,  REM_L2_CCE1),		/* 04: FROM_L2.1_SHR */
+	XD(XLVL, REM_L2_CCE1),		/* 05: FROM_L2.1_MOD */
+
+	P(XLVL,  REM_L3_CCE1),		/* 06: FROM_L3.1_SHR */
+	XD(XLVL, REM_L3_CCE1),		/* 07: FROM_L3.1_MOD */
+
+	P(LVL,   REM_CCE2),		/* 08: FROM_RL2L3_SHR */
+	XD(LVL,  REM_CCE2),		/* 09: FROM_RL2L3_MOD */
+
+	P(XLVL,  REM_CCE3),		/* 10: FROM_DL2L3_SHR */
+	XD(XLVL, REM_CCE3),		/* 11: FROM_DL2L3_MOD */
+
+	P(LVL,   LOC_RAM),		/* 12: FROM_LMEM */
+	P(LVL,   REM_RAM2),		/* 13: FROM_RMEM */
+	P(XLVL,  REM_RAM3),		/* 14: FROM_DMEM */
+
+	P(LVL,   NA),			/* 15: Reserved */
+};
+
 static void power7_get_mem_data_src(union perf_mem_data_src *dsrc,
 				struct pt_regs *regs)
 {
@@ -270,6 +306,14 @@ static void power7_get_mem_data_src(union perf_mem_data_src *dsrc,
 
 		dsrc->val |= mdtlb_src_map[idx];
 	}
+
+	if (mmcra & POWER7_MMCRA_DCACHE_MISS) {
+		idx = mmcra & POWER7_MMCRA_DCACHE_SRC_MASK;
+		idx >>= POWER7_MMCRA_DCACHE_SRC_SHIFT;
+
+		dsrc->val |= dcache_src_map[idx];
+	}
+
 }
 
 /*
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 815ee12..149b33d 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -627,7 +627,8 @@ union perf_mem_data_src {
 			mem_snoop:5,	/* snoop mode */
 			mem_lock:2,	/* lock instr */
 			mem_dtlb:17,	/* tlb access */
-			mem_rsvd:21;
+			mem_xlvl:6,	/* memory hierarchy levels contd */
+			mem_rsvd:15;
 	};
 };
 
@@ -655,6 +656,7 @@ union perf_mem_data_src {
 #define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
 #define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
 #define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
+/* memory hierarchy levels continued/extended below */
 
 /* snoop mode */
 #define PERF_MEM_SNOOP_SHIFT	19
@@ -689,6 +691,15 @@ union perf_mem_data_src {
 #define PERF_MEM_TLB_REM_RAM3	0x8000	/* Remote DRAM (3 hops) */
 #define PERF_MEM_TLB_CCE_DIRTY	0x10000	/* Remote cache entry hit, but dirty */
 
+/* Extended levels i.e. continuation of PERF_MEM_LVL* values above. */
+#define PERF_MEM_XLVL_SHIFT		43
+#define PERF_MEM_XLVL_NA		0x01	/* not available */
+#define PERF_MEM_XLVL_CCE_DIRTY		0x02    /* cache entry hit, was dirty */
+#define PERF_MEM_XLVL_REM_L2_CCE1	0x04    /* Remote L2-cache (1 hop) */
+#define PERF_MEM_XLVL_REM_L3_CCE1	0x08    /* Remote L3-cache (1 hop) */
+#define PERF_MEM_XLVL_REM_CCE3		0x10    /* Remote cache (3 hops) */
+#define PERF_MEM_XLVL_REM_RAM3		0x20    /* Remote DRAM (3 hops) */
+
 #define PERF_MEM_S(a, s) \
 	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
 
-- 
1.7.1

