Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaJMH5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:57:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65362 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaJMH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:57:08 -0400
Date: Mon, 13 Oct 2014 09:57:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] seccomp changes for v3.18
Message-ID: <20141013075702.GA15968@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-seccomp-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-seccomp-for-linus

   # HEAD: 1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e x86_64, entry: Use split-phase syscall_trace_enter for 64-bit syscalls

This tree includes x86 seccomp filter speedups and related 
preparatory work, which touches core seccomp facilities as well.

The main idea is to split seccomp into two phases, to be able to 
enter a simple fast path for syscalls with ptrace side effects.

There's no substantial user-visible (and ABI) effects expected 
from this, except a change in how we emit a better audit record 
for SECCOMP_RET_TRACE events.


  out-of-topic modifications in x86-seccomp-for-linus:
  ------------------------------------------------------
  arch/Kconfig                       # ff27f38e0ef9: seccomp: Document two-phase 
  arch/arm/kernel/ptrace.c           # a4412fc9486e: seccomp,x86,arm,mips,s390: R
  arch/mips/kernel/ptrace.c          # a4412fc9486e: seccomp,x86,arm,mips,s390: R
  arch/s390/kernel/ptrace.c          # a4412fc9486e: seccomp,x86,arm,mips,s390: R
  include/linux/seccomp.h            # d39bd00deabe: seccomp: Allow arch code to 
                                   # 13aa72f0fd0a: seccomp: Refactor the filter
                                   # a4412fc9486e: seccomp,x86,arm,mips,s390: R
  kernel/seccomp.c                   # d39bd00deabe: seccomp: Allow arch code to 
                                   # 13aa72f0fd0a: seccomp: Refactor the filter
                                   # a4412fc9486e: seccomp,x86,arm,mips,s390: R

 Thanks,

	Ingo

------------------>
Andy Lutomirski (9):
      seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing
      seccomp: Refactor the filter callback and the API
      seccomp: Allow arch code to provide seccomp_data
      seccomp: Document two-phase seccomp and arch-provided seccomp_data
      x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit
      x86, entry: Only call user_exit if TIF_NOHZ
      x86: Split syscall_trace_enter into two phases
      x86_64, entry: Treat regs->ax the same in fastpath and slowpath syscalls
      x86_64, entry: Use split-phase syscall_trace_enter for 64-bit syscalls


 arch/Kconfig                   |  11 ++
 arch/arm/kernel/ptrace.c       |   7 +-
 arch/mips/kernel/ptrace.c      |   2 +-
 arch/s390/kernel/ptrace.c      |   2 +-
 arch/x86/include/asm/calling.h |   6 +-
 arch/x86/include/asm/ptrace.h  |   5 +
 arch/x86/kernel/entry_64.S     |  51 ++++-----
 arch/x86/kernel/ptrace.c       | 165 ++++++++++++++++++++++-----
 arch/x86/kernel/vsyscall_64.c  |   2 +-
 include/linux/seccomp.h        |  25 ++--
 kernel/seccomp.c               | 252 ++++++++++++++++++++++++++++-------------
 11 files changed, 371 insertions(+), 157 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 0eae9df35b88..05d7a8a458d5 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -323,6 +323,17 @@ config HAVE_ARCH_SECCOMP_FILTER
 	    results in the system call being skipped immediately.
 	  - seccomp syscall wired up
 
+	  For best performance, an arch should use seccomp_phase1 and
+	  seccomp_phase2 directly.  It should call seccomp_phase1 for all
+	  syscalls if TIF_SECCOMP is set, but seccomp_phase1 does not
+	  need to be called from a ptrace-safe context.  It must then
+	  call seccomp_phase2 if seccomp_phase1 returns anything other
+	  than SECCOMP_PHASE1_OK or SECCOMP_PHASE1_SKIP.
+
+	  As an additional optimization, an arch may provide seccomp_data
+	  directly to seccomp_phase1; this avoids multiple calls
+	  to the syscall_xyz helpers for every syscall.
+
 config SECCOMP_FILTER
 	def_bool y
 	depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 0c27ed6f3f23..5e772a21ab97 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -933,8 +933,13 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 	current_thread_info()->syscall = scno;
 
 	/* Do the secure computing check first; failures should be fast. */
