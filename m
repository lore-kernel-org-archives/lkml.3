Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3AYQeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:34:15 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60014 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3AYQeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:34:11 -0500
Date: Fri, 25 Jan 2013 16:26:08 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
Message-ID: <20130125162608.GD2069@linaro.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-20-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359123276-15833-20-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 02:14:36PM +0000, Arnd Bergmann wrote:
> From: sahara <keun-o.park@windriver.com>
> 
> This is a reminder that we still need to fix the return_address
> function to work correctly with the unwinder. Keun-O Park has
> made this attempt in the past, which is still under discussion[1],
> and Dave Martin has also mentioned that he would provide a
> solution for this problem.
> 
> Right now, this patch makes the warning go away and provides
> an implementation of return_address for the arm unwinder, but
> causes other problems, so we should *not* apply it. I will
> keep sending this patch until we have a better solution.
> 
> [1] http://lkml.org/lkml/2013/1/11/493
> 
> Original changelog:
> 
> This fixes a warning saying:
> 
>     warning: #warning "TODO: return_address should use unwind tables"
> 
> And, this enables return_address using unwind information. If ARM_UNWIND is
> selected, unwind_frame in unwind.c will be called in walk_stackframe.

I did have a brief look at this a few months back, but ran out of ideas
for a quick fix.  The unwinder implementation is too complex to just
rip out all the calls to traced common code without a significant rewrite.

One possibility would be to make unwind_frame check a flag (either a percpu
flag, or more likely a thread flag if unwind_frame can be called in
preemptible context -- I can't see why not) to prevent it self-recursing.
If self-recursion occurs through the ftrace code, unwind_frame would
just return an error instead of going into a self-recursion loop.

This would still mean that traced functions could get called from inside
return_address() once before recursion is quenched.  If this would break
ftrace, I'm not sure how to fix it.

However, if the purpose if making return_address() notrace is just to
prevent infinite recursion, where finite recursion is safe, then it
feels fixable as described above.

Steven, do you know whether such an approach might be safe?

Cheers
---Dave

> 
> Signed-off-by: sahara <keun-o.park@windriver.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Dave Martin <dave.martin@linaro.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> ---
>  arch/arm/include/asm/ftrace.h    |  6 ++----
>  arch/arm/kernel/Makefile         | 12 +++++-------
>  arch/arm/kernel/return_address.c | 10 +++-------
>  arch/arm/kernel/stacktrace.c     |  3 +++
>  kernel/trace/trace_irqsoff.c     | 26 ++++++++++++--------------
>  5 files changed, 25 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index f89515a..3552ad9 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -32,13 +32,11 @@ extern void ftrace_call_old(void);
>  
>  #ifndef __ASSEMBLY__
>  
> -#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
> +#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
>  /*
>   * return_address uses walk_stackframe to do it's work.  If both
>   * CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses unwind
> - * information.  For this to work in the function tracer many functions would
> - * have to be marked with __notrace.  So for now just depend on
> - * !CONFIG_ARM_UNWIND.
> + * information.
>   */
>  
>  void *return_address(unsigned int);
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 5bbec7b..09a0d64 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -5,13 +5,11 @@
>  CPPFLAGS_vmlinux.lds := -DTEXT_OFFSET=$(TEXT_OFFSET)
>  AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
>  
> -ifdef CONFIG_FUNCTION_TRACER
> -CFLAGS_REMOVE_ftrace.o = -pg
> -CFLAGS_REMOVE_insn.o = -pg
> -CFLAGS_REMOVE_patch.o = -pg
> -endif
> -
> -CFLAGS_REMOVE_return_address.o = -pg
> +CFLAGS_REMOVE_ftrace.o		= -pg
> +CFLAGS_REMOVE_insn.o		= -pg
> +CFLAGS_REMOVE_patch.o		= -pg
> +CFLAGS_REMOVE_unwind.o		= -pg
> +CFLAGS_REMOVE_return_address.o	= -pg
>  
>  # Object file lists.
>  
> diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
> index 8085417..ccb5e37 100644
> --- a/arch/arm/kernel/return_address.c
> +++ b/arch/arm/kernel/return_address.c
> @@ -11,7 +11,7 @@
>  #include <linux/export.h>
>  #include <linux/ftrace.h>
>  
> -#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
> +#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
>  #include <linux/sched.h>
>  
>  #include <asm/stacktrace.h>
> @@ -56,17 +56,13 @@ void *return_address(unsigned int level)
>  		return NULL;
>  }
>  
> -#else /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
> -
> -#if defined(CONFIG_ARM_UNWIND)
> -#warning "TODO: return_address should use unwind tables"
> -#endif
> +#else /* CONFIG_FRAME_POINTER || CONFIG_ARM_UNWIND */
>  
>  void *return_address(unsigned int level)
>  {
>  	return NULL;
>  }
>  
> -#endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) / else */
> +#endif /* CONFIG_FRAME_POINTER || CONFIG_ARM_UNWIND */
>  
>  EXPORT_SYMBOL_GPL(return_address);
> diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
> index 00f79e5..aab144b 100644
> --- a/arch/arm/kernel/stacktrace.c
> +++ b/arch/arm/kernel/stacktrace.c
> @@ -6,6 +6,9 @@
>  
>  #if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
>  /*
> + * If both CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses
> + * unwind information. So for now just depend on !CONFIG_ARM_UNWIND.
> + *
>   * Unwind the current stack frame and store the new register values in the
>   * structure passed as argument. Unwinding is equivalent to a function return,
>   * hence the new PC value rather than LR should be used for backtrace.
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 713a2ca..6f207ed 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -483,20 +483,6 @@ inline void print_irqtrace_events(struct task_struct *curr)
>  /*
>   * We are only interested in hardirq on/off events:
>   */
> -void trace_hardirqs_on(void)
> -{
> -	if (!preempt_trace() && irq_trace())
> -		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
> -}
> -EXPORT_SYMBOL(trace_hardirqs_on);
> -
> -void trace_hardirqs_off(void)
> -{
> -	if (!preempt_trace() && irq_trace())
> -		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
> -}
> -EXPORT_SYMBOL(trace_hardirqs_off);
> -
>  void trace_hardirqs_on_caller(unsigned long caller_addr)
>  {
>  	if (!preempt_trace() && irq_trace())
> @@ -504,6 +490,12 @@ void trace_hardirqs_on_caller(unsigned long caller_addr)
>  }
>  EXPORT_SYMBOL(trace_hardirqs_on_caller);
>  
> +void trace_hardirqs_on(void)
> +{
> +	trace_hardirqs_on_caller(CALLER_ADDR0);
> +}
> +EXPORT_SYMBOL(trace_hardirqs_on);
> +
>  void trace_hardirqs_off_caller(unsigned long caller_addr)
>  {
>  	if (!preempt_trace() && irq_trace())
> @@ -511,6 +503,12 @@ void trace_hardirqs_off_caller(unsigned long caller_addr)
>  }
>  EXPORT_SYMBOL(trace_hardirqs_off_caller);
>  
> +void trace_hardirqs_off(void)
> +{
> +	trace_hardirqs_off_caller(CALLER_ADDR0);
> +}
> +EXPORT_SYMBOL(trace_hardirqs_off);
> +
>  #endif /* CONFIG_PROVE_LOCKING */
>  #endif /*  CONFIG_IRQSOFF_TRACER */
>  
> -- 
> 1.8.0
> 
