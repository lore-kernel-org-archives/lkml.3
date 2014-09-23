Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaIWVMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:12:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41550 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaIWVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:11:58 -0400
Date: Tue, 23 Sep 2014 14:13:38 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH 6/9] percpu_ref: decouple switching to atomic mode and
 killing
Message-ID: <20140923211338.GF15142@kmo-pixel>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
 <1411451718-17807-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411451718-17807-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:55:15AM -0400, Tejun Heo wrote:
> percpu_ref has treated the dropping of the base reference and
> switching to atomic mode as an integral operation; however, there's
> nothing inherent tying the two together.
> 
> The use cases for percpu_ref have been expanding continuously.  While
> the current init/kill/reinit/exit model can cover a lot, the coupling
> of kill/reinit with atomic/percpu mode switching is turning out to be
> too restrictive for use cases where many percpu_refs are created and
> destroyed back-to-back with only some of them reaching extended
> operation.  The coupling also makes implementing always-atomic debug
> mode difficult.
> 
> This patch separates out atomic mode switching into
> percpu_ref_switch_to_atomic() and reimplements
> percpu_ref_kill_and_confirm() on top of it.
> 
> * The handling of __PERCPU_REF_ATOMIC and __PERCPU_REF_DEAD is now
>   differentiated.  Among get/put operations, percpu_ref_tryget_live()
>   is the only one which cares about DEAD.
> 
> * percpu_ref_switch_to_atomic() can be called multiple times on the
>   same ref.  This means that multiple @confirm_switch may get queued
>   up which we can't do reliably without extra memory area.  This is
>   handled by making the later invocation synchronously wait for the
>   completion of the previous one.  This isn't particularly desirable
>   but such synchronous waits shouldn't happen in most cases.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Kent Overstreet <kmo@daterainc.com>

