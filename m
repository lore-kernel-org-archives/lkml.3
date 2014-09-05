Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaIEJrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:47:19 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:52224 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbaIEJrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:47:14 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: linux@arm.linux.org.uk, will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH] arm: prevent BUG_ON in audit_syscall_entry()
Date: Fri,  5 Sep 2014 18:46:33 +0900
Message-Id: <1409910393-30896-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG_ON() in audit_syscall_entry() will be hit if user issues syscall(-1)
while syscall auditing is enabled (that is, by starting auditd).
In fact, syscall(-1) just fails (not signaled despite the expectation,
this is another minor bug), but the succeeding syscall hits BUG_ON.

When auditing syscall(-1), audit_syscall_entry() is called anyway, but
audit_syscall_exit() is not called and then 'in_syscall' flag in thread's
audit context is kept on. In this way, audit_syscall_entry() against
the succeeding syscall will see BUG_ON(in_syscall).

This patch fixes this bug by
1) enforcing syscall exit tracing, including audit_syscall_exit(), to be
   executed in all cases,
2) handling user-issued syscall(-1) with arm_syscall().

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm/kernel/entry-common.S |    4 ++--
 arch/arm/kernel/ptrace.c       |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index e52fe5a..28d3931 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -426,7 +426,6 @@ ENTRY(vector_swi)
 local_restart:
 	ldr	r10, [tsk, #TI_FLAGS]		@ check for syscall tracing
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
-
 	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
 	bne	__sys_trace
 
@@ -476,10 +475,11 @@ __sys_trace:
 	cmp	scno, #-1			@ skip the syscall?
 	bne	2b
 	add	sp, sp, #S_OFF			@ restore stack
-	b	ret_slow_syscall
+	b	__sys_trace_return_skipped
 
 __sys_trace_return:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
+__sys_trace_return_skipped:
 	mov	r0, sp
 	bl	syscall_trace_exit
 	b	ret_slow_syscall
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 0c27ed6..f3339c8 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -928,9 +928,13 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	regs->ARM_ip = ip;
 }
 
+extern int arm_syscall(int, struct pt_regs *);
+
 asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 {
-	current_thread_info()->syscall = scno;
+	int orig_scno;
+
+	current_thread_info()->syscall = orig_scno = scno;
 
 	/* Do the secure computing check first; failures should be fast. */
 	if (secure_computing(scno) == -1)
@@ -947,6 +951,10 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
 			    regs->ARM_r2, regs->ARM_r3);
 
+	/* user-issued syscall of -1 */
+	if (scno == -1 && orig_scno == -1)
+		arm_syscall(scno, regs);
+
 	return scno;
 }
 
-- 
1.7.9.5

