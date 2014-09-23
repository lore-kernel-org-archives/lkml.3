Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaIWVNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:13:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36653 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaIWVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:13:08 -0400
Date: Tue, 23 Sep 2014 14:14:48 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH v2 5/9] percpu_ref: add PCPU_REF_DEAD
Message-ID: <20140923211448.GG15142@kmo-pixel>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
 <1411451718-17807-6-git-send-email-tj@kernel.org>
 <20140923134851.GE14905@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923134851.GE14905@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:48:51AM -0400, Tejun Heo wrote:
> From 6f5bdc32c66317416c13eedb68ead2b36fb02603 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 23 Sep 2014 09:45:56 -0400
> 
> percpu_ref will be restructured so that percpu/atomic mode switching
> and reference killing are dedoupled.  In preparation, add
> PCPU_REF_DEAD and PCPU_REF_ATOMIC_DEAD which is OR of ATOMIC and DEAD.
> For now, ATOMIC and DEAD are changed together and all PCPU_REF_ATOMIC
> uses are converted to PCPU_REF_ATOMIC_DEAD without causing any
> behavior changes.
> 
> percpu_ref_init() now specifies an explicit alignment when allocating
> the percpu counters so that the pointer has enough unused low bits to
> accomodate the flags.  Note that one flag was fine as min alignment
> for percpu memory is 2 bytes but two flags are already too many for
> the natural alignment of unsigned longs on archs like cris and m68k.
> 
> v2: The original patch had BUILD_BUG_ON() which triggers if unsigned
>     long's alignment isn't enough to accomodate the flags, which
>     triggered on cris and m64k.  percpu_ref_init() updated to specify
>     the required alignment explicitly.  Reported by Fengguang.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: kbuild test robot <fengguang.wu@intel.com>

Reviewed-by: Kent Overstreet <kmo@daterainc.com>

> ---
>  include/linux/percpu-refcount.h |  6 +++++-
>  lib/percpu-refcount.c           | 19 +++++++++++--------
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 910e5f7..bd9483d 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -57,6 +57,10 @@ typedef void (percpu_ref_func_t)(struct percpu_ref *);
>  /* flags set in the lower bits of percpu_ref->percpu_count_ptr */
>  enum {
>  	__PERCPU_REF_ATOMIC	= 1LU << 0,	/* operating in atomic mode */
> +	__PERCPU_REF_DEAD	= 1LU << 1,	/* (being) killed */
> +	__PERCPU_REF_ATOMIC_DEAD = __PERCPU_REF_ATOMIC | __PERCPU_REF_DEAD,
> +
> +	__PERCPU_REF_FLAG_BITS	= 2,
>  };
>  
>  struct percpu_ref {
> @@ -107,7 +111,7 @@ static inline bool __ref_is_percpu(struct percpu_ref *ref,
>  	/* paired with smp_store_release() in percpu_ref_reinit() */
>  	smp_read_barrier_depends();
>  
> -	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
> +	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC_DEAD))
>  		return false;
>  
>  	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 7aef590..e2ff19f 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -34,7 +34,7 @@
>  static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
>  {
>  	return (unsigned long __percpu *)
> -		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
> +		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
>  }
>  
>  /**
> @@ -52,10 +52,13 @@ static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
>  int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
>  		    gfp_t gfp)
>  {
> +	size_t align = max_t(size_t, 1 << __PERCPU_REF_FLAG_BITS,
> +			     __alignof__(unsigned long));
> +
>  	atomic_long_set(&ref->count, 1 + PERCPU_COUNT_BIAS);
>  
> -	ref->percpu_count_ptr =
> -		(unsigned long)alloc_percpu_gfp(unsigned long, gfp);
> +	ref->percpu_count_ptr = (unsigned long)
> +		__alloc_percpu_gfp(sizeof(unsigned long), align, gfp);
>  	if (!ref->percpu_count_ptr)
>  		return -ENOMEM;
>  
> @@ -80,7 +83,7 @@ void percpu_ref_exit(struct percpu_ref *ref)
>  
>  	if (percpu_count) {
>  		free_percpu(percpu_count);
> -		ref->percpu_count_ptr = __PERCPU_REF_ATOMIC;
> +		ref->percpu_count_ptr = __PERCPU_REF_ATOMIC_DEAD;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_exit);
> @@ -145,10 +148,10 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
>  void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>  				 percpu_ref_func_t *confirm_kill)
>  {
> -	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC,
> +	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC_DEAD,
>  		  "%s called more than once on %pf!", __func__, ref->release);
>  
> -	ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC;
> +	ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC_DEAD;
>  	ref->confirm_switch = confirm_kill;
>  
>  	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
> @@ -180,12 +183,12 @@ void percpu_ref_reinit(struct percpu_ref *ref)
>  	 * Restore per-cpu operation.  smp_store_release() is paired with
>  	 * smp_read_barrier_depends() in __ref_is_percpu() and guarantees
>  	 * that the zeroing is visible to all percpu accesses which can see
> -	 * the following __PERCPU_REF_ATOMIC clearing.
> +	 * the following __PERCPU_REF_ATOMIC_DEAD clearing.
>  	 */
>  	for_each_possible_cpu(cpu)
>  		*per_cpu_ptr(percpu_count, cpu) = 0;
>  
>  	smp_store_release(&ref->percpu_count_ptr,
> -			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
> +			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_reinit);
> -- 
> 1.9.3
> 
