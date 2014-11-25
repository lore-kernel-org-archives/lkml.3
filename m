Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaKYLvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:51:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:60765 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754520AbaKYLve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:51:34 -0500
Message-Id: <20141125115129.578941565@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 25 Nov 2014 06:50:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH 3/9 v2] ftrace/x86: Rename MCOUNT_SAVE_FRAME and add more detailed comments
References: <20141125115003.856641273@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftrace-x86-Rename-MCOUNT_SAVE_FRAME-and-add-more-det.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The name MCOUNT_SAVE_FRAME is rather confusing as it really isn't a
function frame that is saved, but just the required mcount registers
that are needed to be saved before C code may be called. The word
"frame" confuses it as being a function frame which it is not.

Rename MCOUNT_SAVE_FRAME and MCOUNT_RESTORE_FRAME to save_mcount_regs
and restore_mcount_regs respectively. Noticed the lower case, which
keeps it from screaming at the reviewers.

Link: http://lkml.kernel.org/r/CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 94fe46725fe0..0a693d011980 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,8 +21,24 @@
 # define function_hook	mcount
 #endif
 
+/*
+ * gcc -pg option adds a call to 'mcount' in most functions.
+ * When -mfentry is used, the call is to 'fentry' and not 'mcount'
+ * and is done before the function's stack frame is set up.
+ * They both require a set of regs to be saved before calling
+ * any C code and restored before returning back to the function.
+ *
+ * On boot up, all these calls are converted into nops. When tracing
+ * is enabled, the call can jump to either ftrace_caller or
+ * ftrace_regs_caller. Callbacks (tracing functions) that require
+ * ftrace_regs_caller (like kprobes) need to have pt_regs passed to
+ * it. For this reason, the size of the pt_regs structure will be
+ * allocated on the stack and the required mcount registers will
+ * be saved in the locations that pt_regs has them in.
+ */
+
 /* skip is set if the stack was already partially adjusted */
-.macro MCOUNT_SAVE_FRAME skip=0
+.macro save_mcount_regs skip=0
 	 /*
 	  * We add enough stack to save all regs.
 	  */
@@ -39,7 +55,7 @@
 	movq %rdx, RIP(%rsp)
 	.endm
 
-.macro MCOUNT_RESTORE_FRAME skip=0
+.macro restore_mcount_regs skip=0
 	movq R9(%rsp), %r9
 	movq R8(%rsp), %r8
 	movq RDI(%rsp), %rdi
@@ -52,7 +68,7 @@
 
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup trace_label skip=0
-	MCOUNT_SAVE_FRAME \skip
+	save_mcount_regs \skip
 
 	/* Save this location */
 GLOBAL(\trace_label)
@@ -121,7 +137,7 @@ GLOBAL(ftrace_call)
 
 	restore_frame
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	/*
 	 * The copied trampoline must call ftrace_return as it
@@ -196,7 +212,7 @@ GLOBAL(ftrace_regs_call)
 	movq RBX(%rsp), %rbx
 
 	/* skip=8 to skip flags saved in SS */
-	MCOUNT_RESTORE_FRAME 8
+	restore_mcount_regs 8
 
 	/* Restore flags */
 	popfq
@@ -240,7 +256,7 @@ trace:
 
 	call   *ftrace_trace_function
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	jmp fgraph_trace
 END(function_hook)
@@ -249,7 +265,7 @@ END(function_hook)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	MCOUNT_SAVE_FRAME
+	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
 	leaq SS+16(%rsp), %rdi
@@ -263,7 +279,7 @@ ENTRY(ftrace_graph_caller)
 
 	call	prepare_ftrace_return
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	retq
 END(ftrace_graph_caller)
-- 
2.1.1


