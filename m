Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3LBOjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:39:17 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:56508 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3LBOjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:39:13 -0500
Date: Mon, 2 Dec 2013 15:39:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] perf fixes
Message-ID: <20131202143907.GA25791@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: e98a6e59dff885eb387163b1a7abe019a44ba90b Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Misc kernel and tooling fixes.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      tools lib traceevent: Fix conversion of pointer to integer of different size

Frederic Weisbecker (1):
      perf tools: Tag thread comm as overriden

Namhyung Kim (2):
      perf header: Fix bogus group name
      perf header: Fix possible memory leaks in process_group_desc()

Peter Zijlstra (2):
      ftrace, perf: Avoid infinite event generation loop
      perf: Remove fragile swevent hlist optimization

Steven Rostedt (1):
      tools lib traceevent: Fix use of multiple options in processing field

Vince Weaver (1):
      perf/trace: Properly use u64 to hold event_id


 arch/x86/include/asm/trace/irq_vectors.h | 11 +++++++++++
 include/linux/ftrace_event.h             | 16 ++++++++++++++++
 include/linux/tracepoint.h               |  4 ++++
 include/trace/ftrace.h                   |  7 +++++++
 kernel/events/core.c                     |  8 --------
 kernel/trace/trace_event_perf.c          |  8 +++++++-
 tools/lib/traceevent/event-parse.c       | 25 ++++++++++++++++++++++---
 tools/perf/util/header.c                 |  6 ++++--
 tools/perf/util/thread.c                 | 11 +++++------
 9 files changed, 76 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
index 2874df2..4cab890 100644
--- a/arch/x86/include/asm/trace/irq_vectors.h
+++ b/arch/x86/include/asm/trace/irq_vectors.h
@@ -72,6 +72,17 @@ DEFINE_IRQ_VECTOR_EVENT(x86_platform_ipi);
 DEFINE_IRQ_VECTOR_EVENT(irq_work);
 
 /*
+ * We must dis-allow sampling irq_work_exit() because perf event sampling
+ * itself can cause irq_work, which would lead to an infinite loop;
+ *
+ *  1) irq_work_exit happens
+ *  2) generates perf sample
+ *  3) generates irq_work
+ *  4) goto 1
+ */
+TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);
+
+/*
  * call_function - called when entering/exiting a call function interrupt
  * vector handler
  */
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 9abbe63..8c9b7a1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -248,6 +248,9 @@ struct ftrace_event_call {
 #ifdef CONFIG_PERF_EVENTS
 	int				perf_refcount;
 	struct hlist_head __percpu	*perf_events;
+
+	int	(*perf_perm)(struct ftrace_event_call *,
+			     struct perf_event *);
 #endif
 };
 
