Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaLBTYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:24:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46739 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424AbaLBTYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:24:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 119/121] x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
Date: Tue,  2 Dec 2014 11:19:58 -0800
Message-Id: <1417548000-1794-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit af726f21ed8af2cdaa4e93098dc211521218ae65 upstream.

There's nothing special enough about the espfix64 double fault fixup to
justify writing it in assembly.  Move it to C.

This also fixes a bug: if the double fault came from an IST stack, the
old asm code would return to a partially uninitialized stack frame.

Fixes: 3891a04aafd668686239349ea58f3314ea2af86b
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/entry_64.S | 34 ++--------------------------------
 arch/x86/kernel/traps.c    | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 03cd2a8..2bb5032 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1053,6 +1053,7 @@ ENTRY(native_iret)
 	jnz native_irq_return_ldt
 #endif
 
+.global native_irq_return_iret
 native_irq_return_iret:
 	iretq
 	_ASM_EXTABLE(native_irq_return_iret, bad_iret)
@@ -1147,37 +1148,6 @@ ENTRY(retint_kernel)
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
@@ -1379,7 +1349,7 @@ zeroentry overflow do_overflow
 zeroentry bounds do_bounds
 zeroentry invalid_op do_invalid_op
 zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault __do_double_fault
+paranoiderrorentry double_fault do_double_fault
 zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
 errorentry invalid_TSS do_invalid_TSS
 errorentry segment_not_present do_segment_not_present
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b857ed8..e5b2976 100644
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
1.9.1

