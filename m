Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaLATXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:23:14 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45513 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753987AbaLATXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:10 -0500
Message-Id: <20141201192307.829949879@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [for-next][PATCH 8/9] ftrace/x86: Get rid of ftrace_caller_setup
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-ftrace-x86-Get-rid-of-ftrace_caller_setup.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Move all the work from ftrace_caller_setup into save_mcount_regs. This
simplifies the code and makes it easier to understand.

Link: http://lkml.kernel.org/r/CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 71 +++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 003b22df1d87..ddc766efa1f1 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -54,7 +54,15 @@
  * be saved in the locations that pt_regs has them in.
  */
 
-/* @added: the amount of stack added before calling this */
+/*
+ * @added: the amount of stack added before calling this
+ *
+ * After this is called, the following registers contain:
+ *
+ *  %rdi - holds the address that called the trampoline
+ *  %rsi - holds the parent function (traced function's return address)
+ *  %rdx - holds the original %rbp
+ */
 .macro save_mcount_regs added=0
 
 	/* Always save the original rbp */
@@ -101,9 +109,24 @@
 	movq MCOUNT_REG_SIZE-8(%rsp), %rdx
 	movq %rdx, RBP(%rsp)
 
+	/* Copy the parent address into %rsi (second parameter) */
+#ifdef CC_USING_FENTRY
+	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
+#else
+	/* %rdx contains original %rbp */
+	movq 8(%rdx), %rsi
+#endif
+
 	 /* Move RIP to its proper location */
 	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
 	movq %rdi, RIP(%rsp)
+
+	/*
+	 * Now %rdi (the first parameter) has the return address of
+	 * where ftrace_call returns. But the callbacks expect the
+	 * the address of the call itself.
+	 */
+	subq $MCOUNT_INSN_SIZE, %rdi
 	.endm
 
 .macro restore_mcount_regs
@@ -122,28 +145,6 @@
 
 	.endm
 
-/* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup trace_label added=0
-	save_mcount_regs \added
-
-	/* Save this location */
-GLOBAL(\trace_label)
-	/* Load the ftrace_ops into the 3rd parameter */
-	movq function_trace_op(%rip), %rdx
-
-	/* %rdi already has %rip from the save_mcount_regs macro */
-	subq $MCOUNT_INSN_SIZE, %rdi
-	/* Load the parent_ip into the second parameter */
-#ifdef CC_USING_FENTRY
-	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
-#else
-	/* Need to grab the original %rbp */
-	movq RBP(%rsp), %rsi
-	/* Now parent address is 8 above original %rbp */
-	movq 8(%rsi), %rsi
-#endif
-.endm
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 ENTRY(function_hook)
@@ -151,7 +152,13 @@ ENTRY(function_hook)
 END(function_hook)
 
 ENTRY(ftrace_caller)
-	ftrace_caller_setup ftrace_caller_op_ptr
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
+
+GLOBAL(ftrace_caller_op_ptr)
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
+
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
@@ -182,7 +189,12 @@ ENTRY(ftrace_regs_caller)
 	pushfq
 
 	/* added 8 bytes to save flags */
-	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
+	save_mcount_regs 8
+	/* save_mcount_regs fills in first two parameters */
+
+GLOBAL(ftrace_regs_caller_op_ptr)
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
 
 	/* Save the rest of pt_regs */
 	movq %r15, R15(%rsp)
@@ -263,7 +275,8 @@ GLOBAL(ftrace_stub)
 	retq
 
 trace:
-	ftrace_caller_setup ftrace_caller_op_ptr
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
 
 	call   *ftrace_trace_function
 
@@ -276,16 +289,16 @@ END(function_hook)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
+	/* Saves rbp into %rdx */
 	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
 	leaq MCOUNT_REG_SIZE+8(%rsp), %rdi
 	movq $0, %rdx	/* No framepointers needed */
 #else
-	/* Need to grab the original %rbp */
-	movq RBP(%rsp), %rdx
-	/* Now parent address is 8 above original %rbp */
+	/* Save address of the return address of traced function */
 	leaq 8(%rdx), %rdi
+	/* ftrace does sanity checks against frame pointers */
 	movq (%rdx), %rdx
 #endif
 	movq RIP(%rsp), %rsi
-- 
2.1.3


