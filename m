Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaCNWSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:18:01 -0400
Received: from forward9l.mail.yandex.net ([84.201.143.142]:54460 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaCNWR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:17:58 -0400
X-Yandex-Uniq: a16702c2-1c0f-4838-b0a3-19dd78293af3
Authentication-Results: smtp4h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1394835300.18748.33.camel@HP-250-G1-Notebook-PC>
Subject: [PATCH 3/4] sched/rt: Substract number of tasks of throttled queues
 from rq->nr_running
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Mar 2014 02:15:00 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now rq->rt becomes to be able to be in dequeued or enqueued state.
We add new member rt_rq->rt_queued, which is used to indicate this.
The member is used only for top queue rq->rt_rq.

The goal is to fit generic scheme which is used in deadline and
fair classes, i.e. throttled rt_rq's rt_nr_running is beeing
substracted from rq->nr_running.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c    |   73 ++++++++++++++++++++++++++++++++++++++++++--------
 kernel/sched/sched.h |    2 +
 2 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 93810d2..c961350 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -79,6 +79,8 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	rt_rq->overloaded = 0;
 	plist_head_init(&rt_rq->pushable_tasks);
 #endif
+	/* We start is dequeued state, because no RT tasks are queued */
+	rt_rq->rt_queued = 0;
 
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
@@ -404,6 +406,9 @@ static inline void set_post_schedule(struct rq *rq)
 }
 #endif /* CONFIG_SMP */
 
+static void enqueue_top_rt_rq(struct rt_rq *rt_rq);
+static void dequeue_top_rt_rq(struct rt_rq *rt_rq);
+
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 {
 	return !list_empty(&rt_se->run_list);
@@ -465,8 +470,11 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (rt_rq->rt_nr_running) {
-		if (rt_se && !on_rt_rq(rt_se))
+		if (!rt_se)
+			enqueue_top_rt_rq(rt_rq);
+		else if (!on_rt_rq(rt_se))
 			enqueue_rt_entity(rt_se, false);
+
 		if (rt_rq->highest_prio.curr < curr->prio)
 			resched_task(curr);
 	}
@@ -479,7 +487,9 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 
 	rt_se = rt_rq->tg->rt_se[cpu];
 
-	if (rt_se && on_rt_rq(rt_se))
+	if (!rt_se)
+		dequeue_top_rt_rq(rt_rq);
+	else if (on_rt_rq(rt_se))
 		dequeue_rt_entity(rt_se);
 }
 
@@ -545,12 +555,18 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 
 static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
-	if (rt_rq->rt_nr_running)
-		resched_task(rq_of_rt_rq(rt_rq)->curr);
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	if (!rt_rq->rt_nr_running)
+		return;
+
+	enqueue_top_rt_rq(rt_rq);
+	resched_task(rq->curr);
 }
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
+	dequeue_top_rt_rq(rt_rq);
 }
 
 static inline const struct cpumask *sched_rt_period_mask(void)
@@ -935,6 +951,38 @@ static void update_curr_rt(struct rq *rq)
 	}
 }
 
+static void
+dequeue_top_rt_rq(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	BUG_ON(&rq->rt != rt_rq);
+
+	if (!rt_rq->rt_queued)
+		return;
+
+	BUG_ON(!rq->nr_running);
+
+	rq->nr_running -= rt_rq->rt_nr_running;
+	rt_rq->rt_queued = 0;
+}
+
+static void
+enqueue_top_rt_rq(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	BUG_ON(&rq->rt != rt_rq);
+
+	if (rt_rq->rt_queued)
+		return;
+	if (rt_rq_throttled(rt_rq) || !rt_rq->rt_nr_running)
+		return;
+
+	rq->nr_running += rt_rq->rt_nr_running;
+	rt_rq->rt_queued = 1;
+}
+
 #if defined CONFIG_SMP
 
 static void
@@ -1143,6 +1191,8 @@ static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
 		back = rt_se;
 	}
 
+	dequeue_top_rt_rq(rt_rq_of_se(back));
+
 	for (rt_se = back; rt_se; rt_se = rt_se->back) {
 		if (on_rt_rq(rt_se))
 			__dequeue_rt_entity(rt_se);
@@ -1151,13 +1201,18 @@ static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
 
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
+	struct rq *rq = rq_of_rt_se(rt_se);
+
 	dequeue_rt_stack(rt_se);
 	for_each_sched_rt_entity(rt_se)
 		__enqueue_rt_entity(rt_se, head);
+	enqueue_top_rt_rq(&rq->rt);
 }
 
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 {
+	struct rq *rq = rq_of_rt_se(rt_se);
+
 	dequeue_rt_stack(rt_se);
 
 	for_each_sched_rt_entity(rt_se) {
@@ -1166,6 +1221,7 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 		if (rt_rq && rt_rq->rt_nr_running)
 			__enqueue_rt_entity(rt_se, false);
 	}
+	enqueue_top_rt_rq(&rq->rt);
 }
 
 /*
@@ -1183,8 +1239,6 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
-
-	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -1195,8 +1249,6 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
-
-	dec_nr_running(rq);
 }
 
 /*
@@ -1400,10 +1452,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	if (prev->sched_class == &rt_sched_class)
 		update_curr_rt(rq);
 
-	if (!rt_rq->rt_nr_running)
-		return NULL;
-
-	if (rt_rq_throttled(rt_rq))
+	if (!rt_rq->rt_queued)
 		return NULL;
 
 	put_prev_task(rq, prev);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f2de7a1..8327b4e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -409,6 +409,8 @@ struct rt_rq {
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
+	int rt_queued;
+
 	int rt_throttled;
 	u64 rt_time;
 	u64 rt_runtime;




