Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3CJKGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:06:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3CJKGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:06:46 -0400
X-IronPort-AV: E=Sophos;i="4.84,818,1355068800"; 
   d="scan'208";a="6844186"
Message-ID: <513C5BB9.7030305@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 18:08:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 17/31] workqueue: implement attribute-based unbound worker_pool
 management
References: <1362194662-2344-1-git-send-email-tj@kernel.org> <1362194662-2344-18-git-send-email-tj@kernel.org>
In-Reply-To: <1362194662-2344-18-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:05:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:05:34,
	Serialize complete at 2013/03/10 18:05:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 11:24, Tejun Heo wrote:
> This patch makes unbound worker_pools reference counted and
> dynamically created and destroyed as workqueues needing them come and
> go.  All unbound worker_pools are hashed on unbound_pool_hash which is
> keyed by the content of worker_pool->attrs.
> 
> When an unbound workqueue is allocated, get_unbound_pool() is called
> with the attributes of the workqueue.  If there already is a matching
> worker_pool, the reference count is bumped and the pool is returned.
> If not, a new worker_pool with matching attributes is created and
> returned.
> 
> When an unbound workqueue is destroyed, put_unbound_pool() is called
> which decrements the reference count of the associated worker_pool.
> If the refcnt reaches zero, the worker_pool is destroyed in sched-RCU
> safe way.
> 
> Note that the standard unbound worker_pools - normal and highpri ones
> with no specific cpumask affinity - are no longer created explicitly
> during init_workqueues().  init_workqueues() only initializes
> workqueue_attrs to be used for standard unbound pools -
> unbound_std_wq_attrs[].  The pools are spawned on demand as workqueues
> are created.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 230 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 218 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 7eba824..fb91b67 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -41,6 +41,7 @@
>  #include <linux/debug_locks.h>
>  #include <linux/lockdep.h>
>  #include <linux/idr.h>
> +#include <linux/jhash.h>
>  #include <linux/hashtable.h>
>  #include <linux/rculist.h>
>  
> @@ -80,6 +81,7 @@ enum {
>  
>  	NR_STD_WORKER_POOLS	= 2,		/* # standard pools per cpu */
>  
> +	UNBOUND_POOL_HASH_ORDER	= 6,		/* hashed by pool->attrs */
>  	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
>  
>  	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
> @@ -149,6 +151,8 @@ struct worker_pool {
>  	struct ida		worker_ida;	/* L: for worker IDs */
>  
>  	struct workqueue_attrs	*attrs;		/* I: worker attributes */
> +	struct hlist_node	hash_node;	/* R: unbound_pool_hash node */
> +	atomic_t		refcnt;		/* refcnt for unbound pools */
>  
>  	/*
>  	 * The current concurrency level.  As it's likely to be accessed
> @@ -156,6 +160,12 @@ struct worker_pool {
>  	 * cacheline.
>  	 */
>  	atomic_t		nr_running ____cacheline_aligned_in_smp;
> +
> +	/*
> +	 * Destruction of pool is sched-RCU protected to allow dereferences
> +	 * from get_work_pool().
> +	 */
> +	struct rcu_head		rcu;
>  } ____cacheline_aligned_in_smp;
>  
>  /*
> @@ -218,6 +228,11 @@ struct workqueue_struct {
>  
>  static struct kmem_cache *pwq_cache;
>  
> +/* hash of all unbound pools keyed by pool->attrs */
> +static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
> +
> +static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
> +
>  struct workqueue_struct *system_wq __read_mostly;
>  EXPORT_SYMBOL_GPL(system_wq);
>  struct workqueue_struct *system_highpri_wq __read_mostly;
> @@ -1740,7 +1755,7 @@ static struct worker *create_worker(struct worker_pool *pool)
>  	worker->pool = pool;
>  	worker->id = id;
>  
> -	if (pool->cpu != WORK_CPU_UNBOUND)
> +	if (pool->cpu >= 0)
>  		worker->task = kthread_create_on_node(worker_thread,
>  					worker, cpu_to_node(pool->cpu),
>  					"kworker/%d:%d%s", pool->cpu, id, pri);
> @@ -3159,6 +3174,54 @@ fail:
>  	return NULL;
>  }
>  
> +static void copy_workqueue_attrs(struct workqueue_attrs *to,
> +				 const struct workqueue_attrs *from)
> +{
> +	to->nice = from->nice;
> +	cpumask_copy(to->cpumask, from->cpumask);
> +}
> +
> +/*
> + * Hacky implementation of jhash of bitmaps which only considers the
> + * specified number of bits.  We probably want a proper implementation in
> + * include/linux/jhash.h.
> + */
> +static u32 jhash_bitmap(const unsigned long *bitmap, int bits, u32 hash)
> +{
> +	int nr_longs = bits / BITS_PER_LONG;
> +	int nr_leftover = bits % BITS_PER_LONG;
> +	unsigned long leftover = 0;
> +
> +	if (nr_longs)
> +		hash = jhash(bitmap, nr_longs * sizeof(long), hash);
> +	if (nr_leftover) {
> +		bitmap_copy(&leftover, bitmap + nr_longs, nr_leftover);
> +		hash = jhash(&leftover, sizeof(long), hash);
> +	}
> +	return hash;
> +}
> +
> +/* hash value of the content of @attr */
> +static u32 wqattrs_hash(const struct workqueue_attrs *attrs)
> +{
> +	u32 hash = 0;
> +
> +	hash = jhash_1word(attrs->nice, hash);
> +	hash = jhash_bitmap(cpumask_bits(attrs->cpumask), nr_cpu_ids, hash);
> +	return hash;
> +}
> +
> +/* content equality test */
> +static bool wqattrs_equal(const struct workqueue_attrs *a,
> +			  const struct workqueue_attrs *b)
> +{
> +	if (a->nice != b->nice)
> +		return false;
> +	if (!cpumask_equal(a->cpumask, b->cpumask))
> +		return false;
> +	return true;
> +}
> +
>  /**
>   * init_worker_pool - initialize a newly zalloc'd worker_pool
>   * @pool: worker_pool to initialize
> @@ -3169,6 +3232,8 @@ fail:
>  static int init_worker_pool(struct worker_pool *pool)
>  {
>  	spin_lock_init(&pool->lock);
> +	pool->id = -1;
> +	pool->cpu = -1;
>  	pool->flags |= POOL_DISASSOCIATED;
>  	INIT_LIST_HEAD(&pool->worklist);
>  	INIT_LIST_HEAD(&pool->idle_list);
> @@ -3185,12 +3250,133 @@ static int init_worker_pool(struct worker_pool *pool)
>  	mutex_init(&pool->assoc_mutex);
>  	ida_init(&pool->worker_ida);
>  
> +	INIT_HLIST_NODE(&pool->hash_node);
> +	atomic_set(&pool->refcnt, 1);

We should document: the code before "atomic_set(&pool->refcnt, 1);" should not failed.
(In case we add failable code before it when we forget this requirement in future".
reason: when get_unbound_pool() fails, we expected ->refcnt = 1)

>  	pool->attrs = alloc_workqueue_attrs(GFP_KERNEL);
>  	if (!pool->attrs)
>  		return -ENOMEM;
>  	return 0;
>  }
>  
> +static void rcu_free_pool(struct rcu_head *rcu)
> +{
> +	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
> +
> +	ida_destroy(&pool->worker_ida);
> +	free_workqueue_attrs(pool->attrs);
> +	kfree(pool);
> +}
> +
> +/**
> + * put_unbound_pool - put a worker_pool
> + * @pool: worker_pool to put
> + *
> + * Put @pool.  If its refcnt reaches zero, it gets destroyed in sched-RCU
> + * safe manner.
> + */
> +static void put_unbound_pool(struct worker_pool *pool)
> +{
> +	struct worker *worker;
> +
> +	if (!atomic_dec_and_test(&pool->refcnt))
> +		return;

if get_unbound_pool() happens here, it will get a destroyed pool.
so we need to move "spin_lock_irq(&workqueue_lock);" before above statement.
(and ->refcnt don't need atomic after moved)


> +
> +	/* sanity checks */
> +	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)))
> +		return;


