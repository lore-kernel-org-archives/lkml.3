Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3KYSz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:55:29 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34118 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3KYSz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:55:27 -0500
Message-ID: <1385405723.15768.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        "Norton, Scott J" <scott.norton@hp.com>, tom.vaden@hp.com,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 10:55:23 -0800
In-Reply-To: <alpine.DEB.2.02.1311251803040.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
	 <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
	 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
	 <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com>
	 <alpine.DEB.2.02.1311251715490.30673@ionos.tec.linutronix.de>
	 <20131125163627.GC10022@twins.programming.kicks-ass.net>
	 <alpine.DEB.2.02.1311251803040.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 18:32 +0100, Thomas Gleixner wrote:
> On Mon, 25 Nov 2013, Peter Zijlstra wrote:
> > On Mon, Nov 25, 2013 at 05:23:51PM +0100, Thomas Gleixner wrote:
> > > On Sat, 23 Nov 2013, Linus Torvalds wrote:
> > > 
> > > > On Sat, Nov 23, 2013 at 5:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > >
> > > > > Now the question is why we queue the waiter _AFTER_ reading the user
> > > > > space value. The comment in the code is pretty non sensical:
> > > > >
> > > > >    * On the other hand, we insert q and release the hash-bucket only
> > > > >    * after testing *uaddr.  This guarantees that futex_wait() will NOT
> > > > >    * absorb a wakeup if *uaddr does not match the desired values
> > > > >    * while the syscall executes.
> > > > >
> > > > > There is no reason why we cannot queue _BEFORE_ reading the user space
> > > > > value. We just have to dequeue in all the error handling cases, but
> > > > > for the fast path it does not matter at all.
> > > > >
> > > > > CPU 0                                   CPU 1
> > > > >
> > > > >     val = *futex;
> > > > >     futex_wait(futex, val);
> > > > >
> > > > >     spin_lock(&hb->lock);
> > > > >
> > > > >     plist_add(hb, self);
> > > > >     smp_wmb();
> > > > >
> > > > >     uval = *futex;
> > > > >                                         *futex = newval;
> > > > >                                         futex_wake();
> > > > >
> > > > >                                         smp_rmb();
> > > > >                                         if (plist_empty(hb))
> > > > >                                            return;
> > > > > ...
> > > > 
> > > > This would seem to be a nicer approach indeed, without needing the
> > > > extra atomics.
> > > 
> > > I went through the issue with Peter and he noticed, that we need
> > > smp_mb() in both places. That's what we have right now with the
> > > spin_lock() and it is required as we need to guarantee that
> > > 
> > >  The waiter observes the change to the uaddr value after it added
> > >  itself to the plist
> > > 
> > >  The waker observes plist not empty if the change to uaddr was made
> > >  after the waiter checked the value.
> > > 
> > > 
> > > 	write(plist)		|	write(futex_uaddr)
> > > 	mb()			|	mb()
> > > 	read(futex_uaddr)	|	read(plist)
> > > 
> > > The spin_lock mb() on the waiter side does not help here because it
> > > happpens before the write(plist) and not after it.
> > 
> > Ah, note that spin_lock() is only a smp_mb() on x86, in general its an
> > ACQUIRE barrier which is weaker than a full mb and will not suffice in
> > this case even it if were in the right place.
> 
> So now the question is whether this lockless empty check optimization
> which seems to be quite nice on x86 for a particular workload will
> have any negative side effects on other architectures.
> 
> If the smp_mb() is heavy weight, then it will hurt massivly in the
> case where the hash bucket is not empty, because we add the price for
> the smp_mb() just for no gain.
> 
> In that context it would also be helpful to measure the overhead on
> x86 for the !empty case.

Absolutely, I will add these comparisons. If we do notice that we end up
hurting the !empty case, would the current patch using atomic ops still
be considered? We have made sure that none of the changes in this set
affects performance on other workloads/smaller systems.

Thanks,
Davidlohr

