Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaKSS04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:26:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:46843 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaKSS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:26:55 -0500
Date: Wed, 19 Nov 2014 19:26:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 1/2] ftrace/x86: Add frames pointers to trampoline as
 necessary
In-Reply-To: <20141119034829.355440340@goodmis.org>
Message-ID: <alpine.DEB.2.11.1411191926150.3909@nanos>
References: <20141119033331.689278545@goodmis.org> <20141119034829.355440340@goodmis.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When CONFIG_FRAME_POINTERS are enabled, it is required that the
> ftrace_caller and ftrace_regs_caller trampolines set up frame pointers
> otherwise a stack trace from a function call wont print the functions
> that called the trampoline. This is due to a check in
> __save_stack_address():
> 
>  #ifdef CONFIG_FRAME_POINTER
> 	if (!reliable)
> 		return;
>  #endif
> 
> The "reliable" variable is only set if the function address is equal to
> contents of the address before the address the frame pointer register
> points to. If the frame pointer is not set up for the ftrace caller
> then this will fail the reliable test. It will miss the function that
> called the trampoline. Worse yet, if fentry is used (gcc 4.6 and
> beyond), it will also miss the parent, as the fentry is called before
> the stack frame is set up. That means the bp frame pointer points
> to the stack of just before the parent function was called.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Shouldn't this be tagged stable?

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/x86/kernel/mcount_64.S | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
> index 42f0cdd20baf..35a793fa4bba 100644
> --- a/arch/x86/kernel/mcount_64.S
> +++ b/arch/x86/kernel/mcount_64.S
> @@ -47,14 +47,51 @@ GLOBAL(\trace_label)
>  #endif
>  .endm
>  
> +#ifdef CONFIG_FRAME_POINTER
> +/*
> + * Stack traces will stop at the ftrace trampoline if the frame pointer
> + * is not set up properly. If fentry is used, we need to save a frame
> + * pointer for the parent as well as the function traced, because the
> + * fentry is called before the stack frame is set up, where as mcount
> + * is called afterward.
> + */
> +.macro create_frame parent rip
> +#ifdef CC_USING_FENTRY
> +	pushq \parent
> +	pushq %rbp
> +	movq %rsp, %rbp
> +#endif
> +	pushq \rip
> +	pushq %rbp
> +	movq %rsp, %rbp
> +.endm
> +
> +.macro restore_frame
> +#ifdef CC_USING_FENTRY
> +	addq $16, %rsp
> +#endif
> +	popq %rbp
> +	addq $8, %rsp
> +.endm
> +#else
> +.macro create_frame parent rip
> +.endm
> +.macro restore_frame
> +.endm
> +#endif /* CONFIG_FRAME_POINTER */
> +
>  ENTRY(ftrace_caller)
>  	ftrace_caller_setup ftrace_caller_op_ptr
>  	/* regs go into 4th parameter (but make it NULL) */
>  	movq $0, %rcx
>  
> +	create_frame %rsi, %rdi
> +
>  GLOBAL(ftrace_call)
>  	call ftrace_stub
>  
> +	restore_frame
> +
>  	MCOUNT_RESTORE_FRAME
>  
>  	/*
> @@ -105,9 +142,13 @@ ENTRY(ftrace_regs_caller)
>  	/* regs go into 4th parameter */
>  	leaq (%rsp), %rcx
>  
> +	create_frame %rsi, %rdi
> +
>  GLOBAL(ftrace_regs_call)
>  	call ftrace_stub
>  
> +	restore_frame
> +
>  	/* Copy flags back to SS, to restore them */
>  	movq EFLAGS(%rsp), %rax
>  	movq %rax, SS(%rsp)
> -- 
> 2.1.1
> 
> 
> 
