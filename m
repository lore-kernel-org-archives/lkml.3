Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaFPU27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:28:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:21415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbaFPU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:28:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,489,1400050800"; 
   d="scan'208";a="529412144"
Message-ID: <1402950997.15603.39.camel@rage>
Subject: Re: [patch V2 5/5] futex: Simplify futex_lock_pi_atomic() and make
 it more robust
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Mon, 16 Jun 2014 13:36:37 -0700
In-Reply-To: <alpine.DEB.2.10.1406131137020.5170@nanos>
References: <20140611202744.676528190@linutronix.de>
	  <20140611204237.361836310@linutronix.de>
	 <1402638363.22229.23.camel@fury.dvhart.com>
	 <alpine.DEB.2.10.1406131033440.5170@nanos>
	 <alpine.DEB.2.10.1406131136140.5170@nanos>
	 <alpine.DEB.2.10.1406131137020.5170@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 11:44 +0200, Thomas Gleixner wrote:
> Subject: futex: Simplify futex_lock_pi_atomic() and make it more robust
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 11 Jun 2014 20:45:41 -0000
> 
> futex_lock_pi_atomic() is a maze of retry hoops and loops.
> 
> Reduce it to simple and understandable states:
> 
> First step is to lookup existing waiters (state) in the kernel.
> 
> If there is an existing waiter, validate it and attach to it.
> 
> If there is no existing waiter, check the user space value
> 
> If the TID encoded in the user space value is 0, take over the futex
> preserving the owner died bit.
> 
> If the TID encoded in the user space value is != 0, lookup the owner
> task, validate it and attach to it.
> 
> Reduces text size by 128 bytes on x8664.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Darren Hart <darren@dvhart.com>
> Cc: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Kees Cook <kees@outflux.net>
> Cc: wad@chromium.org
> Link: http://lkml.kernel.org/r/20140611204237.361836310@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> 
> V2: Fixed the brown paperbag bug of V1
> 
>  kernel/futex.c |  141 ++++++++++++++++++++++-----------------------------------
>  1 file changed, 55 insertions(+), 86 deletions(-)
> 
> Index: linux/kernel/futex.c
> ===================================================================
> --- linux.orig/kernel/futex.c
> +++ linux/kernel/futex.c
> @@ -956,6 +956,17 @@ static int lookup_pi_state(u32 uval, str
>  	return attach_to_pi_owner(uval, key, ps);
>  }
>  
> +static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
> +{
> +	u32 uninitialized_var(curval);
> +
> +	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
> +		return -EFAULT;
> +
> +	/*If user space value changed, let the caller retry */
> +	return curval != uval ? -EAGAIN : 0;
> +}

Given the complexity of this update and how fragile this path can be, I
think this refactoring would be best done in an independent patch, as
you did with the previous two.

Two general concerns, we appear to be eliminating both the force_take
and the retry.

The force_take only occurs if TID==0, and that is covered here in a
cleaner way, so I believe we are good here.

As for the retry, the remaining use case (outside of TID==0 ->
force_take=1 -> retry) appears to be that userspace changed the value
while we were running. Reading the value early doesn't protect us from
this scenario. How does this change account for that?

It looks to me that before we would retry, while here we just give up
and return -EAGAIN..., which is addressed in futex_lock_pi(), but not in
the futex_requeue() callsite for futex_proxy_trylock_atomic. It does
handle it, but I guess also needs a comment update to "The owner was
exiting" to include "or userspace changed the value" as you did for
futex_lock_pi().

>From my analysis, this is a good cleanup and makes the code for
explicit. I'm nervous about missing corner cases, and would like to
understand what level of testing this has received. We need to add PI
locking tests to futextest. There are some in glibc. Which tests were
run to validate PI locking?

Thanks,

