Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaEUK3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:29:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:39138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaEUK3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:29:39 -0400
Date: Wed, 21 May 2014 12:29:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, fweisbec@gmail.com
Subject: Re: [PATCH 1/6] x86, nmi:  Implement delayed irq_work mechanism to
 handle lost NMIs
Message-ID: <20140521102934.GZ2485@laptop.programming.kicks-ass.net>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400181949-157170-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 03:25:44PM -0400, Don Zickus wrote:
> +DEFINE_PER_CPU(bool, nmi_delayed_work_pending);
> +
> +static void nmi_delayed_work_func(struct irq_work *irq_work)
> +{
> +	DECLARE_BITMAP(nmi_mask, NR_CPUS);

That's _far_ too big for on-stack, 4k cpus would make that 512 bytes.

> +	cpumask_t *mask;
> +
> +	preempt_disable();

That's superfluous, irq_work's are guaranteed to be called with IRQs
disabled.

> +
> +	/*
> +	 * Can't use send_IPI_self here because it will
> +	 * send an NMI in IRQ context which is not what
> +	 * we want.  Create a cpumask for local cpu and
> +	 * force an IPI the normal way (not the shortcut).
> +	 */
> +	bitmap_zero(nmi_mask, NR_CPUS);
> +	mask = to_cpumask(nmi_mask);
> +	cpu_set(smp_processor_id(), *mask);
> +
> +	__this_cpu_xchg(nmi_delayed_work_pending, true);

Why is this xchg and not __this_cpu_write() ?

> +	apic->send_IPI_mask(to_cpumask(nmi_mask), NMI_VECTOR);

What's wrong with apic->send_IPI_self(NMI_VECTOR); ?

> +
> +	preempt_enable();
> +}
> +
> +struct irq_work nmi_delayed_work =
> +{
> +	.func	= nmi_delayed_work_func,
> +	.flags	= IRQ_WORK_LAZY,
> +};

OK, so I don't particularly like the LAZY stuff and was hoping to remove
it before more users could show up... apparently I'm too late :-(

Frederic, I suppose this means dual lists.

> +static bool nmi_queue_work_clear(void)
> +{
> +	bool set = __this_cpu_read(nmi_delayed_work_pending);
> +
> +	__this_cpu_write(nmi_delayed_work_pending, false);
> +
> +	return set;
> +}

That's a test-and-clear, the name doesn't reflect this. And here you do
_not_ use xchg where you actually could have.

That said, try and avoid using xchg() its unconditionally serialized.

> +
> +static int nmi_queue_work(void)
> +{
> +	bool queued = irq_work_queue(&nmi_delayed_work);
> +
> +	if (queued) {
> +		/*
> +		 * If the delayed NMI actually finds a 'dropped' NMI, the
> +		 * work pending bit will never be cleared.  A new delayed
> +		 * work NMI is supposed to be sent in that case.  But there
> +		 * is no guarantee that the same cpu will be used.  So
> +		 * pro-actively clear the flag here (the new self-IPI will
> +		 * re-set it.
> +		 *
> +		 * However, there is a small chance that a real NMI and the
> +		 * simulated one occur at the same time.  What happens is the
> +		 * simulated IPI NMI sets the work_pending flag and then sends
> +		 * the IPI.  At this point the irq_work allows a new work
> +		 * event.  So when the simulated IPI is handled by a real NMI
> +		 * handler it comes in here to queue more work.  Because
> +		 * irq_work returns success, the work_pending bit is cleared.
> +		 * The second part of the back-to-back NMI is kicked off, the
> +		 * work_pending bit is not set and an unknown NMI is generated.
> +		 * Therefore check the BUSY bit before clearing.  The theory is
> +		 * if the BUSY bit is set, then there should be an NMI for this
> +		 * cpu latched somewhere and will be cleared when it runs.
> +		 */
> +		if (!(nmi_delayed_work.flags & IRQ_WORK_BUSY))
> +			nmi_queue_work_clear();

So I'm utterly and completely failing to parse that. It just doesn't
make sense.

> +	}
> +
> +	return 0;
> +}

Why does this function have a return value if all it can return is 0 and
everybody ignores it?

> +
>  static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
>  {
>  	struct nmi_desc *desc = nmi_to_desc(type);
> @@ -341,6 +441,9 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
>  		 */
>  		if (handled > 1)
>  			__this_cpu_write(swallow_nmi, true);
> +
> +		/* kick off delayed work in case we swallowed external NMI */

That's inaccurate, there's no guarantee we actually swallowed one
afaict, this is where we have to assume we lost one because there's
really no other place.

> +		nmi_queue_work();
>  		return;
>  	}
>  
> @@ -362,10 +465,16 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
>  #endif
>  		__this_cpu_add(nmi_stats.external, 1);
>  		raw_spin_unlock(&nmi_reason_lock);
> +		/* kick off delayed work in case we swallowed external NMI */
> +		nmi_queue_work();

Again, inaccurate, there's no guarantee we did swallow an external NMI,
but the thing is, there's no guarantee we didn't either, which is why we
need to do this.

>  		return;
>  	}
>  	raw_spin_unlock(&nmi_reason_lock);
>  
> +	/* expected delayed queued NMI? Don't flag as unknown */
> +	if (nmi_queue_work_clear())
> +		return;
> +

Right, so here we effectively swallow the extra nmi and avoid the
unknown_nmi_error() bits.


