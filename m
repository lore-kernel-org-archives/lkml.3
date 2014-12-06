Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaLFPIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:08:35 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47676 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbaLFPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 15/66] x86_64, traps: Rework bad_iret
Date: Sat,  6 Dec 2014 16:07:07 +0100
Message-Id: <ae0256eb36f88f75533d57c957cc73a2660e1327.1417878427.git.jslaby@suse.cz>
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

commit b645af2d5905c4e32399005b867987919cbfc3ae upstream.

It's possible for iretq to userspace to fail.  This can happen because
of a bad CS, SS, or RIP.

Historically, we've handled it by fixing up an exception from iretq to
land at bad_iret, which pretends that the failed iret frame was really
the hardware part of #GP(0) from userspace.  To make this work, there's
an extra fixup to fudge the gs base into a usable state.

This is suboptimal because it loses the original exception.  It's also
buggy because there's no guarantee that we were on the kernel stack to
begin with.  For example, if the failing iret happened on return from an
NMI, then we'll end up executing general_protection on the NMI stack.
This is bad for several reasons, the most immediate of which is that
general_protection, as a non-paranoid idtentry, will try to deliver
signals and/or schedule from the wrong stack.

This patch throws out bad_iret entirely.  As a replacement, it augments
the existing swapgs fudge into a full-blown iret fixup, mostly written
in C.  It's should be clearer and more correct.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/entry_64.S | 45 +++++++++++++++++++--------------------------
 arch/x86/kernel/traps.c    | 29 +++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e310e82de5e6..e96560628571 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1055,8 +1055,13 @@ ENTRY(native_iret)
 
 .global native_irq_return_iret
 native_irq_return_iret:
+	/*
+	 * This may fault.  Non-paranoid faults on return to userspace are
+	 * handled by fixup_bad_iret.  These include #SS, #GP, and #NP.
+	 * Double-faults due to espfix64 are handled in do_double_fault.
+	 * Other faults here are fatal.
+	 */
 	iretq
-	_ASM_EXTABLE(native_irq_return_iret, bad_iret)
 
 #ifdef CONFIG_X86_ESPFIX64
 native_irq_return_ldt:
@@ -1084,25 +1089,6 @@ native_irq_return_ldt:
 	jmp native_irq_return_iret
 #endif
 
-	.section .fixup,"ax"
-bad_iret:
-	/*
-	 * The iret traps when the %cs or %ss being restored is bogus.
-	 * We've lost the original trap vector and error code.
-	 * #GPF is the most likely one to get for an invalid selector.
-	 * So pretend we completed the iret and took the #GPF in user mode.
-	 *
-	 * We are now running with the kernel GS after exception recovery.
-	 * But error_entry expects us to have user GS to match the user %cs,
-	 * so swap back.
-	 */
-	pushq $0
-
-	SWAPGS
-	jmp general_protection
-
-	.previous
-
 	/* edi: workmask, edx: work */
 retint_careful:
 	CFI_RESTORE_STATE
@@ -1620,16 +1606,15 @@ error_sti:
 
 /*
  * There are two places in the kernel that can potentially fault with
- * usergs. Handle them here. The exception handlers after iret run with
- * kernel gs again, so don't set the user space flag. B stepping K8s
- * sometimes report an truncated RIP for IRET exceptions returning to
- * compat mode. Check for these here too.
+ * usergs. Handle them here.  B stepping K8s sometimes report a
+ * truncated RIP for IRET exceptions returning to compat mode. Check
+ * for these here too.
  */
 error_kernelspace:
 	incl %ebx
 	leaq native_irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
+	je error_bad_iret
 	movl %ecx,%eax	/* zero extend */
 	cmpq %rax,RIP+8(%rsp)
 	je bstep_iret
@@ -1640,7 +1625,15 @@ error_kernelspace:
 bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
-	jmp error_swapgs
+	/* fall through */
+
+error_bad_iret:
+	SWAPGS
+	mov %rsp,%rdi
+	call fixup_bad_iret
+	mov %rax,%rsp
+	decl %ebx	/* Return to usergs */
+	jmp error_sti
 	CFI_ENDPROC
 END(error_entry)
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b2d6c58b28b0..5739ab5359a3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -388,6 +388,35 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 		*regs = *eregs;
 	return regs;
 }
+
+struct bad_iret_stack {
+	void *error_entry_ret;
+	struct pt_regs regs;
+};
+
+asmlinkage __visible
+struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
+{
+	/*
+	 * This is called from entry_64.S early in handling a fault
+	 * caused by a bad iret to user mode.  To handle the fault
+	 * correctly, we want move our stack frame to task_pt_regs
+	 * and we want to pretend that the exception came from the
+	 * iret target.
+	 */
+	struct bad_iret_stack *new_stack =
+		container_of(task_pt_regs(current),
+			     struct bad_iret_stack, regs);
+
+	/* Copy the IRET target to the new stack. */
+	memmove(&new_stack->regs.ip, (void *)s->regs.sp, 5*8);
+
+	/* Copy the remainder of the stack from the current stack. */
+	memmove(new_stack, s, offsetof(struct bad_iret_stack, regs.ip));
+
+	BUG_ON(!user_mode_vm(&new_stack->regs));
+	return new_stack;
+}
 #endif
 
 /*
-- 
2.1.3

