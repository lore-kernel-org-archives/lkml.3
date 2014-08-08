Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaHHSaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:30:07 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:60051 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHHSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:30:05 -0400
Message-ID: <53E5172A.7090508@hp.com>
Date: Fri, 08 Aug 2014 14:30:02 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>, aswin@hp.com
Subject: Re: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner
 before wakeup
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>  <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>  <1407458726.2513.12.camel@buesod1.americas.hpqcorp.net> <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 01:39 AM, Davidlohr Bueso wrote:
> On Thu, 2014-08-07 at 17:45 -0700, Davidlohr Bueso wrote:
>> On Thu, 2014-08-07 at 18:26 -0400, Waiman Long wrote:
>>> On a highly contended rwsem, spinlock contention due to the slow
>>> rwsem_wake() call can be a significant portion of the total CPU cycles
>>> used. With writer lock stealing and writer optimistic spinning, there
>>> is also a pretty good chance that the lock may have been stolen
>>> before the waker wakes up the waiters. The woken tasks, if any,
>>> will have to go back to sleep again.
>> Good catch! And this applies to mutexes as well. How about something
>> like this:
>>
>> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
>> index dadbf88..e037588 100644
>> --- a/kernel/locking/mutex.c
>> +++ b/kernel/locking/mutex.c
>> @@ -707,6 +707,20 @@ EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
>>
>>   #endif
>>
>> +#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_MUTEX_SPIN_ON_OWNER)
> If DEBUG, we don't clear the owner when unlocking. This can just be
>
> +#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>
>> +static inline bool mutex_has_owner(struct mutex *lock)
>> +{
>> +	struct task_struct *owner = ACCESS_ONCE(lock->owner);
>> +
>> +	return owner != NULL;
>> +}
>> +#else
>> +static inline bool mutex_has_owner(struct mutex *lock)
>> +{
>> +	return false;
>> +}
>> +#endif
>> +
>>   /*
>>    * Release the lock, slowpath:
>>    */
>> @@ -734,6 +748,15 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>>   	mutex_release(&lock->dep_map, nested, _RET_IP_);
>>   	debug_mutex_unlock(lock);
>>
>> +	/*
>> +	 * Abort the wakeup operation if there is an active writer as the
>> +	 * lock was stolen. mutex_unlock() should have cleared the owner field
>> +	 * before calling this function. If that field is now set, there must
>> +	 * be an active writer present.
>> +	 */
>> +	if (mutex_has_owner(lock))
>> +		goto done;
> Err so we actually deadlock here because we do the check with the
> lock->wait_lock held and at the same time another task comes into the
> slowpath of a mutex_lock() call which also tries to take the wait_lock.
> Ending up with hung tasks. Here's a more tested patch against
> peterz-queue, survives aim7 and kernel builds on a 80core box. Thanks.

I couldn't figure out why there will be hang tasks. The logic looks OK 
to me.

>
> 8<---------------------------------------------------------------
> From: Davidlohr Bueso<davidlohr@hp.com>
> Subject: [PATCH] locking/mutex: Do not falsely wake-up tasks
>
> Mutexes lock-stealing functionality allows another task to
> skip its turn in the wait-queue and atomically acquire the lock.
> This is fine and a nice optimization, however, when releasing
> the mutex, we always wakeup the next task in FIFO order. When
> the lock has been stolen this leads to wasting waking up a
> task just to immediately realize it cannot acquire the lock
> and just go back to sleep. This is specially true on highly
> contended mutexes that stress the wait_lock.
>
> Signed-off-by: Davidlohr Bueso<davidlohr@hp.com>
> ---
>   kernel/locking/mutex.c | 32 +++++++++++++++++++++++++++++++-
>   1 file changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index dadbf88..52e1136 100644
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
> @@ -730,6 +744,23 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>   	if (__mutex_slowpath_needs_to_unlock())
>   		atomic_set(&lock->count, 1);
>
> +/*
> + * Skipping the mutex_has_owner() check when DEBUG, allows us to
> + * avoid taking the wait_lock in order to do not call mutex_release()
> + * and debug_mutex_unlock() when !DEBUG. This can otherwise result in
> + * deadlocks when another task enters the lock's slowpath in mutex_lock().
> + */
> +#ifndef CONFIG_DEBUG_MUTEXES
> +	/*
> +	 * Abort the wakeup operation if there is an another mutex owner, as the
> +	 * lock was stolen. mutex_unlock() should have cleared the owner field
> +	 * before calling this function. If that field is now set, another task
> +	 * must have acquired the mutex.
> +	 */
> +	if (mutex_has_owner(lock))
> +		return;
> +#endif
> +
>   	spin_lock_mutex(&lock->wait_lock, flags);
>   	mutex_release(&lock->dep_map, nested, _RET_IP_);
>   	debug_mutex_unlock(lock);
> @@ -744,7 +775,6 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>
>   		wake_up_process(waiter->task);
>   	}
> -
>   	spin_unlock_mutex(&lock->wait_lock, flags);
>   }
>

I have 2 issues about this. First of all, the timing windows between 
atomic_set() and mutex_has_owner() check is really small, I doubt it 
will be that effective. Secondly, I think you may need to call 
mutex_release() and debug_mutex_unlock() to make the debugging code 
work, but they seems to be called only under the wait_lock. So I think 
there is more work that need to be done before this patch is ready.

-Longman
