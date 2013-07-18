Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3GRSgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:36:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061Ab3GRSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:36:05 -0400
Date: Thu, 18 Jul 2013 20:30:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tracing/perf: reimplement TP_perf_assign() logic
Message-ID: <20130718183041.GA4068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718183018.GA4043@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch tries to avoid the costly perf_trace_buf_* calls
when possible but there is a problem. We can only do this if
__task == NULL, perf_tp_event(task != NULL) has the additional
code for this case.

Unfortunately, TP_perf_assign/__perf_xxx which changes the default
values of __count/__task variables for perf_trace_buf_submit() is
called "too late", after we already did perf_trace_buf_prepare(),
and the optimization above can't work.

So this patch simply embeds __perf_xxx() into TP_ARGS(), this way
DECLARE_EVENT_CLASS() can use the result of assignments hidden in
"args" right after ftrace_get_offsets_##call() which is mostly
trivial. This allows us to have the fast-path "__task != NULL"
check at the start, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/sched.h |   16 +++-------------
 include/trace/ftrace.h       |   19 +++++++++++--------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 249c024..2e7d994 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -57,7 +57,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 
 	TP_PROTO(struct task_struct *p, int success),
 
-	TP_ARGS(p, success),
+	TP_ARGS(__perf_task(p), success),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -73,9 +73,6 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 		__entry->prio		= p->prio;
 		__entry->success	= success;
 		__entry->target_cpu	= task_cpu(p);
-	)
-	TP_perf_assign(
-		__perf_task(p);
 	),
 
 	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
@@ -313,7 +310,7 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 
 	TP_PROTO(struct task_struct *tsk, u64 delay),
 
-	TP_ARGS(tsk, delay),
+	TP_ARGS(__perf_task(tsk), __perf_count(delay)),
 
 	TP_STRUCT__entry(
 		__array( char,	comm,	TASK_COMM_LEN	)
@@ -325,10 +322,6 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
 		__entry->pid	= tsk->pid;
 		__entry->delay	= delay;
-	)
-	TP_perf_assign(
-		__perf_count(delay);
-		__perf_task(tsk);
 	),
 
 	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
@@ -376,7 +369,7 @@ DECLARE_EVENT_CLASS(sched_stat_runtime,
 
 	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
 
-	TP_ARGS(tsk, runtime, vruntime),
+	TP_ARGS(tsk, __perf_count(runtime), vruntime),
 
 	TP_STRUCT__entry(
 		__array( char,	comm,	TASK_COMM_LEN	)
@@ -390,9 +383,6 @@ DECLARE_EVENT_CLASS(sched_stat_runtime,
 		__entry->pid		= tsk->pid;
 		__entry->runtime	= runtime;
 		__entry->vruntime	= vruntime;
-	)
-	TP_perf_assign(
-		__perf_count(runtime);
 	),
 
 	TP_printk("comm=%s pid=%d runtime=%Lu [ns] vruntime=%Lu [ns]",
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index aed594a..8886877 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -503,8 +503,14 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
-#undef TP_perf_assign
-#define TP_perf_assign(args...)
+#undef __perf_addr
+#define __perf_addr(a)	(a)
+
+#undef __perf_count
+#define __perf_count(c)	(c)
+
+#undef __perf_task
+#define __perf_task(t)	(t)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -632,16 +638,13 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
 #undef __perf_addr
-#define __perf_addr(a) __addr = (a)
+#define __perf_addr(a)	(__addr = (a))
 
 #undef __perf_count
-#define __perf_count(c) __count = (c)
+#define __perf_count(c)	(__count = (c))
 
 #undef __perf_task
-#define __perf_task(t) __task = (t)
-
-#undef TP_perf_assign
-#define TP_perf_assign(args...) args
+#define __perf_task(t)	(__task = (t))
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-- 
1.5.5.1