> +	if (WARN_ON(pool->nr_workers != pool->nr_idle))
> +		return;

This can be false-negative. we should remove this WARN_ON().

> +	if (WARN_ON(!list_empty(&pool->worklist)))
> +		return;
> +
> +	/* release id and unhash */
> +	spin_lock_irq(&workqueue_lock);
> +	if (pool->id >= 0)
> +		idr_remove(&worker_pool_idr, pool->id);
> +	hash_del(&pool->hash_node);
> +	spin_unlock_irq(&workqueue_lock);
> +
> +	/* lock out manager and destroy all workers */
> +	mutex_lock(&pool->manager_mutex);
> +	spin_lock_irq(&pool->lock);
> +
> +	while ((worker = first_worker(pool)))
> +		destroy_worker(worker);
> +	WARN_ON(pool->nr_workers || pool->nr_idle);
> +
> +	spin_unlock_irq(&pool->lock);
> +	mutex_unlock(&pool->manager_mutex);
> +
> +	/* shut down the timers */
> +	del_timer_sync(&pool->idle_timer);
> +	del_timer_sync(&pool->mayday_timer);
> +
> +	/* sched-RCU protected to allow dereferences from get_work_pool() */
> +	call_rcu_sched(&pool->rcu, rcu_free_pool);
> +}
> +
> +/**
> + * get_unbound_pool - get a worker_pool with the specified attributes
> + * @attrs: the attributes of the worker_pool to get
> + *
> + * Obtain a worker_pool which has the same attributes as @attrs, bump the
> + * reference count and return it.  If there already is a matching
> + * worker_pool, it will be used; otherwise, this function attempts to
> + * create a new one.  On failure, returns NULL.
> + */
> +static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
> +{
> +	static DEFINE_MUTEX(create_mutex);
> +	u32 hash = wqattrs_hash(attrs);
> +	struct worker_pool *pool;
> +	struct hlist_node *tmp;
> +	struct worker *worker;
> +
> +	mutex_lock(&create_mutex);
> +
> +	/* do we already have a matching pool? */
> +	spin_lock_irq(&workqueue_lock);
> +	hash_for_each_possible(unbound_pool_hash, pool, tmp, hash_node, hash) {
> +		if (wqattrs_equal(pool->attrs, attrs)) {
> +			atomic_inc(&pool->refcnt);
> +			goto out_unlock;
> +		}
> +	}
> +	spin_unlock_irq(&workqueue_lock);
> +
> +	/* nope, create a new one */
> +	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
> +	if (!pool || init_worker_pool(pool) < 0)
> +		goto fail;
> +
> +	copy_workqueue_attrs(pool->attrs, attrs);
> +
> +	if (worker_pool_assign_id(pool) < 0)
> +		goto fail;
> +
> +	/* create and start the initial worker */
> +	worker = create_worker(pool);
> +	if (!worker)
> +		goto fail;
> +
> +	spin_lock_irq(&pool->lock);
> +	start_worker(worker);
> +	spin_unlock_irq(&pool->lock);
> +
> +	/* install */
> +	spin_lock_irq(&workqueue_lock);
> +	hash_add(unbound_pool_hash, &pool->hash_node, hash);
> +out_unlock:
> +	spin_unlock_irq(&workqueue_lock);
> +	mutex_unlock(&create_mutex);
> +	return pool;
> +fail:
> +	mutex_unlock(&create_mutex);
> +	if (pool)
> +		put_unbound_pool(pool);
> +	return NULL;
> +}
> +
>  static int alloc_and_link_pwqs(struct workqueue_struct *wq)
>  {
>  	bool highpri = wq->flags & WQ_HIGHPRI;
> @@ -3215,7 +3401,12 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
>  		if (!pwq)
>  			return -ENOMEM;
>  
> -		pwq->pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
> +		pwq->pool = get_unbound_pool(unbound_std_wq_attrs[highpri]);
> +		if (!pwq->pool) {
> +			kmem_cache_free(pwq_cache, pwq);
> +			return -ENOMEM;
> +		}
> +
>  		list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
>  	}
>  
> @@ -3393,6 +3584,15 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  		kfree(wq->rescuer);
>  	}
>  
> +	/*
> +	 * We're the sole accessor of @wq at this point.  Directly access
> +	 * the first pwq and put its pool.
> +	 */
> +	if (wq->flags & WQ_UNBOUND) {
> +		pwq = list_first_entry(&wq->pwqs, struct pool_workqueue,
> +				       pwqs_node);
> +		put_unbound_pool(pwq->pool);
> +	}
>  	free_pwqs(wq);
>  	kfree(wq);
>  }
> @@ -3856,19 +4056,14 @@ static int __init init_workqueues(void)
>  	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
>  
>  	/* initialize CPU pools */
> -	for_each_wq_cpu(cpu) {
> +	for_each_possible_cpu(cpu) {
>  		struct worker_pool *pool;
>  
>  		i = 0;
>  		for_each_std_worker_pool(pool, cpu) {
>  			BUG_ON(init_worker_pool(pool));
>  			pool->cpu = cpu;
> -
> -			if (cpu != WORK_CPU_UNBOUND)
> -				cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
> -			else
> -				cpumask_setall(pool->attrs->cpumask);
> -
> +			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
>  			pool->attrs->nice = std_nice[i++];
>  
>  			/* alloc pool ID */
> @@ -3877,14 +4072,13 @@ static int __init init_workqueues(void)
>  	}
>  
>  	/* create the initial worker */
> -	for_each_online_wq_cpu(cpu) {
> +	for_each_online_cpu(cpu) {
>  		struct worker_pool *pool;
>  
>  		for_each_std_worker_pool(pool, cpu) {
>  			struct worker *worker;
>  
> -			if (cpu != WORK_CPU_UNBOUND)
> -				pool->flags &= ~POOL_DISASSOCIATED;
> +			pool->flags &= ~POOL_DISASSOCIATED;
>  
>  			worker = create_worker(pool);
>  			BUG_ON(!worker);
> @@ -3894,6 +4088,18 @@ static int __init init_workqueues(void)
>  		}
>  	}
>  
> +	/* create default unbound wq attrs */
> +	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
> +		struct workqueue_attrs *attrs;
> +
> +		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
> +
> +		attrs->nice = std_nice[i];
> +		cpumask_setall(attrs->cpumask);
> +
> +		unbound_std_wq_attrs[i] = attrs;
> +	}
> +
>  	system_wq = alloc_workqueue("events", 0, 0);
>  	system_highpri_wq = alloc_workqueue("events_highpri", WQ_HIGHPRI, 0);
>  	system_long_wq = alloc_workqueue("events_long", 0, 0);

