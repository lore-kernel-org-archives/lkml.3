Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaBRW3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:29:13 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:62308 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaBRW3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:29:11 -0500
Date: Tue, 18 Feb 2014 17:29:07 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: async worker destruction
Message-ID: <20140218222907.GD31892@mtj.dyndns.org>
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392654243-2829-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Feb 18, 2014 at 12:24:02AM +0800, Lai Jiangshan wrote:
> @@ -2295,9 +2285,16 @@ woke_up:
>  	if (unlikely(worker->flags & WORKER_DIE)) {
>  		spin_unlock_irq(&pool->lock);
>  		WARN_ON_ONCE(!list_empty(&worker->entry));
> +
> +		/* perform worker self-destruction */
> +		mutex_lock(&pool->manager_mutex);
> +		spin_lock_irq(&pool->lock);
> +		idr_remove(&pool->worker_idr, worker->id);
>  		worker->task->flags &= ~PF_WQ_WORKER;
>  		/* No one can access to @worker now, free it. */
>  		kfree(worker);
> +		spin_unlock_irq(&pool->lock);
> +		mutex_unlock(&pool->manager_mutex);

Hmm... is manager_mutex necessary for synchronization with
put_unbound_pool() path?

> @@ -3576,13 +3574,36 @@ static void put_unbound_pool(struct worker_pool *pool)
>  	 */
>  	mutex_lock(&pool->manager_arb);
>  	mutex_lock(&pool->manager_mutex);
> -	spin_lock_irq(&pool->lock);
>  
> +	spin_lock_irq(&pool->lock);
>  	while ((worker = first_worker(pool)))
>  		destroy_worker(worker);
>  	WARN_ON(pool->nr_workers || pool->nr_idle);
> -
>  	spin_unlock_irq(&pool->lock);
> +
> +	/* sync all workers dead */
> +	for_each_pool_worker(worker, wi, pool) {
> +		/*
> +		 * Although @worker->task was kicked to die, but we hold
> +		 * ->manager_mutex, it can't die, so we get its reference
> +		 * before drop ->manager_mutex. And we do sync until it die.
> +		 */
> +		get_task_struct(worker->task);
> +
> +		/*
> +		 * First, for_each_pool_worker() travels based on ID(@wi),
> +		 *   so it is safe even both ->manager_mutex and ->lock
> +		 *   are dropped inside the loop.
> +		 * Second, no worker can be added now, so the loop
> +		 *   ensures to travel all undead workers and sync them dead.
> +		 */
> +		mutex_unlock(&pool->manager_mutex);
> +
> +		kthread_stop(worker->task);
> +		put_task_struct(worker->task);
> +		mutex_lock(&pool->manager_mutex);
> +	}

I can't say I'm a fan of the above.  It's icky.  Why can't we do
simple set WORKER_DIE & wakeup thing here?

Thanks.

-- 
tejun
