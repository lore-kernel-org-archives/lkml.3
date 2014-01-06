Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbaAFWwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:52:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbaAFWwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:52:40 -0500
From: Sergio Durigan Junior <sergiodj@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Organization: Red Hat Brazil
X-URL: http://www.redhat.com
Date: Mon, 06 Jan 2014 20:52:30 -0200
Message-ID: <m3wqic205t.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a somewhat long-wanted feature in the GDB world.  I'm taking my
chances and trying to implement this, let's see how it goes!

This patch implements the new PTRACE_EVENT_SYSCALL_{ENTER,EXIT} events
for ptrace.  The goal is kind of obvious: it lets the tracer to request
for notifications when a syscall is called or has returned in the
tracee.  This is very useful because currently there is no easy/direct
way to inspect whether we are dealing with a call or a return of a
syscall.  GDB itself has an open bug about this, because it can get
confused when the program being debugged is restarted in the middle of a
syscall that has been caught by "catch syscall".

The other nice thing that I have implemented is the ability to obtain
the syscall number related to the event by using PTRACE_GET_EVENTMSG.
This way, we don't need to inspect registers anymore when we want to
know which syscall is responsible for this or that event.  This was easy
to implement, and is a pretty good thing for Linux to export to
userspace, so I decided to include in the patch as well.

I only tested this patch on x86_64 GNU/Linux (Fedora 19).  No tests have
been done on the other architectures affected by this patch, mostly
because I don't have access to them, but also because the modifications
seem pretty straightforward.  However, I will gladly welcome testers for
this.

This patch is mostly an RFC, so I did not take much time to split it
into smaller pieces and send them to the correct maintainers of each
part.  What I'm looking for now is a feedback of my approach.  The
really interesting bits are at the bottom of the patch, which deal with
tracehook.h and its friends in order to implement the new ptrace
options.

Comments are welcome.  Thanks.

--
Sergio

Signed-off-by: Sergio Durigan Junior <sergiodj@redhat.com>

diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index 2a4a80f..fbbea67 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -317,7 +317,8 @@ asmlinkage unsigned long syscall_trace_enter(void)
 {
 	unsigned long ret = 0;
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(current_pt_regs()))
+	    tracehook_report_syscall_entry(current_pt_regs(),
+					current_pt_regs()->r0))
 		ret = -1UL;
 	return ret ?: current_pt_regs()->r0;
 }
@@ -326,5 +327,6 @@ asmlinkage void
 syscall_trace_leave(void)
 {
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(current_pt_regs(), 0);
+		tracehook_report_syscall_exit(current_pt_regs(), 0,
+						current_pt_regs()->r0);
 }
diff --git a/arch/arc/kernel/ptrace.c b/arch/arc/kernel/ptrace.c
index 5d76706..063949a 100644
--- a/arch/arc/kernel/ptrace.c
+++ b/arch/arc/kernel/ptrace.c
@@ -156,7 +156,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 asmlinkage int syscall_trace_entry(struct pt_regs *regs)
 {
-	if (tracehook_report_syscall_entry(regs))
+	if (tracehook_report_syscall_entry(regs, regs->r8))
 		return ULONG_MAX;
 
 	return regs->r8;
@@ -164,5 +164,5 @@ asmlinkage int syscall_trace_entry(struct pt_regs *regs)
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
-	tracehook_report_syscall_exit(regs, 0);
+	tracehook_report_syscall_exit(regs, 0, regs->r8);
 }
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 0dd3b79..1a115c7 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -921,8 +921,10 @@ static int tracehook_report_syscall(struct pt_regs *regs,
 	regs->ARM_ip = dir;
 
 	if (dir == PTRACE_SYSCALL_EXIT)
-		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
+		tracehook_report_syscall_exit(regs, 0,
+					current_thread_info()->syscall);
+	else if (tracehook_report_syscall_entry(regs,
+					current_thread_info()->syscall))
 		current_thread_info()->syscall = -1;
 
 	regs->ARM_ip = ip;
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6a8928b..34d283a 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1079,8 +1079,8 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 	}
 
 	if (dir)
-		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
+		tracehook_report_syscall_exit(regs, 0, regs->syscallno);
+	else if (tracehook_report_syscall_entry(regs, regs->syscallno))
 		regs->syscallno = ~0UL;
 
 	if (is_compat_task())
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index e1f88e0..e282468 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -392,7 +392,7 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	int ret = 0;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		ret = tracehook_report_syscall_entry(regs);
+		ret = tracehook_report_syscall_entry(regs, regs->p0);
 
 	return ret;
 }
