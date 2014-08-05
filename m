Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaHEENH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:13:07 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44477 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaHEENF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:13:05 -0400
Date: Tue, 5 Aug 2014 06:13:33 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, ak@linux.intel.com, mingo@elte.hu
Subject: [PATCH] perf/x86: fix load latency/precise store data source issues
Message-ID: <20140805041333.GA17598@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes some issues introduced by Andi's 'Revamp
PEBS' event selection patch (which is under review right now).

Most of the issues were related to the encoding of the
data source, for PEBS events in general and load/store
events on Haswell.

This patchd does:
 - the default of 0 in perf_sample_data_init() was wrong. 0 is not
  a valid value. So defined PERF_MEM_NA (not available)

 - On HSW, renamed your precise_store_hsw() to datala_hsw()
   because you are actually processing both loads and stores, except
   the load latency event which goes thru normal function

 - precise_store_data_hsw() was returning bogus data source for store
   events. dse.mem_lvl instead of dse.val

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 23 ++++++++++++++---------
 include/linux/perf_event.h                |  9 ++++++++-
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index a9b60f3..1aca254 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,14 +108,17 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
+static u64 precise_datala_hsw(struct perf_event *event, u64 status)
 {
 	union perf_mem_data_src dse;
 	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
-	dse.val = 0;
-	dse.mem_op = PERF_MEM_OP_NA;
-	dse.mem_lvl = PERF_MEM_LVL_NA;
+	dse.val = PERF_MEM_NA;
+
+	if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+		dse.mem_op = PERF_MEM_OP_STORE;
+	else if (event->hw.flags & PERF_X86_EVENT_PEBS_LD_HSW)
+		dse.mem_op = PERF_MEM_OP_LOAD;
 
 	/*
 	 * L1 info only valid for following events:
@@ -126,7 +129,7 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 	 * MEM_UOPS_RETIRED.ALL_STORES
 	 */
 	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
-		return dse.mem_lvl;
+		return dse.val;
 
 	if (status & 1)
 		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
@@ -861,16 +864,18 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		 * data.data_src encodes the data source
 		 */
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
+			u64 val;
 			if (fll)
-				data.data_src.val = load_latency_data(pebs->dse);
+				val = load_latency_data(pebs->dse);
 			else if (event->hw.flags &
 					(PERF_X86_EVENT_PEBS_ST_HSW|
 					 PERF_X86_EVENT_PEBS_LD_HSW|
 					 PERF_X86_EVENT_PEBS_NA_HSW))
-				data.data_src.val =
-					precise_store_data_hsw(event, pebs->dse);
+				val = precise_datala_hsw(event, pebs->dse);
 			else
-				data.data_src.val = precise_store_data(pebs->dse);
+				val = precise_store_data(pebs->dse);
+
+			data.data_src.val = val;
 		}
 	}
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..8b206aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -604,6 +604,13 @@ struct perf_sample_data {
 	u64				txn;
 };
 
+/* default value for data source */
+#define PERF_MEM_NA (PERF_MEM_S(OP, NA)   |\
+		    PERF_MEM_S(LVL, NA)   |\
+		    PERF_MEM_S(SNOOP, NA) |\
+		    PERF_MEM_S(LOCK, NA)  |\
+		    PERF_MEM_S(TLB, NA))
+
 static inline void perf_sample_data_init(struct perf_sample_data *data,
 					 u64 addr, u64 period)
 {
@@ -616,7 +623,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
-	data->data_src.val = 0;
+	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
 }
 
-- 
1.8.3.2

