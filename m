Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab3GXL7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:59:44 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:48273 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3GXL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:59:43 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] sched/rt: Fix pull_rt_task() skips not overloaded rqs
MIME-Version: 1.0
Message-Id: <669251374667179@web8f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 24 Jul 2013 15:59:39 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main patch profit is deletion of the following check
at the beginning of pull_rt_task():

	if (likely(!rt_overloaded(this_rq)))
		return 0;

This check makes pull_rt_task() nearly useless, because
it kills all cases like "last RT task has just gone away".
The check is better suitable for push_rt_task().

So, kill the check, now unusable rt_overloaded() and rto_count.

Move root_domain's refcount to the bottom of the structure
to keep its fields aligned.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/rt.c    |   19 -------------------
 kernel/sched/sched.h |    3 +--
 2 files changed, 1 insertions(+), 21 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..cf297a7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -229,26 +229,12 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 #ifdef CONFIG_SMP
 
-static inline int rt_overloaded(struct rq *rq)
-{
-	return atomic_read(&rq->rd->rto_count);
-}
-
 static inline void rt_set_overload(struct rq *rq)
 {
 	if (!rq->online)
 		return;
 
 	cpumask_set_cpu(rq->cpu, rq->rd->rto_mask);
-	/*
-	 * Make sure the mask is visible before we set
-	 * the overload count. That is checked to determine
-	 * if we should look at the mask. It would be a shame
-	 * if we looked at the mask, but the mask was not
-	 * updated yet.
-	 */
-	wmb();
-	atomic_inc(&rq->rd->rto_count);
 }
 
 static inline void rt_clear_overload(struct rq *rq)
@@ -256,8 +242,6 @@ static inline void rt_clear_overload(struct rq *rq)
 	if (!rq->online)
 		return;
 
-	/* the order here really doesn't matter */
-	atomic_dec(&rq->rd->rto_count);
 	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
@@ -1627,9 +1611,6 @@ static int pull_rt_task(struct rq *this_rq)
 	struct task_struct *p;
 	struct rq *src_rq;
 
-	if (likely(!rt_overloaded(this_rq)))
-		return 0;
-
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4c1cb80..1f36afb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -374,8 +374,6 @@ struct rt_rq {
  *
  */
 struct root_domain {
-	atomic_t refcount;
-	atomic_t rto_count;
 	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
@@ -386,6 +384,7 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	struct cpupri cpupri;
+	atomic_t refcount;
 };
 
 extern struct root_domain def_root_domain;