@@ -403,5 +403,5 @@ asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->p0);
 }
diff --git a/arch/c6x/kernel/ptrace.c b/arch/c6x/kernel/ptrace.c
index 3c494e8..7f8dd66 100644
--- a/arch/c6x/kernel/ptrace.c
+++ b/arch/c6x/kernel/ptrace.c
@@ -167,7 +167,7 @@ long arch_ptrace(struct task_struct *child, long request,
  */
 asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs)
 {
-	if (tracehook_report_syscall_entry(regs))
+	if (tracehook_report_syscall_entry(regs, regs->b0))
 		/* tracing decided this syscall should not happen, so
 		 * We'll return a bogus call number to get an ENOSYS
 		 * error, but leave the original number in
@@ -183,5 +183,5 @@ asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs)
  */
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
-	tracehook_report_syscall_exit(regs, 0);
+	tracehook_report_syscall_exit(regs, 0, regs->b0);
 }
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 3987ff8..d2038c8 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -355,7 +355,7 @@ long arch_ptrace(struct task_struct *child, long request,
 asmlinkage unsigned long syscall_trace_entry(void)
 {
 	__frame->__status |= REG__STATUS_SYSC_ENTRY;
-	if (tracehook_report_syscall_entry(__frame)) {
+	if (tracehook_report_syscall_entry(__frame, __frame->syscallno)) {
 		/* tracing decided this syscall should not happen, so
 		 * We'll return a bogus call number to get an ENOSYS
 		 * error, but leave the original number in
@@ -373,5 +373,5 @@ asmlinkage unsigned long syscall_trace_entry(void)
 asmlinkage void syscall_trace_exit(void)
 {
 	__frame->__status |= REG__STATUS_SYSC_EXIT;
-	tracehook_report_syscall_exit(__frame, 0);
+	tracehook_report_syscall_exit(__frame, 0, __frame->syscallno);
 }
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 7858663..2f698cd 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -366,7 +366,7 @@ void do_trap0(struct pt_regs *regs)
 
 		/* allow strace to catch syscall args  */
 		if (unlikely(test_thread_flag(TIF_SYSCALL_TRACE) &&
-			tracehook_report_syscall_entry(regs)))
+			tracehook_report_syscall_entry(regs, regs->r06)))
 			return;  /*  return -ENOSYS somewhere?  */
 
 		/* Interrupts should be re-enabled for syscall processing */
@@ -404,7 +404,7 @@ void do_trap0(struct pt_regs *regs)
 
 		/* allow strace to get the syscall return state  */
 		if (unlikely(test_thread_flag(TIF_SYSCALL_TRACE)))
-			tracehook_report_syscall_exit(regs, 0);
+			tracehook_report_syscall_exit(regs, 0, regs->r06);
 
 		break;
 	case TRAP_DEBUG:
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index b7a5fff..605a22e 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1211,7 +1211,7 @@ syscall_trace_enter (long arg0, long arg1, long arg2, long arg3,
 		     struct pt_regs regs)
 {
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		if (tracehook_report_syscall_entry(&regs))
+		if (tracehook_report_syscall_entry(&regs, regs.r15))
 			return -ENOSYS;
 
 	/* copy user rbs to kernel rbs */
@@ -1237,7 +1237,7 @@ syscall_trace_leave (long arg0, long arg1, long arg2, long arg3,
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(&regs, step);
+		tracehook_report_syscall_exit(&regs, step, regs.r15);
 
 	/* copy user rbs to kernel rbs */
 	if (test_thread_flag(TIF_RESTORE_RSE))
diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 1bc10e6..6f3e159 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -292,13 +292,15 @@ asmlinkage int syscall_trace_enter(void)
 	int ret = 0;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		ret = tracehook_report_syscall_entry(task_pt_regs(current));
+		ret = tracehook_report_syscall_entry(task_pt_regs(current),
+						task_pt_regs(current)->d1);
 	return ret;
 }
 
 asmlinkage void syscall_trace_leave(void)
 {
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(task_pt_regs(current), 0);
+		tracehook_report_syscall_exit(task_pt_regs(current), 0,
+						task_pt_regs(current)->d1);
 }
 #endif /* CONFIG_COLDFIRE */
diff --git a/arch/metag/kernel/ptrace.c b/arch/metag/kernel/ptrace.c
index 7563628..4b84218 100644
--- a/arch/metag/kernel/ptrace.c
+++ b/arch/metag/kernel/ptrace.c
@@ -396,7 +396,7 @@ int syscall_trace_enter(struct pt_regs *regs)
 	int ret = 0;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		ret = tracehook_report_syscall_entry(regs);
+		ret = tracehook_report_syscall_entry(regs, regs->ctx.DX[0].U1);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->ctx.DX[0].U1);
@@ -410,5 +410,5 @@ void syscall_trace_leave(struct pt_regs *regs)
 		trace_sys_exit(regs, regs->ctx.DX[0].U1);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, 0);
+		tracehook_report_syscall_exit(regs, 0, regs->ctx.DX[0].U1);
 }
diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index 39cf508..60a44c0 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -139,7 +139,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	secure_computing_strict(regs->r12);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->r12))
 		/*
 		 * Tracing decided this syscall should not happen.
 		 * We'll return a bogus call number to get an ENOSYS
@@ -161,7 +161,7 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->r12);
 }
 
 void ptrace_disable(struct task_struct *child)
diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index 5bd5851..621fa8d 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -365,7 +365,7 @@ long arch_ptrace(struct task_struct *child, long request,
  */
 asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs)
 {
-	if (tracehook_report_syscall_entry(regs))
+	if (tracehook_report_syscall_entry(regs, regs->orig_d0))
 		/* tracing decided this syscall should not happen, so
 		 * We'll return a bogus call number to get an ENOSYS
 		 * error, but leave the original number in
@@ -381,5 +381,5 @@ asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs)
  */
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
-	tracehook_report_syscall_exit(regs, 0);
+	tracehook_report_syscall_exit(regs, 0, regs->orig_d0);
 }
diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
index 71a2a0c..70c819c 100644
--- a/arch/openrisc/kernel/ptrace.c
+++ b/arch/openrisc/kernel/ptrace.c
@@ -179,7 +179,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	long ret = 0;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->gpr[11]))
 		/*
 		 * Tracing decided this syscall should not happen.
 		 * We'll return a bogus call number to get an ENOSYS
@@ -202,5 +202,5 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->gpr[11]);
 }
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index e842ee2..13f75ee 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -271,7 +271,7 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 	long ret = 0;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->gr[20]))
 		ret = -1L;
 
 #ifdef CONFIG_64BIT
@@ -300,5 +300,5 @@ void do_syscall_trace_exit(struct pt_regs *regs)
 	audit_syscall_exit(regs);
 
 	if (stepping || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, stepping);
+		tracehook_report_syscall_exit(regs, stepping, regs->gr[20]);
 }
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 2e3d2bf..f9430b9 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1775,7 +1775,7 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 	secure_computing_strict(regs->gpr[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->gpr[0]))
 		/*
 		 * Tracing decided this syscall should not happen.
 		 * We'll return a bogus call number to get an ENOSYS
@@ -1815,7 +1815,7 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->gpr[0]);
 
 	user_enter();
 }
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index e65c91c..8088fde 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -798,7 +798,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	 * call number to gprs[2].
 	 */
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    (tracehook_report_syscall_entry(regs) ||
+	    (tracehook_report_syscall_entry(regs, regs->gprs[2]) ||
 	     regs->gprs[2] >= NR_syscalls)) {
 		/*
 		 * Tracing decided this syscall should not happen or the
@@ -829,7 +829,7 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
 		trace_sys_exit(regs, regs->gprs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, 0);
+		tracehook_report_syscall_exit(regs, 0, regs->gprs[2]);
 }
 
 /*
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 668c816..f3b8a72 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -502,7 +502,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	secure_computing_strict(regs->regs[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->regs[3]))
 		/*
 		 * Tracing decided this syscall should not happen.
 		 * We'll return a bogus call number to get an ENOSYS
@@ -531,5 +531,5 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->regs[3]);
 }
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index af90339..93089e4 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -525,7 +525,7 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 	secure_computing_strict(regs->regs[9]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->regs[9]))
 		/*
 		 * Tracing decided this syscall should not happen.
 		 * We'll return a bogus call number to get an ENOSYS
@@ -554,7 +554,7 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->regs[9]);
 }
 
 /* Called with interrupts disabled */
diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index 896ba7c..174a675 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -447,9 +447,11 @@ asmlinkage int syscall_trace(struct pt_regs *regs, int syscall_exit_p)
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
 		if (syscall_exit_p)
-			tracehook_report_syscall_exit(regs, 0);
+			tracehook_report_syscall_exit(regs, 0,
+						regs->u_regs[UREG_G1]);
 		else
-			ret = tracehook_report_syscall_entry(regs);
+			ret = tracehook_report_syscall_entry(regs,
+						regs->u_regs[UREG_G1]);
 	}
 
 	return ret;
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index c13c9f2..b2019a9 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -1071,7 +1071,8 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 		user_exit();
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		ret = tracehook_report_syscall_entry(regs);
+		ret = tracehook_report_syscall_entry(regs,
+						regs->u_regs[UREG_G1]);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->u_regs[UREG_G1]);
@@ -1099,7 +1100,7 @@ asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 		trace_sys_exit(regs, regs->u_regs[UREG_I0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, 0);
+		tracehook_report_syscall_exit(regs, 0, regs->u_regs[UREG_G1]);
 
 	if (test_thread_flag(TIF_NOHZ))
 		user_enter();
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index de98c6d..5a22bfd 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -253,7 +253,8 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 int do_syscall_trace_enter(struct pt_regs *regs)
 {
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
-		if (tracehook_report_syscall_entry(regs))
+		if (tracehook_report_syscall_entry(regs,
+						regs->regs[TREG_SYSCALL_NR]))
 			regs->regs[TREG_SYSCALL_NR] = -1;
 	}
 
@@ -281,7 +282,8 @@ void do_syscall_trace_exit(struct pt_regs *regs)
 		regs->regs[1] = 0;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, 0);
