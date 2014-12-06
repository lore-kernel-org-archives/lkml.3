Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaLFPZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:25:44 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47679 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751996AbaLFPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:01 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 13/66] x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
Date: Sat,  6 Dec 2014 16:07:05 +0100
Message-Id: <8f9d4f83ed394c6add6be0f27ca466304f1fc42a.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit af726f21ed8af2cdaa4e93098dc211521218ae65 upstream.

There's nothing special enough about the espfix64 double fault fixup to
justify writing it in assembly.  Move it to C.

This also fixes a bug: if the double fault came from an IST stack, the
old asm code would return to a partially uninitialized stack frame.

Fixes: 3891a04aafd668686239349ea58f3314ea2af86b
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/entry_64.S | 34 ++--------------------------------
 arch/x86/kernel/traps.c    | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 207da8d92f75..c2ab43484b5d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1053,6 +1053,7 @@ ENTRY(native_iret)
 	jnz native_irq_return_ldt
 #endif
 
+.global native_irq_return_iret
 native_irq_return_iret:
 	iretq
 	_ASM_EXTABLE(native_irq_return_iret, bad_iret)
@@ -1149,37 +1150,6 @@ ENTRY(retint_kernel)
 	CFI_ENDPROC
 END(common_interrupt)
 
-	/*
-	 * If IRET takes a fault on the espfix stack, then we
-	 * end up promoting it to a doublefault.  In that case,
-	 * modify the stack to make it look like we just entered
-	 * the #GP handler from user space, similar to bad_iret.
-	 */
-#ifdef CONFIG_X86_ESPFIX64
-	ALIGN
-__do_double_fault:
-	XCPT_FRAME 1 RDI+8
-	movq RSP(%rdi),%rax		/* Trap on the espfix stack? */
-	sarq $PGDIR_SHIFT,%rax
-	cmpl $ESPFIX_PGD_ENTRY,%eax
-	jne do_double_fault		/* No, just deliver the fault */
-	cmpl $__KERNEL_CS,CS(%rdi)
-	jne do_double_fault
-	movq RIP(%rdi),%rax
-	cmpq $native_irq_return_iret,%rax
-	jne do_double_fault		/* This shouldn't happen... */
-	movq PER_CPU_VAR(kernel_stack),%rax
-	subq $(6*8-KERNEL_STACK_OFFSET),%rax	/* Reset to original stack */
-	movq %rax,RSP(%rdi)
-	movq $0,(%rax)			/* Missing (lost) #GP error code */
-	movq $general_protection,RIP(%rdi)
-	retq
-	CFI_ENDPROC
-END(__do_double_fault)
-#else
-# define __do_double_fault do_double_fault
-#endif
-
 /*
  * End of kprobes section
  */
@@ -1370,7 +1340,7 @@ zeroentry overflow do_overflow
 zeroentry bounds do_bounds
 zeroentry invalid_op do_invalid_op
 zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault __do_double_fault
+paranoiderrorentry double_fault do_double_fault
 zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
 errorentry invalid_TSS do_invalid_TSS
 errorentry segment_not_present do_segment_not_present
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8c8093b146ca..8a2684f938b9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -248,6 +248,30 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
 
+#ifdef CONFIG_X86_ESPFIX64
+	extern unsigned char native_irq_return_iret[];
+
+	/*
+	 * If IRET takes a non-IST fault on the espfix64 stack, then we
+	 * end up promoting it to a doublefault.  In that case, modify
+	 * the stack to make it look like we just entered the #GP
+	 * handler from user space, similar to bad_iret.
+	 */
+	if (((long)regs->sp >> PGDIR_SHIFT) == ESPFIX_PGD_ENTRY &&
+		regs->cs == __KERNEL_CS &&
+		regs->ip == (unsigned long)native_irq_return_iret)
+	{
+		struct pt_regs *normal_regs = task_pt_regs(current);
+
+		/* Fake a #GP(0) from userspace. */
+		memmove(&normal_regs->ip, (void *)regs->sp, 5*8);
+		normal_regs->orig_ax = 0;  /* Missing (lost) #GP error code */
+		regs->ip = (unsigned long)general_protection;
+		regs->sp = (unsigned long)&normal_regs->orig_ax;
+		return;
+	}
+#endif
+
 	exception_enter();
 	/* Return not checked because double check cannot be ignored */
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
-- 
2.1.3

