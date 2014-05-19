Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaESNKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:10:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaESNKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:10:46 -0400
Date: Mon, 19 May 2014 06:09:50 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-6d0909086bb3ceb22a5a482f27874d7e4b1bdbd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <20140508225830.2469.97461.stgit@localhost>
References: <20140508225830.2469.97461.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched,nohz: Change rq->
 nr_running always using wrappers
Git-Commit-ID: 6d0909086bb3ceb22a5a482f27874d7e4b1bdbd2
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

Commit-ID:  6d0909086bb3ceb22a5a482f27874d7e4b1bdbd2
Gitweb:     http://git.kernel.org/tip/6d0909086bb3ceb22a5a482f27874d7e4b1bdbd2
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Fri, 9 May 2014 03:00:14 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:41 +0900

sched,nohz: Change rq->nr_running always using wrappers

Sometimes nr_running may cross 2 but interrupt is not being
sent to rq's cpu. In this case we don't reenable timer.
Looks like, this may be a reason of rare unexpected effects,
if nohz is enabled.

Patch replaces all places of direct changing of nr_running
and makes add_nr_running() caring about crossing border.

Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140508225830.2469.97461.stgit@localhost
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/deadline.c  |  4 ++--
 kernel/sched/fair.c      |  8 ++++----
 kernel/sched/rt.c        |  4 ++--
 kernel/sched/sched.h     | 12 +++++++-----
 kernel/sched/stop_task.c |  4 ++--
 5 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 800e99b..e0a04ae 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -741,7 +741,7 @@ void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 
 	WARN_ON(!dl_prio(prio));
 	dl_rq->dl_nr_running++;
-	inc_nr_running(rq_of_dl_rq(dl_rq));
+	add_nr_running(rq_of_dl_rq(dl_rq), 1);
 
 	inc_dl_deadline(dl_rq, deadline);
 	inc_dl_migration(dl_se, dl_rq);
@@ -755,7 +755,7 @@ void dec_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	WARN_ON(!dl_prio(prio));
 	WARN_ON(!dl_rq->dl_nr_running);
 	dl_rq->dl_nr_running--;
-	dec_nr_running(rq_of_dl_rq(dl_rq));
+	sub_nr_running(rq_of_dl_rq(dl_rq), 1);
 
 	dec_dl_deadline(dl_rq, dl_se->deadline);
 	dec_dl_migration(dl_se, dl_rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 26ec668..f7cac2b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3325,7 +3325,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	}
 
 	if (!se)
-		rq->nr_running -= task_delta;
+		sub_nr_running(rq, task_delta);
 
 	cfs_rq->throttled = 1;
 	cfs_rq->throttled_clock = rq_clock(rq);
@@ -3376,7 +3376,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	}
 
 	if (!se)
-		rq->nr_running += task_delta;
+		add_nr_running(rq, task_delta);
 
 	/* determine whether we need to wake up potentially idle cpu */
 	if (rq->curr == rq->idle && rq->cfs.nr_running)
@@ -3908,7 +3908,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!se) {
 		update_rq_runnable_avg(rq, rq->nr_running);
-		inc_nr_running(rq);
+		add_nr_running(rq, 1);
 	}
 	hrtick_update(rq);
 }
@@ -3968,7 +3968,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	if (!se) {
-		dec_nr_running(rq);
+		sub_nr_running(rq, 1);
 		update_rq_runnable_avg(rq, 1);
 	}
 	hrtick_update(rq);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7795e29..0ebfd7a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -973,7 +973,7 @@ dequeue_top_rt_rq(struct rt_rq *rt_rq)
 
 	BUG_ON(!rq->nr_running);
 
-	rq->nr_running -= rt_rq->rt_nr_running;
+	sub_nr_running(rq, rt_rq->rt_nr_running);
 	rt_rq->rt_queued = 0;
 }
 
@@ -989,7 +989,7 @@ enqueue_top_rt_rq(struct rt_rq *rt_rq)
 	if (rt_rq_throttled(rt_rq) || !rt_rq->rt_nr_running)
 		return;
 
-	rq->nr_running += rt_rq->rt_nr_running;
+	add_nr_running(rq, rt_rq->rt_nr_running);
 	rt_rq->rt_queued = 1;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b2cbe81..600e229 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1206,12 +1206,14 @@ extern void update_idle_cpu_load(struct rq *this_rq);
 
 extern void init_task_runnable_average(struct task_struct *p);
 
-static inline void inc_nr_running(struct rq *rq)
+static inline void add_nr_running(struct rq *rq, unsigned count)
 {
-	rq->nr_running++;
+	unsigned prev_nr = rq->nr_running;
+
+	rq->nr_running = prev_nr + count;
 
 #ifdef CONFIG_NO_HZ_FULL
-	if (rq->nr_running == 2) {
+	if (prev_nr < 2 && rq->nr_running >= 2) {
 		if (tick_nohz_full_cpu(rq->cpu)) {
 			/* Order rq->nr_running write against the IPI */
 			smp_wmb();
@@ -1221,9 +1223,9 @@ static inline void inc_nr_running(struct rq *rq)
 #endif
 }
 
-static inline void dec_nr_running(struct rq *rq)
+static inline void sub_nr_running(struct rq *rq, unsigned count)
 {
-	rq->nr_running--;
+	rq->nr_running -= count;
 }
 
 static inline void rq_last_tick_reset(struct rq *rq)
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index d6ce65d..bfe0eda 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -41,13 +41,13 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 static void
 enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
-	inc_nr_running(rq);
+	add_nr_running(rq, 1);
 }
 
 static void
 dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
-	dec_nr_running(rq);
+	sub_nr_running(rq, 1);
 }
 
 static void yield_task_stop(struct rq *rq)
