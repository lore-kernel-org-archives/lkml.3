Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaHMI0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:26:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaHMIZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:25:50 -0400
Date: Wed, 13 Aug 2014 01:25:02 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-c8aab2e04ac9f442a07abeaf49ddd1703c608f47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1407785233-32193-5-git-send-email-eranian@google.com>
References: <1407785233-32193-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Clean up __intel_pmu_pebs_event() code
Git-Commit-ID: c8aab2e04ac9f442a07abeaf49ddd1703c608f47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8aab2e04ac9f442a07abeaf49ddd1703c608f47
Gitweb:     http://git.kernel.org/tip/c8aab2e04ac9f442a07abeaf49ddd1703c608f47
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 11 Aug 2014 21:27:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:16 +0200

perf/x86: Clean up __intel_pmu_pebs_event() code

This patch makes the code more readable. It also renames
precise_store_data_hsw() to precise_datala_hsw() because
the function is called for both loads and stores on HSW.
The patch also gets rid of the hardcoded store events
codes in that same function.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1407785233-32193-5-git-send-email-eranian@google.com
Cc: ak@linux.intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 81 ++++++++++++++-----------------
 1 file changed, 37 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 67919ce..9dc4199 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,10 +108,9 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
+static u64 precise_datala_hsw(struct perf_event *event, u64 status)
 {
 	union perf_mem_data_src dse;
-	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = PERF_MEM_NA;
 
@@ -128,15 +127,12 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 	 * MEM_UOPS_RETIRED.SPLIT_STORES
 	 * MEM_UOPS_RETIRED.ALL_STORES
 	 */
-	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
-		return dse.val;
-
-	if (status & 1)
-		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
-	else
-		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_MISS;
-
-	/* Nothing else supported. Sorry. */
+	if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW) {
+		if (status & 1)
+			dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
+		else
+			dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_MISS;
+	}
 	return dse.val;
 }
 
@@ -825,6 +821,10 @@ static inline u64 intel_hsw_transaction(struct pebs_record_hsw *pebs)
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
@@ -834,47 +834,40 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
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
@@ -901,16 +894,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
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
 
