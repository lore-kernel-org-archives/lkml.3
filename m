Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaKYB5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:57:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:8914 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbaKYB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:57:05 -0500
Date: Mon, 24 Nov 2014 20:56:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 0/7] ftrace/x86: Clean up of mcount.S code
Message-ID: <20141124205656.514b4613@gandalf.local.home>
In-Reply-To: <CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
References: <20141125004221.803122027@goodmis.org>
	<CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
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
> 
> (Yes, you can only do that after you've saved the old %rsi, but that's
> easy enough to do by just delaying the second
> 
>     mov %rsp,%rbp
> 
> until after the save area, and replacing it with
> 
>     mov %rbp,%rsi
>     lea MCOUNT_REG_SIZE - MCOUNT_FRAME_SIZE(%rsp),%rbp
> 
> after the saving of the frame. And now you have that RBP(%rsp) in %rsi
> already, so regardless of whether you have CC_USING_FENTRY or not, the
> above code becomes just
> 
>     /* Now parent address is 8 above original %rbp */
>     movq 8(%rsi), %rsi
> 
> No?
> 
> Ok, so I didn't write it all out, and maybe I made some mistake while
> writing this email. but it *looks* like your ftrace_caller_setup macro
> is just unnecessarily complicated, and again, it's because you have
> two different macros and they aren't taking advantage of each other
> very well.
> 
> Hmm?
> 

Actually, I just wrote a patch to move the MCOUNT_INSN_SIZE update into
save_mcount_regs, and after reading this, I think something like this
may work.

Note, I didn't even compile test it. But this removes that
ftrace_caller_setup completely. (Written on top of this series).

I have to look to at how this affects function_graph tracing. But I'm
sure we can make that work too.

-- Steve

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 003b22df1d87..438747ca994f 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -101,9 +101,19 @@
 	movq MCOUNT_REG_SIZE-8(%rsp), %rdx
 	movq %rdx, RBP(%rsp)
 
+	/* Copy the parent address into %rsi (second parameter) */
+	movq 8(%rdx), %rsi
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
@@ -122,28 +132,6 @@
 
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
@@ -151,7 +139,13 @@ ENTRY(function_hook)
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
 
@@ -181,8 +175,12 @@ ENTRY(ftrace_regs_caller)
 	/* Save the current flags before any operations that can change them */
 	pushfq
 
-	/* added 8 bytes to save flags */
-	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs 8
+
+GLOBAL(ftrace_regs_caller_op_ptr)
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
 
 	/* Save the rest of pt_regs */
 	movq %r15, R15(%rsp)
@@ -263,7 +261,8 @@ GLOBAL(ftrace_stub)
 	retq
 
 trace:
-	ftrace_caller_setup ftrace_caller_op_ptr
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
 
 	call   *ftrace_trace_function
 

