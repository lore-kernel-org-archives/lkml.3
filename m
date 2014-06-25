Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbaFYNL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:11:28 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:50757 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbaFYNL0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 25 Jun 2014 09:11:26 -0400
Message-Id: <53AAE69A020000780001D3C7@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 25 Jun 2014 14:11:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: drop several unnecessary CFI annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the conversion of the register saving code from macros to
functions, and with those functions not clobbering most of the
registers they spill, there's no need to annotate most of the spill
operations; the only exceptions being %rbx (always modified) and %rcx
(modified on the error_kernelspace: path).

Also remove a bogus commented out annotation - there's no register
%orig_rax after all.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/kernel/entry_64.S |   52 ++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- 3.16-rc2/arch/x86/kernel/entry_64.S
+++ 3.16-rc2-x86_64-unwind/arch/x86/kernel/entry_64.S
@@ -207,7 +207,6 @@ ENDPROC(native_usergs_sysret64)
  */
 	.macro XCPT_FRAME start=1 offset=0
 	INTR_FRAME \start, RIP+\offset-ORIG_RAX
-	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
 	.endm
 
 /*
@@ -287,21 +286,21 @@ ENDPROC(native_usergs_sysret64)
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
+	movq %rdi, RDI+8(%rsp)
+	movq %rsi, RSI+8(%rsp)
 	movq_cfi rdx, RDX+8
 	movq_cfi rcx, RCX+8
 	movq_cfi rax, RAX+8
-	movq_cfi r8, R8+8
-	movq_cfi r9, R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
+	movq %r8, R8+8(%rsp)
+	movq %r9, R9+8(%rsp)
+	movq %r10, R10+8(%rsp)
+	movq %r11, R11+8(%rsp)
 	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
+	movq %rbp, RBP+8(%rsp)
+	movq %r12, R12+8(%rsp)
+	movq %r13, R13+8(%rsp)
+	movq %r14, R14+8(%rsp)
+	movq %r15, R15+8(%rsp)
 	movl $1,%ebx
 	movl $MSR_GS_BASE,%ecx
 	rdmsr
@@ -1395,21 +1394,21 @@ ENTRY(error_entry)
 	CFI_ADJUST_CFA_OFFSET 15*8
 	/* oldrax contains error code */
 	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
-	movq_cfi rdx, RDX+8
-	movq_cfi rcx, RCX+8
-	movq_cfi rax, RAX+8
-	movq_cfi  r8,  R8+8
-	movq_cfi  r9,  R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
+	movq %rdi, RDI+8(%rsp)
+	movq %rsi, RSI+8(%rsp)
+	movq %rdx, RDX+8(%rsp)
+	movq %rcx, RCX+8(%rsp)
+	movq %rax, RAX+8(%rsp)
+	movq  %r8,  R8+8(%rsp)
+	movq  %r9,  R9+8(%rsp)
+	movq %r10, R10+8(%rsp)
+	movq %r11, R11+8(%rsp)
 	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
+	movq %rbp, RBP+8(%rsp)
+	movq %r12, R12+8(%rsp)
+	movq %r13, R13+8(%rsp)
+	movq %r14, R14+8(%rsp)
+	movq %r15, R15+8(%rsp)
 	xorl %ebx,%ebx
 	testl $3,CS+8(%rsp)
 	je error_kernelspace
@@ -1427,6 +1426,7 @@ error_sti:
  * compat mode. Check for these here too.
  */
 error_kernelspace:
+	CFI_REL_OFFSET rcx, RCX+8
 	incl %ebx
 	leaq irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)



