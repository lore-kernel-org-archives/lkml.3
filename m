Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaFQU4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:56:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41562 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaFQU4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:56:30 -0400
Date: Tue, 17 Jun 2014 16:55:25 -0400
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
Subject: Re: [PATCH 04/11] qspinlock: Extract out the exchange of tail code
 word
Message-ID: <20140617205525.GB29634@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.376621956@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615130153.376621956@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:47:01PM +0200, Peter Zijlstra wrote:
> From: Waiman Long <Waiman.Long@hp.com>
> 
> This patch extracts the logic for the exchange of new and previous tail
> code words into a new xchg_tail() function which can be optimized in a
> later patch.

And also adds a third try on acquiring the lock. That I think should
be a seperate patch.

And instead of saying 'later patch' you should spell out the name
of the patch. Especially as this might not be obvious from somebody
doing git bisection.

> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/asm-generic/qspinlock_types.h |    2 +
>  kernel/locking/qspinlock.c            |   58 +++++++++++++++++++++-------------
>  2 files changed, 38 insertions(+), 22 deletions(-)
> 
> --- a/include/asm-generic/qspinlock_types.h
> +++ b/include/asm-generic/qspinlock_types.h
> @@ -61,6 +61,8 @@ typedef struct qspinlock {
>  #define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
>  #define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
>  
> +#define _Q_TAIL_MASK		(_Q_TAIL_IDX_MASK | _Q_TAIL_CPU_MASK)
> +
>  #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
>  #define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
>  
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -86,6 +86,31 @@ static inline struct mcs_spinlock *decod
>  #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
>  
>  /**
> + * xchg_tail - Put in the new queue tail code word & retrieve previous one
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
> +	u32 old, new, val = atomic_read(&lock->val);
> +
> +	for (;;) {
> +		new = (val & _Q_LOCKED_PENDING_MASK) | tail;
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +	return old;
> +}
> +
> +/**
>   * queue_spin_lock_slowpath - acquire the queue spinlock
>   * @lock: Pointer to queue spinlock structure
>   * @val: Current value of the queue spinlock 32-bit word
> @@ -182,36 +207,25 @@ void queue_spin_lock_slowpath(struct qsp
>  	node->next = NULL;
>  
>  	/*
> -	 * we already touched the queueing cacheline; don't bother with pending
> -	 * stuff.
> -	 *
> -	 * trylock || xchg(lock, node)
> -	 *
> -	 * 0,0,0 -> 0,0,1 ; trylock
> -	 * p,y,x -> n,y,x ; prev = xchg(lock, node)
> +	 * We touched a (possibly) cold cacheline in the per-cpu queue node;
> +	 * attempt the trylock once more in the hope someone let go while we
> +	 * weren't watching.
>  	 */
> -	for (;;) {
> -		new = _Q_LOCKED_VAL;
> -		if (val)
> -			new = tail | (val & _Q_LOCKED_PENDING_MASK);
> -
> -		old = atomic_cmpxchg(&lock->val, val, new);
> -		if (old == val)
> -			break;
> -
> -		val = old;
> -	}
> +	if (queue_spin_trylock(lock))
> +		goto release;

So now are three of them? One in queue_spin_lock, then at the start
of this function when checking for the pending bit, and the once more
here. And that is because the local cache line might be cold for the
'mcs_index' struct?

That all seems to be a bit of experimental. But then we are already
in the slowpath so we could as well do:

for (i = 0; i < 10; i++)
	if (queue_spin_trylock(lock))
		goto release;

And would have the same effect.


>  
>  	/*
> -	 * we won the trylock; forget about queueing.
> +	 * we already touched the queueing cacheline; don't bother with pending
> +	 * stuff.

I guess we could also just erase the pending bit if we wanted too. The
optimistic spinning will still hit go to the queue label as lock->val will
have the tail value.

> +	 *
> +	 * p,*,* -> n,*,*
>  	 */
> -	if (new == _Q_LOCKED_VAL)
> -		goto release;
> +	old = xchg_tail(lock, tail);
>  
>  	/*
>  	 * if there was a previous node; link it and wait.
>  	 */
> -	if (old & ~_Q_LOCKED_PENDING_MASK) {
> +	if (old & _Q_TAIL_MASK) {
>  		prev = decode_tail(old);
>  		ACCESS_ONCE(prev->next) = node;
>  
> 
> 
