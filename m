Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaHDNU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbaHDNU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:20:27 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/6] x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user
Date: Mon,  4 Aug 2014 15:19:43 +0200
Message-Id: <1407158386-6201-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No code changes.

This is a preparatory patch for change in "struct pt_regs" handling.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
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
 arch/x86/kernel/entry_64.S | 88 ++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index dbfd037..37f7d95 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -218,51 +218,6 @@ ENDPROC(native_usergs_sysret64)
 	CFI_REL_OFFSET r15, R15+\offset
 	.endm
 
-/* save partial stack frame */
-	.macro SAVE_ARGS_IRQ
-	cld
-	/* start from rbp in pt_regs and jump over */
-	movq_cfi rdi, (RDI-RBP)
-	movq_cfi rsi, (RSI-RBP)
-	movq_cfi rdx, (RDX-RBP)
-	movq_cfi rcx, (RCX-RBP)
-	movq_cfi rax, (RAX-RBP)
-	movq_cfi  r8,  (R8-RBP)
-	movq_cfi  r9,  (R9-RBP)
-	movq_cfi r10, (R10-RBP)
-	movq_cfi r11, (R11-RBP)
-
-	/* Save rbp so that we can unwind from get_irq_regs() */
-	movq_cfi rbp, 0
-
-	/* Save previous stack value */
-	movq %rsp, %rsi
-
-	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
-	testl $3, CS-RBP(%rsi)
-	je 1f
-	SWAPGS
-	/*
-	 * irq_count is used to check if a CPU is already on an interrupt stack
-	 * or not. While this is essentially redundant with preempt_count it is
-	 * a little cheaper to use a separate counter in the PDA (short of
-	 * moving irq_enter into assembly, which would be too much work)
-	 */
-1:	incl PER_CPU_VAR(irq_count)
-	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
-	CFI_DEF_CFA_REGISTER	rsi
-
-	/* Store previous stack value */
-	pushq %rsi
-	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
-			0x77 /* DW_OP_breg7 */, 0, \
-			0x06 /* DW_OP_deref */, \
-			0x08 /* DW_OP_const1u */, SS+8-RBP, \
-			0x22 /* DW_OP_plus */
-	/* We entered an interrupt context - irqs are off: */
-	TRACE_IRQS_OFF
-	.endm
-
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
@@ -731,7 +686,48 @@ END(interrupt)
 	/* reserve pt_regs for scratch regs and rbp */
 	subq $ORIG_RAX-RBP, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
-	SAVE_ARGS_IRQ
+	cld
+	/* start from rbp in pt_regs and jump over */
+	movq_cfi rdi, (RDI-RBP)
+	movq_cfi rsi, (RSI-RBP)
+	movq_cfi rdx, (RDX-RBP)
+	movq_cfi rcx, (RCX-RBP)
+	movq_cfi rax, (RAX-RBP)
+	movq_cfi  r8,  (R8-RBP)
+	movq_cfi  r9,  (R9-RBP)
+	movq_cfi r10, (R10-RBP)
+	movq_cfi r11, (R11-RBP)
+
+	/* Save rbp so that we can unwind from get_irq_regs() */
+	movq_cfi rbp, 0
+
+	/* Save previous stack value */
+	movq %rsp, %rsi
+
+	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
+	testl $3, CS-RBP(%rsi)
+	je 1f
+	SWAPGS
+	/*
+	 * irq_count is used to check if a CPU is already on an interrupt stack
+	 * or not. While this is essentially redundant with preempt_count it is
+	 * a little cheaper to use a separate counter in the PDA (short of
+	 * moving irq_enter into assembly, which would be too much work)
+	 */
+1:	incl PER_CPU_VAR(irq_count)
+	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
+	CFI_DEF_CFA_REGISTER	rsi
+
+	/* Store previous stack value */
+	pushq %rsi
+	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
+			0x77 /* DW_OP_breg7 */, 0, \
+			0x06 /* DW_OP_deref */, \
+			0x08 /* DW_OP_const1u */, SS+8-RBP, \
+			0x22 /* DW_OP_plus */
+	/* We entered an interrupt context - irqs are off: */
+	TRACE_IRQS_OFF
+
 	call \func
 	.endm
 
-- 
1.8.1.4

