Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbbANVuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:50:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbbANVt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:49:59 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] x86: entry_64.S: use more understandable constants
Date: Wed, 14 Jan 2015 22:48:21 +0100
Message-Id: <1421272101-16847-11-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constants such as SS+8 or SS+8-RIP are mysterious.
In most cases, SS+8 is just meant to be SIZEOF_PTREGS,
SS+8-RIP is RIP's offset in iret frame.

This patch changes some of these constants to be less mysterious.
No code changes (verified with objdump).

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
 arch/x86/kernel/entry_64.S | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 279af0e..d84c7c7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -163,12 +163,12 @@ ENDPROC(native_usergs_sysret64)
  * initial frame state for interrupts (and exceptions without error code)
  */
 	.macro INTR_FRAME start=1 offset=0
-	EMPTY_FRAME \start, SS+8+\offset-RIP
-	/*CFI_REL_OFFSET ss, SS+\offset-RIP*/
-	CFI_REL_OFFSET rsp, RSP+\offset-RIP
-	/*CFI_REL_OFFSET rflags, EFLAGS+\offset-RIP*/
-	/*CFI_REL_OFFSET cs, CS+\offset-RIP*/
-	CFI_REL_OFFSET rip, RIP+\offset-RIP
+	EMPTY_FRAME \start, 5*8+\offset
+	/*CFI_REL_OFFSET ss, 4*8+\offset*/
+	CFI_REL_OFFSET rsp, 3*8+\offset
+	/*CFI_REL_OFFSET rflags, 2*8+\offset*/
+	/*CFI_REL_OFFSET cs, 1*8+\offset*/
+	CFI_REL_OFFSET rip, 0*8+\offset
 	.endm
 
 /*
@@ -176,7 +176,7 @@ ENDPROC(native_usergs_sysret64)
  * with vector already pushed)
  */
 	.macro XCPT_FRAME start=1 offset=0
-	INTR_FRAME \start, RIP+\offset-ORIG_RAX
+	INTR_FRAME \start, 1*8+\offset
 	.endm
 
 /*
@@ -685,10 +685,14 @@ END(interrupt)
 	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	CFI_DEF_CFA_REGISTER	rsi
 	pushq %rsi
+	/*
+	 * For debugger:
+	 * "CFA (Current Frame Address) is the value on stack + offset"
+	 */
 	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
-			0x77 /* DW_OP_breg7 */, 0, \
+			0x77 /* DW_OP_breg7 (rsp) */, 0, \
 			0x06 /* DW_OP_deref */, \
-			0x08 /* DW_OP_const1u */, SS+8-RBP, \
+			0x08 /* DW_OP_const1u */, SIZEOF_PTREGS-RBP, \
 			0x22 /* DW_OP_plus */
 	/* We entered an interrupt context - irqs are off: */
 	TRACE_IRQS_OFF
@@ -714,7 +718,7 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
+	CFI_DEF_CFA rsi,SIZEOF_PTREGS-RBP /* reg/off reset after def_cfa_expr */
 	/* return code expects complete pt_regs - adjust rsp accordingly: */
 	leaq -RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
@@ -1525,7 +1529,7 @@ first_nmi:
 	.rept 5
 	pushq_cfi 11*8(%rsp)
 	.endr
-	CFI_DEF_CFA_OFFSET SS+8-RIP
+	CFI_DEF_CFA_OFFSET 5*8
 
 	/* Everything up to here is safe from nested NMIs */
 
@@ -1553,7 +1557,7 @@ repeat_nmi:
 	pushq_cfi -6*8(%rsp)
 	.endr
 	subq $(5*8), %rsp
-	CFI_DEF_CFA_OFFSET SS+8-RIP
+	CFI_DEF_CFA_OFFSET 5*8
 end_repeat_nmi:
 
 	/*
-- 
1.8.1.4

