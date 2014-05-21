Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaEUTiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:38:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUTip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:38:45 -0400
Date: Wed, 21 May 2014 21:38:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, fweisbec@gmail.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 1/6] x86, nmi:  Implement delayed irq_work mechanism to
 handle lost NMIs
Message-ID: <20140521193830.GK2485@laptop.programming.kicks-ass.net>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-2-git-send-email-dzickus@redhat.com>
 <20140521102934.GZ2485@laptop.programming.kicks-ass.net>
 <20140521164525.GY50500@redhat.com>
 <20140521175149.GI2485@laptop.programming.kicks-ass.net>
 <20140521190225.GC50500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140521190225.GC50500@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:02:25PM -0400, Don Zickus wrote:
> On Wed, May 21, 2014 at 07:51:49PM +0200, Peter Zijlstra wrote:
> > On Wed, May 21, 2014 at 12:45:25PM -0400, Don Zickus wrote:
> > > > > +	/*
> > > > > +	 * Can't use send_IPI_self here because it will
> > > > > +	 * send an NMI in IRQ context which is not what
> > > > > +	 * we want.  Create a cpumask for local cpu and
> > > > > +	 * force an IPI the normal way (not the shortcut).
> > > > > +	 */
> > > > > +	bitmap_zero(nmi_mask, NR_CPUS);
> > > > > +	mask = to_cpumask(nmi_mask);
> > > > > +	cpu_set(smp_processor_id(), *mask);
> > > > > +
> > > > > +	__this_cpu_xchg(nmi_delayed_work_pending, true);
> > > > 
> > > > Why is this xchg and not __this_cpu_write() ?
> > > > 
> > > > > +	apic->send_IPI_mask(to_cpumask(nmi_mask), NMI_VECTOR);
> > > > 
> > > > What's wrong with apic->send_IPI_self(NMI_VECTOR); ?
> > > 
> > > I tried to explain that in my comment above.  IPI_self uses the shortcut
> > > method to send IPIs which means the NMI_VECTOR will be delivered in IRQ
> > > context _not_ NMI context. :-(  This is why I do the whole silly dance.
> > 
> > I'm still not getting it, probably because I don't know how these APICs
> > really work, but the way I read both the comment and your explanation
> > here is that we get an NMI nested in the IRQ context we called it from,
> > which is pretty much exactly what we want.
> 
> Um, ok.  I think my concern with that is an NMI nested in IRQ context
> could be interrupted by a real NMI. I believe that would cause nmi_enter()
> to barf among other bad things in the nmi code.

Ohh, you mean the NMI handler will run as a regular interrupt? Yes, that
would be bad.

> > > So both my problems center around what guarantees does irq_work have to
> > > stay on the same cpu?
> > 
> > Well, none as you used a global irq_work, so all cpus will now contend
> > on it on every NMI trying to queue it :-(
> 
> Yes, I was stuck between using a per-cpu implementation in which every dummy
> NMI grabs the spin lock in the nmi handlers, or a global lock.  I tried
> the global lock.
> 
> I thought the irq_work lock seemed less contended because it was only read
> once before being acted upon (for a cacheline seperate from actual nmi work).
> 
> Whereas a spin lock in the nmi handlers seems to keep reading the lock
> until it owns it thus slowing down useful work for the handler that owns
> the lock (because of the cache contention).
> 
> I could be wrong though.

Well, pretty much every NMI will call irq_queue_work() which calls
irq_work_claim() which does an uncondition cmpxchg (locked rmw) on the
global cacheline.

Which is *hurt*.


will try and reply to the rest later..
