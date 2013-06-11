Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3FKPPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:15:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50959 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3FKPPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:15:37 -0400
Date: Tue, 11 Jun 2013 08:00:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611150032.GA1762@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <20130611095655.GA5146@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611095655.GA5146@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061115-5406-0000-0000-0000096F2D2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 02:56:55AM -0700, Paul E. McKenney wrote:
> On Mon, Jun 10, 2013 at 08:44:40PM -0400, Steven Rostedt wrote:
> > On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:

[ . . . ]

> > > +bool tkt_q_do_spin(arch_spinlock_t *asp, struct __raw_tickets inc)
> > > +{
> > > +	struct tkt_q **oldtail;
> > > +	struct tkt_q tq;
> > > +	struct tkt_q_head *tqhp;
> > > +
> > > +	/*
> > > +	 * Ensure that accesses to queue header happen after sensing
> > > +	 * the lock's have-queue bit.
> > > +	 */
> > > +	smp_mb();  /* See above block comment. */
> > > +
> > > +	/* If there no longer is a queue, leave. */
> > > +	tqhp = tkt_q_find_head(asp);
> > > +	if (tqhp == NULL)
> > > +		return false;
> > > +
> > > +	/* Initialize our queue element. */
> > > +	tq.cpu = raw_smp_processor_id();
> > > +	tq.tail = inc.tail;
> > > +	tq.next = NULL;
> > > +
> > > +	/* Check to see if we already hold the lock. */
> > > +	if (ACCESS_ONCE(tqhp->head_tkt) == inc.tail) {
> > > +		/* The last holder left before queue formed, we hold lock. */
> > > +		tqhp->head_tkt = -1;
> > > +		return true;
> > > +	}
> > > +
> > > +	/* Add our element to the tail of the queue. */
> > > +	oldtail = xchg(&tqhp->spin_tail, &tq.next);
> > 
> > Boy this is tricky code! I thought I found a race window here, but as I
> > went to write my email saying "Gotcha!" I found that it wasn't a race
> > after all. But as I went though the effort of writing this, I figured I
> > would send this out as documentation for others to see. Hmm, I wonder if
> > we can use this email to add more comments. Anyway, here's what I
> > thought was wrong ;-)
> 
> If you didn't know any better, you might even think that I had done
> something like this before.  ;-)
> 
> > OK, I originally thought there was a race window here. Let's say that an
> > NMI hit right here, and it happens to be a big one, where lots of things
> > can happen on other CPUs right now.
> > 
> > The scenario is that there's just one item on the queue, which is
> > waiting for the lock to be released, and is spinning below in the:
> > 
> > 	while (ACCESS_ONCE(tq.cpu) != -1)
> > 		cpu_relax();
> > 
> > And then the lock is released, where in tkt_q_do_wake() the following is
> > called:
> > 
> > 	ACCESS_ONCE(tqp->cpu) = -1;
> > 
> > Now the old queued task is released. But it's tq->next hasn't been set
> > yet, and is still NULL. It leaves by doing:
> > 
> > 	ACCESS_ONCE(tqhp->spin) = tq.next;
> > 	return true;
> > 
> > All before this task gets to set *oldtail to &tq. But, I then looked
> > below...
> > 
> > 
> > > +	ACCESS_ONCE(*oldtail) = &tq;
> > > +
> > > +	/* Spin until handoff. */
> > > +	while (ACCESS_ONCE(tq.cpu) != -1)
> > > +		cpu_relax();
> > > +
> > > +	/*
> > > +	 * Remove our element from the queue.  If the queue is now empty,
> > > +	 * update carefully so that the next acquisition will queue itself
> > > +	 * at the head of the list.
> > > +	 */
> > > +	if (tq.next == NULL) {
> > 
> > This checks for that scenario.
> 
> Yep!
> 
> >                                As if the old task were to come out
> > spinning, the problem would only be if it was the last one on the list,
> > and its tq.next was NULL. But if that was the case, then we set spin to
> > NULL and do the next trick, where I thought I gotcha again...
> > 
> > 
> > > +
> > > +		/* Mark the queue empty. */
> > > +		tqhp->spin = NULL;
> > > +
> > > +		/* Try to point the tail back at the head. */
> > > +		if (cmpxchg(&tqhp->spin_tail,
> > > +			    &tq.next,
> > > +			    &tqhp->spin) == &tq.next)
> > 
> > Here, I was thinking, oh wait, what happens if this is called right
> > before the xchg() above. Then we would set spin_tail but not update the
> > old tq.next. But wait! look at what we assign spin_tail to. It's the
> > address of spin, which would be what oldtail would point to above, and
> > then above would set spin to the new tq!
> 
> Yep again!
> 
> > OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> > don't like trickssy, and we must find precccciouss!!!
> > 
> > 
> > This code is starting to make me look like Gollum :-p
> 
> Hmmm...  The time and effort to do this might almost have been worthwhile
> just to accomplish that!  ;-)
> 
> But yes, this would need better comments, design documentation, or
> maybe both.

