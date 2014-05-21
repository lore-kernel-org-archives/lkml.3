Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaEURwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:52:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEURwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:52:07 -0400
Date: Wed, 21 May 2014 19:51:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, fweisbec@gmail.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 1/6] x86, nmi:  Implement delayed irq_work mechanism to
 handle lost NMIs
Message-ID: <20140521175149.GI2485@laptop.programming.kicks-ass.net>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-2-git-send-email-dzickus@redhat.com>
 <20140521102934.GZ2485@laptop.programming.kicks-ass.net>
 <20140521164525.GY50500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521164525.GY50500@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 12:45:25PM -0400, Don Zickus wrote:
> > > +	/*
> > > +	 * Can't use send_IPI_self here because it will
> > > +	 * send an NMI in IRQ context which is not what
> > > +	 * we want.  Create a cpumask for local cpu and
> > > +	 * force an IPI the normal way (not the shortcut).
> > > +	 */
> > > +	bitmap_zero(nmi_mask, NR_CPUS);
> > > +	mask = to_cpumask(nmi_mask);
> > > +	cpu_set(smp_processor_id(), *mask);
> > > +
> > > +	__this_cpu_xchg(nmi_delayed_work_pending, true);
> > 
> > Why is this xchg and not __this_cpu_write() ?
> > 
> > > +	apic->send_IPI_mask(to_cpumask(nmi_mask), NMI_VECTOR);
> > 
> > What's wrong with apic->send_IPI_self(NMI_VECTOR); ?
> 
> I tried to explain that in my comment above.  IPI_self uses the shortcut
> method to send IPIs which means the NMI_VECTOR will be delivered in IRQ
> context _not_ NMI context. :-(  This is why I do the whole silly dance.

I'm still not getting it, probably because I don't know how these APICs
really work, but the way I read both the comment and your explanation
here is that we get an NMI nested in the IRQ context we called it from,
which is pretty much exactly what we want.

> I am open to better options.  We might be able to patch IPI_self but I am
> not sure why it didn't special case the NMI_VECTOR to begin with (like the
> other handlers seem to do).

cpumask_of(cpu) gives the right mask.

> > > +struct irq_work nmi_delayed_work =
> > > +{
> > > +	.func	= nmi_delayed_work_func,
> > > +	.flags	= IRQ_WORK_LAZY,
> > > +};
> > 
> > OK, so I don't particularly like the LAZY stuff and was hoping to remove
> > it before more users could show up... apparently I'm too late :-(
> > 
> > Frederic, I suppose this means dual lists.
> 
> Again I am open to suggestions here.  I just wanted a little delay somehow
> (a few ticks ideally).  The IRQ_WORK_LAZY seemed to be good enough for me
> for now so I chose it.

This might actually be a good enough usage of LAZY to not shoot it in
the head.

