Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaEUTDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbaEUTDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:03:12 -0400
Date: Wed, 21 May 2014 15:02:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, fweisbec@gmail.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 1/6] x86, nmi:  Implement delayed irq_work mechanism to
 handle lost NMIs
Message-ID: <20140521190225.GC50500@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-2-git-send-email-dzickus@redhat.com>
 <20140521102934.GZ2485@laptop.programming.kicks-ass.net>
 <20140521164525.GY50500@redhat.com>
 <20140521175149.GI2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521175149.GI2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 07:51:49PM +0200, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 12:45:25PM -0400, Don Zickus wrote:
> > > > +	/*
> > > > +	 * Can't use send_IPI_self here because it will
> > > > +	 * send an NMI in IRQ context which is not what
> > > > +	 * we want.  Create a cpumask for local cpu and
> > > > +	 * force an IPI the normal way (not the shortcut).
> > > > +	 */
> > > > +	bitmap_zero(nmi_mask, NR_CPUS);
> > > > +	mask = to_cpumask(nmi_mask);
> > > > +	cpu_set(smp_processor_id(), *mask);
> > > > +
> > > > +	__this_cpu_xchg(nmi_delayed_work_pending, true);
> > > 
> > > Why is this xchg and not __this_cpu_write() ?
> > > 
> > > > +	apic->send_IPI_mask(to_cpumask(nmi_mask), NMI_VECTOR);
> > > 
> > > What's wrong with apic->send_IPI_self(NMI_VECTOR); ?
> > 
> > I tried to explain that in my comment above.  IPI_self uses the shortcut
> > method to send IPIs which means the NMI_VECTOR will be delivered in IRQ
> > context _not_ NMI context. :-(  This is why I do the whole silly dance.
> 
> I'm still not getting it, probably because I don't know how these APICs
> really work, but the way I read both the comment and your explanation
> here is that we get an NMI nested in the IRQ context we called it from,
> which is pretty much exactly what we want.

Um, ok.  I think my concern with that is an NMI nested in IRQ context
could be interrupted by a real NMI. I believe that would cause nmi_enter()
to barf among other bad things in the nmi code.

> 
> > I am open to better options.  We might be able to patch IPI_self but I am
> > not sure why it didn't special case the NMI_VECTOR to begin with (like the
> > other handlers seem to do).
> 
> cpumask_of(cpu) gives the right mask.

Ok. Thanks.

<snip>

> > Now oddly enough there were situations were the NMI happened and it found
> > a PMI event.  So my patch re-queued the irq_work (after clearing the
> > 'flag' based on problem 1 above).  However, the PMI and self IPI happened
> > at roughly the same time, such that after the IRET of the PMI NMI, the
> > 'dummy' NMI is immediately executed (think back-to-back NMIs).
> > 
> > This NMI is supposed to be the 'dummy' NMI caught below with the 'flag'
> > set.  However, the 'flag' was cleared upon re-queue of the previous PMI
> > NMI.  This leads to a periodic unknown NMI. Ooops.
> > 
> > I tried to workaround this by checking the IRQ_BUSY flag and not clear it
> > in that case.
> 
> OK, so this is the part I got lost in and didn't see.
> 
> So a comment in the handler between setting the flag and raising the IPI
> might be a good idea..

Ok. I can do that.

> 
> > So both my problems center around what guarantees does irq_work have to
> > stay on the same cpu?
> 
> Well, none as you used a global irq_work, so all cpus will now contend
> on it on every NMI trying to queue it :-(

Yes, I was stuck between using a per-cpu implementation in which every dummy
NMI grabs the spin lock in the nmi handlers, or a global lock.  I tried
the global lock.

I thought the irq_work lock seemed less contended because it was only read
once before being acted upon (for a cacheline seperate from actual nmi work).

Whereas a spin lock in the nmi handlers seems to keep reading the lock
until it owns it thus slowing down useful work for the handler that owns
the lock (because of the cache contention).

I could be wrong though.


> 
> Didn't we have a problem with NMIs touching global cachelines before?
> 
> Wasn't that one of Dave Hansen's problems?

That might have been the regular port 0x61 spin locks that we added to
support bsp hot plugging.

> 
> > Or better yet, is there a different way to solve this problem?
> 
> Lemme think about that...

Of course oddly enough, the external NMIs are only routed to cpu0 right
now.  So having any non-cpu0 read them would be unexpected.  As a result
the global spin locks are added overhead in the off-chance the bsp cpu
disappears for some reason.

Perhaps just remove those global spin locks and keep a global variable of
which cpu gets to read the external NMIs.  Then upon hot plugging of the
bsp cpu (or the cpu that is setup to read the external NMI), a new cpu is
chosen and a dummy NMI is sent to handle the case an NMI is dropped during
the transition.

This would keep things fast in the normal path and be slow in the hotplug
path (which is rare anyway).  Then we could back to one queue again
(instead of the two queues I am proposing here).

Just an idea to spark conversation.

Cheers,
Don

