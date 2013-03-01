Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3CAQJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:09:34 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:41830 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3CAQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:09:29 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/5] context_tracking: Restore correct previous context state on exception exit
Date: Fri,  1 Mar 2013 17:08:56 +0100
Message-Id: <1362154139-1139-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
References: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On exception exit, we restore the previous context tracking state based on
the regs of the interrupted frame. Iff that frame is in user mode as
stated by user_mode() helper, we restore the context tracking user mode.

However there is a tiny chunck of low level arch code after we pass through
user_enter() and until the CPU eventually resumes userspace.
If an exception happens in this tiny area, exception_enter() correctly
exits the context tracking user mode but exception_exit() won't restore
it because of the value returned by user_mode(regs).

As a result we may return to userspace with the wrong context tracking
state.

To fix this, change exception_enter() to return the context tracking state
prior to its call and pass this saved state to exception_exit(). This restores
the real context tracking state of the interrupted frame.

(May be this patch was suggested to me, I don't recall exactly. If so,
sorry for the missing credit).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/kvm.c            |    6 ++-
 arch/x86/kernel/traps.c          |   65 ++++++++++++++++++++++++--------------
 arch/x86/mm/fault.c              |    6 ++-
 include/linux/context_tracking.h |   19 +++++++----
 4 files changed, 61 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1effefa..7ae5e47 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -254,16 +254,18 @@ EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 dotraplinkage void __kprobes
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
+	enum ctx_state prev_state;
+
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
 		do_page_fault(regs, error_code);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		exception_enter(regs);
+		prev_state = exception_enter();
 		exit_idle();
 		kvm_async_pf_task_wait((u32)read_cr2());
-		exception_exit(regs);
+		exception_exit(prev_state);
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index be079a6..324dff4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -175,34 +175,38 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	exception_enter(regs);						\
+	enum ctx_state prev_state;					\
+									\
+	prev_state = exception_enter();					\
 	if (notify_die(DIE_TRAP, str, regs, error_code,			\
 			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(regs);					\
+		exception_exit(prev_state);				\
 		return;							\
 	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
-	exception_exit(regs);						\
+	exception_exit(prev_state);					\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
+	enum ctx_state prev_state;					\
+									\
 	info.si_signo = signr;						\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	exception_enter(regs);						\
+	prev_state = exception_enter();					\
 	if (notify_die(DIE_TRAP, str, regs, error_code,			\
 			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(regs);					\
+		exception_exit(prev_state);				\
 		return;							\
 	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
-	exception_exit(regs);						\
+	exception_exit(prev_state);					\
 }
 
 DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
@@ -225,14 +229,16 @@ DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
 		preempt_conditional_sti(regs);
 		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
 		preempt_conditional_cli(regs);
 	}
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -240,7 +246,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
 
-	exception_enter(regs);
+	exception_enter();
 	/* Return not checked because double check cannot be ignored */
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
@@ -260,8 +266,9 @@ dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
+	enum ctx_state prev_state;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 	conditional_sti(regs);
 
 #ifdef CONFIG_X86_32
@@ -299,12 +306,14 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 	force_sig(SIGSEGV, tsk);
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 /* May run on IST stack. */
 dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
 {
+	enum ctx_state prev_state;
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/*
 	 * ftrace must be first, everything else may cause a recursive crash.
@@ -314,7 +323,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
-	exception_enter(regs);
+	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -335,7 +344,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 #ifdef CONFIG_X86_64
@@ -392,11 +401,12 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
+	enum ctx_state prev_state;
 	int user_icebp = 0;
 	unsigned long dr6;
 	int si_code;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 
 	get_debugreg(dr6, 6);
 
@@ -466,7 +476,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	debug_stack_usage_dec();
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 /*
@@ -560,17 +570,21 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	math_error(regs, error_code, X86_TRAP_MF);
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	math_error(regs, error_code, X86_TRAP_XF);
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 dotraplinkage void
@@ -638,7 +652,9 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	BUG_ON(use_eager_fpu());
 
 #ifdef CONFIG_MATH_EMULATION
@@ -649,7 +665,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 
 		info.regs = regs;
 		math_emulate(&info);
-		exception_exit(regs);
+		exception_exit(prev_state);
 		return;
 	}
 #endif
@@ -657,15 +673,16 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #ifdef CONFIG_X86_32
 	conditional_sti(regs);
 #endif
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 {
 	siginfo_t info;
+	enum ctx_state prev_state;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 	local_irq_enable();
 
 	info.si_signo = SIGILL;
@@ -677,7 +694,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 		do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
 			&info);
 	}
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 #endif
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6d1e11f..d045a3b 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1228,7 +1228,9 @@ good_area:
 dotraplinkage void __kprobes
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	__do_page_fault(regs, error_code);
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 5a69273..365f4a6 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -5,7 +5,6 @@
 #include <linux/percpu.h>
 #include <asm/ptrace.h>
 
-#ifdef CONFIG_CONTEXT_TRACKING
 struct context_tracking {
 	/*
 	 * When active is false, probes are unset in order
@@ -14,12 +13,13 @@ struct context_tracking {
 	 * may be further optimized using static keys.
 	 */
 	bool active;
-	enum {
+	enum ctx_state {
 		IN_KERNEL = 0,
 		IN_USER,
 	} state;
 };
 
+#ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
 static inline bool context_tracking_in_user(void)
@@ -35,14 +35,19 @@ static inline bool context_tracking_active(void)
 extern void user_enter(void);
 extern void user_exit(void);
 
-static inline void exception_enter(struct pt_regs *regs)
+static inline enum ctx_state exception_enter(void)
 {
+	enum ctx_state prev_ctx;
+
+	prev_ctx = this_cpu_read(context_tracking.state);
 	user_exit();
+
+	return prev_ctx;
 }
 
-static inline void exception_exit(struct pt_regs *regs)
+static inline void exception_exit(enum ctx_state prev_ctx)
 {
-	if (user_mode(regs))
+	if (prev_ctx == IN_USER)
 		user_enter();
 }
 
@@ -52,8 +57,8 @@ extern void context_tracking_task_switch(struct task_struct *prev,
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
-static inline void exception_enter(struct pt_regs *regs) { }
-static inline void exception_exit(struct pt_regs *regs) { }
+static inline enum ctx_state exception_enter(void) { return 0; }
+static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
 						struct task_struct *next) { }
 #endif /* !CONFIG_CONTEXT_TRACKING */
-- 
1.7.5.4

