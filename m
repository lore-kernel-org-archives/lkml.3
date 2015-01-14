Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbbANTU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:20:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbbANTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:20:56 -0500
Date: Wed, 14 Jan 2015 11:19:56 -0800
From: "tip-bot for Peter Zijlstra (Intel)" <tipbot@zytor.com>
Message-ID: <tip-86038c5ea81b519a8a1fcfcd5e4599aab0cdd119@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, paulus@samba.org,
        oleg@redhat.com, hpa@zytor.com, tom.zanussi@linux.intel.com,
        peterz@infradead.org, mathieu.desnoyers@efficios.com, pmladek@suse.cz,
        rostedt@goodmis.org, acme@kernel.org, javi.merino@arm.com,
        vnagarnaik@google.com, torvalds@linux-foundation.org, mingo@kernel.org
Reply-To: vnagarnaik@google.com, mingo@kernel.org,
        torvalds@linux-foundation.org, pmladek@suse.cz, rostedt@goodmis.org,
        javi.merino@arm.com, acme@kernel.org, tom.zanussi@linux.intel.com,
        mathieu.desnoyers@efficios.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, oleg@redhat.com,
        tglx@linutronix.de, paulus@samba.org
In-Reply-To: <20141216115041.GW3337@twins.programming.kicks-ass.net>
References: <20141216115041.GW3337@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Avoid horrible stack usage
Git-Commit-ID: 86038c5ea81b519a8a1fcfcd5e4599aab0cdd119
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86038c5ea81b519a8a1fcfcd5e4599aab0cdd119
Gitweb:     http://git.kernel.org/tip/86038c5ea81b519a8a1fcfcd5e4599aab0cdd119
Author:     Peter Zijlstra (Intel) <peterz@infradead.org>
AuthorDate: Tue, 16 Dec 2014 12:47:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 15:11:45 +0100

perf: Avoid horrible stack usage

Both Linus (most recent) and Steve (a while ago) reported that perf
related callbacks have massive stack bloat.

The problem is that software events need a pt_regs in order to
properly report the event location and unwind stack. And because we
could not assume one was present we allocated one on stack and filled
it with minimal bits required for operation.

Now, pt_regs is quite large, so this is undesirable. Furthermore it
turns out that most sites actually have a pt_regs pointer available,
making this even more onerous, as the stack space is pointless waste.

This patch addresses the problem by observing that software events
have well defined nesting semantics, therefore we can use static
per-cpu storage instead of on-stack.

Linus made the further observation that all but the scheduler callers
of perf_sw_event() have a pt_regs available, so we change the regular
perf_sw_event() to require a valid pt_regs (where it used to be
optional) and add perf_sw_event_sched() for the scheduler.

We have a scheduler specific call instead of a more generic _noregs()
like construct because we can assume non-recursion from the scheduler
and thereby simplify the code further (_noregs would have to put the
recursion context call inline in order to assertain which __perf_regs
element to use).

One last note on the implementation of perf_trace_buf_prepare(); we
allow .regs = NULL for those cases where we already have a pt_regs
pointer available and do not need another.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Javi Merino <javi.merino@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Link: http://lkml.kernel.org/r/20141216115041.GW3337@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/ftrace_event.h    |  2 +-
 include/linux/perf_event.h      | 28 +++++++++++++++++++++-------
 include/trace/ftrace.h          |  7 ++++---
 kernel/events/core.c            | 23 +++++++++++++++++------
 kernel/sched/core.c             |  2 +-
 kernel/trace/trace_event_perf.c |  4 +++-
 kernel/trace/trace_kprobe.c     |  4 ++--
 kernel/trace/trace_syscalls.c   |  4 ++--
 kernel/trace/trace_uprobe.c     |  2 +-
 9 files changed, 52 insertions(+), 24 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0bebb5c..d36f68b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -595,7 +595,7 @@ extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
 extern void *perf_trace_buf_prepare(int size, unsigned short type,
-				    struct pt_regs *regs, int *rctxp);
+				    struct pt_regs **regs, int *rctxp);
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4f7a61c..3a7bd80 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -665,6 +665,7 @@ static inline int is_software_event(struct perf_event *event)
 
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
+extern void ___perf_sw_event(u32, u64, struct pt_regs *, u64);
 extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
 
 #ifndef perf_arch_fetch_caller_regs
@@ -689,14 +690,25 @@ static inline void perf_fetch_caller_regs(struct pt_regs *regs)
 static __always_inline void
 perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
-	struct pt_regs hot_regs;
+	if (static_key_false(&perf_swevent_enabled[event_id]))
+		__perf_sw_event(event_id, nr, regs, addr);
+}
+
+DECLARE_PER_CPU(struct pt_regs, __perf_regs[4]);
 
