Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaIWVJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:09:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38963 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaIWVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:09:36 -0400
Date: Tue, 23 Sep 2014 14:11:15 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH 4/9] percpu_ref: rename things to prepare for decoupling
 percpu/atomic mode switch
Message-ID: <20140923211115.GE15142@kmo-pixel>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
 <1411451718-17807-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411451718-17807-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:55:13AM -0400, Tejun Heo wrote:
> percpu_ref will be restructured so that percpu/atomic mode switching
> and reference killing are dedoupled.  In preparation, do the following
> renames.
> 
> * percpu_ref->confirm_kill	-> percpu_ref->confirm_switch
> * __PERCPU_REF_DEAD		-> __PERCPU_REF_ATOMIC
> * __percpu_ref_alive()		-> __ref_is_percpu()
> 
> This patch is pure rename and doesn't introduce any functional
> changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>

Reviewed-by: Kent Overstreet <kmo@daterainc.com>

> ---
>  include/linux/percpu-refcount.h | 25 ++++++++++++++-----------
>  lib/percpu-refcount.c           | 22 +++++++++++-----------
>  2 files changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 3d463a3..910e5f7 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -54,6 +54,11 @@
>  struct percpu_ref;
>  typedef void (percpu_ref_func_t)(struct percpu_ref *);
>  
> +/* flags set in the lower bits of percpu_ref->percpu_count_ptr */
> +enum {
> +	__PERCPU_REF_ATOMIC	= 1LU << 0,	/* operating in atomic mode */
> +};
> +
>  struct percpu_ref {
>  	atomic_long_t		count;
>  	/*
> @@ -62,7 +67,7 @@ struct percpu_ref {
>  	 */
>  	unsigned long		percpu_count_ptr;
>  	percpu_ref_func_t	*release;
> -	percpu_ref_func_t	*confirm_kill;
> +	percpu_ref_func_t	*confirm_switch;
>  	struct rcu_head		rcu;
>  };
>  
> @@ -88,23 +93,21 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
>  	return percpu_ref_kill_and_confirm(ref, NULL);
>  }
>  
> -#define __PERCPU_REF_DEAD	1
> -
>  /*
>   * Internal helper.  Don't use outside percpu-refcount proper.  The
>   * function doesn't return the pointer and let the caller test it for NULL
>   * because doing so forces the compiler to generate two conditional
>   * branches as it can't assume that @ref->percpu_count is not NULL.
>   */
> -static inline bool __percpu_ref_alive(struct percpu_ref *ref,
> -				      unsigned long __percpu **percpu_countp)
> +static inline bool __ref_is_percpu(struct percpu_ref *ref,
> +					  unsigned long __percpu **percpu_countp)
>  {
>  	unsigned long percpu_ptr = ACCESS_ONCE(ref->percpu_count_ptr);
>  
>  	/* paired with smp_store_release() in percpu_ref_reinit() */
>  	smp_read_barrier_depends();
>  
> -	if (unlikely(percpu_ptr & __PERCPU_REF_DEAD))
> +	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
>  		return false;
>  
>  	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
> @@ -125,7 +128,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
>  
>  	rcu_read_lock_sched();
>  
> -	if (__percpu_ref_alive(ref, &percpu_count))
> +	if (__ref_is_percpu(ref, &percpu_count))
>  		this_cpu_inc(*percpu_count);
>  	else
>  		atomic_long_inc(&ref->count);
> @@ -149,7 +152,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
>  
>  	rcu_read_lock_sched();
>  
> -	if (__percpu_ref_alive(ref, &percpu_count)) {
> +	if (__ref_is_percpu(ref, &percpu_count)) {
>  		this_cpu_inc(*percpu_count);
>  		ret = true;
>  	} else {
> @@ -183,7 +186,7 @@ static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
>  
>  	rcu_read_lock_sched();
>  
> -	if (__percpu_ref_alive(ref, &percpu_count)) {
> +	if (__ref_is_percpu(ref, &percpu_count)) {
>  		this_cpu_inc(*percpu_count);
>  		ret = true;
>  	}
> @@ -208,7 +211,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
>  
>  	rcu_read_lock_sched();
>  
> -	if (__percpu_ref_alive(ref, &percpu_count))
> +	if (__ref_is_percpu(ref, &percpu_count))
>  		this_cpu_dec(*percpu_count);
>  	else if (unlikely(atomic_long_dec_and_test(&ref->count)))
>  		ref->release(ref);
> @@ -228,7 +231,7 @@ static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
>  {
>  	unsigned long __percpu *percpu_count;
>  
> -	if (__percpu_ref_alive(ref, &percpu_count))
> +	if (__ref_is_percpu(ref, &percpu_count))
>  		return false;
>  	return !atomic_long_read(&ref->count);
>  }
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 5aea6b7..7aef590 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -34,7 +34,7 @@
>  static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
>  {
>  	return (unsigned long __percpu *)
> -		(ref->percpu_count_ptr & ~__PERCPU_REF_DEAD);
> +		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
>  }
>  
>  /**
> @@ -80,7 +80,7 @@ void percpu_ref_exit(struct percpu_ref *ref)
>  
>  	if (percpu_count) {
>  		free_percpu(percpu_count);
> -		ref->percpu_count_ptr = __PERCPU_REF_DEAD;
> +		ref->percpu_count_ptr = __PERCPU_REF_ATOMIC;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_exit);
> @@ -117,8 +117,8 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
>  		  ref->release, atomic_long_read(&ref->count));
>  
>  	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
> -	if (ref->confirm_kill)
> -		ref->confirm_kill(ref);
> +	if (ref->confirm_switch)
> +		ref->confirm_switch(ref);
>  
>  	/*
>  	 * Now we're in single atomic_long_t mode with a consistent
> @@ -145,11 +145,11 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
>  void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>  				 percpu_ref_func_t *confirm_kill)
>  {
> -	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_DEAD,
> +	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC,
>  		  "%s called more than once on %pf!", __func__, ref->release);
>  
> -	ref->percpu_count_ptr |= __PERCPU_REF_DEAD;
> -	ref->confirm_kill = confirm_kill;
> +	ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC;
> +	ref->confirm_switch = confirm_kill;
>  
>  	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
>  }
> @@ -178,14 +178,14 @@ void percpu_ref_reinit(struct percpu_ref *ref)
>  
>  	/*
>  	 * Restore per-cpu operation.  smp_store_release() is paired with
> -	 * smp_read_barrier_depends() in __percpu_ref_alive() and
> -	 * guarantees that the zeroing is visible to all percpu accesses
> -	 * which can see the following __PERCPU_REF_DEAD clearing.
> +	 * smp_read_barrier_depends() in __ref_is_percpu() and guarantees
> +	 * that the zeroing is visible to all percpu accesses which can see
> +	 * the following __PERCPU_REF_ATOMIC clearing.
>  	 */
>  	for_each_possible_cpu(cpu)
>  		*per_cpu_ptr(percpu_count, cpu) = 0;
>  
>  	smp_store_release(&ref->percpu_count_ptr,
> -			  ref->percpu_count_ptr & ~__PERCPU_REF_DEAD);
> +			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_reinit);
> -- 
> 1.9.3
> 
