Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3LKHLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:11:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:40037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3LKHLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352556"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 13/15] perf, x86: Use LBR call stack to get user callchain
Date: Wed, 11 Dec 2013 15:10:58 +0800
Message-Id: <1386745860-21143-14-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Try utilizing the LBR call stack to get user callchain in case of
there is no frame pointer

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           | 33 ++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel.c     | 12 ++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 ++
 include/linux/perf_event.h                 |  1 +
 4 files changed, 43 insertions(+), 5 deletions(-)

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
index 722171c..e0f658a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1030,6 +1030,15 @@ static __initconst const u64 slm_hw_cache_event_ids
  },
 };
 
+static inline bool intel_pmu_needs_lbr_callstack(struct perf_event *event)
+{
+	if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+	    (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK))
+		return true;
+
+	return false;
+}
+
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1398,7 +1407,8 @@ again:
 
 		perf_sample_data_init(&data, 0, event->hw.last_period);
 
-		if (has_branch_stack(event))
+		if (has_branch_stack(event) ||
+		    (event->ctx->task && intel_pmu_needs_lbr_callstack(event)))
 			data.br_stack = &cpuc->lbr_stack;
 
 		if (perf_event_overflow(event, &data, regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 80bb097..a879910 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -722,6 +722,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
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
1.8.1.4

