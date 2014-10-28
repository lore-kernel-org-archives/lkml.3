Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaJ1MlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:41:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:58237 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJ1MlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:41:10 -0400
Message-Id: <20141028123352.516276191@infradead.org>
User-Agent: quilt/0.61-1
Date: Tue, 28 Oct 2014 13:30:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] perf,x86: De-obfuscate HSW offcore bits
References: <20141028123043.257488788@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-fix-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi introduced the HSW cache events array, but used magic constants
against convention as set by all the other uarchs. Try and deobfuscate
these a bit.

The SDM doesn't appear to come close to actually describing the
offcore but Andi said actual bit definitions were available from:
  https://download.01.org/perfmon/HSW/Haswell_matrix_bit_definitions_V14.json

The below script was used to generate the macros.

-->8--
#!/bin/bash

UARCH=$1

cat $UARCH/*matrix_bit_definitions*.json | awk -v ua=$UARCH '
	/BitName/ {
		name=ua "_" gensub("[\",]","","g",$2);

		namet=name;
		for (i=1; i<5; i++) {
			if (length(name) < i*8)
				namet = namet "\t";
		}
	}
	/BitIndex/ {
		bits=gensub("\"","","g",$2);

		nr=split(bits, abit, ",");
		if (nr == 2) {
			bit[abit[1]] = name;
			printf "#define %sBIT_ULL(%d)\n", namet, abit[1];
		} else {
			def = "#define " namet "(";
			for (i=1; i<nr; i++) {
				def = def bit[abit[i]];
				if (i+1<nr)
					def = def "|";
			}
			def = def ")";
			print def;
		}
       }
'

Fixes: 86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   82 +++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -519,6 +519,75 @@ static __initconst const u64 hsw_hw_cach
  },
 };
 
+#define HSW_DEMAND_DATA_RD		BIT_ULL(0)
+#define HSW_DEMAND_RFO			BIT_ULL(1)
+#define HSW_DEMAND_CODE_RD		BIT_ULL(2)
+#define HSW_COREWB			BIT_ULL(3)
+#define HSW_PF_L2_DATA_RD		BIT_ULL(4)
+#define HSW_PF_L2_RFO			BIT_ULL(5)
+#define HSW_PF_L2_CODE_RD		BIT_ULL(6)
+#define HSW_PF_L3_DATA_RD		BIT_ULL(7)
+#define HSW_PF_L3_RFO			BIT_ULL(8)
+#define HSW_PF_L3_CODE_RD		BIT_ULL(9)
+#define HSW_SPLIT_LOCK_UC_LOCK		BIT_ULL(10)
+#define HSW_STREAMING_STORES		BIT_ULL(11)
+#define HSW_OTHER			BIT_ULL(15)
+#define HSW_ALL_PF_DATA_RD		(HSW_PF_L2_DATA_RD|HSW_PF_L3_DATA_RD)
+#define HSW_ALL_PF_RFO			(HSW_PF_L2_RFO|HSW_PF_L3_RFO)
+#define HSW_ALL_PF_CODE_RD		(HSW_PF_L2_CODE_RD|HSW_PF_L3_CODE_RD)
+#define HSW_ALL_DATA_RD			(HSW_DEMAND_DATA_RD|HSW_PF_L2_DATA_RD|	\
+					 HSW_PF_L3_DATA_RD)
+#define HSW_ALL_RFO			(HSW_DEMAND_RFO|HSW_PF_L2_RFO|HSW_PF_L3_RFO)
+#define HSW_ALL_CODE_RD			(HSW_DEMAND_CODE_RD|HSW_PF_L2_CODE_RD|	\
+					 HSW_PF_L3_CODE_RD)
+#define HSW_ALL_READS			(HSW_DEMAND_DATA_RD|HSW_DEMAND_RFO|	\
+					 HSW_DEMAND_CODE_RD|HSW_PF_L2_DATA_RD|	\
+					 HSW_PF_L2_RFO|HSW_PF_L2_CODE_RD|	\
+					 HSW_PF_L3_DATA_RD|HSW_PF_L3_RFO|	\
+					 HSW_PF_L3_CODE_RD)
+#define HSW_ALL_REQUESTS		(HSW_DEMAND_DATA_RD|HSW_DEMAND_RFO|	\
+					 HSW_DEMAND_CODE_RD|HSW_COREWB|		\
+					 HSW_PF_L2_DATA_RD|HSW_PF_L2_RFO|	\
+					 HSW_PF_L2_CODE_RD|HSW_PF_L3_DATA_RD|	\
+					 HSW_PF_L3_RFO|HSW_PF_L3_CODE_RD|	\
+					 HSW_SPLIT_LOCK_UC_LOCK|		\
+					 HSW_STREAMING_STORES|HSW_OTHER)
+#define HSW_ANY_RESPONSE		BIT_ULL(16)
+#define HSW_SUPPLIER_NONE		BIT_ULL(17)
+#define HSW_L3_HIT_M			BIT_ULL(18)
+#define HSW_L3_HIT_E			BIT_ULL(19)
+#define HSW_L3_HIT_S			BIT_ULL(20)
+#define HSW_L3_HIT_F			BIT_ULL(21)
+#define HSW_L3_HIT			(HSW_L3_HIT_M|HSW_L3_HIT_E|HSW_L3_HIT_S|HSW_L3_HIT_F)
+#define HSW_L4_HIT_LOCAL_L4             BIT_ULL(22)
+#define HSW_L4_HIT_REMOTE_HOP0_L4       BIT_ULL(23)
+#define HSW_L4_HIT_REMOTE_HOP1_L4       BIT_ULL(24)
+#define HSW_L4_HIT_REMOTE_HOP2P_L4      BIT_ULL(25)
+#define HSW_L4_HIT                      (HSW_L4_HIT_LOCAL_L4|			\
+					 HSW_L4_HIT_REMOTE_HOP0_L4|		\
+					 HSW_L4_HIT_REMOTE_HOP1_L4|		\
+					 HSW_L4_HIT_REMOTE_HOP2P_L4)
+#define HSW_L3_MISS_LOCAL_DRAM		BIT_ULL(26)
+#define HSW_L3_MISS_REMOTE_HOP0_DRAM	BIT_ULL(27)
+#define HSW_L3_MISS_REMOTE_HOP1_DRAM	BIT_ULL(28)
+#define HSW_L3_MISS_REMOTE_HOP2P_DRAM	BIT_ULL(29)
+#define HSW_L3_MISS			(HSW_L3_MISS_LOCAL_DRAM|		\
+					 HSW_L3_MISS_REMOTE_HOP0_DRAM|		\
+					 HSW_L3_MISS_REMOTE_HOP1_DRAM|		\
+					 HSW_L3_MISS_REMOTE_HOP2P_DRAM)
+#define HSW_SPL_HIT			BIT_ULL(30)
+#define HSW_SNOOP_NONE			BIT_ULL(31)
+#define HSW_SNOOP_NOT_NEEDED		BIT_ULL(32)
+#define HSW_SNOOP_MISS			BIT_ULL(33)
+#define HSW_SNOOP_HIT_NO_FWD		BIT_ULL(34)
+#define HSW_SNOOP_HIT_WITH_FWD		BIT_ULL(35)
+#define HSW_SNOOP_HITM			BIT_ULL(36)
+#define HSW_SNOOP_NON_DRAM		BIT_ULL(37)
+#define HSW_ANY_SNOOP			(HSW_SNOOP_NONE|HSW_SNOOP_NOT_NEEDED|	\
+					 HSW_SNOOP_MISS|HSW_SNOOP_HIT_NO_FWD|	\
+					 HSW_SNOOP_HIT_WITH_FWD|HSW_SNOOP_HITM|	\
+					 HSW_SNOOP_NON_DRAM)
+
 static __initconst const u64 hsw_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -526,16 +595,13 @@ static __initconst const u64 hsw_hw_cach
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
-		[ C(RESULT_ACCESS) ] = 0x2d5,
-		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
-                   L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x3fbc0202d5ull,
+		[ C(RESULT_ACCESS) ] = HSW_ALL_DATA_RD|HSW_ALL_CODE_RD,
+		[ C(RESULT_MISS)   ] = HSW_ALL_DATA_RD|HSW_ALL_CODE_RD|HSW_SUPPLIER_NONE|
+				       HSW_L3_MISS|HSW_ANY_SNOOP,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x122, 	/* OFFCORE_RESPONSE:ALL_RFO */
-		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
-		[ C(RESULT_MISS)   ] = 0x3fbc020122ull,
+		[ C(RESULT_ACCESS) ] = HSW_ALL_RFO,
+		[ C(RESULT_MISS)   ] = HSW_ALL_RFO|HSW_SUPPLIER_NONE|HSW_L3_MISS|HSW_ANY_SNOOP,
 	},
 	[ C(OP_PREFETCH) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0,


