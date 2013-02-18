Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3BRTu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:50:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49869 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3BRTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:50:28 -0500
Date: Mon, 18 Feb 2013 11:50:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 13/15] workqueue: also record worker in work->data if
 running&&queued
Message-ID: <20130218195023.GJ17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-14-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361203940-6300-14-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Feb 19, 2013 at 12:12:14AM +0800, Lai Jiangshan wrote:
> +/**
> + * get_work_cwq - get cwq of the work
> + * @work: the work item of interest
> + *
> + * CONTEXT:
> + * spin_lock_irq(&pool->lock), the work must be queued on this pool
> + */
> +static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
> +{
> +	unsigned long data = atomic_long_read(&work->data);
> +	struct worker *worker;
> +
> +	if (data & WORK_STRUCT_CWQ) {
> +		return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
> +	} else if (data & WORK_OFFQ_REQUEUED) {
> +		worker = worker_by_id(data >> WORK_OFFQ_WORKER_SHIFT);
> +		BUG_ON(!worker || !worker->requeue);
> +		return worker->current_cwq;
> +	} else {
> +		BUG();
> +		return NULL;
> +	}
> +}

So, work->data points to the last worker ID if off-queue or on-queue
with another worker executing it and points to cwq if on-queue w/o
another worker executing.  If on-queue w/ concurrent execution, the
excuting worker updates work->data when it finishes execution, right?

Why no documentation about it at all?  The mechanism is convoluted
with interlocking from both work and worker sides.  Lack of
documentation makes things difficult for reviewers and later readers
of the code.

> @@ -1296,8 +1283,16 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
>  		worklist = &cwq->delayed_works;
>  	}
>  
> -	color_flags = work_color_to_flags(cwq->work_color);
> -	insert_work(cwq, work, worklist, color_flags | delayed_flags);
> +	if (worker) {
> +		worker->requeue = true;
> +		worker->requeue_color = cwq->work_color;
> +		set_work_worker_and_keep_pending(work, worker->id,
> +				delayed_flags | WORK_OFFQ_REQUEUED);
> +		list_add_tail(&work->entry, worklist);
> +	} else {
> +		color_flags = work_color_to_flags(cwq->work_color);
> +		insert_work(cwq, work, worklist, color_flags | delayed_flags);
> +	}

I can't say I like this.  In interlocks the work being queued and the
worker so that both have to watch out for each other.  It's kinda
nasty.

> @@ -2236,6 +2241,16 @@ __acquires(&pool->lock)
>  	worker->current_func = NULL;
>  	worker->current_cwq = NULL;
>  	cwq_dec_nr_in_flight(cwq, work_color);
> +
> +	if (unlikely(worker->requeue)) {
> +		unsigned long color_flags, keep_flags;
> +
> +		worker->requeue = false;
> +		keep_flags = atomic_long_read(&work->data);
> +		keep_flags &= WORK_STRUCT_LINKED | WORK_STRUCT_DELAYED;
> +		color_flags = work_color_to_flags(worker->requeue_color);
> +		set_work_cwq(work, cwq, color_flags | keep_flags);
> +	}

So, what was before mostly one way "is it still executing?" query
becomes three party handshake among the queuer, executing worker and
try_to_grab_pending(), and we end up shifting information from the
queuer through the executing worker because work->data can't hold both
workqueue and worker information.

I don't know, Lai.  While removal of busy_hash is nice, I'm not really
sure whether we're ending up with better or worse code by doing this.
It's more convoluted for sure.  Performance-wise, now that idr_find()
for pool costs almost nothing (because we're very unlikely to have
more than 256 pools), we're comparing one idr lookup (which can easily
blow through 256 single layer optimization limit) against two simple
hash table lookup.  I don't really think either would be noticeably
better than the other in any measureable way.

The trade-off, while doesn't seem too bad, doesn't seem much
beneficial either.  It's different from what we're currently doing but
I'm not sure we're making it better by doing this.

Hmmmmm....

-- 
tejun
