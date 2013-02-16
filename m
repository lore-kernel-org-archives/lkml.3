Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3BPRGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:06:47 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:51646 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3BPRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:06:46 -0500
Message-ID: <511FBCA0.9020205@gmail.com>
Date: Sun, 17 Feb 2013 01:06:40 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 wq/for-3.9] workqueue: reimplement is_chained_work()
 using current_wq_worker()
References: <20130214032633.GF9057@htj.dyndns.org> <20130214032705.GG9057@htj.dyndns.org>
In-Reply-To: <20130214032705.GG9057@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, tj

Thank you for adding this one.

Would you deffer "workqueue: rename cpu_workqueue to pool_workqueue" a 
little? I don't want to rebase my almost-ready work again(not a good 
reason... but please...)

I will answer your other emails soon and sent the patches.

Thanks,
Lai

On 14/02/13 11:27, Tejun Heo wrote:
> is_chained_work() was added before current_wq_worker() and implemented
> its own ham-fisted way of finding out whether %current is a workqueue
> worker - it iterates through all possible workers.
>
> Drop the custom implementation and reimplement using
> current_wq_worker().
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>   kernel/workqueue.c |   33 ++++++++-------------------------
>   1 file changed, 8 insertions(+), 25 deletions(-)
>
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1159,35 +1159,18 @@ static void insert_work(struct cpu_workq
>
>   /*
>    * Test whether @work is being queued from another work executing on the
> - * same workqueue.  This is rather expensive and should only be used from
> - * cold paths.
> + * same workqueue.
>    */
>   static bool is_chained_work(struct workqueue_struct *wq)
>   {
> -	unsigned long flags;
> -	unsigned int cpu;
> +	struct worker *worker;
>
> -	for_each_cwq_cpu(cpu, wq) {
> -		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> -		struct worker_pool *pool = cwq->pool;
> -		struct worker *worker;
> -		struct hlist_node *pos;
> -		int i;
> -
> -		spin_lock_irqsave(&pool->lock, flags);
> -		for_each_busy_worker(worker, i, pos, pool) {
> -			if (worker->task != current)
> -				continue;
> -			spin_unlock_irqrestore(&pool->lock, flags);
> -			/*
> -			 * I'm @worker, no locking necessary.  See if @work
> -			 * is headed to the same workqueue.
> -			 */
> -			return worker->current_cwq->wq == wq;
> -		}
> -		spin_unlock_irqrestore(&pool->lock, flags);
> -	}
> -	return false;
> +	worker = current_wq_worker();
> +	/*
> +	 * Return %true iff I'm a worker execuing a work item on @wq.  If
> +	 * I'm @worker, it's safe to dereference it without locking.
> +	 */
> +	return worker && worker->current_cwq->wq == wq;
>   }
>
>   static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

