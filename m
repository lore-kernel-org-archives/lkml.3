Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaFRUa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:30:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59074 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbaFRUaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:30:55 -0400
Date: Wed, 18 Jun 2014 13:27:48 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        Oleg Nesterov <oleg@redhat.com>, linux-arm-kernel@lists.infradead.org,
        Ricky Zhou <rickyz@google.com>
Subject: [PATCH] arm: ptrace: fix syscall modification under
 PTRACE_O_TRACESECCOMP
Message-ID: <20140618202748.GA9022@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An x86 tracer wanting to change the syscall uses PTRACE_SETREGS
(stored to regs->orig_ax), and an ARM tracer uses PTRACE_SET_SYSCALL
(stored to current_thread_info()->syscall). When this happens, the
syscall can change across the call to secure_computing(), since it may
block on tracer notification, and the tracer can then make changes
to the process, before we return from secure_computing(). This
means the code must respect the changed syscall after the
secure_computing() call in syscall_trace_enter(). The same is true
for tracehook_report_syscall_entry() which may also block and change
the syscall.

The x86 code handles this (it expects orig_ax to always be the
desired syscall). In the ARM case, this means we should not be touching
current_thread_info()->syscall after its initial assignment. All failures
should result in a -1 syscall, though.

Based on patch by Ricky Zhou.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ricky Zhou <rickyz@google.com>
Cc: stable@vger.kernel.org
---
 arch/arm/kernel/ptrace.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 0dd3b79b15c3..97bd95f6aa01 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -911,6 +911,7 @@ enum ptrace_syscall_dir {
 static int tracehook_report_syscall(struct pt_regs *regs,
 				    enum ptrace_syscall_dir dir)
 {
+	int ret = 0;
 	unsigned long ip;
 
 	/*
@@ -923,30 +924,35 @@ static int tracehook_report_syscall(struct pt_regs *regs,
 	if (dir == PTRACE_SYSCALL_EXIT)
 		tracehook_report_syscall_exit(regs, 0);
 	else if (tracehook_report_syscall_entry(regs))
-		current_thread_info()->syscall = -1;
+		ret = -1;
 
 	regs->ARM_ip = ip;
-	return current_thread_info()->syscall;
+	return ret;
 }
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 {
+	int ret = 0;
+
+	/* set up syscall, which may be changed in secure_computing */
 	current_thread_info()->syscall = scno;
 
 	/* Do the secure computing check first; failures should be fast. */
 	if (secure_computing(scno) == -1)
 		return -1;
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		scno = tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
+	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
+	    tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER))
+		ret = -1;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-		trace_sys_enter(regs, scno);
+		trace_sys_enter(regs, current_thread_info()->syscall);
 
-	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
+	audit_syscall_entry(AUDIT_ARCH_ARM, current_thread_info()->syscall,
+			    regs->ARM_r0, regs->ARM_r1,
 			    regs->ARM_r2, regs->ARM_r3);
 
-	return scno;
+	return ret ?: current_thread_info()->syscall;
 }
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
