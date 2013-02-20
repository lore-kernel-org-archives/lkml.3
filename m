Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3BTWBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:01:21 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:44752 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3BTWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:01:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302202155320.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302202155320.22263@ionos>
Date: Wed, 20 Feb 2013 23:01:17 +0100
Message-ID: <CAFTL4hx_uXfY=bH9nnEsN6AJFTcwqdAWTxcR0jc=hL1FBrwk0w@mail.gmail.com>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/20 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 20 Feb 2013, Frederic Weisbecker wrote:
>
>> As it stands, irq_exit() may or may not be called with
>> irqs disabled, depending on __ARCH_IRQ_EXIT_IRQS_DISABLED
>> that the arch can define.
>>
>> It makes tick_nohz_irq_exit() unsafe. For example two
>> interrupts can race in tick_nohz_stop_sched_tick(): the inner
>> most one computes the expiring time on top of the timer list,
>> then it's interrupted right before reprogramming the
>> clock. The new interrupt enqueues a new timer list timer,
>> it reprogram the clock to take it into account and it exits.
>> The CPUs resumes the inner most interrupt and performs the clock
>> reprogramming without considering the new timer list timer.
>>
>> This regression has been introduced by:
>>      280f06774afedf849f0b34248ed6aff57d0f6908
>>      ("nohz: Separate out irq exit and idle loop dyntick logic")
>>
>> Let's fix it right now with the appropriate protections.
>
> That's not a fix. That's an hack.

I know it looks that way. That's because it's a pure regression fix,
minimal for backportability.

I'm distinguishing two different things here: the fact that some archs
can call irq_exit() with interrupts enabled which is a global design
problem, and the fact that tick_nohz_irq_exit() was safe against that
until 3.2 when I broke it with a commit of mine.

My goal was basically to restore that protection in a minimal commit
such that we can backport the regression fix, then deal with
__ARCH_IRQ_EXIT_IRQS_DISABLED afterward, since it requires some more
invasive changes.

>> A saner long term solution will be to remove
>> __ARCH_IRQ_EXIT_IRQS_DISABLED.
>
> We really want to enforce that interrupt disabled condition for
> calling irq_exit(). So why make this exclusive to tick_nohz_irq_exit()?

I need a fix that I can backport. Is the below fine with a stable tag?
It looks a bit too invasive for the single regression involved.

Thanks.

>
> Thanks,
>
>         tglx
>
> Index: linux-2.6/kernel/softirq.c
> ===================================================================
> --- linux-2.6.orig/kernel/softirq.c
> +++ linux-2.6/kernel/softirq.c
> @@ -322,18 +322,10 @@ void irq_enter(void)
>
>  static inline void invoke_softirq(void)
>  {
> -       if (!force_irqthreads) {
> -#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
> +       if (!force_irqthreads)
>                 __do_softirq();
> -#else
> -               do_softirq();
> -#endif
> -       } else {
> -               __local_bh_disable((unsigned long)__builtin_return_address(0),
> -                               SOFTIRQ_OFFSET);
> +       else
>                 wakeup_softirqd();
> -               __local_bh_enable(SOFTIRQ_OFFSET);
> -       }
>  }
>
>  /*
> @@ -341,6 +333,14 @@ static inline void invoke_softirq(void)
>   */
>  void irq_exit(void)
>  {
> +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +#else
> +       BUG_ON(!irqs_disabled();
> +#endif
> +
>         account_irq_exit_time(current);
>         trace_hardirq_exit();
>         sub_preempt_count(IRQ_EXIT_OFFSET);
> @@ -354,6 +354,9 @@ void irq_exit(void)
>  #endif
>         rcu_irq_exit();
>         sched_preempt_enable_no_resched();
> +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> +       local_irq_restore(flags);
> +#endif
>  }
>
>  /*
