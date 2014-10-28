Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaJ1MlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:41:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:58242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaJ1MlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:41:10 -0400
Message-Id: <20141028123352.632326435@infradead.org>
User-Agent: quilt/0.61-1
Date: Tue, 28 Oct 2014 13:30:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] perf,x86: Add HSW offcore NUMA events
References: <20141028123043.257488788@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-node.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the actual HSW offcore bits, we can construct the full NODE
event set in a similar manner to the other uarchs (NHM/SNB).

Fixes: 86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -513,6 +513,20 @@ static __initconst const u64 hsw_hw_cach
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+ },
 };
 
 #define HSW_DEMAND_DATA_RD		BIT_ULL(0)
@@ -588,6 +602,11 @@ static __initconst const u64 hsw_hw_cach
 #define HSW_DMND_WRITE			(HSW_ALL_RFO)
 #define HSW_DMND_PREFETCH		(HSW_ALL_PF_DATA|HSW_ALL_PF_RFO)
 
+#define HSW_DRAM_ANY			(HSW_L3_MISS)
+#define HSW_DRAM_REMOTE			(HSW_L3_MISS_REMOTE_HOP0_DRAM|		\
+					 HSW_L3_MISS_REMOTE_HOP1_DRAM|		\
+					 HSW_L3_MISS_REMOTE_HOP2P_DRAM)
+
 #define HSW_LLC_ACCESS			(HSW_ANY_RESPONSE)
 #define HSW_LLC_MISS			(HSW_L3_MISS)
 
@@ -610,6 +629,20 @@ static __initconst const u64 hsw_hw_cach
 		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|HSW_LLC_MISS
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = HSW_DMND_READ|HSW_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = HSW_DMND_READ|HSW_DRAM_REMOTE,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = HSW_DMND_WRITE|HSW_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|HSW_DRAM_REMOTE,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = HSW_DMND_PREFETCH|HSW_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|HSW_DRAM_REMOTE,
+	},
+ },
 };
 
 static __initconst const u64 westmere_hw_cache_event_ids


