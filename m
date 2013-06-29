Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3F2HRu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 03:17:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3F2HRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 03:17:48 -0400
Message-ID: <51CE8A14.4000400@canonical.com>
Date: Sat, 29 Jun 2013 09:17:40 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] mutex: do not unnecessarily deal with waiters
References: <1369353543.1770.0.camel@buesod1.americas.hpqcorp.net>  <20130627090016.GA4398@gmail.com>  <1372383138.2072.42.camel@buesod1.americas.hpqcorp.net>  <51CD24E1.2030608@canonical.com> <1372450398.2106.1.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1372450398.2106.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-06-13 22:13, Davidlohr Bueso schreef:
> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
>
> Upon entering the slowpath, we immediately attempt to acquire the lock
> by checking if it is already unlocked. If we are lucky enough that this
> is the case, then we don't need to deal with any waiter related logic.
>
> Furthermore any checks for an empty wait_list are unnecessary as we
> already know that count is non-negative and hence no one is waiting for
> the lock.
>
> Move the count check and xchg calls to be done before any waiters are
> setup - including waiter debugging. Upon failure to acquire the lock,
> the xchg sets the counter to 0, instead of -1 as it was originally.
> This can be done here since we set it back to -1 right at the beginning
> of the loop so other waiters are woken up when the lock is released.
>
> When tested on a 8-socket (80 core) system against a vanilla 3.10-rc1
> kernel, this patch provides some small performance benefits (+2-6%).
> While it could be considered in the noise level, the average percentages
> were stable across multiple runs and no performance regressions were seen.
> Two big winners, for small amounts of users (10-100), were the short and
> compute workloads had a +19.36% and +%15.76% in jobs per minute.
>
> Also change some break statements to 'goto slowpath', which IMO makes a
> little more intuitive to read.
Nice turquoise bikeshed you built there. ;-)

Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
> v1->v2: Rebase on -tip, dealing with the new W/W mutexes.
>
>  kernel/mutex.c | 41 ++++++++++++++++++-----------------------
>  1 file changed, 18 insertions(+), 23 deletions(-)
>
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index e581ada..61cce1f 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -460,7 +460,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  			 * performed the optimistic spinning cannot be done.
>  			 */
>  			if (ACCESS_ONCE(ww->ctx))
> -				break;
> +				goto slowpath;
>  		}
>  
>  		/*
> @@ -471,7 +471,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		owner = ACCESS_ONCE(lock->owner);
>  		if (owner && !mutex_spin_on_owner(lock, owner)) {
>  			mspin_unlock(MLOCK(lock), &node);
> -			break;
> +			goto slowpath;
>  		}
>  
>  		if ((atomic_read(&lock->count) == 1) &&
> @@ -486,8 +486,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  
>  			mutex_set_owner(lock);
>  			mspin_unlock(MLOCK(lock), &node);
> -			preempt_enable();
> -			return 0;
> +			goto done;
>  		}
>  		mspin_unlock(MLOCK(lock), &node);
>  
> @@ -498,7 +497,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		 * the owner complete.
>  		 */
>  		if (!owner && (need_resched() || rt_task(task)))
> -			break;
> +			goto slowpath;
>  
>  		/*
>  		 * The cpu_relax() call is a compiler barrier which forces
> @@ -512,6 +511,10 @@ slowpath:
>  #endif
>  	spin_lock_mutex(&lock->wait_lock, flags);
>  
> +	/* once more, can we acquire the lock? */
> +	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
> +		goto skip_wait;
> +
>  	debug_mutex_lock_common(lock, &waiter);
>  	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
>  
> @@ -519,9 +522,6 @@ slowpath:
>  	list_add_tail(&waiter.list, &lock->wait_list);
>  	waiter.task = task;
>  
> -	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, -1) == 1))
> -		goto done;
> -
>  	lock_contended(&lock->dep_map, ip);
>  
>  	for (;;) {
> @@ -535,7 +535,7 @@ slowpath:
>  		 * other waiters:
>  		 */
>  		if (MUTEX_SHOW_NO_WAITER(lock) &&
> -		   (atomic_xchg(&lock->count, -1) == 1))
> +		    (atomic_xchg(&lock->count, -1) == 1))
>  			break;
>  
>  		/*
> @@ -560,24 +560,25 @@ slowpath:
>  		schedule_preempt_disabled();
>  		spin_lock_mutex(&lock->wait_lock, flags);
>  	}
> +	mutex_remove_waiter(lock, &waiter, current_thread_info());
> +	/* set it to 0 if there are no waiters left: */
> +	if (likely(list_empty(&lock->wait_list)))
> +		atomic_set(&lock->count, 0);
> +	debug_mutex_free_waiter(&waiter);
>  
> -done:
> +skip_wait:
> +	/* got the lock - cleanup and rejoice! */
>  	lock_acquired(&lock->dep_map, ip);
> -	/* got the lock - rejoice! */
> -	mutex_remove_waiter(lock, &waiter, current_thread_info());
>  	mutex_set_owner(lock);
>  
>  	if (!__builtin_constant_p(ww_ctx == NULL)) {
> -		struct ww_mutex *ww = container_of(lock,
> -						      struct ww_mutex,
> -						      base);
> +		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
>  		struct mutex_waiter *cur;
>  
>  		/*
>  		 * This branch gets optimized out for the common case,
>  		 * and is only important for ww_mutex_lock.
>  		 */
> -
>  		ww_mutex_lock_acquired(ww, ww_ctx);
>  		ww->ctx = ww_ctx;
>  
> @@ -591,15 +592,9 @@ done:
>  		}
>  	}
>  
> -	/* set it to 0 if there are no waiters left: */
> -	if (likely(list_empty(&lock->wait_list)))
> -		atomic_set(&lock->count, 0);
> -
>  	spin_unlock_mutex(&lock->wait_lock, flags);
> -
> -	debug_mutex_free_waiter(&waiter);
> +done:
>  	preempt_enable();
> -
>  	return 0;
>  
>  err:

