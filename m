Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3CDTUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:20:35 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:43196 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3CDTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:20:34 -0500
Date: Mon, 4 Mar 2013 11:20:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix possible bug which may silence the pool
Message-ID: <20130304192028.GM30413@htj.dyndns.org>
References: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sat, Mar 02, 2013 at 11:55:29PM +0800, Lai Jiangshan wrote:
> After we introduce multiple pools for cpu pools, a part of the comments
> in wq_unbind_fn() becomes wrong.
> 
> It said that "current worker would trigger unbound chain execution".
> It is wrong. current worker only belongs to one of the multiple pools.
> 
> If wq_unbind_fn() does unbind the normal_pri pool(not the pool of the current
> worker), the current worker is not the available worker to trigger unbound
> chain execution of the normal_pri pool, and if all the workers of
> the normal_pri goto sleep after they were set %WORKER_UNBOUND but before
> they finish their current work, unbound chain execution is not triggered
> totally. The pool is stopped!
> 
> We can change wq_unbind_fn() only does unbind one pool and we launch multiple
> wq_unbind_fn()s, one for each pool to solve the problem.
> But this change will add much latency to hotplug path unnecessarily.
> 
> So we choice to wake up a worker directly to trigger unbound chain execution.
> 
> current worker may sleep on &second_pool->assoc_mutex, so we also move
> the wakeup code into the loop to avoid second_pool silences the first_pool.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Nice catch.

> @@ -3446,28 +3446,35 @@ static void wq_unbind_fn(struct work_struct *work)
>  
>  		spin_unlock_irq(&pool->lock);
>  		mutex_unlock(&pool->assoc_mutex);
> -	}
>  
> -	/*
> -	 * Call schedule() so that we cross rq->lock and thus can guarantee
> -	 * sched callbacks see the %WORKER_UNBOUND flag.  This is necessary
> -	 * as scheduler callbacks may be invoked from other cpus.
> -	 */
> -	schedule();
> +		/*
> +		 * Call schedule() so that we cross rq->lock and thus can
> +		 * guarantee sched callbacks see the %WORKER_UNBOUND flag.
> +		 * This is necessary as scheduler callbacks may be invoked
> +		 * from other cpus.
> +		 */
> +		schedule();
>  
> -	/*
> -	 * Sched callbacks are disabled now.  Zap nr_running.  After this,
> -	 * nr_running stays zero and need_more_worker() and keep_working()
> -	 * are always true as long as the worklist is not empty.  Pools on
> -	 * @cpu now behave as unbound (in terms of concurrency management)
> -	 * pools which are served by workers tied to the CPU.
> -	 *
> -	 * On return from this function, the current worker would trigger
> -	 * unbound chain execution of pending work items if other workers
> -	 * didn't already.
> -	 */
> -	for_each_std_worker_pool(pool, cpu)
> +		/*
> +		 * Sched callbacks are disabled now.  Zap nr_running.
> +		 * After this, nr_running stays zero and need_more_worker()
> +		 * and keep_working() are always true as long as the worklist
> +		 * is not empty.  This pool now behave as unbound (in terms of
> +		 * concurrency management) pool which are served by workers
> +		 * tied to the pool.
> +		 */
>  		atomic_set(&pool->nr_running, 0);
> +
> +		/* The current busy workers of this pool may goto sleep without
> +		 * wake up any other worker after they were set %WORKER_UNBOUND
> +		 * flag. Here we wake up another possible worker to start
> +		 * the unbound chain execution of pending work items in this
> +		 * case.
> +		 */
> +		spin_lock_irq(&pool->lock);
> +		wake_up_worker(pool);
> +		spin_unlock_irq(&pool->lock);
> +	}

But can we please just addd wake_up_worker() in the
for_each_std_worker_pool() loop?  We want to mark the patch for
-stable and keep it short and to the point.  This patch is a couple
times larger than necessary.

Thanks.

-- 
tejun
