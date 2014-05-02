Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaEBQJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:09:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:20981 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbaEBQJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="504961466"
Subject: Re: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <53639958.9030002@infradead.org>
References: <1398966637.2970.129.camel@schen9-DESK>
	 <5362AC24.9050508@hurleysoftware.com>
	 <1398985513.2970.141.camel@schen9-DESK>  <53639958.9030002@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 May 2014 09:09:02 -0700
Message-ID: <1399046942.2970.144.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 06:10 -0700, Randy Dunlap wrote:

> >
> > It takes me quite a while to understand how rwsem's count field mainifest
> 
>                                                                 manifests
> 
> > itself in different scenarios.  I'm adding comments to provide a quick
> > reference on the the rwsem's count field for each scenario where readers
> > and writers are contending for the lock.  Hopefully it will be useful
> > for future maintenance of the code and for people to get up to speed on
> > how the logic in the code works.
> >
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > ---
> >   kernel/locking/rwsem-xadd.c | 48 +++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 48 insertions(+)
> >
> > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > index 1d66e08..b92a403 100644
> > --- a/kernel/locking/rwsem-xadd.c
> > +++ b/kernel/locking/rwsem-xadd.c
> > @@ -12,6 +12,54 @@
> >   #include <linux/export.h>
> >
> >   /*
> > + * Guide to the rw_semaphore's count field for common values.
> > + * (32 bit case illustrated, similar for 64 bit)
> 
>         32-bit                               64-bit
> 
> > + *
> > + * 0x0000000X	(1) X readers active or attempting lock, no writer waiting
> > + *		    X = #active_readers + #readers attempting to lock
> > + *		    (X*ACTIVE_BIAS)
> > + *
> > + * 0x00000000	rwsem is unlocked, and no one is waiting for the lock or
> > + *		attempting to read lock or write lock.
> > + *
> > + * 0xffff000X	(1) X readers active or attempt lock, there are waiters for lock
> 
> 			                        attempting
> 
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
> 
> 		                       attempting
> 
> > + *		    (ACTIVE_BIAS + ACTIVE_WRITE_BIAS)

Oops, should be       (ACTIVE_WRITE_BIAS)

> > + *
> > + * 0xffff0000	(1) There are writers or readers queued but none active
> > + *		    or in the process of attempting lock.
> > + *		    (WAITING_BIAS)
> > + *		Note: writer can attempt to steal lock for this count by adding
> > + *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
> > + *
> > + * 0xfffe0001	(1) 1 writer active, or attempting lock. Waiters on queue.
> > + *		    (ACTIVE_WRITE_BIAS + WAITING_BIAS)
> > + *
> > + * Note: Reader attempt to lock by adding ACTIVE_BIAS in down_read and checking
> > + *	 the count becomes more than 0, i.e. the case where there are only
> > + *	 readers or no body has lock. (1st and 2nd case above)
> 
> 	            nobody
> 
> > + *
> > + *	 Writer attempt to lock by adding ACTIVE_WRITE_BIAS in down_write and
> > + *	 checking the count becomes ACTIVE_WRITE_BIAS for succesful lock
> 
> 	                                                  successful

Thanks for correcting my grammar mistakes.  Will update the changes.

Tim



