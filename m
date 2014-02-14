Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBNMi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:38:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43606 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaBNMi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:38:56 -0500
Date: Fri, 14 Feb 2014 13:38:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC PATCH] sched: make sure sched-priority after invoke
 idle_balance()
Message-ID: <20140214123845.GI27965@twins.programming.kicks-ass.net>
References: <52FDA18D.40100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDA18D.40100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:54:37PM +0800, Michael wang wrote:
> Since idle_balance() will release rq-lock for a while, there is a chance that
> RT/DL tasks will be enqueued and ask for the resched, the func used to be
> invoked ahead of pick_next_task(), which will make sure we drop into the
> bottom-half inside pick_next_task().
> 
> Now since idle_balance() was done inside pick_next_task_fair(), pick_next_task()
> can no longer make sure the priority, the worst case is that we will going to
> pick the pulled fair task while there is RT/DL on rq which actually should be
> picked up.
> 
> This patch will prevent this happen by some rechecking after idle_balance(), it
> utilize the resched-flag for the case when RT/DL task was enqueued but don't ask
> for resched (will that ever happened?).

I'm not sure this is actually working right; the problem is that while
we do retry on need_resched() in the main schedule() loop, that last
need_resched() is on @next (then current). So clearing/resetting @prev's
need_resched() is not going to trigger that loop.

Not to mention we explicitly clear @prev's need_resched right after
pick_next_task().

So how about something like this?

I don't particularly like adding that condition to pick_next_task(); but
the alternative is recursively calling pick_next_task() and while
recursion is strictly limited to the number of sched_classes, it does
feel kinda icky.

Anybody got any preferences?

---
Subject: sched: Guarantee task priority in pick_next_task()
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Feb 14 12:25:08 CET 2014

Michael spotted that the idle_balance() push down created a task
priority problem.

Previously, when we called idle_balance() before pick_next_task() it
wasn't a problem when -- because of the rq->lock droppage -- an rt/dl
task slipped in.

Similarly for pre_schedule(), rt pre-schedule could have a dl task
slip in.

But by pulling it into the pick_next_task() loop, we'll not try a
higher task priority again.

Cure this by creating a re-start condition in pick_next_task(); and
triggering this from pick_next_task_{rt,fair}().

Fixes: 38033c37faab ("sched: Push down pre_schedule() and idle_balance()")
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-jrdk7auga87duk4lkpo8xusk@git.kernel.org
---
 kernel/sched/core.c |   19 +++++++++++++++----
 kernel/sched/fair.c |   16 +++++++++++++++-
 kernel/sched/rt.c   |   10 +++++++++-
 3 files changed, 39 insertions(+), 6 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2574,27 +2574,38 @@ static inline void schedule_debug(struct
 static inline struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev)
 {
-	const struct sched_class *class;
+	const struct sched_class *class = &fair_sched_class;
 	struct task_struct *p;
 
 	/*
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(prev->sched_class == &fair_sched_class &&
+	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
-			return p;
+			goto got_task;
 	}
 
+again:
 	for_each_class(class) {
 		p = class->pick_next_task(rq, prev);
 		if (p)
-			return p;
+			goto got_task;
 	}
 
 	BUG(); /* the idle class will always have a runnable task */
+
+got_task:
+	/*
+	 * See pick_next_task_{fair,rt}(); they return rq->idle in case
+	 * they want to re-start the task selection.
+	 */
+	if (unlikely(p->sched_class != class))
+		goto again;
+
+	return p;
 }
 
 /*
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4684,6 +4684,7 @@ pick_next_task_fair(struct rq *rq, struc
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 	struct task_struct *p;
+	int new_tasks;
 
 again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -4782,7 +4783,20 @@ pick_next_task_fair(struct rq *rq, struc
 	return p;
 
 idle:
-	if (idle_balance(rq)) /* drops rq->lock */
+	/*
+	 * Because idle_balance() releases (and re-acquires) rq->lock, it is
+	 * possible for any higher priority task to appear. In that case we
+	 * must re-start the pick_next_entity() loop.
+	 */
+	new_tasks = idle_balance(rq);
+
+	/*
+	 * See pick_next_task(); we return rq->idle to restart task selection.
+	 */
+	if (rq->nr_running != rq->cfs.h_nr_running)
+		return rq->idle;
+
+	if (new_tasks)
 		goto again;
 
 	return NULL;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1360,8 +1360,16 @@ pick_next_task_rt(struct rq *rq, struct
 	struct task_struct *p;
 	struct rt_rq *rt_rq = &rq->rt;
 
-	if (need_pull_rt_task(rq, prev))
+	if (need_pull_rt_task(rq, prev)) {
 		pull_rt_task(rq);
+		/*
+		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
+		 * means a dl task can slip in, in which case we need to
+		 * re-start task selection.
+		 */
+		if (unlikely(rq->dl.dl_nr_running))
+			return rq->idle;
+	}
 
 	if (!rt_rq->rt_nr_running)
 		return NULL;
