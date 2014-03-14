Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaCNWSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:18:06 -0400
Received: from forward9l.mail.yandex.net ([84.201.143.142]:54481 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaCNWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:18:03 -0400
X-Yandex-Uniq: ef067c60-9070-4f69-91d4-40feeaa037d4
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1394835307.18748.34.camel@HP-250-G1-Notebook-PC>
Subject: [PATCH 4/4] sched: Revert commit 4c6c4e38c4e9
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Mar 2014 02:15:07 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 4c6c4e38c4e9 [sched/core: Fix endless loop in
pick_next_task()], which is not necessary after [sched/rt: Substract number
of tasks of throttled queues from rq->nr_running]

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  |    4 +---
 kernel/sched/rt.c    |   10 ++++++++++
 kernel/sched/sched.h |   12 ------------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e9bd0b..0d39ef7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6726,9 +6726,7 @@ static int idle_balance(struct rq *this_rq)
 
 out:
 	/* Is there a task of a high priority class? */
-	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
-	    (this_rq->dl.dl_nr_running ||
-	     (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
+	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
 		pulled_task = -1;
 
 	if (pulled_task) {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c961350..ec0933e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -493,6 +493,11 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 		dequeue_rt_entity(rt_se);
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+}
+
 static int rt_se_boosted(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
@@ -569,6 +574,11 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 	dequeue_top_rt_rq(rt_rq);
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled;
+}
+
 static inline const struct cpumask *sched_rt_period_mask(void)
 {
 	return cpu_online_mask;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8327b4e..e8493b4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -425,18 +425,6 @@ struct rt_rq {
 #endif
 };
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
-}
-#else
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled;
-}
-#endif
-
 /* Deadline class' related fields in a runqueue */
 struct dl_rq {
 	/* runqueue is an rbtree, ordered by deadline */




