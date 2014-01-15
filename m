Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaAOUh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:37:28 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56946 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaAOUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:37:23 -0500
Date: Wed, 15 Jan 2014 12:37:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, mingo@redhat.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        aswin@hp.com, scott.norton@hp.com
Subject: Re: [RFC 1/3] mutex: In mutex_can_spin_on_owner(), return false if
 task need_resched()
Message-ID: <20140115203702.GD10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
 <1389745990-7069-2-git-send-email-jason.low2@hp.com>
 <20140115074420.GV31570@twins.programming.kicks-ass.net>
 <20140115074844.GA3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115074844.GA3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011520-1344-0000-0000-000004F798FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 08:48:44AM +0100, Peter Zijlstra wrote:
> On Wed, Jan 15, 2014 at 08:44:20AM +0100, Peter Zijlstra wrote:
> > On Tue, Jan 14, 2014 at 04:33:08PM -0800, Jason Low wrote:
> > > The mutex_can_spin_on_owner() function should also return false if the
> > > task needs to be rescheduled.
> > > 
> > 
> > While I was staring at mutex_can_spin_on_owner(); don't we need this?
> > 
> >  kernel/locking/mutex.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> > index 4dd6e4c219de..480d2f437964 100644
> > --- a/kernel/locking/mutex.c
> > +++ b/kernel/locking/mutex.c
> > @@ -214,8 +214,10 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
> >  
> >  	rcu_read_lock();
> >  	owner = ACCESS_ONCE(lock->owner);
> > -	if (owner)
> > +	if (owner) {
> 
> That is, its an unmatched barrier, as mutex_set_owner() doesn't include
> a barrier, and I don't think i needs to; but on alpha we still need this
> read barrier to ensure we do not mess up this related load afaik.
> 
> Paul? can you explain an unpaired read_barrier_depends?

That is an impressive one!  ;-)

My rationale for the code without smp_read_barrier_depends() is that
(1) the task struct was already exposed to readers and (2) the check
is heuristic in nature -- if we miss the assignment to ->on_cpu due
to memory order (or for any other reason), we just sleep unnecessarily.

If we did need full ordering (which I do -not- believe that we do at
the moment) then the above ACCESS_ONCE() can become rcu_dereference()
and mutex_set_owner() needs an smp_store_release().

So if we need a barrier here (which again I believe we do not), then
there needs to be a paired barrier in mutex_set_owner().

						Thanx, Paul

> > +		smp_read_barrier_depends();
> >  		retval = owner->on_cpu;
> > +	}
> >  	rcu_read_unlock();
> >  	/*
> >  	 * if lock->owner is not set, the mutex owner may have just acquired
> 

