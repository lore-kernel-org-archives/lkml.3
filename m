Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaJHVhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:37:35 -0400
Received: from forward5l.mail.yandex.net ([84.201.143.138]:45214 "EHLO
	forward5l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbaJHVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:37:32 -0400
X-Yandex-Uniq: b6e15004-4fe0-4a95-8801-f3ef86277d25
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1412804248.24248.1.camel@yandex.ru>
Subject: Re: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 01:37:28 +0400
In-Reply-To: <20141008193644.GA32055@redhat.com>
References: <20141007195046.GA28002@redhat.com>
	 <20141008080016.GB10832@worktop.programming.kicks-ass.net>
	 <20141008183302.GA17495@redhat.com> <20141008183326.GB17495@redhat.com>
	 <20141008193644.GA32055@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 08/10/2014 в 21:36 +0200, Oleg Nesterov пишет:
> On 10/08, Oleg Nesterov wrote:
> >
> > Another problem is that finish_task_switch() itself runs with preempt
> > enabled after finish_lock_switch(). If nothing else this means that
> > ->sched_in() notifier can't trust its "cpu" arg.
> 
> OOPS, this obviously can't happen, ->preempt_notifiers must be empty.
> Remove this part from the changelog, please see v2.
> 
> I am not sure about finish_arch_post_lock_switch() ... but probably
> it should be fine without preempt_disable.
> 
> -------------------------------------------------------------------------------
> Subject: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
> 
> finish_task_switch() enables preemption, so post_schedule(rq) can be
> called on the wrong (and even dead) CPU. Afaics, nothing really bad
> can happen, but in this case we can wrongly clear rq->post_schedule
> on that CPU. And this simply looks wrong in any case.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/sched/core.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 703c7e6..3f267e8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2277,15 +2277,14 @@ static inline void post_schedule(struct rq *rq)
>  asmlinkage __visible void schedule_tail(struct task_struct *prev)
>  	__releases(rq->lock)
>  {
> -	struct rq *rq = this_rq();
> +	struct rq *rq;
>  
> +	/* finish_task_switch() drops rq->lock and enables preemtion */
> +	preempt_disable();

Maybe, the code would look simpler if we change
init_task_preempt_count() and create new tasks
with preempt_count() == 2, so this preempt_disable()
won't be necessary. But it's more or less subjectively.

Reviewed-by: Kirill Tkhai <ktkhai@parallels.com>

> +	rq = this_rq();
>  	finish_task_switch(rq, prev);
> -
> -	/*
> -	 * FIXME: do we need to worry about rq being invalidated by the
> -	 * task_switch?
> -	 */
>  	post_schedule(rq);
> +	preempt_enable();
>  
>  	if (current->set_child_tid)
>  		put_user(task_pid_vnr(current), current->set_child_tid);




