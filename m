Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbaFQUEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:04:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18464 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:04:29 -0400
Date: Tue, 17 Jun 2014 16:03:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Waiman.Long@hp.com
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 01/11] qspinlock: A simple generic 4-byte queue spinlock
Message-ID: <20140617200329.GA27400@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130152.912524881@chello.nl>
 <20140616204918.GA26140@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616204918.GA26140@laptop.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +			new = tail | (val & _Q_LOCKED_MASK);
> > +
> > +		old = atomic_cmpxchg(&lock->val, val, new);
> > +		if (old == val)
> > +			break;
> > +
> > +		val = old;
> > +	}
> > +
> > +	/*
> > +	 * we won the trylock; forget about queueing.
> > +	 */
> > +	if (new == _Q_LOCKED_VAL)
> > +		goto release;
> > +
> > +	/*
> > +	 * if there was a previous node; link it and wait.
> > +	 */
> > +	if (old & ~_Q_LOCKED_MASK) {
> > +		prev = decode_tail(old);
> > +		ACCESS_ONCE(prev->next) = node;
> > +
> > +		arch_mcs_spin_lock_contended(&node->locked);

Could you add a comment here:

/* We are spinning forever until the previous node updates locked - which
it does once the it has updated lock->val with our tail number. */

> > +	}
> > +
> > +	/*
> > +	 * we're at the head of the waitqueue, wait for the owner to go away.
> > +	 *
> > +	 * *,x -> *,0
> > +	 */
> > +	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> > +		cpu_relax();
> > +
> > +	/*
> > +	 * claim the lock:
> > +	 *
> > +	 * n,0 -> 0,1 : lock, uncontended
> > +	 * *,0 -> *,1 : lock, contended
> > +	 */
> > +	for (;;) {
> > +		new = _Q_LOCKED_VAL;
> > +		if (val != tail)
> > +			new |= val;
> 
..snip..
> 
> Could you help a bit in explaining it in English please?

After looking at the assembler code I finally figured out how
we can get here. And the 'contended' part threw me off. Somehow
I imagined there are two more more CPUs stampeding here and 
trying to update the lock->val. But in reality the other CPUs
are stuck in the arch_mcs_spin_lock_contended spinning on their
local value.

Perhaps you could add this comment.

/* Once queue_spin_unlock is called (which _subtracts_ _Q_LOCKED_VAL from
the lock->val and still preserving the tail data), the winner gets to
claim the ticket. Since we still need the other CPUs to continue and
preserve the strict ordering in which they setup node->next, we:
 1) update lock->val to the tail value (so tail CPU and its index) with
    _Q_LOCKED_VAL.
 2). Once we are done, we poke the other CPU (the one that linked to
    us) by writting to node->locked (below) so they can make progress and
    loop on lock->val changing from _Q_LOCKED_MASK to zero).

*/
