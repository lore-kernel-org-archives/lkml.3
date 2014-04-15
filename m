Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaDONt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:49:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54976 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaDONt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:49:58 -0400
Date: Tue, 15 Apr 2014 15:49:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] sched/wait: Use __add_wait_queue{_tail}_exclusive()
 as possible.
Message-ID: <20140415134949.GU11096@twins.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <c232d92d5d70daf9b2c58486dc5a182f95edd951.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c232d92d5d70daf9b2c58486dc5a182f95edd951.1397562542.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:32:52PM +0900, Dongsheng Yang wrote:
> From: Dongsheng <yangds.fnst@cn.fujitsu.com>
> 
> There is already a function in include/linux/wait.h to cover the
> 'exclusive' usage. So we can use it in sched/wait.c to replace
> the opened implementation of it.
> 
> Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
> ---
>  kernel/sched/wait.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 283750e..b04827e 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -38,9 +38,8 @@ void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
>  	unsigned long flags;
>  
>  	trace_sched_wait(current);
> -	wait->flags |= WQ_FLAG_EXCLUSIVE;
>  	spin_lock_irqsave(&q->lock, flags);
> -	__add_wait_queue_tail(q, wait);
> +	__add_wait_queue_tail_exclusive(q, wait);
>  	spin_unlock_irqrestore(&q->lock, flags);
>  }
>  EXPORT_SYMBOL(add_wait_queue_exclusive);
> @@ -192,10 +191,9 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
>  	unsigned long flags;
>  
>  	trace_sched_wait(current);
> -	wait->flags |= WQ_FLAG_EXCLUSIVE;
>  	spin_lock_irqsave(&q->lock, flags);
>  	if (list_empty(&wait->task_list))
> -		__add_wait_queue_tail(q, wait);
> +		__add_wait_queue_tail_exclusive(q, wait);
>  	set_current_state(state);
>  	spin_unlock_irqrestore(&q->lock, flags);

That is not a no-op, if !list_empty() we loose the WQ_flag
