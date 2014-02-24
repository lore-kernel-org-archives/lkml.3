Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaBXMM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:12:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35613 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBXMMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:12:25 -0500
Date: Mon, 24 Feb 2014 13:12:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140224121218.GR15586@twins.programming.kicks-ass.net>
References: <5304F32A.4040907@oracle.com>
 <5305856F.3000109@linux.vnet.ibm.com>
 <53078241.3060201@oracle.com>
 <53080122.609@linux.vnet.ibm.com>
 <530ABB44.5000601@oracle.com>
 <530AD653.3000808@linux.vnet.ibm.com>
 <20140224071028.GW9987@twins.programming.kicks-ass.net>
 <530B1B80.4000307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B1B80.4000307@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 06:14:24PM +0800, Michael wang wrote:
> On 02/24/2014 03:10 PM, Peter Zijlstra wrote:
> > On Mon, Feb 24, 2014 at 01:19:15PM +0800, Michael wang wrote:
> >> Peter, do we accidentally missed this commit?
> >>
> >> http://git.kernel.org/tip/477af336ba06ef4c32e97892bb0d2027ce30f466
> > 
> > Ingo dropped it on Saturday because it makes locking_selftest() unhappy.
> > 
> > That is because we call locking_selftest() way before we're ready to
> > call schedule() and guess what it does :-/
> > 
> > I'm not entirely sure what to do.. ideally I'd shoot locking_selftest in
> > the head, but clearly that's not entirely desired either.
> 
> ...what about move idle_balance() back to it's old position?

I've always hated that, idle_balance() is very much a fair policy thing
and shouldn't live in the core code.

> pull_rt_task() logical could be after idle_balance() if still no FAIR
> and DL, then go into the pick loop, that may could make things more
> clean & clear, should we have a try?

So the reason pull_{rt,dl}_task() is before idle_balance() is that we
don't want to add the execution latency of idle_balance() to the rt/dl
task pulling.

Anyway, the below seems to work; it avoids playing tricks with the idle
thread and instead uses a magic constant.

The comparison should be faster too; seeing how we avoid dereferencing
p->sched_class.

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
---
 kernel/sched/core.c  |   12 ++++++++----
 kernel/sched/fair.c  |   13 ++++++++++++-
 kernel/sched/rt.c    |   10 +++++++++-
 kernel/sched/sched.h |    5 +++++
 4 files changed, 34 insertions(+), 6 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2586,24 +2586,28 @@ static inline void schedule_debug(struct
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
-		if (likely(p))
+		if (likely(p && p != RETRY_TASK))
 			return p;
 	}
 
+again:
 	for_each_class(class) {
 		p = class->pick_next_task(rq, prev);
-		if (p)
+		if (p) {
+			if (unlikely(p == RETRY_TASK))
+				goto again;
 			return p;
+		}
 	}
 
 	BUG(); /* the idle class will always have a runnable task */
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4687,6 +4687,7 @@ pick_next_task_fair(struct rq *rq, struc
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 	struct task_struct *p;
+	int new_tasks;
 
 again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -4785,7 +4786,17 @@ pick_next_task_fair(struct rq *rq, struc
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
+	if (rq->nr_running != rq->cfs.h_nr_running)
+		return RETRY_TASK;
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
+			return RETRY_TASK;
+	}
 
 	if (!rt_rq->rt_nr_running)
 		return NULL;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1090,6 +1090,8 @@ static const u32 prio_to_wmult[40] = {
 
 #define DEQUEUE_SLEEP		1
 
+#define RETRY_TASK		((void *)-1UL)
+
 struct sched_class {
 	const struct sched_class *next;
 
@@ -1104,6 +1106,9 @@ struct sched_class {
 	 * It is the responsibility of the pick_next_task() method that will
 	 * return the next task to call put_prev_task() on the @prev task or
 	 * something equivalent.
+	 *
+	 * May return RETRY_TASK when it finds a higher prio class has runnable
+	 * tasks.
 	 */
 	struct task_struct * (*pick_next_task) (struct rq *rq,
 						struct task_struct *prev);
