Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaFZWsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:48:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:4130 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751508AbaFZWsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:48:13 -0400
Date: Thu, 26 Jun 2014 18:48:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched/rt: Check if rt_se has neighbour in
 requeue_task_rt()
Message-ID: <20140626184811.252a66c0@gandalf.local.home>
In-Reply-To: <722151372892539@web1e.yandex.ru>
References: <722151372892539@web1e.yandex.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

A blast from the past. I'm cleaning out my INBOX and I found this patch
under the rug. I know I had a holiday when it was sent (date is July 4th,
Yay! fireworks).

Anyway, there was no comments to it. What do you think.

I haven't reviewed it much but I have a small comment by doing a quick
review (embedded).

On Thu, 04 Jul 2013 03:02:19 +0400
Kirill Tkhai <tkhai@yandex.ru> wrote:

> 1)requeue_task_rt: check if entity's next and prev are not the same element.
> This guarantees entity is queued and it is not the only in the prio list.
> Return 1 if at least one rt_se from the stack was really requeued.
> 
> 2)Remove on_rt_rq check from requeue_rt_entity() because it is useless now.
> Furthermore, it doesn't handle single rt_se case.
> 
> 3)Make pretty task_tick_rt() more pretty.
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/rt.c |   49 +++++++++++++++++++++++--------------------------
>  1 files changed, 23 insertions(+), 26 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 01970c8..3213503 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1135,29 +1135,37 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
>   * Put task to the head or the end of the run list without the overhead of
>   * dequeue followed by enqueue.
>   */
> -static void
> +static inline void

No need for the "inline" here. It's only used once and it's static. Gcc
will inline it naturally.

-- Steve


>  requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
>  {
> -	if (on_rt_rq(rt_se)) {
> -		struct rt_prio_array *array = &rt_rq->active;
> -		struct list_head *queue = array->queue + rt_se_prio(rt_se);
> +	struct rt_prio_array *array = &rt_rq->active;
> +	struct list_head *queue = array->queue + rt_se_prio(rt_se);
>  
> -		if (head)
> -			list_move(&rt_se->run_list, queue);
> -		else
> -			list_move_tail(&rt_se->run_list, queue);
> -	}
> +	if (head)
> +		list_move(&rt_se->run_list, queue);
> +	else
> +		list_move_tail(&rt_se->run_list, queue);
>  }
>  
> -static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
> +static int requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
>  {
>  	struct sched_rt_entity *rt_se = &p->rt;
> -	struct rt_rq *rt_rq;
> +	int requeued = 0;
>  
>  	for_each_sched_rt_entity(rt_se) {
> -		rt_rq = rt_rq_of_se(rt_se);
> -		requeue_rt_entity(rt_rq, rt_se, head);
> +		/*
> +		 * Requeue to the head or tail of prio queue if
> +		 * rt_se is queued and it is not the only element
> +		 */
> +		if (rt_se->run_list.prev != rt_se->run_list.next) {
> +			struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
> +
> +			requeue_rt_entity(rt_rq, rt_se, head);
> +			requeued = 1;
> +		}
>  	}
> +
> +	return requeued;
>  }
>  
>  static void yield_task_rt(struct rq *rq)
> @@ -1912,8 +1920,6 @@ static void watchdog(struct rq *rq, struct task_struct *p)
>  
>  static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
>  {
> -	struct sched_rt_entity *rt_se = &p->rt;
> -
>  	update_curr_rt(rq);
>  
>  	watchdog(rq, p);
> @@ -1930,17 +1936,8 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
>  
>  	p->rt.time_slice = sched_rr_timeslice;
>  
> -	/*
> -	 * Requeue to the end of queue if we (and all of our ancestors) are the
> -	 * only element on the queue
> -	 */
> -	for_each_sched_rt_entity(rt_se) {
> -		if (rt_se->run_list.prev != rt_se->run_list.next) {
> -			requeue_task_rt(rq, p, 0);
> -			set_tsk_need_resched(p);
> -			return;
> -		}
> -	}
> +	if (requeue_task_rt(rq, p, 0))
> +		set_tsk_need_resched(p);
>  }
>  
>  static void set_curr_task_rt(struct rq *rq)

