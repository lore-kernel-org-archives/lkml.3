Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaGVJPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:15:47 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63274 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaGVJPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:15:45 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com,
        keescook@chromium.org
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after ptrace operations
Date: Tue, 22 Jul 2014 18:14:57 +0900
Message-Id: <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arm64 holds a syscall number in w8(x8) register. Ptrace tracer may change
its value either to:
  * any valid syscall number to alter a system call, or
  * -1 to skip a system call

This patch implements this behavior by reloading that value into syscallno
in struct pt_regs after tracehook_report_syscall_entry() or
secure_computing(). In case of '-1', a return value of system call can also
be changed by the tracer setting the value to x0 register, and so
sys_ni_nosyscall() should not be called.

See also:
    42309ab4, ARM: 8087/1: ptrace: reload syscall number after
	      secure_computing() check

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/entry.S  |    2 ++
 arch/arm64/kernel/ptrace.c |   13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5141e79..de8bdbc 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -628,6 +628,8 @@ ENDPROC(el0_svc)
 __sys_trace:
 	mov	x0, sp
 	bl	syscall_trace_enter
+	cmp	w0, #-1				// skip syscall?
+	b.eq	ret_to_user
 	adr	lr, __sys_trace_return		// return address
 	uxtw	scno, w0			// syscall number (possibly new)
 	mov	x1, sp				// pointer to regs
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 70526cf..100d7d1 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -21,6 +21,7 @@
 
 #include <linux/audit.h>
 #include <linux/compat.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -1109,9 +1110,21 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
+	unsigned long saved_x0, saved_x8;
+
+	saved_x0 = regs->regs[0];
+	saved_x8 = regs->regs[8];
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
+	regs->syscallno = regs->regs[8];
+	if ((long)regs->syscallno == ~0UL) { /* skip this syscall */
+		regs->regs[8] = saved_x8;
+		if (regs->regs[0] == saved_x0) /* not changed by user */
+			regs->regs[0] = -ENOSYS;
+	}
+
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, regs->syscallno);
 
-- 
1.7.9.5

