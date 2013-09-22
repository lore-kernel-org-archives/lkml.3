Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3IVOTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab3IVOTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:19:10 -0400
Date: Sun, 22 Sep 2013 17:20:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Olivier Langlois <olivier@trillion01.com>
Subject: [PATCH] sched: drop un-necessary task_rq calls
Message-ID: <20130922142054.GA11499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always know the rq used, let's just pass it around.
This seems to cut the size of scheduler core down a tiny bit.

Before:
[linux]$ size kernel/sched/core-old.o 
   text    data     bss     dec     hex filename
  62760   16130    3876   82766   1434e kernel/sched/core.o
After:
[linux]$ size kernel/sched/core-rq.o 
   text    data     bss     dec     hex filename
  62566   16130    3876   82572   1428c kernel/sched/core-rq.o

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 kernel/sched/core.c  |  6 +++---
 kernel/sched/stats.h | 46 ++++++++++++++++++++++++----------------------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 05c39f0..8558187 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -767,14 +767,14 @@ static void set_load_weight(struct task_struct *p)
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
-	sched_info_queued(p);
+	sched_info_queued(rq, p);
 	p->sched_class->enqueue_task(rq, p, flags);
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
-	sched_info_dequeued(p);
+	sched_info_dequeued(rq, p);
 	p->sched_class->dequeue_task(rq, p, flags);
 }
 
@@ -1853,7 +1853,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	trace_sched_switch(prev, next);
-	sched_info_switch(prev, next);
+	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 5aef494..a3802d6 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -59,9 +59,9 @@ static inline void sched_info_reset_dequeued(struct task_struct *t)
  * from dequeue_task() to account for possible rq->clock skew across cpus. The
  * delta taken on each cpu would annul the skew.
  */
-static inline void sched_info_dequeued(struct task_struct *t)
+static inline void sched_info_dequeued(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
+	unsigned long long now = rq_clock(rq), delta = 0;
 
 	if (unlikely(sched_info_on()))
 		if (t->sched_info.last_queued)
@@ -69,7 +69,7 @@ static inline void sched_info_dequeued(struct task_struct *t)
 	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 
-	rq_sched_info_dequeued(task_rq(t), delta);
+	rq_sched_info_dequeued(rq, delta);
 }
 
 /*
@@ -77,9 +77,9 @@ static inline void sched_info_dequeued(struct task_struct *t)
  * long it was waiting to run.  We also note when it began so that we
  * can keep stats on how long its timeslice is.
  */
-static void sched_info_arrive(struct task_struct *t)
+static void sched_info_arrive(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
+	unsigned long long now = rq_clock(rq), delta = 0;
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
@@ -88,7 +88,7 @@ static void sched_info_arrive(struct task_struct *t)
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
 
-	rq_sched_info_arrive(task_rq(t), delta);
+	rq_sched_info_arrive(rq, delta);
 }
 
 /*
@@ -96,11 +96,11 @@ static void sched_info_arrive(struct task_struct *t)
  * the timestamp if it is already not set.  It's assumed that
  * sched_info_dequeued() will clear that stamp when appropriate.
  */
-static inline void sched_info_queued(struct task_struct *t)
+static inline void sched_info_queued(struct rq *rq, struct task_struct *t)
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = rq_clock(task_rq(t));
+			t->sched_info.last_queued = rq_clock(rq);
 }
 
 /*
@@ -110,15 +110,15 @@ static inline void sched_info_queued(struct task_struct *t)
  * sched_info_queued() to mark that it has now again started waiting on
  * the runqueue.
  */
-static inline void sched_info_depart(struct task_struct *t)
+static inline void sched_info_depart(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long delta = rq_clock(task_rq(t)) -
+	unsigned long long delta = rq_clock(rq) -
 					t->sched_info.last_arrival;
 
-	rq_sched_info_depart(task_rq(t), delta);
+	rq_sched_info_depart(rq, delta);
 
 	if (t->state == TASK_RUNNING)
-		sched_info_queued(t);
+		sched_info_queued(rq, t);
 }
 
 /*
@@ -127,32 +127,34 @@ static inline void sched_info_depart(struct task_struct *t)
  * the idle task.)  We are only called when prev != next.
  */
 static inline void
-__sched_info_switch(struct task_struct *prev, struct task_struct *next)
+__sched_info_switch(struct rq *rq,
+		    struct task_struct *prev, struct task_struct *next)
 {
-	struct rq *rq = task_rq(prev);
-
 	/*
 	 * prev now departs the cpu.  It's not interesting to record
 	 * stats about how efficient we were at scheduling the idle
 	 * process, however.
 	 */
 	if (prev != rq->idle)
-		sched_info_depart(prev);
+		sched_info_depart(rq, prev);
 
 	if (next != rq->idle)
-		sched_info_arrive(next);
+		sched_info_arrive(rq, next);
 }
 static inline void
-sched_info_switch(struct task_struct *prev, struct task_struct *next)
+sched_info_switch(struct rq *rq,
+		  struct task_struct *prev, struct task_struct *next)
 {
 	if (unlikely(sched_info_on()))
-		__sched_info_switch(prev, next);
+		__sched_info_switch(rq, prev, next);
 }
 #else
-#define sched_info_queued(t)			do { } while (0)
+#define sched_info_queued(rq, t)		do { } while (0)
 #define sched_info_reset_dequeued(t)	do { } while (0)
-#define sched_info_dequeued(t)			do { } while (0)
-#define sched_info_switch(t, next)		do { } while (0)
+#define sched_info_dequeued(rq, t)		do { } while (0)
+#define sched_info_depart(rq, t)		do { } while (0)
+#define sched_info_arrive(rq, next)		do { } while (0)
+#define sched_info_switch(rq, t, next)		do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
 /*
-- 
MST
