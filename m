Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaEMSQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:16:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaEMSQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:16:01 -0400
Date: Tue, 13 May 2014 20:15:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140513181549.GE5226@laptop.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <20140513072208.GB7980@gmail.com>
 <5371BCF8.7030708@cn.fujitsu.com>
 <20140513100333.GW30445@twins.programming.kicks-ass.net>
 <20140513171436.GA8672@gmail.com>
 <20140513173032.GD5226@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140513173032.GD5226@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Anyway, ideally we'd do something like the below, except of course that
it'll break userspace :-(

And that is why I loathe tracepoints.

Also, I've not looked at the code difference and or performance
implications.

---
Subject: sched: Add enqueue information to trace_sched_wakeup()

trace_sched_switch() shows task dequeues, trace_sched_wakeup() shows all
wakeups, including those that do not enqueue (because the task is
still enqueued).

In order to easy matching dequeue to enqueue, add enqueue information to
trace_sched_wakeup().

Replace the trace_sched_wakeup() success argument which is the
try_to_wake_up() return value and always true (since we removed
tracing the false path).

Not-signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/trace/events/sched.h | 16 ++++++++--------
 kernel/sched/core.c          | 42 ++++++++++++++++++++++--------------------
 kernel/sched/sched.h         |  3 ++-
 3 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67e1bbf83695..5e5037f794f2 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -55,15 +55,15 @@ TRACE_EVENT(sched_kthread_stop_ret,
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
 
-	TP_PROTO(struct task_struct *p, int success),
+	TP_PROTO(struct task_struct *p, int enqueue),
 
-	TP_ARGS(__perf_task(p), success),
+	TP_ARGS(__perf_task(p), enqueue),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
-		__field(	int,	success			)
+		__field(	int,	enqueue			)
 		__field(	int,	target_cpu		)
 	),
 
@@ -71,24 +71,24 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-		__entry->success	= success;
+		__entry->enqueue	= enqueue;
 		__entry->target_cpu	= task_cpu(p);
 	),
 
-	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
+	TP_printk("comm=%s pid=%d prio=%d enqueue=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->target_cpu)
+		  __entry->enqueue, __entry->target_cpu)
 );
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
-	     TP_PROTO(struct task_struct *p, int success),
+	     TP_PROTO(struct task_struct *p, int enqueue),
 	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for waking up a new task:
  */
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
-	     TP_PROTO(struct task_struct *p, int success),
+	     TP_PROTO(struct task_struct *p, int enqueue),
 	     TP_ARGS(p, success));
 
 #ifdef CREATE_TRACE_POINTS
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f1a087..e29b87748680 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1461,10 +1461,22 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
  * Mark the task runnable and perform wakeup-preemption.
  */
 static void
-ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
+ttwu_do_wakeup(struct rq *rq, struct task_struct *p,
+	       int wake_flags, en_flags)
 {
+	bool enqueue = wake_flags & WF_ENQUEUE;
+
+	if (enqueue) {
+#ifdef CONFIG_SMP
+		if (p->sched_contributes_to_load)
+			rq->nr_uninterruptible--;
+#endif
+
+		ttwu_activate(rq, p, en_flags);
+	}
+
 	check_preempt_curr(rq, p, wake_flags);
-	trace_sched_wakeup(p, true);
+	trace_sched_wakeup(p, enqueue);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -1485,18 +1497,6 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 #endif
 }
 
-static void
-ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
-{
-#ifdef CONFIG_SMP
-	if (p->sched_contributes_to_load)
-		rq->nr_uninterruptible--;
-#endif
-
-	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
-	ttwu_do_wakeup(rq, p, wake_flags);
-}
-
 /*
  * Called in case the task @p isn't fully descheduled from its runqueue,
  * in this case we must do a remote wakeup. Its a 'light' wakeup though,
@@ -1512,7 +1512,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	if (p->on_rq) {
 		/* check_preempt_curr() may use rq clock */
 		update_rq_clock(rq);
-		ttwu_do_wakeup(rq, p, wake_flags);
+		ttwu_do_wakeup(rq, p, wake_flags, 0);
 		ret = 1;
 	}
 	__task_rq_unlock(rq);
@@ -1532,7 +1532,8 @@ static void sched_ttwu_pending(void)
 	while (llist) {
 		p = llist_entry(llist, struct task_struct, wake_entry);
 		llist = llist_next(llist);
-		ttwu_do_activate(rq, p, 0);
+		ttwu_do_wakeup(rq, p, WF_ENQUEUE, 
+			       ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 	}
 
 	raw_spin_unlock(&rq->lock);
@@ -1604,7 +1605,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 #endif
 
 	raw_spin_lock(&rq->lock);
-	ttwu_do_activate(rq, p, 0);
+	ttwu_do_wakeup(rq, p, WF_ENQUEUE, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 	raw_spin_unlock(&rq->lock);
 }
 
@@ -1707,10 +1708,11 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!(p->state & TASK_NORMAL))
 		goto out;
 
-	if (!p->on_rq)
-		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+	if (p->on_rq)
+		ttwu_do_wakeup(rq, p, 0, 0);
+	else
+		ttwu_do_wakeup(rq, p, WF_ENQUEUE, ENQUEUE_WAKEUP);
 
-	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b2cbe81308af..d865415ea1d2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1026,7 +1026,8 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakeup */
 #define WF_FORK		0x02		/* child wakeup after fork */
-#define WF_MIGRATED	0x4		/* internal use, task got migrated */
+#define WF_MIGRATED	0x04		/* internal use, task got migrated */
+#define WF_ENQUEUE	0x08
 
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
