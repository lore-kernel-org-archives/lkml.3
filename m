Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab3HOCEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 22:04:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031Ab3HOCDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 22:03:37 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kDmDN97bTA8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QDFsRHsHNQsA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=FGoTIqphnN9v52ywFmgA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130815020335.143019582@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 22:01:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH tip/perf/core 2/3] tracing/perf: Reimplement TP_perf_assign() logic
References: <20130815020104.813498803@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-perf-Reimplement-TP_perf_assign-logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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

Link: http://lkml.kernel.org/r/20130806160844.GA2739@redhat.com

Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index 618af05..4163d93 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -507,8 +507,14 @@ static inline notrace int ftrace_get_offsets_##call(			\
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
@@ -636,16 +642,13 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
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
1.7.10.4


