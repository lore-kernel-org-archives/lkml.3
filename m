Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FKJ5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:57:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58332 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3FKJ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:57:05 -0400
Date: Tue, 11 Jun 2013 02:56:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611095655.GA5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370911480.9844.160.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061109-5806-0000-0000-000021A5397E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 08:44:40PM -0400, Steven Rostedt wrote:
> On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> 
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
> >  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> >  {
> >  	arch_spinlock_t old, new;
> > @@ -70,17 +91,37 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> >  	if (old.tickets.head != old.tickets.tail)
> >  		return 0;
> >  
> > +#ifndef CONFIG_TICKET_LOCK_QUEUED
> >  	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
> > +#else /* #ifndef CONFIG_TICKET_LOCK_QUEUED */
> > +	new.head_tail = old.head_tail + (2 << TICKET_SHIFT);
> > +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
> >  
> >  	/* cmpxchg is a full barrier, so nothing can move before it */
> >  	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
> >  }
> >  
> > +#ifndef CONFIG_TICKET_LOCK_QUEUED
> > +
> >  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
> >  {
> >  	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
> >  }
> >  
> > +#else /* #ifndef CONFIG_TICKET_LOCK_QUEUED */
> > +
> > +extern void tkt_q_do_wake(arch_spinlock_t *asp);
> > +
> > +static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
> > +{
> > +	__ticket_t head = 2;
> > +
> > +	head = xadd(&lock->tickets.head, 2);
> > +	if (head & 0x1)
> > +		tkt_q_do_wake(lock);
> > +}
> > +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
> > +
> >  static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
> >  {
> >  	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> > diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> > index ad0ad07..cdaefdd 100644
> > --- a/arch/x86/include/asm/spinlock_types.h
> > +++ b/arch/x86/include/asm/spinlock_types.h
> > @@ -7,12 +7,18 @@
> >  
> >  #include <linux/types.h>
> >  
> > -#if (CONFIG_NR_CPUS < 256)
> > +#if (CONFIG_NR_CPUS < 128)
> >  typedef u8  __ticket_t;
> >  typedef u16 __ticketpair_t;
> > -#else
> > +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2 >= (unsigned char)((a) - (b)))
> > +#elif (CONFIG_NR_CPUS < 32768)
> >  typedef u16 __ticket_t;
> >  typedef u32 __ticketpair_t;
> > +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2 >= (unsigned short)((a) - (b)))
> > +#else
> > +typedef u32 __ticket_t;
> > +typedef u64 __ticketpair_t;
> > +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2 >= (unsigned int)((a) - (b)))
> >  #endif
> >  
> >  #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
> > @@ -21,7 +27,11 @@ typedef struct arch_spinlock {
> >  	union {
> >  		__ticketpair_t head_tail;
> >  		struct __raw_tickets {
> > +#ifdef __BIG_ENDIAN__
> > +			__ticket_t tail, head;
> > +#else /* #ifdef __BIG_ENDIAN__ */
> >  			__ticket_t head, tail;
> > +#endif /* #else #ifdef __BIG_ENDIAN__ */
> >  		} tickets;
> >  	};
> >  } arch_spinlock_t;
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index e9ef6d6..816a87c 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -15,6 +15,7 @@
> >  #include <asm/byteorder.h>
> >  #include <uapi/linux/kernel.h>
> >  
> > +#define UCHAR_MAX	((u8)(~0U))
> >  #define USHRT_MAX	((u16)(~0U))
> >  #define SHRT_MAX	((s16)(USHRT_MAX>>1))
> >  #define SHRT_MIN	((s16)(-SHRT_MAX - 1))
> > diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> > index 44511d1..ad9c67c 100644
> > --- a/kernel/Kconfig.locks
> > +++ b/kernel/Kconfig.locks
> > @@ -223,3 +223,21 @@ endif
> >  config MUTEX_SPIN_ON_OWNER
> >  	def_bool y
> >  	depends on SMP && !DEBUG_MUTEXES
> > +
> > +config TICKET_LOCK_QUEUED
> > +	bool "Dynamically switch between ticket and queued locking"
> > +	default n
> > +	---help---
> > +	  Enable dynamic switching between ticketlock and queued locking
> > +	  on a per-lock basis.  This option will slow down low-contention
> > +	  acquisition and release very slightly (additional conditional
> > +	  in release path), but will provide more efficient operation at
> > +	  high levels of lock contention.  High-contention operation will
> > +	  not be quite as efficient as would be a pure queued lock, but
> > +	  this dynamic approach consumes less memory than queud locks
> > +	  and also runs faster at low levels of contention.
> > +
> > +	  Say "Y" if you are running on a large system with a workload
> > +	  that is likely to result in high levels of contention.
> > +
> > +	  Say "N" if you are unsure.
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index 271fd31..70a91f7 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -51,6 +51,7 @@ endif
> >  obj-$(CONFIG_SMP) += spinlock.o
> >  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
> >  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
> > +obj-$(CONFIG_TICKET_LOCK_QUEUED) += tktqlock.o
> >  obj-$(CONFIG_UID16) += uid16.o
> >  obj-$(CONFIG_MODULES) += module.o
> >  obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
> > diff --git a/kernel/tktqlock.c b/kernel/tktqlock.c
> > new file mode 100644
> > index 0000000..f01b760
> > --- /dev/null
> > +++ b/kernel/tktqlock.c
> > @@ -0,0 +1,333 @@
> > +/*
> > + * Queued ticket spinlocks.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright IBM Corporation, 2013
> > + *
> > + * Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > + */
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/smp.h>
> > +#include <linux/percpu.h>
> > +
> > +struct tkt_q {
> > +	int cpu;
> > +	__ticket_t tail;
> > +	struct tkt_q *next;
> > +};
> > +
> > +struct tkt_q_head {
> > +	arch_spinlock_t *ref;		/* Pointer to spinlock if in use. */
> > +	s32 head_tkt;			/* Head ticket when started queuing. */
> > +	struct tkt_q *spin;		/* Head of queue. */
> > +	struct tkt_q **spin_tail;	/* Tail of queue. */
> > +};
> > +
> > +/*
> > + * TKT_Q_SWITCH is twice the number of CPUs that must be spinning on a
> > + * given ticket lock to motivate switching to spinning on a queue.
> > + * The reason that it is twice the number is because the bottom bit of
> > + * the ticket is reserved for the bit that indicates that a queue is
> > + * associated with the lock.
> > + */
> > +#define TKT_Q_SWITCH  (16 * 2)
> > +
> > +/*
> > + * TKT_Q_NQUEUES is the number of queues to maintain.  Large systems
> > + * might have multiple highly contended locks, so provide more queues for
> > + * systems with larger numbers of CPUs.
> > + */
> > +#define TKT_Q_NQUEUES (DIV_ROUND_UP(NR_CPUS + TKT_Q_SWITCH - 1, TKT_Q_SWITCH) * 2)
> > +
> > +/* The queues themselves. */
> > +struct tkt_q_head tkt_q_heads[TKT_Q_NQUEUES];
> > +
> > +/* Advance to the next queue slot, wrapping around to the beginning. */
> > +static int tkt_q_next_slot(int i)
> > +{
> > +	return (++i < TKT_Q_NQUEUES) ? i : 0;
> > +}
> > +
> > +/* Very crude hash from lock address to queue slot number. */
> > +static unsigned long tkt_q_hash(arch_spinlock_t *asp)
> > +{
> > +	return (((unsigned long)asp) >> 8) % TKT_Q_NQUEUES;
> > +}
> > +
> > +/*
> > + * Return a pointer to the queue header associated with the specified lock,
> > + * or return NULL if there is no queue for the lock or if the lock's queue
> > + * is in transition.
> > + */
> > +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
> > +{
> > +	int i;
> > +	int start;
> > +
> > +	start = i = tkt_q_hash(asp);
> > +	do
> > +		if (tkt_q_heads[i].ref == asp)
> > +			return &tkt_q_heads[i];
> > +	while ((i = tkt_q_next_slot(i)) != start);
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * Try to stop queuing, reverting back to normal ticket-lock operation.
> > + * We can only stop queuing when the queue is empty, which means that
> > + * we need to correctly handle races where someone shows up in the queue
> > + * just as we are trying to dispense with the queue.  They win, we lose.
> > + */
> > +static bool tkt_q_try_unqueue(arch_spinlock_t *asp, struct tkt_q_head *tqhp)
> > +{
> > +	arch_spinlock_t asold;
> > +	arch_spinlock_t asnew;
> > +
> > +	/* Pick up the ticket values. */
> > +	asold = ACCESS_ONCE(*asp);
> > +	if ((asold.tickets.head & ~0x1) == asold.tickets.tail) {
> > +
> > +		/* Attempt to mark the lock as not having a queue. */
> > +		asnew = asold;
> > +		asnew.tickets.head &= ~0x1;
> > +		if (cmpxchg(&asp->head_tail,
> > +			    asold.head_tail,
> > +			    asnew.head_tail) == asold.head_tail) {
> > +
> > +			/* Succeeded, mark the queue as unused. */
> > +			ACCESS_ONCE(tqhp->ref) = NULL;
> > +			return true;
> > +		}
> > +	}
> > +
> > +	/* Failed, tell the caller there is still a queue to pass off to. */
> > +	return false;
> > +}
> > +
> > +/*
> > + * Hand the lock off to the first CPU on the queue.
> > + */
> > +void tkt_q_do_wake(arch_spinlock_t *asp)
> > +{
> > +	struct tkt_q_head *tqhp;
> > +	struct tkt_q *tqp;
> > +
> > +	/* If the queue is still being set up, wait for it. */
> > +	while ((tqhp = tkt_q_find_head(asp)) == NULL)
> > +		cpu_relax();
> > +
> > +	for (;;) {
> > +
> > +		/* Find the first queue element. */
> > +		tqp = ACCESS_ONCE(tqhp->spin);
> > +		if (tqp != NULL)
> > +			break;  /* Element exists, hand off lock. */
> > +		if (tkt_q_try_unqueue(asp, tqhp))
> > +			return; /* No element, successfully removed queue. */
> > +		cpu_relax();
> > +	}
> > +	if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> > +		ACCESS_ONCE(tqhp->head_tkt) = -1;
> > +	smp_mb(); /* Order pointer fetch and assignment against handoff. */
> > +	ACCESS_ONCE(tqp->cpu) = -1;
> > +}
> > +
> > +/*
> > + * Given a lock that already has a queue associated with it, spin on
> > + * that queue.  Return false if there was no queue (which means we do not
> > + * hold the lock) and true otherwise (meaning we -do- hold the lock).
> > + */
> > +bool tkt_q_do_spin(arch_spinlock_t *asp, struct __raw_tickets inc)
> > +{
> > +	struct tkt_q **oldtail;
> > +	struct tkt_q tq;
> > +	struct tkt_q_head *tqhp;
> > +
> > +	/*
> > +	 * Ensure that accesses to queue header happen after sensing
> > +	 * the lock's have-queue bit.
> > +	 */
> > +	smp_mb();  /* See above block comment. */
> > +
> > +	/* If there no longer is a queue, leave. */
> > +	tqhp = tkt_q_find_head(asp);
> > +	if (tqhp == NULL)
> > +		return false;
> > +
> > +	/* Initialize our queue element. */
> > +	tq.cpu = raw_smp_processor_id();
> > +	tq.tail = inc.tail;
> > +	tq.next = NULL;
> > +
> > +	/* Check to see if we already hold the lock. */
> > +	if (ACCESS_ONCE(tqhp->head_tkt) == inc.tail) {
> > +		/* The last holder left before queue formed, we hold lock. */
> > +		tqhp->head_tkt = -1;
> > +		return true;
> > +	}
> > +
> > +	/* Add our element to the tail of the queue. */
> > +	oldtail = xchg(&tqhp->spin_tail, &tq.next);
> 
> Boy this is tricky code! I thought I found a race window here, but as I
> went to write my email saying "Gotcha!" I found that it wasn't a race
> after all. But as I went though the effort of writing this, I figured I
> would send this out as documentation for others to see. Hmm, I wonder if
> we can use this email to add more comments. Anyway, here's what I
> thought was wrong ;-)

If you didn't know any better, you might even think that I had done
something like this before.  ;-)

