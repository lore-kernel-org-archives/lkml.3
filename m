Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaBFSLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:11:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:44464 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752044AbaBFSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:11:12 -0500
Message-Id: <20140206181109.376046894@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 12:39:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Li Zefan <lizefan@huawei.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/4] perf/events: Use helper functions in event assignment to shrink macro
 size
References: <20140206173910.029355947@goodmis.org>
Content-Disposition: inline; filename=0004-perf-events-Use-helper-functions-in-event-assignment.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The functions that assign the contents for the perf software events are
defined by the TRACE_EVENT() macros. Each event has its own unique
way to assign data to its buffer. When you have over 500 events,
that means there's 500 functions assigning data uniquely for each
event.

By making helper functions in the core kernel to do the work
instead, we can shrink the size of the kernel down a bit.

With a kernel configured with 707 events, the change in size was:

   text    data     bss     dec     hex filename
12959102        1913504 9785344 24657950        178401e /tmp/vmlinux
12917629        1913568 9785344 24616541        1779e5d /tmp/vmlinux.patched

That's a total of 41473 bytes, which comes down to 82 bytes per event.

Note, most of the savings comes from moving the setup and final submit
into helper functions, where the setup does the work and stores the
data into a structure, and that structure is passed to the submit function,
moving the setup of the parameters of perf_trace_buf_submit().

Link: http://lkml.kernel.org/r/20120810034708.589220175@goodmis.org

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    | 17 ++++++++++++++
 include/trace/ftrace.h          | 33 ++++++++++----------------
 kernel/trace/trace_event_perf.c | 51 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4cc6852..f33162e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -450,6 +450,23 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
+struct perf_trace_event {
+	struct pt_regs			regs;
+	struct hlist_head __percpu	*head;
+	struct task_struct		*task;
+	struct ftrace_event_call	*event_call;
+	void				*entry;
+	u64				addr;
+	u64				count;
+	int				entry_size;
+	int				rctx;
+	int				constant;
+};
+
+extern void *perf_trace_event_setup(struct ftrace_event_call *event_call, 
+				    struct perf_trace_event *pe);
+extern void perf_trace_event_submit(struct perf_trace_event *pe);
+
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
 extern int  perf_trace_add(struct perf_event *event, int flags);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index dc883a3..ba9173a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -629,13 +629,13 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
 #undef __perf_addr
-#define __perf_addr(a)	(__addr = (a))
+#define __perf_addr(a) (__pe.addr = (a))
 
 #undef __perf_count
-#define __perf_count(c)	(__count = (c))
+#define __perf_count(c) (__pe.count = (c))
 
 #undef __perf_task
-#define __perf_task(t)	(__task = (t))
+#define __perf_task(t)	(__pe.task = (t))
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -645,28 +645,20 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
-	struct pt_regs __regs;						\
-	u64 __addr = 0, __count = 1;					\
-	struct task_struct *__task = NULL;				\
-	struct hlist_head *head;					\
-	int __entry_size;						\
+	struct perf_trace_event __pe;					\
 	int __data_size;						\
-	int rctx;							\
+									\
+	__pe.task = NULL;						\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	head = this_cpu_ptr(event_call->perf_events);			\
-	if (__builtin_constant_p(!__task) && !__task &&			\
-				hlist_empty(head))			\
-		return;							\
+	__pe.constant = __builtin_constant_p(!__pe.task) && !__pe.task; \
 									\
-	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
-			     sizeof(u64));				\
-	__entry_size -= sizeof(u32);					\
+	__pe.entry_size = __data_size + sizeof(*entry);			\
+	__pe.addr = 0;							\
+	__pe.count = 1;							\
 									\
-	perf_fetch_caller_regs(&__regs);				\
-	entry = perf_trace_buf_prepare(__entry_size,			\
-			event_call->event.type, &__regs, &rctx);	\
+	entry = perf_trace_event_setup(event_call, &__pe);		\
 	if (!entry)							\
 		return;							\
 									\
@@ -674,8 +666,7 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head, __task);			\
+	perf_trace_event_submit(&__pe);					\
 }
 
 /*
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e854f42..6b01559 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -21,6 +21,57 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
+/**
+ * perf_trace_event_setup - set up for a perf sw event
+ * @event_call: The sw event that is to be recorded
+ * @pe: The perf event structure to pass to the submit function
+ *
+ * This is a helper function to keep the work to set up a perf sw
+ * event out of the inlined trace code. Since the same work neeeds to
+ * be done for the sw events, having a separate function helps keep
+ * from duplicating that code all over the kernel.
+ *
+ * The use of the perf event structure (@pe) is to store and pass the
+ * data to the perf_trace_event_submit() call and keep the setting
+ * up of the parameters of perf_trace_buf_submit() out of the inlined
+ * trace code.
+ */
+void *perf_trace_event_setup(struct ftrace_event_call *event_call, 
+			     struct perf_trace_event *pe)
+{
+	pe->head = this_cpu_ptr(event_call->perf_events);
+	if (pe->constant && hlist_empty(pe->head))
+		return NULL;
+
+	pe->entry_size = ALIGN(pe->entry_size + sizeof(u32), sizeof(u64));
+	pe->entry_size -= sizeof(u32);
+	pe->event_call = event_call;
+
+	perf_fetch_caller_regs(&pe->regs);
+
+	pe->entry = perf_trace_buf_prepare(pe->entry_size,
+			event_call->event.type, &pe->regs, &pe->rctx);
+	return pe->entry;
+}
+EXPORT_SYMBOL_GPL(perf_trace_event_setup);
+
+/**
+ * perf_trace_event_submit - submit from perf sw event
+ * @pe: perf event structure that holds all the necessary data
+ *
+ * This is a helper function that removes a lot of the setting up of
+ * the function parameters to call perf_trace_buf_submit() from the
+ * inlined code. Using the perf event structure @pe to store the
+ * information passed from perf_trace_event_setup() keeps the overhead
+ * of building the function call paremeters out of the inlined functions.
+ */
+void perf_trace_event_submit(struct perf_trace_event *pe)
+{
+	perf_trace_buf_submit(pe->entry, pe->entry_size, pe->rctx, pe->addr,
+			      pe->count, &pe->regs, pe->head, pe->task);
+}
+EXPORT_SYMBOL_GPL(perf_trace_event_submit);
+
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
-- 
1.8.4.3


