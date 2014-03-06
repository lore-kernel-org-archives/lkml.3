Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaCFUnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:43:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:56810 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaCFUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:43:49 -0500
Date: Thu, 6 Mar 2014 21:43:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched: Fix broken setscheduler()
In-Reply-To: <20140306120438.638bfe94@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
References: <20140305232931.449eef8c@gandalf.local.home> <20140306115825.GS27965@twins.programming.kicks-ass.net> <20140306132040.781dbf18c9385a6112fbab2b@gmail.com> <20140306120438.638bfe94@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Steven Rostedt wrote:

> On Thu, 6 Mar 2014 13:20:40 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
> 
> > Yes. I think you can go with
> > 
> >  p->prio = p->normal_prio
> > 
> > and save a few checks in rt_mutex_getprio().
> > 
> 
> You're right! Thanks.
> 
> -----
> 
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

Indeed.
 
> The p->prio has to be set before "check_class_changed()" is called,
> otherwise the class wont be changed.
> 
> Link: http://lkml.kernel.org/r/20140305232931.449eef8c@gandalf.local.home
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched/core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4600bca..3134756 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3198,6 +3198,7 @@ static void __setscheduler_params(struct task_struct *p,
>  	 * getparam()/getattr() don't report silly values for !rt tasks.
>  	 */
>  	p->rt_priority = attr->sched_priority;
> +	p->normal_prio = normal_prio(p);
>  	set_load_weight(p);
>  }
>  
> @@ -3207,6 +3208,12 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
>  {
>  	__setscheduler_params(p, attr);
>  
> +	/*
> +	 * If we get here, there was no pi waiters boosting the
> +	 * task. It is safe to use the normal prio.
> +	 */
> +	p->prio = normal_prio(p);
> +
>  	if (dl_prio(p->prio))
>  		p->sched_class = &dl_sched_class;
>  	else if (rt_prio(p->prio))
> -- 
> 1.8.1.4
> 
> 
