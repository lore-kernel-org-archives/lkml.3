Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaFJPKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:10:47 -0400
Received: from skprod2.natinst.com ([130.164.80.23]:34050 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbaFJPKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:10:46 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Tue, 10 Jun 2014 10:09:47 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 6/7] rtmutex: Cleanup deadlock detector debug logic
Message-ID: <20140610150947.GB29976@linuxgetsreal>
References: <20140609201118.387571774@linutronix.de>
 <20140609202336.431063114@linutronix.de>
MIME-Version: 1.0
In-Reply-To: <20140609202336.431063114@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 10:09:48 AM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 10:09:48 AM,
	Serialize complete at 06/10/2014 10:09:48 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:28:10PM -0000, Thomas Gleixner wrote:
> The conditions under which deadlock detection is conducted are unclear
> and undocumented.
> 
> Add constants instead of using 0/1 and provide a selection function
> which hides the additional debug dependency from the calling code.
> 
> Add comments where needed.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex-debug.c  |    5 +-
>  kernel/locking/rtmutex-debug.h  |    7 ++--
>  kernel/locking/rtmutex.c        |   69 +++++++++++++++++++++++++++-------------
>  kernel/locking/rtmutex.h        |    7 +++-
>  kernel/locking/rtmutex_common.h |   15 ++++++++
>  5 files changed, 75 insertions(+), 28 deletions(-)
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
> +	if (!debug_locks || chwalk || !act_waiter)
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
> +static inline bool debug_rt_mutex_detect_deadlock(struct rt_mutex_waiterr *waiter,
> +						  enum rtmutex_chainwalk walk)
>  {
>  	return (waiter != NULL);
>  }
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -256,6 +256,25 @@ static void rt_mutex_adjust_prio(struct
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
> +	return debug_rt_mutex_detect_deadlock(waiter, chwalk);
> +}
> +
> +/*
>   * Max number of times we'll walk the boosting chain:
>   */
This comment is misleading, max_lock_depth conveys the number of
steps we'll take in any one chain walking. I know it's not in your
change but it bothered me when I was looking at this code and,
considering a goal of these patches is to clarify/document, I
figured I would comment.
>  int max_lock_depth = 1024;
> @@ -328,7 +347,7 @@ static inline struct rt_mutex *task_bloc
>   *	goto again;
>   */
>  static int rt_mutex_adjust_prio_chain(struct task_struct *task,
> -				      int deadlock_detect,
> +				      enum rtmutex_chainwalk chwalk,
>  				      struct rt_mutex *orig_lock,
>  				      struct rt_mutex *next_lock,
>  				      struct rt_mutex_waiter *orig_waiter,
> @@ -336,12 +355,12 @@ static int rt_mutex_adjust_prio_chain(st
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
> @@ -449,7 +468,7 @@ static int rt_mutex_adjust_prio_chain(st
>  	 * walk, we detected a deadlock.
>  	 */
>  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> -		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
> +		debug_rt_mutex_deadlock(chwalk, orig_waiter, lock);
>  		raw_spin_unlock(&lock->wait_lock);
>  		ret = -EDEADLK;
>  		goto out_unlock_pi;
> @@ -659,7 +678,7 @@ static int try_to_take_rt_mutex(struct r
>  static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  				   struct rt_mutex_waiter *waiter,
>  				   struct task_struct *task,
> -				   int detect_deadlock)
> +				   enum rtmutex_chainwalk chwalk)
>  {
>  	struct task_struct *owner = rt_mutex_owner(lock);
>  	struct rt_mutex_waiter *top_waiter = waiter;
> @@ -705,7 +724,7 @@ static int task_blocks_on_rt_mutex(struc
>  		__rt_mutex_adjust_prio(owner);
>  		if (owner->pi_blocked_on)
>  			chain_walk = 1;
> -	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
> +	} else if (rt_mutex_cond_detect_deadlock(waiter, chwalk)) {
>  		chain_walk = 1;
>  	}
>  
> @@ -730,7 +749,7 @@ static int task_blocks_on_rt_mutex(struc
>  
>  	raw_spin_unlock(&lock->wait_lock);
>  
> -	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
> +	res = rt_mutex_adjust_prio_chain(owner, chwalk, lock,
>  					 next_lock, waiter, task);
>  
>  	raw_spin_lock(&lock->wait_lock);
> @@ -813,7 +832,8 @@ static void remove_waiter(struct rt_mute
>  
>  	raw_spin_unlock(&lock->wait_lock);
>  
> -	rt_mutex_adjust_prio_chain(owner, 0, lock, next_lock, NULL, current);
> +	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
> +				   next_lock, NULL, current);
>  
>  	raw_spin_lock(&lock->wait_lock);
>  }
> @@ -843,7 +863,8 @@ void rt_mutex_adjust_pi(struct task_stru
>  	/* gets dropped in rt_mutex_adjust_prio_chain()! */
>  	get_task_struct(task);
>  
> -	rt_mutex_adjust_prio_chain(task, 0, NULL, next_lock, NULL, task);
> +	rt_mutex_adjust_prio_chain(task, RT_MUTEX_MIN_CHAINWALK, NULL, NULL,
> +				   NULL, task);
>  }
>  
>  /**
> @@ -921,7 +942,7 @@ static void rt_mutex_handle_deadlock(int
>  static int __sched
>  rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  		  struct hrtimer_sleeper *timeout,
> -		  int detect_deadlock)
> +		  enum rtmutex_chainwalk chwalk)
>  {
>  	struct rt_mutex_waiter waiter;
>  	int ret = 0;
> @@ -947,7 +968,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
>  			timeout->task = NULL;
>  	}
>  
> -	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
> +	ret = task_blocks_on_rt_mutex(lock, &waiter, current, chwalk);
>  
>  	if (likely(!ret))
>  		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
> @@ -956,7 +977,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
>  
>  	if (unlikely(ret)) {
>  		remove_waiter(lock, &waiter);
> -		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
> +		rt_mutex_handle_deadlock(ret, chwalk, &waiter);
>  	}
>  
>  	/*
> @@ -1037,27 +1058,28 @@ static inline int
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
> +	if (!chwalk && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
>  		rt_mutex_deadlock_account_lock(lock, current);
>  		return 0;
>  	} else
> -		return slowfn(lock, state, timeout, detect_deadlock);
> +		return slowfn(lock, state, timeout, chwalk);
>  }
>  
>  static inline int
> @@ -1119,7 +1141,8 @@ int __rt_mutex_timed_lock(struct rt_mute
>  {
>  	might_sleep();
>  
> -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> +				       RT_MUTEX_FULL_CHAINWALK,
>  				       rt_mutex_slowlock);
>  }
>  
> @@ -1141,7 +1164,8 @@ rt_mutex_timed_lock(struct rt_mutex *loc
>  {
>  	might_sleep();
>  
> -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> +				       RT_MUTEX_MIN_CHAINWALK,
>  				       rt_mutex_slowlock);
>  }
>  EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
> @@ -1270,7 +1294,8 @@ int rt_mutex_start_proxy_lock(struct rt_
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
> 
