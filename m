Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaBUVbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:31:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbaBUVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:31:31 -0500
Date: Fri, 21 Feb 2014 13:30:54 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-3f1d2a318171bf61850d4e5a72031271e5aada76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, tkhai@yandex.ru,
        tglx@linutronix.de, juri.lelli@gmail.com, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, tkhai@yandex.ru,
        tglx@linutronix.de, dan.carpenter@oracle.com, juri.lelli@gmail.com
In-Reply-To: <20140212094930.GB3545@laptop.programming.kicks-ass.net>
References: <20140212094930.GB3545@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix hotplug task migration
Git-Commit-ID: 3f1d2a318171bf61850d4e5a72031271e5aada76
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

Commit-ID:  3f1d2a318171bf61850d4e5a72031271e5aada76
Gitweb:     http://git.kernel.org/tip/3f1d2a318171bf61850d4e5a72031271e5aada76
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 12 Feb 2014 10:49:30 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:18 +0100

sched: Fix hotplug task migration

Dan Carpenter reported:

> kernel/sched/rt.c:1347 pick_next_task_rt() warn: variable dereferenced before check 'prev' (see line 1338)
> kernel/sched/deadline.c:1011 pick_next_task_dl() warn: variable dereferenced before check 'prev' (see line 1005)

Kirill also spotted that migrate_tasks() will have an instant NULL
deref because pick_next_task() will immediately deref prev.

Instead of fixing all the corner cases because migrate_tasks() can
pass in a NULL prev task in the unlikely case of hot-un-plug, provide
a fake task such that we can remove all the NULL checks from the far
more common paths.

A further problem; not previously spotted; is that because we pushed
pre_schedule() and idle_balance() into pick_next_task() we now need to
avoid those getting called and pulling more tasks on our dying CPU.

We avoid pull_{dl,rt}_task() by setting fake_task.prio to MAX_PRIO+1.
We also note that since we call pick_next_task() exactly the amount of
times we have runnable tasks present, we should never land in
idle_balance().

Fixes: 38033c37faab ("sched: Push down pre_schedule() and idle_balance()")
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140212094930.GB3545@laptop.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c      | 18 +++++++++++++++++-
 kernel/sched/deadline.c  |  3 +--
 kernel/sched/fair.c      |  5 ++---
 kernel/sched/idle_task.c |  3 +--
 kernel/sched/rt.c        |  3 +--
 kernel/sched/sched.h     |  5 +++++
 kernel/sched/stop_task.c |  3 +--
 7 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fb9764f..49db434 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4681,6 +4681,22 @@ static void calc_load_migrate(struct rq *rq)
 		atomic_long_add(delta, &calc_load_tasks);
 }
 
+static void put_prev_task_fake(struct rq *rq, struct task_struct *prev)
+{
+}
+
+static const struct sched_class fake_sched_class = {
+	.put_prev_task = put_prev_task_fake,
+};
+
+static struct task_struct fake_task = {
+	/*
+	 * Avoid pull_{rt,dl}_task()
+	 */
+	.prio = MAX_PRIO + 1,
+	.sched_class = &fake_sched_class,
+};
+
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
@@ -4721,7 +4737,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq, NULL);
+		next = pick_next_task(rq, &fake_task);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ed31ef6..bfeb84e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1008,8 +1008,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 
 	dl_se = pick_next_dl_entity(rq, dl_rq);
 	BUG_ON(!dl_se);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 40c758b..e884e45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4690,7 +4690,7 @@ again:
 	if (!cfs_rq->nr_running)
 		goto idle;
 
-	if (!prev || prev->sched_class != &fair_sched_class)
+	if (prev->sched_class != &fair_sched_class)
 		goto simple;
 
 	/*
@@ -4766,8 +4766,7 @@ simple:
 	if (!cfs_rq->nr_running)
 		goto idle;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 
 	do {
 		se = pick_next_entity(cfs_rq, NULL);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index f7d03af..53ff9e7 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -26,8 +26,7 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *
 pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 72f9ec7..65c2d68 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1344,8 +1344,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	if (rt_rq_throttled(rt_rq))
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 
 	p = _pick_next_task_rt(rq);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 92018f9..d276147 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1147,6 +1147,11 @@ struct sched_class {
 #endif
 };
 
+static inline void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index a4147c9..d6ce65d 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -31,8 +31,7 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 	if (!stop || !stop->on_rq)
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 
 	stop->se.exec_start = rq_clock_task(rq);
 
