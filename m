Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764163AbbA2DXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:23:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbbA2Cfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 038/139] ftrace/x86: Add frames pointers to trampoline as necessary
Date: Wed, 28 Jan 2015 14:19:41 -0800
Message-Id: <1422483682-15393-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 9960efeb80f73bd073483dab0855ee0ddc27085c upstream.

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
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ kamal: backport to 3.13-stable: applied to entry_64.S; context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/entry_64.S | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 02553d6..3d47217 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -102,6 +102,39 @@ END(function_hook)
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
 	/* Check if tracing was disabled (quick check) */
 	cmpl $0, function_trace_stop
@@ -161,9 +194,13 @@ ENTRY(ftrace_regs_caller)
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
1.9.1

