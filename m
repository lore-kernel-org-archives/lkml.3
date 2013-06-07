Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3FGThq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:37:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3FGTho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:37:44 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gXzUYEAd_P0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=wXoUysf7cpcA:10 a=vaJtXVxTAAAA:8 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=NccOWU47VS7Jxu_p5SsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370633863.9844.92.camel@gandalf.local.home>
Subject: [PATCH] sched/rt: Simplify pull_rt_task() logic and remove
 .leaf_rt_rq_list
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Fri, 07 Jun 2013 15:37:43 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Peter, this is based off of some of my work, I ran it though a few 
  tests and it passed. I also reviewed it, and added my SOB as I am
  somewhat a co-author to it. ]

From: Kirill Tkhai <tkhai@yandex.ru>

Based on the patch by Steven Rostedt from previous year:

https://lkml.org/lkml/2012/4/18/517

1)Simplify pull_rt_task() logic: search in pushable tasks of dest runqueue.
The only pullable tasks are the tasks which are pushable in their local rq,
and no others.

2)Remove .leaf_rt_rq_list member of struct rt_rq and functions connected
with it: nobody uses it since now.

Link: http://lkml.kernel.org/r/287571370557898@web7d.yandex.ru

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/rt.c    |   82 ++++++++++----------------------------------------
 kernel/sched/sched.h |    1 -
 2 files changed, 16 insertions(+), 67 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8d85f9a..01970c8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -399,20 +399,6 @@ static inline struct task_group *next_task_group(struct task_group *tg)
 		(iter = next_task_group(iter)) &&			\
 		(rt_rq = iter->rt_rq[cpu_of(rq)]);)
 
-static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-	list_add_rcu(&rt_rq->leaf_rt_rq_list,
-			&rq_of_rt_rq(rt_rq)->leaf_rt_rq_list);
-}
-
-static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-	list_del_rcu(&rt_rq->leaf_rt_rq_list);
-}
-
-#define for_each_leaf_rt_rq(rt_rq, rq) \
-	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = rt_se->parent)
 
@@ -509,17 +495,6 @@ typedef struct rt_rq *rt_rq_iter_t;
 #define for_each_rt_rq(rt_rq, iter, rq) \
 	for ((void) iter, rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
-static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-}
-
-static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-}
-
-#define for_each_leaf_rt_rq(rt_rq, rq) \
-	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = NULL)
 
@@ -1066,9 +1041,6 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	if (!rt_rq->rt_nr_running)
-		list_add_leaf_rt_rq(rt_rq);
-
 	if (head)
 		list_add(&rt_se->run_list, queue);
 	else
@@ -1088,8 +1060,6 @@ static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
-	if (!rt_rq->rt_nr_running)
-		list_del_leaf_rt_rq(rt_rq);
 }
 
 /*
@@ -1394,42 +1364,24 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 	return 0;
 }
 
-/* Return the second highest RT task, NULL otherwise */
-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
+/*
+ * Return the highest pushable rq's task, which is suitable to be executed
+ * on the cpu, NULL otherwise
+ */
+static struct task_struct *pick_highest_pushable_task(struct rq *rq, int cpu)
 {
-	struct task_struct *next = NULL;
-	struct sched_rt_entity *rt_se;
-	struct rt_prio_array *array;
-	struct rt_rq *rt_rq;
-	int idx;
-
-	for_each_leaf_rt_rq(rt_rq, rq) {
-		array = &rt_rq->active;
-		idx = sched_find_first_bit(array->bitmap);
-next_idx:
-		if (idx >= MAX_RT_PRIO)
-			continue;
-		if (next && next->prio <= idx)
-			continue;
-		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p;
+	struct plist_head *head = &rq->rt.pushable_tasks;
+	struct task_struct *p;
 
-			if (!rt_entity_is_task(rt_se))
-				continue;
+	if (!has_pushable_tasks(rq))
+		return NULL;
 
-			p = rt_task_of(rt_se);
-			if (pick_rt_task(rq, p, cpu)) {
-				next = p;
-				break;
-			}
-		}
-		if (!next) {
-			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-			goto next_idx;
-		}
+	plist_for_each_entry(p, head, pushable_tasks) {
+		if (pick_rt_task(rq, p, cpu))
+			return p;
 	}
 
-	return next;
+	return NULL;
 }
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
@@ -1703,12 +1655,10 @@ static int pull_rt_task(struct rq *this_rq)
 		double_lock_balance(this_rq, src_rq);
 
 		/*
-		 * Are there still pullable RT tasks?
+		 * We can pull only a task, which is pushable
+		 * on its rq, and no others.
 		 */
-		if (src_rq->rt.rt_nr_running <= 1)
-			goto skip;
-
-		p = pick_next_highest_task_rt(src_rq, this_cpu);
+		p = pick_highest_pushable_task(src_rq, this_cpu);
 
 		/*
 		 * Do we have an RT task that preempts
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 74ff659..029601a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -361,7 +361,6 @@ struct rt_rq {
 	unsigned long rt_nr_boosted;
 
 	struct rq *rq;
-	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
 #endif
 };
-- 
1.7.3.4