+/*
+ * 'Special' version for the scheduler, it hard assumes no recursion,
+ * which is guaranteed by us not actually scheduling inside other swevents
+ * because those disable preemption.
+ */
+static __always_inline void
+perf_sw_event_sched(u32 event_id, u64 nr, u64 addr)
+{
 	if (static_key_false(&perf_swevent_enabled[event_id])) {
-		if (!regs) {
-			perf_fetch_caller_regs(&hot_regs);
-			regs = &hot_regs;
-		}
-		__perf_sw_event(event_id, nr, regs, addr);
+		struct pt_regs *regs = this_cpu_ptr(&__perf_regs[0]);
+
+		perf_fetch_caller_regs(regs);
+		___perf_sw_event(event_id, nr, regs, addr);
 	}
 }
 
@@ -712,7 +724,7 @@ static inline void perf_event_task_sched_in(struct task_struct *prev,
 static inline void perf_event_task_sched_out(struct task_struct *prev,
 					     struct task_struct *next)
 {
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
+	perf_sw_event_sched(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 0);
 
 	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
@@ -823,6 +835,8 @@ static inline int perf_event_refresh(struct perf_event *event, int refresh)
 static inline void
 perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
 static inline void
+perf_sw_event_sched(u32 event_id, u64 nr, u64 addr)			{ }
+static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
 static inline int perf_register_guest_info_callbacks
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 139b506..27609df 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -763,7 +763,7 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
-	struct pt_regs __regs;						\
+	struct pt_regs *__regs;						\
 	u64 __addr = 0, __count = 1;					\
 	struct task_struct *__task = NULL;				\
 	struct hlist_head *head;					\
@@ -782,18 +782,19 @@ perf_trace_##call(void *__data, proto)					\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	perf_fetch_caller_regs(&__regs);				\
 	entry = perf_trace_buf_prepare(__entry_size,			\
 			event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
 		return;							\
 									\
+	perf_fetch_caller_regs(__regs);					\
+									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head, __task);			\
+		__count, __regs, head, __task);				\
 }
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 882f835..c10124b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5889,6 +5889,8 @@ end:
 	rcu_read_unlock();
 }
 
+DEFINE_PER_CPU(struct pt_regs, __perf_regs[4]);
+
 int perf_swevent_get_recursion_context(void)
 {
 	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
@@ -5904,21 +5906,30 @@ inline void perf_swevent_put_recursion_context(int rctx)
 	put_recursion_context(swhash->recursion, rctx);
 }
 
-void __perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
+void ___perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data;
-	int rctx;
 
-	preempt_disable_notrace();
-	rctx = perf_swevent_get_recursion_context();
-	if (rctx < 0)
+	if (WARN_ON_ONCE(!regs))
 		return;
 
 	perf_sample_data_init(&data, addr, 0);
-
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, &data, regs);
+}
+
+void __perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
+{
+	int rctx;
+
+	preempt_disable_notrace();
+	rctx = perf_swevent_get_recursion_context();
+	if (unlikely(rctx < 0))
+		goto fail;
+
+	___perf_sw_event(event_id, nr, regs, addr);
 
 	perf_swevent_put_recursion_context(rctx);
+fail:
 	preempt_enable_notrace();
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0accc0..d22fb16 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1082,7 +1082,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		if (p->sched_class->migrate_task_rq)
 			p->sched_class->migrate_task_rq(p, new_cpu);
 		p->se.nr_migrations++;
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
+		perf_sw_event_sched(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 0);
 	}
 
 	__set_task_cpu(p, new_cpu);
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 4b9c114..6fa484d 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -261,7 +261,7 @@ void perf_trace_del(struct perf_event *p_event, int flags)
 }
 
 void *perf_trace_buf_prepare(int size, unsigned short type,
-			     struct pt_regs *regs, int *rctxp)
+			     struct pt_regs **regs, int *rctxp)
 {
 	struct trace_entry *entry;
 	unsigned long flags;
@@ -280,6 +280,8 @@ void *perf_trace_buf_prepare(int size, unsigned short type,
 	if (*rctxp < 0)
 		return NULL;
 
+	if (regs)
+		*regs = this_cpu_ptr(&__perf_regs[*rctxp]);
 	raw_data = this_cpu_ptr(perf_trace_buf[*rctxp]);
 
 	/* zero the dead bytes from align to not leak stack to user */
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5edb518..296079a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1148,7 +1148,7 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
+	entry = perf_trace_buf_prepare(size, call->event.type, NULL, &rctx);
 	if (!entry)
 		return;
 
@@ -1179,7 +1179,7 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
+	entry = perf_trace_buf_prepare(size, call->event.type, NULL, &rctx);
 	if (!entry)
 		return;
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c6ee36f..f97f6e3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -574,7 +574,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	size -= sizeof(u32);
 
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
-				sys_data->enter_event->event.type, regs, &rctx);
+				sys_data->enter_event->event.type, NULL, &rctx);
 	if (!rec)
 		return;
 
@@ -647,7 +647,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	size -= sizeof(u32);
 
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
-				sys_data->exit_event->event.type, regs, &rctx);
+				sys_data->exit_event->event.type, NULL, &rctx);
 	if (!rec)
 		return;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 8520acc..b114413 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1111,7 +1111,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 	if (hlist_empty(head))
 		goto out;
 
-	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
+	entry = perf_trace_buf_prepare(size, call->event.type, NULL, &rctx);
 	if (!entry)
 		goto out;
 
