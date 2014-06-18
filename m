Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaFRTeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:34:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaFRTeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:34:03 -0400
Date: Wed, 18 Jun 2014 11:57:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 05/11] qspinlock: Optimize for smaller NR_CPUS
Message-ID: <20140618155730.GA5107@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.483502389@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615130153.483502389@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:47:02PM +0200, Peter Zijlstra wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> When we allow for a max NR_CPUS < 2^14 we can optimize the pending
> wait-acquire and the xchg_tail() operations.
> 
> By growing the pending bit to a byte, we reduce the tail to 16bit.
> This means we can use xchg16 for the tail part and do away with all
> the repeated compxchg() operations.
> 
> This in turn allows us to unconditionally acquire; the locked state
> as observed by the wait loops cannot change. And because both locked
> and pending are now a full byte we can use simple stores for the
> state transition, obviating one atomic operation entirely.

I have to ask - how much more performance do you get from this?

Is this extra atomic operation hurting that much?
> 
> All this is horribly broken on Alpha pre EV56 (and any other arch that
> cannot do single-copy atomic byte stores).
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/asm-generic/qspinlock_types.h |   13 ++++
>  kernel/locking/qspinlock.c            |  103 ++++++++++++++++++++++++++++++----
>  2 files changed, 106 insertions(+), 10 deletions(-)
> 
> --- a/include/asm-generic/qspinlock_types.h
> +++ b/include/asm-generic/qspinlock_types.h
> @@ -38,6 +38,14 @@ typedef struct qspinlock {
>  /*
>   * Bitfields in the atomic value:
>   *
> + * When NR_CPUS < 16K
> + *  0- 7: locked byte
> + *     8: pending
> + *  9-15: not used
> + * 16-17: tail index
> + * 18-31: tail cpu (+1)
> + *
> + * When NR_CPUS >= 16K
>   *  0- 7: locked byte
>   *     8: pending
>   *  9-10: tail index
> @@ -50,7 +58,11 @@ typedef struct qspinlock {
>  #define _Q_LOCKED_MASK		_Q_SET_MASK(LOCKED)
>  
>  #define _Q_PENDING_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
> +#if CONFIG_NR_CPUS < (1U << 14)
> +#define _Q_PENDING_BITS		8
> +#else
>  #define _Q_PENDING_BITS		1
> +#endif
>  #define _Q_PENDING_MASK		_Q_SET_MASK(PENDING)
>  
>  #define _Q_TAIL_IDX_OFFSET	(_Q_PENDING_OFFSET + _Q_PENDING_BITS)
> @@ -61,6 +73,7 @@ typedef struct qspinlock {
>  #define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
>  #define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
>  
> +#define _Q_TAIL_OFFSET		_Q_TAIL_IDX_OFFSET
>  #define _Q_TAIL_MASK		(_Q_TAIL_IDX_MASK | _Q_TAIL_CPU_MASK)
>  
>  #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -22,6 +22,7 @@
>  #include <linux/percpu.h>
>  #include <linux/hardirq.h>
>  #include <linux/mutex.h>
> +#include <asm/byteorder.h>
>  #include <asm/qspinlock.h>
>  
>  /*
> @@ -48,6 +49,9 @@
>   * We can further change the first spinner to spin on a bit in the lock word
>   * instead of its node; whereby avoiding the need to carry a node from lock to
>   * unlock, and preserving API.
> + *
> + * N.B. The current implementation only supports architectures that allow
> + *      atomic operations on smaller 8-bit and 16-bit data types.
>   */
>  
>  #include "mcs_spinlock.h"
> @@ -85,6 +89,87 @@ static inline struct mcs_spinlock *decod
>  
>  #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
>  
> +/*
> + * By using the whole 2nd least significant byte for the pending bit, we
> + * can allow better optimization of the lock acquisition for the pending
> + * bit holder.
> + */
> +#if _Q_PENDING_BITS == 8
> +
> +struct __qspinlock {
> +	union {
> +		atomic_t val;
> +		struct {
> +#ifdef __LITTLE_ENDIAN
> +			u16	locked_pending;
> +			u16	tail;
> +#else
> +			u16	tail;
> +			u16	locked_pending;
> +#endif
> +		};
> +	};
> +};
> +
> +/**
> + * clear_pending_set_locked - take ownership and clear the pending bit.
> + * @lock: Pointer to queue spinlock structure
> + * @val : Current value of the queue spinlock 32-bit word
> + *
> + * *,1,0 -> *,0,1
> + *
> + * Lock stealing is not allowed if this function is used.
> + */
> +static __always_inline void
> +clear_pending_set_locked(struct qspinlock *lock, u32 val)
> +{
> +	struct __qspinlock *l = (void *)lock;
> +
> +	ACCESS_ONCE(l->locked_pending) = _Q_LOCKED_VAL;
> +}
> +
> +/*
> + * xchg_tail - Put in the new queue tail code word & retrieve previous one

Missing full stop.
> + * @lock : Pointer to queue spinlock structure
> + * @tail : The new queue tail code word
> + * Return: The previous queue tail code word
> + *
> + * xchg(lock, tail)
> + *
> + * p,*,* -> n,*,* ; prev = xchg(lock, node)
> + */
> +static __always_inline u32 xchg_tail(struct qspinlock *lock, u32 tail)
> +{
> +	struct __qspinlock *l = (void *)lock;
> +
> +	return (u32)xchg(&l->tail, tail >> _Q_TAIL_OFFSET) << _Q_TAIL_OFFSET;
> +}
> +
> +#else /* _Q_PENDING_BITS == 8 */
> +
> +/**
> + * clear_pending_set_locked - take ownership and clear the pending bit.
> + * @lock: Pointer to queue spinlock structure
> + * @val : Current value of the queue spinlock 32-bit word
> + *
> + * *,1,0 -> *,0,1
> + */
> +static __always_inline void
> +clear_pending_set_locked(struct qspinlock *lock, u32 val)
> +{
> +	u32 new, old;
> +
> +	for (;;) {
> +		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +}
> +
>  /**
>   * xchg_tail - Put in the new queue tail code word & retrieve previous one
>   * @lock : Pointer to queue spinlock structure
> @@ -109,6 +194,7 @@ static __always_inline u32 xchg_tail(str
>  	}
>  	return old;
>  }
> +#endif /* _Q_PENDING_BITS == 8 */
>  
>  /**
>   * queue_spin_lock_slowpath - acquire the queue spinlock
> @@ -173,8 +259,13 @@ void queue_spin_lock_slowpath(struct qsp
>  	 * we're pending, wait for the owner to go away.
>  	 *
>  	 * *,1,1 -> *,1,0
> +	 *
> +	 * this wait loop must be a load-acquire such that we match the
> +	 * store-release that clears the locked bit and create lock
> +	 * sequentiality; this because not all clear_pending_set_locked()
> +	 * implementations imply full barriers.
>  	 */
> -	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> +	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK)

lock->val.counter? Ugh, all to deal with the 'int' -> 'u32' (or 'u64')

Could you introduce a macro in atomic.h called 'atomic_read_raw' which
would do the this? Like this:


diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index fef3a80..5a83750 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -160,6 +160,8 @@ static inline void atomic_or(int i, atomic_t *v)
 }
 #endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
 
+#define atomic_read_raw(v)	(v.counter)
+
 #include <asm-generic/atomic-long.h>
 #ifdef CONFIG_GENERIC_ATOMIC64
 #include <asm-generic/atomic64.h>
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index fc7fd8c..2833fe1 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -265,7 +265,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * sequentiality; this because not all clear_pending_set_locked()
 	 * implementations imply full barriers.
 	 */
-	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK)
+	while ((val = smp_load_acquire(atomic_read_raw(&lock->val))) & _Q_LOCKED_MASK)
 		arch_mutex_cpu_relax();
 
 	/*

?
>  		cpu_relax();
>  
>  	/*
> @@ -182,15 +273,7 @@ void queue_spin_lock_slowpath(struct qsp
>  	 *
>  	 * *,1,0 -> *,0,1
>  	 */
> -	for (;;) {
> -		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> -
> -		old = atomic_cmpxchg(&lock->val, val, new);
> -		if (old == val)
> -			break;
> -
> -		val = old;
> -	}
> +	clear_pending_set_locked(lock, val);
>  	return;
>  
>  	/*
> 
> 
