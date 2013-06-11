Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3FKP5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:57:37 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10522 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3FKP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:57:36 -0400
Message-ID: <51B748DA.2070306@hp.com>
Date: Tue, 11 Jun 2013 11:57:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
References: <20130609193657.GA13392@linux.vnet.ibm.com>
In-Reply-To: <20130609193657.GA13392@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 03:36 PM, Paul E. McKenney wrote:
> Breaking up locks is better than implementing high-contention locks, but
> if we must have high-contention locks, why not make them automatically
> switch between light-weight ticket locks at low contention and queued
> locks at high contention?
>
> This commit therefore allows ticket locks to automatically switch between
> pure ticketlock and queued-lock operation as needed.  If too many CPUs
> are spinning on a given ticket lock, a queue structure will be allocated
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
> This has been only lightly tested in the kernel, though a userspace
> implementation has survived substantial testing.
>
> Signed-off-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>

This is an interesting patch and I think it is useful for workloads that 
run on systems with a large number of CPUs.

> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> index ad0ad07..cdaefdd 100644
> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -7,12 +7,18 @@
>
>   #include<linux/types.h>
>
> -#if (CONFIG_NR_CPUS<  256)
> +#if (CONFIG_NR_CPUS<  128)
>   typedef u8  __ticket_t;
>   typedef u16 __ticketpair_t;
> -#else
> +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2>= (unsigned char)((a) - (b)))
> +#elif (CONFIG_NR_CPUS<  32768)
>   typedef u16 __ticket_t;
>   typedef u32 __ticketpair_t;
> +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2>= (unsigned short)((a) - (b)))
> +#else
> +typedef u32 __ticket_t;
> +typedef u64 __ticketpair_t;
> +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2>= (unsigned int)((a) - (b)))
>   #endif

It is theoretically possible that a large number of CPUs (says 64 or 
more with CONFIG_NR_CPUS < 128) can acquire a ticket from the lock 
before the check for TICKET_T_CMP_GE() in tkt_spin_pass(). So the check 
will fail even when there is a large number of CPUs contending for the 
lock. The chance of this happening is, of course, extremely rare. This 
is not an error as the lock is still working as it should be without 
your change.

>
> +/*
> + * TKT_Q_SWITCH is twice the number of CPUs that must be spinning on a
> + * given ticket lock to motivate switching to spinning on a queue.
> + * The reason that it is twice the number is because the bottom bit of
> + * the ticket is reserved for the bit that indicates that a queue is
> + * associated with the lock.
> + */
> +#define TKT_Q_SWITCH  (16 * 2)
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

I am a bit concern about the size of the head queue table itself. RHEL6, 
for example, had defined CONFIG_NR_CPUS to be 4096 which mean a table 
size of 256. Maybe it is better to dynamically allocate the table at 
init time depending on the actual number of CPUs in the system.

> +/*
> + * Return a pointer to the queue header associated with the specified lock,
> + * or return NULL if there is no queue for the lock or if the lock's queue
> + * is in transition.
> + */
> +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
> +{
> +	int i;
> +	int start;
> +
> +	start = i = tkt_q_hash(asp);
> +	do
> +		if (tkt_q_heads[i].ref == asp)
> +			return&tkt_q_heads[i];
> +	while ((i = tkt_q_next_slot(i)) != start);
> +	return NULL;
> +}

With a table size of 256 and you have to scan the whole table to find 
the right head queue. This can be a significant overhead. I will suggest 
setting a limiting of how many entries it scans before it aborts rather 
than checking the whole table.

> +/*
> + * Hand the lock off to the first CPU on the queue.
> + */
> +void tkt_q_do_wake(arch_spinlock_t *asp)
> +{
> +	struct tkt_q_head *tqhp;
> +	struct tkt_q *tqp;
> +
> +	/* If the queue is still being set up, wait for it. */
> +	while ((tqhp = tkt_q_find_head(asp)) == NULL)
> +		cpu_relax();
> +
> +	for (;;) {
> +
> +		/* Find the first queue element. */
> +		tqp = ACCESS_ONCE(tqhp->spin);
> +		if (tqp != NULL)
> +			break;  /* Element exists, hand off lock. */
> +		if (tkt_q_try_unqueue(asp, tqhp))
> +			return; /* No element, successfully removed queue. */
> +		cpu_relax();
> +	}
> +	if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> +		ACCESS_ONCE(tqhp->head_tkt) = -1;

In case NR_CPUS is 32768 or higher, the ticket will be of type u32 and 
tqhp->head_tkt is s32. So -1 will be a valid ticket number. You may have 
to conditionally define head_tkt to be s64 when the ticket is u32.

Do you have any data on how much this patch can actually improve 
performance on certain workloads? This will help the discussion here.

Regards,
Longman
