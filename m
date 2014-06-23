Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaF0OYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:24:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaF0OYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:24:08 -0400
Date: Mon, 23 Jun 2014 12:20:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 01/11] qspinlock: A simple generic 4-byte queue spinlock
Message-ID: <20140623162020.GA9426@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130152.912524881@chello.nl>
 <20140616204918.GA26140@laptop.dumpdata.com>
 <20140617200329.GA27400@laptop.dumpdata.com>
 <20140623161200.GG19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623161200.GG19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:12:00PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 17, 2014 at 04:03:29PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > +			new = tail | (val & _Q_LOCKED_MASK);
> > > > +
> > > > +		old = atomic_cmpxchg(&lock->val, val, new);
> > > > +		if (old == val)
> > > > +			break;
> > > > +
> > > > +		val = old;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * we won the trylock; forget about queueing.
> > > > +	 */
> > > > +	if (new == _Q_LOCKED_VAL)
> > > > +		goto release;
> > > > +
> > > > +	/*
> > > > +	 * if there was a previous node; link it and wait.
> > > > +	 */
> > > > +	if (old & ~_Q_LOCKED_MASK) {
> > > > +		prev = decode_tail(old);
> > > > +		ACCESS_ONCE(prev->next) = node;
> > > > +
> > > > +		arch_mcs_spin_lock_contended(&node->locked);
> > 
> > Could you add a comment here:
> > 
> > /* We are spinning forever until the previous node updates locked - which
> > it does once the it has updated lock->val with our tail number. */
> 
> That's incorrect -- or at least, I understand that to be incorrect. The
> previous node will not have changed the tail to point to us. You always
> change to tail to point to yourself, seeing how you add yourself to the
> tail.
> 
> Is the existing comment any better if I s/wait./wait for it to release
> us./ ?

Yes!
> 
> > > > +	/*
> > > > +	 * claim the lock:
> > > > +	 *
> > > > +	 * n,0 -> 0,1 : lock, uncontended
> > > > +	 * *,0 -> *,1 : lock, contended
> > > > +	 */
> > > > +	for (;;) {
> > > > +		new = _Q_LOCKED_VAL;
> > > > +		if (val != tail)
> > > > +			new |= val;
> > > 
> > ..snip..
> > > 
> > > Could you help a bit in explaining it in English please?
> > 
> > After looking at the assembler code I finally figured out how
> > we can get here. And the 'contended' part threw me off. Somehow
> > I imagined there are two more more CPUs stampeding here and 
> > trying to update the lock->val. But in reality the other CPUs
> > are stuck in the arch_mcs_spin_lock_contended spinning on their
> > local value.
> 
> Well, the lock as a whole is contended (there's >1 waiters), and the
> point of MCS style locks it to make sure they're not actually pounding
> on the same cacheline. So the whole thing is consistent.
> 
> > Perhaps you could add this comment.
> > 
> > /* Once queue_spin_unlock is called (which _subtracts_ _Q_LOCKED_VAL from
> > the lock->val and still preserving the tail data), the winner gets to
> > claim the ticket. 
> 
> There's no tickets :/

s/ticket/be first in line/ ?

> 
> > Since we still need the other CPUs to continue and
> > preserve the strict ordering in which they setup node->next, we:
> >  1) update lock->val to the tail value (so tail CPU and its index) with
> >     _Q_LOCKED_VAL.
> 
> We don't, we preserve the tail value, unless we're the tail, in which
> case we clear the tail.
> 
> >  2). Once we are done, we poke the other CPU (the one that linked to
> >     us) by writting to node->locked (below) so they can make progress and
> >     loop on lock->val changing from _Q_LOCKED_MASK to zero).
> 
> _If_ there was another cpu, ie. the tail didn't point to us.

<nods>
> 
> ---
> 
> I don't do well with natural language comments like that; they tend to
> confuse me more than anything.
> 
