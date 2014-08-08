Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaHHAPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:15:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:31348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaHHAPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="369517299"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf, x86: Don't mark DataLA addresses as store
Date: Thu,  7 Aug 2014 17:15:39 -0700
Message-Id: <1407456941-16232-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
References: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell supports reporting the data address for a range
of PEBS events, including:

UOPS_RETIRED.ALL
MEM_UOPS_RETIRED.STLB_MISS_LOADS
MEM_UOPS_RETIRED.STLB_MISS_STORES
MEM_UOPS_RETIRED.LOCK_LOADS
MEM_UOPS_RETIRED.SPLIT_LOADS
MEM_UOPS_RETIRED.SPLIT_STORES
MEM_UOPS_RETIRED.ALL_LOADS
MEM_UOPS_RETIRED.ALL_STORES
MEM_LOAD_UOPS_RETIRED.L1_HIT
MEM_LOAD_UOPS_RETIRED.L2_HIT
MEM_LOAD_UOPS_RETIRED.L3_HIT
MEM_LOAD_UOPS_RETIRED.L1_MISS
MEM_LOAD_UOPS_RETIRED.L2_MISS
MEM_LOAD_UOPS_RETIRED.L3_MISS
MEM_LOAD_UOPS_RETIRED.HIT_LFB
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE
MEM_LOAD_UOPS_L3_MISS_RETIRED.LOCAL_DRAM

This facility was already enabled earlier with the original Haswell
perf changes.

However these addresses were always reports as stores by perf, which is wrong,
as they could be loads or NA too.

This patch uses the load/store/na flags added earlier to report the correct
operation based on the event type. For some events this is NA.

v2: Supports load/stores/na again instead of marking everything NA
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index aca77e9..855c19e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,13 +108,19 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
+static u64 precise_store_data_hsw(struct perf_event *event, u64 status,
+				  unsigned flags)
 {
 	union perf_mem_data_src dse;
 	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = 0;
-	dse.mem_op = PERF_MEM_OP_STORE;
+	if (flags & PERF_X86_EVENT_PEBS_LD_HSW)
+		dse.mem_op = PERF_MEM_OP_LOAD;
+	else if (flags & PERF_X86_EVENT_PEBS_ST_HSW)
+		dse.mem_op = PERF_MEM_OP_STORE;
+	else
+		dse.mem_op = PERF_MEM_OP_NA;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
 
 	/*
@@ -868,7 +874,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 					 PERF_X86_EVENT_PEBS_LD_HSW|
 					 PERF_X86_EVENT_PEBS_NA_HSW))
 				data.data_src.val =
-					precise_store_data_hsw(event, pebs->dse);
+					precise_store_data_hsw(event, pebs->dse,
+							       event->hw.flags);
 			else
 				data.data_src.val = precise_store_data(pebs->dse);
 		}
-- 
1.9.3

