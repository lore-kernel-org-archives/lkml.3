Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaHKT1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:27:25 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61195 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaHKT0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:26:38 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com
Subject: [PATCH v2 2/4] perf/x86: Don't mark DataLA addresses as store
Date: Mon, 11 Aug 2014 21:27:11 +0200
Message-Id: <1407785233-32193-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407785233-32193-1-git-send-email-eranian@google.com>
References: <1407785233-32193-1-git-send-email-eranian@google.com>
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

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index aca77e9..a9b60f3 100644
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
1.7.9.5

