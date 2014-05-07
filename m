Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaEGNND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:13:03 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47993 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaEGNNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:13:00 -0400
Date: Wed, 7 May 2014 09:12:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
Message-ID: <20140507131257.GB16702@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
 <20140505143613.GD11231@htj.dyndns.org>
 <5369DC5C.20001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369DC5C.20001@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, May 07, 2014 at 03:10:20PM +0800, Lai Jiangshan wrote:
> 1) complete() can't be called inside attach_mutex due to the worker
>    shouldn't access to the pool after complete().

Sure, complete it after releasing the lock.  Shutdown can't complete
before the completion gets completed, right?

> 2) put_unbound_pool() may called from get_unbound_pool(), we need to add
>    an additional check and avoid the wait_for_completion() if so.
> 
> +static void worker_detach_from_pool(struct worker *worker, struct worker_pool *pool)
> +{
> +	bool is_last;
> +
> +	mutex_lock(&pool->bind_mutex);
> +	list_del(&worker->bind_entry);
> +	is_last = list_empty(&worker->bind_entry);
> +	mutex_unlock(&pool->bind_mutex);
> +
> +	/* need some comments here */
> +	if (is_last)
> +		complete(&pool->workers_detached);
> +}
> 
> 
> @@ -3588,6 +3587,7 @@ static void put_unbound_pool(struct worker_pool *pool)
>  	mutex_lock(&pool->manager_mutex);
>  	spin_lock_irq(&pool->lock);
>  	
> +	need_to_wait = pool->nr_workers != 0; /* it may be called from get_unbound_pool() */
>  	while ((worker = first_worker(pool)))
>  		destroy_worker(worker);
>  	WARN_ON(pool->nr_workers || pool->nr_idle);
> @@ -3596,6 +3596,8 @@ static void put_unbound_pool(struct worker_pool *pool)
>  	mutex_unlock(&pool->manager_mutex);
>  	mutex_unlock(&pool->manager_arb);
>  
> +	if (need_to_wait)
> +		wait_for_completion(&pool->workers_detached);

Shouldn't it be able to wait whenever it's about to destroy non-empty
pool?

	DECLARE_COMPLETION_ONSTACK(completion);

	...

	while ((worker = first_worker(pool))) {
		destroy_worker(worker);
		pool->detach_completion = &completion;
	}

	...
	unlock;

	if (pool->detach_completion)
		wait_for_completion();
	...

And the worker side can simply do,

	struct completion *completion;

	if (I'm the last worker exiting)
		completion = pool->detach_completion;
	unlock;

	complete(completion);

Thanks.

-- 
tejun
