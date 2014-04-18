Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaDRNIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:08:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38813 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:08:15 -0400
Date: Fri, 18 Apr 2014 06:07:42 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-46383648b3c769fa74794ae6425ab993fc113bdb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <1394835307.18748.34.camel@HP-250-G1-Notebook-PC>
References: <1394835307.18748.34.camel@HP-250-G1-Notebook-PC>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Revert commit 4c6c4e38c4e9 ("sched/core:
  Fix endless loop in pick_next_task()")
Git-Commit-ID: 46383648b3c769fa74794ae6425ab993fc113bdb
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

Commit-ID:  46383648b3c769fa74794ae6425ab993fc113bdb
Gitweb:     http://git.kernel.org/tip/46383648b3c769fa74794ae6425ab993fc113bdb
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Sat, 15 Mar 2014 02:15:07 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:29 +0200

sched: Revert commit 4c6c4e38c4e9 ("sched/core: Fix endless loop in pick_next_task()")

This reverts commit 4c6c4e38c4e9 ("sched/core: Fix endless loop in
pick_next_task()"), which is not necessary after ("sched/rt: Substract number
of tasks of throttled queues from rq->nr_running").

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
[conflict resolution with stop task checking patch]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394835307.18748.34.camel@HP-250-G1-Notebook-PC
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  |  5 +----
 kernel/sched/rt.c    | 10 ++++++++++
 kernel/sched/sched.h | 12 ------------
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5e157f1..43232b8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6732,10 +6732,7 @@ static int idle_balance(struct rq *this_rq)
 
 out:
 	/* Is there a task of a high priority class? */
-	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
-	    ((this_rq->stop && this_rq->stop->on_rq) ||
-	     this_rq->dl.dl_nr_running ||
-	     (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
+	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
 		pulled_task = -1;
 
 	if (pulled_task) {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2add019..7795e29 100644
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
index c8d9ee4..b2cbe81 100644
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
