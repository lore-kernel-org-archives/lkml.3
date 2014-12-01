Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaLATZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:25:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:18104 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753483AbaLATXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:09 -0500
Message-Id: <20141201192307.687605266@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [for-next][PATCH 7/9] ftrace/x86: Have save_mcount_regs macro also save stack frames if
 needed
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-ftrace-x86-Have-save_mcount_regs-macro-also-save-sta.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The save_mcount_regs macro saves and restores the required mcount regs that
need to be saved before calling C code. It is done for all the function hook
utilities (static tracing, dynamic tracing, regs, function graph).

When frame pointers are enabled, the ftrace trampolines need to set up
frames and pointers such that a back trace (dump stack) can continue passed
them. Currently, a separate macro is used (create_frame) to do this, but
it's only done for the ftrace_caller and ftrace_reg_caller functions. It
is not done for the static tracer or function graph tracing.

Instead of having a separate macro doing the recording of the frames,
have the save_mcount_regs perform this task. This also has all tracers
saving the frame pointers when needed.

Link: http://lkml.kernel.org/r/CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 118 +++++++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index a0f6f942183a..003b22df1d87 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,8 +21,22 @@
 # define function_hook	mcount
 #endif
 
+/* All cases save the original rbp (8 bytes) */
+#ifdef CONFIG_FRAME_POINTER
+# ifdef CC_USING_FENTRY
+/* Save parent and function stack frames (rip and rbp) */
+#  define MCOUNT_FRAME_SIZE	(8+16*2)
+# else
+/* Save just function stack frame (rip and rbp) */
+#  define MCOUNT_FRAME_SIZE	(8+16)
+# endif
+#else
+/* No need to save a stack frame */
+# define MCOUNT_FRAME_SIZE	8
+#endif /* CONFIG_FRAME_POINTER */
+
 /* Size of stack used to save mcount regs in save_mcount_regs */
-#define MCOUNT_REG_SIZE		(SS+8)
+#define MCOUNT_REG_SIZE		(SS+8 + MCOUNT_FRAME_SIZE)
 
 /*
  * gcc -pg option adds a call to 'mcount' in most functions.
@@ -42,10 +56,37 @@
 
 /* @added: the amount of stack added before calling this */
 .macro save_mcount_regs added=0
-	 /*
-	  * We add enough stack to save all regs.
-	  */
-	subq $MCOUNT_REG_SIZE, %rsp
+
+	/* Always save the original rbp */
+	pushq %rbp
+
+#ifdef CONFIG_FRAME_POINTER
+	/*
+	 * Stack traces will stop at the ftrace trampoline if the frame pointer
+	 * is not set up properly. If fentry is used, we need to save a frame
+	 * pointer for the parent as well as the function traced, because the
+	 * fentry is called before the stack frame is set up, where as mcount
+	 * is called afterward.
+	 */
+#ifdef CC_USING_FENTRY
+	/* Save the parent pointer (skip orig rbp and our return address) */
+	pushq \added+8*2(%rsp)
+	pushq %rbp
+	movq %rsp, %rbp
+	/* Save the return address (now skip orig rbp, rbp and parent) */
+	pushq \added+8*3(%rsp)
+#else
+	/* Can't assume that rip is before this (unless added was zero) */
+	pushq \added+8(%rsp)
+#endif
+	pushq %rbp
+	movq %rsp, %rbp
+#endif /* CONFIG_FRAME_POINTER */
+
+	/*
+	 * We add enough stack to save all regs.
+	 */
+	subq $(MCOUNT_REG_SIZE - MCOUNT_FRAME_SIZE), %rsp
 	movq %rax, RAX(%rsp)
 	movq %rcx, RCX(%rsp)
 	movq %rdx, RDX(%rsp)
@@ -53,6 +94,13 @@
 	movq %rdi, RDI(%rsp)
 	movq %r8, R8(%rsp)
 	movq %r9, R9(%rsp)
+	/*
+	 * Save the original RBP. Even though the mcount ABI does not
+	 * require this, it helps out callers.
+	 */
+	movq MCOUNT_REG_SIZE-8(%rsp), %rdx
+	movq %rdx, RBP(%rsp)
+
 	 /* Move RIP to its proper location */
 	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
 	movq %rdi, RIP(%rsp)
