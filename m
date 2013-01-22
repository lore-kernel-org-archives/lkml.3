Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3AVGum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:50:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58767 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3AVGul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:50:41 -0500
X-AuditID: 9c930179-b7d01ae000004006-b7-50fe36bfa7d2
Date: Tue, 22 Jan 2013 15:50:39 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 15/17] workqueue: remove global_cwq
Message-ID: <20130122065039.GA4417@lge.com>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
 <1358386969-945-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358386969-945-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 05:42:47PM -0800, Tejun Heo wrote:
> global_cwq is now nothing but a container for per-pcu standard

s/per-pcu/per-cpu/

> worker_pools.  Declare the worker pools directly as
> cpu/unbound_std_worker_pools[] and remove global_cwq.
> 
> * get_gcwq() is replaced with std_worker_pools() which returns the
>   pointer to the standard pool array for a given CPU.
> 
> * __alloc_workqueue_key() updated to use get_std_worker_pool() instead
>   of open-coding pool determination.
> 
> This is part of an effort to remove global_cwq and make worker_pool
> the top level abstraction, which in turn will help implementing worker
> pools with user-specified attributes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 47 +++++++++++++++++------------------------------
>  1 file changed, 17 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index d37db53..4bddf52 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -120,7 +120,6 @@ enum {
>   * W: workqueue_lock protected.
>   */
>  
> -struct global_cwq;
>  struct worker_pool;
>  
>  /*
> @@ -174,16 +173,6 @@ struct worker_pool {
>  };
>  
>  /*
> - * Global per-cpu workqueue.  There's one and only one for each cpu
> - * and all works are queued and processed here regardless of their
> - * target workqueues.
> - */
> -struct global_cwq {
> -	struct worker_pool	pools[NR_STD_WORKER_POOLS];
> -						/* normal and highpri pools */
> -} ____cacheline_aligned_in_smp;
> -
> -/*
>   * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
>   * work_struct->data are used for flags and thus cwqs need to be
>   * aligned at two's power of the number of flag bits.
> @@ -277,8 +266,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
>  #include <trace/events/workqueue.h>
>  
>  #define for_each_std_worker_pool(pool, cpu)				\
> -	for ((pool) = &get_gcwq((cpu))->pools[0];			\
> -	     (pool) < &get_gcwq((cpu))->pools[NR_STD_WORKER_POOLS]; (pool)++)
> +	for ((pool) = &std_worker_pools(cpu)[0];			\
> +	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
>  
>  #define for_each_busy_worker(worker, i, pos, pool)			\
>  	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
> @@ -454,19 +443,19 @@ static LIST_HEAD(workqueues);
>  static bool workqueue_freezing;		/* W: have wqs started freezing? */
>  
>  /*
> - * The almighty global cpu workqueues.  nr_running is the only field
> - * which is expected to be used frequently by other cpus via
> - * try_to_wake_up().  Put it in a separate cacheline.
> + * The CPU standard worker pools.  nr_running is the only field which is
> + * expected to be used frequently by other cpus via try_to_wake_up().  Put
> + * it in a separate cacheline.
>   */
> -static DEFINE_PER_CPU(struct global_cwq, global_cwq);
> +static DEFINE_PER_CPU_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
> +			      cpu_std_worker_pools);
>  static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);

Why worker_pool is defined as DEFINE_PER_CPU_ALIGNED?

And this makes only worker_pool[0] aligned with cacheline.
worker_pool[1] is not aligned with cacheline.
Now, we have a spin_lock for each instance of worker_pool and
each one is independent instance.
So, IMHO, it is better to align worker_pool[1] with cacheline.

Thanks.

>  /*
> - * Global cpu workqueue and nr_running counter for unbound gcwq.  The pools
> - * for online CPUs have POOL_DISASSOCIATED set, and all their workers have
> - * WORKER_UNBOUND set.
> + * Standard worker pools and nr_running counter for unbound CPU.  The pools
> + * have POOL_DISASSOCIATED set, and all workers have WORKER_UNBOUND set.
>   */
> -static struct global_cwq unbound_global_cwq;
> +static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
>  static atomic_t unbound_pool_nr_running[NR_STD_WORKER_POOLS] = {
>  	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
>  };
> @@ -477,17 +466,17 @@ static DEFINE_IDR(worker_pool_idr);
>  
>  static int worker_thread(void *__worker);
>  
> -static struct global_cwq *get_gcwq(unsigned int cpu)
> +static struct worker_pool *std_worker_pools(int cpu)
>  {
>  	if (cpu != WORK_CPU_UNBOUND)
> -		return &per_cpu(global_cwq, cpu);
> +		return per_cpu(cpu_std_worker_pools, cpu);
>  	else
> -		return &unbound_global_cwq;
> +		return unbound_std_worker_pools;
>  }
>  
>  static int std_worker_pool_pri(struct worker_pool *pool)
>  {
> -	return pool - get_gcwq(pool->cpu)->pools;
> +	return pool - std_worker_pools(pool->cpu);
>  }
>  
>  /* allocate ID and assign it to @pool */
> @@ -514,9 +503,9 @@ static struct worker_pool *worker_pool_by_id(int pool_id)
>  
>  static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
>  {
> -	struct global_cwq *gcwq = get_gcwq(cpu);
> +	struct worker_pool *pools = std_worker_pools(cpu);
>  
> -	return &gcwq->pools[highpri];
> +	return &pools[highpri];
>  }
>  
>  static atomic_t *get_pool_nr_running(struct worker_pool *pool)
> @@ -3279,11 +3268,9 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>  
>  	for_each_cwq_cpu(cpu, wq) {
>  		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> -		struct global_cwq *gcwq = get_gcwq(cpu);
> -		int pool_idx = (bool)(flags & WQ_HIGHPRI);
>  
>  		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
> -		cwq->pool = &gcwq->pools[pool_idx];
> +		cwq->pool = get_std_worker_pool(cpu, flags & WQ_HIGHPRI);
>  		cwq->wq = wq;
>  		cwq->flush_color = -1;
>  		cwq->max_active = max_active;
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
