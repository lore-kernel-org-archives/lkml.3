Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3AVAzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:55:45 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:45332 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3AVAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:55:15 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 3/4] tile: Add support for TIF_SYSCALL_TRACEPOINT
Date: Mon, 21 Jan 2013 19:54:57 -0500
Message-Id: <1358816098-13070-3-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
References: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 22 Jan 2013 00:55:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the TIF_SYSCALL_TRACEPOINT on the tile
architecture. Basically, it calls the appropriate tracepoints on syscall
entry and exit.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/include/asm/thread_info.h |    8 ++++++++
 arch/tile/kernel/intvec_64.S        |   14 ++++++++++----
 arch/tile/kernel/ptrace.c           |   17 ++++++++++++++---
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index e9c670d..c96331e 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -124,6 +124,7 @@ extern void _cpu_idle(void);
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_MEMDIE		7	/* OOM killer at work */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
+#define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation */
 
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -134,12 +135,19 @@ extern void _cpu_idle(void);
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
+#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 
 /* Work to do on any return to user space. */
 #define _TIF_ALLWORK_MASK \
   (_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SINGLESTEP|\
    _TIF_ASYNC_TLB|_TIF_NOTIFY_RESUME)
 
+/* Work to do at syscall entry. */
+#define _TIF_SYSCALL_ENTRY_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT)
+
+/* Work to do at syscall exit. */
+#define _TIF_SYSCALL_EXIT_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT)
+
 /*
  * Thread-synchronous status.
  *
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index fd78cd4..505e6d4 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1000,8 +1000,11 @@ handle_syscall:
 
 	/* Trace syscalls, if requested. */
 	addi	r31, r31, THREAD_INFO_FLAGS_OFFSET
-	ld	r30, r31
-	andi    r30, r30, _TIF_SYSCALL_TRACE
+	{
+	 ld     r30, r31
+	 moveli r32, _TIF_SYSCALL_ENTRY_WORK
+	}
+	and     r30, r30, r32
 	{
 	 addi   r30, r31, THREAD_INFO_STATUS_OFFSET - THREAD_INFO_FLAGS_OFFSET
 	 beqzt	r30, .Lrestore_syscall_regs
@@ -1070,8 +1073,11 @@ handle_syscall:
 	FEEDBACK_REENTER(handle_syscall)
 
 	/* Do syscall trace again, if requested. */
-	ld	r30, r31
-	andi    r0, r30, _TIF_SYSCALL_TRACE
+	{
+	 ld      r30, r31
+	 moveli  r32, _TIF_SYSCALL_EXIT_WORK
+	}
+	and      r0, r30, r32
 	{
 	 andi    r0, r30, _TIF_SINGLESTEP
 	 beqzt   r0, 1f
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 0ab8b76..363b2dd 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -25,6 +25,9 @@
 #include <asm/traps.h>
 #include <arch/chip.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 void user_enable_single_step(struct task_struct *child)
 {
 	set_tsk_thread_flag(child, TIF_SINGLESTEP);
@@ -249,16 +252,24 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 int do_syscall_trace_enter(struct pt_regs *regs)
 {
-	if (tracehook_report_syscall_entry(regs)) {
-		regs->regs[TREG_SYSCALL_NR] = -1;
+	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
+		if (tracehook_report_syscall_entry(regs))
+			regs->regs[TREG_SYSCALL_NR] = -1;
 	}
 
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		trace_sys_enter(regs, regs->regs[TREG_SYSCALL_NR]);
+
 	return regs->regs[TREG_SYSCALL_NR];
 }
 
 void do_syscall_trace_exit(struct pt_regs *regs)
 {
-	tracehook_report_syscall_exit(regs, 0);
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(regs, 0);
+
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		trace_sys_exit(regs, regs->regs[TREG_SYSCALL_NR]);
 }
 
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
-- 
1.7.1

