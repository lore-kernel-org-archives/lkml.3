Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaHNRRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:17:49 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:47542 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaHNRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:17:48 -0400
Message-ID: <53ECEF32.6010706@hp.com>
Date: Thu, 14 Aug 2014 13:17:38 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: peterz@infradead.org, mingo@kernel.org, jason.low2@hp.com,
        scott.norton@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] locking/mutexes: Avoid bogus wakeups after lock
 stealing
References: <1407995870-4268-1-git-send-email-davidlohr@hp.com>
In-Reply-To: <1407995870-4268-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 01:57 AM, Davidlohr Bueso wrote:
> Mutexes lock-stealing functionality allows another task to
> skip its turn in the wait-queue and atomically acquire the lock.
> This is fine and a nice optimization, however, when releasing
> the mutex, we always wakeup the next task in FIFO order. When
> the lock has been stolen, this leads to wasting waking up a
> task just to immediately realize it cannot acquire the lock
> and just go back to sleep. While in practice this window is
> quite small, it is not about performance or avoid taking the
> wait_lock, but because avoiding bogus wakeups is the right thing
> to do.
>
> In order to deal with the race when potentially missing the
> unlock slowpath (details in the comments), we pessimistically set
> the lock to have waiters. The downside of this is that the task
> that now stole the lock would always have to acquire the mutex in
> its slowpath (as mutex_try_to_acquire() would never succeed.
> However, since this path is rarely called, the cost is really
> never noticed.
>
> Signed-off-by: Davidlohr Bueso<davidlohr@hp.com>
> ---
> Original thread: https://lkml.org/lkml/2014/8/8/37
>
>   kernel/locking/mutex.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index dadbf88..4570611 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -383,12 +383,26 @@ done:
>
>   	return false;
>   }
> +
> +static inline bool mutex_has_owner(struct mutex *lock)
> +{
> +	struct task_struct *owner = ACCESS_ONCE(lock->owner);
> +
> +	return owner != NULL;
> +}
> +
>   #else
> +
>   static bool mutex_optimistic_spin(struct mutex *lock,
>   				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
>   {
>   	return false;
>   }
> +
> +static inline bool mutex_has_owner(struct mutex *lock)
> +{
> +	return false;
> +}
>   #endif
>
>   __visible __used noinline
> @@ -715,6 +729,35 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>   {
>   	unsigned long flags;
>
> +/*
> + * Skipping the mutex_has_owner() check when DEBUG, allows us to
> + * avoid taking the wait_lock in order to do not call mutex_release()
> + * and debug_mutex_unlock() when !DEBUG. This can otherwise result in
> + * hung it a hung task when another one enters the lock's slowpath in
> + * mutex_lock().
> + */
> +#ifndef CONFIG_DEBUG_MUTEXES
> +	/*
> +	 * Abort the wakeup operation if there is an another mutex owner, as the
> +	 * lock was stolen. mutex_unlock() should have cleared the owner field
> +	 * before calling this function. If that field is now set, another task
> +	 * must have acquired the mutex. Note that this is a very tiny window.
> +	 */
> +	if (unlikely(mutex_has_owner(lock))) {
> +		/*
> +		 * Unconditionally set the lock to have waiters. Otherwise
> +		 * we can race with another task that grabbed the mutex via
> +		 * optimistic spinning and sets the lock to 0. When done,
> +		 * the unlock logic never reaches the slowpath, thus never
> +		 * waking the next task in the queue.
> +		 * Furthermore, this is safe as we've already acknowledged
> +		 * the fact that the lock was stolen and now a new owner
> +		 * exists.
> +		 */
> +		atomic_set(&lock->count, -1);
> +		return;
> +	}
> +#endif
>   	/*
>   	 * As a performance measurement, release the lock before doing other
>   	 * wakeup related duties to follow. This allows other tasks to acquire

I still think it is better to do that after spin_lock_mutex(). In 
addition, the atomic_set() is racy. It is better to something like

   if (atomic_cmpxchg(&lock->count, 0, -1) <= 0)
     return;

BTW, the current patch has no performance impact on x86 because 
__mutex_slowpath_needs_to_unlock() is true.

-Longman
