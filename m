Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LKHMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:12:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:45634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3LKHLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352544"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 12/15] perf, core: Pass perf_sample_data to perf_callchain()
Date: Wed, 11 Dec 2013 15:10:57 +0800
Message-Id: <1386745860-21143-13-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

New Intel CPU can record call chains by using existing last branch
record facility. perf_callchain_user() can make use of the call
chains recorded by hardware in case of there is no frame pointer.

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
index bc3f2ef..fdcc654 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -566,8 +566,8 @@ user_backtrace(struct frame_tail __user *tail,
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
index b5c38fa..cba0306 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1785,8 +1785,8 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	perf_callchain_store(entry, regs->tpc);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2e43f1b..49128e6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2009,8 +2009,8 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
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
index 0d88eb8..c442276 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -709,7 +709,8 @@ extern void perf_event_fork(struct task_struct *tsk);
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
index e039dbc..127b882 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4656,7 +4656,7 @@ void perf_prepare_sample(struct perf_event_header *header,
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
1.8.1.4

