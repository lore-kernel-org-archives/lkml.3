Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbbAWQH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:07:59 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbbAWQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:07:56 -0500
Date: Fri, 23 Jan 2015 17:07:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        luto@amacapital.net
Subject: Re: [RFC] sched, x86: Prevent resched interrupts if task in kernel
 mode and !CONFIG_PREEMPT
Message-ID: <20150123160746.GD23123@twins.programming.kicks-ass.net>
References: <1422028412.6345.6.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422028412.6345.6.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 06:53:32PM +0300, Kirill Tkhai wrote:
> It's useless to send reschedule interrupts in such situations. The earliest
> point, where schedule() call is possible, is sysret_careful(). But in that
> function we directly test TIF_NEED_RESCHED.
> 
> So it's possible to get rid of that type of interrupts.
> 
> How about this idea? Is set_bit() cheap on x86 machines?

So you set TIF_POLLING_NRFLAG on syscall entry and clear it again on
exit? Thereby we avoid the IPI, because the exit path already checks for
TIF_NEED_RESCHED.

Should work I suppose, but I'm not too familiar with all that entry.S
muck. Andy might know and appreciate this.

> ---
>  arch/x86/kernel/entry_64.S |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index c653dc4..a046ba8 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -409,6 +409,13 @@ GLOBAL(system_call_after_swapgs)
>  	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
>  	movq  %rcx,RIP-ARGOFFSET(%rsp)
>  	CFI_REL_OFFSET rip,RIP-ARGOFFSET
> +#if !defined(CONFIG_PREEMPT) || !defined(SMP)
> +	/*
> +	 * Tell resched_curr() do not send useless interrupts to us.
> +	 * Kernel isn't preemptible till sysret_careful() anyway.
> +	 */
> +	LOCK ; bts $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> +#endif
>  	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>  	jnz tracesys
>  system_call_fastpath:
> @@ -427,6 +434,9 @@ GLOBAL(system_call_after_swapgs)
>   * Has incomplete stack frame and undefined top of stack.
>   */
>  ret_from_sys_call:
> +#if !defined(CONFIG_PREEMPT) || !defined(SMP)
> +	LOCK ; btr $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> +#endif
>  	movl $_TIF_ALLWORK_MASK,%edi
>  	/* edi:	flagmask */
>  sysret_check:
> 
> 
> 
