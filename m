Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3EVQSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:18:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46985 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3EVQSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:18:50 -0400
Date: Wed, 22 May 2013 18:18:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130522161831.GQ18810@twins.programming.kicks-ass.net>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CA976.9000109@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:18:14PM +0200, Maarten Lankhorst wrote:

Lacking the actual msg atm, I'm going to paste in here...
  	
> Subject: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
> From: Maarten Lankhorst <maarten.lankhorst@xxxxxxxxxxxxx>
> 
> Changes since RFC patch v1:
>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>  - removed mutex_locked_set_reservation_id (or w/e it was called)
> Changes since RFC patch v2:
>  - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>    mutex_(,reserve_)lock/unlock.
> Changes since v1:
>  - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
>    triggered from normal locks, because __builtin_constant_p might evaluate to false
>    for the constant 0 in that case. Tests for this have been added in the next patch.
>  - Updated documentation slightly.
> Changes since v2:
>  - Renamed everything to ww_mutex. (mlankhorst)
>  - Added ww_acquire_ctx and ww_class. (mlankhorst)
>  - Added a lot of checks for wrong api usage. (mlankhorst)
>  - Documentation updates. (danvet)
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@xxxxxxxxxxxxx>
> Signed-off-by: Daniel Vetter <daniel.vetter@xxxxxxxx>
> ---
>  Documentation/ww-mutex-design.txt |  322 +++++++++++++++++++++++++++
>  include/linux/mutex-debug.h       |    1 
>  include/linux/mutex.h             |  257 +++++++++++++++++++++
>  kernel/mutex.c                    |  445 ++++++++++++++++++++++++++++++++++++-
>  lib/debug_locks.c                 |    2 
>  5 files changed, 1010 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/ww-mutex-design.txt
> 
> diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
> new file mode 100644
> index 0000000..154bae3
> --- /dev/null
> +++ b/Documentation/ww-mutex-design.txt
> @@ -0,0 +1,322 @@
> +Wait/Wound Deadlock-Proof Mutex Design
> +======================================
> +
> +Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
> +
> +Motivation for WW-Mutexes
> +-------------------------
> +
> +GPU's do operations that commonly involve many buffers.  Those buffers
> +can be shared across contexts/processes, exist in different memory
> +domains (for example VRAM vs system memory), and so on.  And with
> +PRIME / dmabuf, they can even be shared across devices.  So there are
> +a handful of situations where the driver needs to wait for buffers to
> +become ready.  If you think about this in terms of waiting on a buffer
> +mutex for it to become available, this presents a problem because
> +there is no way to guarantee that buffers appear in a execbuf/batch in
> +the same order in all contexts.  That is directly under control of
> +userspace, and a result of the sequence of GL calls that an application
> +makes.	Which results in the potential for deadlock.  The problem gets
> +more complex when you consider that the kernel may need to migrate the
> +buffer(s) into VRAM before the GPU operates on the buffer(s), which
> +may in turn require evicting some other buffers (and you don't want to
> +evict other buffers which are already queued up to the GPU), but for a
> +simplified understanding of the problem you can ignore this.
> +
> +The algorithm that TTM came up with for dealing with this problem is quite
> +simple.  For each group of buffers (execbuf) that need to be locked, the caller
> +would be assigned a unique reservation id/ticket, from a global counter.  In
> +case of deadlock while locking all the buffers associated with a execbuf, the
> +one with the lowest reservation ticket (i.e. the oldest task) wins, and the one
> +with the higher reservation id (i.e. the younger task) unlocks all of the
> +buffers that it has already locked, and then tries again.
> +
> +In the RDBMS literature this deadlock handling approach is called wait/wound:
> +The older tasks waits until it can acquire the contended lock. The younger tasks
> +needs to back off and drop all the locks it is currently holding, i.e. the
> +younger task is wounded.
> +
> +Concepts
> +--------
> +
> +Compared to normal mutexes two additional concepts/objects show up in the lock
> +interface for w/w mutexes:
> +
> +Acquire context: To ensure eventual forward progress it is important the a task
> +trying to acquire locks doesn't grab a new reservation id, but keeps the one it
> +acquired when starting the lock acquisition. This ticket is stored in the
> +acquire context. Furthermore the acquire context keeps track of debugging state
> +to catch w/w mutex interface abuse.
> +
> +W/w class: In contrast to normal mutexes the lock class needs to be explicit for
> +w/w mutexes, since it is required to initialize the acquire context.
> +
> +Furthermore there are three different classe of w/w lock acquire functions:
> +- Normal lock acquisition with a context, using ww_mutex_lock
> +- Slowpath lock acquisition on the contending lock, used by the wounded task
> +  after having dropped all already acquired locks. These functions have the
> +  _slow postfix.

