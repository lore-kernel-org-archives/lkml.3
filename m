Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbaFRDhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:37:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:16982 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932192AbaFRDhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:37:05 -0400
X-IronPort-AV: E=Sophos;i="5.00,729,1396972800"; 
   d="scan'208";a="32066952"
Message-ID: <53A1097F.3060400@cn.fujitsu.com>
Date: Wed, 18 Jun 2014 11:37:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cl@linux-foundation.org>, <kmo@daterainc.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
References: <1403053685-28240-1-git-send-email-tj@kernel.org> <1403053685-28240-7-git-send-email-tj@kernel.org>
In-Reply-To: <1403053685-28240-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 09:08 AM, Tejun Heo wrote:
> Now that explicit invocation of percpu_ref_exit() is necessary to free
> the percpu counter, we can implement percpu_ref_reinit() which
> reinitializes a released percpu_ref.  This can be used implement
> scalable gating switch which can be drained and then re-opened without
> worrying about memory allocation failures.
> 
> percpu_ref_is_zero() is added to be used in a sanity check in
> percpu_ref_exit().  As this function will be useful for other purposes
> too, make it a public interface.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> ---
>  include/linux/percpu-refcount.h | 21 ++++++++++++++++++++-
>  lib/percpu-refcount.c           | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 0ddd283..80f21ea 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -67,6 +67,7 @@ struct percpu_ref {
>  
>  int __must_check percpu_ref_init(struct percpu_ref *ref,
>  				 percpu_ref_func_t *release);
> +void percpu_ref_reinit(struct percpu_ref *ref);
>  void percpu_ref_exit(struct percpu_ref *ref);
>  void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>  				 percpu_ref_func_t *confirm_kill);
> @@ -97,7 +98,10 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
>  static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
>  				    unsigned __percpu **pcpu_countp)
>  {
> -	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
> +	unsigned long pcpu_ptr;
> +
> +	/* paired with smp_store_release() in percpu_ref_reinit() */
> +	pcpu_ptr = smp_load_acquire(&ref->pcpu_count_ptr);


Does "smp_load_acquire()" hurts the performance of percpu_ref_get/put()
in non-x86 system?

>  
>  	if (unlikely(pcpu_ptr & PCPU_REF_DEAD))
>  		return false;
> @@ -206,4 +210,19 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
>  	rcu_read_unlock_sched();
>  }
>  
> +/**
> + * percpu_ref_is_zero - test whether a percpu refcount reached zero
> + * @ref: percpu_ref to test
> + *
> + * Returns %true if @ref reached zero.
> + */
> +static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +
> +	if (__pcpu_ref_alive(ref, &pcpu_count))
> +		return false;
> +	return !atomic_read(&ref->count);
> +}
> +
>  #endif
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index ac42991..b348a2f 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -61,6 +61,41 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
>  EXPORT_SYMBOL_GPL(percpu_ref_init);
>  
>  /**
> + * percpu_ref_reinit - re-initialize a percpu refcount
> + * @ref: perpcu_ref to re-initialize
> + *
> + * Re-initialize @ref so that it's in the same state as when it finished
> + * percpu_ref_init().  @ref must have been initialized successfully, killed
> + * and reached 0 but not exited.
> + *
> + * Note that percpu_ref_tryget[_live]() are safe to perform on @ref while
> + * this function is in progress.
> + */
> +void percpu_ref_reinit(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
> +	int cpu;
> +
> +	BUG_ON(!pcpu_count);
> +	WARN_ON(!percpu_ref_is_zero(ref));
> +
> +	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
> +
> +	/*
> +	 * Restore per-cpu operation.  smp_store_release() is paired with
> +	 * smp_load_acquire() in __pcpu_ref_alive() and guarantees that the
> +	 * zeroing is visible to all percpu accesses which can see the
> +	 * following PCPU_REF_DEAD clearing.
> +	 */
> +	for_each_possible_cpu(cpu)
> +		*per_cpu_ptr(pcpu_count, cpu) = 0;
> +
> +	smp_store_release(&ref->pcpu_count_ptr,
> +			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
> +}
> +EXPORT_SYMBOL_GPL(percpu_ref_reinit);
> +
> +/**
>   * percpu_ref_exit - undo percpu_ref_init()
>   * @ref: percpu_ref to exit
>   *

