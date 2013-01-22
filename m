Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3AVRPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:15:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58084 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3AVRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:15:21 -0500
Date: Tue, 22 Jan 2013 18:15:10 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
To: linux-rt-users@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: [PATCH RT] Fix v3.2.37-rt55 build break
Message-ID: <alpine.LFD.2.03.1301221804320.14732@tycho>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806542-1746295343-1358874917=:14732"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806542-1746295343-1358874917=:14732
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

make O=/bld/v3.2.37-rt55/
make[2]: Nothing to be done for `relocs'.
  Using /home/jkacur/linux-rt as source for kernel
  GEN     /bld/v3.2.37-rt55/Makefile
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    /home/jkacur/linux-rt/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
  CC [M]  drivers/misc/sgi-xp/xpc_main.o
/home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c: In function 
¡xpc_system_die¢:
/home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1208: error: 
¡X86_TRAP_DF¢ undeclared (first use in this function)
/home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1208: error: (Each 
undeclared identifier is reported only once
/home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1208: error: for each 
function it appears in.)
/home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1211: error: 
¡X86_TRAP_MF¢ undeclared (first use in this function)
/home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1212: error: 
¡X86_TRAP_XF¢ undeclared (first use in this function)
make[4]: *** [drivers/misc/sgi-xp/xpc_main.o] Error 1
make[3]: *** [drivers/misc/sgi-xp] Error 2
make[2]: *** [drivers/misc] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

Clark Williams pointed out that this can be fixed by cherry-picking
c94082656dac74257f63e91f78d5d458ac781fa5
However, there are build conflicts with the rt-patch

The following is my fix applied to the rt-kernel, but it's fine with
me if you want to do the cherry-pick against the stable kernel,
and then respin fix-rt-int3-x86_32-3.2-rt.patch

Note, I believe this is correct but we're still doing our
internal testing.

commit 8c71778132f732bb45ec00c2bda1e39114098479
Author: Kees Cook <keescook@chromium.org>
Date:   Fri Mar 9 16:07:10 2012 -0800

    x86: Use enum instead of literals for trap values
    
    commit c94082656dac74257f63e91f78d5d458ac781fa5 upstream
    
    The traps are referred to by their numbers and it can be difficult to
    understand them while reading the code without context. This patch adds
    enumeration of the trap numbers and replaces the numbers with the correct
    enum for x86.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Link: http://lkml.kernel.org/r/20120310000710.GA32667@www.outflux.net
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Cherry-picked-for: v3.2-rt
    Conflicts:
    	arch/x86/kernel/traps.c
    Signed-off-by: John Kacur <jkacur@redhat.com>

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0012d09..88eae2a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -89,4 +89,29 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+/* Interrupts/Exceptions */
+enum {
+	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
+	X86_TRAP_DB,		/*  1, Debug */
+	X86_TRAP_NMI,		/*  2, Non-maskable Interrupt */
+	X86_TRAP_BP,		/*  3, Breakpoint */
+	X86_TRAP_OF,		/*  4, Overflow */
+	X86_TRAP_BR,		/*  5, Bound Range Exceeded */
+	X86_TRAP_UD,		/*  6, Invalid Opcode */
+	X86_TRAP_NM,		/*  7, Device Not Available */
+	X86_TRAP_DF,		/*  8, Double Fault */
+	X86_TRAP_OLD_MF,	/*  9, Coprocessor Segment Overrun */
+	X86_TRAP_TS,		/* 10, Invalid TSS */
+	X86_TRAP_NP,		/* 11, Segment Not Present */
+	X86_TRAP_SS,		/* 12, Stack Segment Fault */
+	X86_TRAP_GP,		/* 13, General Protection Fault */
+	X86_TRAP_PF,		/* 14, Page Fault */
+	X86_TRAP_SPURIOUS,	/* 15, Spurious Interrupt */
+	X86_TRAP_MF,		/* 16, x87 Floating-Point Exception */
+	X86_TRAP_AC,		/* 17, Alignment Check */
+	X86_TRAP_MC,		/* 18, Machine Check */
+	X86_TRAP_XF,		/* 19, SIMD Floating-Point Exception */
+	X86_TRAP_IRET = 32,	/* 32, IRET Exception */
+};
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index b3300e6..e328f69 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -61,7 +61,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
-	math_error(get_irq_regs(), 0, 16);
+	math_error(get_irq_regs(), 0, X86_TRAP_MF);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index cc88aec..ed4c00c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -133,7 +133,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
 		 * On nmi (interrupt 2), do_trap should not be called.
 		 */
-		if (trapnr < 6)
+		if (trapnr < X86_TRAP_UD)
 			goto vm86_trap;
 		goto trap_signal;
 	}
@@ -217,28 +217,32 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
+		regs->ip)
+DO_ERROR(X86_TRAP_OF, SIGSEGV, "overflow", overflow)
+DO_ERROR(X86_TRAP_BR, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(X86_TRAP_UD, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN,
+		regs->ip)
+DO_ERROR(X86_TRAP_OLD_MF, SIGFPE, "coprocessor segment overrun",
+		coprocessor_segment_overrun)
+DO_ERROR(X86_TRAP_TS, SIGSEGV, "invalid TSS", invalid_TSS)
+DO_ERROR(X86_TRAP_NP, SIGBUS, "segment not present", segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
+DO_ERROR(X86_TRAP_SS, SIGBUS, "stack segment", stack_segment)
 #endif
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
+DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
+		BUS_ADRALN, 0)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			12, SIGBUS) == NOTIFY_STOP)
+			X86_TRAP_SS, SIGBUS) == NOTIFY_STOP)
 		return;
-	conditional_sti_ist(regs);
-	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
-	conditional_cli_ist(regs);
+	preempt_conditional_sti(regs);
+	do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
 }
 
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -247,10 +251,10 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	struct task_struct *tsk = current;
 
 	/* Return not checked because double check cannot be ignored */
-	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
+	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
+	tsk->thread.trap_no = X86_TRAP_DF;
 
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
@@ -278,7 +282,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		goto gp_in_kernel;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_no = X86_TRAP_GP;
 
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 			printk_ratelimit()) {
@@ -305,9 +309,9 @@ gp_in_kernel:
 		return;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-	if (notify_die(DIE_GPF, "general protection fault", regs,
-				error_code, 13, SIGSEGV) == NOTIFY_STOP)
+	tsk->thread.trap_no = X86_TRAP_GP;
+	if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
+			X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
 		return;
 	die("general protection fault", regs, error_code);
 }
@@ -316,13 +320,13 @@ gp_in_kernel:
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
-	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
+				SIGTRAP) == NOTIFY_STOP)
 		return;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 #ifdef CONFIG_KPROBES
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
+			SIGTRAP) == NOTIFY_STOP)
 		return;
 #else
 	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
@@ -330,9 +334,15 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 		return;
 #endif
 
-	conditional_sti_ist(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
-	conditional_cli_ist(regs);
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	debug_stack_usage_inc();
+	preempt_conditional_sti(regs);
+	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
+	debug_stack_usage_dec();
 }
 
 #ifdef CONFIG_X86_64
@@ -429,9 +439,10 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	conditional_sti_ist(regs);
 
 	if (regs->flags & X86_VM_MASK) {
-		handle_vm86_trap((struct kernel_vm86_regs *) regs,
-				error_code, 1);
-		conditional_cli_ist(regs);
+		handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code,
+					X86_TRAP_DB);
+		preempt_conditional_cli(regs);
+		debug_stack_usage_dec();
 		return;
 	}
 
@@ -465,7 +476,8 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	struct task_struct *task = current;
 	siginfo_t info;
 	unsigned short err;
-	char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
+	char *str = (trapnr == X86_TRAP_MF) ? "fpu exception" :
+						"simd exception";
 
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
 		return;
@@ -490,7 +502,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_addr = (void __user *)regs->ip;
-	if (trapnr == 16) {
+	if (trapnr == X86_TRAP_MF) {
 		unsigned short cwd, swd;
 		/*
 		 * (~cwd & swd) will mask out exceptions that are not set to unmasked
@@ -534,10 +546,11 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 		info.si_code = FPE_FLTRES;
 	} else {
 		/*
-		 * If we're using IRQ 13, or supposedly even some trap 16
-		 * implementations, it's possible we get a spurious trap...
+		 * If we're using IRQ 13, or supposedly even some trap
+		 * X86_TRAP_MF implementations, it's possible
+		 * we get a spurious trap, which is not an error.
 		 */
-		return;		/* Spurious trap, no error */
+		return;
 	}
 	force_sig_info(SIGFPE, &info, task);
 }
@@ -548,13 +561,13 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 	ignore_fpu_irq = 1;
 #endif
 
-	math_error(regs, error_code, 16);
+	math_error(regs, error_code, X86_TRAP_MF);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	math_error(regs, error_code, 19);
+	math_error(regs, error_code, X86_TRAP_XF);
 }
 
 dotraplinkage void
@@ -672,20 +685,21 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	info.si_errno = 0;
 	info.si_code = ILL_BADSTK;
 	info.si_addr = NULL;
-	if (notify_die(DIE_TRAP, "iret exception",
-			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
+	if (notify_die(DIE_TRAP, "iret exception", regs, error_code,
+			X86_TRAP_IRET, SIGILL) == NOTIFY_STOP)
 		return;
-	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+	do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
+		&info);
 }
 #endif
 
 /* Set of traps needed for early debugging. */
 void __init early_trap_init(void)
 {
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(X86_TRAP_DB, &debug, DEBUG_STACK);
 	/* int3 can be called from all */
-	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
-	set_intr_gate(14, &page_fault);
+	set_system_intr_gate_ist(X86_TRAP_BP, &int3, DEBUG_STACK);
+	set_intr_gate(X86_TRAP_PF, &page_fault);
 	load_idt(&idt_descr);
 }
 
@@ -701,30 +715,30 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	set_intr_gate(X86_TRAP_DE, &divide_error);
+	set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK);
 	/* int4 can be called from all */
-	set_system_intr_gate(4, &overflow);
-	set_intr_gate(5, &bounds);
-	set_intr_gate(6, &invalid_op);
-	set_intr_gate(7, &device_not_available);
+	set_system_intr_gate(X86_TRAP_OF, &overflow);
+	set_intr_gate(X86_TRAP_BR, &bounds);
+	set_intr_gate(X86_TRAP_UD, &invalid_op);
+	set_intr_gate(X86_TRAP_NM, &device_not_available);
 #ifdef CONFIG_X86_32
-	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+	set_task_gate(X86_TRAP_DF, GDT_ENTRY_DOUBLEFAULT_TSS);
 #else
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+	set_intr_gate_ist(X86_TRAP_DF, &double_fault, DOUBLEFAULT_STACK);
 #endif
-	set_intr_gate(9, &coprocessor_segment_overrun);
-	set_intr_gate(10, &invalid_TSS);
-	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(13, &general_protection);
-	set_intr_gate(15, &spurious_interrupt_bug);
-	set_intr_gate(16, &coprocessor_error);
-	set_intr_gate(17, &alignment_check);
+	set_intr_gate(X86_TRAP_OLD_MF, &coprocessor_segment_overrun);
+	set_intr_gate(X86_TRAP_TS, &invalid_TSS);
+	set_intr_gate(X86_TRAP_NP, &segment_not_present);
+	set_intr_gate_ist(X86_TRAP_SS, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(X86_TRAP_GP, &general_protection);
+	set_intr_gate(X86_TRAP_SPURIOUS, &spurious_interrupt_bug);
+	set_intr_gate(X86_TRAP_MF, &coprocessor_error);
+	set_intr_gate(X86_TRAP_AC, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
+	set_intr_gate_ist(X86_TRAP_MC, &machine_check, MCE_STACK);
 #endif
-	set_intr_gate(19, &simd_coprocessor_error);
+	set_intr_gate(X86_TRAP_XF, &simd_coprocessor_error);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
---1463806542-1746295343-1358874917=:14732--