+		tracehook_report_syscall_exit(regs, 0,
+					regs->regs[TREG_SYSCALL_NR]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_exit(regs, regs->regs[0]);
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 694d551..addb5b6 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -175,7 +175,7 @@ void syscall_trace_enter(struct pt_regs *regs)
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
 
-	tracehook_report_syscall_entry(regs);
+	tracehook_report_syscall_entry(regs, UPT_SYSCALL_NR(&regs->regs));
 }
 
 void syscall_trace_leave(struct pt_regs *regs)
@@ -191,7 +191,7 @@ void syscall_trace_leave(struct pt_regs *regs)
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
 
-	tracehook_report_syscall_exit(regs, 0);
+	tracehook_report_syscall_exit(regs, 0, UPT_SYSCALL_NR(&regs->regs));
 	/* force do_signal() --> is_syscall() */
 	if (ptraced & PT_PTRACED)
 		set_thread_flag(TIF_SIGPENDING);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7461f50..f487e55 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1481,7 +1481,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 		ret = -1L;
 
 	if ((ret || test_thread_flag(TIF_SYSCALL_TRACE)) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs, regs->orig_ax))
 		ret = -1L;
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
@@ -1529,7 +1529,7 @@ void syscall_trace_leave(struct pt_regs *regs)
 	step = unlikely(test_thread_flag(TIF_SINGLESTEP)) &&
 			!test_thread_flag(TIF_SYSCALL_EMU);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, step);
+		tracehook_report_syscall_exit(regs, step, regs->orig_ax);
 
 	user_enter();
 }
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 07d0df6..15c06e8 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -31,6 +31,8 @@
 #define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 #define PT_TRACE_SECCOMP	PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
+#define PT_TRACE_SYSCALL_ENTER	PT_EVENT_FLAG(PTRACE_EVENT_SYSCALL_ENTER)
+#define PT_TRACE_SYSCALL_EXIT	PT_EVENT_FLAG(PTRACE_EVENT_SYSCALL_EXIT)
 
 #define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
 
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 1e98b55..e977a71 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -53,16 +53,28 @@
 struct linux_binprm;
 
 /*
- * ptrace report for syscall entry and exit looks identical.
+ * ptrace report for syscall entry and exit.
  */
