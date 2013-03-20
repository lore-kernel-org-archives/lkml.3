Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3CTPwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:52:07 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:65194 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3CTPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:52:04 -0400
MIME-Version: 1.0
In-Reply-To: <1363737629-16745-9-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<1363737629-16745-9-git-send-email-tj@kernel.org>
Date: Wed, 20 Mar 2013 23:52:03 +0800
Message-ID: <CACvQF52vBmDi7nbg2O+CEo7M=n+RZSdEK45vyuCgv=o6R36KeA@mail.gmail.com>
Subject: Re: [PATCH 08/10] workqueue: break init_and_link_pwq() into two
 functions and introduce alloc_unbound_pwq()
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 8:00 AM, Tejun Heo <tj@kernel.org> wrote:
> Break init_and_link_pwq() into init_pwq() and link_pwq() and move
> unbound-workqueue specific handling into apply_workqueue_attrs().
> Also, factor out unbound pool and pool_workqueue allocation into
> alloc_unbound_pwq().
>
> This reorganization is to prepare for NUMA affinity and doesn't
> introduce any functional changes.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 75 +++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 52 insertions(+), 23 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 3f820a5..bbbfc92 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3647,13 +3647,10 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
>         spin_unlock(&pwq->pool->lock);
>  }
>
> -static void init_and_link_pwq(struct pool_workqueue *pwq,
> -                             struct workqueue_struct *wq,
> -                             struct worker_pool *pool,
> -                             struct pool_workqueue **p_last_pwq)
> +/* initialize newly zalloced @pwq which is associated with @wq and @pool */
> +static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
> +                    struct worker_pool *pool)
>  {
> -       int node;
> -
>         BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
>
>         pwq->pool = pool;
> @@ -3663,9 +3660,16 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
>         INIT_LIST_HEAD(&pwq->delayed_works);
>         INIT_LIST_HEAD(&pwq->mayday_node);
>         INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
> +}
>
> -       mutex_lock(&wq->flush_mutex);
> -       spin_lock_irq(&pwq_lock);
> +/* sync @pwq with the current state of its associated wq and link it */
> +static void link_pwq(struct pool_workqueue *pwq,
> +                    struct pool_workqueue **p_last_pwq)
> +{
> +       struct workqueue_struct *wq = pwq->wq;
> +
> +       lockdep_assert_held(&wq->flush_mutex);
> +       lockdep_assert_held(&pwq_lock);
>
>         /*
>          * Set the matching work_color.  This is synchronized with
> @@ -3680,15 +3684,27 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
>
>         /* link in @pwq */
>         list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
> +}
>
> -       if (wq->flags & WQ_UNBOUND) {
> -               copy_workqueue_attrs(wq->unbound_attrs, pool->attrs);
> -               for_each_node(node)
> -                       rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
> +/* obtain a pool matching @attr and create a pwq associating the pool and @wq */
> +static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
> +                                       const struct workqueue_attrs *attrs)
> +{
> +       struct worker_pool *pool;
> +       struct pool_workqueue *pwq;
> +
> +       pool = get_unbound_pool(attrs);
> +       if (!pool)
> +               return NULL;
> +
> +       pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);

this allocation is not numa-awared, you may use pool->node here.

> +       if (!pwq) {
> +               put_unbound_pool(pool);
> +               return NULL;
>         }
>
> -       spin_unlock_irq(&pwq_lock);
> -       mutex_unlock(&wq->flush_mutex);
> +       init_pwq(pwq, wq, pool);
> +       return pwq;
>  }
>
>  /**
> @@ -3709,7 +3725,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
>                           const struct workqueue_attrs *attrs)
>  {
>         struct pool_workqueue *pwq, *last_pwq;
> -       struct worker_pool *pool;
> +       int node;
>
>         /* only unbound workqueues can change attributes */
>         if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
> @@ -3719,17 +3735,22 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
>         if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
>                 return -EINVAL;
>
> -       pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
> +       pwq = alloc_unbound_pwq(wq, attrs);
>         if (!pwq)
>                 return -ENOMEM;
>
> -       pool = get_unbound_pool(attrs);
> -       if (!pool) {
> -               kmem_cache_free(pwq_cache, pwq);
> -               return -ENOMEM;
> -       }
> +       mutex_lock(&wq->flush_mutex);
> +       spin_lock_irq(&pwq_lock);
> +
> +       link_pwq(pwq, &last_pwq);
> +
> +       copy_workqueue_attrs(wq->unbound_attrs, pwq->pool->attrs);
> +       for_each_node(node)
> +               rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
> +
> +       spin_unlock_irq(&pwq_lock);
> +       mutex_unlock(&wq->flush_mutex);
>
> -       init_and_link_pwq(pwq, wq, pool, &last_pwq);
>         if (last_pwq) {
>                 spin_lock_irq(&last_pwq->pool->lock);
>                 put_pwq(last_pwq);
> @@ -3755,7 +3776,15 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
>                         struct worker_pool *cpu_pools =
>                                 per_cpu(cpu_worker_pools, cpu);
>
> -                       init_and_link_pwq(pwq, wq, &cpu_pools[highpri], NULL);
> +                       init_pwq(pwq, wq, &cpu_pools[highpri]);
> +
> +                       mutex_lock(&wq->flush_mutex);
> +                       spin_lock_irq(&pwq_lock);
> +
> +                       link_pwq(pwq, NULL);
> +
> +                       spin_unlock_irq(&pwq_lock);
> +                       mutex_unlock(&wq->flush_mutex);
>                 }
>                 return 0;
>         } else {
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