> OK, I originally thought there was a race window here. Let's say that an
> NMI hit right here, and it happens to be a big one, where lots of things
> can happen on other CPUs right now.
> 
> The scenario is that there's just one item on the queue, which is
> waiting for the lock to be released, and is spinning below in the:
> 
> 	while (ACCESS_ONCE(tq.cpu) != -1)
> 		cpu_relax();
> 
> And then the lock is released, where in tkt_q_do_wake() the following is
> called:
> 
> 	ACCESS_ONCE(tqp->cpu) = -1;
> 
> Now the old queued task is released. But it's tq->next hasn't been set
> yet, and is still NULL. It leaves by doing:
> 
> 	ACCESS_ONCE(tqhp->spin) = tq.next;
> 	return true;
> 
> All before this task gets to set *oldtail to &tq. But, I then looked
> below...
> 
> 
> > +	ACCESS_ONCE(*oldtail) = &tq;
> > +
> > +	/* Spin until handoff. */
> > +	while (ACCESS_ONCE(tq.cpu) != -1)
> > +		cpu_relax();
> > +
> > +	/*
> > +	 * Remove our element from the queue.  If the queue is now empty,
> > +	 * update carefully so that the next acquisition will queue itself
> > +	 * at the head of the list.
> > +	 */
> > +	if (tq.next == NULL) {
> 
> This checks for that scenario.

Yep!

>                                As if the old task were to come out
> spinning, the problem would only be if it was the last one on the list,
> and its tq.next was NULL. But if that was the case, then we set spin to
> NULL and do the next trick, where I thought I gotcha again...
> 
> 
> > +
> > +		/* Mark the queue empty. */
> > +		tqhp->spin = NULL;
> > +
> > +		/* Try to point the tail back at the head. */
> > +		if (cmpxchg(&tqhp->spin_tail,
> > +			    &tq.next,
> > +			    &tqhp->spin) == &tq.next)
> 
> Here, I was thinking, oh wait, what happens if this is called right
> before the xchg() above. Then we would set spin_tail but not update the
> old tq.next. But wait! look at what we assign spin_tail to. It's the
> address of spin, which would be what oldtail would point to above, and
> then above would set spin to the new tq!

Yep again!

> OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> don't like trickssy, and we must find precccciouss!!!
> 
> 
> This code is starting to make me look like Gollum :-p

Hmmm...  The time and effort to do this might almost have been worthwhile
just to accomplish that!  ;-)

