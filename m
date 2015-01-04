Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbbADSgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 13:36:35 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35346 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbbADSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 13:36:32 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: [PATCH 1/2] perf: Move task_pt_regs sampling into arch code
Date: Sun,  4 Jan 2015 10:36:19 -0800
Message-Id: <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1420396372.git.luto@amacapital.net>
References: <20150104174105.GA29388@krava.brq.redhat.com>
 <cover.1420396372.git.luto@amacapital.net>
In-Reply-To: <cover.1420396372.git.luto@amacapital.net>
References: <cover.1420396372.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, at least, task_pt_regs may be only partially initialized
in many contexts, so x86_64 should not use it without extra care
from interrupt context, let alone NMI context.

This will allow x86_64 to override the logic and will supply some
scratch space to use to make a cleaner copy of user regs.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/arm/kernel/perf_regs.c   |  8 ++++++++
 arch/arm64/kernel/perf_regs.c |  8 ++++++++
 arch/x86/kernel/perf_regs.c   | 16 ++++++++++++++++
 include/linux/perf_event.h    | 12 +++++++-----
 include/linux/perf_regs.h     | 16 ++++++++++++++++
 kernel/events/core.c          | 19 ++++++++-----------
 6 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/perf_regs.c b/arch/arm/kernel/perf_regs.c
index 6e4379c67cbc..592dda3f21ff 100644
--- a/arch/arm/kernel/perf_regs.c
+++ b/arch/arm/kernel/perf_regs.c
@@ -28,3 +28,11 @@ u64 perf_reg_abi(struct task_struct *task)
 {
 	return PERF_SAMPLE_REGS_ABI_32;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
index 6762ad705587..3f62b35fb6f1 100644
--- a/arch/arm64/kernel/perf_regs.c
+++ b/arch/arm64/kernel/perf_regs.c
@@ -50,3 +50,11 @@ u64 perf_reg_abi(struct task_struct *task)
 	else
 		return PERF_SAMPLE_REGS_ABI_64;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index e309cc5c276e..3bbbb1a4fb52 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -78,6 +78,14 @@ u64 perf_reg_abi(struct task_struct *task)
 {
 	return PERF_SAMPLE_REGS_ABI_32;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
 #else /* CONFIG_X86_64 */
 #define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
 		       (1ULL << PERF_REG_X86_ES) | \
@@ -102,4 +110,12 @@ u64 perf_reg_abi(struct task_struct *task)
 	else
 		return PERF_SAMPLE_REGS_ABI_64;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
 #endif /* CONFIG_X86_32 */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 486e84ccb1f9..4f7a61ca4b39 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -79,11 +79,6 @@ struct perf_branch_stack {
 	struct perf_branch_entry	entries[0];
 };
 
-struct perf_regs {
-	__u64		abi;
-	struct pt_regs	*regs;
-};
-
 struct task_struct;
 
 /*
@@ -610,7 +605,14 @@ struct perf_sample_data {
 		u32	reserved;
 	}				cpu_entry;
 	struct perf_callchain_entry	*callchain;
+
+	/*
+	 * regs_user may point to task_pt_regs or to regs_user_copy, depending
+	 * on arch details.
+	 */
 	struct perf_regs		regs_user;
+	struct pt_regs			regs_user_copy;
+
 	struct perf_regs		regs_intr;
 	u64				stack_user_size;
 } ____cacheline_aligned;
diff --git a/include/linux/perf_regs.h b/include/linux/perf_regs.h
index 3c73d5fe18be..a5f98d53d732 100644
--- a/include/linux/perf_regs.h
+++ b/include/linux/perf_regs.h
@@ -1,11 +1,19 @@
 #ifndef _LINUX_PERF_REGS_H
 #define _LINUX_PERF_REGS_H
 
+struct perf_regs {
+	__u64		abi;
+	struct pt_regs	*regs;
+};
+
 #ifdef CONFIG_HAVE_PERF_REGS
 #include <asm/perf_regs.h>
 u64 perf_reg_value(struct pt_regs *regs, int idx);
 int perf_reg_validate(u64 mask);
 u64 perf_reg_abi(struct task_struct *task);
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy);
 #else
 static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
 {
@@ -21,5 +29,13 @@ static inline u64 perf_reg_abi(struct task_struct *task)
 {
 	return PERF_SAMPLE_REGS_ABI_NONE;
 }
+
+static inline void perf_get_regs_user(struct perf_regs *regs_user,
+				      struct pt_regs *regs,
+				      struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
 #endif /* CONFIG_HAVE_PERF_REGS */
 #endif /* _LINUX_PERF_REGS_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c1ee7f2bebc..882f835a0d85 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4461,18 +4461,14 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 }
 
 static void perf_sample_regs_user(struct perf_regs *regs_user,
-				  struct pt_regs *regs)
+				  struct pt_regs *regs,
+				  struct pt_regs *regs_user_copy)
 {
-	if (!user_mode(regs)) {
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
-	}
-
-	if (regs) {
-		regs_user->abi  = perf_reg_abi(current);
+	if (user_mode(regs)) {
+		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
+	} else if (current->mm) {
+		perf_get_regs_user(regs_user, regs, regs_user_copy);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
 		regs_user->regs = NULL;
@@ -4951,7 +4947,8 @@ void perf_prepare_sample(struct perf_event_header *header,
 	}
 
 	if (sample_type & (PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER))
-		perf_sample_regs_user(&data->regs_user, regs);
+		perf_sample_regs_user(&data->regs_user, regs,
+				      &data->regs_user_copy);
 
 	if (sample_type & PERF_SAMPLE_REGS_USER) {
 		/* regs dump ABI info */
-- 
2.1.0

