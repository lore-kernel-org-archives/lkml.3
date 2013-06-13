Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab3FMX6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:58:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54471 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759218Ab3FMX6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:58:18 -0400
Date: Thu, 13 Jun 2013 16:57:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org,
        walken@google.com, waiman.long@hp.com, davidlohr.bueso@hp.com
Subject: Re: [PATCH RFC ticketlock] v3 Auto-queued ticketlock
Message-ID: <20130613235741.GI5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <20130611170249.GA1091@linux.vnet.ibm.com>
 <20130612154008.GA9714@linux.vnet.ibm.com>
 <51B934AD.1070807@cn.fujitsu.com>
 <20130613152238.GB5146@linux.vnet.ibm.com>
 <CACvQF52F57Ac17oNjfD0wMoV26csbRDPRWSQd5OYRXFUQSs01Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52F57Ac17oNjfD0wMoV26csbRDPRWSQd5OYRXFUQSs01Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13061323-7182-0000-0000-00000752C891
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 07:25:57AM +0800, Lai Jiangshan wrote:
> On Thu, Jun 13, 2013 at 11:22 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Jun 13, 2013 at 10:55:41AM +0800, Lai Jiangshan wrote:
> >> On 06/12/2013 11:40 PM, Paul E. McKenney wrote:
> >> > Breaking up locks is better than implementing high-contention locks, but
> >> > if we must have high-contention locks, why not make them automatically
> >> > switch between light-weight ticket locks at low contention and queued
> >> > locks at high contention?  After all, this would remove the need for
> >> > the developer to predict which locks will be highly contended.
> >> >
> >> > This commit allows ticket locks to automatically switch between pure
> >> > ticketlock and queued-lock operation as needed.  If too many CPUs are
> >> > spinning on a given ticket lock, a queue structure will be allocated
> >> > and the lock will switch to queued-lock operation.  When the lock becomes
> >> > free, it will switch back into ticketlock operation.  The low-order bit
> >> > of the head counter is used to indicate that the lock is in queued mode,
> >> > which forces an unconditional mismatch between the head and tail counters.
> >> > This approach means that the common-case code path under conditions of
> >> > low contention is very nearly that of a plain ticket lock.
> >> >
> >> > A fixed number of queueing structures is statically allocated in an
> >> > array.  The ticket-lock address is used to hash into an initial element,
> >> > but if that element is already in use, it moves to the next element.  If
> >> > the entire array is already in use, continue to spin in ticket mode.
> >> >
> >> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> > [ paulmck: Eliminate duplicate code and update comments (Steven Rostedt). ]
> >> > [ paulmck: Address Eric Dumazet review feedback. ]
> >> > [ paulmck: Use Lai Jiangshan idea to eliminate smp_mb(). ]
> >> > [ paulmck: Expand ->head_tkt from s32 to s64 (Waiman Long). ]
> >> > [ paulmck: Move cpu_relax() to main spin loop (Steven Rostedt). ]
> >> > [ paulmck: Reduce queue-switch contention (Waiman Long). ]
> >> > [ paulmck: __TKT_SPIN_INC for __ticket_spin_trylock() (Steffen Persvold). ]
> >> > [ paulmck: Type safety fixes (Steven Rostedt). ]
> >> > [ paulmck: Pre-check cmpxchg() value (Waiman Long). ]
> >> > [ paulmck: smp_mb() downgrade to smp_wmb() (Lai Jiangshan). ]
> >>
> >>
> >> Hi, Paul,
> >>
> >> I simplify the code and remove the search by encoding the index of struct tkt_q_head
> >> into lock->tickets.head.
> >>
> >> A) lock->tickets.head(when queued-lock):
> >> ---------------------------------
> >>  index of struct tkt_q_head |0|1|
> >> ---------------------------------
> >
> > Interesting approach!  It might reduce queued-mode overhead a bit in
> > some cases, though I bet that in the common case the first queue element
> > examined is the right one.  More on this below.
> >
> >> The bit0 = 1 for queued, and the bit1 = 0 is reserved for __ticket_spin_unlock(),
> >> thus __ticket_spin_unlock() will not change the higher bits of lock->tickets.head.
> >>
> >> B) tqhp->head is for the real value of lock->tickets.head.
> >> if the last bit of tqhp->head is 1, it means it is the head ticket when started queuing.
> >
> > But don't you also need the xadd() in __ticket_spin_unlock() to become
> > a cmpxchg() for this to work?  Or is your patch missing your changes to
> > arch/x86/include/asm/spinlock.h?  Either way, this is likely to increase
> > the no-contention overhead, which might be counterproductive.  Wouldn't
> > hurt to get measurements, though.
> 
> No, don't need to change __ticket_spin_unlock() in my idea.
> bit1 in the  tickets.head is reserved for __ticket_spin_unlock(),
> __ticket_spin_unlock() only changes the bit1, it will not change
> the higher bits. tkt_q_do_wake() will restore the tickets.head.
> 
> This approach avoids cmpxchg in __ticket_spin_unlock().