See below, I don't see the need for this interface.

> +- Functions to only acquire a single w/w mutex, which results in the exact same
> +  semantics as a normal mutex. These functions have the _single postfix.

This is missing rationale.

> +
> +Of course, all the usual variants for handling wake-ups due to signals are also
> +provided.
> +
> +Usage
> +-----
> +
> +Three different ways to acquire locks within the same w/w class. Common
> +definitions for methods 1&2.
> +
> +static DEFINE_WW_CLASS(ww_class);
> +
> +struct obj {
> +	sct ww_mutex lock;
> +	/* obj data */
> +};
> +
> +struct obj_entry {
> +	struct list_head *list;
> +	struct obj *obj;
> +};
> +
> +Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
> +This is useful if a list of required objects is already tracked somewhere.
> +Furthermore the lock helper can use propagate the -EALREADY return code back to
> +the caller as a signal that an object is twice on the list. This is useful if
> +the list is constructed from userspace input and the ABI requires userspace to
> +no have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
> +
> +int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
> +{
> +	struct obj *res_obj = NULL;
> +	struct obj_entry *contended_entry = NULL;
> +	struct obj_entry *entry;
> +
> +	ww_acquire_init(ctx, &ww_class);
> +
> +retry:
> +	list_for_each_entry (list, entry) {
> +		if (entry == res_obj) {
> +			res_obj = NULL;
> +			continue;
> +		}
> +		ret = ww_mutex_lock(&entry->obj->lock, ctx);
> +		if (ret < 0) {
> +			contended_obj = entry;
> +			goto err;
> +		}
> +	}
> +
> +	ww_acquire_done(ctx);
> +	return 0;
> +
> +err:
> +	list_for_each_entry_continue_reverse (list, contended_entry, entry)
> +		ww_mutex_unlock(&entry->obj->lock);
> +
> +	if (res_obj)
> +		ww_mutex_unlock(&res_obj->lock);
> +
> +	if (ret == -EDEADLK) {
> +		/* we lost out in a seqno race, lock and retry.. */
> +		ww_mutex_lock_slow(&contended_entry->obj->lock, ctx);

I missing the need for ww_mutex_lock_slow(). AFAICT we should be able to tell
its the first lock in the ctx and thus we cannot possibly deadlock.

> +		res_obj = contended_entry->obj;
> +		goto retry;
> +	}
> +	ww_acquire_fini(ctx);
> +
> +	return ret;
> +}
> +

... you certainly went all out on documentation.

