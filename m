Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaEOP4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:56:50 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48199 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaEOP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:56:49 -0400
Date: Thu, 15 May 2014 17:56:44 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@ghostprotocols.net,
        jolsa@redhat.com, jmario@redhat.com, dzickus@redhat.com,
        ak@linux.intel.com
Subject: [PATCH v2]: fix Haswell precise store data source encoding
Message-ID: <20140515155644.GA3884@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a bug in  precise_store_data_hsw() whereby
it would set the data source memory level to the wrong value.

As per the the SDM Vol 3b Table 18-41 (Layout of Data Linear
Address Information in PEBS Record), when status bit 0 is set
this is a L1 hit, otherwise this is a L1 miss.

This patch encodes the memory level according to the specification.

In V2, we added the filtering on the store events.
Only the following events produce L1 information:
 * MEM_UOPS_RETIRED.STLB_MISS_STORES
 * MEM_UOPS_RETIRED.LOCK_STORES
 * MEM_UOPS_RETIRED.SPLIT_STORES
 * MEM_UOPS_RETIRED.ALL_STORES

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..980970c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,15 +108,31 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(u64 status)
+static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 {
 	union perf_mem_data_src dse;
+	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = 0;
 	dse.mem_op = PERF_MEM_OP_STORE;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
+
+	/*
+	 * L1 info only valid for following events:
+	 *
+	 * MEM_UOPS_RETIRED.STLB_MISS_STORES
+	 * MEM_UOPS_RETIRED.LOCK_STORES
+	 * MEM_UOPS_RETIRED.SPLIT_STORES
+	 * MEM_UOPS_RETIRED.ALL_STORES
+	 */
+	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
+		return dse.mem_lvl;
+
 	if (status & 1)
-		dse.mem_lvl = PERF_MEM_LVL_L1;
+		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
+	else
+		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_MISS;
+
 	/* Nothing else supported. Sorry. */
 	return dse.val;
 }
@@ -887,7 +903,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				data.data_src.val = load_latency_data(pebs->dse);
 			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
 				data.data_src.val =
-					precise_store_data_hsw(pebs->dse);
+					precise_store_data_hsw(event, pebs->dse);
 			else
 				data.data_src.val = precise_store_data(pebs->dse);
 		}
