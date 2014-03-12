Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaCLKLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:11:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaCLKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:11:17 -0400
Date: Wed, 12 Mar 2014 03:10:19 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-383afd0971538b3d77532a56404b24cfe967b5dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de,
        bigeasy@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de,
        bigeasy@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <20140306120438.638bfe94@gandalf.local.home>
References: <20140306120438.638bfe94@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix broken setscheduler()
Git-Commit-ID: 383afd0971538b3d77532a56404b24cfe967b5dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  383afd0971538b3d77532a56404b24cfe967b5dd
Gitweb:     http://git.kernel.org/tip/383afd0971538b3d77532a56404b24cfe967b5dd
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 11 Mar 2014 19:24:20 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 10:48:59 +0100

sched: Fix broken setscheduler()

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: SebastianAndrzej Siewior <bigeasy@linutronix.de>
Cc: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140306120438.638bfe94@gandalf.local.home
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9e126a2..ae365aa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3195,6 +3195,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
+	p->normal_prio = normal_prio(p);
 	set_load_weight(p);
 }
 
@@ -3204,6 +3205,12 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
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
@@ -3262,7 +3269,8 @@ static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
-	int newprio = MAX_RT_PRIO - 1 - attr->sched_priority;
+	int newprio = dl_policy(attr->sched_policy) ? MAX_DL_PRIO - 1 :
+		      MAX_RT_PRIO - 1 - attr->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
