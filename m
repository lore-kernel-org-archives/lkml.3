Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaELRlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:41:39 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57303 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaELRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:41:37 -0400
Date: Mon, 12 May 2014 19:41:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Architecture support for remote irq work
 raise
Message-ID: <20140512174130.GA6127@localhost.localdomain>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
 <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
 <20140512075650.GJ30445@twins.programming.kicks-ass.net>
 <20140512162641.GA28033@localhost.localdomain>
 <20140512171729.GD13467@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512171729.GD13467@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 07:17:29PM +0200, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 06:26:49PM +0200, Frederic Weisbecker wrote:
> > On Mon, May 12, 2014 at 09:56:50AM +0200, Peter Zijlstra wrote:
> > > On Mon, May 12, 2014 at 01:33:53AM +0200, Frederic Weisbecker wrote:
> > > > We are going to extend irq work to support remote queuing.
> > > > 
> > > > So lets add a cpu argument to arch_irq_work_raise(). The architectures
> > > > willing to support that must then provide the backend to raise irq work
> > > > IPIs remotely.
> > > > 
> > > > Initial support is provided for x86 and ARM since they are easily
> > > > extended. The other archs that overwrite arch_irq_work_raise() seem
> > > > to use local clock interrupts and therefore need deeper rewrite of their
> > > > irq work support to implement remote raising.
> > > > 
> > > 
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > > Why not borrow the smp_call_function IPI for the remote bits? We could
> > > limit the 'safe from NMI' to the local works. And we validate this by
> > > putting a WARN_ON(in_nmi()) in irq_work_queue_on().
> > 
> > Right, but although I don't need it to be safe from NMI, I need it
> > to be callable concurrently and when irqs are disabled.
> > 
> > So we can't use smp_call_function_single() for that. But we can use the async
> > version in which case we must keep the irq work claim. But that's
> > about the same than smp_queue_function_single() we had previously
> > and we are back with our csd_lock issue.
> 
> Who said anything about using smp_call_function_single()?

Ah shortcutting, doesn't look bad indeed.

> 
> 
> ---
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index a82170e2fa78..2fc9d8ece05a 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -61,7 +61,8 @@ void __weak arch_irq_work_raise(void)
>   *
>   * Can be re-enqueued while the callback is still in progress.
>   */
> -bool irq_work_queue(struct irq_work *work)
> +static __always_inline bool
> +__irq_work_queue_on(struct irq_work *work, int cpu)
>  {
>  	/* Only queue if not already pending */
>  	if (!irq_work_claim(work))
> @@ -78,16 +79,31 @@ bool irq_work_queue(struct irq_work *work)
>  	 * for the next tick.
>  	 */
>  	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
> -		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
> -			arch_irq_work_raise();
> +		if (cmpxchg(&__get_cpu_var(irq_work_raised, 0, 1) == 0)) {
> +			if (cpu == smp_processor_id() || cpu == -1)
> +				arch_irq_work_raise();
> +			else
> +				arch_send_call_function_single_ipi();
> +		}

Ok that needs some more tuning with the raised flag and the destination list
to pick, but I get the idea.

>  	}
>  
>  	preempt_enable();
>  
>  	return true;
>  }
> +
> +bool irq_work_queue(struct irq_work *work)
> +{
> +	return __irq_work_queue_on(work, -1);
> +}
>  EXPORT_SYMBOL_GPL(irq_work_queue);
>  
> +bool irq_work_queue_on(struct irq_work *work, int cpu)
> +{
> +	WARN_ON_ONCE(in_nmi());
> +	return __irq_work_queue_on(work, cpu);
> +}
> +
>  bool irq_work_needs_cpu(void)
>  {
>  	struct llist_head *this_list;
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 06d574e42c72..0fd53963c4fb 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -198,6 +198,12 @@ void generic_smp_call_function_single_interrupt(void)
>  		csd->func(csd->info);
>  		csd_unlock(csd);
>  	}
> +
> +	/*
> +	 * First run the synchronous callbacks, people are waiting on them;
> +	 * then run the async ones.
> +	 */
> +	irq_work_run();
>  }

Alright, I'm reiterating with that.

Thanks.
