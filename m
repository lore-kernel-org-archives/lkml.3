Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaCFL6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:58:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52544 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaCFL6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:58:42 -0500
Date: Thu, 6 Mar 2014 12:58:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH linux-next] sched: Fix broken setscheduler()
Message-ID: <20140306115825.GS27965@twins.programming.kicks-ass.net>
References: <20140305232931.449eef8c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305232931.449eef8c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:29:31PM -0500, Steven Rostedt wrote:
> I decided to run my tests on linux-next, and my wakeup_rt tracer was
> broken. After running a bisect, I found that the problem commit was:
> 
>    linux-next commit c365c292d059
>    "sched: Consider pi boosting in setscheduler()"
> 
> And the reason the wake_rt tracer test was failing, was because it had
> no RT task to trace. I first noticed this when running with
> sched_switch event and saw that my RT task still had normal SCHED_OTHER
> priority. Looking at the problem commit, I found:
> 
>  -       p->normal_prio = normal_prio(p);
>  -       p->prio = rt_mutex_getprio(p);
> 
> With no
> 
>  +       p->normal_prio = normal_prio(p);
>  +       p->prio = rt_mutex_getprio(p);
> 
> Reading what the commit is suppose to do, I realize that the p->prio
> can't be set if the task is boosted with a higher prio, but the
> p->normal_prio still needs to be set regardless, otherwise, when the
> task is deboosted, it wont get the new priority.
> 
> The p->prio has to be set before "check_class_changed()" is called,
> otherwise the class wont be changed.

So Juri had a different patch for this problem:

  http://lkml.kernel.org/r/20140301191838.d15d03112b2598a671dac22c@gmail.com

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4600bca..b1cc871 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3198,6 +3198,7 @@ static void __setscheduler_params(struct task_struct *p,
>  	 * getparam()/getattr() don't report silly values for !rt tasks.
>  	 */
>  	p->rt_priority = attr->sched_priority;
> +	p->normal_prio = normal_prio(p);
>  	set_load_weight(p);
>  }

Now; if I'm reading things right, normal_prio is the unboosted priority
of a task. And we should indeed keep setting that, otherwise the unboost
doesn't know where it should go.

Juri put that in __setscheduler(), but I think that's wrong because the
rt_mutex_check_prio() case in __sched_setscheduler() still needs to
update this.

> @@ -3207,6 +3208,8 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
>  {
>  	__setscheduler_params(p, attr);
>  
> +	p->prio = rt_mutex_getprio(p);
> +
>  	if (dl_prio(p->prio))
>  		p->sched_class = &dl_sched_class;
>  	else if (rt_prio(p->prio))
> 

And when we call this we're sure to not be boosted; so this is
effectively the same as Juri has:

  p->prio = p->normal_prio = normal_prio(p)

Seeing how rt_mutex_getprio() and normal_prio() are the same under these
conditions.


