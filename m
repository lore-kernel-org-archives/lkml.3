Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaEENBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:01:48 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:45878 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaEENBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:01:46 -0400
Date: Mon, 5 May 2014 09:01:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] workqueue: use manager lock only to protect
 worker_idr
Message-ID: <20140505130130.GA11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:08:56PM +0800, Lai Jiangshan wrote:
> worker_idr is highly bound to managers and is always/only accessed in manager
> lock context. So we don't need pool->lock for it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
...
> @@ -378,14 +367,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
>   * @wi: integer used for iteration
>   * @pool: worker_pool to iterate workers of
>   *
> - * This must be called with either @pool->manager_mutex or ->lock held.
> + * This must be called with either @pool->manager_mutex.

Please drop "either" from the sentence.

> @@ -1725,13 +1714,7 @@ static struct worker *create_worker(struct worker_pool *pool)
>  	 * ID is needed to determine kthread name.  Allocate ID first
>  	 * without installing the pointer.
>  	 */
> -	idr_preload(GFP_KERNEL);
> -	spin_lock_irq(&pool->lock);
> -
> -	id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_NOWAIT);
> -
> -	spin_unlock_irq(&pool->lock);
> -	idr_preload_end();
> +	id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_KERNEL);
>  	if (id < 0)
>  		goto fail;
>  
> @@ -1773,18 +1756,13 @@ static struct worker *create_worker(struct worker_pool *pool)
>  		worker->flags |= WORKER_UNBOUND;
>  
>  	/* successful, commit the pointer to idr */
> -	spin_lock_irq(&pool->lock);
>  	idr_replace(&pool->worker_idr, worker, worker->id);
> -	spin_unlock_irq(&pool->lock);

W/ locking updated, we can simply assign the pointer on idr_alloc()
instead of doing split alloc/replace.

I'm a bit on the fence about this patch.  It does simplify the code a
bit but then we lose the ability to iterate workers without grabbing
the manager_mutex, which would come handy when, for example,
implementing better workqueue info reporting during oops which we'll
prolly need to add sooner or later.

Thanks.

-- 
tejun
