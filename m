Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3BRT6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:58:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:57036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3BRT6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:58:45 -0500
Date: Mon, 18 Feb 2013 20:58:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <20130218155324.GA5816@somewhere.redhat.com>
Message-ID: <alpine.LFD.2.02.1302182055040.22263@ionos>
References: <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com> <20130215174435.GA2792@linux.vnet.ibm.com>
 <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com> <CAFTL4hyTfwAZWz=gMokk5oG3HO8iGh7=FtoNv89CMg_Lm-TPNg@mail.gmail.com> <CA+55aFz4vO-JGv+A7h=uxwfyWEMcK=Q3gntwHfr=a4OUVs-f+g@mail.gmail.com> <CAFTL4hx7iX8vZFu7pO5wLSPpEzfMD8K7n0bUsY-wK-uCsDAsEw@mail.gmail.com>
 <CAFTL4hzUy+2qDaCDK3jCUs+6Fe48-uU9KSB+Ssk+-i=zYhqaRg@mail.gmail.com> <20130218155324.GA5816@somewhere.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Frederic Weisbecker wrote:
> On Sun, Feb 17, 2013 at 10:02:11PM +0100, Frederic Weisbecker wrote:
> > 2013/2/17 Frederic Weisbecker <fweisbec@gmail.com>:
> > > 2013/2/17 Linus Torvalds <torvalds@linux-foundation.org>:
> > >> On Sun, Feb 17, 2013 at 7:11 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > >>>
> > >>> preempt_value_in_interrupt() looks buggy in your patch: it makes
> > >>> invoke_softirq() returning if (val & HARDIRQ_MASK). But that's always
> > >>> true since you have moved further the sub_preempt_count(IRQ_EXIT)
> > >>> further.
> > >>
> > >> No, that's not it. The value hasn't been written back yet, but it already did:
> > >>
> > >> +       int offset = IRQ_EXIT_OFFSET;
> > >> +       int count = preempt_count() - offset;
> > >>
> > >> so the 'count' has the IRQ_EXIT_OFFSET already subtracted. So no,
> > >> HARDIRQ_MASK is *not* always set.
> > >
> > > Another thing. Perhaps we can push the idea of your patch a little
> > > further by re-entering HARDIRQ_OFFSET at the end of the softirq
> > > processing and do the final sub_preempt_count(HARDIRQ_OFFSET) at the
> > > very end of irq_exit().
> > >
> > > This way irq_exit() looks a bit more simple to me: everything there
> > > becomes considered as in hardirq: (ie: rcu_irq_exit() and
> > > tick_nohz_irq_exit() won't appear anymore as weird special cases) and
> > > we get rid of that IRQ_EXIT_OFFSET hack that fixes the CONFIG_PREEMPT
> > > case.
> > >
> > > I'm attaching an untested patch that modify yours. It's probably
> > > missing some corner cases that rely on in_interrupt() value in
> > > rcu_irq_exit() and tick_nohz_irq_exit() and may be other things.
> > 
> > I messed up preempt_offset_in_interrupt() with in_atomic() code
> > instead of in_interrupt(). Anyway the patch is untested and is more
> > there to get your opinion for now. I'll put some more care on it if
> > people like it.
> 
> Here is an updated version. It cleans up things a bit and boots fine with my usual
> config. There might be still some small details to work on but here is the big picture.
> 
> What do you think?
> 
> ---
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 624ef3f..d1ab5b4 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -87,6 +87,7 @@
>  #define in_irq()		(hardirq_count())
>  #define in_softirq()		(softirq_count())
>  #define in_interrupt()		(irq_count())
> +#define in_nesting_interrupt()  (irq_count() - HARDIRQ_OFFSET)
>  #define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
>  
>  /*
> @@ -118,10 +119,8 @@
>  
>  #ifdef CONFIG_PREEMPT_COUNT
>  # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
> -# define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
>  #else
>  # define preemptible()	0
> -# define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
>  #endif
>  
>  #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index ed567ba..69fbefd 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -277,6 +277,17 @@ restart:
>  	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
>  }
>  
> +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED

We really should get rid of that and make irqs disabled on irq exit
mandatory.

> +static void __do_softirq_irq_unsafe(void)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__do_softirq();
> +	local_irq_restore(flags);
> +}
> +#endif
> +
>  #ifndef __ARCH_HAS_DO_SOFTIRQ
>  
>  asmlinkage void do_softirq(void)
> @@ -320,20 +331,45 @@ void irq_enter(void)
>  	__irq_enter();
>  }
>  
> +/*
> + * Invoce softirq's from irq_exit().
> + *
> + * Return the preempt offset: either IRQ_EXIT_OFFSET (if we
> + * did nothing to the preemption count) or SOFTIRQ_OFFSET (in
> + * case we did softirq processing and changed the preemption
> + * count to account for that).
> + */
>  static inline void invoke_softirq(void)
>  {
> -	if (!force_irqthreads) {
> +	/* Can we run softirq's at all? We migth be nesting interrupts */
> +	if (in_nesting_interrupt())
> +		return;

We might also be in a softirq disabled region where it makes no sense
to continue. So this should be

   in_nesting_interrupt() || in_softirq()

> +	/* Are there any pending? */
> +	if (!local_softirq_pending())
> +		return;
> +
> +	/* Do we force irq threads? If so, just wake up the daemon */
> +	if (force_irqthreads) {
> +		wakeup_softirqd();
> +		return;
> +	}
> +
> +	/*
> +	 * Ok, do actual softirq handling!
> +	 *
> +	 * This downgrades us from hardirq context to softirq context.
> +	 */
> +	preempt_count() += SOFTIRQ_OFFSET - HARDIRQ_OFFSET;
> +
> +	trace_softirqs_off(__builtin_return_address(0));
>  #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
> -		__do_softirq();
> +	__do_softirq();
>  #else
> -		do_softirq();
> +	__do_softirq_irq_unsafe();
>  #endif
> -	} else {
> -		__local_bh_disable((unsigned long)__builtin_return_address(0),
> -				SOFTIRQ_OFFSET);
> -		wakeup_softirqd();
> -		__local_bh_enable(SOFTIRQ_OFFSET);
> -	}
> +	preempt_count() += HARDIRQ_OFFSET - SOFTIRQ_OFFSET;
> +	trace_softirqs_on((unsigned long)__builtin_return_address(0));
>  }
>  
>  /*
> @@ -343,17 +379,17 @@ void irq_exit(void)
>  {
>  	vtime_account_irq_exit(current);
>  	trace_hardirq_exit();
> -	sub_preempt_count(IRQ_EXIT_OFFSET);
> -	if (!in_interrupt() && local_softirq_pending())
> -		invoke_softirq();
> +	invoke_softirq();
>  
>  #ifdef CONFIG_NO_HZ
>  	/* Make sure that timer wheel updates are propagated */
> -	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
> -		tick_nohz_irq_exit();
> +	if (idle_cpu(smp_processor_id())) {
> +		if (!in_nesting_interrupt() && !need_resched())
> +			tick_nohz_irq_exit();
> +	}
>  #endif
>  	rcu_irq_exit();
> -	sched_preempt_enable_no_resched();
> +	sub_preempt_count(HARDIRQ_OFFSET);
>  }

Otherwise this is a nice improvement!

Thanks,

	tglx
