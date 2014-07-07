Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaGGWiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:38:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:42666 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbaGGWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,621,1400050800"; 
   d="scan'208";a="566404696"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
Date: Mon,  7 Jul 2014 15:37:41 -0700
Message-Id: <1404772661-15527-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404772661-15527-1-git-send-email-andi@firstfloor.org>
References: <1404772661-15527-1-git-send-email-andi@firstfloor.org>
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
as they could be loads too.  The hardware does not distinguish loads and stores
for these instructions, so there's no (cheap) way for the profiler
to find out.

Change the type to PERF_MEM_OP_NA instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 0e22ce6..c5d83ab 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -114,7 +114,7 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = 0;
-	dse.mem_op = PERF_MEM_OP_STORE;
+	dse.mem_op = PERF_MEM_OP_NA;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
 
 	/*
-- 
1.9.3

