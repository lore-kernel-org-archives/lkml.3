Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975AbaFQUhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:37:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36444 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaFQUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:37:12 -0400
Date: Tue, 17 Jun 2014 16:36:15 -0400
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
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
Message-ID: <20140617203615.GA29634@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.196728583@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615130153.196728583@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:47:00PM +0200, Peter Zijlstra wrote:
> Because the qspinlock needs to touch a second cacheline; add a pending
> bit and allow a single in-word spinner before we punt to the second
> cacheline.

Could you add this in the description please:

And by second cacheline we mean the local 'node'. That is the:
mcs_nodes[0] and mcs_nodes[idx]

Perhaps it might be better then to split this in the header file
as this is trying to not be a slowpath code - but rather - a
pre-slow-path-lets-try-if-we can do another cmpxchg in case
the unlocker has just unlocked itself.

So something like:

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index e8a7ae8..29cc9c7 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -75,11 +75,21 @@ extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
  */
 static __always_inline void queue_spin_lock(struct qspinlock *lock)
 {
-	u32 val;
+	u32 val, new;
 
 	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
 	if (likely(val == 0))
 		return;
+
+	/* One more attempt - but if we fail mark it as pending. */
+	if (val == _Q_LOCKED_VAL) {
+		new = Q_LOCKED_VAL |_Q_PENDING_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == _Q_LOCKED_VAL) /* YEEY! */
+			return;
+		val = old;
+	}
 	queue_spin_lock_slowpath(lock, val);
 }

