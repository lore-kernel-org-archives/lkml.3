Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3GQRmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:42:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab3GQRmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:42:44 -0400
Date: Wed, 17 Jul 2013 19:37:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
	opening probe event files and deleting probe
Message-ID: <20130717173720.GA31421@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130715180149.GA15821@redhat.com> <20130716163804.GA30560@redhat.com> <1374001825.6458.44.camel@gandalf.local.home> <20130716192200.GA21716@redhat.com> <1374003524.6458.51.camel@gandalf.local.home> <1374077030.6458.148.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1374077030.6458.148.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 07/17, Steven Rostedt wrote:
>
> On Tue, 2013-07-16 at 15:38 -0400, Steven Rostedt wrote:
>
> > > Btw, Steven, what about other pending (and orthogonal changes) ?
> > > >From Jovi, from me. I see nothing new in linux-trace.git#for-next...
> >
> > My INBOX is full with too much crap. I thought I grabbed the patches
> > from you and Jovi, but they may have been something else.
> >
> > Can you just tell me what the subjects were. My INBOX currently has
> > >10,000 emails, and it's just getting worse.

Please see the attached mbox. It contains 2 series with
perf_trace_buf/perf_xxx hacks.

1-3 looks very simple and straightforward.

4-6 reimplement TP_perf_assign(), we already discussed this (and you even
did the performance testing), but I am still not sure if you agree with
this hack or not.

And 2 patches from Jovi, acked by Masami and me:

	[PATCH 1/2 v6] tracing/uprobes: Support ftrace_event_file base multibuffer
	[PATCH 2/2 v6] tracing/uprobes: Support soft-mode disabling

Oleg.

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="RSND.m"

>From aa40385bba7692f4b53572da24119c3b293c9aa1 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Mon, 17 Jun 2013 19:02:04 +0200
Subject: [PATCH 1/6] tracing/function: Avoid perf_trace_buf_*() if event_function.perf_events is empty

perf_trace_buf_prepare() + perf_trace_buf_submit(head, task => NULL)
make no sense if hlist_empty(head). Change perf_ftrace_function_call()
to check event_function.perf_events beforehand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_event_perf.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 84b1e04..12df557 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -266,6 +266,10 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 	struct pt_regs regs;
 	int rctx;
 
+	head = this_cpu_ptr(event_function.perf_events);
+	if (hlist_empty(head))
+		return;
+
 #define ENTRY_SIZE (ALIGN(sizeof(struct ftrace_entry) + sizeof(u32), \
 		    sizeof(u64)) - sizeof(u32))
 
@@ -279,8 +283,6 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 
 	entry->ip = ip;
 	entry->parent_ip = parent_ip;
-
-	head = this_cpu_ptr(event_function.perf_events);
 	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
 			      1, &regs, head, NULL);
 
-- 
1.5.5.1


>From 803ce880302ef7d21bdad2196cddc76b4c1a49a1 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Mon, 17 Jun 2013 19:02:07 +0200
Subject: [PATCH 2/6] tracing/syscall: Avoid perf_trace_buf_*() if sys_data->perf_events is empty

perf_trace_buf_prepare() + perf_trace_buf_submit(head, task => NULL)
make no sense if hlist_empty(head). Change perf_syscall_enter/exit()
to check sys_data->{enter,exit}_event->perf_events beforehand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_syscalls.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 322e164..ea5b672 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -566,6 +566,10 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
+	head = this_cpu_ptr(sys_data->enter_event->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	/* get the size after alignment with the u32 buffer size field */
 	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
@@ -583,8 +587,6 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-
-	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
@@ -642,6 +644,10 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	head = this_cpu_ptr(sys_data->exit_event->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	/* We can probably do that at build time */
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -661,8 +667,6 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
-
-	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
-- 
1.5.5.1


>From 6037b2b9af2e6122380e967406f89ae9410fc5d6 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Mon, 17 Jun 2013 19:02:11 +0200
Subject: [PATCH 3/6] tracing/perf: Move the PERF_MAX_TRACE_SIZE check into perf_trace_buf_prepare()

Every perf_trace_buf_prepare() caller does
WARN_ONCE(size > PERF_MAX_TRACE_SIZE, message) and "message" is
almost the same.

Shift this WARN_ONCE() into perf_trace_buf_prepare(). This changes
the meaning of _ONCE, but I think this is fine.

	- 4947014 2932448 10104832  17984294  1126b26 vmlinux
	+ 4948422 2932448 10104832  17985702  11270a6 vmlinux

on my build.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/ftrace.h          |    4 ----
 kernel/trace/trace_event_perf.c |    4 ++++
 kernel/trace/trace_kprobe.c     |    6 ------
 kernel/trace/trace_syscalls.c   |   12 ------------
 kernel/trace/trace_uprobe.c     |    2 --
 5 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..c162a57 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -666,10 +666,6 @@ perf_trace_##call(void *__data, proto)					\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
-		      "profile buffer not large enough"))		\
-		return;							\
-									\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
 		__entry_size, event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 12df557..80c36bc 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -236,6 +236,10 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+			"perf buffer not large enough"))
