Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3GHOVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:21:43 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:41917 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3GHOVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:21:42 -0400
Message-ID: <51DACADF.4000802@hp.com>
Date: Mon, 08 Jul 2013 10:21:19 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 01/12] spinlock: A new lockref structure for lockless
 update of refcount
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <1373035656-40600-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307051911110.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307051911110.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 02:59 PM, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Waiman Long wrote:
>> + * If the spinlock&  reference count optimization feature is disabled,
>> + * the spinlock and reference count are accessed separately on its own.
>> + */
>> +struct lockref {
>> +	unsigned int refcnt;	/* Reference count */
>> +	spinlock_t   lock;
>> +};
>> +
>> +/*
>> + * Struct lockref helper functions
>> + */
>> +/*
> Function documentation starts with /**

I will fix that.

>> + * lockref_get - increments reference count while not locked
> This should be: Increments reference count unconditionally.

Will change that.

>> + * @lockcnt: pointer to lockref structure
>> + */
>> +static __always_inline void
>> +lockref_get(struct lockref *lockcnt)
> Please avoid these line breaks if the line fits in 80 chars.

Will make the change.

>> +{
>> +	spin_lock(&lockcnt->lock);
>> +	lockcnt->refcnt++;
>> +	spin_unlock(&lockcnt->lock);
>> +}
>> +/*
>> + * lockref_put_or_locked - decrements count unless count<= 1 before decrement
>> + *			   otherwise the lock will be taken
>    lockref_put_or_lock please
>
> Docbook cannot work with multiline comments for the function name.
>
> So make that shorter and add a longer explanation below the @argument
> docs.

Will fix that.

>> + * @lockcnt: pointer to lockref structure
>> + * Return: 1 if count updated successfully or 0 if count<= 1 and lock taken
>> + */
>> +static __always_inline int
>> +lockref_put_or_locked(struct lockref *lockcnt)
>> +{
>> +	spin_lock(&lockcnt->lock);
>> +	if (likely(lockcnt->refcnt>  1)) {
>> +		lockcnt->refcnt--;
>> +		spin_unlock(&lockcnt->lock);
>> +		return 1;
>> +	}
>> +	return 0;	/* Count is 1&  lock taken */
> Please no tail comments. They are horrible to parse and it's obvious
> from the code.

Will remove the tail comments.

>> +}
>> +
>> +#endif /* CONFIG_SPINLOCK_REFCOUNT */
>> +#endif /* __LINUX_SPINLOCK_REFCOUNT_H */
>> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
>> index 44511d1..d1f8670 100644
>> --- a/kernel/Kconfig.locks
>> +++ b/kernel/Kconfig.locks
>> @@ -223,3 +223,8 @@ endif
>>   config MUTEX_SPIN_ON_OWNER
>>   	def_bool y
>>   	depends on SMP&&  !DEBUG_MUTEXES
>> +
>> +config SPINLOCK_REFCOUNT
>> +	def_bool y
>> +	depends on ARCH_SPINLOCK_REFCOUNT&&  SMP
> This looks wrong. We want three options:
>
> 1) Always take the lock
> 2) Use the generic implementation
> 3) Use an architecture specific implementation
>
> So we want
>
>     config GENERIC_SPINLOCK_REFCOUNT
>     	  bool
>
>     config ARCH_SPINLOCK_REFCOUNT
>     	  bool
>
>     config SPINLOCK_REFCOUNT
>     	  def_bool y
> 	  depends on GENERIC_SPINLOCK_REFCOUNT || ARCH_SPINLOCK_REFCOUNT
> 	  depends on .....
>     	  	
> So an architectire can select GENERIC_SPINLOCK_REFCOUNT to get the
> generic implementation or ARCH_SPINLOCK_REFCOUNT if it provides its
> own special version.
>
> And lib/spinlock_refcount.o depends on GENERIC_SPINLOCK_REFCOUNT

I think it is OK to add the GENERIC option, but I would like to make 
available a slightly different set of options:
1) Always take the lock
2) Use the generic implementation with the default parameters
3) Use the generic implementation with a customized set of parameters
4) Use an architecture specific implementation.

2) set only GENERIC_SPINLOCK_REFCOUNT
3) set both GENERIC_SPINLOCK_REFCOUNT and ARCH_SPINLOCK_REFCOUNT
4) set only ARCH_SPINLOCK_REFCOUNT

The customized parameters will be set in the "asm/spinlock_refcount.h" 
file. Currently ,there is 2 parameters that can be customized for each 
architecture:
1) How much time will the function wait until the lock is free
2) How many attempts to do a lockless cmpxchg to update reference count