> diff --git a/include/linux/mutex-debug.h b/include/linux/mutex-debug.h
> index 731d77d..4ac8b19 100644
> --- a/include/linux/mutex-debug.h
> +++ b/include/linux/mutex-debug.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/linkage.h>
>  #include <linux/lockdep.h>
> +#include <linux/debug_locks.h>
>  
>  /*
>   * Mutexes - debugging helpers:
> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index 9121595..004f863 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -74,6 +74,35 @@ struct mutex_waiter {
>  #endif
>  };
>  
> +struct ww_class {
> +	atomic_long_t stamp;
> +	struct lock_class_key acquire_key;
> +	struct lock_class_key mutex_key;
> +	const char *acquire_name;
> +	const char *mutex_name;
> +};
> +
> +struct ww_acquire_ctx {
> +	struct task_struct *task;
> +	unsigned long stamp;
> +#ifdef CONFIG_DEBUG_MUTEXES
> +	unsigned acquired, done_acquire;
> +	struct ww_class *ww_class;
> +	struct ww_mutex *contending_lock;
> +#endif
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	struct lockdep_map dep_map;
> +#endif
> +};
> +
> +struct ww_mutex {
> +	struct mutex base;
> +	struct ww_acquire_ctx *ctx;
> +#ifdef CONFIG_DEBUG_MUTEXES
> +	struct ww_class *ww_class;
> +#endif
> +};
> +


> @@ -167,6 +236,192 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
>   */
>  extern int mutex_trylock(struct mutex *lock);
>  extern void mutex_unlock(struct mutex *lock);
> +
> +/**
> + * ww_acquire_init - initialize a w/w acquire context
> + * @ctx: w/w acquire context to initialize
> + * @ww_class: w/w class of the context
> + *
> + * Initializes an context to acquire multiple mutexes of the given w/w class.
> + *
> + * Context-based w/w mutex acquiring can be done in any order whatsoever within
> + * a given lock class. Deadlocks will be detected and handled with the
> + * wait/wound logic.
> + *
> + * Mixing of context-based w/w mutex acquiring and single w/w mutex locking can
> + * result in undetected deadlocks and is so forbidden. Mixing different contexts
> + * for the same w/w class when acquiring mutexes can also result in undetected
> + * deadlocks, and is hence also forbidden.
> + *
> + * Nesting of acquire contexts for _different_ w/w classes is possible, subject
> + * to the usual locking rules between different lock classes.
> + *
> + * An acquire context must be release by the same task before the memory is
> + * freed with ww_acquire_fini. It is recommended to allocate the context itself
> + * on the stack.
> + */
> +static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
> +				   struct ww_class *ww_class)
> +{
> +	ctx->task = current;
> +	do {
> +		ctx->stamp = atomic_long_inc_return(&ww_class->stamp);
> +	} while (unlikely(!ctx->stamp));

I suppose we'll figure something out when this becomes a bottleneck. Ideally
we'd do something like:

 ctx->stamp = local_clock();

but for now we cannot guarantee that's not jiffies, and I suppose that's a tad
too coarse to work for this.

Also, why is 0 special?

> +#ifdef CONFIG_DEBUG_MUTEXES
> +	ctx->ww_class = ww_class;
> +	ctx->acquired = ctx->done_acquire = 0;
> +	ctx->contending_lock = NULL;
> +#endif
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	debug_check_no_locks_freed((void *)ctx, sizeof(*ctx));
> +	lockdep_init_map(&ctx->dep_map, ww_class->acquire_name,
> +			 &ww_class->acquire_key, 0);
> +	mutex_acquire(&ctx->dep_map, 0, 0, _RET_IP_);
> +#endif
> +}

> +/**
> + * ww_mutex_trylock_single - tries to acquire the w/w mutex without acquire context
> + * @lock: mutex to lock
> + *
> + * Trylocks a mutex without acquire context, so no deadlock detection is
> + * possible. Returns 0 if the mutex has been acquired.
> + *
> + * Unlocking the mutex must happen with a call to ww_mutex_unlock_single.
> + */
> +static inline int __must_check ww_mutex_trylock_single(struct ww_mutex *lock)
> +{
> +	return mutex_trylock(&lock->base);
> +}

trylocks can never deadlock they don't block per definition, I don't see the
point of the _single() thing here.

