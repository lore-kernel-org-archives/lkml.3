Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbaELVU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:20:28 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52351 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaELVU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:20:27 -0400
Date: Mon, 12 May 2014 17:20:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10 V2] workqueue: async worker destruction
Message-ID: <20140512212022.GC18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:15PM +0800, Lai Jiangshan wrote:
>  /**
> + * worker_detach_from_pool() - detach the worker from the pool
> + * @worker: worker which is attached to its pool
> + * @pool: attached pool
> + *
> + * Undo the attaching which had been done in create_worker().
> + * The caller worker shouldn't access to the pool after detached
> + * except it has other reference to the pool.
> + */
> +static void worker_detach_from_pool(struct worker *worker,
> +				    struct worker_pool *pool)
> +{
> +	struct completion *detach_completion = NULL;
> +
> +	mutex_lock(&pool->manager_mutex);
> +	idr_remove(&pool->worker_idr, worker->id);
> +	if (idr_is_empty(&pool->worker_idr))
> +		detach_completion = pool->detach_completion;
> +	mutex_unlock(&pool->manager_mutex);
> +
> +	if (detach_completion)
> +		complete(detach_completion);
> +}

Are we gonna use this function from somewhere else too?

> @@ -2289,6 +2298,10 @@ woke_up:
>  		spin_unlock_irq(&pool->lock);
>  		WARN_ON_ONCE(!list_empty(&worker->entry));
>  		worker->task->flags &= ~PF_WQ_WORKER;
> +
> +		set_task_comm(worker->task, "kworker_dying");

Given how other kworkers are named, maybe a better name is
"kworker/dying" or "kworker/detached"?

> +		worker_detach_from_pool(worker, pool);
> +		kfree(worker);
>  		return 0;
>  	}
>  
> @@ -3561,6 +3574,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
>  static void put_unbound_pool(struct worker_pool *pool)
>  {
>  	struct worker *worker;
> +	DECLARE_COMPLETION_ONSTACK(detach_completion);

I think it's conventional to put initialized ones (especially the ones
require initializing macros) before uninitialized vars.

> @@ -3579,19 +3593,24 @@ static void put_unbound_pool(struct worker_pool *pool)
>  
>  	/*
>  	 * Become the manager and destroy all workers.  Grabbing
> -	 * manager_arb prevents @pool's workers from blocking on
> -	 * manager_mutex.
> +	 * manager_arb ensures manage_workers() finish and enter idle.

I don't follow what the above comment update is trying to say.

Thanks.

-- 
tejun
