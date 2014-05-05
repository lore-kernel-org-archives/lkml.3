Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaEENNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:13:19 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:62708 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaEENNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:13:18 -0400
Date: Mon, 5 May 2014 09:13:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] workqueue: destroy_worker() should destroy idle
 workers only
Message-ID: <20140505131315.GB11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Apr 27, 2014 at 12:08:57PM +0800, Lai Jiangshan wrote:
> @@ -1692,9 +1691,8 @@ static struct worker *alloc_worker(void)
>   * create_worker - create a new workqueue worker
>   * @pool: pool the new worker will belong to
>   *
> - * Create a new worker which is bound to @pool.  The returned worker
> - * can be started by calling start_worker() or destroyed using
> - * destroy_worker().
> + * Create a new worker which is bound to @pool.
> + * The new worker should be started and enter idle by start_worker().

Hmm... we used to have a path where a worker is created and then
destroyed without being started.  IIRC, it was on the CPU online
failure path.  A worker was created for the CPU coming online and if
the online operation failed the created worker was shut down without
being started.  Right, we no longer shutdown per-cpu pools on offline
so this doesn't matter anymore.  Might worthwhile to note in the patch
description tho.

> @@ -1815,6 +1812,7 @@ static int create_and_start_worker(struct worker_pool *pool)
>   * @worker: worker to be destroyed
>   *
>   * Destroy @worker and adjust @pool stats accordingly.
> + * The worker should be idle(WORKER_IDLE).

Just write "The worker should be idle."  Also, in general, can you
please put a space before opening parenthesis?

>   *
>   * CONTEXT:
>   * spin_lock_irq(pool->lock) which is released and regrabbed.
> @@ -1828,13 +1826,13 @@ static void destroy_worker(struct worker *worker)
>  
>  	/* sanity check frenzy */
>  	if (WARN_ON(worker->current_work) ||
> -	    WARN_ON(!list_empty(&worker->scheduled)))
> +	    WARN_ON(!list_empty(&worker->scheduled)) ||
> +	    WARN_ON(!(worker->flags & WORKER_IDLE)) ||
> +	    WARN_ON(pool->nr_workers == 1 && !list_empty(&pool->worklist)))

I'm not sure about the pool condition check.  It's kinda overreaching
to check for it from worker destruction.

> @@ -3589,6 +3587,7 @@ static void put_unbound_pool(struct worker_pool *pool)
>  	mutex_lock(&pool->manager_mutex);
>  	spin_lock_irq(&pool->lock);
>  
> +	WARN_ON(pool->nr_workers != pool->nr_idle);

Does this condition detect anything new from the condition below?

>  	while ((worker = first_worker(pool)))
>  		destroy_worker(worker);
>  	WARN_ON(pool->nr_workers || pool->nr_idle);

Thanks.

-- 
tejun
