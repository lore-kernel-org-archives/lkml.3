Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaAVDyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:54:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55614 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAVDyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:54:47 -0500
Date: Tue, 21 Jan 2014 19:54:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: uninline rcu_lock_acquire/etc ?
Message-ID: <20140122035440.GW10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140120181942.GA20783@redhat.com>
 <20140120182019.GA26515@redhat.com>
 <20140121141022.GX31570@twins.programming.kicks-ass.net>
 <20140121173534.GA25642@redhat.com>
 <20140121184310.GA24702@redhat.com>
 <20140121193909.GA17497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121193909.GA17497@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012203-0928-0000-0000-000005E027CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 08:39:09PM +0100, Oleg Nesterov wrote:
> On 01/21, Oleg Nesterov wrote:
> >
> > But I agreed that the code looks simpler with bitfields, so perhaps
> > this patch is better.
> 
> Besides, I guess the major offender is rcu...
> 
> Paul, can't we do something like below? Saves 19.5 kilobytes,
> 
> 	-       5255131 2974376 10125312        18354819        1181283 vmlinux
> 	+	5235227 2970344 10125312        18330883        117b503 vmlinux
> 
> probably we can also uninline rcu_lockdep_assert()...

Looks mostly plausible, some questions inline below.

							Thanx, Paul

