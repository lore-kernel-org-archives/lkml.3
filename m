Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaIJC6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:58:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:29986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbaIJC6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,495,1406617200"; 
   d="scan'208";a="597207905"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 12/16] perf, x86: use LBR call stack to get user callchain
Date: Sun,  7 Jan 2001 21:31:59 -0500
Message-Id: <978921123-30240-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <978921123-30240-1-git-send-email-kan.liang@intel.com>
References: <978921123-30240-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are
executed
the last captured branch record is popped from the on-chip LBR
registers.
The LBR call stack facility can help perf to get call chains of progam
without frame pointer.

This patch makes x86's perf_callchain_user() failback to use LBR call
stack data when there is no frame pointer in the user program. The
'from'
address of branch entry is used as 'return' address of function call.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           | 34 ++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel.c     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 ++
 include/linux/perf_event.h                 |  1 +
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 71e293a..0a71f04 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2005,12 +2005,29 @@ static unsigned long get_segment_base(unsigned int segment)
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
+
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
@@ -2039,11 +2056,16 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
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
@@ -2073,12 +2095,12 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
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
@@ -2091,6 +2113,10 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
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
index 49e7d14..93e8038 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1404,7 +1404,7 @@ again:
 
 		perf_sample_data_init(&data, 0, event->hw.last_period);
 
-		if (has_branch_stack(event))
+		if (needs_branch_stack(event))
 			data.br_stack = &cpuc->lbr_stack;
 
 		if (perf_event_overflow(event, &data, regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 6aabbb4..5afb21b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -743,6 +743,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 	int i, j, type;
 	bool compress = false;
 
+	cpuc->lbr_stack.user_callstack = branch_user_callstack(br_sel);
+
 	/* if sampling all branches, then nothing to filter */
 	if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
 		return;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8db3520..4d38d5e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -75,6 +75,7 @@ struct perf_raw_record {
  * recent branch.
  */
 struct perf_branch_stack {
+	bool				user_callstack;
 	__u64				nr;
 	struct perf_branch_entry	entries[0];
 };
-- 
1.8.3.2