@@ -317,6 +320,19 @@ struct ftrace_event_file {
 	}								\
 	early_initcall(trace_init_flags_##name);
 
+#define __TRACE_EVENT_PERF_PERM(name, expr...)				\
+	static int perf_perm_##name(struct ftrace_event_call *tp_event, \
+				    struct perf_event *p_event)		\
+	{								\
+		return ({ expr; });					\
+	}								\
+	static int __init trace_init_perf_perm_##name(void)		\
+	{								\
+		event_##name.perf_perm = &perf_perm_##name;		\
+		return 0;						\
+	}								\
+	early_initcall(trace_init_perf_perm_##name);
+
 #define PERF_MAX_TRACE_SIZE	2048
 
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index ebeab36..f16dc0a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -267,6 +267,8 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define TRACE_EVENT_FLAGS(event, flag)
 
+#define TRACE_EVENT_PERF_PERM(event, expr...)
+
 #endif /* DECLARE_TRACE */
 
 #ifndef TRACE_EVENT
@@ -399,4 +401,6 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define TRACE_EVENT_FLAGS(event, flag)
 
+#define TRACE_EVENT_PERF_PERM(event, expr...)
+
 #endif /* ifdef TRACE_EVENT (see note above) */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 52594b2..6b852f6 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -90,6 +90,10 @@
 #define TRACE_EVENT_FLAGS(name, value)					\
 	__TRACE_EVENT_FLAGS(name, value)
 
+#undef TRACE_EVENT_PERF_PERM
+#define TRACE_EVENT_PERF_PERM(name, expr...)				\
+	__TRACE_EVENT_PERF_PERM(name, expr)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 
@@ -140,6 +144,9 @@
 #undef TRACE_EVENT_FLAGS
 #define TRACE_EVENT_FLAGS(event, flag)
 
+#undef TRACE_EVENT_PERF_PERM
+#define TRACE_EVENT_PERF_PERM(event, expr...)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d724e77..72348dc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5680,11 +5680,6 @@ static void swevent_hlist_put(struct perf_event *event)
 {
 	int cpu;
 
-	if (event->cpu != -1) {
-		swevent_hlist_put_cpu(event, event->cpu);
-		return;
-	}
-
 	for_each_possible_cpu(cpu)
 		swevent_hlist_put_cpu(event, cpu);
 }
@@ -5718,9 +5713,6 @@ static int swevent_hlist_get(struct perf_event *event)
 	int err;
 	int cpu, failed_cpu;
 
-	if (event->cpu != -1)
-		return swevent_hlist_get_cpu(event, event->cpu);
-
 	get_online_cpus();
 	for_each_possible_cpu(cpu) {
 		err = swevent_hlist_get_cpu(event, cpu);
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 78e27e3..e854f42 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -24,6 +24,12 @@ static int	total_ref_count;
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
+	if (tp_event->perf_perm) {
+		int ret = tp_event->perf_perm(tp_event, p_event);
+		if (ret)
+			return ret;
+	}
+
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event) &&
 	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
@@ -173,7 +179,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 int perf_trace_init(struct perf_event *p_event)
 {
 	struct ftrace_event_call *tp_event;
-	int event_id = p_event->attr.config;
+	u64 event_id = p_event->attr.config;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0362d57..217c82e 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1606,6 +1606,24 @@ process_arg(struct event_format *event, struct print_arg *arg, char **tok)
 static enum event_type
 process_op(struct event_format *event, struct print_arg *arg, char **tok);
 
+/*
+ * For __print_symbolic() and __print_flags, we need to completely
+ * evaluate the first argument, which defines what to print next.
+ */
+static enum event_type
+process_field_arg(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	enum event_type type;
+
+	type = process_arg(event, arg, tok);
+
+	while (type == EVENT_OP) {
+		type = process_op(event, arg, tok);
+	}
+
+	return type;
+}
+
 static enum event_type
 process_cond(struct event_format *event, struct print_arg *top, char **tok)
 {
@@ -2371,7 +2389,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 		goto out_free;
 	}
 
-	type = process_arg(event, field, &token);
+	type = process_field_arg(event, field, &token);
 
 	/* Handle operations in the first argument */
 	while (type == EVENT_OP)
@@ -2424,7 +2442,8 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 		goto out_free;
 	}
 
-	type = process_arg(event, field, &token);
+	type = process_field_arg(event, field, &token);
+
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free_field;
 
@@ -3446,7 +3465,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		 * is in the bottom half of the 32 bit field.
 		 */
 		offset &= 0xffff;
-		val = (unsigned long long)(data + offset);
+		val = (unsigned long long)((unsigned long)data + offset);
 		break;
 	default: /* not sure what to do there */
 		return 0;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 369c036..1cd0357 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2078,8 +2078,10 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 		if (evsel->idx == (int) desc[i].leader_idx) {
 			evsel->leader = evsel;
 			/* {anon_group} is a dummy name */
-			if (strcmp(desc[i].name, "{anon_group}"))
+			if (strcmp(desc[i].name, "{anon_group}")) {
 				evsel->group_name = desc[i].name;
+				desc[i].name = NULL;
+			}
 			evsel->nr_members = desc[i].nr_members;
 
 			if (i >= nr_groups || nr > 0) {
@@ -2105,7 +2107,7 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 
 	ret = 0;
 out_free:
-	while ((int) --i >= 0)
+	for (i = 0; i < nr_groups; i++)
 		free(desc[i].name);
 	free(desc);
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index cd8e2f5..49eaf1d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -70,14 +70,13 @@ int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
 		comm__override(curr, str, timestamp);
-		return 0;
+	} else {
+		new = comm__new(str, timestamp);
+		if (!new)
+			return -ENOMEM;
+		list_add(&new->list, &thread->comm_list);
 	}
 
-	new = comm__new(str, timestamp);
-	if (!new)
-		return -ENOMEM;
-
-	list_add(&new->list, &thread->comm_list);
 	thread->comm_set = true;
 
 	return 0;
