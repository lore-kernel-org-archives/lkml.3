Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaCFJct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:32:49 -0500
Received: from relay.parallels.com ([195.214.232.42]:54861 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaCFJcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:32:09 -0500
Message-ID: <1394098321.19290.11.camel@tkhai>
Subject: [PATCH tip 2/2] sched/core: Fix endless loop in pick_next_task()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Date: Thu, 6 Mar 2014 13:32:01 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1)Single cpu machine case.

When rq has only RT tasks, but no one of them can be picked
because of throttling, we enter in endless loop.

pick_next_task_{dl,rt} return NULL.

In pick_next_task_fair() we permanently go to retry

	if (rq->nr_running != rq->cfs.h_nr_running)
		return RETRY_TASK;

(rq->nr_running is not being decremented when rt_rq becomes
throttled).

No chances to unthrottle any rt_rq or to wake fair here,
because of rq is locked permanently and interrupts are
disabled.

2)In case of SMP this can cause a hang too. Although we unlock
rq in idle_balance(), interrupts are still disabled.

The solution is to check for available tasks in DL and RT
classes instead of checking for sum.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/fair.c  |    4 +++-
 kernel/sched/rt.c    |   10 ----------
 kernel/sched/sched.h |   12 ++++++++++++
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b956e70..10db4a8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6728,7 +6728,9 @@ static int idle_balance(struct rq *this_rq)
 
 out:
 	/* Is there a task of a high priority class? */
-	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
+	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
+	    (this_rq->dl.dl_nr_running ||
+	     (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
 		pulled_task = -1;
 
 	if (pulled_task) {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f3cee0a..d8cdf16 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -470,11 +470,6 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 		dequeue_rt_entity(rt_se);
 }
 
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
-}
-
 static int rt_se_boosted(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
@@ -545,11 +540,6 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 }
 
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled;
-}
-
 static inline const struct cpumask *sched_rt_period_mask(void)
 {
 	return cpu_online_mask;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 378bff7..f2de7a1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -423,6 +423,18 @@ struct rt_rq {
 #endif
 };
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+}
+#else
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled;
+}
+#endif
+
 /* Deadline class' related fields in a runqueue */
 struct dl_rq {
 	/* runqueue is an rbtree, ordered by deadline */