But yes, this would need better comments, design documentation, or
maybe both.

							Thanx, Paul

> -- Steve
> 
> > +			return true; /* Succeeded, queue is now empty. */
> > +
> > +		/* Failed, if needed, wait for the enqueue to complete. */
> > +		while (tq.next == NULL)
> > +			cpu_relax();
> > +
> > +		/* The following code will repair the head. */
> > +	}
> > +	smp_mb(); /* Force ordering between handoff and critical section. */
> > +
> > +	/* Advance list-head pointer. */
> > +	ACCESS_ONCE(tqhp->spin) = tq.next;
> > +	return true;
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
> > +tkt_q_init_contend(int i, arch_spinlock_t *asp, struct __raw_tickets inc)
> > +{
> > +	arch_spinlock_t asold;
> > +	arch_spinlock_t asnew;
> > +	struct tkt_q_head *tqhp;
> > +
> > +	/* Initialize the i-th queue header. */
> > +	tqhp = &tkt_q_heads[i];
> > +	tqhp->spin = NULL;
> > +	tqhp->spin_tail = &tqhp->spin;
> > +
> > +	/* Each pass through this loop attempts to mark the lock as queued. */
> > +	do {
> > +		asold.head_tail = ACCESS_ONCE(asp->head_tail);
> > +		asnew = asold;
> > +		if (asnew.tickets.head & 0x1) {
> > +
> > +			/* Someone beat us to it, back out. */
> > +			smp_mb();
> > +			ACCESS_ONCE(tqhp->ref) = NULL;
> > +
> > +			/* Spin on the queue element they set up. */
> > +			return tkt_q_do_spin(asp, inc);
> > +		}
> > +
> > +		/* The low-order bit in the head counter says "queued". */
> > +		asnew.tickets.head |= 0x1;
> > +	} while (cmpxchg(&asp->head_tail,
> > +		 asold.head_tail,
> > +		 asnew.head_tail) != asold.head_tail);
> > +
> > +	/* Point the queue at the lock and go spin on it. */
> > +	tqhp->head_tkt = asold.tickets.head;
> > +	smp_mb(); /* Ensure head_tkt is set prior to queuers seeing tqhp. */
> > +	ACCESS_ONCE(tqhp->ref) = asp;
> > +	return tkt_q_do_spin(asp, inc);
> > +}
> > +
> > +/*
> > + * Start handling a period of high contention by finding a queue to associate
> > + * with this lock.  Returns true if successful (in which case we hold the
> > + * lock) and false otherwise (in which case we do -not- hold the lock).
> > + */
> > +bool tkt_q_start_contend(arch_spinlock_t *asp, struct __raw_tickets inc)
> > +{
> > +	int i;
> > +	int start;
> > +
> > +	/* Hash the lock address to find a starting point. */
> > +	start = i = tkt_q_hash(asp);
> > +
> > +	/*
> > +	 * Each pass through the following loop attempts to associate
> > +	 * the lock with the corresponding queue.
> > +	 */
> > +	do {
> > +		/*
> > +		 * Use 0x1 to mark the queue in use, but also avoiding
> > +		 * any spinners trying to use it before we get it all
> > +		 * initialized.
> > +		 */
> > +		if (cmpxchg(&tkt_q_heads[i].ref,
> > +			    NULL,
> > +			    (arch_spinlock_t *)0x1) == NULL) {
> > +
> > +			/* Succeeded, now go initialize it. */
> > +			return tkt_q_init_contend(i, asp, inc);
> > +		}
> > +
> > +		/* If someone beat us to it, go spin on their queue. */
> > +		if (ACCESS_ONCE(asp->tickets.head) & 0x1)
> > +			return tkt_q_do_spin(asp, inc);
> > +	} while ((i = tkt_q_next_slot(i)) != start);
> > +
> > +	/* All the queues are in use, revert to spinning on the ticket lock. */
> > +	return false;
> > +}
> > +
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
> > +	} else if (TICKET_T_CMP_GE(ACCESS_ONCE(ap->tickets.tail) - TKT_Q_SWITCH,
> > +				   ACCESS_ONCE(ap->tickets.head))) {
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
> > +	cpu_relax();
> > +	return false;
> > +}
> 
> 