> ---
>  include/linux/percpu-refcount.h |   8 ++-
>  lib/percpu-refcount.c           | 141 +++++++++++++++++++++++++++++++---------
>  2 files changed, 116 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 24cf157..03a02e9 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -76,9 +76,11 @@ struct percpu_ref {
>  int __must_check percpu_ref_init(struct percpu_ref *ref,
>  				 percpu_ref_func_t *release, gfp_t gfp);
>  void percpu_ref_exit(struct percpu_ref *ref);
> +void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
> +				 percpu_ref_func_t *confirm_switch);
> +void percpu_ref_reinit(struct percpu_ref *ref);
>  void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>  				 percpu_ref_func_t *confirm_kill);
> -void percpu_ref_reinit(struct percpu_ref *ref);
>  
>  /**
>   * percpu_ref_kill - drop the initial ref
> @@ -109,7 +111,7 @@ static inline bool __ref_is_percpu(struct percpu_ref *ref,
>  	/* paired with smp_store_release() in percpu_ref_reinit() */
>  	smp_read_barrier_depends();
>  
> -	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC_DEAD))
> +	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
>  		return false;
>  
>  	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
> @@ -191,6 +193,8 @@ static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
>  	if (__ref_is_percpu(ref, &percpu_count)) {
>  		this_cpu_inc(*percpu_count);
>  		ret = true;
> +	} else if (!(ACCESS_ONCE(ref->percpu_count_ptr) & __PERCPU_REF_DEAD)) {
> +		ret = atomic_long_inc_not_zero(&ref->count);
>  	}
>  
>  	rcu_read_unlock_sched();
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index b0b8c09..56a7c0d 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -1,6 +1,8 @@
>  #define pr_fmt(fmt) "%s: " fmt "\n", __func__
>  
>  #include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/wait.h>
>  #include <linux/percpu-refcount.h>
>  
>  /*
> @@ -31,6 +33,8 @@
>  
>  #define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 1))
>  
> +static DECLARE_WAIT_QUEUE_HEAD(percpu_ref_switch_waitq);
> +
>  static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
>  {
>  	return (unsigned long __percpu *)
> @@ -88,7 +92,19 @@ void percpu_ref_exit(struct percpu_ref *ref)
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_exit);
>  
> -static void percpu_ref_kill_rcu(struct rcu_head *rcu)
> +static void percpu_ref_call_confirm_rcu(struct rcu_head *rcu)
> +{
> +	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
> +
> +	ref->confirm_switch(ref);
> +	ref->confirm_switch = NULL;
> +	wake_up_all(&percpu_ref_switch_waitq);
> +
> +	/* drop ref from percpu_ref_switch_to_atomic() */
> +	percpu_ref_put(ref);
> +}
> +
> +static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
>  {
>  	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
>  	unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
> @@ -116,47 +132,79 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
>  	atomic_long_add((long)count - PERCPU_COUNT_BIAS, &ref->count);
>  
>  	WARN_ONCE(atomic_long_read(&ref->count) <= 0,
> -		  "percpu ref (%pf) <= 0 (%ld) after killed",
> +		  "percpu ref (%pf) <= 0 (%ld) after switching to atomic",
>  		  ref->release, atomic_long_read(&ref->count));
>  
> -	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
> -	if (ref->confirm_switch)
> -		ref->confirm_switch(ref);
> +	/* @ref is viewed as dead on all CPUs, send out switch confirmation */
> +	percpu_ref_call_confirm_rcu(rcu);
> +}
>  
> -	/*
> -	 * Now we're in single atomic_long_t mode with a consistent
> -	 * refcount, so it's safe to drop our initial ref:
> -	 */
> -	percpu_ref_put(ref);
> +static void percpu_ref_noop_confirm_switch(struct percpu_ref *ref)
> +{
> +}
> +
> +static void __percpu_ref_switch_to_atomic(struct percpu_ref *ref,
> +					  percpu_ref_func_t *confirm_switch)
> +{
> +	if (!(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC)) {
> +		/* switching from percpu to atomic */
> +		ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC;
> +
> +		/*
> +		 * Non-NULL ->confirm_switch is used to indicate that
> +		 * switching is in progress.  Use noop one if unspecified.
> +		 */
> +		WARN_ON_ONCE(ref->confirm_switch);
> +		ref->confirm_switch =
> +			confirm_switch ?: percpu_ref_noop_confirm_switch;
> +
> +		percpu_ref_get(ref);	/* put after confirmation */
> +		call_rcu_sched(&ref->rcu, percpu_ref_switch_to_atomic_rcu);
> +	} else if (confirm_switch) {
> +		/*
> +		 * Somebody already set ATOMIC.  Switching may still be in
> +		 * progress.  @confirm_switch must be invoked after the
> +		 * switching is complete and a full sched RCU grace period
> +		 * has passed.  Wait synchronously for the previous
> +		 * switching and schedule @confirm_switch invocation.
> +		 */
> +		wait_event(percpu_ref_switch_waitq, !ref->confirm_switch);
> +		ref->confirm_switch = confirm_switch;
> +
> +		percpu_ref_get(ref);	/* put after confirmation */
> +		call_rcu_sched(&ref->rcu, percpu_ref_call_confirm_rcu);
> +	}
>  }
>  
>  /**
> - * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirmation
> - * @ref: percpu_ref to kill
> - * @confirm_kill: optional confirmation callback
> + * percpu_ref_switch_to_atomic - switch a percpu_ref to atomic mode
> + * @ref: percpu_ref to switch to atomic mode
> + * @confirm_switch: optional confirmation callback
>   *
> - * Equivalent to percpu_ref_kill() but also schedules kill confirmation if
> - * @confirm_kill is not NULL.  @confirm_kill, which may not block, will be
> - * called after @ref is seen as dead from all CPUs - all further
> - * invocations of percpu_ref_tryget_live() will fail.  See
> - * percpu_ref_tryget_live() for more details.
> + * There's no reason to use this function for the usual reference counting.
> + * Use percpu_ref_kill[_and_confirm]().
> + *
> + * Schedule switching of @ref to atomic mode.  All its percpu counts will
> + * be collected to the main atomic counter.  On completion, when all CPUs
> + * are guaraneed to be in atomic mode, @confirm_switch, which may not
> + * block, is invoked.  This function may be invoked concurrently with all
> + * the get/put operations and can safely be mixed with kill and reinit
> + * operations.
>   *
> - * Due to the way percpu_ref is implemented, @confirm_kill will be called
> - * after at least one full RCU grace period has passed but this is an
> - * implementation detail and callers must not depend on it.
> + * This function normally doesn't block and can be called from any context
> + * but it may block if @confirm_kill is specified and @ref is already in
> + * the process of switching to atomic mode.  In such cases, @confirm_switch
> + * will be invoked after the switching is complete.
> + *
> + * Due to the way percpu_ref is implemented, @confirm_switch will be called
> + * after at least one full sched RCU grace period has passed but this is an
> + * implementation detail and must not be depended upon.
>   */
> -void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> -				 percpu_ref_func_t *confirm_kill)
> +void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
> +				 percpu_ref_func_t *confirm_switch)
>  {
> -	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC_DEAD,
> -		  "%s called more than once on %pf!", __func__, ref->release);
> -
> -	ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC_DEAD;
> -	ref->confirm_switch = confirm_kill;
> -
> -	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
> +	__percpu_ref_switch_to_atomic(ref, confirm_switch);
>  }
> -EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
>  
>  /**
>   * percpu_ref_reinit - re-initialize a percpu refcount
> @@ -192,3 +240,34 @@ void percpu_ref_reinit(struct percpu_ref *ref)
>  			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_reinit);
> +
> +/**
> + * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirmation
> + * @ref: percpu_ref to kill
> + * @confirm_kill: optional confirmation callback
> + *
> + * Equivalent to percpu_ref_kill() but also schedules kill confirmation if
> + * @confirm_kill is not NULL.  @confirm_kill, which may not block, will be
> + * called after @ref is seen as dead from all CPUs at which point all
> + * further invocations of percpu_ref_tryget_live() will fail.  See
> + * percpu_ref_tryget_live() for details.
> + *
> + * This function normally doesn't block and can be called from any context
> + * but it may block if @confirm_kill is specified and @ref is already in
> + * the process of switching to atomic mode by percpu_ref_switch_atomic().
> + *
> + * Due to the way percpu_ref is implemented, @confirm_switch will be called
> + * after at least one full sched RCU grace period has passed but this is an
> + * implementation detail and must not be depended upon.
> + */
> +void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> +				 percpu_ref_func_t *confirm_kill)
> +{
> +	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_DEAD,
> +		  "%s called more than once on %pf!", __func__, ref->release);
> +
> +	ref->percpu_count_ptr |= __PERCPU_REF_DEAD;
> +	__percpu_ref_switch_to_atomic(ref, confirm_kill);
> +	percpu_ref_put(ref);
> +}
> +EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
> -- 
> 1.9.3
> 
