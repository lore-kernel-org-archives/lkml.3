Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaACFtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:49:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:23246 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaACFsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:48:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="scan'208";a="459449404"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 12/14] perf, x86: use LBR call stack to get user callchain
Date: Fri,  3 Jan 2014 13:48:09 +0800
Message-Id: <1388728091-18564-13-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are executed
the last captured branch record is popped from the on-chip LBR registers.
The LBR call stack facility can help perf to get call chains of progam
without frame pointer.

This patch makes x86's perf_callchain_user() failback to LBR callstack
when there is no frame pointer in the user program.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           | 33 ++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel.c     | 11 +++++++++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 ++
 include/linux/perf_event.h                 |  1 +
 4 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 49128e6..1509340 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1965,12 +1965,28 @@ static unsigned long get_segment_base(unsigned int segment)
 	return get_desc_base(desc + idx);
 }
 
+static inline void
+perf_callchain_lbr_callstack(struct perf_callchain_entry *entry,
+			     struct perf_sample_data *data)
+{
+	struct perf_branch_stack *br_stack = data->br_stack;
+
+	if (br_stack && br_stack->user_callstack) {
+		int i = 0;
+		while (i < br_stack->nr && entry->nr < PERF_MAX_STACK_DEPTH) {
+			perf_callchain_store(entry, br_stack->entries[i].from);
+			i++;
+		}
+	}
+}
+
 #ifdef CONFIG_COMPAT
 
 #include <asm/compat.h>
 
 static inline int
-perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
+perf_callchain_user32(struct perf_callchain_entry *entry,
+		      struct pt_regs *regs, struct perf_sample_data *data)
 {
 	/* 32-bit process in 64-bit kernel. */
 	unsigned long ss_base, cs_base;
@@ -1999,11 +2015,16 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		perf_callchain_store(entry, cs_base + frame.return_address);
 		fp = compat_ptr(ss_base + frame.next_frame);
 	}
+
+	if (fp == compat_ptr(regs->bp))
+		perf_callchain_lbr_callstack(entry, data);
+
 	return 1;
 }
 #else
 static inline int
-perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
+perf_callchain_user32(struct perf_callchain_entry *entry,
+		      struct pt_regs *regs, struct perf_sample_data *data)
 {
     return 0;
 }
@@ -2033,12 +2054,12 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 	if (!current->mm)
 		return;
 
-	if (perf_callchain_user32(regs, entry))
+	if (perf_callchain_user32(entry, regs, data))
 		return;
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		unsigned long bytes;
-		frame.next_frame	     = NULL;
+		frame.next_frame = NULL;
 		frame.return_address = 0;
 
 		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
@@ -2051,6 +2072,10 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
+
+	/* try LBR callstack if there is no frame pointer */
+	if (fp == (void __user *)regs->bp)
+		perf_callchain_lbr_callstack(entry, data);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 722171c..8b7465c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1030,6 +1030,14 @@ static __initconst const u64 slm_hw_cache_event_ids
  },
 };
 
+static inline bool intel_pmu_needs_lbr_callstack(struct perf_event *event)
+{
+	if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+	    (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK))
+		return true;
+	return false;
+}
+
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1398,7 +1406,8 @@ again:
 
 		perf_sample_data_init(&data, 0, event->hw.last_period);
 
-		if (has_branch_stack(event))
+		if (has_branch_stack(event) ||
+		    (event->ctx->task && intel_pmu_needs_lbr_callstack(event)))
 			data.br_stack = &cpuc->lbr_stack;
 
 		if (perf_event_overflow(event, &data, regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 51e1842..08e3ba1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -718,6 +718,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 	int i, j, type;
 	bool compress = false;
 
+	cpuc->lbr_stack.user_callstack = branch_user_callstack(br_sel);
+
 	/* if sampling all branches, then nothing to filter */
 	if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
 		return;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c442276..d2f0488 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -74,6 +74,7 @@ struct perf_raw_record {
  * recent branch.
  */
 struct perf_branch_stack {
+	bool				user_callstack;
 	__u64				nr;
 	struct perf_branch_entry	entries[0];
 };
-- 
1.8.4.2

