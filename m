Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaFMFqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:46:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48410 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFMFqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:46:06 -0400
Message-ID: <1402638363.22229.23.camel@fury.dvhart.com>
Subject: Re: [patch 5/5] futex: Simplify futex_lock_pi_atomic() and make it
 more robust
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Thu, 12 Jun 2014 22:46:03 -0700
In-Reply-To: <20140611204237.361836310@linutronix.de>
References: <20140611202744.676528190@linutronix.de>
	 <20140611204237.361836310@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> futex_lock_pi_atomic() is a maze of retry hoops and loops.
> 
> Reduce it to simple and understandable states:

Heh... well...

With this patch applied (1-4 will not reproduce without 5), if userspace
wrongly sets the uval to 0, the pi_state can end up being NULL for a
subsequent requeue_pi operation:

[   10.426159] requeue: 00000000006022e0 to 00000000006022e4
[   10.427737]   this:ffff88013a637da8
[   10.428749]   waking:ffff88013a637da8
fut2 = 0
[   10.429994]   comparing requeue_pi_key
[   10.431034]   prepare waiter to take the rt_mutex
[   10.432344]   pi_state:          (null)
[   10.433414] BUG: unable to handle kernel NULL pointer dereference at
0000000000000038

This occurs in the requeue loop, in the requeue_pi block at:

	atomic_inc(&pi_state->refcount);


> 
> First step is to lookup existing waiters (state) in the kernel.
> 
> If there is an existing waiter, validate it and attach to it.
> 
> If there is no existing waiter, check the user space value
> 
> If the TID encoded in the user space value is 0, take over the futex
> preserving the owner died bit.

This is the scenario resulting in the panic. See below.

