Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3LYDNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 22:13:40 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:16817 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3LYDNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 22:13:39 -0500
Message-ID: <52BA4D4C.6070709@hp.com>
Date: Tue, 24 Dec 2013 22:13:16 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>  <1387478746-5436-5-git-send-email-davidlohr@hp.com>  <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com> <1387589770.3119.2.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1387589770.3119.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 08:36 PM, Davidlohr Bueso wrote:
> On Thu, 2013-12-19 at 15:14 -0800, Linus Torvalds wrote:
>> On Thu, Dec 19, 2013 at 10:45 AM, Davidlohr Bueso<davidlohr@hp.com>  wrote:
>>> - increment the counter at queue_lock() as we always end up calling
>>>    queue_me() which adds the element to the list. Upon any error,
>>>    queue_unlock() is called for housekeeping, for which we decrement
>>>    to mach the increment done in queue_lock().
>>>
>>> - decrement the counter at __unqueue_me() to reflect when an element is
>>>    removed from the queue for wakeup related purposes.
>> I still hate this whole separate counter thing. It seems really annoying.
>>
>> If re-ordering things didn't work out, then why can't just the counter
>> we *already* have in the spinlock itself work as the counter? Your
>> counter update logic seems to basically match when you take the
>> spinlock anyway.
> So the following has passed all testing, just like the atomics variant.
> Thoughts?
>
> Thanks,
> Davidlohr
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fcc6850..c8c7ce5 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -73,19 +73,22 @@
>    * Basic futex operation and ordering guarantees:
>    *
>    * The waiter reads the futex value in user space and calls
> - * futex_wait(). This function computes the hash bucket and acquires
> - * the hash bucket lock. After that it reads the futex user space value
> - * again and verifies that the data has not changed. If it has not
> - * changed it enqueues itself into the hash bucket, releases the hash
> + * futex_wait(). It computes the hash bucket and acquires the hash
> + * bucket lock. After that it reads the futex user space value again
> + * and verifies that the data has not changed. If it has not changed
> + * it enqueues itself into the hash bucket, releases the hash
>    * bucket lock and schedules.
>    *
>    * The waker side modifies the user space value of the futex and calls
> - * futex_wake(). This functions computes the hash bucket and acquires
> - * the hash bucket lock. Then it looks for waiters on that futex in the
> - * hash bucket and wakes them.
> + * futex_wake(). It computes the hash bucket and acquires the hash
> + * bucket lock. Then it looks for waiters on that futex in the hash
> + * bucket and wakes them.
>    *
> - * Note that the spin_lock serializes waiters and wakers, so that the
> - * following scenario is avoided:
> + * In scenarios where wakeups are called and no tasks are blocked on a futex,
> + * taking the hb spinlock can be avoided and simply return. In order for this
> + * optimization to work, ordering guarantees must exist so that the waiter
> + * being added to the list is acknowledged when the list is concurrently being
> + * checked by the waker, avoiding scenarios like the following:
>    *
>    * CPU 0                               CPU 1
>    * val = *futex;
> @@ -106,24 +109,50 @@
>    * This would cause the waiter on CPU 0 to wait forever because it
>    * missed the transition of the user space value from val to newval
>    * and the waker did not find the waiter in the hash bucket queue.
> - * The spinlock serializes that:
> + *
> + * The correct serialization ensures that a waiter either observes
> + * the changed user space value before blocking or is woken by a
> + * concurrent waker:
>    *
>    * CPU 0                               CPU 1
>    * val = *futex;
>    * sys_futex(WAIT, futex, val);
>    *   futex_wait(futex, val);
> - *   lock(hash_bucket(futex));
> - *   uval = *futex;
> - *                                     *futex = newval;
> - *                                     sys_futex(WAKE, futex);
> - *                                       futex_wake(futex);
> - *                                       lock(hash_bucket(futex));
> + *
> + *   waiters++;
> + *   mb(); (A)<-- paired with -.
> + *                              |
> + *   lock(hash_bucket(futex));  |
> + *                              |
> + *   uval = *futex;             |
> + *                              |        *futex = newval;
> + *                              |        sys_futex(WAKE, futex);
> + *                              |          futex_wake(futex);
> + *                              |
> + *                              `------->    mb(); (B)

Checking the state of the spinlock counter isn't the same as 
incrementing a waiter count. So your pseudo code here is misleading. See 
further explanation below.

>    *   if (uval == val)
> - *      queue();
> + *     queue();
>    *     unlock(hash_bucket(futex));
> - *     schedule();                       if (!queue_empty())
> - *                                         wake_waiters(futex);
> - *                                       unlock(hash_bucket(futex));
> + *     schedule();                         if (waiters)
> + *                                           lock(hash_bucket(futex));
> + *                                           wake_waiters(futex);
> + *                                           unlock(hash_bucket(futex));
> + *
> + * Where (A) orders the waiters increment and the futex value read -- this
> + * is guaranteed by the head counter in the hb spinlock; and where (B)
> + * orders the write to futex and the waiters read.
> + *
> + * This yields the following case (where X:=waiters, Y:=futex):
> + *
> + *	X = Y = 0
> + *
> + *	w[X]=1		w[Y]=1
> + *	MB		MB
> + *	r[Y]=y		r[X]=x
> + *
> + * Which guarantees that x==0&&  y==0 is impossible; which translates back into
> + * the guarantee that we cannot both miss the futex variable change and the
> + * enqueue.
>    */
>
>   int __read_mostly futex_cmpxchg_enabled;
> @@ -211,6 +240,35 @@ static unsigned long __read_mostly futex_hashsize;
>
>   static struct futex_hash_bucket *futex_queues;
>
> +static inline void futex_get_mm(union futex_key *key)
> +{
> +	atomic_inc(&key->private.mm->mm_count);
> +#ifdef CONFIG_SMP
> +	/*
> +	 * Ensure futex_get_mm() implies a full barrier such that
> +	 * get_futex_key() implies a full barrier. This is relied upon
> +	 * as full barrier (B), see the ordering comment above.
> +	 */
> +	smp_mb__after_atomic_inc();
> +#endif
> +}
> +
> +static inline bool hb_waiters_pending(struct futex_hash_bucket *hb)
> +{
> +#ifdef CONFIG_SMP
> +	/*
> +	 * If the hash bucket is locked then we know the ticket counter
> +	 * is non-zero and thus there is at least one waiter in the queue.
> +	 */
> +	if (spin_is_locked(&hb->lock))
> +		return true;
> +	smp_rmb(); /* Make sure we check the lock state first */
> +	return !plist_head_empty(&hb->chain);
> +#else
> +	return true;
> +#endif
> +}

The ticket spinlock counter is a cyclic counter that can cycle through 0 
periodically. So the zero-ness of the counter has no relation to whether 
it is locked or not.  Your comment above is not correct. What 
spin_is_locked() can tell you is whether one or more tasks are trying to 
get into the critical section which can be a waiter (most likely) or a 
waker. Coupled with checking if the list is empty, that could be a 
cheaper alternative to using a separate atomic counter, but it is also 
slightly less reliable and has a higher chance of false positive.

-Longman
