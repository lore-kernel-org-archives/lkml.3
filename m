Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaHHUkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:40:55 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45974 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaHHUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:40:35 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com
Subject: [PATCH 4/4] perf/x86: code cleanups for __intel_pmu_pebs_event()
Date: Fri,  8 Aug 2014 22:40:52 +0200
Message-Id: <1407530452-19774-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407530452-19774-1-git-send-email-eranian@google.com>
References: <1407530452-19774-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the code more readable. It also renames
precise_store_data_hsw() to precise_datala_hsw() because
the function is called for both loads and stores on HSW.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   65 ++++++++++++++---------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 67919ce..97890c2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,7 +108,7 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
+static u64 precise_datala_hsw(struct perf_event *event, u64 status)
 {
 	union perf_mem_data_src dse;
 	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
@@ -825,6 +825,10 @@ static inline u64 intel_hsw_transaction(struct pebs_record_hsw *pebs)
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
+#define PERF_X86_EVENT_PEBS_HSW_PREC \
+		(PERF_X86_EVENT_PEBS_ST_HSW | \
+		 PERF_X86_EVENT_PEBS_LD_HSW | \
+		 PERF_X86_EVENT_PEBS_NA_HSW)
 	/*
 	 * We cast to the biggest pebs_record but are careful not to
 	 * unconditionally access the 'extra' entries.
@@ -834,47 +838,40 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
-	int fll, fst;
+	int fll, fst, dsrc;
+	int fl = event->hw.flags;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
-	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
-	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
-				 PERF_X86_EVENT_PEBS_ST_HSW |
-				 PERF_X86_EVENT_PEBS_LD_HSW |
-				 PERF_X86_EVENT_PEBS_NA_HSW);
+	sample_type = event->attr.sample_type;
+	dsrc = sample_type & PERF_SAMPLE_DATA_SRC;
+
+	fll = fl & PERF_X86_EVENT_PEBS_LDLAT;
+	fst = fl & (PERF_X86_EVENT_PEBS_ST | PERF_X86_EVENT_PEBS_HSW_PREC);
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
 	data.period = event->hw.last_period;
-	sample_type = event->attr.sample_type;
 
 	/*
-	 * if PEBS-LL or PreciseStore
+	 * Use latency for weight (only avail with PEBS-LL)
 	 */
-	if (fll || fst) {
-		/*
-		 * Use latency for weight (only avail with PEBS-LL)
-		 */
-		if (fll && (sample_type & PERF_SAMPLE_WEIGHT))
-			data.weight = pebs->lat;
-
-		/*
-		 * data.data_src encodes the data source
-		 */
-		if (sample_type & PERF_SAMPLE_DATA_SRC) {
-			if (fll)
-				data.data_src.val = load_latency_data(pebs->dse);
-			else if (event->hw.flags &
-					(PERF_X86_EVENT_PEBS_ST_HSW|
-					 PERF_X86_EVENT_PEBS_LD_HSW|
-					 PERF_X86_EVENT_PEBS_NA_HSW))
-				data.data_src.val =
-					precise_store_data_hsw(event, pebs->dse);
-			else
-				data.data_src.val = precise_store_data(pebs->dse);
-		}
+	if (fll && (sample_type & PERF_SAMPLE_WEIGHT))
+		data.weight = pebs->lat;
+
+	/*
+	 * data.data_src encodes the data source
+	 */
+	if (dsrc) {
+		u64 val = PERF_MEM_NA;
+		if (fll)
+			val = load_latency_data(pebs->dse);
+		else if (fst && (fl & PERF_X86_EVENT_PEBS_HSW_PREC))
+			val = precise_datala_hsw(event, pebs->dse);
+		else if (fst)
+			val = precise_store_data(pebs->dse);
+		data.data_src.val = val;
 	}
 
 	/*
@@ -901,16 +898,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
-	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
+	if ((sample_type & PERF_SAMPLE_ADDR) &&
 	    x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
 	if (x86_pmu.intel_cap.pebs_format >= 2) {
 		/* Only set the TSX weight when no memory weight. */
-		if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll)
+		if ((sample_type & PERF_SAMPLE_WEIGHT) && !fll)
 			data.weight = intel_hsw_weight(pebs);
 
-		if (event->attr.sample_type & PERF_SAMPLE_TRANSACTION)
+		if (sample_type & PERF_SAMPLE_TRANSACTION)
 			data.txn = intel_hsw_transaction(pebs);
 	}
 
-- 
1.7.9.5

