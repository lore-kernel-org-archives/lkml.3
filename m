Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab3HOTtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:49:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59198 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab3HOTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:49:45 -0400
Date: Thu, 15 Aug 2013 12:48:57 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-12473965c38a527a0c6f7a38d23edce60957f873@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20130806160844.GA2739@redhat.com>
References: <20130806160844.GA2739@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/perf: Reimplement TP_perf_assign() logic
Git-Commit-ID: 12473965c38a527a0c6f7a38d23edce60957f873
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 12:49:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12473965c38a527a0c6f7a38d23edce60957f873
Gitweb:     http://git.kernel.org/tip/12473965c38a527a0c6f7a38d23edce60957f873
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 6 Aug 2013 18:08:44 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 13 Aug 2013 21:05:57 -0400

tracing/perf: Reimplement TP_perf_assign() logic

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
 include/trace/events/sched.h | 16 +++-------------
 include/trace/ftrace.h       | 19 +++++++++++--------
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
