Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaG2DjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:39:02 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61189 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaG2Di4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:38:56 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 3/5] x86: Split syscall_trace_enter into two phases
Date: Mon, 28 Jul 2014 20:38:30 -0700
Message-Id: <714cf438762d342673b3b131d5c90bc69ca921a9.1406604806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406604806.git.luto@amacapital.net>
References: <cover.1406604806.git.luto@amacapital.net>
In-Reply-To: <cover.1406604806.git.luto@amacapital.net>
References: <cover.1406604806.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This splits syscall_trace_enter into syscall_trace_enter_phase1 and
syscall_trace_enter_phase2.  Only phase 2 has full pt_regs, and only
phase 2 is permitted to modify any of pt_regs except for orig_ax.

The intent is that phase 1 can be called from the syscall fast path.

In this implementation, phase1 can handle any combination of
TIF_NOHZ (RCU context tracking), TIF_SECCOMP, and TIF_SYSCALL_AUDIT,
unless seccomp requests a ptrace event, in which case phase2 is
forced.

In principle, this could yield a big speedup for TIF_NOHZ as well as
for TIF_SECCOMP if syscall exit work were similarly split up.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/ptrace.h |   5 ++
 arch/x86/kernel/ptrace.c      | 151 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 135 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 6205f0c..86fc2bb 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -75,6 +75,11 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
 
+
+extern unsigned long syscall_trace_enter_phase1(struct pt_regs *, u32 arch);
+extern long syscall_trace_enter_phase2(struct pt_regs *, u32 arch,
+				       unsigned long phase1_result);
+
 extern long syscall_trace_enter(struct pt_regs *);
 extern void syscall_trace_leave(struct pt_regs *);
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index bbf338a..5da2672 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1441,20 +1441,126 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
+static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
+{
+#ifdef CONFIG_X86_64
+	if (arch == AUDIT_ARCH_X86_64) {
+		audit_syscall_entry(arch, regs->orig_ax, regs->di,
+				    regs->si, regs->dx, regs->r10);
+	} else
+#endif
+	{
+		audit_syscall_entry(arch, regs->orig_ax, regs->bx,
+				    regs->cx, regs->dx, regs->si);
+	}
+}
+
 /*
- * We must return the syscall number to actually look up in the table.
- * This can be -1L to skip running any syscall at all.
+ * We can return 0 to resume the syscall or anything else to go to phase
+ * 2.  If we resume the syscall, we need to put something appropriate in
+ * regs->orig_ax.
+ *
+ * NB: We don't have full pt_regs here, but regs->orig_ax and regs->ax
+ * are fully functional.
+ *
+ * For phase 2's benefit, our return value is:
+ * 0:			resume the syscall
+ * 1:			go to phase 2; no seccomp phase 2 needed
+ * anything else:	go to phase 2; pass return value to seccomp
  */
