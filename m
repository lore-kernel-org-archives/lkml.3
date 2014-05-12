Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbaELVgC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:36:02 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35000 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaELVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:35:57 -0400
Date: Mon, 12 May 2014 17:35:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/10 V2] workqueue: separate iteration role from
 worker_idr
Message-ID: <20140512213553.GE18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:17PM +0800, Lai Jiangshan wrote:
> worker_idr has the iteration(iterating for attached workers) and worker ID
                              ^
Please put a space before an opening parenthses.  It becomes a lot
easier on the eyes.

> duties. These two duties are not necessary tied together. We can separate
                                   necessarily

> them and use a list for tracking attached workers and iteration
> 
> After separation, we can add the rescuer workers to the list for iteration
> in future. worker_idr can't add rescuer workers due to rescuer workers
> can't allocate id from worker_idr.

Explaining how that'd be beneficial and justifies this change would be
nice.

...
>  /**
> - * for_each_pool_worker - iterate through all workers of a worker_pool
> - * @worker: iteration cursor
> - * @wi: integer used for iteration
> - * @pool: worker_pool to iterate workers of
> - *
> - * This must be called with @pool->manager_mutex.
> - *
> - * The if/else clause exists only for the lockdep assertion and can be
> - * ignored.
> - */
> -#define for_each_pool_worker(worker, wi, pool)				\
> -	idr_for_each_entry(&(pool)->worker_idr, (worker), (wi))		\
> -		if (({ lockdep_assert_held(&pool->manager_mutex); false; })) { } \
> -		else

Hmmm.... don't we still want the lockdep protection?

> @@ -1772,6 +1759,8 @@ static struct worker *create_worker(struct worker_pool *pool)
>  
>  	/* successful, commit the pointer to idr */

	/* successful, commit it to idr and link on the workers list */

>  	idr_replace(&pool->worker_idr, worker, worker->id);
> +	/* successful, attach the worker to the pool */

and lose the above line.

> diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
> index 7e2204d..c44abc3 100644
> --- a/kernel/workqueue_internal.h
> +++ b/kernel/workqueue_internal.h
> @@ -37,6 +37,7 @@ struct worker {
>  	struct task_struct	*task;		/* I: worker task */
>  	struct worker_pool	*pool;		/* I: the associated pool */
>  						/* L: for rescuers */
> +	struct list_head	node;		/* M: attached to the pool */

						/* M: anchored at pool->workers */

Thanks.

-- 
tejun