And for whatever it might be worth, here is an attempted upgrade for
comments.

First, I upgrade the comment for the xchg() that does the enqueue:

	/*
	 * Add our element to the tail of the queue.  Note that if the
	 * queue is empty, the ->spin_tail pointer will reference
	 * the queue's head pointer, namely ->spin.
	 */
	oldtail = xchg(&tqhp->spin_tail, &tq.next);
	ACCESS_ONCE(*oldtail) = &tq;

Next, I upgrade the comment for the dequeue operation:

	/*
	 * Remove our element from the queue.  If the queue is now empty,
	 * update carefully so that the next acquisition will enqueue itself
	 * at the head of the list.  Of course, the next enqueue operation
	 * might be happening concurrently, and this code needs to handle all
	 * of the possible combinations, keeping in mind that the enqueue
	 * operation happens in two stages: (1) update the tail pointer and
	 * (2) update the predecessor's ->next pointer.  With this in mind,
	 * the following code needs to deal with three scenarios:
	 *
	 * 1.	tq is the last entry.  In this case, we use cmpxchg to
	 *	point the list tail back to the list head (->spin).  If
	 * 	the cmpxchg fails, that indicates that we are instead
	 *	in scenario 2 below.  If the cmpxchg succeeds, the next
	 *	enqueue operation's tail-pointer exchange will enqueue
	 *	the next element at the queue head, because the ->spin_tail
	 *	pointer now references the queue head.
	 *
	 * 2.	tq is the last entry, and the next entry has updated the
	 *	tail pointer but has not yet updated tq.next.  In this
	 *	case, tq.next is NULL, the cmpxchg will fail, and the
	 *	code will wait for the enqueue to complete before completing
	 *	removal of tq from the list.
	 *
	 * 3.	tq is not the last pointer.  In this case, tq.next is non-NULL,
	 *	so the following code simply removes tq from the list.
	 */
	if (tq.next == NULL) {

		/* Mark the queue empty. */
		tqhp->spin = NULL;

		/* Try to point the tail back at the head. */
		if (cmpxchg(&tqhp->spin_tail,
			    &tq.next,
			    &tqhp->spin) == &tq.next)
			return true; /* Succeeded, queue is now empty. */

		/* Failed, if needed, wait for the enqueue to complete. */
		while (tq.next == NULL)
			cpu_relax();

		/* The following code will repair the head. */
	}
	smp_mb(); /* Force ordering between handoff and critical section. */

	/*
	 * Advance list-head pointer.  This same task will be the next to
	 * access this when releasing the lock, so no need for a memory
	 * barrier after the following assignment.
	 */
	ACCESS_ONCE(tqhp->spin) = tq.next;
	return true;
}

							Thanx, Paul

