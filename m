Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3IYQi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:38:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3IYQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:38:23 -0400
Date: Wed, 25 Sep 2013 09:37:29 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-4314895165623879937f46d767673654662b570c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mst@redhat.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130922142054.GA11499@redhat.com>
References: <20130922142054.GA11499@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Micro-optimize by dropping unnecessary task_rq() calls
Git-Commit-ID: 4314895165623879937f46d767673654662b570c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:37:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4314895165623879937f46d767673654662b570c
Gitweb:     http://git.kernel.org/tip/4314895165623879937f46d767673654662b570c
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 22 Sep 2013 17:20:54 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 13:51:06 +0200

sched: Micro-optimize by dropping unnecessary task_rq() calls

We always know the rq used, let's just pass it around.
This seems to cut the size of scheduler core down a tiny bit:

Before:

  [linux]$ size kernel/sched/core.o.orig
     text    data     bss     dec     hex filename
    62760   16130    3876   82766   1434e kernel/sched/core.o.orig

After:

  [linux]$ size kernel/sched/core.o.patched
     text    data     bss     dec     hex filename
    62566   16130    3876   82572   1428c kernel/sched/core.o.patched

Probably speeds it up as well.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130922142054.GA11499@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |  6 +++---
 kernel/sched/stats.h | 46 ++++++++++++++++++++++++----------------------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2283c5..ac57967 100644
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
 
@@ -1839,7 +1839,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	trace_sched_switch(prev, next);
-	sched_info_switch(prev, next);
+	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index c7edee7..4ab7043 100644
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
@@ -111,15 +111,15 @@ static inline void sched_info_queued(struct task_struct *t)
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
@@ -128,32 +128,34 @@ static inline void sched_info_depart(struct task_struct *t)
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
