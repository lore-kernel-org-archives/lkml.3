Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaHHRpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbaHHRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:45:44 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 10/17] x86: entry_64.S: rename save_paranoid to paranoid_entry, no code changes
Date: Fri,  8 Aug 2014 19:44:33 +0200
Message-Id: <1407519880-6719-11-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does a lot of cleanup in comments and formatting,
but it does not change any code.

Rename save_paranoid to paranoid_entry: this makes naming
similar to its "non-paranoid" sibling, error_entry,
and to it counterpart, paranoid_exit.

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
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/entry_64.S | 117 +++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 5ad9b28..decfe25 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1000,10 +1000,11 @@ ENTRY(\sym)
 	ALLOC_PTREGS_ON_STACK
 
 	.if \paranoid
-	call save_paranoid
+	call paranoid_entry
 	.else
 	call error_entry
 	.endif
+	/* returned flag: ebx=0: need swapgs on exit, ebx=1: don't need it */
 
 	DEFAULT_FRAME 0
 
@@ -1034,10 +1035,11 @@ ENTRY(\sym)
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
 
 	CFI_ENDPROC
@@ -1242,36 +1244,40 @@ idtentry async_page_fault do_async_page_fault has_error_code=1
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
-	movl $1,%ebx
-	movl $MSR_GS_BASE,%ecx
+	movl	$1,%ebx
+	movl	$MSR_GS_BASE,%ecx
 	rdmsr
-	testl %edx,%edx
-	js 1f	/* negative -> in kernel */
+	testl	%edx,%edx
+	js	1f	/* negative -> in kernel */
 	SWAPGS
-	xorl %ebx,%ebx
+	xorl	%ebx,%ebx
 1:	ret
 	CFI_ENDPROC
-END(save_paranoid)
-
-	/*
-	 * "Paranoid" exit path from exception stack.
-	 * Paranoid because this is used by NMIs and cannot take
-	 * any kernel state for granted.
-	 * We don't do kernel preemption checks here, because only
-	 * NMI should be common and it does not enable IRQs and
-	 * cannot get reschedule ticks.
-	 *
-	 * "trace" is 0 for the NMI handler only, because irq-tracing
-	 * is fundamentally NMI-unsafe. (we cannot change the soft and
-	 * hard flags at once, atomically)
-	 */
+END(paranoid_entry)
 
-	/* ebx:	no swapgs flag */
+/*
+ * "Paranoid" exit path from exception stack.
+ * Paranoid because this is used by NMIs and cannot take
+ * any kernel state for granted.
+ * We don't do kernel preemption checks here, because only
+ * NMI should be common and it does not enable IRQs and
+ * cannot get reschedule ticks.
+ *
+ * "trace" is 0 for the NMI handler only, because irq-tracing
+ * is fundamentally NMI-unsafe. (we cannot change the soft and
+ * hard flags at once, atomically)
+ */
+/* On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it) */
 ENTRY(paranoid_exit)
 	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1323,53 +1329,48 @@ paranoid_schedule:
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
-	je error_kernelspace
+	xorl	%ebx,%ebx
+	testl	$3,CS+8(%rsp)
+	jz error_kernelspace
 error_swapgs:
 	SWAPGS
 error_sti:
 	TRACE_IRQS_OFF
 	ret
-
-/*
- * There are two places in the kernel that can potentially fault with
- * usergs. Handle them here. The exception handlers after iret run with
- * kernel gs again, so don't set the user space flag. B stepping K8s
- * sometimes report an truncated RIP for IRET exceptions returning to
- * compat mode. Check for these here too.
- */
+	/*
+	 * There are two places in the kernel that can potentially fault with
+	 * usergs. Handle them here. The exception handlers after iret run with
+	 * kernel gs again, so don't set the user space flag. B stepping K8s
+	 * sometimes report an truncated RIP for IRET exceptions returning to
+	 * compat mode. Check for these here too.
+	 */
 error_kernelspace:
-	incl %ebx
-	leaq irq_return_iret(%rip),%rcx
-	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
-	movl %ecx,%eax	/* zero extend */
-	cmpq %rax,RIP+8(%rsp)
-	je bstep_iret
-	cmpq $gs_change,RIP+8(%rsp)
-	je error_swapgs
-	jmp error_sti
-
+	incl	%ebx
+	leaq	irq_return_iret(%rip),%rcx
+	cmpq	%rcx,RIP+8(%rsp)
+	je	error_swapgs
+	movl	%ecx,%eax	/* zero extend */
+	cmpq	%rax,RIP+8(%rsp)
+	je	bstep_iret
+	cmpq	$gs_change,RIP+8(%rsp)
+	je	error_swapgs
+	jmp	error_sti
 bstep_iret:
 	/* Fix truncated RIP */
-	movq %rcx,RIP+8(%rsp)
-	jmp error_swapgs
+	movq	%rcx,RIP+8(%rsp)
+	jmp	error_swapgs
 	CFI_ENDPROC
 END(error_entry)
 
-
-/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
+/* On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it) */
 ENTRY(error_exit)
 	DEFAULT_FRAME
 	movl %ebx,%eax
@@ -1595,13 +1596,13 @@ end_repeat_nmi:
 	ALLOC_PTREGS_ON_STACK
 
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

