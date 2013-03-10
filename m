Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3CJKHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:07:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16633 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3CJKHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:07:16 -0400
X-IronPort-AV: E=Sophos;i="4.84,818,1355068800"; 
   d="scan'208";a="6844189"
Message-ID: <513C5BD8.9050909@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 18:09:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 12/31] workqueue: update synchronization rules on workqueue->pwqs
References: <1362194662-2344-1-git-send-email-tj@kernel.org> <1362194662-2344-13-git-send-email-tj@kernel.org>
In-Reply-To: <1362194662-2344-13-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:06:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:06:05,
	Serialize complete at 2013/03/10 18:06:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 11:24, Tejun Heo wrote:
> Make workqueue->pwqs protected by workqueue_lock for writes and
> sched-RCU protected for reads.  Lockdep assertions are added to
> for_each_pwq() and first_pwq() and all their users are converted to
> either hold workqueue_lock or disable preemption/irq.
> 
> alloc_and_link_pwqs() is updated to use list_add_tail_rcu() for
> consistency which isn't strictly necessary as the workqueue isn't
> visible.  destroy_workqueue() isn't updated to sched-RCU release pwqs.
> This is okay as the workqueue should have on users left by that point.
> 
> The locking is superflous at this point.  This is to help
> implementation of unbound pools/pwqs with custom attributes.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 85 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 68 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 02f51b8..ff51c59 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -42,6 +42,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/idr.h>
>  #include <linux/hashtable.h>
> +#include <linux/rculist.h>
>  
>  #include "workqueue_internal.h"
>  
> @@ -118,6 +119,8 @@ enum {
>   * F: wq->flush_mutex protected.
>   *
>   * W: workqueue_lock protected.
> + *
> + * R: workqueue_lock protected for writes.  Sched-RCU protected for reads.
>   */
>  
>  /* struct worker is defined in workqueue_internal.h */
> @@ -169,7 +172,7 @@ struct pool_workqueue {
>  	int			nr_active;	/* L: nr of active works */
>  	int			max_active;	/* L: max active works */
>  	struct list_head	delayed_works;	/* L: delayed works */
> -	struct list_head	pwqs_node;	/* I: node on wq->pwqs */
> +	struct list_head	pwqs_node;	/* R: node on wq->pwqs */
>  	struct list_head	mayday_node;	/* W: node on wq->maydays */
>  } __aligned(1 << WORK_STRUCT_FLAG_BITS);
>  
> @@ -189,7 +192,7 @@ struct wq_flusher {
>  struct workqueue_struct {
>  	unsigned int		flags;		/* W: WQ_* flags */
>  	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
> -	struct list_head	pwqs;		/* I: all pwqs of this wq */
> +	struct list_head	pwqs;		/* R: all pwqs of this wq */
>  	struct list_head	list;		/* W: list of all workqueues */
>  
>  	struct mutex		flush_mutex;	/* protects wq flushing */
> @@ -227,6 +230,11 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/workqueue.h>
>  
> +#define assert_rcu_or_wq_lock()						\
> +	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
> +			   lockdep_is_held(&workqueue_lock),		\
> +			   "sched RCU or workqueue lock should be held")
> +
>  #define for_each_std_worker_pool(pool, cpu)				\
>  	for ((pool) = &std_worker_pools(cpu)[0];			\
>  	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
> @@ -282,9 +290,16 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
>   * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
>   * @pwq: iteration cursor
>   * @wq: the target workqueue
> + *
> + * This must be called either with workqueue_lock held or sched RCU read
> + * locked.  If the pwq needs to be used beyond the locking in effect, the
> + * caller is responsible for guaranteeing that the pwq stays online.
> + *
> + * The if clause exists only for the lockdep assertion and can be ignored.
>   */
>  #define for_each_pwq(pwq, wq)						\
> -	list_for_each_entry((pwq), &(wq)->pwqs, pwqs_node)
> +	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
> +		if (({ assert_rcu_or_wq_lock(); true; }))

Aware this:

if (somecondition)
	for_each_pwq(pwq, wq)
		one_statement;q
else
	xxxxx;


for_each_pwq() will eat the else.

To avoid this, you can use:

#define for_each_pwq(pwq, wq)						\
	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
		if (({ assert_rcu_or_wq_lock(); false; })) { }		\
		else


The same for for_each_pool() in later patch.


>  
>  #ifdef CONFIG_DEBUG_OBJECTS_WORK
>  
> @@ -463,9 +478,19 @@ static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
>  	return &pools[highpri];
>  }
>  
> +/**
> + * first_pwq - return the first pool_workqueue of the specified workqueue
> + * @wq: the target workqueue
> + *
> + * This must be called either with workqueue_lock held or sched RCU read
> + * locked.  If the pwq needs to be used beyond the locking in effect, the
> + * caller is responsible for guaranteeing that the pwq stays online.
> + */
>  static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
>  {
> -	return list_first_entry(&wq->pwqs, struct pool_workqueue, pwqs_node);
> +	assert_rcu_or_wq_lock();
> +	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
> +				      pwqs_node);
>  }
>  
>  static unsigned int work_color_to_flags(int color)
> @@ -2488,10 +2513,12 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
>  		atomic_set(&wq->nr_pwqs_to_flush, 1);
>  	}
>  
> +	local_irq_disable();
> +
>  	for_each_pwq(pwq, wq) {
>  		struct worker_pool *pool = pwq->pool;
>  
> -		spin_lock_irq(&pool->lock);
> +		spin_lock(&pool->lock);
>  
>  		if (flush_color >= 0) {
>  			WARN_ON_ONCE(pwq->flush_color != -1);
> @@ -2508,9 +2535,11 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
>  			pwq->work_color = work_color;
>  		}
>  
> -		spin_unlock_irq(&pool->lock);
> +		spin_unlock(&pool->lock);
>  	}
>  
> +	local_irq_enable();
> +
>  	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_pwqs_to_flush))
>  		complete(&wq->first_flusher->done);
>  
> @@ -2701,12 +2730,14 @@ void drain_workqueue(struct workqueue_struct *wq)
>  reflush:
>  	flush_workqueue(wq);
>  
> +	local_irq_disable();
> +
>  	for_each_pwq(pwq, wq) {
>  		bool drained;
>  
> -		spin_lock_irq(&pwq->pool->lock);
> +		spin_lock(&pwq->pool->lock);
>  		drained = !pwq->nr_active && list_empty(&pwq->delayed_works);
> -		spin_unlock_irq(&pwq->pool->lock);
> +		spin_unlock(&pwq->pool->lock);
>  
>  		if (drained)
>  			continue;
> @@ -2715,13 +2746,17 @@ reflush:
>  		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
>  			pr_warn("workqueue %s: flush on destruction isn't complete after %u tries\n",
>  				wq->name, flush_cnt);
> +
> +		local_irq_enable();
>  		goto reflush;
>  	}
>  
> -	spin_lock_irq(&workqueue_lock);
> +	spin_lock(&workqueue_lock);
>  	if (!--wq->nr_drainers)
>  		wq->flags &= ~WQ_DRAINING;
> -	spin_unlock_irq(&workqueue_lock);
> +	spin_unlock(&workqueue_lock);
> +
> +	local_irq_enable();
>  }
>  EXPORT_SYMBOL_GPL(drain_workqueue);
>  
> @@ -3087,7 +3122,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
>  				per_cpu_ptr(wq->cpu_pwqs, cpu);
>  
>  			pwq->pool = get_std_worker_pool(cpu, highpri);
> -			list_add_tail(&pwq->pwqs_node, &wq->pwqs);
> +			list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
>  		}
>  	} else {
>  		struct pool_workqueue *pwq;
> @@ -3097,7 +3132,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
>  			return -ENOMEM;
>  
>  		pwq->pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
> -		list_add_tail(&pwq->pwqs_node, &wq->pwqs);
> +		list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
>  	}
>  
>  	return 0;
> @@ -3174,6 +3209,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>  	if (alloc_and_link_pwqs(wq) < 0)
>  		goto err;
>  
> +	local_irq_disable();
>  	for_each_pwq(pwq, wq) {
>  		BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
>  		pwq->wq = wq;
> @@ -3182,6 +3218,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>  		INIT_LIST_HEAD(&pwq->delayed_works);
>  		INIT_LIST_HEAD(&pwq->mayday_node);
>  	}
> +	local_irq_enable();
>  
>  	if (flags & WQ_RESCUER) {
>  		struct worker *rescuer;
> @@ -3239,24 +3276,32 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  	/* drain it before proceeding with destruction */
>  	drain_workqueue(wq);
>  
> +	spin_lock_irq(&workqueue_lock);
> +
>  	/* sanity checks */
>  	for_each_pwq(pwq, wq) {
>  		int i;
>  
> -		for (i = 0; i < WORK_NR_COLORS; i++)
> -			if (WARN_ON(pwq->nr_in_flight[i]))
> +		for (i = 0; i < WORK_NR_COLORS; i++) {
> +			if (WARN_ON(pwq->nr_in_flight[i])) {
> +				spin_unlock_irq(&workqueue_lock);
>  				return;
> +			}
> +		}
> +
>  		if (WARN_ON(pwq->nr_active) ||
> -		    WARN_ON(!list_empty(&pwq->delayed_works)))
> +		    WARN_ON(!list_empty(&pwq->delayed_works))) {
> +			spin_unlock_irq(&workqueue_lock);
>  			return;
> +		}
>  	}
>  
>  	/*
>  	 * wq list is used to freeze wq, remove from list after
>  	 * flushing is complete in case freeze races us.
>  	 */
> -	spin_lock_irq(&workqueue_lock);
>  	list_del(&wq->list);
> +
>  	spin_unlock_irq(&workqueue_lock);
>  
>  	if (wq->flags & WQ_RESCUER) {
> @@ -3340,13 +3385,19 @@ EXPORT_SYMBOL_GPL(workqueue_set_max_active);
>  bool workqueue_congested(int cpu, struct workqueue_struct *wq)
>  {
>  	struct pool_workqueue *pwq;
> +	bool ret;
> +
> +	preempt_disable();
>  
>  	if (!(wq->flags & WQ_UNBOUND))
>  		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
>  	else
>  		pwq = first_pwq(wq);
>  
> -	return !list_empty(&pwq->delayed_works);
> +	ret = !list_empty(&pwq->delayed_works);
> +	preempt_enable();
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(workqueue_congested);
>  

