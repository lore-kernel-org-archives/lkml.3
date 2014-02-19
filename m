Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaBSCuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:50:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:28519 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751881AbaBSCuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:50:16 -0500
Date: Tue, 18 Feb 2014 21:50:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3] sched/deadline: Fix bad accounting of nr_running
Message-ID: <20140218215012.209059c0@gandalf.local.home>
In-Reply-To: <53022F2D.8040301@gmail.com>
References: <20140214235946.60a89b65@gandalf.local.home>
	<53022F2D.8040301@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Rationale for this odd behavior is that, when a task is throttled, it
> is removed only from the dl_rq, but we keep it on_rq (as this is not
> a "full dequeue", that is the task is not actually sleeping). But, it
> is also true that, while throttled a task behaves like it is sleeping
> (e.g., its timer will fire on a new CPU if the old one is dead). So,
> Steven's fix sounds also semantically correct.

Actually, it seems that I was hitting it again, but this time getting a
negative number. OK, after looking at the code a bit more, I think we
should update the runqueue nr_running only when the task is officially
enqueued and dequeued, and all accounting within, will not touch that
number.

----
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

By only updating the nr_running when the task is officially enqueued or
dequeued by the core scheduler, we can prevent the accounting of that
number from going out of sync.

Link: http://lkml.kernel.org/r/20140214235946.60a89b65@gandalf.local.home

For reference on my test programs:

  http://rostedt.homelinux.com/private/stress-cpu-hotplug
  http://rostedt.homelinux.com/private/deadline.c

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
v3. Only update nr_running in enqueue and dequeue of core scheduler calls

v2. cleaned up claws mail line wrapping crap

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..27cb282 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -238,7 +238,7 @@ void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 
 #endif /* CONFIG_SMP */
 
-static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
+static void __enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
 static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags);
 static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 				  int flags);
@@ -510,7 +510,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
 	if (p->on_rq) {
-		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
+		__enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (task_has_dl_policy(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
 		else
@@ -608,7 +608,7 @@ static void update_curr_dl(struct rq *rq)
 		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
 			dl_se->dl_throttled = 1;
 		else
-			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
+			__enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
 		if (!is_leftmost(curr, &rq->dl))
 			resched_task(curr);
@@ -809,7 +809,7 @@ static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
 	__dequeue_dl_entity(dl_se);
 }
 
-static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+static void __enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct task_struct *pi_task = rt_mutex_get_top_task(p);
 	struct sched_dl_entity *pi_se = &p->dl;
@@ -836,7 +836,11 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
+}
 
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	__enqueue_task_dl(rq, p, flags);
 	inc_nr_running(rq);
 }
 
