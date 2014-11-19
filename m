Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbaKSXc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:32:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:44218 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754452AbaKSX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:12 -0500
Message-Id: <20141119232709.587971857@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 02/18] ftrace/x86: Add frames pointers to trampoline as necessary
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftrace-x86-Add-frames-pointers-to-trampoline-as-nece.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When CONFIG_FRAME_POINTERS are enabled, it is required that the
ftrace_caller and ftrace_regs_caller trampolines set up frame pointers
otherwise a stack trace from a function call wont print the functions
that called the trampoline. This is due to a check in
__save_stack_address():

 #ifdef CONFIG_FRAME_POINTER
	if (!reliable)
		return;
 #endif

The "reliable" variable is only set if the function address is equal to
contents of the address before the address the frame pointer register
points to. If the frame pointer is not set up for the ftrace caller
then this will fail the reliable test. It will miss the function that
called the trampoline. Worse yet, if fentry is used (gcc 4.6 and
beyond), it will also miss the parent, as the fentry is called before
the stack frame is set up. That means the bp frame pointer points
to the stack of just before the parent function was called.

Link: http://lkml.kernel.org/r/20141119034829.355440340@goodmis.org

Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org # 3.7+
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 42f0cdd20baf..35a793fa4bba 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -47,14 +47,51 @@ GLOBAL(\trace_label)
 #endif
 .endm
 
+#ifdef CONFIG_FRAME_POINTER
+/*
+ * Stack traces will stop at the ftrace trampoline if the frame pointer
+ * is not set up properly. If fentry is used, we need to save a frame
+ * pointer for the parent as well as the function traced, because the
+ * fentry is called before the stack frame is set up, where as mcount
+ * is called afterward.
+ */
+.macro create_frame parent rip
+#ifdef CC_USING_FENTRY
+	pushq \parent
+	pushq %rbp
+	movq %rsp, %rbp
+#endif
+	pushq \rip
+	pushq %rbp
+	movq %rsp, %rbp
+.endm
+
+.macro restore_frame
+#ifdef CC_USING_FENTRY
+	addq $16, %rsp
+#endif
+	popq %rbp
+	addq $8, %rsp
+.endm
+#else
+.macro create_frame parent rip
+.endm
+.macro restore_frame
+.endm
+#endif /* CONFIG_FRAME_POINTER */
+
 ENTRY(ftrace_caller)
 	ftrace_caller_setup ftrace_caller_op_ptr
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
+	create_frame %rsi, %rdi
+
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
+	restore_frame
+
 	MCOUNT_RESTORE_FRAME
 
 	/*
@@ -105,9 +142,13 @@ ENTRY(ftrace_regs_caller)
 	/* regs go into 4th parameter */
 	leaq (%rsp), %rcx
 
+	create_frame %rsi, %rdi
+
 GLOBAL(ftrace_regs_call)
 	call ftrace_stub
 
+	restore_frame
+
 	/* Copy flags back to SS, to restore them */
 	movq EFLAGS(%rsp), %rax
 	movq %rax, SS(%rsp)
-- 
2.1.1


