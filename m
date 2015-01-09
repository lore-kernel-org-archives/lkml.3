Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbbAILpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:45:21 -0500
Received: from forward4l.mail.yandex.net ([84.201.143.137]:52186 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbbAILpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:45:19 -0500
Authentication-Results: smtp3m.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH] sched/dl: Prevent initialization of already set dl_timer
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Luca Abeni <luca.abeni@unitn.it>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Fri, 09 Jan 2015 14:45:13 +0300
Message-ID: <20150109114440.8605.19481.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__setparam_dl() may be called for a task which is already of
deadline class. If the task is throttled, we corrupt its dl_timer
when we are doing hrtimer_init() in init_dl_task_timer().

It seems that__setparam_dl() is not the place where we want
to use cancel_dl_timer(). It may unlock rq while the call chain
is long, and some of previous functions in the chain may be
unhappy for this reason (now and in the future). So, we just
try to cancel the timer, and in some situations we fail to do that.

If hrtimer_try_to_cancel() fails, than the handler is being
executed on other processor, and it's waiting for rq->lock.
The most probably the handler will take the lock right after
we release it.

So, let's pass the actions, which we do here usually here,
to the handler. It will unthrottle and queue us properly.

Reported-and-tested-by: Luca Abeni <luca.abeni@unitn.it>
Fixes: 67dfa1b756f2 "sched/deadline: Implement cancel_dl_timer() to use ..."
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 include/linux/sched/deadline.h |    2 ++
 kernel/sched/core.c            |   21 +++++++++++++++++----
 kernel/sched/deadline.c        |   10 +---------
 kernel/sched/sched.h           |    1 -
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 9d303b8..c70a7fc 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -21,4 +21,6 @@ static inline int dl_task(struct task_struct *p)
 	return dl_prio(p->prio);
 }
 
+extern enum hrtimer_restart dl_task_timer(struct hrtimer *timer);
+
 #endif /* _SCHED_DEADLINE_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0accc0..8fc8a2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1840,6 +1840,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	RB_CLEAR_NODE(&p->dl.rb_node);
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	p->dl.dl_timer.function = dl_task_timer;
 	__dl_clear_params(p);
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -3250,16 +3251,28 @@ static void
 __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+        struct hrtimer *timer = &dl_se->dl_timer;
+	struct rq *rq = task_rq(p);
+
+	/*
+	 * There may be a race with dl_task_timer. If it's pending and
+	 * we've failed to cancel it, timer's handler will unthrottle
+	 * the task right after p's rq is unlocked.
+	 */
+	if (!hrtimer_active(timer) || hrtimer_try_to_cancel(timer) != -1) {
+		dl_se->dl_throttled = 0;
+		dl_se->dl_new = 1;
+		dl_se->dl_yielded = 0;
+	} else {
+		dl_se->deadline = rq_clock(rq) + attr->sched_deadline;
+		dl_se->runtime = attr->sched_runtime;
+	}
 
-	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
 	dl_se->flags = attr->sched_flags;
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
-	dl_se->dl_throttled = 0;
-	dl_se->dl_new = 1;
-	dl_se->dl_yielded = 0;
 }
 
 /*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e5db8c6..8649bd6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -500,7 +500,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
  * updating (and the queueing back to dl_rq) will be done by the
  * next call to enqueue_task_dl().
  */
-static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
+enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 {
 	struct sched_dl_entity *dl_se = container_of(timer,
 						     struct sched_dl_entity,
@@ -559,14 +559,6 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void init_dl_task_timer(struct sched_dl_entity *dl_se)
-{
-	struct hrtimer *timer = &dl_se->dl_timer;
-
-	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	timer->function = dl_task_timer;
-}
-
 static
 int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a2a45c..ad3a2f0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1257,7 +1257,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern struct dl_bandwidth def_dl_bandwidth;
 extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
-extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
 
 unsigned long to_ratio(u64 period, u64 runtime);
 

