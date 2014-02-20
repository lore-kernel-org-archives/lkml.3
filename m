Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaBTITt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:19:49 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34210 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaBTITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:19:48 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, rostedt@goodmis.org
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH v4] sched/deadline: Fix bad accounting of nr_running
Date: Thu, 20 Feb 2014 09:19:39 +0100
Message-Id: <1392884379-13744-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Rostedt's v3: https://lkml.org/lkml/2014/2/18/882

My test suite was locking up hard when enabling mmiotracer. This was due
to the mmiotracer placing all but one CPU offline. I found this out
when I was able to reproduce the bug with just my stress-cpu-hotplug
test. This bug baffled me because it would not always trigger, and
would only trigger on the first run after boot up. The
stress-cpu-hotplug test would crash hard the first run, or never crash
at all. But a new reboot may cause it to crash on the first run again.

I spent all week bisecting this, as I couldn't find a consistent
reproducer. I finally narrowed it down to the sched deadline patches,
and even more peculiar, to the commit that added the sched
deadline boot up self test to the latency tracer. Then it dawned on me
to what the bug was.

All it took was to run a task under sched deadline to screw up the CPU
hot plugging. This explained why it would lock up only on the first run
of the stress-cpu-hotplug test. The bug happened when the boot up self
test of the schedule latency tracer would test a deadline task. The
deadline task would corrupt something that would cause CPU hotplug to
fail. If it didn't corrupt it, the stress test would always work
(there's no other sched deadline tasks that would run to cause
problems). If it did corrupt on boot up, the first test would lockup
hard.

I proved this theory by running my deadline test program on another box,
and then run the stress-cpu-hotplug test, and it would now consistently
lock up. I could run stress-cpu-hotplug over and over with no problem,
but once I ran the deadline test, the next run of the
stress-cpu-hotplug would lock hard.

After adding lots of tracing to the code, I found the cause. The
function tracer showed that migrate_tasks() was stuck in an infinite
loop, where rq->nr_running never equaled 1 to break out of it. When I
added a trace_printk() to see what that number was, it was 335 and
never decrementing!

Looking at the deadline code I found:

static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags) {
	dequeue_dl_entity(&p->dl);
	dequeue_pushable_dl_task(rq, p);
}

static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags) {
	update_curr_dl(rq);
	__dequeue_task_dl(rq, p, flags);

	dec_nr_running(rq);
}

And this:

	if (dl_runtime_exceeded(rq, dl_se)) {
		__dequeue_task_dl(rq, curr, 0);
		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
			dl_se->dl_throttled = 1;
		else
			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);

		if (!is_leftmost(curr, &rq->dl))
			resched_task(curr);
	}

Notice how we call __dequeue_task_dl() and in the else case we
call enqueue_task_dl()? Also notice that dequeue_task_dl() has
underscores where enqueue_task_dl() does not. The enqueue_task_dl()
calls inc_nr_running(rq), but __dequeue_task_dl() does not. This is
where we get nr_running out of sync.

[snip]

Another point where nr_running can get out of sync is when the dl_timer
fires:

	dl_se->dl_throttled = 0;
	if (p->on_rq) {
		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
		if (task_has_dl_policy(rq->curr))
			check_preempt_curr_dl(rq, p, 0);
		else
			resched_task(rq->curr);

This patch does two things:

 - correctly accounts for throttled tasks (that are now considered
   !running);

 - fixes the bug, updating nr_running from {inc,dec}_dl_tasks(),
   since we risk to update it twice in some situations (e.g., a
   task is dequeued while it has exceeded its budget).

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/deadline.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..b819577 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -717,6 +717,7 @@ void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 
 	WARN_ON(!dl_prio(prio));
 	dl_rq->dl_nr_running++;
+	inc_nr_running(rq_of_dl_rq(dl_rq));
 
 	inc_dl_deadline(dl_rq, deadline);
 	inc_dl_migration(dl_se, dl_rq);
@@ -730,6 +731,7 @@ void dec_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	WARN_ON(!dl_prio(prio));
 	WARN_ON(!dl_rq->dl_nr_running);
 	dl_rq->dl_nr_running--;
+	dec_nr_running(rq_of_dl_rq(dl_rq));
 
 	dec_dl_deadline(dl_rq, dl_se->deadline);
 	dec_dl_migration(dl_se, dl_rq);
@@ -836,8 +838,6 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
-
-	inc_nr_running(rq);
 }
 
 static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
@@ -850,8 +850,6 @@ static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_curr_dl(rq);
 	__dequeue_task_dl(rq, p, flags);
-
-	dec_nr_running(rq);
 }
 
 /*
-- 
1.7.9.5

