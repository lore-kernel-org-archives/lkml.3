Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaKYCgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:36:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:58972 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750852AbaKYCgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:36:40 -0500
Date: Mon, 24 Nov 2014 21:36:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 0/7] ftrace/x86: Clean up of mcount.S code
Message-ID: <20141124213634.0613665d@gandalf.local.home>
In-Reply-To: <CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
References: <20141125004221.803122027@goodmis.org>
	<CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 17:34:04 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Nov 24, 2014 at 4:42 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Let me know if these changes have mcount.S give you less heebie-jeebies.
> 
> So I haven't looked at the individual patches, I just looked at the
> rolled-up final patch in this email.
> 
> And yes, from that final patch, I certainly like this much more. At
> least it now creates the frame in the obvious place, and the comments
> explain the layout.
> 
> However, explain this (in the ftrace_caller_setup macro):
> 
>  #ifdef CC_USING_FENTRY
> -       movq SS+16(%rsp), %rsi
> +       movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
>  #else
> -       movq 8(%rbp), %rsi
> +       /* Need to grab the original %rbp */
> +       movq RBP(%rsp), %rsi
> +       /* Now parent address is 8 above original %rbp */
> +       movq 8(%rsi), %rsi
>  #endif
> 
> Why isn't that "follow rbp" approach now *always* the right thing to
> do, regardless of fentry-vs-not? And in particular, couldn't you have
> made '%rsi' already contain that old rbp address in save_mcount_regs,
> the same way %rdi contains the RIP value?

Testing my code and watching it crash and burn, I remember why I did it
this way. When using "mcount", frame pointers are always compiled in,
when "fentry" is used, they may or may not be. That is, %rbp is
meaningless.

We have three scenarios:

1) mcount (and frame pointers)
2) fentry (and frame pointers)
3) fentry (and no frame pointers)

The functions that are traced look like this:

1)
	func:
		push %rbp
		mov  %rsp, %rbp
		[ set up the rest of the frame ]
		call mcount

	That is, the call to the mcount trampoline is done where the
	only way to get to the parent is by "8(%rbp)".

2)
	func:
		call fentry
		push %rbp
		mov  %rsp, %rbp

	Here, when the fentry trampoline is called, it contains the
	return address of fentry (func:) and before that, the return
	address of func itself (parent). %rbp holds the parent's frame
	pointer. The only way to get to the parent is 8(%rsp) where
	0(%rsp) is the return back to func.

3)
	func:
		call fentry
		[ do whatever ]

	This is the same as 2) but this time %rbp is meaning less.
	And again, we need to get the parent with 8(%rsp).

But we can still have save_mcount_regs do all the work. Something like
this:


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


-- Steve
