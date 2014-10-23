Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaJWLAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:00:02 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbaJWK75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:59:57 -0400
Message-Id: <20141023105658.111371548@infradead.org>
User-Agent: quilt/0.61-1
Date: Thu, 23 Oct 2014 12:51:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>
Subject: [PATCH 1/4] perf,x86: De-obfuscate HSW offcore bits
References: <20141023105119.173457103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-fix-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi introduced the HSW cache events array, but used magic constants
against convention as set by all the other uarchs. Try and deobfuscate
these a bit.

This patch should not change the actual values generated; however
weird they seems.

In that patch Andi also said there were differences between the
SNB/IVB and HSW/BDW offcore tables but failed to specify which and
why.

Fixes: 86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel.c |   48 +++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -247,6 +247,7 @@ static u64 intel_pmu_event_map(int hw_ev
 #define SNB_BUS_LOCKS		(1ULL << 10)
 #define SNB_STRM_ST		(1ULL << 11)
 #define SNB_OTHER		(1ULL << 15)
+
 #define SNB_RESP_ANY		(1ULL << 16)
 #define SNB_NO_SUPP		(1ULL << 17)
 #define SNB_LLC_HITM		(1ULL << 18)
@@ -255,6 +256,7 @@ static u64 intel_pmu_event_map(int hw_ev
 #define SNB_LLC_HITF		(1ULL << 21)
 #define SNB_LOCAL		(1ULL << 22)
 #define SNB_REMOTE		(0xffULL << 23)
+
 #define SNB_SNP_NONE		(1ULL << 31)
 #define SNB_SNP_NOT_NEEDED	(1ULL << 32)
 #define SNB_SNP_MISS		(1ULL << 33)
@@ -519,6 +521,40 @@ static __initconst const u64 hsw_hw_cach
  },
 };
 
+/* HSW Request type */
+#define HSW_DMND_DATA_RD	(1ULL << 0)
+#define HSW_DMND_RFO		(1ULL << 1)
+#define HSW_DMND_IFETCH		(1ULL << 2)
+
+#define HSW_PF_DATA_RD		(1ULL << 4)
+#define HSW_PF_RFO		(1ULL << 5)
+#define HSW_PF_IFETCH		(1ULL << 6)
+
+#define HSW_OTHER		(1ULL << 15)
+
+/* HSW Supplier info := SNB Supplier info */
+/* HSW Snoop Info := SNB Snoop Info */
+
+/*
+ * SNB_LLC_* is specified as 'reserved' in the SDM
+ * but Andi added it anyhow, suggesting HSW/BDW have it just fine
+ *
+ * XXX NHM/WSM/SNB/IVB don't have the PF/IFETCH bits set
+ */
+#define HSW_DMND_READ		(HSW_DMND_DATA_RD|HSW_DMND_IFETCH| \
+				 HSW_PF_DATA_RD|HSW_PF_IFETCH| \
+				 SNB_LLC_DATA_RD|SNB_LLC_IFETCH)
+
+/* XXX NHM/WSM/SNB/IVB dont have the PF bits set */
+#define HSW_DMND_WRITE		(HSW_DMND_RFO|HSW_PF_RFO|SNB_LLC_RFO)
+
+#define HSW_DMND_PREFETCH	(0) /* XXX broken ? */
+
+#define HSW_DRAM_ANY		(SNB_NO_SUPP|SNB_SNP_ANY|(0x78ULL << 23)) /* WTF */
+
+#define HSW_L3_ACCESS		(0) /* XXX no supplier! */
+#define NSW_L3_MISS		(HSW_DRAM_ANY|SNB_NON_DRAM)
+
 static __initconst const u64 hsw_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -526,16 +562,12 @@ static __initconst const u64 hsw_hw_cach
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
-		[ C(RESULT_ACCESS) ] = 0x2d5,
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
-                   L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x3fbc0202d5ull,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_READ|HSW_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_READ|HSW_L3_MISS,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x122, 	/* OFFCORE_RESPONSE:ALL_RFO */
-		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x3fbc020122ull,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_WRITE|HSW_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|HSW_L3_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0,


