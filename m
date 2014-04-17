Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaDQQyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:54:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaDQQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:54:31 -0400
Date: Thu, 17 Apr 2014 18:54:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 07/19] qspinlock: Use a simple write to grab the lock,
 if applicable
Message-ID: <20140417165408.GU11096@twins.programming.kicks-ass.net>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
 <1397747051-15401-8-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397747051-15401-8-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:03:59AM -0400, Waiman Long wrote:
>  kernel/locking/qspinlock.c |   61 +++++++++++++++++++++++++++++++------------
>  1 files changed, 44 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index 497da24..80fe9ee 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -98,23 +98,29 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
>   * can allow better optimization of the lock acquisition for the pending
>   * bit holder.
>   */
> -#if _Q_PENDING_BITS == 8
> -
>  struct __qspinlock {
>  	union {
>  		atomic_t val;
> -		struct {
>  #ifdef __LITTLE_ENDIAN
> +		u8	 locked;
> +		struct {
>  			u16	locked_pending;
>  			u16	tail;
> +		};
>  #else
> +		struct {
>  			u16	tail;
>  			u16	locked_pending;
> -#endif
>  		};
> +		struct {
> +			u8	reserved[3];
> +			u8	locked;
> +		};
> +#endif

Ah, yes, that's probably nicer than what I made of it..

>  	};
>  };
>  
> +#if _Q_PENDING_BITS == 8
>  /**
>   * clear_pending_set_locked - take ownership and clear the pending bit.
>   * @lock: Pointer to queue spinlock structure
> @@ -204,6 +210,22 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
>  #endif /* _Q_PENDING_BITS == 8 */
>  
>  /**
> + * get_qlock - Set the lock bit and own the lock
> + * @lock: Pointer to queue spinlock structure
> + *
> + * This routine should only be called when the caller is the only one
> + * entitled to acquire the lock.
> + */
> +static __always_inline void get_qlock(struct qspinlock *lock)

Don't like that function name though; what was wrong with set_locked(),
which is more or less what I called it.

> +{
> +	struct __qspinlock *l = (void *)lock;
> +
> +	barrier();
> +	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
> +	barrier();
> +}

> @@ -378,15 +403,19 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>  	 *
>  	 * n,0,0 -> 0,0,1 : lock, uncontended
>  	 * *,0,0 -> *,0,1 : lock, contended
> +	 *
> +	 * If the queue head is the only one in the queue (lock value == tail),
> +	 * clear the tail code and grab the lock. Otherwise, we only need
> +	 * to grab the lock.
>  	 */
>  	for (;;) {
> -		new = _Q_LOCKED_VAL;
> -		if (val != tail)
> -			new |= val;
> -
> -		old = atomic_cmpxchg(&lock->val, val, new);
> -		if (old == val)
> +		if (val != tail) {
> +			get_qlock(lock);
>  			break;
> +		}

Ah, good one. I hadn't done that.

> +		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
> +		if (old == val)
> +			goto release;	/* No contention */
>  
>  		val = old;
>  	}

I did have a patch that played tricks with ->next, but I seem to have
forgotten the details, and I tossed the patch because it didn't show any
difference on the benchmark.
