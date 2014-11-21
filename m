Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaKUV00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:26:26 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62646 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaKUV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:26:24 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
Date: Fri, 21 Nov 2014 13:26:08 -0800
Message-Id: <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently pretend that IST context is like standard exception
context, but this is incorrect.  IST entries from userspace are like
standard exceptions except that they use per-cpu stacks, so they are
atomic.  IST entries from kernel space are like NMIs from RCU's
perspective -- they are not quiescent states even if they
interrupted the kernel during a quiescent state.

Add and use ist_enter and ist_exit to track IST context.  Even
though x86_32 has no IST stacks, we track these interrupts the same
way.

This fixes two issues:

 - Scheduling from an IST interrupt handler will now warn.  It would
   previously appear to work as long as we got lucky and nothing
   overwrote the stack frame.  (I don't know of any bugs in this
   that would trigger the warning, but it's good to be on the safe
   side.)

 - RCU handling in IST context was dangerous.  As far as I know,
   only machine checks were likely to trigger this, but it's good to
   be on the safe side.

Note that the machine check handlers appears to have been missing
any context tracking at all before this patch.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/traps.h         |  4 +++
 arch/x86/kernel/cpu/mcheck/mce.c     |  5 ++++
 arch/x86/kernel/cpu/mcheck/p5.c      |  6 +++++
 arch/x86/kernel/cpu/mcheck/winchip.c |  5 ++++
 arch/x86/kernel/traps.c              | 49 ++++++++++++++++++++++++++++++------
 5 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index bc8352e7010a..eb16a61bfd06 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_TRAPS_H
 #define _ASM_X86_TRAPS_H
 
+#include <linux/context_tracking_state.h>
 #include <linux/kprobes.h>
 
 #include <asm/debugreg.h>
@@ -109,6 +110,9 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+extern enum ctx_state ist_enter(struct pt_regs *regs);
+extern void ist_exit(struct pt_regs *regs, enum ctx_state prev_state);
+
 /* Interrupts/Exceptions */
 enum {
 	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668cebfd..b72509d77337 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -43,6 +43,7 @@
 #include <linux/export.h>
 
 #include <asm/processor.h>
+#include <asm/traps.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -1016,6 +1017,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 {
 	struct mca_config *cfg = &mca_cfg;
 	struct mce m, *final;
+	enum ctx_state prev_state;
 	int i;
 	int worst = 0;
 	int severity;
@@ -1038,6 +1040,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	char *msg = "Unknown";
 
+	prev_state = ist_enter(regs);
+
 	this_cpu_inc(mce_exception_count);
 
 	if (!cfg->banks)
@@ -1168,6 +1172,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	sync_core();
+	ist_exit(regs, prev_state);
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index a3042989398c..ec2663a708e4 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -8,6 +8,7 @@
 #include <linux/smp.h>
 
 #include <asm/processor.h>
+#include <asm/traps.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -17,8 +18,11 @@ int mce_p5_enabled __read_mostly;
 /* Machine check handler for Pentium class Intel CPUs: */
 static void pentium_machine_check(struct pt_regs *regs, long error_code)
 {
+	enum ctx_state prev_state;
 	u32 loaddr, hi, lotype;
 
+	prev_state = ist_enter(regs);
+
 	rdmsr(MSR_IA32_P5_MC_ADDR, loaddr, hi);
 	rdmsr(MSR_IA32_P5_MC_TYPE, lotype, hi);
 
@@ -33,6 +37,8 @@ static void pentium_machine_check(struct pt_regs *regs, long error_code)
 	}
 
 	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
+
+	ist_exit(regs, prev_state);
 }
 
 /* Set up machine check reporting for processors with Intel style MCE: */
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 7dc5564d0cdf..bd5d46a32210 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -7,14 +7,19 @@
 #include <linux/types.h>
 
 #include <asm/processor.h>
+#include <asm/traps.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
 /* Machine check handler for WinChip C6: */
 static void winchip_machine_check(struct pt_regs *regs, long error_code)
 {
+	enum ctx_state prev_state = ist_enter(regs);
+
 	printk(KERN_EMERG "CPU0: Machine Check Exception.\n");
 	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
+
+	ist_exit(regs, prev_state);
 }
 
 /* Set up machine check reporting on the Winchip C6 series */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0d0e922fafc1..f5c4b8813774 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -107,6 +107,39 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	preempt_count_dec();
 }
 
+enum ctx_state ist_enter(struct pt_regs *regs)
+{
+	/*
+	 * We are atomic because we're on the IST stack (or we're on x86_32,
+	 * in which case we still shouldn't schedule.
+	 */
+	preempt_count_add(HARDIRQ_OFFSET);
+
+	if (user_mode_vm(regs)) {
+		/* Other than that, we're just an exception. */
+		return exception_enter();
+	} else {
+		/*
+		 * We might have interrupted pretty much anything.  In
+		 * fact, if we're a machine check, we can even interrupt
+		 * NMI processing.  We don't want in_nmi() to return true,
+		 * but we need to notify RCU.
+		 */
+		rcu_nmi_enter();
+		return IN_KERNEL;  /* the value is irrelevant. */
+	}
+}
+
+void ist_exit(struct pt_regs *regs, enum ctx_state prev_state)
+{
+	preempt_count_sub(HARDIRQ_OFFSET);
+
+	if (user_mode_vm(regs))
+		return exception_exit(prev_state);
+	else
+		rcu_nmi_exit();
+}
+
 static nokprobe_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 		  struct pt_regs *regs,	long error_code)
@@ -244,14 +277,14 @@ dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
 
-	prev_state = exception_enter();
+	prev_state = ist_enter(regs);
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
 		preempt_conditional_sti(regs);
 		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
 		preempt_conditional_cli(regs);
 	}
-	exception_exit(prev_state);
+	ist_exit(regs, prev_state);
 }
 
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -259,8 +292,8 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
 
-	exception_enter();
-	/* Return not checked because double check cannot be ignored */
+	ist_enter(regs);
+	/* Return not checked because double fault cannot be ignored */
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
@@ -343,7 +376,7 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 	if (poke_int3_handler(regs))
 		return;
 
-	prev_state = exception_enter();
+	prev_state = ist_enter(regs);
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -369,7 +402,7 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 exit:
-	exception_exit(prev_state);
+	ist_exit(regs, prev_state);
 }
 NOKPROBE_SYMBOL(do_int3);
 
@@ -433,7 +466,7 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
-	prev_state = exception_enter();
+	prev_state = ist_enter(regs);
 
 	get_debugreg(dr6, 6);
 
@@ -508,7 +541,7 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 	debug_stack_usage_dec();
 
 exit:
-	exception_exit(prev_state);
+	ist_exit(regs, prev_state);
 }
 NOKPROBE_SYMBOL(do_debug);
 
-- 
1.9.3

