Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaCKXYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:24:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:22676 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755563AbaCKXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:24:22 -0400
Date: Tue, 11 Mar 2014 19:24:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v3] sched: Fix broken setscheduler()
Message-ID: <20140311192420.39395358@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1403111147540.18573@ionos.tec.linutronix.de>
References: <20140305232931.449eef8c@gandalf.local.home>
	<20140306115825.GS27965@twins.programming.kicks-ass.net>
	<20140306132040.781dbf18c9385a6112fbab2b@gmail.com>
	<20140306120438.638bfe94@gandalf.local.home>
	<alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
	<20140310132940.78e556c7@gandalf.local.home>
	<alpine.DEB.2.02.1403102206520.18573@ionos.tec.linutronix.de>
	<20140310173731.06d41157@gandalf.local.home>
	<20140311103545.fc7f0f6b1bf0eb1d3391c85c@gmail.com>
	<alpine.DEB.2.02.1403111147540.18573@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Also added fix to newprio to include a check for deadline policy that
was missing. This change was suggested by Juri Lelli.

Link: http://lkml.kernel.org/r/20140306120438.638bfe94@gandalf.local.home
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee8004c..f00a032 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3197,6 +3197,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
+	p->normal_prio = normal_prio(p);
 	set_load_weight(p);
 }
 
@@ -3206,6 +3207,12 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
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
@@ -3264,7 +3271,8 @@ static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
-	int newprio = MAX_RT_PRIO - 1 - attr->sched_priority;
+	int newprio = dl_policy(attr->sched_policy) ? MAX_DL_PRIO - 1 :
+		      MAX_RT_PRIO - 1 - attr->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
-- 
1.8.1.4


