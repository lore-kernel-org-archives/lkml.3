Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaBFPyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:54:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:40857 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbaBFPyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:54:11 -0500
Message-ID: <1391702020.17616.16.camel@pasglop>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 06 Feb 2014 09:53:40 -0600
In-Reply-To: <20140206103736.GA18054@lst.de>
References: <20140206103736.GA18054@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 11:37 +0100, Torsten Duwe wrote:
> x86 has them, MIPS has them, ARM has them, even ia64 has them:
> ticket locks. They reduce memory bus and cache pressure especially
> for contended spinlocks, increasing performance.
> 
> This patch is a port of the x86 spin locks, mostly written in C,
> to the powerpc, introducing inline asm where needed. The pSeries
> directed yield for vCPUs is taken care of by an additional "holder"
> field in the lock.

Thanks, I've been meaning to look into this for ages and never quite got
to it :-)

I'm travelling right now, I'll review this next week.

Cheers,
Ben.

> Signed-off-by: Torsten Duwe <duwe@suse.de>
> --
>  arch/powerpc/include/asm/spinlock_types.h |   27 ++++-
>  arch/powerpc/include/asm/spinlock.h       |  157 +++++++++++++++++++++++-------
>  arch/powerpc/lib/locks.c                  |    6 -
>  3 files changed, 151 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/spinlock_types.h b/arch/powerpc/include/asm/spinlock_types.h
> index 2351adc..64a98be 100644
> --- a/arch/powerpc/include/asm/spinlock_types.h
> +++ b/arch/powerpc/include/asm/spinlock_types.h
> @@ -5,11 +5,30 @@
>  # error "please don't include this file directly"
>  #endif
>  
> -typedef struct {
> -	volatile unsigned int slock;
> -} arch_spinlock_t;
> +typedef u16 __ticket_t;
> +typedef u32 __ticketpair_t;
> +
> +#define TICKET_LOCK_INC	((__ticket_t)1)
> +
> +#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
> +
> +typedef struct arch_spinlock {
> +	union {
> +		__ticketpair_t head_tail;
> +		struct __raw_tickets {
> +#ifdef __BIG_ENDIAN__		/* The "tail" part should be in the MSBs */
> +			__ticket_t tail, head;
> +#else
> +			__ticket_t head, tail;
> +#endif
> +		} tickets;
> +	};
> +#if defined(CONFIG_PPC64)
> +	u32 holder;
> +#endif
> +} arch_spinlock_t __aligned(8);
>  
> -#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
> +#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 }, 0 }
>  
>  typedef struct {
>  	volatile signed int lock;
> diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
> index 5f54a74..6e33691 100644
> --- a/arch/powerpc/include/asm/spinlock.h
> +++ b/arch/powerpc/include/asm/spinlock.h
> @@ -9,8 +9,7 @@
>   * Copyright (C) 2001 Anton Blanchard <anton@au.ibm.com>, IBM
>   * Copyright (C) 2002 Dave Engebretsen <engebret@us.ibm.com>, IBM
>   *	Rework to support virtual processors
> - *
> - * Type of int is used as a full 64b word is not necessary.
> + * Copyright (C) 2014 Torsten Duwe <duwe@suse.de>, ticket lock port
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -28,7 +27,20 @@
>  #include <asm/synch.h>
>  #include <asm/ppc-opcode.h>
>  
> -#define arch_spin_is_locked(x)		((x)->slock != 0)
> +static inline int arch_spin_is_locked(arch_spinlock_t *lock)
> +{
> +	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> +
> +	return tmp.tail != tmp.head;
> +}
> +
> +static inline int arch_spin_is_contended(arch_spinlock_t *lock)
> +{
> +	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> +
> +	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
> +}
> +#define arch_spin_is_contended	arch_spin_is_contended
>  
>  #ifdef CONFIG_PPC64
>  /* use 0x800000yy when locked, where yy == CPU number */
> @@ -37,8 +49,12 @@
>  #else
>  #define LOCK_TOKEN	(*(u32 *)(&get_paca()->paca_index))
>  #endif
> +#define SIZE_LETTER	"d"
> +#define L64		"1"
>  #else
>  #define LOCK_TOKEN	1
> +#define SIZE_LETTER	"w"
> +#define L64		"0"
>  #endif
>  
>  #if defined(CONFIG_PPC64) && defined(CONFIG_SMP)
> @@ -55,33 +71,59 @@
>  #endif
>  
>  /*
> - * This returns the old value in the lock, so we succeeded
> - * in getting the lock if the return value is 0.
> + * Our own cmpxchg, operating on spinlock_t's.  Returns 0 iff value
> + * read at lock was equal to "old" AND the cmpxchg succeeded
> + * uninterruptedly.
>   */
> -static inline unsigned long __arch_spin_trylock(arch_spinlock_t *lock)
> +static __always_inline int __arch_spin_cmpxchg_eq(arch_spinlock_t *lock,
> +					       arch_spinlock_t old,
> +					       arch_spinlock_t new)
>  {
> -	unsigned long tmp, token;
> +	register int retval = 1;
> +	register arch_spinlock_t tmp;
> +
> +	__asm__ __volatile__ (
> +"	li %0,1\n"		/* default to "fail" */
> +	PPC_RELEASE_BARRIER
> +"1:	l" SIZE_LETTER "arx   %2,0,%5         # __arch_spin_cmpxchg_eq\n"
> +"	cmp 0,"L64",%3,%2\n"
> +"	bne-    2f\n"
> +	PPC405_ERR77(0, "%5")
> +"	st" SIZE_LETTER "cx.  %4,0,%5\n"
> +"	bne-    1b\n"
> +"	isync\n"
> +"	li %0,0\n"
> +"2:"
> +	: "=&r" (retval), "+m" (*lock)
> +	: "r" (tmp), "r" (old), "r" (new), "r" (lock)
> +	: "cc", "memory");
> +
> +	return retval;
> +}
> +#undef SIZE_LETTER
> +#undef L64
>  
> -	token = LOCK_TOKEN;
> -	__asm__ __volatile__(
> -"1:	" PPC_LWARX(%0,0,%2,1) "\n\
> -	cmpwi		0,%0,0\n\
> -	bne-		2f\n\
> -	stwcx.		%1,0,%2\n\
> -	bne-		1b\n"
> -	PPC_ACQUIRE_BARRIER
> -"2:"
> -	: "=&r" (tmp)
> -	: "r" (token), "r" (&lock->slock)
> -	: "cr0", "memory");
> +static __always_inline int __arch_spin_trylock(arch_spinlock_t *lock)
> +{
> +	arch_spinlock_t old, new;
>  
> -	return tmp;
> +	old.tickets = ACCESS_ONCE(lock->tickets);
> +	if (old.tickets.head != old.tickets.tail)
> +		return 0;
> +
> +	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
> +#if defined(CONFIG_PPC64)
> +	old.holder = lock->holder;
> +	new.holder = LOCK_TOKEN;
> +#endif
> +
> +	return !__arch_spin_cmpxchg_eq(lock, old, new);
>  }
>  
>  static inline int arch_spin_trylock(arch_spinlock_t *lock)
>  {
>  	CLEAR_IO_SYNC;
> -	return __arch_spin_trylock(lock) == 0;
> +	return  __arch_spin_trylock(lock);
>  }
>  
>  /*
> @@ -93,9 +135,8 @@ static inline int arch_spin_trylock(arch_spinlock_t *lock)
>   * rest of our timeslice to the lock holder.
>   *
>   * So that we can tell which virtual processor is holding a lock,
> - * we put 0x80000000 | smp_processor_id() in the lock when it is
> - * held.  Conveniently, we have a word in the paca that holds this
> - * value.
> + * we put 0x80000000 | smp_processor_id() into lock->holder.
> + * Conveniently, we have a word in the paca that holds this value.
>   */
>  
>  #if defined(CONFIG_PPC_SPLPAR)
> @@ -109,19 +150,59 @@ extern void __rw_yield(arch_rwlock_t *lock);
>  #define SHARED_PROCESSOR	0
>  #endif
>  
> -static inline void arch_spin_lock(arch_spinlock_t *lock)
> +/*
> + * Ticket locks are conceptually two parts, one indicating the current head of
> + * the queue, and the other indicating the current tail. The lock is acquired
> + * by atomically noting the tail and incrementing it by one (thus adding
> + * ourself to the queue and noting our position), then waiting until the head
> + * becomes equal to the the initial value of the tail.
> + *
> + * We use an asm covering *both* parts of the lock, to increment the tail and
> + * also load the position of the head, which takes care of memory ordering
> + * issues and should be optimal for the uncontended case. Note the tail must be
> + * in the high part, because a wide add increment of the low part would carry
> + * up and contaminate the high part.
> + */
> +static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
>  {
> +	register struct __raw_tickets old, tmp,
> +		inc = { .tail = TICKET_LOCK_INC };
> +
>  	CLEAR_IO_SYNC;
> -	while (1) {
> -		if (likely(__arch_spin_trylock(lock) == 0))
> -			break;
> +	__asm__ __volatile__(
> +"1:	lwarx   %0,0,%4         # arch_spin_lock\n"
> +"	add     %1,%3,%0\n"
> +	PPC405_ERR77(0, "%4")
> +"	stwcx.  %1,0,%4\n"
> +"	bne-    1b"
> +	: "=&r" (old), "=&r" (tmp), "+m" (lock->tickets)
> +	: "r" (inc), "r" (&lock->tickets)
> +	: "cc");
> +
> +	if (likely(old.head == old.tail)) {
> +#if defined(CONFIG_PPC64)
> +		lock->holder = LOCK_TOKEN;
> +#endif
> +		goto out;
> +	}
> +
> +	for (;;) {
> +		unsigned count = 100;
> +
>  		do {
> +			if (ACCESS_ONCE(lock->tickets.head) == old.tail) {
> +#if defined(CONFIG_PPC64)
> +				lock->holder = LOCK_TOKEN;
> +#endif
> +				goto out;
> +			}
>  			HMT_low();
>  			if (SHARED_PROCESSOR)
>  				__spin_yield(lock);
> -		} while (unlikely(lock->slock != 0));
> +		} while (--count);
>  		HMT_medium();
>  	}
> +out:	barrier();	/* make sure nothing creeps before the lock is taken */
>  }
>  
>  static inline
> @@ -131,7 +211,7 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
>  
>  	CLEAR_IO_SYNC;
>  	while (1) {
> -		if (likely(__arch_spin_trylock(lock) == 0))
> +		if (likely(__arch_spin_trylock(lock)))
>  			break;
>  		local_save_flags(flags_dis);
>  		local_irq_restore(flags);
> @@ -139,7 +219,7 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
>  			HMT_low();
>  			if (SHARED_PROCESSOR)
>  				__spin_yield(lock);
> -		} while (unlikely(lock->slock != 0));
> +		} while (arch_spin_is_locked(lock));
>  		HMT_medium();
>  		local_irq_restore(flags_dis);
>  	}
> @@ -147,10 +227,22 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
>  
>  static inline void arch_spin_unlock(arch_spinlock_t *lock)
>  {
> +	arch_spinlock_t old, new;
> +
> +#if defined(CONFIG_PPC64)
> +	new.holder = 0;
> +#endif
> +	do {
> +		old.tickets = ACCESS_ONCE(lock->tickets);
> +#if defined(CONFIG_PPC64)
> +		old.holder = lock->holder;
> +#endif
> +		new.tickets.head = old.tickets.head + TICKET_LOCK_INC;
> +		new.tickets.tail = old.tickets.tail;
> +	} while (unlikely(__arch_spin_cmpxchg_eq(lock, old, new)));
>  	SYNC_IO;
>  	__asm__ __volatile__("# arch_spin_unlock\n\t"
>  				PPC_RELEASE_BARRIER: : :"memory");
> -	lock->slock = 0;
>  }
>  
>  #ifdef CONFIG_PPC64
> diff --git a/arch/powerpc/lib/locks.c b/arch/powerpc/lib/locks.c
> index 0c9c8d7..4a57e32 100644
> --- a/arch/powerpc/lib/locks.c
> +++ b/arch/powerpc/lib/locks.c
> @@ -27,7 +27,7 @@ void __spin_yield(arch_spinlock_t *lock)
>  {
>  	unsigned int lock_value, holder_cpu, yield_count;
>  
> -	lock_value = lock->slock;
> +	lock_value = lock->holder;
>  	if (lock_value == 0)
>  		return;
>  	holder_cpu = lock_value & 0xffff;
> @@ -36,7 +36,7 @@ void __spin_yield(arch_spinlock_t *lock)
>  	if ((yield_count & 1) == 0)
>  		return;		/* virtual cpu is currently running */
>  	rmb();
> -	if (lock->slock != lock_value)
> +	if (lock->holder != lock_value)
>  		return;		/* something has changed */
>  	plpar_hcall_norets(H_CONFER,
>  		get_hard_smp_processor_id(holder_cpu), yield_count);
> @@ -70,7 +70,7 @@ void __rw_yield(arch_rwlock_t *rw)
>  
>  void arch_spin_unlock_wait(arch_spinlock_t *lock)
>  {
> -	while (lock->slock) {
> +	while (arch_spin_is_locked(lock)) {
>  		HMT_low();
>  		if (SHARED_PROCESSOR)
>  			__spin_yield(lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


