Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3FJVah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:30:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38875 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3FJVag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:30:36 -0400
Date: Mon, 10 Jun 2013 14:30:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130610213023.GS5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370898505.9844.123.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370898505.9844.123.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061021-5806-0000-0000-000021A33177
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 05:08:25PM -0400, Steven Rostedt wrote:
> On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> >  
> > +#else /* #ifndef CONFIG_TICKET_LOCK_QUEUED */
> > +
> > +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
> > +
> > +static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
> > +{
> > +	register struct __raw_tickets inc = { .tail = 2 };
> > +
> > +	inc = xadd(&lock->tickets, inc);
> > +	for (;;) {
> > +		if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
> > +			break;
> > +		inc.head = ACCESS_ONCE(lock->tickets.head);
> > +	}
> > +	barrier(); /* smp_mb() on Power or ARM. */
> > +}
> > +
> > +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
> > +
> 
> To avoid the above code duplication, I would have this instead:

Nice!  I have updated accordingly.

							Thanx, Paul

> #ifdef CONFIG_TICKET_LOCK_QUEUED
> 
> bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
> #define __TKT_SPIN_INC 2
> 
> #else
> 
> static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct
> __raw_tickets inc)
> {
> 	return false;
> }
> 
> #define __TKT_SPIN_INC 1
> 
> #endif
> 
> static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
> {
> 	register struct __raw_tickets inc = { .tail = __TKT_SPIN_INC };
> 
> 	inc = xadd(&lock->tickets, inc);
> 
> 	for (;;) {
> 		if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
> 			break;
> 		cpu_relax();
> 		inc.head = ACCESS_ONCE(lock->tickets.head);
> 	}
> 	barrier;	/* make sure nothing creeps before the lock is taken */
> }
> 
> -- Steve
> 
> 

