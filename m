Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaCCJgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:36:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCCJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:36:29 -0500
Date: Mon, 3 Mar 2014 10:35:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        tkhai@yandex.ru
Subject: Re: [PATCH]sched/core: Return possibility to set RT and DL classes
 back
Message-ID: <20140303093558.GP27965@twins.programming.kicks-ass.net>
References: <1393496657.3522.3.camel@tkhai>
 <1393584643.3522.5.camel@tkhai>
 <20140301191838.d15d03112b2598a671dac22c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140301191838.d15d03112b2598a671dac22c@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 07:18:38PM +0100, Juri Lelli wrote:
> From 73bae0ad978db6e75f492eea9adff12ec9d6d2a3 Mon Sep 17 00:00:00 2001
> From: Juri Lelli <juri.lelli@gmail.com>
> Date: Sat, 1 Mar 2014 16:43:30 +0100
> Subject: [PATCH] sched/core: restore __setscheduler() behavior
> 
> Commit c365c29 introduced __setscheduler_params(), that is now used
> to only store a task's new scheduling parameters in the case it is
> priority boosted.
> 
> Before this change, __setscheduler() was in charge of changing tasks
> normal_prio and prio, and the latter is used to actually perform
> sched_class change. Unfortunately, the commit above broke this
> behavior, causing tasks to remain in fair_sched_class.
> 
> Restore the old behaviour setting normal_prio and prio to the right
> values after the __setscheduler_params() call.

Please also add a Fixes: tag when appropriate, and add to Cc all those
two were involved with the original patch.

Fixes: c365c292d059 ("sched: Consider pi boosting in setscheduler()")
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/sched/core.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ee8004c..04ae20d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3206,6 +3206,13 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
>  {
>  	__setscheduler_params(p, attr);
>  
> +	/*
> +	 * Since we checked before with rt_mutex_check_prio(),
> +	 * we don't have pi waiters or our top waiter has lower
> +	 * priority (user space view) than what we got.
> +	 */
> +	p->prio = p->normal_prio = normal_prio(p);
> +
>  	if (dl_prio(p->prio))
>  		p->sched_class = &dl_sched_class;
>  	else if (rt_prio(p->prio))

So there is one more caller of this: normalize_task() but since that is
only used to force set all tasks to SCHED_NORMAL ignoring the PI stuff
seems perfectly fine.
