Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3FKUdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:33:18 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49015 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368Ab3FKUdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:33:14 -0400
Date: Tue, 11 Jun 2013 13:32:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611203256.GE5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <51B748DA.2070306@hp.com>
 <20130611163607.GG5146@linux.vnet.ibm.com>
 <51B76F77.6020004@hp.com>
 <20130611194927.GX5146@linux.vnet.ibm.com>
 <1370981396.9844.219.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370981396.9844.219.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061120-5806-0000-0000-000021A8F31E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:09:56PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 12:49 -0700, Paul E. McKenney wrote:
> 
> > +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> > +{
> > +	if (unlikely(inc.head & 0x1)) {
> > +
> > +		/* This lock has a queue, so go spin on the queue. */
> > +		if (tkt_q_do_spin(ap, inc))
> > +			return true;
> > +
> > +		/* Get here if the queue is in transition: Retry next time. */
> > +
> 
> This looks better, but please add a comment, something to the likes of:
> 
> 	/*
> 	 * Only the TKT_Q_SWITCH waiter will set up the queue to prevent
> 	 * a thundering herd of setups to occur. It is still possible for
> 	 * more than one task to perform a setup if the lock is released
> 	 * after this check, a waiter coming in may also match this test. But
> 	 * that's covered by the cmpxchg() setup in tkt_q_start_contend.
> 	 */
> 
> > +	} else if (inc.tail - TKT_Q_SWITCH == inc.head) {
> 
> Also shouldn't this be:
> 
> 	} else if ((__ticket_t)(inc.tail - TKT_Q_SWITCH) == inc.head) {

Good points on the comment, here is what I currently have:

	} else if (inc.tail - TKT_Q_SWITCH == inc.head) {

		/*
		 * This lock has lots of spinners, but no queue.  Go create
		 * a queue to spin on.
		 *
		 * In the common case, only the single task that
		 * sees the head and tail tickets being different by
		 * exactly TKT_Q_SWITCH will come here set up the queue,
		 * which prevents a "thundering herd" of queue setups.
		 * Although it is still possible for an unfortunate series
		 * of lock handoffs and newly arrived tasks to result
		 * in more than one task performing a queue setup, this
		 * is unlikely.  Of course, this situation must still be
		 * handled correctly, which is the job of the cmpxchg()
		 * in tkt_q_start_contend().
		 */
		if (tkt_q_start_contend(ap, inc))
			return true;

Does that help?

> As TKT_Q_SWITCH doesn't have a type, I'm not sure how C will evaluate
> this. I always screw type conversions up, and just add in the type casts
> to be safe.
> 
> You could also give TKT_Q_SWITCH a type too.

This is an excellent point as well -- things might well get confused.
My solution was to take your last suggestion and given TKT_Q_SWITCH the
same type as inc.tail and inc.head, and also apply type-safety paranoia
to TKT_Q_NQUEUES:

/*
 * TKT_Q_SWITCH is twice the number of CPUs that must be spinning on a
 * given ticket lock to motivate switching to spinning on a queue.
 * The reason that it is twice the number is because the bottom bit of
 * the ticket is reserved for the bit that indicates that a queue is
 * associated with the lock.
 */
#define TKT_Q_SWITCH  ((__ticket_t)(CONFIG_TICKET_LOCK_QUEUED_SWITCH * 2))

/*
 * TKT_Q_NQUEUES is the number of queues to maintain.  Large systems
 * might have multiple highly contended locks, so provide more queues for
 * systems with larger numbers of CPUs.
 */
#define TKT_Q_NQUEUES (2 * DIV_ROUND_UP(NR_CPUS + ((int)TKT_Q_SWITCH) - 1, \
					(int)TKT_Q_SWITCH))

Does that look OK?  (The limits on the value of TKT_Q_SWITCH should avoid
signed integer overflow.)

							Thanx, Paul

> -- Steve
> 
> > +
> > +		/*
> > +		 * This lock has lots of spinners, but no queue.
> > +		 * Go create a queue to spin on.
> > +		 */
> > +		if (tkt_q_start_contend(ap, inc))
> > +			return true;
> > +
> > +		/* Get here if the queue is in transition: Retry next time. */
> > +	}
> > +
> > +	/* Either no need for a queue or the queue is in transition.  Spin. */
> > +	return false;
> > +}
> > +EXPORT_SYMBOL(tkt_spin_pass);
> 
> 