-long syscall_trace_enter(struct pt_regs *regs)
+unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 {
-	long ret = 0;
+	unsigned long ret = 0;
+	u32 work;
+
+	BUG_ON(regs != task_pt_regs(current));
+
+	work = ACCESS_ONCE(current_thread_info()->flags) &
+		_TIF_WORK_SYSCALL_ENTRY;
 
 	/*
 	 * If TIF_NOHZ is set, we are required to call user_exit() before
 	 * doing anything that could touch RCU.
 	 */
-	if (test_thread_flag(TIF_NOHZ))
+	if (work & _TIF_NOHZ) {
 		user_exit();
+		work &= ~TIF_NOHZ;
+	}
+
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Do seccomp first -- it should minimize exposure of other
+	 * code, and keeping seccomp fast is probably more valuable
+	 * than the rest of this.
+	 */
+	if (work & _TIF_SECCOMP) {
+		struct seccomp_data sd;
+
+		sd.arch = arch;
+		sd.nr = regs->orig_ax;
+		sd.instruction_pointer = regs->ip;
+#ifdef CONFIG_X86_64
+		if (arch == AUDIT_ARCH_X86_64) {
+			sd.args[0] = regs->di;
+			sd.args[1] = regs->si;
+			sd.args[2] = regs->dx;
+			sd.args[3] = regs->r10;
+			sd.args[4] = regs->r8;
+			sd.args[5] = regs->r9;
+		} else
+#endif
+		{
+			sd.args[0] = regs->bx;
+			sd.args[1] = regs->cx;
+			sd.args[2] = regs->dx;
+			sd.args[3] = regs->si;
+			sd.args[4] = regs->di;
+			sd.args[5] = regs->bp;
+		}
+
+		BUILD_BUG_ON(SECCOMP_PHASE1_OK != 0);
+		BUILD_BUG_ON(SECCOMP_PHASE1_SKIP != 1);
+
+		ret = seccomp_phase1(&sd);
+		if (ret == SECCOMP_PHASE1_SKIP) {
+			regs->orig_ax = -1;
+			ret = 0;
+		} else if (ret != SECCOMP_PHASE1_OK) {
+			return ret;  /* Go directly to phase 2 */
+		}
+
+		work &= ~_TIF_SECCOMP;
+	}
+#endif
+
+	/* Do our best to finish without phase 2. */
+	if (work == 0)
+		return ret;  /* seccomp and/or nohz only (ret == 0 here) */
+
+#ifdef CONFIG_AUDITSYSCALL
+	if (work == _TIF_SYSCALL_AUDIT) {
+		/*
+		 * If there is no more work to be done except auditing,
+		 * then audit in phase 1.  Phase 2 always audits, so, if
+		 * we audit here, then we can't go on to phase 2.
+		 */
+		do_audit_syscall_entry(regs, arch);
+		return 0;
+	}
+#endif
+
+	return 1;  /* Something is enabled that we can't handle in phase 1 */
+}
+
+/* Returns the syscall nr to run (which should match regs->orig_ax). */
+long syscall_trace_enter_phase2(struct pt_regs *regs, u32 arch,
+				unsigned long phase1_result)
+{
+	long ret = 0;
+	u32 work = ACCESS_ONCE(current_thread_info()->flags) &
+		_TIF_WORK_SYSCALL_ENTRY;
+
+	BUG_ON(regs != task_pt_regs(current));
 
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
@@ -1463,17 +1569,20 @@ long syscall_trace_enter(struct pt_regs *regs)
 	 * do_debug() and we need to set it again to restore the user
 	 * state.  If we entered on the slow path, TF was already set.
 	 */
-	if (test_thread_flag(TIF_SINGLESTEP))
+	if (work & _TIF_SINGLESTEP)
 		regs->flags |= X86_EFLAGS_TF;
 
-	/* do the secure computing check first */
-	if (secure_computing()) {
+	/*
+	 * Call seccomp_phase2 before running the other hooks so that
+	 * they can see any changes made by a seccomp tracer.
+	 */
+	if (phase1_result > 1 && seccomp_phase2(phase1_result)) {
 		/* seccomp failures shouldn't expose any additional code. */
 		ret = -1L;
 		goto out;
 	}
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
+	if (unlikely(work & _TIF_SYSCALL_EMU))
 		ret = -1L;
 
 	if ((ret || test_thread_flag(TIF_SYSCALL_TRACE)) &&
@@ -1483,23 +1592,23 @@ long syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->orig_ax);
 
-	if (is_ia32_task())
-		audit_syscall_entry(AUDIT_ARCH_I386,
-				    regs->orig_ax,
-				    regs->bx, regs->cx,
-				    regs->dx, regs->si);
-#ifdef CONFIG_X86_64
-	else
-		audit_syscall_entry(AUDIT_ARCH_X86_64,
-				    regs->orig_ax,
-				    regs->di, regs->si,
-				    regs->dx, regs->r10);
-#endif
+	do_audit_syscall_entry(regs, arch);
 
 out:
 	return ret ?: regs->orig_ax;
 }
 
+long syscall_trace_enter(struct pt_regs *regs)
+{
+	u32 arch = is_ia32_task() ? AUDIT_ARCH_I386 : AUDIT_ARCH_X86_64;
+	unsigned long phase1_result = syscall_trace_enter_phase1(regs, arch);
+
+	if (phase1_result == 0)
+		return regs->orig_ax;
+	else
+		return syscall_trace_enter_phase2(regs, arch, phase1_result);
+}
+
 void syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
-- 
1.9.3

