Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3FLBTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:19:41 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47220 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3FLBTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130611194927.GX5146@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<51B748DA.2070306@hp.com>
	<20130611163607.GG5146@linux.vnet.ibm.com>
	<51B76F77.6020004@hp.com>
	<20130611194927.GX5146@linux.vnet.ibm.com>
Date: Wed, 12 Jun 2013 09:19:38 +0800
Message-ID: <CACvQF51s+xsP9XX2V7ASEe+T3qH1n9Gzatf5k9Fzr=ehma8baQ@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Lai Jiangshan <eag0628@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 3:49 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jun 11, 2013 at 02:41:59PM -0400, Waiman Long wrote:
>> On 06/11/2013 12:36 PM, Paul E. McKenney wrote:
>> >
>> >>I am a bit concern about the size of the head queue table itself.
>> >>RHEL6, for example, had defined CONFIG_NR_CPUS to be 4096 which mean
>> >>a table size of 256. Maybe it is better to dynamically allocate the
>> >>table at init time depending on the actual number of CPUs in the
>> >>system.
>> >But if your kernel is built for 4096 CPUs, the 32*256=8192 bytes of memory
>> >is way down in the noise.  Systems that care about that small an amount
>> >of memory probably have a small enough number of CPUs that they can just
>> >turn off queueing at build time using CONFIG_TICKET_LOCK_QUEUED=n, right?
>>
>> My concern is more about the latency on the table scan than the
>> actual memory that was used.
>>
>> >>>+/*
>> >>>+ * Return a pointer to the queue header associated with the specified lock,
>> >>>+ * or return NULL if there is no queue for the lock or if the lock's queue
>> >>>+ * is in transition.
>> >>>+ */
>> >>>+static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
>> >>>+{
>> >>>+  int i;
>> >>>+  int start;
>> >>>+
>> >>>+  start = i = tkt_q_hash(asp);
>> >>>+  do
>> >>>+          if (tkt_q_heads[i].ref == asp)
>> >>>+                  return&tkt_q_heads[i];
>> >>>+  while ((i = tkt_q_next_slot(i)) != start);
>> >>>+  return NULL;
>> >>>+}
>> >>With a table size of 256 and you have to scan the whole table to
>> >>find the right head queue. This can be a significant overhead. I
>> >>will suggest setting a limiting of how many entries it scans before
>> >>it aborts rather than checking the whole table.
>> >But it will scan 256 entries only if there are 256 other locks in queued
>> >mode, which is -very- unlikely, even given 4096 CPUs.  That said, if you
>> >show me that this results in a real latency problem on a real system,
>> >I would be happy to provide a way to limit the search.
>>
>> Looking at the code more carefully, the chance of actually scanning
>> 256 entries is very small. However, I now have some concern on the
>> way you set up the initial queue.
>>
>> +/*
>> + * Start handling a period of high contention by finding a queue to associate
>> + * with this lock.  Returns true if successful (in which case we hold the
>> + * lock) and false otherwise (in which case we do -not- hold the lock).
>> + */
>> +bool tkt_q_start_contend(arch_spinlock_t *asp, struct __raw_tickets inc)
>> +{
>> +     int i;
>> +     int start;
>> +
>> +     /* Hash the lock address to find a starting point. */
>> +     start = i = tkt_q_hash(asp);
>> +
>> +     /*
>> +      * Each pass through the following loop attempts to associate
>> +      * the lock with the corresponding queue.
>> +      */
>> +     do {
>> +             /*
>> +              * Use 0x1 to mark the queue in use, but also avoiding
>> +              * any spinners trying to use it before we get it all
>> +              * initialized.
>> +              */
>> +             if (cmpxchg(&tkt_q_heads[i].ref,
>> +                         NULL,
>> +                         (arch_spinlock_t *)0x1) == NULL) {
>> +
>> +                     /* Succeeded, now go initialize it. */
>> +                     return tkt_q_init_contend(i, asp, inc);
>> +             }
>> +
>> +             /* If someone beat us to it, go spin on their queue. */
>> +             if (ACCESS_ONCE(asp->tickets.head)&  0x1)
>> +                     return tkt_q_do_spin(asp, inc);
>> +     } while ((i = tkt_q_next_slot(i)) != start);
>> +
>> +     /* All the queues are in use, revert to spinning on the ticket lock. */
>> +     return false;
>> +}
>> +
>>
>> Unconditional cmpxchg() can be a source of high contention by
>> itself. Considering that 16 threads may be doing cmpxchg() more or
>> less simultaneously on the same cache line, it can cause a lot of
>> contention. It will be better if you check to see if tkt_q_heads[i]
>> is NULL first before doing cmpxchg.
>>
>> Another point is that the 16 threads maybe setting up the queues in
>> consecutive slots in the head table. This is both a source of
>> contention and a waste of effort. One possible solution is to add
>> one more field (set to cpuid + 1, for example) to indicate that that
>> setup is being done with asp set to the target lock address
>> immediately. We will need to use cmpxchg128() for 64-bit machine,
>> though. Another solution is to have only that thread with ticket
>> number that is a fixed distance from head (e.g. 16*2) to do the
>> queue setup while the rest wait until the setup is done before
>> spinning on the queue.
>>
>> As my colleague Davidlohr had reported there are more regressions
>> than performance improvement in the AIM7 benchmark. I believe that
>> queue setup contention is likely a source of performance regression.
>
> Please see below for a v3 patch that:
>
> 1.      Fixes cpu_relax().
>
> 2.      Tests before doing cmpxchg().
>
> 3.      Reduces the number of CPUs attempting to set up the queue,
>         in the common case, to a single CPU.  (Multiple CPUs can
>         still be trying to set up the queue given unfortunate
>         sequences of concurrent ticket-lock handoffs.)
>
> Please let me know how it goes!
>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> ticketlock: Add queued-ticketlock capability
>
> Breaking up locks is better than implementing high-contention locks, but
> if we must have high-contention locks, why not make them automatically
> switch between light-weight ticket locks at low contention and queued
> locks at high contention?  After all, this would remove the need for
> the developer to predict which locks will be highly contended.
>
> This commit allows ticket locks to automatically switch between pure
> ticketlock and queued-lock operation as needed.  If too many CPUs are
> spinning on a given ticket lock, a queue structure will be allocated
> and the lock will switch to queued-lock operation.  When the lock becomes
> free, it will switch back into ticketlock operation.  The low-order bit
> of the head counter is used to indicate that the lock is in queued mode,
> which forces an unconditional mismatch between the head and tail counters.
> This approach means that the common-case code path under conditions of
> low contention is very nearly that of a plain ticket lock.
>
> A fixed number of queueing structures is statically allocated in an
> array.  The ticket-lock address is used to hash into an initial element,
> but if that element is already in use, it moves to the next element.  If
> the entire array is already in use, continue to spin in ticket mode.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> [ paulmck: Eliminate duplicate code and update comments (Steven Rostedt). ]
> [ paulmck: Address Eric Dumazet review feedback. ]
> [ paulmck: Use Lai Jiangshan idea to eliminate smp_mb(). ]
> [ paulmck: Expand ->head_tkt from s32 to s64 (Waiman Long). ]
> [ paulmck: Move cpu_relax() to main spin loop (Steven Rostedt). ]
> [ paulmck: Reduce queue-switch contention (Waiman Long). ]
>
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 33692ea..509c51a 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -34,6 +34,21 @@
>  # define UNLOCK_LOCK_PREFIX
>  #endif
>
> +#ifdef CONFIG_TICKET_LOCK_QUEUED
> +
> +#define __TKT_SPIN_INC 2
> +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc);
> +
> +#else /* #ifdef CONFIG_TICKET_LOCK_QUEUED */
> +
> +#define __TKT_SPIN_INC 1
> +static inline bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> +{
> +       return false;
> +}
> +
> +#endif /* #else #ifdef CONFIG_TICKET_LOCK_QUEUED */
> +
>  /*
>   * Ticket locks are conceptually two parts, one indicating the current head of
>   * the queue, and the other indicating the current tail. The lock is acquired
> @@ -49,17 +64,16 @@
>   */
>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>  {
> -       register struct __raw_tickets inc = { .tail = 1 };
> +       register struct __raw_tickets inc = { .tail = __TKT_SPIN_INC };
>
>         inc = xadd(&lock->tickets, inc);
> -
>         for (;;) {
> -               if (inc.head == inc.tail)
> +               if (inc.head == inc.tail || tkt_spin_pass(lock, inc))
>                         break;
>                 cpu_relax();
>                 inc.head = ACCESS_ONCE(lock->tickets.head);
>         }
> -       barrier();              /* make sure nothing creeps before the lock is taken */
> +       barrier(); /* Make sure nothing creeps in before the lock is taken. */
>  }
>
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> @@ -70,17 +84,37 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
>         if (old.tickets.head != old.tickets.tail)
>                 return 0;
>
> +#ifndef CONFIG_TICKET_LOCK_QUEUED
>         new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
> +#else /* #ifndef CONFIG_TICKET_LOCK_QUEUED */
> +       new.head_tail = old.head_tail + (2 << TICKET_SHIFT);
> +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
>
>         /* cmpxchg is a full barrier, so nothing can move before it */
>         return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
>  }
>
> +#ifndef CONFIG_TICKET_LOCK_QUEUED
> +
>  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>  {
>         __add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
>  }
>
> +#else /* #ifndef CONFIG_TICKET_LOCK_QUEUED */
> +
> +extern void tkt_q_do_wake(arch_spinlock_t *lock);
> +
> +static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
> +{
> +       __ticket_t head = 2;
> +
> +       head = xadd(&lock->tickets.head, head);
> +       if (head & 0x1)
> +               tkt_q_do_wake(lock);
> +}
> +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
> +
>  static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
>  {
>         struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> index ad0ad07..cdaefdd 100644
> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -7,12 +7,18 @@
>
>  #include <linux/types.h>
>
> -#if (CONFIG_NR_CPUS < 256)
> +#if (CONFIG_NR_CPUS < 128)
>  typedef u8  __ticket_t;
>  typedef u16 __ticketpair_t;
> -#else
> +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2 >= (unsigned char)((a) - (b)))
> +#elif (CONFIG_NR_CPUS < 32768)
>  typedef u16 __ticket_t;
>  typedef u32 __ticketpair_t;
> +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2 >= (unsigned short)((a) - (b)))
> +#else
> +typedef u32 __ticket_t;
> +typedef u64 __ticketpair_t;
> +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2 >= (unsigned int)((a) - (b)))
>  #endif
>
>  #define TICKET_SHIFT   (sizeof(__ticket_t) * 8)
> @@ -21,7 +27,11 @@ typedef struct arch_spinlock {
>         union {
>                 __ticketpair_t head_tail;
>                 struct __raw_tickets {
> +#ifdef __BIG_ENDIAN__
> +                       __ticket_t tail, head;
> +#else /* #ifdef __BIG_ENDIAN__ */
>                         __ticket_t head, tail;
> +#endif /* #else #ifdef __BIG_ENDIAN__ */
>                 } tickets;
>         };
>  } arch_spinlock_t;
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index e9ef6d6..816a87c 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -15,6 +15,7 @@
>  #include <asm/byteorder.h>
>  #include <uapi/linux/kernel.h>
>
> +#define UCHAR_MAX      ((u8)(~0U))
>  #define USHRT_MAX      ((u16)(~0U))
>  #define SHRT_MAX       ((s16)(USHRT_MAX>>1))
>  #define SHRT_MIN       ((s16)(-SHRT_MAX - 1))
> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> index 44511d1..900c0f0 100644
> --- a/kernel/Kconfig.locks
> +++ b/kernel/Kconfig.locks
> @@ -223,3 +223,38 @@ endif
>  config MUTEX_SPIN_ON_OWNER
>         def_bool y
>         depends on SMP && !DEBUG_MUTEXES
> +
> +config TICKET_LOCK_QUEUED
> +       bool "Dynamically switch between ticket and queued locking"
> +       depends on SMP
> +       default n
> +       ---help---
> +         Enable dynamic switching between ticketlock and queued locking
> +         on a per-lock basis.  This option will slow down low-contention
> +         acquisition and release very slightly (additional conditional
> +         in release path), but will provide more efficient operation at
> +         high levels of lock contention.  High-contention operation will
> +         not be quite as efficient as would be a pure queued lock, but
> +         this dynamic approach consumes less memory than queud locks
> +         and also runs faster at low levels of contention.
> +
> +         Say "Y" if you are running on a large system with a workload
> +         that is likely to result in high levels of contention.
> +
> +         Say "N" if you are unsure.
> +
> +config TICKET_LOCK_QUEUED_SWITCH
> +       int "When to switch from ticket to queued locking"
> +       depends on TICKET_LOCK_QUEUED
> +       default 8
> +       range 3 32
> +       ---help---
> +         Specify how many tasks should be spinning on the lock before
> +         switching to queued mode.  Systems with low-latency memory/cache
> +         interconnects will prefer larger numbers, while extreme low-latency
> +         and real-time workloads will prefer a smaller number.  Of course,
> +         extreme real-time workloads would be even happier if contention
> +         on the locks were reduced to the point that there was never any
> +         need for queued locking in the first place.
> +
> +         Take the default if you are unsure.
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 271fd31..70a91f7 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -51,6 +51,7 @@ endif
>  obj-$(CONFIG_SMP) += spinlock.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
> +obj-$(CONFIG_TICKET_LOCK_QUEUED) += tktqlock.o
>  obj-$(CONFIG_UID16) += uid16.o
>  obj-$(CONFIG_MODULES) += module.o
>  obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
> diff --git a/kernel/tktqlock.c b/kernel/tktqlock.c
> new file mode 100644
> index 0000000..9f03af0
> --- /dev/null
> +++ b/kernel/tktqlock.c
> @@ -0,0 +1,369 @@
> +/*
> + * Queued ticket spinlocks.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright IBM Corporation, 2013
> + *
> + * Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> + */
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/smp.h>
> +#include <linux/percpu.h>
> +
> +struct tkt_q {
> +       int cpu;
> +       __ticket_t tail;
> +       struct tkt_q *next;
> +};
> +
> +struct tkt_q_head {
> +       arch_spinlock_t *ref;           /* Pointer to spinlock if in use. */
> +       s64 head_tkt;                   /* Head ticket when started queuing. */
> +       struct tkt_q *spin;             /* Head of queue. */
> +       struct tkt_q **spin_tail;       /* Tail of queue. */
> +};
> +
> +/*
> + * TKT_Q_SWITCH is twice the number of CPUs that must be spinning on a
> + * given ticket lock to motivate switching to spinning on a queue.
> + * The reason that it is twice the number is because the bottom bit of
> + * the ticket is reserved for the bit that indicates that a queue is
> + * associated with the lock.
> + */
> +#define TKT_Q_SWITCH  (CONFIG_TICKET_LOCK_QUEUED_SWITCH * 2)
> +
> +/*
> + * TKT_Q_NQUEUES is the number of queues to maintain.  Large systems
> + * might have multiple highly contended locks, so provide more queues for
> + * systems with larger numbers of CPUs.
> + */
> +#define TKT_Q_NQUEUES (DIV_ROUND_UP(NR_CPUS + TKT_Q_SWITCH - 1, TKT_Q_SWITCH) * 2)
> +
> +/* The queues themselves. */
> +struct tkt_q_head tkt_q_heads[TKT_Q_NQUEUES];
> +
> +/* Advance to the next queue slot, wrapping around to the beginning. */
> +static int tkt_q_next_slot(int i)
> +{
> +       return (++i < TKT_Q_NQUEUES) ? i : 0;
> +}
> +
> +/* Very crude hash from lock address to queue slot number. */
> +static unsigned long tkt_q_hash(arch_spinlock_t *lock)
> +{
> +       return (((unsigned long)lock) >> 8) % TKT_Q_NQUEUES;
> +}
> +
> +/*
> + * Return a pointer to the queue header associated with the specified lock,
> + * or return NULL if there is no queue for the lock or if the lock's queue
> + * is in transition.
> + */
> +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *lock)
> +{
> +       int i;
> +       int start;
> +
> +       start = i = tkt_q_hash(lock);
> +       do
> +               if (tkt_q_heads[i].ref == lock)
> +                       return &tkt_q_heads[i];
> +       while ((i = tkt_q_next_slot(i)) != start);
> +       return NULL;
> +}
> +
> +/*
> + * Try to stop queuing, reverting back to normal ticket-lock operation.
> + * We can only stop queuing when the queue is empty, which means that
> + * we need to correctly handle races where someone shows up in the queue
> + * just as we are trying to dispense with the queue.  They win, we lose.
> + */
> +static bool tkt_q_try_unqueue(arch_spinlock_t *lock, struct tkt_q_head *tqhp)
> +{
> +       arch_spinlock_t asold;
> +       arch_spinlock_t asnew;
> +
> +       /* Pick up the ticket values. */
> +       asold = ACCESS_ONCE(*lock);
> +       if ((asold.tickets.head & ~0x1) == asold.tickets.tail) {
> +
> +               /* Attempt to mark the lock as not having a queue. */
> +               asnew = asold;
> +               asnew.tickets.head &= ~0x1;
> +               if (cmpxchg(&lock->head_tail,
> +                           asold.head_tail,
> +                           asnew.head_tail) == asold.head_tail) {
> +
> +                       /* Succeeded, mark the queue as unused. */
> +                       ACCESS_ONCE(tqhp->ref) = NULL;
> +                       return true;
> +               }
> +       }
> +
> +       /* Failed, tell the caller there is still a queue to pass off to. */
> +       return false;
> +}
> +
> +/*
> + * Hand the lock off to the first CPU on the queue.
> + */
> +void tkt_q_do_wake(arch_spinlock_t *lock)
> +{
> +       struct tkt_q_head *tqhp;
> +       struct tkt_q *tqp;
> +
> +       /* If the queue is still being set up, wait for it. */
> +       while ((tqhp = tkt_q_find_head(lock)) == NULL)
> +               cpu_relax();
> +
> +       for (;;) {
> +
> +               /* Find the first queue element. */
> +               tqp = ACCESS_ONCE(tqhp->spin);
> +               if (tqp != NULL)
> +                       break;  /* Element exists, hand off lock. */
> +               if (tkt_q_try_unqueue(lock, tqhp))
> +                       return; /* No element, successfully removed queue. */
> +               cpu_relax();
> +       }
> +       if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> +               ACCESS_ONCE(tqhp->head_tkt) = -1;
> +       smp_mb(); /* Order pointer fetch and assignment against handoff. */
> +       ACCESS_ONCE(tqp->cpu) = -1;
> +}
> +EXPORT_SYMBOL(tkt_q_do_wake);
> +
> +/*
> + * Given a lock that already has a queue associated with it, spin on
> + * that queue.  Return false if there was no queue (which means we do not
> + * hold the lock) and true otherwise (meaning we -do- hold the lock).
> + */
> +bool tkt_q_do_spin(arch_spinlock_t *lock, struct __raw_tickets inc)
> +{
> +       struct tkt_q **oldtail;
> +       struct tkt_q tq;
> +       struct tkt_q_head *tqhp;
> +
> +       /*
> +        * Ensure that accesses to queue header happen after sensing
> +        * the lock's have-queue bit.
> +        */
> +       smp_mb();  /* See above block comment. */
> +
> +       /* If there no longer is a queue, leave. */
> +       tqhp = tkt_q_find_head(lock);
> +       if (tqhp == NULL)
> +               return false;
> +
> +       /* Initialize our queue element. */
> +       tq.cpu = raw_smp_processor_id();
> +       tq.tail = inc.tail;
> +       tq.next = NULL;

I guess a mb() is needed here for between read tqhp->ref and read
tqhp->head_tkt.
you can move the above mb() to here.

> +
> +       /* Check to see if we already hold the lock. */
> +       if (ACCESS_ONCE(tqhp->head_tkt) == inc.tail) {
> +               /* The last holder left before queue formed, we hold lock. */
> +               tqhp->head_tkt = -1;
> +               return true;
> +       }
> +
> +       /*
> +        * Add our element to the tail of the queue.  Note that if the
> +        * queue is empty, the ->spin_tail pointer will reference
> +        * the queue's head pointer, namely ->spin.
> +        */
> +       oldtail = xchg(&tqhp->spin_tail, &tq.next);
> +       ACCESS_ONCE(*oldtail) = &tq;
> +
> +       /* Spin until handoff. */
> +       while (ACCESS_ONCE(tq.cpu) != -1)
> +               cpu_relax();
> +
> +       /*
> +        * Remove our element from the queue.  If the queue is now empty,
> +        * update carefully so that the next acquisition will enqueue itself
> +        * at the head of the list.  Of course, the next enqueue operation
> +        * might be happening concurrently, and this code needs to handle all
> +        * of the possible combinations, keeping in mind that the enqueue
> +        * operation happens in two stages: (1) update the tail pointer and
> +        * (2) update the predecessor's ->next pointer.  With this in mind,
> +        * the following code needs to deal with three scenarios:
> +        *
> +        * 1.   tq is the last entry.  In this case, we use cmpxchg to
> +        *      point the list tail back to the list head (->spin).  If
> +        *      the cmpxchg fails, that indicates that we are instead
> +        *      in scenario 2 below.  If the cmpxchg succeeds, the next
> +        *      enqueue operation's tail-pointer exchange will enqueue
> +        *      the next element at the queue head, because the ->spin_tail
> +        *      pointer now references the queue head.
> +        *
> +        * 2.   tq is the last entry, and the next entry has updated the
> +        *      tail pointer but has not yet updated tq.next.  In this
> +        *      case, tq.next is NULL, the cmpxchg will fail, and the
> +        *      code will wait for the enqueue to complete before completing
> +        *      removal of tq from the list.
> +        *
> +        * 3.   tq is not the last pointer.  In this case, tq.next is non-NULL,
> +        *      so the following code simply removes tq from the list.
> +        */
> +       if (tq.next == NULL) {
> +
> +               /* Mark the queue empty. */
> +               tqhp->spin = NULL;
> +
> +               /* Try to point the tail back at the head. */
> +               if (cmpxchg(&tqhp->spin_tail,
> +                           &tq.next,
> +                           &tqhp->spin) == &tq.next)
> +                       return true; /* Succeeded, queue is now empty. */
> +
> +               /* Failed, if needed, wait for the enqueue to complete. */
> +               while (tq.next == NULL)
> +                       cpu_relax();
> +
> +               /* The following code will repair the head. */
> +       }
> +       smp_mb(); /* Force ordering between handoff and critical section. */
> +
> +       /*
> +        * Advance list-head pointer.  This same task will be the next to
> +        * access this when releasing the lock, so no need for a memory
> +        * barrier after the following assignment.
> +        */
> +       ACCESS_ONCE(tqhp->spin) = tq.next;
> +       return true;
> +}
> +
> +/*
> + * Given a lock that does not have a queue, attempt to associate the
> + * i-th queue with it, returning true if successful (meaning we hold
> + * the lock) or false otherwise (meaning we do -not- hold the lock).
> + * Note that the caller has already filled in ->ref with 0x1, so we
> + * own the queue.
> + */
> +static bool
> +tkt_q_init_contend(int i, arch_spinlock_t *lock, struct __raw_tickets inc)
> +{
> +       arch_spinlock_t asold;
> +       arch_spinlock_t asnew;
> +       struct tkt_q_head *tqhp;
> +
> +       /* Initialize the i-th queue header. */
> +       tqhp = &tkt_q_heads[i];
> +       tqhp->spin = NULL;
> +       tqhp->spin_tail = &tqhp->spin;
> +
> +       /* Each pass through this loop attempts to mark the lock as queued. */
> +       do {
> +               asold.head_tail = ACCESS_ONCE(lock->head_tail);
> +               asnew = asold;
> +               if (asnew.tickets.head & 0x1) {
> +
> +                       /* Someone beat us to it, back out. */
> +                       smp_mb();
> +                       ACCESS_ONCE(tqhp->ref) = NULL;
> +
> +                       /* Spin on the queue element they set up. */
> +                       return tkt_q_do_spin(lock, inc);
> +               }
> +
> +               /*
> +                * Record the head counter in case one of the spinning
> +                * CPUs already holds the lock but doesn't realize it yet.
> +                */
> +               tqhp->head_tkt = asold.tickets.head;
> +
> +               /* The low-order bit in the head counter says "queued". */
> +               asnew.tickets.head |= 0x1;
> +       } while (cmpxchg(&lock->head_tail,
> +                asold.head_tail,
> +                asnew.head_tail) != asold.head_tail);
> +
> +       /* Point the queue at the lock and go spin on it. */
> +       ACCESS_ONCE(tqhp->ref) = lock;
> +       return tkt_q_do_spin(lock, inc);
> +}
> +
> +/*
> + * Start handling a period of high contention by finding a queue to associate
> + * with this lock.  Returns true if successful (in which case we hold the
> + * lock) and false otherwise (in which case we do -not- hold the lock).
> + */
> +bool tkt_q_start_contend(arch_spinlock_t *lock, struct __raw_tickets inc)
> +{
> +       int i;
> +       int start;
> +
> +       /* Hash the lock address to find a starting point. */
> +       start = i = tkt_q_hash(lock);
> +
> +       /*
> +        * Each pass through the following loop attempts to associate
> +        * the lock with the corresponding queue.
> +        */
> +       do {
> +               /*
> +                * Use 0x1 to mark the queue in use, but also avoiding
> +                * any spinners trying to use it before we get it all
> +                * initialized.
> +                */
> +               if (tkt_q_heads[i].ref)
> +                       continue;
> +               if (cmpxchg(&tkt_q_heads[i].ref,
> +                           NULL,
> +                           (arch_spinlock_t *)0x1) == NULL) {
> +
> +                       /* Succeeded, now go initialize it. */
> +                       return tkt_q_init_contend(i, lock, inc);
> +               }
> +
> +               /* If someone beat us to it, go spin on their queue. */
> +               if (ACCESS_ONCE(lock->tickets.head) & 0x1)
> +                       return tkt_q_do_spin(lock, inc);
> +       } while ((i = tkt_q_next_slot(i)) != start);
> +
> +       /* All the queues are in use, revert to spinning on the ticket lock. */
> +       return false;
> +}
> +
> +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> +{
> +       if (unlikely(inc.head & 0x1)) {
> +
> +               /* This lock has a queue, so go spin on the queue. */
> +               if (tkt_q_do_spin(ap, inc))
> +                       return true;
> +
> +               /* Get here if the queue is in transition: Retry next time. */
> +
> +       } else if (inc.tail - TKT_Q_SWITCH == inc.head) {
> +
> +               /*
> +                * This lock has lots of spinners, but no queue.
> +                * Go create a queue to spin on.
> +                */
> +               if (tkt_q_start_contend(ap, inc))
> +                       return true;
> +
> +               /* Get here if the queue is in transition: Retry next time. */
> +       }
> +
> +       /* Either no need for a queue or the queue is in transition.  Spin. */
> +       return false;
> +}
> +EXPORT_SYMBOL(tkt_spin_pass);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
