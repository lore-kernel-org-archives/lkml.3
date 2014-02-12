Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBLOGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:06:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBLOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:06:34 -0500
Date: Wed, 12 Feb 2014 15:06:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [tip:sched/core] sched: Push put_prev_task() into
 pick_next_task( )
Message-ID: <20140212140620.GD9987@twins.programming.kicks-ass.net>
References: <1328936700.2476.17.camel@laptop>
 <tip-606dba2e289446600a0b68422ed2019af5355c12@git.kernel.org>
 <124891392188453@web4h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <124891392188453@web4h.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:00:53AM +0400, Kirill Tkhai wrote:
> > @@ -4748,7 +4743,7 @@ static void migrate_tasks(unsigned int dead_cpu)
> >                  if (rq->nr_running == 1)
> >                          break;
> >
> > - next = pick_next_task(rq);
> > + next = pick_next_task(rq, NULL);
> 
> pick_next_task() firstly checks for prev->sched_class, doesn't it ???
> 
> The same for pick_next_task_rt().


OK, how about something like this?

---
Subject: sched: Fix hotplug task migration
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 12 Feb 2014 10:49:30 +0100

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140212094930.GB3545@laptop.programming.kicks-ass.net
---
 kernel/sched/core.c      |   18 +++++++++++++++++-
 kernel/sched/deadline.c  |    3 +--
 kernel/sched/fair.c      |    5 ++---
 kernel/sched/idle_task.c |    3 +--
 kernel/sched/rt.c        |    3 +--
 kernel/sched/stop_task.c |    3 +--
 6 files changed, 23 insertions(+), 12 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4681,6 +4681,22 @@ static void calc_load_migrate(struct rq
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
@@ -4721,7 +4737,7 @@ static void migrate_tasks(unsigned int d
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq, NULL);
+		next = pick_next_task(rq, &fake_task);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1008,8 +1008,7 @@ struct task_struct *pick_next_task_dl(st
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	prev->sched_class->put_prev_task(rq, prev);
 
 	dl_se = pick_next_dl_entity(rq, dl_rq);
 	BUG_ON(!dl_se);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4690,7 +4690,7 @@ pick_next_task_fair(struct rq *rq, struc
 	if (!cfs_rq->nr_running)
 		goto idle;
 
-	if (!prev || prev->sched_class != &fair_sched_class)
+	if (prev->sched_class != &fair_sched_class)
 		goto simple;
 
 	/*
@@ -4766,8 +4766,7 @@ pick_next_task_fair(struct rq *rq, struc
 	if (!cfs_rq->nr_running)
 		goto idle;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	prev->sched_class->put_prev_task(rq, prev);
 
 	do {
 		se = pick_next_entity(cfs_rq, NULL);
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -26,8 +26,7 @@ static void check_preempt_curr_idle(stru
 static struct task_struct *
 pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	prev->sched_class->put_prev_task(rq, prev);
 
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1344,8 +1344,7 @@ pick_next_task_rt(struct rq *rq, struct
 	if (rt_rq_throttled(rt_rq))
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	prev->sched_class->put_prev_task(rq, prev);
 
 	p = _pick_next_task_rt(rq);
 
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -31,8 +31,7 @@ pick_next_task_stop(struct rq *rq, struc
 	if (!stop || !stop->on_rq)
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
+	prev->sched_class->put_prev_task(rq, prev);
 
 	stop->se.exec_start = rq_clock_task(rq);
 
