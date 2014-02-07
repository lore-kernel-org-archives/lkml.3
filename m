Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBGRMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:12:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaBGRMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:12:34 -0500
Date: Fri, 7 Feb 2014 18:12:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc ticket locks
Message-ID: <20140207171224.GR5002@laptop.programming.kicks-ass.net>
References: <20140207165801.GC2107@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207165801.GC2107@lst.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:58:01PM +0100, Torsten Duwe wrote:
> +static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
>  {
> +	register struct __raw_tickets old, tmp,
> +		inc = { .tail = TICKET_LOCK_INC };
> +
>  	CLEAR_IO_SYNC;
> +	__asm__ __volatile__(
> +"1:	lwarx	%0,0,%4		# arch_spin_lock\n"
> +"	add	%1,%3,%0\n"
> +	PPC405_ERR77(0, "%4")
> +"	stwcx.	%1,0,%4\n"
> +"	bne-	1b"
> +	: "=&r" (old), "=&r" (tmp), "+m" (lock->tickets)
> +	: "r" (inc), "r" (&lock->tickets)
> +	: "cc");
> +
> +	if (likely(old.head == old.tail))
> +		goto out;

I would have expected an lwsync someplace hereabouts.

> +	for (;;) {
> +		unsigned count = 100;
> +
>  		do {
> +			if (ACCESS_ONCE(lock->tickets.head) == old.tail)
> +				goto out;
>  			HMT_low();
>  			if (SHARED_PROCESSOR)
>  				__spin_yield(lock);
> +		} while (--count);
>  		HMT_medium();
>  	}
> +out:
> +#if defined(CONFIG_PPC_SPLPAR)
> +	lock->holder = LOCK_TOKEN;
> +#endif
> +	barrier();	/* make sure nothing creeps before the lock is taken */
>  }
>  
>  static inline

> @@ -147,10 +220,21 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
>  
>  static inline void arch_spin_unlock(arch_spinlock_t *lock)
>  {
> +	arch_spinlock_t old, new;
> +
> +#if defined(CONFIG_PPC_SPLPAR)
> +	lock->holder = 0;
> +#endif
> +	do {
> +		old.tickets = ACCESS_ONCE(lock->tickets);
> +		new.tickets.head = old.tickets.head + TICKET_LOCK_INC;
> +		new.tickets.tail = old.tickets.tail;
> +	} while (unlikely(__arch_spin_cmpxchg_eq(lock,
> +						 old.head_tail,
> +						 new.head_tail)));
>  	SYNC_IO;
>  	__asm__ __volatile__("# arch_spin_unlock\n\t"
>  				PPC_RELEASE_BARRIER: : :"memory");

Doens't your cmpxchg_eq not already imply a lwsync?

> -	lock->slock = 0;
>  }

I'm still failing to see why you need an ll/sc pair for unlock.
