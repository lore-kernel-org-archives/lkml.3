Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3FQUWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:22:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3FQUWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:22:38 -0400
Date: Mon, 17 Jun 2013 22:18:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
Message-ID: <20130617201818.GA12349@redhat.com>
References: <20130617170142.GA19780@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617170142.GA19780@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Oleg Nesterov wrote:
>
> DECLARE_EVENT_CLASS()->perf_trace_##call() is not trivial because
> of __perf_task()

Perhaps we can do something like below?

Then we can

	1. kill __perf_addr(), __perf_count(), __perf_task() and
	   TP_perf_assign()

	2. Add the fast path check

		if (builtin_constant(__task) && !__task &&
		    hlist_empty(head)))
			return;

	   into perf_trace_call() right after ftrace_get_offsets_call().

Doesn't look very nice, it relies on the fact that
ftrace_get_offsets_call(args) evaluates TP_perf_arg()'s hidden in
TP_ARGS().

OTOH, the whole point of include/trace/ is to create the code which
nobody except the maintainers can understand. At least I certainly
can't ;) So perhaps this is fine.

Oleg.

--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -57,7 +57,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 
 	TP_PROTO(struct task_struct *p, int success),
 
-	TP_ARGS(p, success),
+	TP_ARGS(TP_perf_arg(__task, p), success),
 
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
+	TP_ARGS(TP_perf_arg(__task, tsk), TP_perf_arg(__count, delay)),
 
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
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -506,6 +506,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef TP_perf_assign
 #define TP_perf_assign(args...)
 
+#undef TP_perf_arg
+#define TP_perf_arg(var, val)	(val)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
@@ -643,6 +646,9 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #undef TP_perf_assign
 #define TP_perf_assign(args...) args
 
+#undef TP_perf_arg
+#define TP_perf_arg(var, val)	(var = (val))
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
@@ -659,13 +665,12 @@ perf_trace_##call(void *__data, proto)					\
 	int __data_size;						\
 	int rctx;							\
 									\
-	perf_fetch_caller_regs(&__regs);				\
-									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
+	perf_fetch_caller_regs(&__regs);				\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
 		__entry_size, event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\

