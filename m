Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaCKJfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:35:39 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:64403 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaCKJfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:35:34 -0400
Date: Tue, 11 Mar 2014 10:35:45 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched: Fix broken setscheduler()
Message-Id: <20140311103545.fc7f0f6b1bf0eb1d3391c85c@gmail.com>
In-Reply-To: <20140310173731.06d41157@gandalf.local.home>
References: <20140305232931.449eef8c@gandalf.local.home>
	<20140306115825.GS27965@twins.programming.kicks-ass.net>
	<20140306132040.781dbf18c9385a6112fbab2b@gmail.com>
	<20140306120438.638bfe94@gandalf.local.home>
	<alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
	<20140310132940.78e556c7@gandalf.local.home>
	<alpine.DEB.2.02.1403102206520.18573@ionos.tec.linutronix.de>
	<20140310173731.06d41157@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 17:37:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 10 Mar 2014 22:18:56 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > Lemme look at it tomorrow again with an awake brain. This seems to be
> > some forward porting hickup which needs a closer look. Just look at
> 
> Yep, I talked with Sebastian on IRC and that seems to be the case.
> 
> > the 3.10-rt version of this:
> > 
> > @@ -3825,20 +3826,25 @@ static struct task_struct *find_process_by_pid(pid_t pid)
> >  	return pid ? find_task_by_vpid(pid) : current;
> >  }
> >  
> > -/* Actually do priority change: must hold rq lock. */
> > -static void
> > -__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
> > +static void __setscheduler_params(struct task_struct *p, int policy, int prio)
> >  {
> >  	p->policy = policy;
> >  	p->rt_priority = prio;
> >  	p->normal_prio = normal_prio(p);
> > +	set_load_weight(p);
> > +}
> > 
> > That code has changed significantly probably due to the EDF merge. We
> > need to figure out whether there is more damage due to that.
> 
> Yeah, when I looked at the -rt version, it appeared to have my fix
> already. But in reality, the forward port broke it. Here's the problem
> part of the commit:
> 
> +       set_load_weight(p);
> +}
>  
> -       p->normal_prio = normal_prio(p);
> -       p->prio = rt_mutex_getprio(p);
> 
> Your patch never deleted the above two. And it kept them in the
> locations that I placed them in, in my patch.
> 

Oh, and you have to have also something like this

@@ -3271,7 +3271,8 @@ static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
-	int newprio = MAX_RT_PRIO - 1 - attr->sched_priority;
+	int newprio = dl_policy(attr->sched_policy) ? MAX_DL_PRIO - 1 :
+		      MAX_RT_PRIO - 1 - attr->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;

or you can fail to become DL if you are currently boosted by RT, as
attr->sched_priority == 0 for DL tasks. Then rt_mutex_check_prio ()
returns 1 (just update params) if setting DL params for a task already
boosted by another DL. But this seems to be ok, as we are already
outside enforcement in this situation. (This is going to be trickier
with proxy exec, though :/).

Thanks,

- Juri

> -- Steve
> 
> 
> +/* Actually do priority change: must hold pi & rq lock. */
> +static void __setscheduler(struct rq *rq, struct task_struct *p,
> +                          const struct sched_attr *attr)
> +{
> 
> 