>> +/*
>> + * The maximum number of waiting spins when the lock was acquiring before
>> + * trying to attempt a lockless update. The purpose of the timeout is to
>> + * limit the amount of unfairness to the thread that is doing the reference
>> + * count update. Otherwise, it is theoretically possible for that thread to
>> + * be starved for a really long time causing all kind of problems. If it
>> + * times out and the lock is still not free, the code will fall back to the
>> + * traditional way of queuing up to acquire the lock before updating the count.
>> + *
>> + * The actual time spent in the wait loop very much depends on the CPU being
>> + * used. On a 2.4GHz Westmere CPU, the execution time of a PAUSE instruction
>> + * (cpu_relax) in a 4k loop is about 16us. The lock checking and looping
>> + * overhead is about 8us. With 4 cpu_relax's in the loop, it will wait
>> + * about 72us before the count reaches 0. With cacheline contention, the
>> + * wait time can go up to 3x as much (about 210us). Having multiple
>> + * cpu_relax's in the wait loop does seem to reduce cacheline contention
>> + * somewhat and give slightly better performance.
>> + *
>> + * The preset timeout value is rather arbitrary and really depends on the CPU
>> + * being used. If customization is needed, we could add a config variable for
>> + * that. The exact value is not that important. A longer wait time will
>> + * increase the chance of doing a lockless update, but it results in more
>> + * unfairness to the waiting thread and vice versa.
> As I told you before it's a horrible idea.
>
> This is completely depending on the CPU, the cache implementation and
> whatever. These heuristic can never be made correct. Their are prone
> to fail and in the worst case you end up with a regression on some
> systems.
>
> Let's start with a simple version because it IS simple and easy
> to analyze and debug and then incrementally build improvements on it
> instead of creating an heuristics monster in the first place, i.e.:
>
>     if (!spin_is_locked(&lr->lock)&&  try_cmpxchg_once(lr))
>        return 0;
>     return 1;
>
> Take numbers for this on a zoo of different machines: Intel and AMD,
> old and new.
>
> Then you can add an incremental patch on that, which add loops and
> hoops. Along with numbers on the same zoo of machines.

I originally tried to do a cmpxchg without waiting and there was 
practically no performance gain. I believe that as soon as contention 
happens, it will force all the upcoming reference count update threads 
to take the lock eliminating any potential performance gain that we can 
have. To make it simple, I can change the default to wait indefinitely 
until the lock is free instead of looping a certain number of times, but 
I still like the option of letting each architecture to decide how many 
times they want to try. I agree that the actual waiting time even for 
one architecture is depending on the actual CPU chip that is being used. 
I have done some experiment on that. As long as the count is large 
enough, increasing the loop count doesn't have any significant impact on 
performance any more. The main reason for having a finite time is to 
avoid having the waiting thread to wait virtually forever if the lock 
happens to be busy for a long time.
>> + */
>> +#ifndef CONFIG_LOCKREF_WAIT_SHIFT
> No, we don't want this to be a config option. Either you can determine
> it at runtime with a proper test or you just avoid the whole loop
> business.

This will be a customized parameter settable by each architecture.

