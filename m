Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaJ1MlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:41:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaJ1MlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:41:14 -0400
Message-Id: <20141028123352.574638596@infradead.org>
User-Agent: quilt/0.61-1
Date: Tue, 28 Oct 2014 13:30:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/3] perf,x86: Sanitize HSW offcore events
References: <20141028123043.257488788@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-fix-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the actual HSW offcore bits, we can now construct the full LL
event set in a similar manner to the other uarchs (NHM/SNB).

Fixes: 86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -459,20 +459,16 @@ static __initconst const u64 hsw_hw_cach
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
 		[ C(RESULT_ACCESS) ] = 0x1b7,
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
-                   L3_MISS|ANY_SNOOP */
 		[ C(RESULT_MISS)   ] = 0x1b7,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x1b7, 	/* OFFCORE_RESPONSE:ALL_RFO */
-		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
+		[ C(RESULT_ACCESS) ] = 0x1b7,
 		[ C(RESULT_MISS)   ] = 0x1b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
+		[ C(RESULT_ACCESS) ] = 0x1b7,
+		[ C(RESULT_MISS)   ] = 0x1b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -580,6 +576,13 @@ static __initconst const u64 hsw_hw_cach
 					 HSW_SNOOP_HIT_WITH_FWD|HSW_SNOOP_HITM|	\
 					 HSW_SNOOP_NON_DRAM)
 
+#define HSW_DMND_READ			(HSW_ALL_DATA_RD)
+#define HSW_DMND_WRITE			(HSW_ALL_RFO)
+#define HSW_DMND_PREFETCH		(HSW_ALL_PF_DATA_RD|HSW_ALL_PF_RFO)
+
+#define HSW_LLC_ACCESS			(HSW_ANY_RESPONSE)
+#define HSW_LLC_MISS			(HSW_L3_MISS)
+
 static __initconst const u64 hsw_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -587,17 +590,16 @@ static __initconst const u64 hsw_hw_cach
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = HSW_ALL_DATA_RD|HSW_ALL_CODE_RD,
-		[ C(RESULT_MISS)   ] = HSW_ALL_DATA_RD|HSW_ALL_CODE_RD|HSW_SUPPLIER_NONE|
-				       HSW_L3_MISS|HSW_ANY_SNOOP,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_READ|HSW_LLC_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_READ|HSW_LLC_MISS,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = HSW_ALL_RFO,
-		[ C(RESULT_MISS)   ] = HSW_ALL_RFO|HSW_SUPPLIER_NONE|HSW_L3_MISS|HSW_ANY_SNOOP,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_WRITE|HSW_LLC_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|HSW_LLC_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
+		[ C(RESULT_ACCESS) ] = HSW_DMND_PREFETCH|HSW_LLC_ACCESS,
+		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|HSW_LLC_MISS
 	},
  },
 };


