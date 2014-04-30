Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbaD3QRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:17:46 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:36058 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076AbaD3QRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:17:45 -0400
Message-ID: <1398874657.2618.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 09:17:37 -0700
In-Reply-To: <20140430082715.GA11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140430082715.GA11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 10:27 +0200, Peter Zijlstra wrote:
> On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
> > +/*
> > + * Try to acquire write lock before the writer has been put on wait queue.
> > + */
> > +static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
> > +{
> > +	long count = ACCESS_ONCE(sem->count);
> > +retry:
> > +	if (count == RWSEM_WAITING_BIAS) {
> > +		count = cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > +			    RWSEM_ACTIVE_WRITE_BIAS + RWSEM_WAITING_BIAS);
> > +		/* allow write lock stealing, try acquiring the write lock. */
> > +		if (count == RWSEM_WAITING_BIAS)
> > +			goto acquired;
> > +		else if (count == 0)
> > +			goto retry;
> > +	} else if (count == 0) {
> > +		count = cmpxchg(&sem->count, 0, RWSEM_ACTIVE_WRITE_BIAS);
> > +		if (count == 0)
> > +			goto acquired;
> > +		else if (count == RWSEM_WAITING_BIAS)
> > +			goto retry;
> > +	}
> > +	return false;
> > +
> > +acquired:
> > +	return true;
> > +}
> 
> Could we have written that like:
> 
> static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
> {
> 	long old, count = ACCESS_ONCE(sem->count);
> 
> 	for (;;) {
> 		if (!(count == 0 || count == RWSEM_WAITING_BIAS))
> 			return false;
> 
> 		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_BIAS);
> 		if (old == count)
> 			return true;
> 
> 		count = old;
> 	}
> }
> 
> ?

Yeah that's a lot nicer.