> 
> If the TID encoded in the user space value is != 0, lookup the owner
> task, validate it and attach to it.
> 
> Reduces text size by 144 bytes on x8664.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/futex.c |  139 +++++++++++++++++++++------------------------------------
>  1 file changed, 53 insertions(+), 86 deletions(-)
> 
> Index: linux/kernel/futex.c
> ===================================================================
> --- linux.orig/kernel/futex.c
> +++ linux/kernel/futex.c
> @@ -956,6 +956,17 @@ static int lookup_pi_state(u32 uval, str
>         return attach_to_pi_owner(uval, key, ps);
>  }
>  
> +static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
> +{
> +       u32 uninitialized_var(curval);
> +
> +       if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
> +               return -EFAULT;
> +
> +       /* If user space value changed, let the caller retry */
> +       return curval != uval ? -EAGAIN : 0;
> +}
> +
>  /**
>   * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
>   * @uaddr:             the pi futex user address
> @@ -979,113 +990,67 @@ static int futex_lock_pi_atomic(u32 __us
>                                 struct futex_pi_state **ps,
>                                 struct task_struct *task, int set_waiters)
>  {
> -       int lock_taken, ret, force_take = 0;
> -       u32 uval, newval, curval, vpid = task_pid_vnr(task);
> -
> -retry:
> -       ret = lock_taken = 0;
> +       u32 uval, newval, vpid = task_pid_vnr(task);
> +       struct futex_q *match;
> +       int ret;
>  
>         /*
> -        * To avoid races, we attempt to take the lock here again
> -        * (by doing a 0 -> TID atomic cmpxchg), while holding all
> -        * the locks. It will most likely not succeed.
> +        * Read the user space value first so we can validate a few
> +        * things before proceeding further.
>          */
> -       newval = vpid;
> -       if (set_waiters)
> -               newval |= FUTEX_WAITERS;
> -
> -       if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
> +       if (get_futex_value_locked(&uval, uaddr))
>                 return -EFAULT;
>  
>         /*
>          * Detect deadlocks.
>          */
> -       if ((unlikely((curval & FUTEX_TID_MASK) == vpid)))
> +       if ((unlikely((uval & FUTEX_TID_MASK) == vpid)))
>                 return -EDEADLK;
>  
>         /*
> -        * Surprise - we got the lock, but we do not trust user space at all.

We really don't want to drop this comment (at leas not the latter
half ;-)

> +        * Lookup existing state first. If it exists, try to attach to
> +        * its pi_state.
>          */
> -       if (unlikely(!curval)) {
> -               /*
> -                * We verify whether there is kernel state for this
> -                * futex. If not, we can safely assume, that the 0 ->
> -                * TID transition is correct. If state exists, we do
> -                * not bother to fixup the user space state as it was
> -                * corrupted already.
> -                */
> -               return futex_top_waiter(hb, key) ? -EINVAL : 1;

On successful acquisition, we used to return 1...

> -       }
> -
> -       uval = curval;
> +       match = futex_top_waiter(hb, key);
> +       if (match)
> +               return attach_to_pi_state(uval, match->pi_state, ps);
>  
>         /*
> -        * Set the FUTEX_WAITERS flag, so the owner will know it has someone
> -        * to wake at the next unlock.
> +        * No waiter and user TID is 0. We are here because the
> +        * waiters or the owner died bit is set or called from
> +        * requeue_cmp_pi or for whatever reason something took the
> +        * syscall.
>          */
> -       newval = curval | FUTEX_WAITERS;
> -
> -       /*
> -        * Should we force take the futex? See below.
> -        */
> -       if (unlikely(force_take)) {
> +       if (!(uval & FUTEX_TID_MASK)) {
>                 /*
> -                * Keep the OWNER_DIED and the WAITERS bit and set the
> -                * new TID value.
> +                * We take over the futex. No other waiters and the user space
> +                * TID is 0. We preserve the owner died bit.
>                  */

Or userspace is screwing with us and set it to 0 for no good reason at
all... so there could still be a waiter queued up from
FUTEX_WAIT_REQUEUE_PI.

> -               newval = (curval & ~FUTEX_TID_MASK) | vpid;
> -               force_take = 0;
> -               lock_taken = 1;
> -       }
> +               newval = uval & FUTEX_OWNER_DIED;
> +               newval |= vpid;
>  
> -       if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
> -               return -EFAULT;
> -       if (unlikely(curval != uval))
> -               goto retry;
> +               /* The futex requeue_pi code can enforce the waiters bit */
> +               if (set_waiters)
> +                       newval |= FUTEX_WAITERS;
> +
> +               return lock_pi_update_atomic(uaddr, uval, newval);

And now we return 0, resulting in futex_proxy_trylock_atomic also
returning 0, but the pi_state is NULL, and as it doesn't return > 0
(vpid), we don't look it up again after atomic acquisition in
futex_requeue().

And BANG.

Consider the following:

>From 3eec2db2654a6cd8dcac3c60acda0f16a3243e29 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhart@linux.intel.com>
Date: Thu, 12 Jun 2014 22:41:32 -0700
Subject: [PATCH] futex: Invert the return value of lock_pi_update_atomic

Indicate success to the caller by returning 1 for lock acquired.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 kernel/futex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 391df53..82b96a4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1033,7 +1033,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr,
struct futex_hash_bucket *hb,
 		if (set_waiters)
 			newval |= FUTEX_WAITERS;
 
-		return lock_pi_update_atomic(uaddr, uval, newval);
+		return !lock_pi_update_atomic(uaddr, uval, newval);
 	}
 
 	/*
-- 
2.0.0.rc2




--
Darren

> +       }
>  
>         /*
> -        * We took the lock due to forced take over.
> +        * First waiter. Set the waiters bit before attaching ourself to
> +        * the owner. If owner tries to unlock, it will be forced into
> +        * the kernel and blocked on hb->lock.
>          */
> -       if (unlikely(lock_taken))
> -               return 1;
> -
> +       newval = uval | FUTEX_WAITERS;
> +       ret = lock_pi_update_atomic(uaddr, uval, newval);
> +       if (ret)
> +               return ret;
>         /*
> -        * We dont have the lock. Look up the PI state (or create it if
> -        * we are the first waiter):
> +        * If the update of the user space value succeeded, we try to
> +        * attach to the owner. If that fails, no harm done, we only
> +        * set the FUTEX_WAITERS bit in the user space variable.
>          */
> -       ret = lookup_pi_state(uval, hb, key, ps);
> -
> -       if (unlikely(ret)) {
> -               switch (ret) {
> -               case -ESRCH:
> -                       /*
> -                        * We failed to find an owner for this
> -                        * futex. So we have no pi_state to block
> -                        * on. This can happen in two cases:
> -                        *
> -                        * 1) The owner died
> -                        * 2) A stale FUTEX_WAITERS bit
> -                        *
> -                        * Re-read the futex value.
> -                        */
> -                       if (get_futex_value_locked(&curval, uaddr))
> -                               return -EFAULT;
> -
> -                       /*
> -                        * If the owner died or we have a stale
> -                        * WAITERS bit the owner TID in the user space
> -                        * futex is 0.
> -                        */
> -                       if (!(curval & FUTEX_TID_MASK)) {
> -                               force_take = 1;
> -                               goto retry;
> -                       }
> -               default:
> -                       break;
> -               }
> -       }
> -
> -       return ret;
> +       return attach_to_pi_owner(uval, key, ps);
>  }
>  
>  /**
> @@ -2316,8 +2281,10 @@ retry_private:
>                         goto uaddr_faulted;
>                 case -EAGAIN:
>                         /*
> -                        * Task is exiting and we just wait for the
> -                        * exit to complete.
> +                        * Two reasons for this:
> +                        * - Task is exiting and we just wait for the
> +                        *   exit to complete.
> +                        * - The user space value changed.
>                          */
>                         queue_unlock(hb);
>                         put_futex_key(&q.key);
> 


