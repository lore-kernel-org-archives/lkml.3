Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaKCKfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:35:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:55616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaKCKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:35:15 -0500
Date: Mon, 3 Nov 2014 11:35:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v13 09/11] pvqspinlock, x86: Add para-virtualization
 support
Message-ID: <20141103103505.GZ23531@worktop.programming.kicks-ass.net>
References: <1414613951-32532-1-git-send-email-Waiman.Long@hp.com>
 <1414613951-32532-10-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414613951-32532-10-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:19:09PM -0400, Waiman Long wrote:
>  arch/x86/include/asm/pvqspinlock.h    |  411 +++++++++++++++++++++++++++++++++

I do wonder why all this needs to live in x86..

>  
> +#ifdef CONFIG_QUEUE_SPINLOCK
> +
> +static __always_inline void pv_kick_cpu(int cpu)
> +{
> +	PVOP_VCALLEE1(pv_lock_ops.kick_cpu, cpu);
> +}
> +
> +static __always_inline void pv_lockwait(u8 *lockbyte)
> +{
> +	PVOP_VCALLEE1(pv_lock_ops.lockwait, lockbyte);
> +}
> +
> +static __always_inline void pv_lockstat(enum pv_lock_stats type)
> +{
> +	PVOP_VCALLEE1(pv_lock_ops.lockstat, type);
> +}

Why are any of these PV ops? they're only called from other pv_*()
functions. What's the point of pv ops you only call from pv code?

> +/*
> + *	Queue Spinlock Para-Virtualization (PV) Support
> + *
> + * The PV support code for queue spinlock is roughly the same as that
> + * of the ticket spinlock.

Relative comments are bad, esp. since we'll make the ticket code go away
if this works, at which point this is a reference into a black hole.

>                             Each CPU waiting for the lock will spin until it
> + * reaches a threshold. When that happens, it will put itself to a halt state
> + * so that the hypervisor can reuse the CPU cycles in some other guests as
> + * well as returning other hold-up CPUs faster.




> +/**
> + * queue_spin_lock - acquire a queue spinlock
> + * @lock: Pointer to queue spinlock structure
> + *
> + * N.B. INLINE_SPIN_LOCK should not be enabled when PARAVIRT_SPINLOCK is on.

One should write a compile time fail for that, not a comment.

> + */
> +static __always_inline void queue_spin_lock(struct qspinlock *lock)
> +{
> +	u32 val;
> +
> +	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
> +	if (likely(val == 0))
> +		return;
> +	if (static_key_false(&paravirt_spinlocks_enabled))
> +		pv_queue_spin_lock_slowpath(lock, val);
> +	else
> +		queue_spin_lock_slowpath(lock, val);
> +}

No, this is just vile.. _that_ is what we have PV ops for. And at that
point its the same function it was before the PV stuff, so that whole
inline thing is then gone.

> +extern void queue_spin_unlock_slowpath(struct qspinlock *lock);
> +
>  /**
>   * queue_spin_unlock - release a queue spinlock
>   * @lock : Pointer to queue spinlock structure
>   *
>   * An effective smp_store_release() on the least-significant byte.
> + *
> + * Inlining of the unlock function is disabled when CONFIG_PARAVIRT_SPINLOCKS
> + * is defined. So _raw_spin_unlock() will be the only call site that will
> + * have to be patched.

again if you hard rely on the not inlining make a build fail not a
comment.

>   */
>  static inline void queue_spin_unlock(struct qspinlock *lock)
>  {
>  	barrier();
> +	if (!static_key_false(&paravirt_spinlocks_enabled)) {
> +		native_spin_unlock(lock);
> +		return;
> +	}
>  
> +	/*
> +	 * Need to atomically clear the lock byte to avoid racing with
> +	 * queue head waiter trying to set _QLOCK_LOCKED_SLOWPATH.
> +	 */
> +	if (unlikely(cmpxchg((u8 *)lock, _Q_LOCKED_VAL, 0) != _Q_LOCKED_VAL))
> +		queue_spin_unlock_slowpath(lock);
> +}

Idem, that static key stuff is wrong, use PV ops to switch between
unlock paths.

> @@ -354,7 +394,7 @@ queue:
>  	 * if there was a previous node; link it and wait until reaching the
>  	 * head of the waitqueue.
>  	 */
> -	if (old & _Q_TAIL_MASK) {
> +	if (!pv_link_and_wait_node(old, node) && (old & _Q_TAIL_MASK)) {
>  		prev = decode_tail(old);
>  		ACCESS_ONCE(prev->next) = node;
> @@ -369,9 +409,11 @@ queue:
>  	 *
>  	 * *,x,y -> *,0,0
>  	 */
> -	while ((val = smp_load_acquire(&lock->val.counter)) &
> -			_Q_LOCKED_PENDING_MASK)
> +	val = pv_wait_head(lock, node);
> +	while (val & _Q_LOCKED_PENDING_MASK) {
>  		cpu_relax();
> +		val = smp_load_acquire(&lock->val.counter);
> +	}
>  
>  	/*
>  	 * claim the lock:

Please make the pv_*() calls return void and reduce to NOPs. This keeps
the logic invariant of the pv stuff.
