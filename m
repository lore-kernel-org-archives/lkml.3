Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3CUAIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:08:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61905 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3CUAIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:08:53 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 20:08:52 EDT
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Mats Liljegren <mats.liljegren@enea.com>
Subject: [PATCH 2/4] ARM: context tracking: instrument system calls
Date: Wed, 20 Mar 2013 17:01:59 -0700
Message-Id: <1363824121-26169-3-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1363824121-26169-1-git-send-email-khilman@linaro.org>
References: <1363824121-26169-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When context tracking (TIF_NOHZ), force the syscall slow path by
adding _TIF_NOHZ to _TIF_SYSCALL_WORK.  Use the syscall trace
enter/exit paths to do the context tracking.  This corresponds to
commit bf5a3c13 (x86: Syscall hooks for userspace RCU extended QS.)

Also cover the special case in syscall_trace_exit() based on commit
2c5594df (rcu: Fix unrecovered RCU user mode in syscall_trace_leave())
for x86.

Special thanks to Mats Liljegren for collaboration and additional
testing.

Cc: Mats Liljegren <mats.liljegren@enea.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/include/asm/thread_info.h |  4 +++-
 arch/arm/kernel/ptrace.c           | 11 +++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..e4c7e21 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -152,6 +152,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_SYSCALL_AUDIT	9
 #define TIF_SYSCALL_TRACEPOINT	10
 #define TIF_SECCOMP		11	/* seccomp syscall filtering active */
+#define TIF_NOHZ		12	/* in adaptive nohz mode */
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
@@ -165,10 +166,11 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
+#define _TIF_NOHZ		(1 << TIF_NOHZ)
 
 /* Checks for any syscall work in entry-common.S */
 #define _TIF_SYSCALL_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-			   _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
+			   _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | _TIF_NOHZ)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 03deeff..3ab329a 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -26,6 +26,7 @@
 #include <linux/audit.h>
 #include <linux/tracehook.h>
 #include <linux/unistd.h>
+#include <linux/context_tracking.h>
 
 #include <asm/pgtable.h>
 #include <asm/traps.h>
@@ -941,6 +942,8 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 {
 	current_thread_info()->syscall = scno;
 
+	user_exit();
+
 	/* Do the secure computing check first; failures should be fast. */
 	if (secure_computing(scno) == -1)
 		return -1;
@@ -960,6 +963,12 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
 	/*
+	 * We may come here right after calling do_work_pending() in
+	 * which case we can be in context_tracking user mode.
+	 */
+	user_exit();
+
+	/*
 	 * Audit the syscall before anything else, as a debugger may
 	 * come in and change the current registers.
 	 */
@@ -976,4 +985,6 @@ asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
+
+	user_enter();
 }
-- 
1.8.2

