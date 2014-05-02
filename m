Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaEBVZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:25:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:53419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbaEBVZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:25:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,974,1389772800"; 
   d="scan'208";a="505094135"
Subject: Re: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <5363F969.5060601@hurleysoftware.com>
References: <1398966637.2970.129.camel@schen9-DESK>
	 <5362AC24.9050508@hurleysoftware.com>
	 <1398985513.2970.141.camel@schen9-DESK>
	 <5363F969.5060601@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 May 2014 14:25:00 -0700
Message-ID: <1399065900.2970.182.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >   /*
> > + * Guide to the rw_semaphore's count field for common values.
> > + * (32 bit case illustrated, similar for 64 bit)
> 
> The values below are x86-specific; the actual defines are arch-dependent.
> Do other archs use different values?

This is also the value used also for generic case.  I don't see other
arch specific values defined.

> 
> > + *
> > + * 0x0000000X	(1) X readers active or attempting lock, no writer waiting
> > + *		    X = #active_readers + #readers attempting to lock
> > + *		    (X*ACTIVE_BIAS)
> 
> Not sure it matters, but maybe you want to note that it's possible for 0 readers
> to be active with this value, and all of the other readers may have initially
> failed to claim the lock but may be successful if one can claim the wait_lock while
> the count is still > 0.

I'll add the explanation for the down_read_failed scenario in
the note section below.

> 
> > + *
> > + * 0x00000000	rwsem is unlocked, and no one is waiting for the lock or
> > + *		attempting to read lock or write lock.
> > + *
> > + * 0xffff000X	(1) X readers active or attempt lock, there are waiters for lock
> > + *		    X = #active readers + # readers attempting lock
> > + *		    (X*ACTIVE_BIAS + WAITING_BIAS)
> > + *		(2) 1 writer attempting lock, no waiters for lock
> > + *		    X-1 = #active readers + #readers attempting lock
> > + *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
> > + *		(3) 1 writer active, no waiters for lock
> > + *		    X-1 = #active readers + #readers attempting lock
> > + *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
> > + *
> > + * 0xffff0001	(1) 1 reader active or attempting lock, waiters for lock
> > + *		    (WAITING_BIAS + ACTIVE_BIAS)
> > + *		(2) 1 writer active or attempt lock, no waiters for lock
> > + *		    (ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
> > + *
> > + * 0xffff0000	(1) There are writers or readers queued but none active
> > + *		    or in the process of attempting lock.
> > + *		    (WAITING_BIAS)
> > + *		Note: writer can attempt to steal lock for this count by adding
> > + *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
> > + *
> > + * 0xfffe0001	(1) 1 writer active, or attempting lock. Waiters on queue.
> > + *		    (ACTIVE_WRITE_BIAS + WAITING_BIAS)
> 
> The count can have more values than just 0xfffe0001 because multiple
> failed write lock attempts plus failed read lock attempts can produce other
> values than those listed.

You're correct.  The values are not comprehensive.  I tried to show the common 
ones and how they arose.  How about I replace the 0xfffe0001 case with
	
count < WAITING_BIAS
	(1) X writer active, Y writers attempting lock, Z readers attempting lock, no waiters
		where X = 0 or 1, (X+Y) >= 2, Z >= 0
		(X+Y) * ACTIVE_WRITE_BIAS + Z * ACTIVE_BIAS
	(2) X writer active, Y writers attempting lock, Z readers attempting lock, with waiters
		where X = 0 or 1, (X+Y) >= 1, Z >= 0
		(X+Y) * ACTIVE_WRITE_BIAS + Z * ACTIVE_BIAS + WAITING_BIAS

Thanks.

Tim


