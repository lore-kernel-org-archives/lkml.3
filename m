Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3FJVfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:35:15 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52796 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3FJVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:35:13 -0400
Message-ID: <1370900106.3252.11.camel@edumazet-glaptop>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org
Date: Mon, 10 Jun 2013 14:35:06 -0700
In-Reply-To: <20130609193657.GA13392@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
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
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

This looks a great idea ;)

> +
> +static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
> +{
> +	__ticket_t head = 2;
> +
> +	head = xadd(&lock->tickets.head, 2);

	head = xadd(&lock->tickets.head, head);

> +	if (head & 0x1)
> +		tkt_q_do_wake(lock);
> +}
> +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */

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
> +	smp_mb(); /* Order pointer fetch and assignment against handoff. */
> +	ACCESS_ONCE(tqp->cpu) = -1;
> +}

EXPORT_SYMBOL(tkt_q_do_wake) ?

Hmm, unfortunately I lack time this week to fully read the patch !



