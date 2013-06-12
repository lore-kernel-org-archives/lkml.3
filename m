Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3FLB6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:58:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3FLB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:58:11 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=lR8XWyAi4B0eAeDuLXAA:9 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371002288.9844.246.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Waiman Long <waiman.long@hp.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Date: Tue, 11 Jun 2013 21:58:08 -0400
In-Reply-To: <CACvQF51s+xsP9XX2V7ASEe+T3qH1n9Gzatf5k9Fzr=ehma8baQ@mail.gmail.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <51B748DA.2070306@hp.com> <20130611163607.GG5146@linux.vnet.ibm.com>
	 <51B76F77.6020004@hp.com> <20130611194927.GX5146@linux.vnet.ibm.com>
	 <CACvQF51s+xsP9XX2V7ASEe+T3qH1n9Gzatf5k9Fzr=ehma8baQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 09:19 +0800, Lai Jiangshan wrote:

> > +
> > +/*
> > + * Hand the lock off to the first CPU on the queue.
> > + */
> > +void tkt_q_do_wake(arch_spinlock_t *lock)
> > +{
> > +       struct tkt_q_head *tqhp;
> > +       struct tkt_q *tqp;
> > +
> > +       /* If the queue is still being set up, wait for it. */
> > +       while ((tqhp = tkt_q_find_head(lock)) == NULL)
> > +               cpu_relax();
> > +
> > +       for (;;) {
> > +
> > +               /* Find the first queue element. */
> > +               tqp = ACCESS_ONCE(tqhp->spin);
> > +               if (tqp != NULL)
> > +                       break;  /* Element exists, hand off lock. */
> > +               if (tkt_q_try_unqueue(lock, tqhp))
> > +                       return; /* No element, successfully removed queue. */
> > +               cpu_relax();
> > +       }
> > +       if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> > +               ACCESS_ONCE(tqhp->head_tkt) = -1;
> > +       smp_mb(); /* Order pointer fetch and assignment against handoff. */
> > +       ACCESS_ONCE(tqp->cpu) = -1;
> > +}
> > +EXPORT_SYMBOL(tkt_q_do_wake);
> > +
> > +/*
> > + * Given a lock that already has a queue associated with it, spin on
> > + * that queue.  Return false if there was no queue (which means we do not
> > + * hold the lock) and true otherwise (meaning we -do- hold the lock).
> > + */
> > +bool tkt_q_do_spin(arch_spinlock_t *lock, struct __raw_tickets inc)
> > +{
> > +       struct tkt_q **oldtail;
> > +       struct tkt_q tq;
> > +       struct tkt_q_head *tqhp;
> > +
> > +       /*
> > +        * Ensure that accesses to queue header happen after sensing
> > +        * the lock's have-queue bit.
> > +        */
> > +       smp_mb();  /* See above block comment. */
> > +
> > +       /* If there no longer is a queue, leave. */
> > +       tqhp = tkt_q_find_head(lock);
> > +       if (tqhp == NULL)
> > +               return false;
> > +
> > +       /* Initialize our queue element. */
> > +       tq.cpu = raw_smp_processor_id();
> > +       tq.tail = inc.tail;
> > +       tq.next = NULL;
> 
> I guess a mb() is needed here for between read tqhp->ref and read
> tqhp->head_tkt.
> you can move the above mb() to here.

Do we?

The only way to get into here is if you either set up the queue
yourself, or you saw the LSB set in head.

If you were the one to set it up yourself, then there's nothing to worry
about because you are also the one that set head_tkt.

If you didn't set up the queue, then someone else set the LSB in head,
which is done with a cmpxchg() which is also a full mb. This would make
head_tkt visible as well because it's set before cmpxchg is called.

Thus, to come into this function you must have seen head & 1 set, and
the smp_mb() above will also make head_tkt visible.

The only thing I can see now is that it might not find tqhp because ref
may not be set yet. If that's the case, then it will fall out back to
the main loop. But if it finds ref, then I don't see how it can't see
head_tkt up to date as well.

Maybe I'm missing something.

-- Steve


> 
> > +
> > +       /* Check to see if we already hold the lock. */
> > +       if (ACCESS_ONCE(tqhp->head_tkt) == inc.tail) {
> > +               /* The last holder left before queue formed, we hold lock. */
> > +               tqhp->head_tkt = -1;
> > +               return true;
> > +       }
> > +
> > +       /*
> > +        * Add our element to the tail of the queue.  Note that if the
> > +        * queue is empty, the ->spin_tail pointer will reference
> > +        * the queue's head pointer, namely ->spin.
> > +        */
> > +       oldtail = xchg(&tqhp->spin_tail, &tq.next);
> > +       ACCESS_ONCE(*oldtail) = &tq;
> > +
> > +       /* Spin until handoff. */
> > +       while (ACCESS_ONCE(tq.cpu) != -1)
> > +               cpu_relax();
> > +
> > +       /*
> > +        * Remove our element from the queue.  If the queue is now empty,
> > +        * update carefully so that the next acquisition will enqueue itself
> > +        * at the head of the list.  Of course, the next enqueue operation
> > +        * might be happening concurrently, and this code needs to handle all
> > +        * of the possible combinations, keeping in mind that the enqueue
> > +        * operation happens in two stages: (1) update the tail pointer and
> > +        * (2) update the predecessor's ->next pointer.  With this in mind,
> > +        * the following code needs to deal with three scenarios:
> > +        *
> > +        * 1.   tq is the last entry.  In this case, we use cmpxchg to
> > +        *      point the list tail back to the list head (->spin).  If
> > +        *      the cmpxchg fails, that indicates that we are instead
> > +        *      in scenario 2 below.  If the cmpxchg succeeds, the next
> > +        *      enqueue operation's tail-pointer exchange will enqueue
> > +        *      the next element at the queue head, because the ->spin_tail
> > +        *      pointer now references the queue head.
> > +        *
> > +        * 2.   tq is the last entry, and the next entry has updated the
> > +        *      tail pointer but has not yet updated tq.next.  In this
> > +        *      case, tq.next is NULL, the cmpxchg will fail, and the
> > +        *      code will wait for the enqueue to complete before completing
> > +        *      removal of tq from the list.
> > +        *
> > +        * 3.   tq is not the last pointer.  In this case, tq.next is non-NULL,
> > +        *      so the following code simply removes tq from the list.
> > +        */
> > +       if (tq.next == NULL) {
> > +
> > +               /* Mark the queue empty. */
> > +               tqhp->spin = NULL;
> > +
> > +               /* Try to point the tail back at the head. */
> > +               if (cmpxchg(&tqhp->spin_tail,
> > +                           &tq.next,
> > +                           &tqhp->spin) == &tq.next)
> > +                       return true; /* Succeeded, queue is now empty. */
> > +
> > +               /* Failed, if needed, wait for the enqueue to complete. */
> > +               while (tq.next == NULL)
> > +                       cpu_relax();
> > +
> > +               /* The following code will repair the head. */
> > +       }
> > +       smp_mb(); /* Force ordering between handoff and critical section. */
> > +
> > +       /*
> > +        * Advance list-head pointer.  This same task will be the next to
> > +        * access this when releasing the lock, so no need for a memory
> > +        * barrier after the following assignment.
> > +        */
> > +       ACCESS_ONCE(tqhp->spin) = tq.next;
> > +       return true;
> > +}
> > +
> > +/*
> > + * Given a lock that does not have a queue, attempt to associate the
> > + * i-th queue with it, returning true if successful (meaning we hold
> > + * the lock) or false otherwise (meaning we do -not- hold the lock).
> > + * Note that the caller has already filled in ->ref with 0x1, so we
> > + * own the queue.
> > + */
> > +static bool
> > +tkt_q_init_contend(int i, arch_spinlock_t *lock, struct __raw_tickets inc)
> > +{
> > +       arch_spinlock_t asold;
> > +       arch_spinlock_t asnew;
> > +       struct tkt_q_head *tqhp;
> > +
> > +       /* Initialize the i-th queue header. */
> > +       tqhp = &tkt_q_heads[i];
> > +       tqhp->spin = NULL;
> > +       tqhp->spin_tail = &tqhp->spin;
> > +
> > +       /* Each pass through this loop attempts to mark the lock as queued. */
> > +       do {
> > +               asold.head_tail = ACCESS_ONCE(lock->head_tail);
> > +               asnew = asold;
> > +               if (asnew.tickets.head & 0x1) {
> > +
> > +                       /* Someone beat us to it, back out. */
> > +                       smp_mb();
> > +                       ACCESS_ONCE(tqhp->ref) = NULL;
> > +
> > +                       /* Spin on the queue element they set up. */
> > +                       return tkt_q_do_spin(lock, inc);
> > +               }
> > +
> > +               /*
> > +                * Record the head counter in case one of the spinning
> > +                * CPUs already holds the lock but doesn't realize it yet.
> > +                */
> > +               tqhp->head_tkt = asold.tickets.head;
> > +
> > +               /* The low-order bit in the head counter says "queued". */
> > +               asnew.tickets.head |= 0x1;
> > +       } while (cmpxchg(&lock->head_tail,
> > +                asold.head_tail,
> > +                asnew.head_tail) != asold.head_tail);
> > +
> > +       /* Point the queue at the lock and go spin on it. */
> > +       ACCESS_ONCE(tqhp->ref) = lock;
> > +       return tkt_q_do_spin(lock, inc);
> > +}
> > +
> > +/*
> > + * Start handling a period of high contention by finding a queue to associate
> > + * with this lock.  Returns true if successful (in which case we hold the
> > + * lock) and false otherwise (in which case we do -not- hold the lock).
> > + */
> > +bool tkt_q_start_contend(arch_spinlock_t *lock, struct __raw_tickets inc)
> > +{
> > +       int i;
> > +       int start;
> > +
> > +       /* Hash the lock address to find a starting point. */
> > +       start = i = tkt_q_hash(lock);
> > +
> > +       /*
> > +        * Each pass through the following loop attempts to associate
> > +        * the lock with the corresponding queue.
> > +        */
> > +       do {
> > +               /*
> > +                * Use 0x1 to mark the queue in use, but also avoiding
> > +                * any spinners trying to use it before we get it all
> > +                * initialized.
> > +                */
> > +               if (tkt_q_heads[i].ref)
> > +                       continue;
> > +               if (cmpxchg(&tkt_q_heads[i].ref,
> > +                           NULL,
> > +                           (arch_spinlock_t *)0x1) == NULL) {
> > +
> > +                       /* Succeeded, now go initialize it. */
> > +                       return tkt_q_init_contend(i, lock, inc);
> > +               }
> > +
> > +               /* If someone beat us to it, go spin on their queue. */
> > +               if (ACCESS_ONCE(lock->tickets.head) & 0x1)
> > +                       return tkt_q_do_spin(lock, inc);
> > +       } while ((i = tkt_q_next_slot(i)) != start);
> > +
> > +       /* All the queues are in use, revert to spinning on the ticket lock. */
> > +       return false;
> > +}
> > +
> > +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> > +{
> > +       if (unlikely(inc.head & 0x1)) {
> > +
> > +               /* This lock has a queue, so go spin on the queue. */
> > +               if (tkt_q_do_spin(ap, inc))
> > +                       return true;
> > +
> > +               /* Get here if the queue is in transition: Retry next time. */
> > +
> > +       } else if (inc.tail - TKT_Q_SWITCH == inc.head) {
> > +
> > +               /*
> > +                * This lock has lots of spinners, but no queue.
> > +                * Go create a queue to spin on.
> > +                */
> > +               if (tkt_q_start_contend(ap, inc))
> > +                       return true;
> > +
> > +               /* Get here if the queue is in transition: Retry next time. */
> > +       }
> > +
> > +       /* Either no need for a queue or the queue is in transition.  Spin. */
> > +       return false;
> > +}
> > +EXPORT_SYMBOL(tkt_spin_pass);
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