> Oleg.
> ---
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 2eef290..58f7a97 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -310,18 +310,34 @@ static inline bool rcu_lockdep_current_cpu_online(void)
>  }
>  #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
> 
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -
> -static inline void rcu_lock_acquire(struct lockdep_map *map)
> +static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned long ip)
>  {
> -	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
> +	lock_acquire(map, 0, 0, 2, 0, NULL, ip);
>  }
> 
> -static inline void rcu_lock_release(struct lockdep_map *map)
> +static inline void __rcu_lock_release(struct lockdep_map *map, unsigned long ip)
>  {
>  	lock_release(map, 1, _THIS_IP_);
>  }
> 
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)
> +extern void rcu_lock_acquire(void);
> +extern void rcu_lock_release(void);
> +extern void rcu_lock_acquire_bh(void);
> +extern void rcu_lock_release_bh(void);
> +extern void rcu_lock_acquire_sched(void);
> +extern void rcu_lock_release_sched(void);
> +#else
> +#define rcu_lock_acquire()		do { } while (0)
> +#define rcu_lock_release()		do { } while (0)
> +#define rcu_lock_acquire_bh()		do { } while (0)
> +#define rcu_lock_release_bh()		do { } while (0)
> +#define rcu_lock_acquire_sched()	do { } while (0)
> +#define rcu_lock_release_sched()	do { } while (0)
> +#endif
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +
>  extern struct lockdep_map rcu_lock_map;
>  extern struct lockdep_map rcu_bh_lock_map;
>  extern struct lockdep_map rcu_sched_lock_map;
> @@ -419,9 +435,6 @@ static inline int rcu_read_lock_sched_held(void)
> 
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> 
> -# define rcu_lock_acquire(a)		do { } while (0)
> -# define rcu_lock_release(a)		do { } while (0)
> -
>  static inline int rcu_read_lock_held(void)
>  {
>  	return 1;
> @@ -766,11 +779,9 @@ static inline void rcu_preempt_sleep_check(void)
>   */
>  static inline void rcu_read_lock(void)
>  {
> -	__rcu_read_lock();
>  	__acquire(RCU);
> -	rcu_lock_acquire(&rcu_lock_map);
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_lock() used illegally while idle");
> +	__rcu_read_lock();
> +	rcu_lock_acquire();

Not sure why __rcu_read_lock() needs to be in any particular order
with respect to the sparse __acquire(RCU), but should work either way.
Same question about the other reorderings of similar statements.

>  }
> 
>  /*
> @@ -790,11 +801,9 @@ static inline void rcu_read_lock(void)
>   */
>  static inline void rcu_read_unlock(void)
>  {
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_unlock() used illegally while idle");
> -	rcu_lock_release(&rcu_lock_map);
> -	__release(RCU);
> +	rcu_lock_release();
>  	__rcu_read_unlock();
> +	__release(RCU);
>  }
> 
>  /**
> @@ -816,11 +825,9 @@ static inline void rcu_read_unlock(void)
>   */
>  static inline void rcu_read_lock_bh(void)
>  {
> -	local_bh_disable();
>  	__acquire(RCU_BH);
> -	rcu_lock_acquire(&rcu_bh_lock_map);
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_lock_bh() used illegally while idle");
> +	local_bh_disable();
> +	rcu_lock_acquire_bh();
>  }
> 
>  /*
> @@ -830,11 +837,9 @@ static inline void rcu_read_lock_bh(void)
>   */
>  static inline void rcu_read_unlock_bh(void)
>  {
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_unlock_bh() used illegally while idle");
> -	rcu_lock_release(&rcu_bh_lock_map);
> -	__release(RCU_BH);
> +	rcu_lock_release_bh();
>  	local_bh_enable();
> +	__release(RCU_BH);
>  }
> 
>  /**
> @@ -852,9 +857,9 @@ static inline void rcu_read_unlock_bh(void)
>   */
>  static inline void rcu_read_lock_sched(void)
>  {
> -	preempt_disable();
>  	__acquire(RCU_SCHED);
> -	rcu_lock_acquire(&rcu_sched_lock_map);
> +	preempt_disable();
> +	rcu_lock_acquire_sched();
>  	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_lock_sched() used illegally while idle");

The above pair of lines (rcu_lockdep_assert()) should also be removed,
correct?

>  }
> @@ -862,8 +867,8 @@ static inline void rcu_read_lock_sched(void)
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
>  static inline notrace void rcu_read_lock_sched_notrace(void)
>  {
> -	preempt_disable_notrace();
>  	__acquire(RCU_SCHED);
> +	preempt_disable_notrace();

I cannot help repeating myself on this one...  ;-)

Why the change in order?

>  }
> 
>  /*
> @@ -873,18 +878,16 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
>   */
>  static inline void rcu_read_unlock_sched(void)
>  {
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_unlock_sched() used illegally while idle");
> -	rcu_lock_release(&rcu_sched_lock_map);
> -	__release(RCU_SCHED);
> +	rcu_lock_release_sched();
>  	preempt_enable();
> +	__release(RCU_SCHED);
>  }
> 
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
>  static inline notrace void rcu_read_unlock_sched_notrace(void)
>  {
> -	__release(RCU_SCHED);
>  	preempt_enable_notrace();
> +	__release(RCU_SCHED);
>  }
> 
>  /**
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 9b058ee..9b0f568 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
>  {
>  	int retval = __srcu_read_lock(sp);
> 
> -	rcu_lock_acquire(&(sp)->dep_map);
> +	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);

Good, we do not way srcu_read_lock() complaining about offline or idle
CPUs.

>  	return retval;
>  }
> 
> @@ -233,7 +233,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
>  static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
>  	__releases(sp)
>  {
> -	rcu_lock_release(&(sp)->dep_map);
> +	__rcu_lock_release(&(sp)->dep_map, _THIS_IP_);
>  	__srcu_read_unlock(sp, idx);
>  }
> 
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index a3596c8..19ff915 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -333,4 +333,47 @@ static int __init check_cpu_stall_init(void)
>  }
>  early_initcall(check_cpu_stall_init);
> 
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)
> +
> +static void ck_rcu_is_watching(const char *message)
> +{
> +	rcu_lockdep_assert(rcu_is_watching(), message);
> +}
> +
> +void rcu_lock_acquire(void)
> +{
> +	__rcu_lock_acquire(&rcu_lock_map, _RET_IP_);
> +	ck_rcu_is_watching("rcu_read_lock() used illegally while idle");
> +}
> +
> +void rcu_lock_release(void)
> +{
> +	ck_rcu_is_watching("rcu_read_unlock() used illegally while idle");
> +	__rcu_lock_release(&rcu_lock_map, _RET_IP_);
> +}
> +
> +void rcu_lock_acquire_bh(void)
> +{
> +	__rcu_lock_acquire(&rcu_bh_lock_map, _RET_IP_);
> +	ck_rcu_is_watching("rcu_read_lock_bh() used illegally while idle");
> +}
> +
> +void rcu_lock_release_bh(void)
> +{
> +	ck_rcu_is_watching("rcu_read_unlock_bh() used illegally while idle");
> +	__rcu_lock_release(&rcu_bh_lock_map, _RET_IP_);
> +}
> +void rcu_lock_acquire_sched(void)
> +{
> +	__rcu_lock_acquire(&rcu_sched_lock_map, _RET_IP_);
> +	ck_rcu_is_watching("rcu_read_lock_sched() used illegally while idle");
> +}
> +
> +void rcu_lock_release_sched(void)
> +{
> +	ck_rcu_is_watching("rcu_read_unlock_sched() used illegally while idle");
> +	__rcu_lock_release(&rcu_sched_lock_map, _RET_IP_);
> +}
> +#endif
> +
>  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
> 

