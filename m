Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3FKRyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:54:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49372 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab3FKRyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:54:08 -0400
Date: Tue, 11 Jun 2013 10:52:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org,
        walken@google.com, waiman.long@hp.com
Subject: Re: [PATCH RFC ticketlock] v2 Auto-queued ticketlock
Message-ID: <20130611175253.GR5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <20130611170249.GA1091@linux.vnet.ibm.com>
 <1370972187.9844.205.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370972187.9844.205.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061117-5806-0000-0000-000021A8082D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 01:36:27PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 10:02 -0700, Paul E. McKenney wrote:
> 
> > +#ifdef CONFIG_TICKET_LOCK_QUEUED
> > +
> > +#define __TKT_SPIN_INC 2
> > +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
> > +
> > +#else /* #ifdef CONFIG_TICKET_LOCK_QUEUED */
> > +
> > +#define __TKT_SPIN_INC 1
> > +static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> > +{
> > +	return false;
> > +}
> > +
> > +#endif /* #else #ifdef CONFIG_TICKET_LOCK_QUEUED */
> > +
> >  /*
> >   * Ticket locks are conceptually two parts, one indicating the current head of
> >   * the queue, and the other indicating the current tail. The lock is acquired
> > @@ -49,17 +64,15 @@
> >   */
> >  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
> >  {
> > -	register struct __raw_tickets inc = { .tail = 1 };
> > +	register struct __raw_tickets inc = { .tail = __TKT_SPIN_INC };
> >  
> >  	inc = xadd(&lock->tickets, inc);
> > -
> >  	for (;;) {
> > -		if (inc.head == inc.tail)
> > +		if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
> >  			break;
> > -		cpu_relax();
> 
> Overheating the CPU are we ;-)
> 
> Keeping the cpu_relax() doesn't hurt, even when TICKET_LOCK_QUEUE is
> enabled. As the only latency to worry about is when tkt_spin_pass()
> returns true, where it breaks out of the loop anyway.
> 
> But if you really don't want the double call to cpu_relax(), we can
> probably remove the cpu_relax from tkt_spin_pass() and keep this one, or
> in the above tkt_spin_pass() where TICK_LOCK_QUEUED is not set, we can
> do:
> 
> static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct
> __raw_tickets inc)
> {
> 	cpu_relax();
> 	return false;
> }
> 
> Honesty, I would say remove it from tkt_spin_pass() when returning
> false.

Sold!  I moved the cpu_relax() from tkt_spin_pass()'s false return to
the spin loop in __ticket_spin_lock().  Misguided attempt on my part to
minimize __ticket_spin_lock()'s size.

							Thanx, Paul

> -- Steve
> 
> 
> >  		inc.head = ACCESS_ONCE(lock->tickets.head);
> >  	}
> > -	barrier();		/* make sure nothing creeps before the lock is taken */
> > +	barrier(); /* Make sure nothing creeps in before the lock is taken. */
> >  }
> >  
> 
> 

