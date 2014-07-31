Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaGaGqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:46:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:8726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbaGaGpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059835"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 4/9] perf, x86: introduce setup_pebs_sample_data()
Date: Thu, 31 Jul 2014 14:44:59 +0800
Message-Id: <1406789104-25863-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move codes that setup PEBS sample data to separate function

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 63 ++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ecf8b5d6..06b4884 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -870,8 +870,10 @@ static inline u64 intel_hsw_transaction(struct pebs_record_hsw *pebs)
 	return txn;
 }
 
-static void __intel_pmu_pebs_event(struct perf_event *event,
-				   struct pt_regs *iregs, void *__pebs)
+static void setup_pebs_sample_data(struct perf_event *event,
+				   struct pt_regs *iregs, void *__pebs,
+				   struct perf_sample_data *data,
+				   struct pt_regs *regs)
 {
 	/*
 	 * We cast to the biggest pebs_record but are careful not to
@@ -879,21 +881,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_hsw *pebs = __pebs;
-	struct perf_sample_data data;
-	struct pt_regs regs;
 	u64 sample_type;
 	int fll, fst;
 
-	if (!intel_pmu_save_and_restart(event))
-		return;
-
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
 	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
 				 PERF_X86_EVENT_PEBS_ST_HSW);
 
-	perf_sample_data_init(&data, 0, event->hw.last_period);
+	perf_sample_data_init(data, 0, event->hw.last_period);
 
-	data.period = event->hw.last_period;
+	data->period = event->hw.last_period;
 	sample_type = event->attr.sample_type;
 
 	/*
@@ -904,19 +901,19 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		 * Use latency for weight (only avail with PEBS-LL)
 		 */
 		if (fll && (sample_type & PERF_SAMPLE_WEIGHT))
-			data.weight = pebs->lat;
+			data->weight = pebs->lat;
 
 		/*
 		 * data.data_src encodes the data source
 		 */
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
-				data.data_src.val = load_latency_data(pebs->dse);
+				data->data_src.val = load_latency_data(pebs->dse);
 			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
-				data.data_src.val =
+				data->data_src.val =
 					precise_store_data_hsw(event, pebs->dse);
 			else
-				data.data_src.val = precise_store_data(pebs->dse);
+				data->data_src.val = precise_store_data(pebs->dse);
 		}
 	}
 
@@ -930,35 +927,47 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * PERF_SAMPLE_IP and PERF_SAMPLE_CALLCHAIN to function properly.
 	 * A possible PERF_SAMPLE_REGS will have to transfer all regs.
 	 */
-	regs = *iregs;
-	regs.flags = pebs->flags;
-	set_linear_ip(&regs, pebs->ip);
-	regs.bp = pebs->bp;
-	regs.sp = pebs->sp;
+	*regs = *iregs;
+	regs->flags = pebs->flags;
+	set_linear_ip(regs, pebs->ip);
+	regs->bp = pebs->bp;
+	regs->sp = pebs->sp;
 
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
-		regs.ip = pebs->real_ip;
-		regs.flags |= PERF_EFLAGS_EXACT;
-	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
-		regs.flags |= PERF_EFLAGS_EXACT;
+		regs->ip = pebs->real_ip;
+		regs->flags |= PERF_EFLAGS_EXACT;
+	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(regs))
+		regs->flags |= PERF_EFLAGS_EXACT;
 	else
-		regs.flags &= ~PERF_EFLAGS_EXACT;
+		regs->flags &= ~PERF_EFLAGS_EXACT;
 
 	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
 	    x86_pmu.intel_cap.pebs_format >= 1)
-		data.addr = pebs->dla;
+		data->addr = pebs->dla;
 
 	if (x86_pmu.intel_cap.pebs_format >= 2) {
 		/* Only set the TSX weight when no memory weight. */
 		if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll)
-			data.weight = intel_hsw_weight(pebs);
+			data->weight = intel_hsw_weight(pebs);
 
 		if (event->attr.sample_type & PERF_SAMPLE_TRANSACTION)
-			data.txn = intel_hsw_transaction(pebs);
+			data->txn = intel_hsw_transaction(pebs);
 	}
 
 	if (has_branch_stack(event))
-		data.br_stack = &cpuc->lbr_stack;
+		data->br_stack = &cpuc->lbr_stack;
+}
+
+static void __intel_pmu_pebs_event(struct perf_event *event,
+				   struct pt_regs *iregs, void *__pebs)
+{
+	struct perf_sample_data data;
+	struct pt_regs regs;
+
+	if (!intel_pmu_save_and_restart(event))
+		return;
+
+	setup_pebs_sample_data(event, iregs, __pebs, &data, &regs);
 
 	if (perf_event_overflow(event, &data, &regs))
 		x86_pmu_stop(event, 0);
-- 
1.9.3

