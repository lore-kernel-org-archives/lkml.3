Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaCFREn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:04:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:56255 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751015AbaCFREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:04:42 -0500
Date: Thu, 6 Mar 2014 12:04:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2] sched: Fix broken setscheduler()
Message-ID: <20140306120438.638bfe94@gandalf.local.home>
In-Reply-To: <20140306132040.781dbf18c9385a6112fbab2b@gmail.com>
References: <20140305232931.449eef8c@gandalf.local.home>
	<20140306115825.GS27965@twins.programming.kicks-ass.net>
	<20140306132040.781dbf18c9385a6112fbab2b@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 13:20:40 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:

> Yes. I think you can go with
> 
>  p->prio = p->normal_prio
> 
> and save a few checks in rt_mutex_getprio().
> 

You're right! Thanks.

-----

I decided to run my tests on linux-next, and my wakeup_rt tracer was
broken. After running a bisect, I found that the problem commit was:

   linux-next commit c365c292d059
   "sched: Consider pi boosting in setscheduler()"

And the reason the wake_rt tracer test was failing, was because it had
no RT task to trace. I first noticed this when running with
sched_switch event and saw that my RT task still had normal SCHED_OTHER
priority. Looking at the problem commit, I found:

 -       p->normal_prio = normal_prio(p);
 -       p->prio = rt_mutex_getprio(p);

With no

 +       p->normal_prio = normal_prio(p);
 +       p->prio = rt_mutex_getprio(p);

Reading what the commit is suppose to do, I realize that the p->prio
can't be set if the task is boosted with a higher prio, but the
p->normal_prio still needs to be set regardless, otherwise, when the
task is deboosted, it wont get the new priority.

The p->prio has to be set before "check_class_changed()" is called,
otherwise the class wont be changed.

Link: http://lkml.kernel.org/r/20140305232931.449eef8c@gandalf.local.home

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4600bca..3134756 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3198,6 +3198,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
+	p->normal_prio = normal_prio(p);
 	set_load_weight(p);
 }
 
@@ -3207,6 +3208,12 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 {
 	__setscheduler_params(p, attr);
 
+	/*
+	 * If we get here, there was no pi waiters boosting the
+	 * task. It is safe to use the normal prio.
+	 */
+	p->prio = normal_prio(p);
+
 	if (dl_prio(p->prio))
 		p->sched_class = &dl_sched_class;
 	else if (rt_prio(p->prio))
-- 
1.8.1.4

