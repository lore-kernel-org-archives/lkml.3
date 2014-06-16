Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaFPQLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:11:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:27729 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaFPQLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,487,1400050800"; 
   d="scan'208";a="558311488"
Message-ID: <1402935528.15603.14.camel@rage>
Subject: Re: [patch 1/5] futex: Make unlock_pi more robust
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Mon, 16 Jun 2014 09:18:48 -0700
In-Reply-To: <20140611204237.016987332@linutronix.de>
References: <20140611202744.676528190@linutronix.de>
	 <20140611204237.016987332@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> The kernel tries to atomically unlock the futex without checking
> whether there is kernel state associated to the futex.
> 
> So if user space manipulated the user space value, this will leave
> kernel internal state around associated to the owner task. 
> 
> For robustness sake, lookup first whether there are waiters on the
> futex. If there are waiters, wake the top priority waiter with all the
> proper sanity checks applied.
> 
> If there are no waiters, do the atomic release. We do not have to
> preserve the waiters bit in this case, because a potentially incoming
> waiter is blocked on the hb->lock and will acquire the futex
> atomically. We neither have to preserve the owner died bit. The caller
> is the owner and it was supposed to cleanup the mess.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/futex.c |   78
> +++++++++++++++++++--------------------------------------
>  1 file changed, 26 insertions(+), 52 deletions(-)
> 
> Index: linux/kernel/futex.c
> ===================================================================
> --- linux.orig/kernel/futex.c
> +++ linux/kernel/futex.c
> @@ -1186,22 +1186,6 @@ static int wake_futex_pi(u32 __user *uad
>         return 0;
>  }
>  
> -static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
> -{
> -       u32 uninitialized_var(oldval);
> -
> -       /*
> -        * There is no waiter, so we unlock the futex. The owner died
> -        * bit has not to be preserved here. We are the owner:
> -        */
> -       if (cmpxchg_futex_value_locked(&oldval, uaddr, uval, 0))
> -               return -EFAULT;
> -       if (oldval != uval)
> -               return -EAGAIN;
> -
> -       return 0;
> -}

I thought we used that in multiple places, but apparently not. Worth
consolidating.

> -
>  /*
>   * Express the locking dependencies for lockdep:
>   */
> @@ -2401,10 +2385,10 @@ uaddr_faulted:
>   */
>  static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
>  {
> -       struct futex_hash_bucket *hb;
> -       struct futex_q *this, *next;
> +       u32 uninitialized_var(curval), uval, vpid =
> task_pid_vnr(current);
>         union futex_key key = FUTEX_KEY_INIT;
> -       u32 uval, vpid = task_pid_vnr(current);
> +       struct futex_hash_bucket *hb;
> +       struct futex_q *match;
>         int ret;
>  
>  retry:
> @@ -2417,57 +2401,47 @@ retry:
>                 return -EPERM;
>  
>         ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key,
> VERIFY_WRITE);
> -       if (unlikely(ret != 0))
> -               goto out;
> +       if (ret)
> +               return ret;

Looks like you're also trying to move away from a single exit point to
multiple exit points. I prefer the single exit (which you've probably
noticed :-), but it's a subjective thing, and so long as we are not
duplicating cleanup logic, I guess it's fine either way. This change was
not mentioned in the commit message though.

>  
>         hb = hash_futex(&key);
>         spin_lock(&hb->lock);
>  
>         /*
> -        * To avoid races, try to do the TID -> 0 atomic transition
> -        * again. If it succeeds then we can return without waking
> -        * anyone else up. We only try this if neither the waiters nor
> -        * the owner died bit are set.
> -        */
> -       if (!(uval & ~FUTEX_TID_MASK) &&
> -           cmpxchg_futex_value_locked(&uval, uaddr, vpid, 0))
> -               goto pi_faulted;
> -       /*
> -        * Rare case: we managed to release the lock atomically,
> -        * no need to wake anyone else up:
> -        */
> -       if (unlikely(uval == vpid))
> -               goto out_unlock;
> -
> -       /*
> -        * Ok, other tasks may need to be woken up - check waiters
> -        * and do the wakeup if necessary:
> -        */
> -       plist_for_each_entry_safe(this, next, &hb->chain, list) {
> -               if (!match_futex (&this->key, &key))
> -                       continue;
> -               ret = wake_futex_pi(uaddr, uval, this);
> +        * Check waiters first. We do not trust user space values at
> +        * all and we at least want to know if user space fiddled
> +        * with the futex value instead of blindly unlocking.
> +        */
> +       match = futex_top_waiter(hb, &key);
> +       if (match) {
> +               ret = wake_futex_pi(uaddr, uval, match);
>                 /*
> -                * The atomic access to the futex value
> -                * generated a pagefault, so retry the
> -                * user-access and the wakeup:
> +                * The atomic access to the futex value generated a
> +                * pagefault, so retry the user-access and the wakeup:
>                  */
>                 if (ret == -EFAULT)
>                         goto pi_faulted;
>                 goto out_unlock;
>         }
> +
>         /*
> -        * No waiters - kernel unlocks the futex:
> +        * We have no kernel internal state, i.e. no waiters in the
> +        * kernel. Waiters which are about to queue themself are stuck

themselves

> +        * on hb->lock. So we can safely ignore them. We do neither
> +        * preserve the WAITERS bit not the OWNER_DIED one. We are the

We preserve neither the WAITERS bit nor the OWNER_DIED bit.
(the above use of "do" and "not" is incorrect and could easily be
misinterpreted).

> +        * owner.

In wake_futex_pi we verify ownership by matching pi_state->owner ==
current, but here the only test is the TID value, which is set by
userspace - which we don't trust...

I'm trying to determine if it matters in this case... if there are no
waiters, is the pi_state still around? If so, it does indeed matter, and
we should be verifying.


>          */
> -       ret = unlock_futex_pi(uaddr, uval);
> -       if (ret == -EFAULT)
> +       if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))
>                 goto pi_faulted;
>  

This refactoring seems like it would be best done as a prequel patch so
as not to confuse cleanup with functional change. At least that is what
you and others have beaten into me over the years ;-)

> +       /*
> +        * If uval has changed, let user space handle it.
> +        */
> +       ret = (curval == uval) ? 0 : -EAGAIN;
> +
>  out_unlock:
>         spin_unlock(&hb->lock);
>         put_futex_key(&key);
> -
> -out:
>         return ret;
>  

By dropping this you won't return ret, but rather fall through into
pi_faulted... which certainly isn't what you wanted.

The need for better test coverage is very evident now :-)

--
Darren

>  pi_faulted:
> 


