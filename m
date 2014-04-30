Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049AbaD3VGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:06:39 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:40402 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945914AbaD3VGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:06:37 -0400
Message-ID: <1398891992.10827.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 14:06:32 -0700
In-Reply-To: <1398891699.2970.110.camel@schen9-DESK>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140430082715.GA11096@twins.programming.kicks-ass.net>
	 <1398880209.2970.100.camel@schen9-DESK>
	 <20140430180441.GF17778@laptop.programming.kicks-ass.net>
	 <1398881337.2970.103.camel@schen9-DESK>
	 <1398891699.2970.110.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 14:01 -0700, Tim Chen wrote:
> On Wed, 2014-04-30 at 11:08 -0700, Tim Chen wrote:
> > On Wed, 2014-04-30 at 20:04 +0200, Peter Zijlstra wrote:
> > > On Wed, Apr 30, 2014 at 10:50:09AM -0700, Tim Chen wrote:
> > > > On Wed, 2014-04-30 at 10:27 +0200, Peter Zijlstra wrote:
> > > > > On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
> > > > > > +/*
> > > > > > + * Try to acquire write lock before the writer has been put on wait queue.
> > > > > > + */
> > > > > > +static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
> > > > > > +{
> > > > > > +	long count = ACCESS_ONCE(sem->count);
> > > > > > +retry:
> > > > > > +	if (count == RWSEM_WAITING_BIAS) {
> > > > > > +		count = cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > > > > > +			    RWSEM_ACTIVE_WRITE_BIAS + RWSEM_WAITING_BIAS);
> > > 
> > > count = RWSEM_WAITING_BIAS
> > > new = RWSEM_WAITING_BIAS + RWSEM_ACTIVE_WRITE_BIAS
> > > new = count + RWSEM_ACTIVE_WRITE_BIAS
> > > 
> > > > > > +		/* allow write lock stealing, try acquiring the write lock. */
> > > > > > +		if (count == RWSEM_WAITING_BIAS)
> > > > > > +			goto acquired;
> > > > > > +		else if (count == 0)
> > > > > > +			goto retry;
> > > > > > +	} else if (count == 0) {
> > > > > > +		count = cmpxchg(&sem->count, 0, RWSEM_ACTIVE_WRITE_BIAS);
> > > 
> > > count = 0
> > > new = RWSEM_ACTIVE_WRITE_BIAS
> > > new = count + RWSEM_ACTIVE_WRITE_BIAS
> > > 
> > > > > > +		if (count == 0)
> > > > > > +			goto acquired;
> > > > > > +		else if (count == RWSEM_WAITING_BIAS)
> > > > > > +			goto retry;
> > > > > > +	}
> > > > > > +	return false;
> > > > > > +
> > > > > > +acquired:
> > > > > > +	return true;
> > > > > > +}
> > > > > 
> > > > > Could we have written that like:
> > > > > 
> > > > > static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
> > > > > {
> > > > > 	long old, count = ACCESS_ONCE(sem->count);
> > > > > 
> > > > > 	for (;;) {
> > > > > 		if (!(count == 0 || count == RWSEM_WAITING_BIAS))
> > > > > 			return false;
> > > > > 
> > > > > 		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_BIAS);
> > > > 
> > > > Above line won't be correct for the case when count == 0.  We are trying 
> > > > to acquire write lock, so the sem->count should become
> > > > RWSEM_ACTIVE_WRITE_BIAS, or RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS.  
> > > > So we should change the logic to
> > > > 
> > > > 		  if (count == RWSEM_WAITING_BIAS)
> > > > 			old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_BIAS);
> > > > 		  else
> > > > 			old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
> > > 
> > > I think I simply mis-typed it; shouldn't both cases be
> > > RWSEM_ACTIVE_WRITE_BIAS ?
> > 
> > Yeah,  we should just write it as
> > 			  old = cmpxchg(&sem->count, count, RWSEM_ACTIVE_WRITE_BIAS);
> 
> Oops, I mean
> 			    old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
> 
> for count == 0, we need sem->count to be RWSEM_ACTIVE_WRITE_BIAS, 
> for count == RWSEM_WAITING_BIAS, we need sem->count to be  RWSEM_WAITING_BIAS + RWSEM_ACTIVE_WRITE_BIAS

Yep, I had just noticed this. Peter's original suggestion was correct,
just needed to change RWSEM_ACTIVE_BIAS for RWSEM_ACTIVE_WRITE_BIAS.