and then the slowpath preserves most of the old logic path
(with the pending bit stuff)?

 
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/asm-generic/qspinlock_types.h |   12 ++-
>  kernel/locking/qspinlock.c            |  109 +++++++++++++++++++++++++++-------
>  2 files changed, 97 insertions(+), 24 deletions(-)
> 
> --- a/include/asm-generic/qspinlock_types.h
> +++ b/include/asm-generic/qspinlock_types.h
> @@ -39,8 +39,9 @@ typedef struct qspinlock {
>   * Bitfields in the atomic value:
>   *
>   *  0- 7: locked byte
> - *  8- 9: tail index
> - * 10-31: tail cpu (+1)
> + *     8: pending
> + *  9-10: tail index
> + * 11-31: tail cpu (+1)
>   */
>  #define	_Q_SET_MASK(type)	(((1U << _Q_ ## type ## _BITS) - 1)\
>  				      << _Q_ ## type ## _OFFSET)
> @@ -48,7 +49,11 @@ typedef struct qspinlock {
>  #define _Q_LOCKED_BITS		8
>  #define _Q_LOCKED_MASK		_Q_SET_MASK(LOCKED)
>  
> -#define _Q_TAIL_IDX_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
> +#define _Q_PENDING_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
> +#define _Q_PENDING_BITS		1
> +#define _Q_PENDING_MASK		_Q_SET_MASK(PENDING)
> +
> +#define _Q_TAIL_IDX_OFFSET	(_Q_PENDING_OFFSET + _Q_PENDING_BITS)
>  #define _Q_TAIL_IDX_BITS	2
>  #define _Q_TAIL_IDX_MASK	_Q_SET_MASK(TAIL_IDX)
>  
> @@ -57,5 +62,6 @@ typedef struct qspinlock {
>  #define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
>  
>  #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
> +#define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
>  
>  #endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -83,24 +83,28 @@ static inline struct mcs_spinlock *decod
>  	return per_cpu_ptr(&mcs_nodes[idx], cpu);
>  }
>  
> +#define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
> +
>  /**
>   * queue_spin_lock_slowpath - acquire the queue spinlock
>   * @lock: Pointer to queue spinlock structure
>   * @val: Current value of the queue spinlock 32-bit word
>   *
> - * (queue tail, lock bit)
> - *
> - *              fast      :    slow                                  :    unlock
> - *                        :                                          :
> - * uncontended  (0,0)   --:--> (0,1) --------------------------------:--> (*,0)
> - *                        :       | ^--------.                    /  :
> - *                        :       v           \                   |  :
> - * uncontended            :    (n,x) --+--> (n,0)                 |  :
> - *   queue                :       | ^--'                          |  :
> - *                        :       v                               |  :
> - * contended              :    (*,x) --+--> (*,0) -----> (*,1) ---'  :
> - *   queue                :         ^--'                             :
> + * (queue tail, pending bit, lock bit)
>   *
> + *              fast     :    slow                                  :    unlock
> + *                       :                                          :
> + * uncontended  (0,0,0) -:--> (0,0,1) ------------------------------:--> (*,*,0)
> + *                       :       | ^--------.------.             /  :
> + *                       :       v           \      \            |  :
> + * pending               :    (0,1,1) +--> (0,1,0)   \           |  :
> + *                       :       | ^--'              |           |  :
> + *                       :       v                   |           |  :
> + * uncontended           :    (n,x,y) +--> (n,0,0) --'           |  :
> + *   queue               :       | ^--'                          |  :
> + *                       :       v                               |  :
> + * contended             :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
> + *   queue               :         ^--'                             :
>   */
>  void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>  {
> @@ -110,6 +114,65 @@ void queue_spin_lock_slowpath(struct qsp
>  
>  	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
>  
> +	/*
> +	 * trylock || pending
> +	 *
> +	 * 0,0,0 -> 0,0,1 ; trylock
> +	 * 0,0,1 -> 0,1,1 ; pending
> +	 */
> +	for (;;) {
> +		/*
> +		 * If we observe any contention; queue.
> +		 */
> +		if (val & ~_Q_LOCKED_MASK)
> +			goto queue;
> +
> +		new = _Q_LOCKED_VAL;
> +		if (val == new)
> +			new |= _Q_PENDING_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +
> +	/*
> +	 * we won the trylock
> +	 */
> +	if (new == _Q_LOCKED_VAL)
> +		return;
> +
> +	/*
> +	 * we're pending, wait for the owner to go away.
> +	 *
> +	 * *,1,1 -> *,1,0
> +	 */
> +	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> +		cpu_relax();
> +
> +	/*
> +	 * take ownership and clear the pending bit.
> +	 *
> +	 * *,1,0 -> *,0,1
> +	 */
> +	for (;;) {
> +		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +	return;
> +
> +	/*
> +	 * End of pending bit optimistic spinning and beginning of MCS
> +	 * queuing.
> +	 */
> +queue:
>  	node = this_cpu_ptr(&mcs_nodes[0]);
>  	idx = node->count++;
>  	tail = encode_tail(smp_processor_id(), idx);
> @@ -119,15 +182,18 @@ void queue_spin_lock_slowpath(struct qsp
>  	node->next = NULL;
>  
>  	/*
> +	 * we already touched the queueing cacheline; don't bother with pending
> +	 * stuff.
> +	 *
>  	 * trylock || xchg(lock, node)
>  	 *
> -	 * 0,0 -> 0,1 ; trylock
> -	 * p,x -> n,x ; prev = xchg(lock, node)
> +	 * 0,0,0 -> 0,0,1 ; trylock
> +	 * p,y,x -> n,y,x ; prev = xchg(lock, node)
>  	 */
>  	for (;;) {
>  		new = _Q_LOCKED_VAL;
>  		if (val)
> -			new = tail | (val & _Q_LOCKED_MASK);
> +			new = tail | (val & _Q_LOCKED_PENDING_MASK);
>  
>  		old = atomic_cmpxchg(&lock->val, val, new);
>  		if (old == val)
> @@ -145,7 +211,7 @@ void queue_spin_lock_slowpath(struct qsp
>  	/*
>  	 * if there was a previous node; link it and wait.
>  	 */
> -	if (old & ~_Q_LOCKED_MASK) {
> +	if (old & ~_Q_LOCKED_PENDING_MASK) {
>  		prev = decode_tail(old);
>  		ACCESS_ONCE(prev->next) = node;
>  
> @@ -153,18 +219,19 @@ void queue_spin_lock_slowpath(struct qsp
>  	}
>  
>  	/*
> -	 * we're at the head of the waitqueue, wait for the owner to go away.
> +	 * we're at the head of the waitqueue, wait for the owner & pending to
> +	 * go away.
>  	 *
> -	 * *,x -> *,0
> +	 * *,x,y -> *,0,0
>  	 */
> -	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> +	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_PENDING_MASK)
>  		cpu_relax();
>  
>  	/*
>  	 * claim the lock:
>  	 *
> -	 * n,0 -> 0,1 : lock, uncontended
> -	 * *,0 -> *,1 : lock, contended
> +	 * n,0,0 -> 0,0,1 : lock, uncontended
> +	 * *,0,0 -> *,0,1 : lock, contended
>  	 */
>  	for (;;) {
>  		new = _Q_LOCKED_VAL;
> 
> 
