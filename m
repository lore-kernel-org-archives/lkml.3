Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaJSWHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:07:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaJSWFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644498"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 11/17] perf, core: expose LBR call stack to user perf tool
Date: Sun, 19 Oct 2014 17:55:06 -0400
Message-Id: <1413755712-8259-12-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With LBR call stack feature enable, there are two call chain data
sources, traditional frame pointer and LBR call stack.
This patch extends the perf_callchain_entry struct to mark the available
call chain source.
The frame pointer is still output as PERF_SAMPLE_CALLCHAIN data format.
The LBR call stack data will be output as PERF_SAMPLE_BRANCH_STACK data
format.

Note: The LBR call stack is only available for user callchain. The
kernel is always got from frame pointers.
The user space perf tool also need to be changed to handle thses two
sources.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           |  7 +++++++
 arch/x86/kernel/cpu/perf_event_intel.c     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 ++
 include/linux/perf_event.h                 | 14 +++++++++++++-
 kernel/events/callchain.c                  |  1 +
 kernel/events/core.c                       | 22 +++++++++++++++++-----
 7 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f94a618e..8043526 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2049,6 +2049,10 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		perf_callchain_store(entry, cs_base + frame.return_address);
 		fp = compat_ptr(ss_base + frame.next_frame);
 	}
+
+	if (fp != compat_ptr(regs->bp))
+		entry->source |= PERF_FP_CALLCHAIN;
+
 	return 1;
 }
 #else
@@ -2101,6 +2105,9 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
+
+	if (fp != (void __user *)regs->bp)
+		entry->source |= PERF_FP_CALLCHAIN;
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 50bb51d..2808267 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1533,7 +1533,7 @@ again:
 
 		perf_sample_data_init(&data, 0, event->hw.last_period);
 
-		if (has_branch_stack(event))
+		if (needs_branch_stack(event))
 			data.br_stack = &cpuc->lbr_stack;
 
 		if (perf_event_overflow(event, &data, regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b1553d0..5b2d2b3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -907,7 +907,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 			data.txn = intel_hsw_transaction(pebs);
 	}
 
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
 	if (perf_event_overflow(event, &data, &regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 1908875..6e473c9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -745,6 +745,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 	int i, j, type;
 	bool compress = false;
 
+	cpuc->lbr_stack.user_callstack = branch_user_callstack(br_sel);
+
 	/* if sampling all branches, then nothing to filter */
 	if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
 		return;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 285776a..fd1936f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -55,7 +55,16 @@ struct perf_guest_info_callbacks {
 #include <linux/workqueue.h>
 #include <asm/local.h>
 
+/*
+ * From Haswell, the existing Last Branch Record facility can
+ * also be used to record call chains.
+ * source: indicates the available call chains source.
+ */
+#define	PERF_FP_CALLCHAIN		0x01
+#define	PERF_LBR_CALLCHAIN		0x02
+
 struct perf_callchain_entry {
+	__u64				source;
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
 };
@@ -67,7 +76,9 @@ struct perf_raw_record {
 
 /*
  * branch stack layout:
- *  nr: number of taken branches stored in entries[]
+ * user_callstack: LBR is enhanced to support call stack profiling.
+ * user_callstack indicates if it's call stack info.
+ * nr: number of taken branches stored in entries[]
  *
  * Note that nr can vary from sample to sample
  * branches (to, from) are stored from most recent
@@ -75,6 +86,7 @@ struct perf_raw_record {
  * recent branch.
  */
 struct perf_branch_stack {
+	bool				user_callstack;
 	__u64				nr;
 	struct perf_branch_entry	entries[0];
 };
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index f2a88de..69fab7c 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -175,6 +175,7 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	if (!entry)
 		goto exit_put;
 
+	entry->source = 0;
 	entry->nr = 0;
 
 	if (kernel && !user_mode(regs)) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c8e367c..84f9885 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4793,7 +4793,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		if (data->callchain) {
-			int size = 1;
+			int size = 2;
 
 			if (data->callchain)
 				size += data->callchain->nr;
@@ -4824,7 +4824,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
+	/* LBR can be used for call stack, so it may be enabled implicitly. */
+	if ((sample_type & PERF_SAMPLE_BRANCH_STACK) ||
+			(data->br_stack && data->br_stack->user_callstack)) {
 		if (data->br_stack) {
 			size_t size;
 
@@ -4908,13 +4910,21 @@ void perf_prepare_sample(struct perf_event_header *header,
 		data->ip = perf_instruction_pointer(regs);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		int size = 1;
+		int size = 2;
 
 		data->callchain = perf_callchain(event, regs);
 
-		if (data->callchain)
+		if (data->callchain) {
 			size += data->callchain->nr;
 
+			if (data->br_stack &&
+			    data->br_stack->user_callstack &&
+			    !(sample_type & PERF_SAMPLE_BRANCH_STACK) &&
+			    !(sample_type & PERF_SAMPLE_STACK_USER))
+				data->callchain->source |=
+					PERF_LBR_CALLCHAIN;
+		}
+
 		header->size += size * sizeof(u64);
 	}
 
@@ -4930,7 +4940,9 @@ void perf_prepare_sample(struct perf_event_header *header,
 		header->size += size;
 	}
 
-	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
+	/* LBR can be used for call stack, so it may be enabled implicitly. */
+	if ((sample_type & PERF_SAMPLE_BRANCH_STACK) ||
+		(data->br_stack && data->br_stack->user_callstack)) {
 		int size = sizeof(u64); /* nr */
 		if (data->br_stack) {
 			size += data->br_stack->nr
-- 
1.8.3.2