>> +#define CONFIG_LOCKREF_WAIT_SHIFT	12
>> +#endif
>> +#define	LOCKREF_SPIN_WAIT_MAX	(1<<CONFIG_LOCKREF_WAIT_SHIFT)
>> +
>> +/**
>> + *
>> + * __lockref_add_unless - atomically add the given value to the count unless
>> + *			  the lock was acquired or the count equals to the
>> + *			  given threshold value.
> Short online descriptions please.

Will change that.

>> + * @plockcnt : pointer to the combined lock and count 8-byte data
>> + * @plock    : pointer to the spinlock
>> + * @pcount   : pointer to the reference count
>> + * @value    : value to be added
>> + * @threshold: threshold value for acquiring the lock
>> + * Return    : 1 if operation succeeds, 0 otherwise
>> + *
>> + * If the lock was not acquired, __lockref_add_unless() atomically adds the
>> + * given value to the reference count unless the given threshold is reached.
>> + * If the lock was acquired or the threshold was reached, 0 is returned and
>> + * the caller will have to acquire the lock and update the count accordingly
>> + * (can be done in a non-atomic way).
>> + *
>> + * N.B. The lockdep code won't be run as this optimization should be disabled
>> + *	when LOCK_STAT is enabled.
> -ENOPARSE
>
>> + */
>> +static __always_inline int
>> +__lockref_add_unless(u64 *plockcnt, spinlock_t *plock, unsigned int *pcount,
>> +		     int value, int threshold)
>> +{
>> +	struct lockref old, new;
>> +	int   get_lock, loopcnt;
>> +#ifdef _SHOW_WAIT_LOOP_TIME
>> +	struct timespec tv1, tv2;
>> +#endif
>> +
>> +	/*
>> +	 * Code doesn't work if raw spinlock is larger than 4 bytes
>> +	 * or is empty.
>> +	 */
>> +	BUILD_BUG_ON(sizeof(arch_spinlock_t) == 0);
>> +	if (sizeof(arch_spinlock_t)>  4)
>> +		return 0;	/* Need to acquire the lock explicitly */
> You can fail the build here as well. Why go through loops and hoops at
> runtime if the compiler can figure it out already?

Will change that to BUILD_BUG_ON.

>> +	/*
>> +	 * Wait a certain amount of time until the lock is free or the loop
>> +	 * counter reaches 0. Doing multiple cpu_relax() helps to reduce
>> +	 * contention in the spinlock cacheline and achieve better performance.
>> +	 */
>> +#ifdef _SHOW_WAIT_LOOP_TIME
>> +	getnstimeofday(&tv1);
>> +#endif
>> +	loopcnt = LOCKREF_SPIN_WAIT_MAX;
>> +	while (loopcnt&&  spin_is_locked(plock)) {
>> +		loopcnt--;
>> +		cpu_relax();
>> +		cpu_relax();
>> +		cpu_relax();
>> +		cpu_relax();
>> +	}
>> +#ifdef _SHOW_WAIT_LOOP_TIME
>> +	if (loopcnt == 0) {
>> +		unsigned long ns;
>> +
>> +		getnstimeofday(&tv2);
>> +		ns = (tv2.tv_sec - tv1.tv_sec) * NSEC_PER_SEC +
>> +		     (tv2.tv_nsec - tv1.tv_nsec);
>> +		pr_info("lockref wait loop time = %lu ns\n", ns);
> Using getnstimeofday() for timestamping and spamming the logs with
> printouts? You can't be serious about that?
>
> Thats what tracepoints are for. Tracing is the only way to get proper
> numbers which take preemption, interrupts etc. into account without
> hurting runtime performace.

The _SHOW_WAIT_LOOP_TIME is for debugging and instrumentation purpose 
only during development cycle. It is not supposed to be turned on at 
production system. I will document that in the code.

>> +	}
>> +#endif
>> +
>> +#ifdef CONFIG_LOCK_STAT
>> +	if (loopcnt != LOCKREF_SPIN_WAIT_MAX)
>> +		lock_contended(plock->dep_map, _RET_IP_);
>> +#endif
> So you already failed and nevertheless you try again? Whats' the
> point?

I will take this code out as it is not supposed to be used anyway.

>> +	old.__lock_count = ACCESS_ONCE(*plockcnt);
>> +	get_lock = ((threshold>= 0)&&  (old.refcnt<= threshold));
>> +	if (likely(!get_lock&&  !spin_is_locked(&old.lock))) {
>> +		new.__lock_count = old.__lock_count;
>> +		new.refcnt += value;
>> +		if (cmpxchg64(plockcnt, old.__lock_count, new.__lock_count)
>> +		    == old.__lock_count)
>> +			return 1;
>> +		cpu_relax();
>> +		cpu_relax();
>> +		/*
>> +		 * Try one more time
>> +		 */
> There are proper loop constructs available in C. Copying code is
> definitely none of them.

Will change that into a loop.

>> +		old.__lock_count = ACCESS_ONCE(*plockcnt);
>> +		get_lock = ((threshold>= 0)&&  (old.refcnt<= threshold));
>> +		if (likely(!get_lock&&  !spin_is_locked(&old.lock))) {
>> +			new.__lock_count = old.__lock_count;
>> +			new.refcnt += value;
>> +			if (cmpxchg64(plockcnt, old.__lock_count,
>> +				      new.__lock_count) == old.__lock_count)
>> +				return 1;
>> +			cpu_relax();
>> +		}
>> +	}
>> +	return 0;	/* The caller will need to acquire the lock */
>> +}
>> +
>> +/*
>> + * Generic macros to increment and decrement reference count
>> + * @sname : pointer to lockref structure
>> + * @lock  : name of spinlock in structure
>> + * @count : name of reference count in structure
>> + *
>> + * LOCKREF_GET()  - increments count unless it is locked
>> + * LOCKREF_GET0() - increments count unless it is locked or count is 0
>> + * LOCKREF_PUT()  - decrements count unless it is locked or count is 1
>> + */
>> +#define LOCKREF_GET(sname, lock, count)					\
>> +	__lockref_add_unless(&(sname)->__lock_count,&(sname)->lock,	\
>> +			&(sname)->count, 1, -1)
>> +void
>> +lockref_get(struct lockref *lockcnt)
> One line please

Will do that.

>> +{
>> +	if (LOCKREF_GET(lockcnt, lock, refcnt))
>> +		return;
> What's wrong with writing:
>
>         if (lockref_mod(&lc->__lock_count,&lc->lock,&lc->refcnt, 1, -1))
>         	  	return;

Will remove the macros.

Thank for your time reviewing this patch.

Regards,
Longman