-static inline int ptrace_report_syscall(struct pt_regs *regs)
+static inline int ptrace_report_syscall(struct pt_regs *regs, int entry,
+	unsigned int sysno)
 {
 	int ptrace = current->ptrace;
+	int is_sysenter = ptrace & PT_TRACE_SYSCALL_ENTER;
+	int is_sysexit = ptrace & PT_TRACE_SYSCALL_EXIT;
+	int is_ptsysgood = ptrace & PT_TRACESYSGOOD;
 
 	if (!(ptrace & PT_PTRACED))
 		return 0;
 
-	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+	if (is_sysenter || is_sysexit) {
+		if (entry && is_sysenter)
+			ptrace_event(PTRACE_EVENT_SYSCALL_ENTER, sysno);
+		else if (!entry && is_sysexit)
+			ptrace_event(PTRACE_EVENT_SYSCALL_EXIT, sysno);
+		else
+			return 0;
+	} else
+		ptrace_notify(SIGTRAP | (is_ptsysgood ? 0x80 : 0));
 
 	/*
 	 * this isn't the same as continuing with a signal, but it will do
@@ -80,6 +92,7 @@ static inline int ptrace_report_syscall(struct pt_regs *regs)
 /**
  * tracehook_report_syscall_entry - task is about to attempt a system call
  * @regs:		user register state of current task
+ * @sysno:		system call number to be reported
  *
  * This will be called if %TIF_SYSCALL_TRACE has been set, when the
  * current task has just entered the kernel for a system call.
@@ -97,15 +110,16 @@ static inline int ptrace_report_syscall(struct pt_regs *regs)
  * Called without locks, just after entering kernel mode.
  */
 static inline __must_check int tracehook_report_syscall_entry(
-	struct pt_regs *regs)
+	struct pt_regs *regs, unsigned int sysno)
 {
-	return ptrace_report_syscall(regs);
+	return ptrace_report_syscall(regs, 1, sysno);
 }
 
 /**
  * tracehook_report_syscall_exit - task has just finished a system call
  * @regs:		user register state of current task
  * @step:		nonzero if simulating single-step or block-step
+ * @sysno:		system call number to be reported
  *
  * This will be called if %TIF_SYSCALL_TRACE has been set, when the
  * current task has just finished an attempted system call.  Full
@@ -119,7 +133,8 @@ static inline __must_check int tracehook_report_syscall_entry(
  *
  * Called without locks, just before checking for pending signals.
  */
-static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
+static inline void tracehook_report_syscall_exit(struct pt_regs *regs,
+	int step, unsigned int sysno)
 {
 	if (step) {
 		siginfo_t info;
@@ -128,7 +143,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 		return;
 	}
 
-	ptrace_report_syscall(regs);
+	ptrace_report_syscall(regs, 0, sysno);
 }
 
 /**
diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index cf1019e..012ecc9 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -68,13 +68,16 @@ struct ptrace_peeksiginfo_args {
 #define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
 
 /* Wait extended result codes for the above trace options.  */
-#define PTRACE_EVENT_FORK	1
-#define PTRACE_EVENT_VFORK	2
-#define PTRACE_EVENT_CLONE	3
-#define PTRACE_EVENT_EXEC	4
-#define PTRACE_EVENT_VFORK_DONE	5
-#define PTRACE_EVENT_EXIT	6
-#define PTRACE_EVENT_SECCOMP	7
+#define PTRACE_EVENT_FORK		1
+#define PTRACE_EVENT_VFORK		2
+#define PTRACE_EVENT_CLONE		3
+#define PTRACE_EVENT_EXEC		4
+#define PTRACE_EVENT_VFORK_DONE		5
+#define PTRACE_EVENT_EXIT		6
+#define PTRACE_EVENT_SECCOMP		7
+#define PTRACE_EVENT_SYSCALL_ENTER	8
+#define PTRACE_EVENT_SYSCALL_EXIT	9
+
 /* Extended result codes which enabled by means other than options.  */
 #define PTRACE_EVENT_STOP	128
 
@@ -87,11 +90,13 @@ struct ptrace_peeksiginfo_args {
 #define PTRACE_O_TRACEVFORKDONE	(1 << PTRACE_EVENT_VFORK_DONE)
 #define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
 #define PTRACE_O_TRACESECCOMP	(1 << PTRACE_EVENT_SECCOMP)
+#define PTRACE_O_SYSCALL_ENTER	(1 << PTRACE_EVENT_SYSCALL_ENTER)
+#define PTRACE_O_SYSCALL_EXIT	(1 << PTRACE_EVENT_SYSCALL_EXIT)
 
 /* eventless options */
 #define PTRACE_O_EXITKILL	(1 << 20)
 
-#define PTRACE_O_MASK		(0x000000ff | PTRACE_O_EXITKILL)
+#define PTRACE_O_MASK		(0x00000fff | PTRACE_O_EXITKILL)
 
 #include <asm/ptrace.h>
 
