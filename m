Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaCASSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 13:18:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55173 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaCASSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 13:18:43 -0500
Date: Sat, 1 Mar 2014 19:18:38 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Subject: Re: [PATCH]sched/core: Return possibility to set RT and DL classes
 back
Message-Id: <20140301191838.d15d03112b2598a671dac22c@gmail.com>
In-Reply-To: <1393584643.3522.5.camel@tkhai>
References: <1393496657.3522.3.camel@tkhai>
	<1393584643.3522.5.camel@tkhai>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 14:50:43 +0400
Kirill Tkhai <ktkhai@parallels.com> wrote:

> Thomas, have you seen this?
> 
> Nothing works at the moment:
>

Noticed the same once rebased on tip/master as of today.
 
> now
> 
>    21 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/3                                                                                                                                            
>    16 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/2                                                                                                                                            
>    11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1                                                                                                                                            
>    10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/0
> 
>    22 root      20   0     0    0    0 S  0.0  0.0   0:00.00 migration/3                                                                                                                                           
>    17 root      20   0     0    0    0 S  0.0  0.0   0:00.00 migration/2                                                                                                                                           
>    12 root      20   0     0    0    0 S  0.0  0.0   0:00.04 migration/1                                                                                                                                           
>     9 root      20   0     0    0    0 S  0.0  0.0   0:00.20 migration/0
> 
> with fix
> 
>    21 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/3         
>    16 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/2         
>    11 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1         
>    10 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/0
> 
>    22 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/3                                                                                                                                           
>    17 root      RT   0     0    0    0 S  0.0  0.0   0:00.03 migration/2                                                                                                                                           
>    12 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/1                                                                                                                                           
>     9 root      RT   0     0    0    0 S  0.0  0.0   0:00.24 migration/0
> 
> В Чт, 27/02/2014 в 14:24 +0400, Kirill Tkhai пишет:
> > [PATCH]sched/core: Return possibility to set RT and DL classes back
> > 
> > I found that it's impossible to set RT policy for tasks at the moment.
> > 
> > This is regression after commit [sched: Consider pi boosting in setscheduler()]
> > 				[c365c292d05908c6ea6f32708f331e21033fe71d     ]
> > Fix that.
> > 
> > Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Ingo Molnar <mingo@redhat.com>
> > ---
> >  kernel/sched/core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 84b23ce..30cf9ad 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -3193,6 +3193,10 @@ static void __setscheduler_params(struct task_struct *p,
> >  	 * getparam()/getattr() don't report silly values for !rt tasks.
> >  	 */
> >  	p->rt_priority = attr->sched_priority;
> > +
> > +	p->normal_prio = normal_prio(p);
> > +	p->prio = rt_mutex_getprio(p);
> > +
> >  	set_load_weight(p);
> >  }
> >  
> > 

I'd propose what follows, so that we can still use
__setscheduler_params() as it is.

Regards,

- Juri

>From 73bae0ad978db6e75f492eea9adff12ec9d6d2a3 Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@gmail.com>
Date: Sat, 1 Mar 2014 16:43:30 +0100
Subject: [PATCH] sched/core: restore __setscheduler() behavior

Commit c365c29 introduced __setscheduler_params(), that is now used
to only store a task's new scheduling parameters in the case it is
priority boosted.

Before this change, __setscheduler() was in charge of changing tasks
normal_prio and prio, and the latter is used to actually perform
sched_class change. Unfortunately, the commit above broke this
behavior, causing tasks to remain in fair_sched_class.

Restore the old behaviour setting normal_prio and prio to the right
values after the __setscheduler_params() call.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee8004c..04ae20d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3206,6 +3206,13 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 {
 	__setscheduler_params(p, attr);
 
+	/*
+	 * Since we checked before with rt_mutex_check_prio(),
+	 * we don't have pi waiters or our top waiter has lower
+	 * priority (user space view) than what we got.
+	 */
+	p->prio = p->normal_prio = normal_prio(p);
+
 	if (dl_prio(p->prio))
 		p->sched_class = &dl_sched_class;
 	else if (rt_prio(p->prio))
-- 
1.7.9.5
