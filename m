Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3AKWET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:04:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab3AKWES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:04:18 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HQJ7cb7SADkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MBbGe7VapwAA:10 a=krGNe3JXxW3P9hHRluIA:9 a=PUjeQqilurYA:10 a=ufnQq11pkNcivdJh:21 a=SCkeDSWjtdFfYRlk:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357941855.5141.43.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Keun-O Park <kpark3469@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, fweisbec@gmail.com,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sahara <keun-o.park@windriver.com>
Date: Fri, 11 Jan 2013 17:04:15 -0500
In-Reply-To: <CA+KhAHbOu8JxMuwajZYBAkex7pZag3oaTvz=EoLOQz5iZtUfsQ@mail.gmail.com>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	 <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	 <20130103103815.GL2631@n2100.arm.linux.org.uk>
	 <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
	 <1357220165.10284.30.camel@gandalf.local.home>
	 <20130103141301.GQ2631@n2100.arm.linux.org.uk>
	 <1357229038.10284.46.camel@gandalf.local.home>
	 <20130103162359.GR2631@n2100.arm.linux.org.uk>
	 <1357232337.10284.67.camel@gandalf.local.home>
	 <CA+KhAHYbDU0Ajr5uPEjPxX2ECitvnK2ENOjmqjC=3G657GvG7w@mail.gmail.com>
	 <1357566094.10284.83.camel@gandalf.local.home>
	 <CA+KhAHbOu8JxMuwajZYBAkex7pZag3oaTvz=EoLOQz5iZtUfsQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 17:53 +0900, Keun-O Park wrote:

> Hello Steve,
> 
> Much obliged for your explaining this.
> As your guess, there's another path that uses CALLER_ADDR1 without
> CONFIG_PROVE_LOCKING though both lockdep and ftrace's irqsoff tracer
> is turned on. In this case, ftrace's trace_hardirqs_on/off() would be
> called.
> And, as you said to me, if lockdep is off and ftrace's irqsoff is on,
> ftrace's trace_hardirqs_on/off() would be called.
> I think the proper way to avoid calling CALLER_ADDR1 will be calling
> trace_hardirqs_off_caller() instead of calling stop_critical_timing()
> directly in trace_hardirqs_off(). And, this will suppress the message
> outputs of unwind_frame.

That will break the output for users that have a working CALLER_ADDR1.

> If you think this idea is okay, I will push the patch v2 to you.
> In my test result, it looks it's functionally correct.
> 
> Thanks.
> 
> -- kpark
> 
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
> index 5bbec7b..675fd62 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -9,6 +9,9 @@ ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_insn.o = -pg
>  CFLAGS_REMOVE_patch.o = -pg
> +ifdef CONFIG_ARM_UNWIND
> +CFLAGS_REMOVE_unwind.o = -pg
> +endif

You don't need to add the ifdef CONFIG_ARM_UNWIND. It's just setting a
variable and if the unwind.o gets complied, it will apply the removal of
-pg. If the unwind isn't compiled the variable will just be set but
unused. No harm done.

>  endif
> 
>  CFLAGS_REMOVE_return_address.o = -pg



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

This is not equivalent. CALLER_ADDR0 will just give us what disabled the
irqs (spin_lock_irq or local_irq_save), but wont give us who called
that.

If you can't handle CALLER_ADDR1, then define it to NULL or to
CALLER_ADDR0.

What the original output gives:

jbd2/dm--1399    3d...    0us : _raw_spin_lock_irqsave
<-ata_scsi_queuecmd

which shows that the _raw_spin_lock_irqsave which disabled irqs was
called by ata_scsi_queuecmd.

With your patch we get:

jbd2/dm--1407    3d...    0us : trace_hardirqs_off
<-_raw_spin_lock_irqsave

Which shows the internal function "trace_hardirqs_off" which is useless,
as well as that the thing that disabled interrupts was
_raw_spin_lock_irqsave. But we don't get who called
_raw_spin_lock_irqsave.

Thus you just broke the code for those that can handle CALLER_ADDR1.

-- Steve

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


