Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaCGRsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:48:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:40168 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCGRsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:48:12 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] x86: Do not disable preemption in int3 on 32bit
Date: Fri,  7 Mar 2014 18:48:03 +0100
Message-Id: <1394214483-17606-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Preemption must be disabled before enabling interrupts in do_trap
on x86_64 because the stack in use for int3 and debug is a per CPU
stack set by th IST. But 32bit does not have an IST and the stack
still belongs to the current task and there is no problem in scheduling
out the task.

Keep preemption enabled on X86_32 when enabling interrupts for
do_trap().

The name of the function is changed from preempt_conditional_sti/cli()
to conditional_sti/cli_ist(), to annotate that this function is used
when the stack is on the IST.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/traps.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..48dab0c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -86,9 +86,21 @@ static inline void conditional_sti(struct pt_regs *regs)
 		local_irq_enable();
 }
 
-static inline void preempt_conditional_sti(struct pt_regs *regs)
+static inline void conditional_sti_ist(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
+	/*
+	 * X86_64 uses a per CPU stack on the IST for certain traps
+	 * like int3. The task can not be preempted when using one
+	 * of these stacks, thus preemption must be disabled, otherwise
+	 * the stack can be corrupted if the task is scheduled out,
+	 * and another task comes in and uses this stack.
+	 *
+	 * On x86_32 the task keeps its own stack and it is OK if the
+	 * task schedules out.
+	 */
 	preempt_count_inc();
+#endif
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -99,11 +111,13 @@ static inline void conditional_cli(struct pt_regs *regs)
 		local_irq_disable();
 }
 
-static inline void preempt_conditional_cli(struct pt_regs *regs)
+static inline void conditional_cli_ist(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
+#ifdef CONFIG_X86_64
 	preempt_count_dec();
+#endif
 }
 
 static int __kprobes
@@ -232,9 +246,9 @@ dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 	prev_state = exception_enter();
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
-		preempt_conditional_sti(regs);
+		conditional_sti_ist(regs);
 		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
-		preempt_conditional_cli(regs);
+		conditional_cli_ist(regs);
 	}
 	exception_exit(prev_state);
 }
@@ -343,9 +357,9 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	 * as we may switch to the interrupt stack.
 	 */
 	debug_stack_usage_inc();
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 	debug_stack_usage_dec();
 exit:
 	exception_exit(prev_state);
@@ -451,12 +465,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	debug_stack_usage_inc();
 
 	/* It's safe to allow irq's after DR6 has been saved */
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 
 	if (regs->flags & X86_VM_MASK) {
 		handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code,
 					X86_TRAP_DB);
-		preempt_conditional_cli(regs);
+		conditional_cli_ist(regs);
 		debug_stack_usage_dec();
 		goto exit;
 	}
@@ -476,7 +490,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	si_code = get_si_code(tsk->thread.debugreg6);
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 	debug_stack_usage_dec();
 
 exit:
-- 
1.9.0

