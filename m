Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaFMRTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:19:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:35380 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753816AbaFMRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:19:30 -0400
Date: Fri, 13 Jun 2014 13:19:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch V4 09/10] rtmutex: Cleanup deadlock detector debug logic
Message-ID: <20140613131928.061636e7@gandalf.local.home>
In-Reply-To: <20140611183853.644673097@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183853.644673097@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 18:44:08 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The conditions under which deadlock detection is conducted are unclear
> and undocumented.
> 
> Add constants instead of using 0/1 and provide a selection function
> which hides the additional debug dependency from the calling code.
> 
> Add comments where needed.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Link: http://lkml.kernel.org/r/20140522031949.947264874@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex-debug.c  |    5 +-
>  kernel/locking/rtmutex-debug.h  |    7 ++--
>  kernel/locking/rtmutex.c        |   70 +++++++++++++++++++++++++++-------------
>  kernel/locking/rtmutex.h        |    7 +++-
>  kernel/locking/rtmutex_common.h |   15 ++++++++
>  5 files changed, 76 insertions(+), 28 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex-debug.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex-debug.c
> +++ tip/kernel/locking/rtmutex-debug.c
> @@ -66,12 +66,13 @@ void rt_mutex_debug_task_free(struct tas
>   * the deadlock. We print when we return. act_waiter can be NULL in
>   * case of a remove waiter operation.
>   */
> -void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *act_waiter,
> +void debug_rt_mutex_deadlock(enum rtmutex_chainwalk chwalk,
> +			     struct rt_mutex_waiter *act_waiter,
>  			     struct rt_mutex *lock)
>  {
>  	struct task_struct *task;
>  
> -	if (!debug_locks || detect || !act_waiter)
> +	if (!debug_locks || chwalk == RT_MUTEX_FULL_CHAINWALK || !act_waiter)
>  		return;
>  
>  	task = rt_mutex_owner(act_waiter->lock);
> Index: tip/kernel/locking/rtmutex-debug.h
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex-debug.h
> +++ tip/kernel/locking/rtmutex-debug.h
> @@ -20,14 +20,15 @@ extern void debug_rt_mutex_unlock(struct
>  extern void debug_rt_mutex_proxy_lock(struct rt_mutex *lock,
>  				      struct task_struct *powner);
>  extern void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock);
> -extern void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *waiter,
> +extern void debug_rt_mutex_deadlock(enum rtmutex_chainwalk chwalk,
> +				    struct rt_mutex_waiter *waiter,
>  				    struct rt_mutex *lock);
>  extern void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter);
>  # define debug_rt_mutex_reset_waiter(w)			\
>  	do { (w)->deadlock_lock = NULL; } while (0)
>  
> -static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
> -						 int detect)
> +static inline bool debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
> +						  enum rtmutex_chainwalk walk)
>  {
>  	return (waiter != NULL);
>  }
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -308,6 +308,25 @@ static void rt_mutex_adjust_prio(struct
>  }
>  
>  /*
> + * Deadlock detection is conditional:
> + *
> + * If CONFIG_DEBUG_RT_MUTEXES=n, deadlock detection is only conducted
> + * if the detect argument is == RT_MUTEX_FULL_CHAINWALK.
> + *
> + * If CONFIG_DEBUG_RT_MUTEXES=y, deadlock detection is always
> + * conducted independent of the detect argument.
> + *
> + * If the waiter argument is NULL this indicates the deboost path and
> + * deadlock detection is disabled independent of the detect argument
> + * and the config settings.
> + */
> +static bool rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
> +					  enum rtmutex_chainwalk chwalk)
> +{

	/*
	 * This is just a wrapper function for the following call,
	 * because debug_rt_mutex_detect_deadlock() smells like a magic
	 * debug feature and I wanted to keep the cond function in the
	 * main source file along with the comments instead of having
	 * two of the same in the headers.
	 */

;-)

(found an error below)

