Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbbAIMeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:34:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbbAIMeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:34:11 -0500
Date: Fri, 9 Jan 2015 04:32:11 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-88a7c26af8dab2f2d69f5a6067eb670694ec38c0@git.kernel.org>
Cc: namhyung@gmail.com, acme@kernel.org, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, efault@gmx.de, eranian@google.com,
        msalter@redhat.com, luto@amacapital.net, jolsa@kernel.org,
        torvalds@linux-foundation.org, dsahern@gmail.com, tglx@linutronix.de,
        will.deacon@arm.com, mingo@kernel.org, hpa@zytor.com,
        jean.pihet@linaro.org, fengguang.wu@intel.com, arjan@linux.intel.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Reply-To: namhyung@gmail.com, linux@arm.linux.org.uk, acme@kernel.org,
        luto@amacapital.net, msalter@redhat.com, eranian@google.com,
        efault@gmx.de, catalin.marinas@arm.com, torvalds@linux-foundation.org,
        jolsa@kernel.org, tglx@linutronix.de, will.deacon@arm.com,
        dsahern@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, arjan@linux.intel.com, fengguang.wu@intel.com,
        jean.pihet@linaro.org, hpa@zytor.com
In-Reply-To: <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
References: <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Move task_pt_regs sampling into arch code
Git-Commit-ID: 88a7c26af8dab2f2d69f5a6067eb670694ec38c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88a7c26af8dab2f2d69f5a6067eb670694ec38c0
Gitweb:     http://git.kernel.org/tip/88a7c26af8dab2f2d69f5a6067eb670694ec38c0
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Sun, 4 Jan 2015 10:36:19 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:12:28 +0100

perf: Move task_pt_regs sampling into arch code

On x86_64, at least, task_pt_regs may be only partially initialized
in many contexts, so x86_64 should not use it without extra care
from interrupt context, let alone NMI context.

This will allow x86_64 to override the logic and will supply some
scratch space to use to make a cleaner copy of user regs.

Tested-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: chenggang.qcg@taobao.com
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/kernel/perf_regs.c   |  8 ++++++++
 arch/arm64/kernel/perf_regs.c |  8 ++++++++
 arch/x86/kernel/perf_regs.c   | 16 ++++++++++++++++
 include/linux/perf_event.h    | 12 +++++++-----
 include/linux/perf_regs.h     | 16 ++++++++++++++++
 kernel/events/core.c          | 19 ++++++++-----------
 6 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/perf_regs.c b/arch/arm/kernel/perf_regs.c
index 6e4379c..592dda3 100644
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
index 6762ad7..3f62b35 100644
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
index e309cc5..3bbbb1a 100644
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
index 486e84c..4f7a61c 100644
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
index 3c73d5f..a5f98d5 100644
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
index 4c1ee7f..882f835 100644
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
