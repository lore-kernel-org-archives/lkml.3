Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3FKQoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:44:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34361 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3FKQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:44:44 -0400
Date: Tue, 11 Jun 2013 09:43:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611164313.GH5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <51B748DA.2070306@hp.com>
 <1370967632.9844.182.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370967632.9844.182.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061116-4834-0000-0000-000007F4DD12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 12:20:32PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 11:57 -0400, Waiman Long wrote:
> 
> > This is an interesting patch and I think it is useful for workloads that 
> > run on systems with a large number of CPUs.
> 
> I would say it is definitely a fun academic patch, now if it is
> something for a production environment remains to be seen.

At the moment, it should be considered an intellectual exercise.  Might be
useful at some point, but I would personally rather that the offending
lock be broken up to reduce its contention.

> > > diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> > > index ad0ad07..cdaefdd 100644
> > > --- a/arch/x86/include/asm/spinlock_types.h
> > > +++ b/arch/x86/include/asm/spinlock_types.h
> > > @@ -7,12 +7,18 @@
> > >
> > >   #include<linux/types.h>
> > >
> > > -#if (CONFIG_NR_CPUS<  256)
> > > +#if (CONFIG_NR_CPUS<  128)
> > >   typedef u8  __ticket_t;
> > >   typedef u16 __ticketpair_t;
> > > -#else
> > > +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2>= (unsigned char)((a) - (b)))
> > > +#elif (CONFIG_NR_CPUS<  32768)
> > >   typedef u16 __ticket_t;
> > >   typedef u32 __ticketpair_t;
> > > +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2>= (unsigned short)((a) - (b)))
> > > +#else
> > > +typedef u32 __ticket_t;
> > > +typedef u64 __ticketpair_t;
> > > +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2>= (unsigned int)((a) - (b)))
> > >   #endif
> > 
> > It is theoretically possible that a large number of CPUs (says 64 or 
> > more with CONFIG_NR_CPUS < 128) can acquire a ticket from the lock 
> > before the check for TICKET_T_CMP_GE() in tkt_spin_pass(). So the check 
> > will fail even when there is a large number of CPUs contending for the 
> > lock. The chance of this happening is, of course, extremely rare. This 
> > is not an error as the lock is still working as it should be without 
> > your change.
> 
> Can you explain this more. How can you acquire the ticket and update at
> the same time? If a queue has been set, then you can't acquire the
> ticket as the head has a 1 appended to it.

Suppose that CONFIG_NR_CPUS=127, and suppose that 65 CPUs atomically
increment ->tail before ...

Ah, good point.  If TKT_Q_SWITCH is less than 64, then at least one CPU
will see the need to switch to queued mode, and will do so regardless of
what the other CPUs think.  The key point is that each CPU will get its
ticket from the xadd(), and these will be issued in order.  I therefore
backed out my change of the limits.

> > > +/*
> > > + * TKT_Q_SWITCH is twice the number of CPUs that must be spinning on a
> > > + * given ticket lock to motivate switching to spinning on a queue.
> > > + * The reason that it is twice the number is because the bottom bit of
> > > + * the ticket is reserved for the bit that indicates that a queue is
> > > + * associated with the lock.
> > > + */
> > > +#define TKT_Q_SWITCH  (16 * 2)
> > > +
> > > +/*
> > > + * TKT_Q_NQUEUES is the number of queues to maintain.  Large systems
> > > + * might have multiple highly contended locks, so provide more queues for
> > > + * systems with larger numbers of CPUs.
> > > + */
> > > +#define TKT_Q_NQUEUES (DIV_ROUND_UP(NR_CPUS + TKT_Q_SWITCH - 1, TKT_Q_SWITCH) * 2)
> > > +
> > > +/* The queues themselves. */
> > > +struct tkt_q_head tkt_q_heads[TKT_Q_NQUEUES];
> > 
> > I am a bit concern about the size of the head queue table itself. RHEL6, 
> > for example, had defined CONFIG_NR_CPUS to be 4096 which mean a table 
> > size of 256. Maybe it is better to dynamically allocate the table at 
> > init time depending on the actual number of CPUs in the system.
> 
> Yeah, it can be allocated dynamically at boot.

But let's first demonstrate the need.  Keep in mind that an early-boot
deadlock would exercise this code.  Yes, it is just a check for NULL,
but on the other hand I didn't get the impression that you thought that
this code was too simple.  ;-)

> > > +/*
> > > + * Return a pointer to the queue header associated with the specified lock,
> > > + * or return NULL if there is no queue for the lock or if the lock's queue
> > > + * is in transition.
> > > + */
> > > +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
> > > +{
> > > +	int i;
> > > +	int start;
> > > +
> > > +	start = i = tkt_q_hash(asp);
> > > +	do
> > > +		if (tkt_q_heads[i].ref == asp)
> > > +			return&tkt_q_heads[i];
> > > +	while ((i = tkt_q_next_slot(i)) != start);
> > > +	return NULL;
> > > +}
> > 
> > With a table size of 256 and you have to scan the whole table to find 
> > the right head queue. This can be a significant overhead. I will suggest 
> > setting a limiting of how many entries it scans before it aborts rather 
> > than checking the whole table.
> 
> We could add a limit, but in practice I'm not sure that would have any
> issue. I thought the same thing when I first saw this, but to hit most
> of the list, would require a large collision in the hash algorithm,
> would could probably be fixed with a better hash.
> 
> > 
> > > +/*
> > > + * Hand the lock off to the first CPU on the queue.
> > > + */
> > > +void tkt_q_do_wake(arch_spinlock_t *asp)
> > > +{
> > > +	struct tkt_q_head *tqhp;
> > > +	struct tkt_q *tqp;
> > > +
> > > +	/* If the queue is still being set up, wait for it. */
> > > +	while ((tqhp = tkt_q_find_head(asp)) == NULL)
> > > +		cpu_relax();
> > > +
> > > +	for (;;) {
> > > +
> > > +		/* Find the first queue element. */
> > > +		tqp = ACCESS_ONCE(tqhp->spin);
> > > +		if (tqp != NULL)
> > > +			break;  /* Element exists, hand off lock. */
> > > +		if (tkt_q_try_unqueue(asp, tqhp))
> > > +			return; /* No element, successfully removed queue. */
> > > +		cpu_relax();
> > > +	}
> > > +	if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> > > +		ACCESS_ONCE(tqhp->head_tkt) = -1;
> > 
> > In case NR_CPUS is 32768 or higher, the ticket will be of type u32 and 
> > tqhp->head_tkt is s32. So -1 will be a valid ticket number. You may have 
> > to conditionally define head_tkt to be s64 when the ticket is u32.
> 
> Good point.
> 
> > 
> > Do you have any data on how much this patch can actually improve 
> > performance on certain workloads? This will help the discussion here.
> 
> Yeah, that's come up already in the thread. Linus wants to see hard
> numbers *and* an explanation of why the contended locks can't be fixed,
> before he even considers merging this type of change.

A point that I am definitely -not- arguing with.  ;-)

								Thanx, Paul

