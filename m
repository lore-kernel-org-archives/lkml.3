Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbbAOL5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:57:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38550 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbAOL5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:57:36 -0500
Message-ID: <54B7AB29.20209@hitachi.com>
Date: Thu, 15 Jan 2015 20:57:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ftrace/jprobes/x86: Fix conflict between jprobes
 and function graph tracing
References: <20150114153958.931152836@goodmis.org> <20150114154329.552437962@goodmis.org>
In-Reply-To: <20150114154329.552437962@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for fixing this bug!

(2015/01/15 0:40), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> If the function graph tracer traces a jprobe callback, the system will
> crash. This can easily be demonstrated by compiling the jprobe
> sample module that is in the kernel tree, loading it and running the
> function graph tracer.
> 
>  # modprobe jprobe_example.ko
>  # echo function_graph > /sys/kernel/debug/tracing/current_tracer
>  # ls
> 
> The first two commands end up in a nice crash after the first fork.
> (do_fork has a jprobe attached to it, so "ls" just triggers that fork)
> 
> The problem is caused by the jprobe_return() that all jprobe callbacks
> must end with. The way jprobes works is that the function a jprobe
> is attached to has a breakpoint placed at the start of it (or it uses
> ftrace if fentry is supported). The breakpoint handler (or ftrace callback)
> will copy the stack frame and change the ip address to return to the
> jprobe handler instead of the function. The jprobe handler must end
> with jprobe_return() which swaps the stack and does an int3 (breakpoint).
> This breakpoint handler will then put back the saved stack frame,
> simulate the instruction at the beginning of the function it added
> a breakpoint to, and then continue on.
> 
> For function tracing to work, it hijakes the return address from the
> stack frame, and replaces it with a hook function that will trace
> the end of the call. This hook function will restore the return
> address of the function call.

Yeah, function-graph tracer makes a hidden return-address stack for
each thread for storing the return address.

> If the function tracer traces the jprobe handler, the hook function
> for that handler will not be called, and its saved return address
> will be used for the next function. This will result in a kernel crash.

Actually, both jprobe (user-defined) handler and jprobe_return() doesn't
execute "ret".
So, right after run out the jprobe handler with function-graph tracer,
on the top of its hidden stack, there are at least 2(*) unused return
addresses, one is for jprobe handler (this should be same as the probed
function's return address) and other is jprobe_return()'s return address.
(*: this can be more than 2 if jprobe_return is called from a function
 which is called from jprobe handler)

So, the hidden stack may be as below;

[jprobe_return() return address]
[probed function return address]
[probed function return address]

After jumping back to the probed function, the function return is
trapped by the function-graph tracer, and it uses jprobe_return()'s
return address. Since usually jprobe_return() is called at the end of
the function, CPU will execute "ret" soon again(if someone puts a BUG
right after jprobe_return(), the kernel will show that BUG), and it
returns to the caller of the probed function.
However, there still be the probed function return address on the
hidden stack! This means that the next "ret" will go back to the same
address but with modified register and stacks.

> To solve this, pause function tracing before the jprobe handler is called
> and unpause it before it returns back to the function it probed.

Agreed, but it also could drop some NMI events. That is downside.

> Some other updates:
> 
> Used a variable "saved_sp" to hold kcb->jprobe_saved_sp. This makes the
> code look a bit cleaner and easier to understand (various tries to fix
> this bug required this change).

OK.

> Note, if fentry is being used, jprobes will change the ip address before
> the function graph tracer runs and it will not be able to trace the
> function that the jprobe is probing.

yes, it should be fixed.

BTW, my last part of IPMODIFY patches (which is not yet merged)
can solve this a different way. It sets IPMODIFY flag only to jprobe.
So, if function-graph tracer sets IPMODIFY flag, user can not enable
function-graph tracer when jprobe is used.

https://lkml.org/lkml/2014/10/9/210

Anyway, this patch is better to go stable trees.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> Cc: stable@vger.kernel.org # 2.6.30+
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/kprobes/core.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index f7e3cd50ece0..98f654d466e5 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -1020,6 +1020,15 @@ int setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
>  	regs->flags &= ~X86_EFLAGS_IF;
>  	trace_hardirqs_off();
>  	regs->ip = (unsigned long)(jp->entry);
> +
> +	/*
> +	 * jprobes use jprobe_return() which skips the normal return
> +	 * path of the function, and this messes up the accounting of the
> +	 * function graph tracer to get messed up.
> +	 *
> +	 * Pause function graph tracing while performing the jprobe function.
> +	 */
> +	pause_graph_tracing();
>  	return 1;
>  }
>  NOKPROBE_SYMBOL(setjmp_pre_handler);
> @@ -1048,24 +1057,25 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
>  	u8 *addr = (u8 *) (regs->ip - 1);
>  	struct jprobe *jp = container_of(p, struct jprobe, kp);
> +	void *saved_sp = kcb->jprobe_saved_sp;
>  
>  	if ((addr > (u8 *) jprobe_return) &&
>  	    (addr < (u8 *) jprobe_return_end)) {
> -		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
> +		if (stack_addr(regs) != saved_sp) {
>  			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
>  			printk(KERN_ERR
>  			       "current sp %p does not match saved sp %p\n",
> -			       stack_addr(regs), kcb->jprobe_saved_sp);
> +			       stack_addr(regs), saved_sp);
>  			printk(KERN_ERR "Saved registers for jprobe %p\n", jp);
>  			show_regs(saved_regs);
>  			printk(KERN_ERR "Current registers\n");
>  			show_regs(regs);
>  			BUG();
>  		}
> +		/* It's OK to start function graph tracing again */
> +		unpause_graph_tracing();
>  		*regs = kcb->jprobe_saved_regs;
> -		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
> -		       kcb->jprobes_stack,
> -		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
> +		memcpy(saved_sp, kcb->jprobes_stack, MIN_STACK_SIZE(saved_sp));
>  		preempt_enable_no_resched();
>  		return 1;
>  	}
> -- 2.1.4
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