> +	return debug_rt_mutex_detect_deadlock(waiter, chwalk);
> +}
> +
> +/*
>   * Max number of times we'll walk the boosting chain:
>   */
>  int max_lock_depth = 1024;
> @@ -381,7 +400,7 @@ static inline struct rt_mutex *task_bloc
>   *	  goto again;
>   */
>  static int rt_mutex_adjust_prio_chain(struct task_struct *task,
> -				      int deadlock_detect,
> +				      enum rtmutex_chainwalk chwalk,
>  				      struct rt_mutex *orig_lock,
>  				      struct rt_mutex *next_lock,
>  				      struct rt_mutex_waiter *orig_waiter,
> @@ -389,12 +408,12 @@ static int rt_mutex_adjust_prio_chain(st
>  {
>  	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
>  	struct rt_mutex_waiter *prerequeue_top_waiter;
> -	int detect_deadlock, ret = 0, depth = 0;
> +	int ret = 0, depth = 0;
>  	struct rt_mutex *lock;
> +	bool detect_deadlock;
>  	unsigned long flags;
>  
> -	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
> -							 deadlock_detect);
> +	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter, chwalk);
>  
>  	/*
>  	 * The (de)boosting is a step by step approach with a lot of
> @@ -520,7 +539,7 @@ static int rt_mutex_adjust_prio_chain(st
>  	 * walk, we detected a deadlock.
>  	 */
>  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> -		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
> +		debug_rt_mutex_deadlock(chwalk, orig_waiter, lock);
>  		raw_spin_unlock(&lock->wait_lock);
>  		ret = -EDEADLK;
>  		goto out_unlock_pi;
> @@ -784,7 +803,7 @@ takeit:
>  static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  				   struct rt_mutex_waiter *waiter,
>  				   struct task_struct *task,
> -				   int detect_deadlock)
> +				   enum rtmutex_chainwalk chwalk)
>  {
>  	struct task_struct *owner = rt_mutex_owner(lock);
>  	struct rt_mutex_waiter *top_waiter = waiter;
> @@ -830,7 +849,7 @@ static int task_blocks_on_rt_mutex(struc
>  		__rt_mutex_adjust_prio(owner);
>  		if (owner->pi_blocked_on)
>  			chain_walk = 1;
> -	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
> +	} else if (rt_mutex_cond_detect_deadlock(waiter, chwalk)) {
>  		chain_walk = 1;
>  	}
>  
> @@ -855,7 +874,7 @@ static int task_blocks_on_rt_mutex(struc
>  
>  	raw_spin_unlock(&lock->wait_lock);
>  
> -	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
> +	res = rt_mutex_adjust_prio_chain(owner, chwalk, lock,
>  					 next_lock, waiter, task);
>  
>  	raw_spin_lock(&lock->wait_lock);
> @@ -963,7 +982,8 @@ static void remove_waiter(struct rt_mute
>  
>  	raw_spin_unlock(&lock->wait_lock);
>  
> -	rt_mutex_adjust_prio_chain(owner, 0, lock, next_lock, NULL, current);
> +	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
> +				   next_lock, NULL, current);
>  
>  	raw_spin_lock(&lock->wait_lock);
>  }
> @@ -993,7 +1013,8 @@ void rt_mutex_adjust_pi(struct task_stru
>  	/* gets dropped in rt_mutex_adjust_prio_chain()! */
>  	get_task_struct(task);
>  
> -	rt_mutex_adjust_prio_chain(task, 0, NULL, next_lock, NULL, task);
> +	rt_mutex_adjust_prio_chain(task, RT_MUTEX_MIN_CHAINWALK, NULL, NULL,

You dropped next_lock here. Was that intentional? I doubt it.

-- Steve


> +				   NULL, task);
>  }
>  
>  /**
> @@ -1071,7 +1092,7 @@ static void rt_mutex_handle_deadlock(int
>  static int __sched
>  rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  		  struct hrtimer_sleeper *timeout,
> -		  int detect_deadlock)
> +		  enum rtmutex_chainwalk chwalk)
>  {
>  	struct rt_mutex_waiter waiter;
>  	int ret = 0;
> @@ -1097,7 +1118,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
>  			timeout->task = NULL;
>  	}
>  
> -	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
> +	ret = task_blocks_on_rt_mutex(lock, &waiter, current, chwalk);
>  
>  	if (likely(!ret))
>  		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
> @@ -1106,7 +1127,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
>  
>  	if (unlikely(ret)) {
>  		remove_waiter(lock, &waiter);
> -		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
> +		rt_mutex_handle_deadlock(ret, chwalk, &waiter);
>  	}
>  
>  	/*
> @@ -1234,27 +1255,29 @@ static inline int
>  rt_mutex_fastlock(struct rt_mutex *lock, int state,
>  		  int (*slowfn)(struct rt_mutex *lock, int state,
>  				struct hrtimer_sleeper *timeout,
> -				int detect_deadlock))
> +				enum rtmutex_chainwalk chwalk))
>  {
>  	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
>  		rt_mutex_deadlock_account_lock(lock, current);
>  		return 0;
>  	} else
> -		return slowfn(lock, state, NULL, 0);
> +		return slowfn(lock, state, NULL, RT_MUTEX_MIN_CHAINWALK);
>  }
>  
>  static inline int
>  rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
> -			struct hrtimer_sleeper *timeout, int detect_deadlock,
> +			struct hrtimer_sleeper *timeout,
> +			enum rtmutex_chainwalk chwalk,
>  			int (*slowfn)(struct rt_mutex *lock, int state,
>  				      struct hrtimer_sleeper *timeout,
> -				      int detect_deadlock))
> +				      enum rtmutex_chainwalk chwalk))
>  {
> -	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> +	if (chwalk == RT_MUTEX_MIN_CHAINWALK &&
> +	    likely(rt_mutex_cmpxchg(lock, NULL, current))) {
>  		rt_mutex_deadlock_account_lock(lock, current);
>  		return 0;
>  	} else
> -		return slowfn(lock, state, timeout, detect_deadlock);
> +		return slowfn(lock, state, timeout, chwalk);
>  }
>  
>  static inline int
> @@ -1316,7 +1339,8 @@ int __rt_mutex_timed_lock(struct rt_mute
>  {
>  	might_sleep();
>  
> -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 1,
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> +				       RT_MUTEX_FULL_CHAINWALK,
>  				       rt_mutex_slowlock);
>  }
>  
> @@ -1338,7 +1362,8 @@ rt_mutex_timed_lock(struct rt_mutex *loc
>  {
>  	might_sleep();
>  
> -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> +				       RT_MUTEX_MIN_CHAINWALK,
>  				       rt_mutex_slowlock);
>  }
>  EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
> @@ -1467,7 +1492,8 @@ int rt_mutex_start_proxy_lock(struct rt_
>  	}
>  
>  	/* We enforce deadlock detection for futexes */
> -	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
> +	ret = task_blocks_on_rt_mutex(lock, waiter, task,
> +				      RT_MUTEX_FULL_CHAINWALK);
>  
>  	if (ret && !rt_mutex_owner(lock)) {
>  		/*
> Index: tip/kernel/locking/rtmutex.h
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.h
> +++ tip/kernel/locking/rtmutex.h
> @@ -22,10 +22,15 @@
>  #define debug_rt_mutex_init(m, n)			do { } while (0)
>  #define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
>  #define debug_rt_mutex_print_deadlock(w)		do { } while (0)
> -#define debug_rt_mutex_detect_deadlock(w,d)		(d)
>  #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
>  
>  static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
>  {
>  	WARN(1, "rtmutex deadlock detected\n");
>  }
> +
> +static inline bool debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *w,
> +						  enum rtmutex_chainwalk walk)
> +{
> +	return walk == RT_MUTEX_FULL_CHAINWALK;
> +}
> Index: tip/kernel/locking/rtmutex_common.h
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex_common.h
> +++ tip/kernel/locking/rtmutex_common.h
> @@ -102,6 +102,21 @@ static inline struct task_struct *rt_mut
>  }
>  
>  /*
> + * Constants for rt mutex functions which have a selectable deadlock
> + * detection.
> + *
> + * RT_MUTEX_MIN_CHAINWALK:	Stops the lock chain walk when there are
> + *				no further PI adjustments to be made.
> + *
> + * RT_MUTEX_FULL_CHAINWALK:	Invoke deadlock detection with a full
> + *				walk of the lock chain.
> + */
> +enum rtmutex_chainwalk {
> +	RT_MUTEX_MIN_CHAINWALK,
> +	RT_MUTEX_FULL_CHAINWALK,
> +};
> +
> +/*
>   * PI-futex support (proxy locking functions, etc.):
>   */
>  extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
> 

