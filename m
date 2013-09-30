Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3I3V7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:59:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:22297 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab3I3V7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="409512128"
From: Andi Kleen <andi@firstfloor.org>
To: acma@infradead.org
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6] perf, x86: Add Haswell specific transaction flag reporting v5
Date: Mon, 30 Sep 2013 14:58:59 -0700
Message-Id: <1380578343-31301-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In the PEBS handler report the transaction flags using the new
generic transaction flags facility. Most of them come from
the "tsx_tuning" field in PEBSv2, but the abort code is derived
from the RAX register reported in the PEBS record.

v2: Fix interaction with precise-loads
v3: Mask out reserved bits. More comments.
v4: Adjust white space
v5: Refactor PEBS handler code to collapse one if
    and move parts into new inline.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 54ff6ce..81111df 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -206,6 +206,8 @@ union hsw_tsx_tuning {
 	u64	    value;
 };
 
+#define PEBS_HSW_TSX_FLAGS	0xff00000000ULL
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -806,6 +808,16 @@ static inline u64 intel_hsw_weight(struct pebs_record_hsw *pebs)
 	return 0;
 }
 
+static inline u64 intel_hsw_transaction(struct pebs_record_hsw *pebs)
+{
+	u64 txn = (pebs->tsx_tuning & PEBS_HSW_TSX_FLAGS) >> 32;
+
+	/* For RTM XABORTs also log the abort code from AX */
+	if ((txn & PERF_TXN_TRANSACTION) && (pebs->ax & 1))
+		txn |= ((pebs->ax >> 24) & 0xff) << PERF_TXN_ABORT_SHIFT;
+	return txn;
+}
+
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
@@ -884,10 +896,14 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	    x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
-	/* Only set the TSX weight when no memory weight was requested. */
-	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll &&
-	    (x86_pmu.intel_cap.pebs_format >= 2))
-		data.weight = intel_hsw_weight(pebs);
+	if (x86_pmu.intel_cap.pebs_format >= 2) {
+		/* Only set the TSX weight when no memory weight. */
+		if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll)
+			data.weight = intel_hsw_weight(pebs);
+
+		if (event->attr.sample_type & PERF_SAMPLE_TRANSACTION)
+			data.txn = intel_hsw_transaction(pebs);
+	}
 
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
-- 
1.8.3.1

