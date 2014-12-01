Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaLATYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:24:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26412 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753822AbaLATXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:10 -0500
Message-Id: <20141201192307.522306687@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 6/9] ftrace/x86: Add macro MCOUNT_REG_SIZE for amount of stack used to
 save mcount regs
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-ftrace-x86-Add-macro-MCOUNT_REG_SIZE-for-amount-of-s.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The macro save_mcount_regs saves regs onto the stack. But to uncouple the
amount of stack used in that macro from the users of the macro, we need
to have a define that tells all the users how much stack is used by that
macro. This way we can change the amount of stack the macro uses without
breaking its users.

Also remove some dead code that was left over from commit fdc841b58cf5
"ftrace: x86: Remove check of obsolete variable function_trace_stop".

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 596ac330c1db..a0f6f942183a 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,6 +21,9 @@
 # define function_hook	mcount
 #endif
 
+/* Size of stack used to save mcount regs in save_mcount_regs */
+#define MCOUNT_REG_SIZE		(SS+8)
+
 /*
  * gcc -pg option adds a call to 'mcount' in most functions.
  * When -mfentry is used, the call is to 'fentry' and not 'mcount'
@@ -42,7 +45,7 @@
 	 /*
 	  * We add enough stack to save all regs.
 	  */
-	subq $(SS+8), %rsp
+	subq $MCOUNT_REG_SIZE, %rsp
 	movq %rax, RAX(%rsp)
 	movq %rcx, RCX(%rsp)
 	movq %rdx, RDX(%rsp)
@@ -51,7 +54,7 @@
 	movq %r8, R8(%rsp)
 	movq %r9, R9(%rsp)
 	 /* Move RIP to its proper location */
-	movq SS+8+\added(%rsp), %rdi
+	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
 	movq %rdi, RIP(%rsp)
 	.endm
 
@@ -63,7 +66,7 @@
 	movq RDX(%rsp), %rdx
 	movq RCX(%rsp), %rcx
 	movq RAX(%rsp), %rax
-	addq $(SS+8), %rsp
+	addq $MCOUNT_REG_SIZE, %rsp
 	.endm
 
 /* skip is set if stack has been adjusted */
@@ -79,7 +82,7 @@ GLOBAL(\trace_label)
 	subq $MCOUNT_INSN_SIZE, %rdi
 	/* Load the parent_ip into the second parameter */
 #ifdef CC_USING_FENTRY
-	movq SS+16+\added(%rsp), %rsi
+	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
 #else
 	movq 8+\added(%rbp), %rsi
 #endif
@@ -172,7 +175,7 @@ ENTRY(ftrace_regs_caller)
 	movq %rbp, RBP(%rsp)
 	movq %rbx, RBX(%rsp)
 	/* Copy saved flags */
-	movq SS+8(%rsp), %rcx
+	movq MCOUNT_REG_SIZE(%rsp), %rcx
 	movq %rcx, EFLAGS(%rsp)
 	/* Kernel segments */
 	movq $__KERNEL_DS, %rcx
@@ -180,7 +183,7 @@ ENTRY(ftrace_regs_caller)
 	movq $__KERNEL_CS, %rcx
 	movq %rcx, CS(%rsp)
 	/* Stack - skipping return address and flags */
-	leaq SS+8*3(%rsp), %rcx
+	leaq MCOUNT_REG_SIZE+8*2(%rsp), %rcx
 	movq %rcx, RSP(%rsp)
 
 	/* regs go into 4th parameter */
@@ -195,11 +198,11 @@ GLOBAL(ftrace_regs_call)
 
 	/* Copy flags back to SS, to restore them */
 	movq EFLAGS(%rsp), %rax
-	movq %rax, SS+8(%rsp)
+	movq %rax, MCOUNT_REG_SIZE(%rsp)
 
 	/* Handlers can change the RIP */
 	movq RIP(%rsp), %rax
-	movq %rax, SS+8*2(%rsp)
+	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
 
 	/* restore the rest of pt_regs */
 	movq R15(%rsp), %r15
@@ -225,9 +228,6 @@ GLOBAL(ftrace_regs_caller_end)
 
 	jmp ftrace_return
 
-	popfq
-	jmp  ftrace_stub
-
 END(ftrace_regs_caller)
 
 
@@ -266,7 +266,7 @@ ENTRY(ftrace_graph_caller)
 	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
-	leaq SS+16(%rsp), %rdi
+	leaq MCOUNT_REG_SIZE+8(%rsp), %rdi
 	movq $0, %rdx	/* No framepointers needed */
 #else
 	leaq 8(%rbp), %rdi
-- 
2.1.3