@@ -66,7 +114,12 @@
 	movq RDX(%rsp), %rdx
 	movq RCX(%rsp), %rcx
 	movq RAX(%rsp), %rax
+
+	/* ftrace_regs_caller can modify %rbp */
+	movq RBP(%rsp), %rbp
+
 	addq $MCOUNT_REG_SIZE, %rsp
+
 	.endm
 
 /* skip is set if stack has been adjusted */
@@ -84,7 +137,10 @@ GLOBAL(\trace_label)
 #ifdef CC_USING_FENTRY
 	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
 #else
-	movq 8+\added(%rbp), %rsi
+	/* Need to grab the original %rbp */
+	movq RBP(%rsp), %rsi
+	/* Now parent address is 8 above original %rbp */
+	movq 8(%rsi), %rsi
 #endif
 .endm
 
@@ -94,51 +150,14 @@ ENTRY(function_hook)
 	retq
 END(function_hook)
 
-#ifdef CONFIG_FRAME_POINTER
-/*
- * Stack traces will stop at the ftrace trampoline if the frame pointer
- * is not set up properly. If fentry is used, we need to save a frame
- * pointer for the parent as well as the function traced, because the
- * fentry is called before the stack frame is set up, where as mcount
- * is called afterward.
- */
-.macro create_frame parent rip
-#ifdef CC_USING_FENTRY
-	pushq \parent
-	pushq %rbp
-	movq %rsp, %rbp
-#endif
-	pushq \rip
-	pushq %rbp
-	movq %rsp, %rbp
-.endm
-
-.macro restore_frame
-#ifdef CC_USING_FENTRY
-	addq $16, %rsp
-#endif
-	popq %rbp
-	addq $8, %rsp
-.endm
-#else
-.macro create_frame parent rip
-.endm
-.macro restore_frame
-.endm
-#endif /* CONFIG_FRAME_POINTER */
-
 ENTRY(ftrace_caller)
 	ftrace_caller_setup ftrace_caller_op_ptr
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
-	create_frame %rsi, %rdi
-
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
-	restore_frame
-
 	restore_mcount_regs
 
 	/*
@@ -172,7 +191,6 @@ ENTRY(ftrace_regs_caller)
 	movq %r12, R12(%rsp)
 	movq %r11, R11(%rsp)
 	movq %r10, R10(%rsp)
-	movq %rbp, RBP(%rsp)
 	movq %rbx, RBX(%rsp)
 	/* Copy saved flags */
 	movq MCOUNT_REG_SIZE(%rsp), %rcx
@@ -189,13 +207,9 @@ ENTRY(ftrace_regs_caller)
 	/* regs go into 4th parameter */
 	leaq (%rsp), %rcx
 
-	create_frame %rsi, %rdi
-
 GLOBAL(ftrace_regs_call)
 	call ftrace_stub
 
-	restore_frame
-
 	/* Copy flags back to SS, to restore them */
 	movq EFLAGS(%rsp), %rax
 	movq %rax, MCOUNT_REG_SIZE(%rsp)
@@ -210,7 +224,6 @@ GLOBAL(ftrace_regs_call)
 	movq R13(%rsp), %r13
 	movq R12(%rsp), %r12
 	movq R10(%rsp), %r10
-	movq RBP(%rsp), %rbp
 	movq RBX(%rsp), %rbx
 
 	restore_mcount_regs
@@ -269,8 +282,11 @@ ENTRY(ftrace_graph_caller)
 	leaq MCOUNT_REG_SIZE+8(%rsp), %rdi
 	movq $0, %rdx	/* No framepointers needed */
 #else
-	leaq 8(%rbp), %rdi
-	movq (%rbp), %rdx
+	/* Need to grab the original %rbp */
+	movq RBP(%rsp), %rdx
+	/* Now parent address is 8 above original %rbp */
+	leaq 8(%rdx), %rdi
+	movq (%rdx), %rdx
 #endif
 	movq RIP(%rsp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rsi
-- 
2.1.3


