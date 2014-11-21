Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbaKUOu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:50:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:60768 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758417AbaKUOuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:50:54 -0500
Date: Fri, 21 Nov 2014 09:50:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [GIT PULL] ftrace/x86: Add frames pointers to trampoline as
 necessary
Message-ID: <20141121095037.2f5a4d4f@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

While testing function triggers, I noticed that the stack trace trigger
for functions was missing the function that caused the trigger as
well as the parent function that called the triggered function. I use
this feature a lot and never noticed this before. Then I realized that
the difference was that I had CONFIG_FRAME_POINTERS enabled, which I
don't on the production machines I'm debugging.

When frame pointers are enabled, the stack trace code will ignore anything
that isn't found via the frame pointer. As the function trace trampoline
does not set up frame pointers, it is skipped. When fentry is used,
(gcc -pg --mfentry) it is called before the function stack frame is set
up, thus we also lose the parent pointer. These are quite useful for
debugging live kernels.

This goes back to 3.7 where the stacktrace trigger was introduced.
Before that, the function stack trace option had this issue, but since
it was before fentry was introduced, it only lost the traced function.
But that wasn't an issue as the option required the function itself
to be traced, and that showed the missing function.

This is cherry-picked from my 3.19 queue. After some thought, I figured
it should go into 3.18 and stable.

Please pull the latest trace-fixes-v3.18-rc5 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.18-rc5

Tag SHA1: 7c58faf742b3dba437a84f40e994ac490cdad86a
Head SHA1: ec86b2aedbcb69ea4f8eae0d5e1af9321810b2f8


Steven Rostedt (Red Hat) (1):
      ftrace/x86: Add frames pointers to trampoline as necessary

----
 arch/x86/kernel/mcount_64.S | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
---------------------------
commit ec86b2aedbcb69ea4f8eae0d5e1af9321810b2f8
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Tue Nov 18 19:13:25 2014 -0500

    ftrace/x86: Add frames pointers to trampoline as necessary
    
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

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index c73aecf10d34..d23132a9ef1c 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -45,14 +45,51 @@ END(function_hook)
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
 	ftrace_caller_setup
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
+	create_frame %rsi, %rdi
+
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
+	restore_frame
+
 	MCOUNT_RESTORE_FRAME
 ftrace_return:
 
@@ -96,9 +133,13 @@ ENTRY(ftrace_regs_caller)
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
