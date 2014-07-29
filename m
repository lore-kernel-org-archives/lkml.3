Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaG2PFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:05:06 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:53727 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaG2PFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:05:04 -0400
Date: Tue, 29 Jul 2014 11:04:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2 V2] workqueue: use dedicated creater kthread for
 all pools
Message-ID: <20140729150459.GE4791@htj.dyndns.org>
References: <20140729021643.GA22241@mtj.dyndns.org>
 <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 29, 2014 at 05:16:07PM +0800, Lai Jiangshan wrote:

First of all, the patch is too big.  This is a rather pervasive
change.  Please split it up if at all possible.

> +/* Start the mayday timer and the creater when needed */
> +static inline void start_creater_work(struct worker_pool *pool)
> +{
> +	if (pool->nr_idle || pool->creating || list_empty(&pool->worklist))
> +		return;

pool->creating is an optimization around queue_kthread_work(), right?
So that you don't have to grab the lock every time a work item is
queued.  Please explain things like that explicitly.  Also, the
condition itself needs explanation.  This is what guarantees that the
queue is not stalled after all.

Hmmm... list_empty() is unnecessary when called from the queueing
path.  Do we want to move that out of this function?

>  	/* we own @work, set data and link */
>  	set_work_pwq(work, pwq, extra_flags);
>  	list_add_tail(&work->entry, head);
> +	start_creater_work(pool);

creator is spelled with an 'o' not 'e'.  Also, it'd be better if the
name reflects that this is a kthread_work not a workqueue one.

> +static void create_worker(struct kthread_work *work)
>  {
...
>  fail:
>  	if (id >= 0)
>  		ida_simple_remove(&pool->worker_ida, id);
>  	kfree(worker);
> -	return NULL;
> +
> +	/* cool down before next create_worker() */
> +	schedule_timeout_interruptible(CREATE_COOLDOWN);
> +	del_timer_sync(&pool->mayday_timer);
> +
> +	spin_lock_irq(&pool->lock);
> +	pool->creating = false;
> +	start_creater_work(pool);
> +	spin_unlock_irq(&pool->lock);

Why?  Just sleep and retry?  What's the point of requeueing?

> -/**
>   * process_one_work - process single work
>   * @worker: self
>   * @work: work to process
> @@ -1991,6 +1905,7 @@ __acquires(&pool->lock)
>  	work_color = get_work_color(work);
>  
>  	list_del_init(&work->entry);
> +	start_creater_work(pool);

Should this be combined with wake_up_worker()?

Thanks.

-- 
tejun
