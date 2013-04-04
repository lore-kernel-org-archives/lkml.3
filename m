Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598Ab3DDOPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:15:31 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41810 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761471Ab3DDOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:15:28 -0400
Date: Thu, 4 Apr 2013 07:15:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] workqueue: rename rebind_workers() to
 associate_cpu_pool()
Message-ID: <20130404141523.GE9425@htj.dyndns.org>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
 <1365041143-3088-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365041143-3088-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:05:34AM +0800, Lai Jiangshan wrote:
> merge the code of clearing POOL_DISASSOCIATED to rebind_workers(), and
> rename rebind_workers() to associate_cpu_pool().
> 
> It merges high related code together and simplify
> workqueue_cpu_up_callback().
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   21 ++++++++++-----------
>  1 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 66a9d71..b4369de 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2270,7 +2270,7 @@ recheck:
>  	 * worker or that someone else has already assumed the manager
>  	 * role.  This is where @worker starts participating in concurrency
>  	 * management if applicable and concurrency management is restored
> -	 * after being rebound.  See rebind_workers() for details.
> +	 * after being rebound.  See associate_cpu_pool() for details.
>  	 */
>  	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
>  
> @@ -4431,12 +4431,13 @@ static void wq_unbind_fn(struct work_struct *work)
>  }
>  
>  /**
> - * rebind_workers - rebind all workers of a pool to the associated CPU
> + * associate_cpu_pool - rebind all workers of a pool to the associated CPU
>   * @pool: pool of interest
>   *
> - * @pool->cpu is coming online.  Rebind all workers to the CPU.
> + * @pool->cpu is coming online.  Rebind all workers to the CPU and
> + * set the pool associated
>   */
> -static void rebind_workers(struct worker_pool *pool)
> +static void associate_cpu_pool(struct worker_pool *pool)
>  {
>  	struct worker *worker;
>  	int wi;
> @@ -4451,8 +4452,9 @@ static void rebind_workers(struct worker_pool *pool)
>  	 * from CPU_ONLINE, the following shouldn't fail.
>  	 */
>  	for_each_pool_worker(worker, wi, pool)
> -		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
> -						  pool->attrs->cpumask) < 0);
> +		if (WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
> +				pool->attrs->cpumask) < 0))
> +			return;
>  
>  	spin_lock_irq(&pool->lock);
>  
> @@ -4491,6 +4493,7 @@ static void rebind_workers(struct worker_pool *pool)
>  		ACCESS_ONCE(worker->flags) = worker_flags;
>  	}
>  
> +	pool->flags &= ~POOL_DISASSOCIATED;

So, now we're clearing DISASSOCIATED after rebinding workers instead
of before.  Is that safe?  Even if so, why no mention of that in the
patch description?  Changes like this are functional changes which can
cause subtle issues and *should* be explained and justified in the
patch description.  Please put more effort in explaining what's going
on.

Thanks.

-- 
tejun
