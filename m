Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaCOFk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:40:27 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54987 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaCOFjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:39:54 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 2/4] arm64: split syscall_trace() into separate functions for enter/exit
Date: Sat, 15 Mar 2014 14:39:06 +0900
Message-Id: <1394861948-28712-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
 <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As done in arm, this change makes it easy to confirm we invoke syscall
related hooks, including syscall tracepoint, audit and seccomp which would
be implemented later, in correct order. That is, undoing operations in the
opposite order on exit that they were done on entry.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/entry.S  | 10 ++++------
 arch/arm64/kernel/ptrace.c | 50 +++++++++++++++++++++++++++-------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f9f2cae..00d6eb9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -649,9 +649,8 @@ ENDPROC(el0_svc)
 	 * switches, and waiting for our parent to respond.
 	 */
 __sys_trace:
-	mov	x1, sp
-	mov	w0, #0				// trace entry
-	bl	syscall_trace
+	mov	x0, sp
+	bl	syscall_trace_enter
 	adr	lr, __sys_trace_return		// return address
 	uxtw	scno, w0			// syscall number (possibly new)
 	mov	x1, sp				// pointer to regs
@@ -666,9 +665,8 @@ __sys_trace:
 
 __sys_trace_return:
 	str	x0, [sp]			// save returned x0
-	mov	x1, sp
-	mov	w0, #1				// trace exit
-	bl	syscall_trace
+	mov	x0, sp
+	bl	syscall_trace_exit
 	b	ret_to_user
 
 /*
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6a8928b..f606276 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1058,35 +1058,43 @@ long arch_ptrace(struct task_struct *child, long request,
 	return ptrace_request(child, request, addr, data);
 }
 
-asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
+enum ptrace_syscall_dir {
+	PTRACE_SYSCALL_ENTER = 0,
+	PTRACE_SYSCALL_EXIT,
+};
+
+static void tracehook_report_syscall(struct pt_regs *regs,
+				     enum ptrace_syscall_dir dir)
 {
+	int scrach;
 	unsigned long saved_reg;
 
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return regs->syscallno;
-
-	if (is_compat_task()) {
-		/* AArch32 uses ip (r12) for scratch */
-		saved_reg = regs->regs[12];
-		regs->regs[12] = dir;
-	} else {
-		/*
-		 * Save X7. X7 is used to denote syscall entry/exit:
-		 *   X7 = 0 -> entry, = 1 -> exit
-		 */
-		saved_reg = regs->regs[7];
-		regs->regs[7] = dir;
-	}
+	/*
+	 * A scrach register (ip(r12) on AArch32, x7 on AArch64) is
+	 * used to denote syscall entry/exit:
+	 */
+	scrach = (is_compat_task() ? 12 : 7);
+	saved_reg = regs->regs[scrach];
+	regs->regs[scrach] = dir;
 
-	if (dir)
+	if (dir == PTRACE_SYSCALL_EXIT)
 		tracehook_report_syscall_exit(regs, 0);
 	else if (tracehook_report_syscall_entry(regs))
 		regs->syscallno = ~0UL;
 
-	if (is_compat_task())
-		regs->regs[12] = saved_reg;
-	else
-		regs->regs[7] = saved_reg;
+	regs->regs[scrach] = saved_reg;
+}
+
+asmlinkage int syscall_trace_enter(struct pt_regs *regs)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
 	return regs->syscallno;
 }
+
+asmlinkage void syscall_trace_exit(struct pt_regs *regs)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
+}
-- 
1.8.3.2