-	if (secure_computing(scno) == -1)
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+	if (secure_computing() == -1)
 		return -1;
+#else
+	/* XXX: remove this once OABI gets fixed */
+	secure_computing_strict(scno);
+#endif
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 645b3c4fcfba..f7aac5b57b4b 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -770,7 +770,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
 	long ret = 0;
 	user_exit();
 
-	if (secure_computing(syscall) == -1)
+	if (secure_computing() == -1)
 		return -1;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 5dc7ad9e2fbf..bebacad48305 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -803,7 +803,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	long ret = 0;
 
 	/* Do the secure computing check first. */
-	if (secure_computing(regs->gprs[2])) {
+	if (secure_computing()) {
 		/* seccomp failures shouldn't expose any additional code. */
 		ret = -1;
 		goto out;
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index cb4c73bfeb48..76659b67fd11 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -85,7 +85,7 @@ For 32-bit we have the following conventions - kernel is built with
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
 
-	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
+	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1, rax_enosys=0
 	subq  $9*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
 	movq_cfi rdi, 8*8
@@ -96,7 +96,11 @@ For 32-bit we have the following conventions - kernel is built with
 	movq_cfi rcx, 5*8
 	.endif
 
+	.if \rax_enosys
+	movq $-ENOSYS, 4*8(%rsp)
+	.else
 	movq_cfi rax, 4*8
+	.endif
 
 	.if \save_r891011
 	movq_cfi r8,  3*8
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 6205f0c434db..86fc2bb82287 100644
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
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 2fac1343a90b..df088bb03fb3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -404,8 +404,8 @@ GLOBAL(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,0
-	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
+	SAVE_ARGS 8, 0, rax_enosys=1
+	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
@@ -417,7 +417,7 @@ GLOBAL(system_call_after_swapgs)
 	andl $__SYSCALL_MASK,%eax
 	cmpl $__NR_syscall_max,%eax
 #endif
-	ja badsys
+	ja ret_from_sys_call  /* and return regs->ax */
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
 	movq %rax,RAX-ARGOFFSET(%rsp)
@@ -476,28 +476,8 @@ GLOBAL(system_call_after_swapgs)
 	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
 	jmp int_check_syscall_exit_work
 
-badsys:
-	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
-	jmp ret_from_sys_call
-
 #ifdef CONFIG_AUDITSYSCALL
 	/*
-	 * Fast path for syscall audit without full syscall trace.
-	 * We just call __audit_syscall_entry() directly, and then
-	 * jump back to the normal fast path.
-	 */
-auditsys:
-	movq %r10,%r9			/* 6th arg: 4th syscall arg */
-	movq %rdx,%r8			/* 5th arg: 3rd syscall arg */
-	movq %rsi,%rcx			/* 4th arg: 2nd syscall arg */
-	movq %rdi,%rdx			/* 3rd arg: 1st syscall arg */
-	movq %rax,%rsi			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
-	call __audit_syscall_entry
-	LOAD_ARGS 0		/* reload call-clobbered registers */
-	jmp system_call_fastpath
-
-	/*
 	 * Return fast path for syscall audit.  Call __audit_syscall_exit()
 	 * directly and then jump back to the fast path with TIF_SYSCALL_AUDIT
 	 * masked off.
@@ -514,18 +494,25 @@ GLOBAL(system_call_after_swapgs)
 
 	/* Do syscall tracing */
 tracesys:
-#ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	jz auditsys
-#endif
+	leaq -REST_SKIP(%rsp), %rdi
+	movq $AUDIT_ARCH_X86_64, %rsi
+	call syscall_trace_enter_phase1
+	test %rax, %rax
+	jnz tracesys_phase2		/* if needed, run the slow path */
+	LOAD_ARGS 0			/* else restore clobbered regs */
+	jmp system_call_fastpath	/*      and return to the fast path */
+
+tracesys_phase2:
 	SAVE_REST
-	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
 	FIXUP_TOP_OF_STACK %rdi
-	movq %rsp,%rdi
-	call syscall_trace_enter
+	movq %rsp, %rdi
+	movq $AUDIT_ARCH_X86_64, %rsi
+	movq %rax,%rdx
+	call syscall_trace_enter_phase2
+
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
-	 * We don't reload %rax because syscall_trace_enter() returned
+	 * We don't reload %rax because syscall_trace_entry_phase2() returned
 	 * the value it wants us to use in the table lookup.
 	 */
 	LOAD_ARGS ARGOFFSET, 1
@@ -536,7 +523,7 @@ GLOBAL(system_call_after_swapgs)
 	andl $__SYSCALL_MASK,%eax
 	cmpl $__NR_syscall_max,%eax
 #endif
-	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
+	ja   int_ret_from_sys_call	/* RAX(%rsp) is already set */
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 678c0ada3b3c..29576c244699 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1441,24 +1441,126 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-
-#ifdef CONFIG_X86_32
-# define IS_IA32	1
-#elif defined CONFIG_IA32_EMULATION
-# define IS_IA32	is_compat_task()
-#else
-# define IS_IA32	0
+static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
+{
+#ifdef CONFIG_X86_64
+	if (arch == AUDIT_ARCH_X86_64) {
+		audit_syscall_entry(arch, regs->orig_ax, regs->di,
+				    regs->si, regs->dx, regs->r10);
+	} else
 #endif
+	{
+		audit_syscall_entry(arch, regs->orig_ax, regs->bx,
+				    regs->cx, regs->dx, regs->si);
+	}
+}
 
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
+{
+	unsigned long ret = 0;
+	u32 work;
+
+	BUG_ON(regs != task_pt_regs(current));
+
+	work = ACCESS_ONCE(current_thread_info()->flags) &
+		_TIF_WORK_SYSCALL_ENTRY;
+
+	/*
+	 * If TIF_NOHZ is set, we are required to call user_exit() before
+	 * doing anything that could touch RCU.
+	 */
+	if (work & _TIF_NOHZ) {
+		user_exit();
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
 {
 	long ret = 0;
+	u32 work = ACCESS_ONCE(current_thread_info()->flags) &
+		_TIF_WORK_SYSCALL_ENTRY;
 
-	user_exit();
+	BUG_ON(regs != task_pt_regs(current));
 
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
@@ -1467,17 +1569,21 @@ long syscall_trace_enter(struct pt_regs *regs)
 	 * do_debug() and we need to set it again to restore the user
 	 * state.  If we entered on the slow path, TF was already set.
 	 */
-	if (test_thread_flag(TIF_SINGLESTEP))
+	if (work & _TIF_SINGLESTEP)
 		regs->flags |= X86_EFLAGS_TF;
 
-	/* do the secure computing check first */
-	if (secure_computing(regs->orig_ax)) {
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Call seccomp_phase2 before running the other hooks so that
+	 * they can see any changes made by a seccomp tracer.
+	 */
+	if (phase1_result > 1 && seccomp_phase2(phase1_result)) {
 		/* seccomp failures shouldn't expose any additional code. */
-		ret = -1L;
-		goto out;
+		return -1;
 	}
+#endif
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
+	if (unlikely(work & _TIF_SYSCALL_EMU))
 		ret = -1L;
 
 	if ((ret || test_thread_flag(TIF_SYSCALL_TRACE)) &&
@@ -1487,23 +1593,22 @@ long syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->orig_ax);
 
-	if (IS_IA32)
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
 
-out:
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
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e1e1e80fc6a6..957779f4eb40 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -216,7 +216,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	 */
 	regs->orig_ax = syscall_nr;
 	regs->ax = -ENOSYS;
-	tmp = secure_computing(syscall_nr);
+	tmp = secure_computing();
 	if ((!tmp && regs->orig_ax != syscall_nr) || regs->ip != address) {
 		warn_bad_vsyscall(KERN_DEBUG, regs,
 				  "seccomp tried to change syscall nr or ip");
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 5d586a45a319..a19ddacdac30 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -27,19 +27,23 @@ struct seccomp {
 	struct seccomp_filter *filter;
 };
 
-extern int __secure_computing(int);
-static inline int secure_computing(int this_syscall)
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+extern int __secure_computing(void);
+static inline int secure_computing(void)
 {
 	if (unlikely(test_thread_flag(TIF_SECCOMP)))
-		return  __secure_computing(this_syscall);
+		return  __secure_computing();
 	return 0;
 }
 
-/* A wrapper for architectures supporting only SECCOMP_MODE_STRICT. */
-static inline void secure_computing_strict(int this_syscall)
-{
-	BUG_ON(secure_computing(this_syscall) != 0);
-}
+#define SECCOMP_PHASE1_OK	0
+#define SECCOMP_PHASE1_SKIP	1
+
+extern u32 seccomp_phase1(struct seccomp_data *sd);
+int seccomp_phase2(u32 phase1_result);
+#else
+extern void secure_computing_strict(int this_syscall);
+#endif
 
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long, char __user *);
@@ -56,8 +60,11 @@ static inline int seccomp_mode(struct seccomp *s)
 struct seccomp { };
 struct seccomp_filter { };
 
-static inline int secure_computing(int this_syscall) { return 0; }
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+static inline int secure_computing(void) { return 0; }
+#else
 static inline void secure_computing_strict(int this_syscall) { return; }
+#endif
 
 static inline long prctl_get_seccomp(void)
 {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 44eb005c6695..1285cb205d49 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -21,10 +21,11 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
-/* #define SECCOMP_DEBUG 1 */
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+#include <asm/syscall.h>
+#endif
 
 #ifdef CONFIG_SECCOMP_FILTER
-#include <asm/syscall.h>
 #include <linux/filter.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
@@ -172,10 +173,10 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  *
  * Returns valid seccomp BPF response codes.
  */
-static u32 seccomp_run_filters(int syscall)
+static u32 seccomp_run_filters(struct seccomp_data *sd)
 {
 	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
-	struct seccomp_data sd;
+	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
@@ -185,14 +186,17 @@ static u32 seccomp_run_filters(int syscall)
 	/* Make sure cross-thread synced filter points somewhere sane. */
 	smp_read_barrier_depends();
 
-	populate_seccomp_data(&sd);
+	if (!sd) {
+		populate_seccomp_data(&sd_local);
+		sd = &sd_local;
+	}
 
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (; f; f = f->prev) {
-		u32 cur_ret = BPF_PROG_RUN(f->prog, (void *)&sd);
+		u32 cur_ret = BPF_PROG_RUN(f->prog, (void *)sd);
 
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
@@ -564,11 +568,55 @@ static int mode1_syscalls_32[] = {
 };
 #endif
 
-int __secure_computing(int this_syscall)
+static void __secure_computing_strict(int this_syscall)
+{
+	int *syscall_whitelist = mode1_syscalls;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		syscall_whitelist = mode1_syscalls_32;
+#endif
+	do {
+		if (*syscall_whitelist == this_syscall)
+			return;
+	} while (*++syscall_whitelist);
+
+#ifdef SECCOMP_DEBUG
+	dump_stack();
+#endif
+	audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
+	do_exit(SIGKILL);
+}
+
+#ifndef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+void secure_computing_strict(int this_syscall)
+{
+	int mode = current->seccomp.mode;
+
+	if (mode == 0)
+		return;
+	else if (mode == SECCOMP_MODE_STRICT)
+		__secure_computing_strict(this_syscall);
+	else
+		BUG();
+}
+#else
+int __secure_computing(void)
 {
-	int exit_sig = 0;
-	int *syscall;
-	u32 ret;
+	u32 phase1_result = seccomp_phase1(NULL);
+
+	if (likely(phase1_result == SECCOMP_PHASE1_OK))
+		return 0;
+	else if (likely(phase1_result == SECCOMP_PHASE1_SKIP))
+		return -1;
+	else
+		return seccomp_phase2(phase1_result);
+}
+
+#ifdef CONFIG_SECCOMP_FILTER
+static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
+{
+	u32 filter_ret, action;
+	int data;
 
 	/*
 	 * Make sure that any changes to mode from another thread have
@@ -576,85 +624,127 @@ int __secure_computing(int this_syscall)
 	 */
 	rmb();
 
-	switch (current->seccomp.mode) {
-	case SECCOMP_MODE_STRICT:
-		syscall = mode1_syscalls;
-#ifdef CONFIG_COMPAT
-		if (is_compat_task())
-			syscall = mode1_syscalls_32;
+	filter_ret = seccomp_run_filters(sd);
+	data = filter_ret & SECCOMP_RET_DATA;
+	action = filter_ret & SECCOMP_RET_ACTION;
+
+	switch (action) {
+	case SECCOMP_RET_ERRNO:
+		/* Set the low-order 16-bits as a errno. */
+		syscall_set_return_value(current, task_pt_regs(current),
+					 -data, 0);
+		goto skip;
+
+	case SECCOMP_RET_TRAP:
+		/* Show the handler the original registers. */
+		syscall_rollback(current, task_pt_regs(current));
+		/* Let the filter pass back 16 bits of data. */
+		seccomp_send_sigsys(this_syscall, data);
+		goto skip;
+
+	case SECCOMP_RET_TRACE:
+		return filter_ret;  /* Save the rest for phase 2. */
+
+	case SECCOMP_RET_ALLOW:
+		return SECCOMP_PHASE1_OK;
+
+	case SECCOMP_RET_KILL:
+	default:
+		audit_seccomp(this_syscall, SIGSYS, action);
+		do_exit(SIGSYS);
+	}
+
+	unreachable();
+
+skip:
+	audit_seccomp(this_syscall, 0, action);
+	return SECCOMP_PHASE1_SKIP;
+}
 #endif
-		do {
-			if (*syscall == this_syscall)
-				return 0;
-		} while (*++syscall);
-		exit_sig = SIGKILL;
-		ret = SECCOMP_RET_KILL;
-		break;
+
+/**
+ * seccomp_phase1() - run fast path seccomp checks on the current syscall
+ * @arg sd: The seccomp_data or NULL
+ *
+ * This only reads pt_regs via the syscall_xyz helpers.  The only change
+ * it will make to pt_regs is via syscall_set_return_value, and it will
+ * only do that if it returns SECCOMP_PHASE1_SKIP.
+ *
+ * If sd is provided, it will not read pt_regs at all.
+ *
+ * It may also call do_exit or force a signal; these actions must be
+ * safe.
+ *
+ * If it returns SECCOMP_PHASE1_OK, the syscall passes checks and should
+ * be processed normally.
+ *
+ * If it returns SECCOMP_PHASE1_SKIP, then the syscall should not be
+ * invoked.  In this case, seccomp_phase1 will have set the return value
+ * using syscall_set_return_value.
+ *
+ * If it returns anything else, then the return value should be passed
+ * to seccomp_phase2 from a context in which ptrace hooks are safe.
+ */
+u32 seccomp_phase1(struct seccomp_data *sd)
+{
+	int mode = current->seccomp.mode;
+	int this_syscall = sd ? sd->nr :
+		syscall_get_nr(current, task_pt_regs(current));
+
+	switch (mode) {
+	case SECCOMP_MODE_STRICT:
+		__secure_computing_strict(this_syscall);  /* may call do_exit */
+		return SECCOMP_PHASE1_OK;
 #ifdef CONFIG_SECCOMP_FILTER
-	case SECCOMP_MODE_FILTER: {
-		int data;
-		struct pt_regs *regs = task_pt_regs(current);
-		ret = seccomp_run_filters(this_syscall);
-		data = ret & SECCOMP_RET_DATA;
-		ret &= SECCOMP_RET_ACTION;
-		switch (ret) {
-		case SECCOMP_RET_ERRNO:
-			/* Set the low-order 16-bits as a errno. */
-			syscall_set_return_value(current, regs,
-						 -data, 0);
-			goto skip;
-		case SECCOMP_RET_TRAP:
-			/* Show the handler the original registers. */
-			syscall_rollback(current, regs);
-			/* Let the filter pass back 16 bits of data. */
-			seccomp_send_sigsys(this_syscall, data);
-			goto skip;
-		case SECCOMP_RET_TRACE:
-			/* Skip these calls if there is no tracer. */
-			if (!ptrace_event_enabled(current, PTRACE_EVENT_SECCOMP)) {
-				syscall_set_return_value(current, regs,
-							 -ENOSYS, 0);
-				goto skip;
-			}
-			/* Allow the BPF to provide the event message */
-			ptrace_event(PTRACE_EVENT_SECCOMP, data);
-			/*
-			 * The delivery of a fatal signal during event
-			 * notification may silently skip tracer notification.
-			 * Terminating the task now avoids executing a system
-			 * call that may not be intended.
-			 */
-			if (fatal_signal_pending(current))
-				break;
-			if (syscall_get_nr(current, regs) < 0)
-				goto skip;  /* Explicit request to skip. */
-
-			return 0;
-		case SECCOMP_RET_ALLOW:
-			return 0;
-		case SECCOMP_RET_KILL:
-		default:
-			break;
-		}
-		exit_sig = SIGSYS;
-		break;
-	}
+	case SECCOMP_MODE_FILTER:
+		return __seccomp_phase1_filter(this_syscall, sd);
 #endif
 	default:
 		BUG();
 	}
+}
 
-#ifdef SECCOMP_DEBUG
-	dump_stack();
-#endif
-	audit_seccomp(this_syscall, exit_sig, ret);
-	do_exit(exit_sig);
-#ifdef CONFIG_SECCOMP_FILTER
-skip:
-	audit_seccomp(this_syscall, exit_sig, ret);
-#endif
-	return -1;
+/**
+ * seccomp_phase2() - finish slow path seccomp work for the current syscall
+ * @phase1_result: The return value from seccomp_phase1()
+ *
+ * This must be called from a context in which ptrace hooks can be used.
+ *
+ * Returns 0 if the syscall should be processed or -1 to skip the syscall.
+ */
+int seccomp_phase2(u32 phase1_result)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+	u32 action = phase1_result & SECCOMP_RET_ACTION;
+	int data = phase1_result & SECCOMP_RET_DATA;
+
+	BUG_ON(action != SECCOMP_RET_TRACE);
+
+	audit_seccomp(syscall_get_nr(current, regs), 0, action);
+
+	/* Skip these calls if there is no tracer. */
+	if (!ptrace_event_enabled(current, PTRACE_EVENT_SECCOMP)) {
+		syscall_set_return_value(current, regs,
+					 -ENOSYS, 0);
+		return -1;
+	}
+
+	/* Allow the BPF to provide the event message */
+	ptrace_event(PTRACE_EVENT_SECCOMP, data);
+	/*
+	 * The delivery of a fatal signal during event
+	 * notification may silently skip tracer notification.
+	 * Terminating the task now avoids executing a system
+	 * call that may not be intended.
+	 */
+	if (fatal_signal_pending(current))
+		do_exit(SIGSYS);
+	if (syscall_get_nr(current, regs) < 0)
+		return -1;  /* Explicit request to skip. */
+
+	return 0;
 }
+#endif /* CONFIG_HAVE_ARCH_SECCOMP_FILTER */
 
 long prctl_get_seccomp(void)
 {
