Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaGGG3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:29:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:11640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbaGGG3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="539565608"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v5 11/16] perf, core: Pass perf_sample_data to perf_callchain()
Date: Mon,  7 Jul 2014 14:28:42 +0800
Message-Id: <1404714527-18603-14-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
References: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are executed
the last captured branch record is popped from the on-chip LBR registers.
The LBR call stack facility can help perf to get call chains of progam
without frame pointer.

This patch modifies various architectures' perf_callchain() to accept
perf sample data. Later patch will add code that use the sample data to
get call chains.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/arm/kernel/perf_event.c     | 4 ++--
 arch/powerpc/perf/callchain.c    | 4 ++--
 arch/sparc/kernel/perf_event.c   | 4 ++--
 arch/x86/kernel/cpu/perf_event.c | 4 ++--
 include/linux/perf_event.h       | 3 ++-
 kernel/events/callchain.c        | 8 +++++---
 kernel/events/core.c             | 2 +-
 kernel/events/internal.h         | 3 ++-
 8 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 4238bcb..4bc9148 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -579,8 +579,8 @@ user_backtrace(struct frame_tail __user *tail,
 	return buftail.fp - 1;
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	struct frame_tail __user *tail;
 
diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 74d1e78..b379ebc 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -482,8 +482,8 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 	}
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	if (current_is_64bit())
 		perf_callchain_user_64(entry, regs);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 8efd337..85c190e 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1788,8 +1788,8 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	perf_callchain_store(entry, regs->tpc);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5abbb8a..34f57ed 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2046,8 +2046,8 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 }
 #endif
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	struct stack_frame frame;
 	const void __user *fp;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4818c26..958a1d1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -722,7 +722,8 @@ extern void perf_event_fork(struct task_struct *tsk);
 /* Callchains */
 DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
-extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs);
+extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs,
+				struct perf_sample_data *data);
 extern void perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs);
 
 static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 97b67df..19d497c 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -30,7 +30,8 @@ __weak void perf_callchain_kernel(struct perf_callchain_entry *entry,
 }
 
 __weak void perf_callchain_user(struct perf_callchain_entry *entry,
-				struct pt_regs *regs)
+				struct pt_regs *regs,
+				struct perf_sample_data *data)
 {
 }
 
@@ -157,7 +158,8 @@ put_callchain_entry(int rctx)
 }
 
 struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs)
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+	       struct perf_sample_data *data)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
@@ -198,7 +200,7 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 				goto exit_put;
 
 			perf_callchain_store(entry, PERF_CONTEXT_USER);
-			perf_callchain_user(entry, regs);
+			perf_callchain_user(entry, regs, data);
 		}
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6ca082d..bfa7f49 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4750,7 +4750,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
-		data->callchain = perf_callchain(event, regs);
+		data->callchain = perf_callchain(event, regs, data);
 
 		if (data->callchain)
 			size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b2187..cd18b64 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -147,7 +147,8 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
 
 /* Callchain handling */
 extern struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs);
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+	       struct perf_sample_data *data);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
 
-- 
1.9.3

