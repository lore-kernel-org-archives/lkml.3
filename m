Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaKRF7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:59:06 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:59685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560AbaKRF7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:59:04 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43547752"
Message-ID: <546AE0BC.5020606@cn.fujitsu.com>
Date: Tue, 18 Nov 2014 14:01:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
References: <20141029172608.39119c80@notabene.brown>	<20141029143210.GA25226@htj.dyndns.org>	<20141030101932.2241daa7@notabene.brown>	<20141104142240.GD14459@htj.dyndns.org>	<20141106165811.GA2338@gmail.com>	<545C368C.5040704@cn.fujitsu.com>	<20141110162848.6f2246bb@notabene.brown>	<20141110085250.GB15948@quack.suse.cz>	<20141111090402.35fa0700@notabene.brown> <20141118152754.60b0c75e@notabene.brown>
In-Reply-To: <20141118152754.60b0c75e@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 12:27 PM, NeilBrown wrote:
> 
> When there is serious memory pressure, all workers in a pool could be
> blocked, and a new thread cannot be created because it requires memory
> allocation.
> 
> In this situation a WQ_MEM_RECLAIM workqueue will wake up the
> rescuer thread to do some work.
> 
> The rescuer will only handle requests that are already on ->worklist.
> If max_requests is 1, that means it will handle a single request.
> 
> The rescuer will be woken again in 100ms to handle another max_requests
> requests.
> 
> I've seen a machine (running a 3.0 based "enterprise" kernel) with
> thousands of requests queued for xfslogd, which has a max_requests of
> 1, and is needed for retiring all 'xfs' write requests.  When one of
> the worker pools gets into this state, it progresses extremely slowly
> and possibly never recovers (only waited an hour or two).
> 
> With this patch we leave a pool_workqueue on mayday list
> until it is clearly no longer in need of assistance.  This allows
> all requests to be handled in a timely fashion.
> 
> The code is a bit awkward due to the need to hold both wq_mayday_lock
> and pool->lock at the same time, and due to the lock ordering imposed
> on them.  In particular we move work items from the ->worklist to the
> rescuer list while holding both locks because we need pool->lock
> to do the move, and need wq_mayday_lock to manipulate the mayday list
> after we have found out if there was anything to do.
> 
> 'need_to_create_worker()' is called *before* moving work items off
> pool->worklist as an empty worklist will make it return false, but
> after the move_linked_works() calls and before the
> process_scheduled_works() call, an empty worklist does not indicate
> that there is no work to do.
> 
> We keep each pool_workqueue on the mayday list until
> need_to_create_worker() is false, and no work for this workqueue is
> found in the pool.
> 
> As the main rescuer loop now iterates an arbitrary number of time,
> cond_resched() was inserted to avoid imposing excessive latencies.
> 
> I have tested this in combination with a (hackish) patch which forces
> all work items to be handled by the rescuer thread.  In that context
> it significantly improves performance.  A similar patch for a 3.0
> kernel significantly improved performance on a heavy work load.
> 
> Thanks to Jan Kara for some design ideas, and to Dongsu Park for
> some comments and testing.
> 
> Cc: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index caedde34ee7f..4baa7b8b7e0f 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2253,26 +2253,36 @@ repeat:
>  					struct pool_workqueue, mayday_node);
>  		struct worker_pool *pool = pwq->pool;
>  		struct work_struct *work, *n;
> +		int still_needed;
>  
>  		__set_current_state(TASK_RUNNING);
> -		list_del_init(&pwq->mayday_node);
> -
> -		spin_unlock_irq(&wq_mayday_lock);
> -
> -		worker_attach_to_pool(rescuer, pool);
> -
> -		spin_lock_irq(&pool->lock);
> -		rescuer->pool = pool;
> -
> +		spin_lock(&pool->lock);
>  		/*
>  		 * Slurp in all works issued via this workqueue and
>  		 * process'em.
>  		 */
>  		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));

> +		still_needed = need_to_create_worker(pool);

This line of code will cause the rescuer busy-loop even no work-item pending
on the workqueue.

>  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
>  			if (get_work_pwq(work) == pwq)
>  				move_linked_works(work, scheduled, &n);
>  
> +		if (!list_empty(scheduled))
> +			still_needed = 1;
> +		if (still_needed) {
> +			list_move_tail(&pwq->mayday_node, &wq->maydays);
> +			get_pwq(pwq);
> +		} else
> +			/* We can let go of this one now */
> +			list_del_init(&pwq->mayday_node);
> +
> +		spin_unlock(&pool->lock);
> +		spin_unlock_irq(&wq_mayday_lock);
> +
> +		worker_attach_to_pool(rescuer, pool);
> +
> +		spin_lock_irq(&pool->lock);
> +		rescuer->pool = pool;
>  		process_scheduled_works(rescuer);
>  
>  		/*
> @@ -2293,7 +2303,7 @@ repeat:
>  		spin_unlock_irq(&pool->lock);
>  
>  		worker_detach_from_pool(rescuer, pool);
> -
> +		cond_resched();
>  		spin_lock_irq(&wq_mayday_lock);
>  	}
>  

