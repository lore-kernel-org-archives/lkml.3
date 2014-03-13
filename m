Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaCMKNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:13:06 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48254 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCMKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:13:01 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v4 2/3] arm64: split syscall_trace() into separate functions for enter/exit
Date: Thu, 13 Mar 2014 19:11:30 +0900
Message-Id: <1394705491-12343-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393564465-3862-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As done in arm, this change makes it easy to confirm we invoke syscall
related hooks, including syscall tracepoint, audit and seccomp which would
be implemented later, in correct order. That is, undoing operations in the
opposite order on exit that they were done on entry.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/entry.S  |   10 ++++-----
 arch/arm64/kernel/ptrace.c |   48 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 17 deletions(-)

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
index 6a8928b..9993a8f 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1058,29 +1058,27 @@ long arch_ptrace(struct task_struct *child, long request,
 	return ptrace_request(child, request, addr, data);
 }
 
-asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
+asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long saved_reg;
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return regs->syscallno;
 
+	/*
+	 * A scrach register (ip(r12) on AArch32, x7 on AArch64) is
+	 * used to denote syscall entry/exit:
+	 *   0 -> entry
+	 */
 	if (is_compat_task()) {
-		/* AArch32 uses ip (r12) for scratch */
 		saved_reg = regs->regs[12];
-		regs->regs[12] = dir;
+		regs->regs[12] = 0;
 	} else {
-		/*
-		 * Save X7. X7 is used to denote syscall entry/exit:
-		 *   X7 = 0 -> entry, = 1 -> exit
-		 */
 		saved_reg = regs->regs[7];
-		regs->regs[7] = dir;
+		regs->regs[7] = 0;
 	}
 
-	if (dir)
-		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
+	if (tracehook_report_syscall_entry(regs))
 		regs->syscallno = ~0UL;
 
 	if (is_compat_task())
@@ -1090,3 +1088,31 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 
 	return regs->syscallno;
 }
+
+asmlinkage void syscall_trace_exit(struct pt_regs *regs)
+{
+	unsigned long saved_reg;
+
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return;
+
+	/*
+	 * A scrach register (ip(r12) on AArch32, x7 on AArch64) is
+	 * used to denote syscall entry/exit:
+	 *   1 -> exit
+	 */
+	if (is_compat_task()) {
+		saved_reg = regs->regs[12];
+		regs->regs[12] = 1;
+	} else {
+		saved_reg = regs->regs[7];
+		regs->regs[7] = 1;
+	}
+
+	tracehook_report_syscall_exit(regs, 0);
+
+	if (is_compat_task())
+		regs->regs[12] = saved_reg;
+	else
+		regs->regs[7] = saved_reg;
+}
-- 
1.7.9.5

