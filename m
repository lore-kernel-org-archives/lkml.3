Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbbANVtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:49:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbbANVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:49:37 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] x86: entry_64.S: rename save_paranoid to paranoid_entry, no code changes
Date: Wed, 14 Jan 2015 22:48:17 +0100
Message-Id: <1421272101-16847-7-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does a lot of cleanup in comments and formatting,
but it does not change any code.

Rename save_paranoid to paranoid_entry: this makes naming
similar to its "non-paranoid" sibling, error_entry,
and to its counterpart, paranoid_exit.

Use the same CFI annotation atop paranoid_entry and error_entry.

Fix irregular indentation of assembler operands.

Add/fix comments on top of paranoid_entry and error_entry.
Remove stale comment about "oldrax".
Make comments about "no swapgs" flag in ebx more prominent.
Deindent wrongly indented top-level comment atop paranoid_exit.
Indent wrongly deindented comment inside error_entry.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/entry_64.S | 104 +++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index d72e46e..aacfa2c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -968,10 +968,11 @@ ENTRY(\sym)
 	testl $3, CS(%rsp)		/* If coming from userspace, switch */
 	jnz 1f				/* stacks. */
 	.endif
-	call save_paranoid
+	call paranoid_entry
 	.else
 	call error_entry
 	.endif
+	/* returned flag: ebx=0: need swapgs on exit, ebx=1: don't need it */
 
 	DEFAULT_FRAME 0
 
@@ -1002,10 +1003,11 @@ ENTRY(\sym)
 	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\shift_ist)
 	.endif
 
+	/* these procedures expect "no swapgs" flag in ebx */
 	.if \paranoid
-	jmp paranoid_exit		/* %ebx: no swapgs flag */
+	jmp paranoid_exit
 	.else
-	jmp error_exit			/* %ebx: no swapgs flag */
+	jmp error_exit
 	.endif
 
 	.if \paranoid == 1
@@ -1240,8 +1242,13 @@ idtentry async_page_fault do_async_page_fault has_error_code=1
 idtentry machine_check has_error_code=0 paranoid=1 do_sym=*machine_check_vector(%rip)
 #endif
 
-ENTRY(save_paranoid)
-	XCPT_FRAME 1 RDI+8
+/*
+ * Save all registers in pt_regs, and switch gs if needed.
+ * Use slow, but surefire "are we in kernel?" check.
+ * Return: ebx=0: need swapgs on exit, ebx=1: otherwise
+ */
+ENTRY(paranoid_entry)
+	XCPT_FRAME 1 15*8
 	cld
 	SAVE_C_REGS 8
 	SAVE_EXTRA_REGS 8
@@ -1254,20 +1261,19 @@ ENTRY(save_paranoid)
 	xorl %ebx,%ebx
 1:	ret
 	CFI_ENDPROC
-END(save_paranoid)
+END(paranoid_entry)
 
-	/*
-	 * "Paranoid" exit path from exception stack.  This is invoked
-	 * only on return from non-NMI IST interrupts that came
-	 * from kernel space.
-	 *
-	 * We may be returning to very strange contexts (e.g. very early
-	 * in syscall entry), so checking for preemption here would
-	 * be complicated.  Fortunately, we there's no good reason
-	 * to try to handle preemption here.
-	 */
-
-	/* ebx:	no swapgs flag */
+/*
+ * "Paranoid" exit path from exception stack.  This is invoked
+ * only on return from non-NMI IST interrupts that came
+ * from kernel space.
+ *
+ * We may be returning to very strange contexts (e.g. very early
+ * in syscall entry), so checking for preemption here would
+ * be complicated.  Fortunately, we there's no good reason
+ * to try to handle preemption here.
+ */
+/* On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it) */
 ENTRY(paranoid_exit)
 	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1288,18 +1294,16 @@ paranoid_restore1:
 END(paranoid_exit)
 
 /*
- * Exception entry point. This expects an error code/orig_rax on the stack.
- * returns in "no swapgs flag" in %ebx.
+ * Save all registers in pt_regs, and switch gs if needed.
+ * Return: ebx=0: need swapgs on exit, ebx=1: otherwise
  */
 ENTRY(error_entry)
-	XCPT_FRAME
-	CFI_ADJUST_CFA_OFFSET 15*8
-	/* oldrax contains error code */
+	XCPT_FRAME 1 15*8
 	cld
 	SAVE_C_REGS 8
 	SAVE_EXTRA_REGS 8
-	xorl %ebx,%ebx
-	testl $3,CS+8(%rsp)
+	xorl	%ebx,%ebx
+	testl	$3,CS+8(%rsp)
 	je error_kernelspace
 error_swapgs:
 	SWAPGS
@@ -1307,42 +1311,42 @@ error_sti:
 	TRACE_IRQS_OFF
 	ret
 
-/*
- * There are two places in the kernel that can potentially fault with
- * usergs. Handle them here.  B stepping K8s sometimes report a
- * truncated RIP for IRET exceptions returning to compat mode. Check
- * for these here too.
- */
+	/*
+	 * There are two places in the kernel that can potentially fault with
+	 * usergs. Handle them here.  B stepping K8s sometimes report a
+	 * truncated RIP for IRET exceptions returning to compat mode. Check
+	 * for these here too.
+	 */
 error_kernelspace:
 	CFI_REL_OFFSET rcx, RCX+8
-	incl %ebx
-	leaq native_irq_return_iret(%rip),%rcx
-	cmpq %rcx,RIP+8(%rsp)
-	je error_bad_iret
-	movl %ecx,%eax	/* zero extend */
-	cmpq %rax,RIP+8(%rsp)
-	je bstep_iret
-	cmpq $gs_change,RIP+8(%rsp)
-	je error_swapgs
-	jmp error_sti
+	incl	%ebx
+	leaq	native_irq_return_iret(%rip),%rcx
+	cmpq	%rcx,RIP+8(%rsp)
+	je	error_bad_iret
+	movl	%ecx,%eax	/* zero extend */
+	cmpq	%rax,RIP+8(%rsp)
+	je	bstep_iret
+	cmpq	$gs_change,RIP+8(%rsp)
+	je	error_swapgs
+	jmp	error_sti
 
 bstep_iret:
 	/* Fix truncated RIP */
-	movq %rcx,RIP+8(%rsp)
+	movq	%rcx,RIP+8(%rsp)
 	/* fall through */
 
 error_bad_iret:
 	SWAPGS
-	mov %rsp,%rdi
-	call fixup_bad_iret
-	mov %rax,%rsp
-	decl %ebx	/* Return to usergs */
-	jmp error_sti
+	mov	%rsp,%rdi
+	call	fixup_bad_iret
+	mov	%rax,%rsp
+	decl	%ebx	/* Return to usergs */
+	jmp	error_sti
 	CFI_ENDPROC
 END(error_entry)
 
 
-/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
+/* On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it) */
 ENTRY(error_exit)
 	DEFAULT_FRAME
 	movl %ebx,%eax
@@ -1568,13 +1572,13 @@ end_repeat_nmi:
 	ALLOC_PT_GPREGS_ON_STACK
 
 	/*
-	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
+	 * Use paranoid_entry to handle SWAPGS, but no need to use paranoid_exit
 	 * as we should not be calling schedule in NMI context.
 	 * Even with normal interrupts enabled. An NMI should not be
 	 * setting NEED_RESCHED or anything that normal interrupts and
 	 * exceptions might do.
 	 */
-	call save_paranoid
+	call paranoid_entry
 	DEFAULT_FRAME 0
 
 	/*
-- 
1.8.1.4

