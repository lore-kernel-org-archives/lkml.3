Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab3K1L6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:58:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:57070 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3K1L6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:58:33 -0500
Date: Thu, 28 Nov 2013 12:58:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
In-Reply-To: <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1311281211530.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de>  <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>  <20131126085256.GD789@laptop.programming.kicks-ass.net>  <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>  <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
  <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de> <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Davidlohr Bueso wrote:
> On Wed, 2013-11-27 at 00:56 +0100, Thomas Gleixner wrote:
> > As a side note, it might be worthwhile to epxlore whether forcing the
> > hash buckets to be cache line aligned gives us an advantage over
> > blindly increasing the hash size:
> > 
> >  We could avoid access across cacheline boundaries and also avoid
> >  massive cache line bouncing if multiple cpus are hammering away at
> >  different hash buckets which happen to reside in the same cache line.
> 
> How about both enlarging the table _and_ aligning the buckets? As you
> know, increasing the size of the table also benefits (particularly in
> larger systems) in having more spinlocks. So we reduce the amount of
> collisions and alleviate contention on the hb->lock. Btw, do you have
> any particular concerns about the larger hash table patch? 

I'm not against increasing the hash table size, but I'm very
interested in investigating the alignment effect as a separate issue.

> > But back to the problem at hand.
> > 
> > I'm leaning towards your initial atomic_inc() approach for the
> > following reasons:
> > 
> > 1) It avoids the queue/unqueue dance in the error and (*uaddr != uval)
> >    case. The latter is the one you are optimizing for.
> > 
> >    We dirty the cache line in any case on the waiter side.
> > 
> >    With the optimized check, we avoid dirtying the cache line on the
> >    waker side in the case that there is no waiter in flight or
> >    enqueued.
> > 
> > 2) It's very simple to make it OPT-IN. That allows architectures to
> >    trade the mb/memory overhead with the spinlock contention overhead.
> > 
> >    A lot of [embedded] architectures do not care at all about the
> >    futex performance simply because they do not run futex sensitive
> >    workloads. And others might want to avoid the heavy smp_mb() for
> >    obvious reasons.
> > 
> >    Make that a CONFIG switch which can be selected by the user or by a
> >    select statement in the arch. That also allows archs to determine
> >    the costs of that optimization just by recompiling with a different
> >    .config.
> 
> Would it be useful to consider NR_CPUS? Sure, you get the problem of
> when it's too little or too big, but it would deal quite well for
> smaller systems - perhaps it could at least be mentioned in the option
> description/help. I don't think users should have a direct say in the
> option, though.

Right, it does not need to be user selectable. And thinking more about
it, it shouldn't be an issue for any architecture. It's pointless for
UP though. 

What might be interesting in terms of NR_CPUS is the hash table
size. That might want to scale with the system size.

Thanks,

	tglx