Ah, I did miss that.  But doesn't the adjustment in __ticket_spin_lock()
need to be atomic in order to handle concurrent invocations of
__ticket_spin_lock()?

Either way, it would be good to see the performance effects of this.

							Thanx, Paul

> > Given the results that Davidlohr posted, I believe that the following
> > optimizations would also provide some improvement:
> >
> > 1.      Move the call to tkt_spin_pass() from __ticket_spin_lock()
> >         to a separate linker section in order to reduce the icache
> >         penalty exacted by the spinloop.  This is likely to be causing
> >         some of the performance reductions in the cases where ticket
> >         locks are not highly contended.
> >
> > 2.      Limit the number of elements searched for in the array of
> >         queues.  However, this would help only if a number of ticket
> >         locks were in queued mode at the same time.
> >
> > 3.      Dynamically allocate the queue array at boot.  This might
> >         also reduce cache pressure, again, at least in cases where
> >         there are a number of ticket locks in queued mode at the
> >         same time.
> >
> > Frederic just reminded me that I owe him some energy-efficiency improvements
> > for adaptive ticks, so I won't get to these very quickly.  Please feel free
> > to take these on -- the patch clearly does well under high contention, so
> > reducing the no-contention penalty could really help.
> >
> >                                                         Thanx, Paul
> >
> >> Thanks,
> >> Lai
> >>
> >>  kernel/tktqlock.c |   51 +++++++++++++--------------------------------------
> >>  1 files changed, 13 insertions(+), 38 deletions(-)
> >>
> >> diff --git a/kernel/tktqlock.c b/kernel/tktqlock.c
> >> index 912817c..1329d0f 100644
> >> --- a/kernel/tktqlock.c
> >> +++ b/kernel/tktqlock.c
> >> @@ -33,7 +33,7 @@ struct tkt_q {
> >>
> >>  struct tkt_q_head {
> >>       arch_spinlock_t *ref;           /* Pointer to spinlock if in use. */
> >> -     s64 head_tkt;                   /* Head ticket when started queuing. */
> >> +     __ticket_t head;                /* Real head when queued. */
> >>       struct tkt_q *spin;             /* Head of queue. */
> >>       struct tkt_q **spin_tail;       /* Tail of queue. */
> >>  };
> >> @@ -77,15 +77,8 @@ static unsigned long tkt_q_hash(arch_spinlock_t *lock)
> >>   */
> >>  static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *lock)
> >>  {
> >> -     int i;
> >> -     int start;
> >> -
> >> -     start = i = tkt_q_hash(lock);
> >> -     do
> >> -             if (ACCESS_ONCE(tkt_q_heads[i].ref) == lock)
> >> -                     return &tkt_q_heads[i];
> >> -     while ((i = tkt_q_next_slot(i)) != start);
> >> -     return NULL;
> >> +     BUILD_BUG_ON(TKT_Q_NQUEUES > (1 << (TICKET_SHIFT - 2)));
> >> +     return &tkt_q_heads[ACCESS_ONCE(lock->tickets.head) >> 2];
> >>  }
> >>
> >>  /*
> >> @@ -101,11 +94,11 @@ static bool tkt_q_try_unqueue(arch_spinlock_t *lock, struct tkt_q_head *tqhp)
> >>
> >>       /* Pick up the ticket values. */
> >>       asold = ACCESS_ONCE(*lock);
> >> -     if ((asold.tickets.head & ~0x1) == asold.tickets.tail) {
> >> +     if (tqhp->head == asold.tickets.tail) {
> >>
> >>               /* Attempt to mark the lock as not having a queue. */
> >>               asnew = asold;
> >> -             asnew.tickets.head &= ~0x1;
> >> +             asnew.tickets.head = tqhp->head;
> >>               if (cmpxchg(&lock->head_tail,
> >>                           asold.head_tail,
> >>                           asnew.head_tail) == asold.head_tail) {
> >> @@ -128,12 +121,9 @@ void tkt_q_do_wake(arch_spinlock_t *lock)
> >>       struct tkt_q_head *tqhp;
> >>       struct tkt_q *tqp;
> >>
> >> -     /*
> >> -      * If the queue is still being set up, wait for it.  Note that
> >> -      * the caller's xadd() provides the needed memory ordering.
> >> -      */
> >> -     while ((tqhp = tkt_q_find_head(lock)) == NULL)
> >> -             cpu_relax();
> >> +     tqhp = tkt_q_find_head(lock);
> >> +     ACCESS_ONCE(lock->tickets.head) -= __TKT_SPIN_INC;
> >> +     ACCESS_ONCE(tqhp->head) = (tqhp->head & ~0x1) + __TKT_SPIN_INC;
> >>
> >>       for (;;) {
> >>
> >> @@ -145,9 +135,7 @@ void tkt_q_do_wake(arch_spinlock_t *lock)
> >>                       return; /* No element, successfully removed queue. */
> >>               cpu_relax();
> >>       }
> >> -     if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> >> -             ACCESS_ONCE(tqhp->head_tkt) = -1;
> >> -     smp_mb(); /* Order pointer fetch and assignment against handoff. */
> >> +     smp_mb(); /* Order modification, pointer fetch and assignment against handoff. */
> >>       ACCESS_ONCE(tqp->cpu) = -1;
> >>  }
> >>  EXPORT_SYMBOL(tkt_q_do_wake);
> >> @@ -169,10 +157,7 @@ bool tkt_q_do_spin(arch_spinlock_t *lock, struct __raw_tickets inc)
> >>        */
> >>       smp_mb();  /* See above block comment. */
> >>
> >> -     /* If there no longer is a queue, leave. */
> >>       tqhp = tkt_q_find_head(lock);
> >> -     if (tqhp == NULL)
> >> -             return false;
> >>
> >>       /* Initialize our queue element. */
> >>       tq.cpu = raw_smp_processor_id();
> >> @@ -180,9 +165,8 @@ bool tkt_q_do_spin(arch_spinlock_t *lock, struct __raw_tickets inc)
> >>       tq.next = NULL;
> >>
> >>       /* Check to see if we already hold the lock. */
> >> -     if (ACCESS_ONCE(tqhp->head_tkt) == inc.tail) {
> >> +     if (ACCESS_ONCE(tqhp->head) == (inc.tail | 0x1)) {
> >>               /* The last holder left before queue formed, we hold lock. */
> >> -             tqhp->head_tkt = -1;
> >>               return true;
> >>       }
> >>
> >> @@ -290,16 +274,14 @@ tkt_q_init_contend(int i, arch_spinlock_t *lock, struct __raw_tickets inc)
> >>                * Record the head counter in case one of the spinning
> >>                * CPUs already holds the lock but doesn't realize it yet.
> >>                */
> >> -             tqhp->head_tkt = asold.tickets.head;
> >> +             tqhp->head = asold.tickets.head | 0x1;
> >>
> >>               /* The low-order bit in the head counter says "queued". */
> >> -             asnew.tickets.head |= 0x1;
> >> +             asnew.tickets.head = (i << 2) + 0x1;
> >>       } while (cmpxchg(&lock->head_tail,
> >>                asold.head_tail,
> >>                asnew.head_tail) != asold.head_tail);
> >>
> >> -     /* Point the queue at the lock and go spin on it. */
> >> -     ACCESS_ONCE(tqhp->ref) = lock;
> >>       return tkt_q_do_spin(lock, inc);
> >>  }
> >>
> >> @@ -321,15 +303,8 @@ bool tkt_q_start_contend(arch_spinlock_t *lock, struct __raw_tickets inc)
> >>        * the lock with the corresponding queue.
> >>        */
> >>       do {
> >> -             /*
> >> -              * Use 0x1 to mark the queue in use, but also avoiding
> >> -              * any spinners trying to use it before we get it all
> >> -              * initialized.
> >> -              */
> >>               if (!tkt_q_heads[i].ref &&
> >> -                 cmpxchg(&tkt_q_heads[i].ref,
> >> -                         NULL,
> >> -                         (arch_spinlock_t *)0x1) == NULL) {
> >> +                 cmpxchg(&tkt_q_heads[i].ref, NULL, lock) == NULL) {
> >>
> >>                       /* Succeeded, now go initialize it. */
> >>                       return tkt_q_init_contend(i, lock, inc);
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

