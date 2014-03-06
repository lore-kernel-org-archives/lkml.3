Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaCFE3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:29:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:14185 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752185AbaCFE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:29:34 -0500
Date: Wed, 5 Mar 2014 23:29:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH linux-next] sched: Fix broken setscheduler()
Message-ID: <20140305232931.449eef8c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4600bca..b1cc871 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3198,6 +3198,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
+	p->normal_prio = normal_prio(p);
 	set_load_weight(p);
 }
 
@@ -3207,6 +3208,8 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 {
 	__setscheduler_params(p, attr);
 
+	p->prio = rt_mutex_getprio(p);
+
 	if (dl_prio(p->prio))
 		p->sched_class = &dl_sched_class;
 	else if (rt_prio(p->prio))

