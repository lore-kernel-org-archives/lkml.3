Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaFFQxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaFFQxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:53:17 -0400
Date: Fri, 6 Jun 2014 18:52:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sched/deadline: Kill task_struct->pi_top_task
Message-ID: <20140606165206.GB29465@redhat.com>
References: <20140606165150.GA29465@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606165150.GA29465@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove task_struct->pi_top_task. The only user, rt_mutex_setprio(),
can use a local.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    2 --
 kernel/fork.c         |    1 -
 kernel/sched/core.c   |    6 +++---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 82fe3da..2b426ee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1386,8 +1386,6 @@ struct task_struct {
 	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
-	/* Top pi_waiters task */
-	struct task_struct *pi_top_task;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
diff --git a/kernel/fork.c b/kernel/fork.c
index 65736ca..cafea61 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1094,7 +1094,6 @@ static void rt_mutex_init_task(struct task_struct *p)
 	p->pi_waiters = RB_ROOT;
 	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
-	p->pi_top_task = NULL;
 #endif
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..9dc8517 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2888,7 +2888,6 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	}
 
 	trace_sched_pi_setprio(p, prio);
-	p->pi_top_task = rt_mutex_get_top_task(p);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
@@ -2908,8 +2907,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	 *          running task
 	 */
 	if (dl_prio(prio)) {
-		if (!dl_prio(p->normal_prio) || (p->pi_top_task &&
-			dl_entity_preempt(&p->pi_top_task->dl, &p->dl))) {
+		struct task_struct *pi_task = rt_mutex_get_top_task(p);
+		if (!dl_prio(p->normal_prio) ||
+		    (pi_task && dl_entity_preempt(&pi_task->dl, &p->dl))) {
 			p->dl.dl_boosted = 1;
 			p->dl.dl_throttled = 0;
 			enqueue_flag = ENQUEUE_REPLENISH;
-- 
1.5.5.1