> > > +static int nmi_queue_work(void)
> > > +{
> > > +	bool queued = irq_work_queue(&nmi_delayed_work);
> > > +
> > > +	if (queued) {
> > > +		/*
> > > +		 * If the delayed NMI actually finds a 'dropped' NMI, the
> > > +		 * work pending bit will never be cleared.  A new delayed
> > > +		 * work NMI is supposed to be sent in that case.  But there
> > > +		 * is no guarantee that the same cpu will be used.  So
> > > +		 * pro-actively clear the flag here (the new self-IPI will
> > > +		 * re-set it.
> > > +		 *
> > > +		 * However, there is a small chance that a real NMI and the
> > > +		 * simulated one occur at the same time.  What happens is the
> > > +		 * simulated IPI NMI sets the work_pending flag and then sends
> > > +		 * the IPI.  At this point the irq_work allows a new work
> > > +		 * event.  So when the simulated IPI is handled by a real NMI
> > > +		 * handler it comes in here to queue more work.  Because
> > > +		 * irq_work returns success, the work_pending bit is cleared.
> > > +		 * The second part of the back-to-back NMI is kicked off, the
> > > +		 * work_pending bit is not set and an unknown NMI is generated.
> > > +		 * Therefore check the BUSY bit before clearing.  The theory is
> > > +		 * if the BUSY bit is set, then there should be an NMI for this
> > > +		 * cpu latched somewhere and will be cleared when it runs.
> > > +		 */
> > > +		if (!(nmi_delayed_work.flags & IRQ_WORK_BUSY))
> > > +			nmi_queue_work_clear();
> > 
> > So I'm utterly and completely failing to parse that. It just doesn't
> > make sense.
> 
> Ok.  Sorry about that.  There is two issues here.  One is hypotethical I
> think and the second I stumbled upon after trying to solve the first one.
> 
> Let me try to explain this again and see if I can do a better job.
> 
> The original problem is that two NMIs might show up with the second one
> being dropped because they are latched waiting for the first NMI to
> finish (something like that).
> 
> Currently all the NMI handlers are processed regardless if the first one
> on the list handled the NMI or not.  This helps avoid the problem
> described above.
> 
> Now a new wrinkle.  There are two NMI handlers (legacy port 0x61 and GHES)
> that require a spin lock to access the hardware safely.  This is obviously
> a big latency hit.  Not a problem if the NMI volume is low.
> 
> However, perf makes NMI a high volume interrupt. :-)
> 
> The question is how to handle the high volume PMI without incurring the
> latency hit of the spin locks.
> 
> I posted a patch to split these into two queues: internal and external
> (external being the ones that use a spin lock).
> 
> Ingo pointed out the 'original' problem again and suggested using irq_work
> to solve it by passing in a dummy NMI periodically to look for 'stale??'
> NMIs.
> 
> 
> Implementing Ingo's idea seemed to imply most of the time the dummy NMI
> would pass through and cause unknown errors unless I caught (using that
> test-and-clear flag above).  Seemed acceptable.
> 
> Say a dummy NMI came through and actually _found_ a 'stale' NMI (like it
> was supposed to do).  What happens to the 'flag'?  It doesn't get cleared.
> 
> To take care of that, I just keep creating 'dummy' NMIs until it falls all
> the way through and clears the flag.
> 

Right, I got that far.

> Now to my 'comment' that doesn't make sense.
> 
> I was theorizing what happens if a dummy NMI came through and found a 'stale'
> NMI?  My patch was supposed to generate another 'dummy' NMI to clear the
> 'flag'.  But are there any guarantees that the new 'dummy' NMI is sent to
> the same cpu?  If not, then the flag is never cleared.  Which means a
> later 'real' unknown NMI would get swallowed accidentally.
> 
> That is what the first half of my comment was trying to say.
> 
> I tried to solve this by always clearing the 'flag' upon re-queue of the
> irq_work event. [The flag is always 'set' in the irq_work function]
> 
> This way if the irq_work event was scheduled on a different cpu, the
> 'flag' would not stay set forever.

OK, that I got too, I think. And at that point I was thinking, why not
unconditionally wipe the flag in nmi_queue_work() and have the handler
set it again.

> The second half tries to talk about a problem I uncovered while trying to
> solve the first problem, which is:
> 
> The irq_work function is called and the first thing it does is set a
> 'flag' (to prevent the accidentally unknown NMI).  Then it calls the IPI,
> which immediately takes the NMI.
> 
> Now oddly enough there were situations were the NMI happened and it found
> a PMI event.  So my patch re-queued the irq_work (after clearing the
> 'flag' based on problem 1 above).  However, the PMI and self IPI happened
> at roughly the same time, such that after the IRET of the PMI NMI, the
> 'dummy' NMI is immediately executed (think back-to-back NMIs).
> 
> This NMI is supposed to be the 'dummy' NMI caught below with the 'flag'
> set.  However, the 'flag' was cleared upon re-queue of the previous PMI
> NMI.  This leads to a periodic unknown NMI. Ooops.
> 
> I tried to workaround this by checking the IRQ_BUSY flag and not clear it
> in that case.

OK, so this is the part I got lost in and didn't see.

So a comment in the handler between setting the flag and raising the IPI
might be a good idea..

> So both my problems center around what guarantees does irq_work have to
> stay on the same cpu?

Well, none as you used a global irq_work, so all cpus will now contend
on it on every NMI trying to queue it :-(

Didn't we have a problem with NMIs touching global cachelines before?

Wasn't that one of Dave Hansen's problems?

> Or better yet, is there a different way to solve this problem?

Lemme think about that...
