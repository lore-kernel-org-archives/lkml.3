Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaBONIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 08:08:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:40643 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050AbaBONIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:08:07 -0500
Date: Sat, 15 Feb 2014 08:08:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] sched/deadline: Fix bad accounting of nr_running
Message-ID: <20140215080806.4b6a1c9b@gandalf.local.home>
In-Reply-To: <20140215095207.GI14089@laptop.programming.kicks-ass.net>
References: <20140214235946.60a89b65@gandalf.local.home>
	<20140215095207.GI14089@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

By moving the dec_nr_running() from dequeue_task_dl() to
__dequeue_task_dl(), everything works again. That is, I can run the
deadline test program and then run the stress-cpu-hotplug() and all
would be fine.

For reference on my test programs:

  http://rostedt.homelinux.com/private/stress-cpu-hotplug
  http://rostedt.homelinux.com/private/deadline.c

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

v2. cleaned up claws mail line wrapping crap

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..84c2454 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -844,14 +844,14 @@ static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
 	dequeue_dl_entity(&p->dl);
 	dequeue_pushable_dl_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_curr_dl(rq);
 	__dequeue_task_dl(rq, p, flags);
-
-	dec_nr_running(rq);
 }
 
 /*