> +/**
> + * ww_mutex_lock_single - acquire the w/w mutex without acquire context
> + * @lock: mutex to lock
> + *
> + * Locks a mutex without acquire context, so no deadlock detection is
> + * possible.
> + *
> + * Unlocking the mutex must happen with a call to ww_mutex_unlock_single.
> + */
> +static inline void ww_mutex_lock_single(struct ww_mutex *lock)
> +{
> +	mutex_lock(&lock->base);
> +}

as per the above, I'm missing the rationale for having this.

> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 84a5f07..66807c7 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -127,16 +127,156 @@ void __sched mutex_unlock(struct mutex *lock)
>  
>  EXPORT_SYMBOL(mutex_unlock);
>  
> +/**
> + * ww_mutex_unlock - release the w/w mutex
> + * @lock: the mutex to be released
> + *
> + * Unlock a mutex that has been locked by this task previously
> + * with ww_mutex_lock* using an acquire context. It is forbidden to release the
> + * locks after releasing the acquire context.
> + *
> + * This function must not be used in interrupt context. Unlocking
> + * of a unlocked mutex is not allowed.
> + *
> + * Note that locks acquired with one of the ww_mutex_lock*single variant must be
> + * unlocked with ww_mutex_unlock_single.
> + */
> +void __sched ww_mutex_unlock(struct ww_mutex *lock)
> +{
> +	/*
> +	 * The unlocking fastpath is the 0->1 transition from 'locked'
> +	 * into 'unlocked' state:
> +	 */
> +#ifdef CONFIG_DEBUG_MUTEXES
> +	DEBUG_LOCKS_WARN_ON(!lock->ctx);
> +	if (lock->ctx) {
> +		DEBUG_LOCKS_WARN_ON(!lock->ctx->acquired);
> +		if (lock->ctx->acquired > 0)
> +			lock->ctx->acquired--;
> +	}
> +#endif
> +	lock->ctx = NULL;

barriers should always have a comment explaining the exact ordering and the
pairing barrier's location.

> +	smp_mb__before_atomic_inc();
> +
> +#ifndef CONFIG_DEBUG_MUTEXES
> +	/*
> +	 * When debugging is enabled we must not clear the owner before time,
> +	 * the slow path will always be taken, and that clears the owner field
> +	 * after verifying that it was indeed current.
> +	 */
> +	mutex_clear_owner(&lock->base);
> +#endif
> +	__mutex_fastpath_unlock(&lock->base.count, __mutex_unlock_slowpath);
> +}
> +EXPORT_SYMBOL(ww_mutex_unlock);
> +
> +static inline int __sched
> +__mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
> +{
> +	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
> +	struct ww_acquire_ctx *hold_ctx = ACCESS_ONCE(ww->ctx);
> +
> +	if (!hold_ctx)
> +		return 0;
> +
> +	if (unlikely(ctx->stamp == hold_ctx->stamp))
> +		return -EALREADY;

Why compare stamps? I expected: ctx == hold_ctx here.

> +
> +	if (unlikely(ctx->stamp - hold_ctx->stamp <= LONG_MAX)) {

Why not simply write: ctx->stamp > hold_ctx->stamp ?

If we need to deal with equal stamps from different contexts we could tie-break
based on ctx address or so, but seeing its a global counter from the class,
that shouldn't happen for now.

> +#ifdef CONFIG_DEBUG_MUTEXES
> +		DEBUG_LOCKS_WARN_ON(ctx->contending_lock);
> +		ctx->contending_lock = ww;
> +#endif
> +		return -EDEADLK;
> +	}
> +
> +	return 0;
> +}
> +
> +static __always_inline void ww_mutex_lock_acquired(struct ww_mutex *ww,
> +						   struct ww_acquire_ctx *ww_ctx,
> +						   bool ww_slow)
> +{
> +#ifdef CONFIG_DEBUG_MUTEXES
> +	/*
> +	 * If this WARN_ON triggers, you used mutex_lock to acquire,
> +	 * but released with ww_mutex_unlock in this call.
> +	 */
> +	DEBUG_LOCKS_WARN_ON(ww->ctx);
> +
> +	/*
> +	 * Not quite done after ww_acquire_done() ?
> +	 */
> +	DEBUG_LOCKS_WARN_ON(ww_ctx->done_acquire);
> +
> +	if (ww_slow) {

s/ww_slow/!ww_ctx->acquired/

> +		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock != ww);
> +		ww_ctx->contending_lock = NULL;
> +	} else
> +		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock);
> +
> +
> +	/*
> +	 * Naughty, using a different class can lead to undefined behavior!
> +	 */
> +	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
> +
> +	if (ww_slow)
> +		DEBUG_LOCKS_WARN_ON(ww_ctx->acquired > 0);
> +
> +	ww_ctx->acquired++;
> +#endif
> +}
> +
> +/*
> + * after acquiring lock with fastpath or when we lost out in contested
> + * slowpath, set ctx and wake up any waiters so they can recheck.
> + *
> + * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
> + * as the fastpath and opportunistic spinning are disabled in that case.
> + */
> +static __always_inline void
> +ww_mutex_set_context_fastpath(struct ww_mutex *lock,
> +			       struct ww_acquire_ctx *ctx)
> +{
> +	unsigned long flags;
> +	struct mutex_waiter *cur;
> +
> +	ww_mutex_lock_acquired(lock, ctx, false);
> +
> +	lock->ctx = ctx;

 missing comment

> +	smp_mb__after_atomic_dec();
> +
> +	/*
> +	 * Check if lock is contended, if not there is nobody to wake up
> +	 */
> +	if (likely(atomic_read(&lock->base.count) == 0))
> +		return;
> +
> +	/*
> +	 * Uh oh, we raced in fastpath, wake up everyone in this case,
> +	 * so they can see the new ctx
> +	 */
> +	spin_lock_mutex(&lock->base.wait_lock, flags);
> +	list_for_each_entry(cur, &lock->base.wait_list, list) {
> +		debug_mutex_wake_waiter(&lock->base, cur);
> +		wake_up_process(cur->task);
> +	}
> +	spin_unlock_mutex(&lock->base.wait_lock, flags);
> +}
> +
>  /*
>   * Lock a mutex (possibly interruptible), slowpath:
>   */
> -static inline int __sched
> +static __always_inline int __sched
>  __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> -		    struct lockdep_map *nest_lock, unsigned long ip)
> +		    struct lockdep_map *nest_lock, unsigned long ip,
> +		    struct ww_acquire_ctx *ww_ctx, bool ww_slow)
>  {
>  	struct task_struct *task = current;
>  	struct mutex_waiter waiter;
>  	unsigned long flags;
> +	int ret;
>  
>  	preempt_disable();
>  	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
> @@ -163,6 +303,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	for (;;) {
>  		struct task_struct *owner;
>  
> +		if (!__builtin_constant_p(ww_ctx == NULL) && !ww_slow) {

Since we _know_ ww_ctx isn't NULL, we can trivially do: s/ww_slow/!ww_ctx->acquired/

> +			struct ww_mutex *ww;
> +
> +			ww = container_of(lock, struct ww_mutex, base);
> +			if (ACCESS_ONCE(ww->ctx))

What's the point of this ACCESS_ONCE()?

> +				break;
> +		}
> +
>  		/*
>  		 * If there's an owner, wait for it to either
>  		 * release the lock or go to sleep.
> @@ -173,6 +321,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  
>  		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
>  			lock_acquired(&lock->dep_map, ip);

Should this not also have a __builtin_constant_p(ww_ctx == NULL) ?

> +			if (ww_slow) {
> +				struct ww_mutex *ww;
> +				ww = container_of(lock, struct ww_mutex, base);
> +
> +				ww_mutex_set_context_fastpath(ww, ww_ctx);
> +			}
> +
>  			mutex_set_owner(lock);
>  			preempt_enable();
>  			return 0;
> @@ -228,15 +383,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		 * TASK_UNINTERRUPTIBLE case.)
>  		 */
>  		if (unlikely(signal_pending_state(state, task))) {
> -			mutex_remove_waiter(lock, &waiter,
> -					    task_thread_info(task));
> -			mutex_release(&lock->dep_map, 1, ip);
> -			spin_unlock_mutex(&lock->wait_lock, flags);
> +			ret = -EINTR;
> +			goto err;
> +		}
>  
> -			debug_mutex_free_waiter(&waiter);
> -			preempt_enable();
> -			return -EINTR;
> +		if (!__builtin_constant_p(ww_ctx == NULL) && !ww_slow) {
> +			ret = __mutex_lock_check_stamp(lock, ww_ctx);
> +			if (ret)
> +				goto err;
>  		}
> +
>  		__set_task_state(task, state);
>  
>  		/* didn't get the lock, go to sleep: */
> @@ -251,6 +407,30 @@ done:
>  	mutex_remove_waiter(lock, &waiter, current_thread_info());
>  	mutex_set_owner(lock);
>  
> +	if (!__builtin_constant_p(ww_ctx == NULL)) {
> +		struct ww_mutex *ww = container_of(lock,
> +						      struct ww_mutex,
> +						      base);
> +		struct mutex_waiter *cur;
> +
> +		/*
> +		 * This branch gets optimized out for the common case,
> +		 * and is only important for ww_mutex_lock.
> +		 */
> +
> +		ww_mutex_lock_acquired(ww, ww_ctx, ww_slow);
> +		ww->ctx = ww_ctx;
> +
> +		/*
> +		 * Give any possible sleeping processes the chance to wake up,
> +		 * so they can recheck if they have to back off.
> +		 */
> +		list_for_each_entry(cur, &lock->wait_list, list) {
> +			debug_mutex_wake_waiter(lock, cur);
> +			wake_up_process(cur->task);
> +		}
> +	}
> +
>  	/* set it to 0 if there are no waiters left: */
>  	if (likely(list_empty(&lock->wait_list)))
>  		atomic_set(&lock->count, 0);
> @@ -261,6 +441,14 @@ done:
>  	preempt_enable();
>  
>  	return 0;
> +
> +err:
> +	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
> +	spin_unlock_mutex(&lock->wait_lock, flags);
> +	debug_mutex_free_waiter(&waiter);
> +	mutex_release(&lock->dep_map, 1, ip);
> +	preempt_enable();
> +	return ret;
>  }
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> @@ -268,7 +456,8 @@ void __sched
>  mutex_lock_nested(struct mutex *lock, unsigned int subclass)
>  {
>  	might_sleep();
> -	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
> +	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
> +			    subclass, NULL, _RET_IP_, 0, 0);
>  }

The pendant in me has to tell you 4x that NULL != 0 :-)

> +EXPORT_SYMBOL_GPL(ww_mutex_lock);
> +EXPORT_SYMBOL_GPL(ww_mutex_lock_interruptible);
> +EXPORT_SYMBOL_GPL(ww_mutex_lock_slow);
> +EXPORT_SYMBOL_GPL(ww_mutex_lock_slow_interruptible);

Now having to do the _slow stuff saves lines and interface complexity!

> @@ -401,20 +738,39 @@ __mutex_lock_slowpath(atomic_t *lock_count)
>  {
>  	struct mutex *lock = container_of(lock_count, struct mutex, count);
>  
> -	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
> +	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
> +			    NULL, _RET_IP_, 0, 0);
>  }
>  
>  static noinline int __sched
>  __mutex_lock_killable_slowpath(struct mutex *lock)
>  {
> -	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
> +	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
> +				   NULL, _RET_IP_, 0, 0);
>  }
>  
>  static noinline int __sched
>  __mutex_lock_interruptible_slowpath(struct mutex *lock)
>  {
> -	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
> +	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
> +				   NULL, _RET_IP_, 0, 0);
>  }

A few more cases where NULL != 0 :-)


