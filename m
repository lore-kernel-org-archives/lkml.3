Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaJBJrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:47:20 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45065 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaJBJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:47:16 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v7 2/6] arm64: ptrace: allow tracer to skip a system call
Date: Thu,  2 Oct 2014 18:46:12 +0900
Message-Id: <1412243176-16192-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracer specifies -1 as a syscall number, this traced system call should
be skipped with a value in x0 used as a return value.
This patch implements this semantics, but there is one restriction here:

   when syscall(-1) is issued by user, tracer cannot skip this system call
   and modify a return value at syscall entry.

In order to ease this flavor, we need to take whatever value x0 has as
a return value, but this might result in a bogus value being returned,
especially when tracer doesn't do anything against this syscall.
So we always return ENOSYS instead, while we still have another chance to
change a return value at syscall exit.

Please also note:
* syscall entry tracing and syscall exit tracing (ftrace tracepoint and
  audit) are always executed, if enabled, even when skipping a system call
  (that is, -1).
  In this way, we can avoid a potential bug where audit_syscall_entry()
  might be called without audit_syscall_exit() at the previous system call
  being called, that would cause OOPs in audit_syscall_entry().

* syscallno may also be set to -1 if a fatal signal (SIGKILL) is detected
  in tracehook_report_syscall_entry(), but since a value set to x0 (ENOSYS)
  is not used in this case, we may neglect the case.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/ptrace.h |    8 ++++++++
 arch/arm64/kernel/entry.S       |    4 ++++
 arch/arm64/kernel/ptrace.c      |   23 ++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 41ed9e1..736ebc3 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -65,6 +65,14 @@
 #define COMPAT_PT_TEXT_ADDR		0x10000
 #define COMPAT_PT_DATA_ADDR		0x10004
 #define COMPAT_PT_TEXT_END_ADDR		0x10008
+
+/*
+ * System call will be skipped if a syscall number is changed to -1
+ * with ptrace(PTRACE_SET_SYSCALL).
+ * Upper 32-bit should be ignored for safe check.
+ */
+#define IS_SKIP_SYSCALL(no)	((int)(no & 0xffffffff) == -1)
+
 #ifndef __ASSEMBLY__
 
 /* sizeof(struct user) for AArch32 */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f0b5e51..b53a1c5 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -25,6 +25,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/errno.h>
 #include <asm/esr.h>
+#include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/unistd.h>
 
@@ -671,6 +672,8 @@ ENDPROC(el0_svc)
 __sys_trace:
 	mov	x0, sp
 	bl	syscall_trace_enter
+	cmp	w0, #-1				// skip the syscall?
+	b.eq	__sys_trace_return_skipped
 	adr	lr, __sys_trace_return		// return address
 	uxtw	scno, w0			// syscall number (possibly new)
 	mov	x1, sp				// pointer to regs
@@ -685,6 +688,7 @@ __sys_trace:
 
 __sys_trace_return:
 	str	x0, [sp]			// save returned x0
+__sys_trace_return_skipped:
 	mov	x0, sp
 	bl	syscall_trace_exit
 	b	ret_to_user
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 2842f9f..6b11c6a 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1126,6 +1126,8 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
+	unsigned int orig_syscallno = regs->syscallno;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
@@ -1133,7 +1135,26 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 		trace_sys_enter(regs, regs->syscallno);
 
 	audit_syscall_entry(syscall_get_arch(), regs->syscallno,
-		regs->orig_x0, regs->regs[1], regs->regs[2], regs->regs[3]);
+			regs->orig_x0, regs->regs[1],
+			regs->regs[2], regs->regs[3]);
+
+	if (IS_SKIP_SYSCALL(regs->syscallno) &&
+			IS_SKIP_SYSCALL(orig_syscallno)) {
+		/*
+		 * For compatibility, we handles user-issued syscall(-1).
+		 *
+		 * RESTRICTION: we can't modify a return value here in this
+		 * specific case. In order to ease this flavor, we have to
+		 * take whatever value x0 has as a return value, but this
+		 * might result in a bogus value being returned.
+		 *
+		 * NOTE: syscallno may also be set to -1 if fatal signal
+		 * is detected in tracehook_report_syscall(ENTRY),
+		 * but since a value set to x0 here is not used in this
+		 * case, we may neglect the case.
+		 */
+		regs->regs[0] = -ENOSYS;
+	}
 
 	return regs->syscallno;
 }
-- 
1.7.9.5