+		return NULL;
+
 	pc = preempt_count();
 
 	*rctxp = perf_swevent_get_recursion_context();
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..ae6ce83 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1087,9 +1087,6 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		     "profile buffer not large enough"))
-		return;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
@@ -1120,9 +1117,6 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		     "profile buffer not large enough"))
-		return;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ea5b672..b7e3447 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -575,10 +575,6 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
-		return;
-
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
 				sys_data->enter_event->event.type, regs, &rctx);
 	if (!rec)
@@ -652,14 +648,6 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	/*
-	 * Impossible, but be paranoid with the future
-	 * How to put this check outside runtime?
-	 */
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		"exit event has grown above perf buffer size"))
-		return;
-
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
 				sys_data->exit_event->event.type, regs, &rctx);
 	if (!rec)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d5d0cd3..a23d2d7 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -818,8 +818,6 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
-		return;
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
-- 
1.5.5.1


>From f883693f6e02a9c5c1e32b47490671ffa554a6fe Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 18 Jun 2013 21:22:11 +0200
Subject: [PATCH 4/6] tracing/perf: expand TRACE_EVENT(sched_stat_runtime)

To simplify the review of the next patch:

1. We are going to reimplent __perf_task/counter and embedd them
   into TP_ARGS(). expand TRACE_EVENT(sched_stat_runtime) into
   DECLARE_EVENT_CLASS() + DEFINE_EVENT(), this way they can use
   different TP_ARGS's.

2. Change perf_trace_##call() macri to do perf_fetch_caller_regs()
   right before perf_trace_buf_prepare(). This way it evaluates
   "args" asap.

   Note: after 87f44bbc perf_trace_buf_prepare() doesn't need
   "struct pt_regs *regs", perhaps it makes sense to remove this
   argument. And perhaps we can teach perf_trace_buf_submit()
   to accept regs == NULL and do fetch_caller_regs(CALLER_ADDR1)
   in this case.

3. Cosmetic, but the typecast from "void*" buys nothing. It just
   adds the noise, remove it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/sched.h |    6 +++++-
 include/trace/ftrace.h       |    7 +++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e5586ca..249c024 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -372,7 +372,7 @@ DEFINE_EVENT(sched_stat_template, sched_stat_blocked,
  * Tracepoint for accounting runtime (time the task is executing
  * on a CPU).
  */
-TRACE_EVENT(sched_stat_runtime,
+DECLARE_EVENT_CLASS(sched_stat_runtime,
 
 	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
 
@@ -401,6 +401,10 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+DEFINE_EVENT(sched_stat_runtime, sched_stat_runtime,
+	     TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
+	     TP_ARGS(tsk, runtime, vruntime));
+
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c162a57..aed594a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -659,15 +659,14 @@ perf_trace_##call(void *__data, proto)					\
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
-	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->event.type, &__regs, &rctx);	\
+	perf_fetch_caller_regs(&__regs);				\
+	entry = perf_trace_buf_prepare(__entry_size,			\
+			event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
 		return;							\
 									\
-- 
1.5.5.1


>From 74318b1e89e7d6e6de9bb4992ab41e761c1175f6 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 18 Jun 2013 21:22:14 +0200
Subject: [PATCH 5/6] tracing/perf: reimplement TP_perf_assign() logic

TP_perf_assign/__perf_xxx is used to change the default values
of __addr/__count/__task variables for perf_trace_buf_submit().

Unfortunately, TP_perf_assign() is called "too late", we want to
have a fast-path "__task != NULL" check in perf_trace_##call() at
the start. So this patch simply embeds __perf_xxx() into TP_ARGS(),
this way DECLARE_EVENT_CLASS() can use the result of assignments
hidden in "args" right after ftrace_get_offsets_##call() which is
mostly trivial.

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


>From f5e6c3976bd68a72d7259e3282c5fda20fcefa4c Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 18 Jun 2013 21:22:18 +0200
Subject: [PATCH 6/6] tracing/perf: Avoid perf_trace_buf_*() in perf_trace_##call() when possible

perf_trace_buf_prepare() + perf_trace_buf_submit(task => NULL)
make no sense if hlist_empty(head). Change perf_trace_##call()
to check ->perf_events beforehand and do nothing if it is empty.

However, we can only do this if __task == NULL, so we also add
the __builtin_constant_p(__task) check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/ftrace.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 8886877..04455b8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -663,6 +663,12 @@ perf_trace_##call(void *__data, proto)					\
 	int rctx;							\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
+									\
+	head = this_cpu_ptr(event_call->perf_events);			\
+	if (__builtin_constant_p(!__task) && !__task &&			\
+				hlist_empty(head))			\
+		return;							\
+									\
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
@@ -677,7 +683,6 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, &__regs, head, __task);			\
 }
-- 
1.5.5.1


--2oS5YaxWCcQjTEyO--

