Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3JDRle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:41:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3JDRdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:33:05 -0400
Date: Fri, 4 Oct 2013 10:32:38 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a405bad5ad2086766ce320b16a56952e013327f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1379688044-14173-3-git-send-email-andi@firstfloor.org>
References: <1379688044-14173-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add Haswell specific transaction flag reporting
Git-Commit-ID: a405bad5ad2086766ce320b16a56952e013327f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:32:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a405bad5ad2086766ce320b16a56952e013327f8
Gitweb:     http://git.kernel.org/tip/a405bad5ad2086766ce320b16a56952e013327f8
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 20 Sep 2013 07:40:40 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:06:09 +0200

perf/x86: Add Haswell specific transaction flag reporting

In the PEBS handler report the transaction flags using the new
generic transaction flags facility. Most of them come from
the "tsx_tuning" field in PEBSv2, but the abort code is derived
from the RAX register reported in the PEBS record.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379688044-14173-3-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 07d9a05..32e9ed8 100644
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
@@ -807,6 +809,16 @@ static inline u64 intel_hsw_weight(struct pebs_record_hsw *pebs)
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
@@ -885,10 +897,14 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
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