Darren Hart
> +
>  /**
>   * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
>   * @uaddr:		the pi futex user address
> @@ -979,113 +990,69 @@ static int futex_lock_pi_atomic(u32 __us
>  				struct futex_pi_state **ps,
>  				struct task_struct *task, int set_waiters)
>  {
> -	int lock_taken, ret, force_take = 0;
> -	u32 uval, newval, curval, vpid = task_pid_vnr(task);
> -
> -retry:
> -	ret = lock_taken = 0;
> +	u32 uval, newval, vpid = task_pid_vnr(task);
> +	struct futex_q *match;
> +	int ret;
>  
>  	/*
> -	 * To avoid races, we attempt to take the lock here again
> -	 * (by doing a 0 -> TID atomic cmpxchg), while holding all
> -	 * the locks. It will most likely not succeed.
> +	 * Read the user space value first so we can validate a few
> +	 * things before proceeding further.
>  	 */
> -	newval = vpid;
> -	if (set_waiters)
> -		newval |= FUTEX_WAITERS;
> -
> -	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
> +	if (get_futex_value_locked(&uval, uaddr))
>  		return -EFAULT;
>  
>  	/*
>  	 * Detect deadlocks.
>  	 */
> -	if ((unlikely((curval & FUTEX_TID_MASK) == vpid)))
> +	if ((unlikely((uval & FUTEX_TID_MASK) == vpid)))
>  		return -EDEADLK;
>  
>  	/*
> -	 * Surprise - we got the lock, but we do not trust user space at all.
> +	 * Lookup existing state first. If it exists, try to attach to
> +	 * its pi_state.
>  	 */
> -	if (unlikely(!curval)) {
> -		/*
> -		 * We verify whether there is kernel state for this
> -		 * futex. If not, we can safely assume, that the 0 ->
> -		 * TID transition is correct. If state exists, we do
> -		 * not bother to fixup the user space state as it was
> -		 * corrupted already.
> -		 */
> -		return futex_top_waiter(hb, key) ? -EINVAL : 1;
> -	}
> -
> -	uval = curval;
> +	match = futex_top_waiter(hb, key);
> +	if (match)
> +		return attach_to_pi_state(uval, match->pi_state, ps);
>  
>  	/*
> -	 * Set the FUTEX_WAITERS flag, so the owner will know it has someone
> -	 * to wake at the next unlock.
> +	 * No waiter and user TID is 0. We are here because the
> +	 * waiters or the owner died bit is set or called from
> +	 * requeue_cmp_pi or for whatever reason something took the
> +	 * syscall.
>  	 */
> -	newval = curval | FUTEX_WAITERS;
> -
> -	/*
> -	 * Should we force take the futex? See below.
> -	 */
> -	if (unlikely(force_take)) {
> +	if (!(uval & FUTEX_TID_MASK)) {
>  		/*
> -		 * Keep the OWNER_DIED and the WAITERS bit and set the
> -		 * new TID value.
> +		 * We take over the futex. No other waiters and the user space
> +		 * TID is 0. We preserve the owner died bit.
>  		 */
> -		newval = (curval & ~FUTEX_TID_MASK) | vpid;
> -		force_take = 0;
> -		lock_taken = 1;
> -	}
> +		newval = uval & FUTEX_OWNER_DIED;
> +		newval |= vpid;
>  
> -	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
> -		return -EFAULT;
> -	if (unlikely(curval != uval))
> -		goto retry;
> +		/* The futex requeue_pi code can enforce the waiters bit */
> +		if (set_waiters)
> +			newval |= FUTEX_WAITERS;
> +
> +		ret = lock_pi_update_atomic(uaddr, uval, newval);
> +		/* If the take over worked, return 1 */
> +		return ret < 0 ? ret : 1;
> +	}
>  
>  	/*
> -	 * We took the lock due to forced take over.
> +	 * First waiter. Set the waiters bit before attaching ourself to
> +	 * the owner. If owner tries to unlock, it will be forced into
> +	 * the kernel and blocked on hb->lock.
>  	 */
> -	if (unlikely(lock_taken))
> -		return 1;
> -
> +	newval = uval | FUTEX_WAITERS;
> +	ret = lock_pi_update_atomic(uaddr, uval, newval);
> +	if (ret)
> +		return ret;
>  	/*
> -	 * We dont have the lock. Look up the PI state (or create it if
> -	 * we are the first waiter):
> +	 * If the update of the user space value succeeded, we try to
> +	 * attach to the owner. If that fails, no harm done, we only
> +	 * set the FUTEX_WAITERS bit in the user space variable.
>  	 */
> -	ret = lookup_pi_state(uval, hb, key, ps);
> -
> -	if (unlikely(ret)) {
> -		switch (ret) {
> -		case -ESRCH:
> -			/*
> -			 * We failed to find an owner for this
> -			 * futex. So we have no pi_state to block
> -			 * on. This can happen in two cases:
> -			 *
> -			 * 1) The owner died
> -			 * 2) A stale FUTEX_WAITERS bit
> -			 *
> -			 * Re-read the futex value.
> -			 */
> -			if (get_futex_value_locked(&curval, uaddr))
> -				return -EFAULT;
> -
> -			/*
> -			 * If the owner died or we have a stale
> -			 * WAITERS bit the owner TID in the user space
> -			 * futex is 0.
> -			 */
> -			if (!(curval & FUTEX_TID_MASK)) {
> -				force_take = 1;
> -				goto retry;
> -			}
> -		default:
> -			break;
> -		}
> -	}
> -
> -	return ret;
> +	return attach_to_pi_owner(uval, key, ps);
>  }
>  
>  /**
> @@ -2316,8 +2283,10 @@ retry_private:
>  			goto uaddr_faulted;
>  		case -EAGAIN:
>  			/*
> -			 * Task is exiting and we just wait for the
> -			 * exit to complete.
> +			 * Two reasons for this:
> +			 * - Task is exiting and we just wait for the
> +			 *   exit to complete.
> +			 * - The user space value changed.
>  			 */
>  			queue_unlock(hb);
>  			put_futex_key(&q.key);

-- 
Darren Hart
Intel Open Source Technology Center


