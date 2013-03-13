Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3CMKla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:41:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:9377 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3CMKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:41:29 -0400
Message-ID: <514057BF.6040804@huawei.com>
Date: Wed, 13 Mar 2013 18:41:03 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2] tracing: Expose event tracing infrastructure
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[change from v1: add missed type assignment in ftrace_event_register]

Currently event tracing only can be use for ftrace and perf,
there don't have any mechanism to let modules(like external tracing tool)
register callback tracing function.

Event tracing implement based on tracepoint, compare with raw tracepoint,
event tracing infrastructure provide built-in structured event annotate format,
this feature should expose to external user.

For example, simple pseudo ktap script demonstrate how to use this event
tracing expose change.

function event_trace(e)
{
        printf(e.annotate);
}

os.trace("sched:sched_switch", event_trace);
os.trace("irq:softirq_raise", event_trace);

The running result:
sched_switch: prev_comm=rcu_sched prev_pid=10 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=120
softirq_raise: vec=1 [action=TIMER]
...

This expose change can be use by other tracing tool, like systemtap/lttng,
if they would implement this.

This patch introduce struct event_trace_ops, it have two function pointers,
pre_trace and do_trace. when ftrace_raw_event_<call> function hit,
it will call all registered event_trace_ops.

Use this unify callback mechanism, ftrace_raw_event_<call> and
perf_trace_<call> is integrated into one function,
the benefit of this change is kernel size shrink ~52K(with ftrace and perf compiled in).

text    data     bss     dec     hex filename
7801238  841596 3473408 12116242         b8e112 vmlinux.old
7757064  833596 3473408 12064068         b81544 vmlinux.new

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/linux/ftrace_event.h |   63 +++++++++++++-
 include/trace/ftrace.h       |  198 ++++++++----------------------------------
 kernel/trace/trace_events.c  |  174 ++++++++++++++++++++++++++++++++++---
 3 files changed, 260 insertions(+), 175 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 13a54d0..4539a79 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -167,9 +167,6 @@ struct ftrace_event_call;
 struct ftrace_event_class {
 	char			*system;
 	void			*probe;
-#ifdef CONFIG_PERF_EVENTS
-	void			*perf_probe;
-#endif
 	int			(*reg)(struct ftrace_event_call *event,
 				       enum trace_reg type, void *data);
 	int			(*define_fields)(struct ftrace_event_call *);
@@ -199,6 +196,57 @@ enum {
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 };

+struct ftrace_trace_descriptor_t {
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
+};
+
+#ifdef CONFIG_PERF_EVENTS
+struct perf_trace_descriptor_t {
+	struct pt_regs __regs;
+	struct task_struct *__task;
+	u64 __addr;
+	u64 __count;
+	int rctx;
+};
+#endif
+
+/*
+ * trace_descriptor_t is purpose for passing arguments between
+ * pre_trace and do_trace function.
+ * this definition is ugly, change it in future.
+ */
+struct trace_descriptor_t {
+	struct ftrace_trace_descriptor_t	f;
+#ifdef CONFIG_PERF_EVENTS
+	struct perf_trace_descriptor_t		p;
+#endif
+	void  *data;
+};
+
+enum TRACE_REG_TYPE {
+	TRACE_REG_FTRACE,
+	TRACE_REG_PERF,
+};
+
+/* callback function for tracing */
+struct event_trace_ops {
+	void *(*pre_trace)(struct ftrace_event_call *event_call,
+			   int entry_size, void *data);
+	void (*do_trace)(struct ftrace_event_call *event_call,
+			 void *entry, int entry_size, void *data);
+};
+
+struct ftrace_probe {
+	struct list_head list;
+
+	/* 0: TRACE_REG_FTRACE; 1 : TRACE_REG_PERF */
+	int type;
+	struct event_trace_ops *ops;
+};
+
 struct ftrace_event_call {
 	struct list_head	list;
 	struct ftrace_event_class *class;
@@ -210,6 +258,10 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;

+	/* list head of "struct ftrace_probe" */
+	struct list_head	probe_ops_list;
+	int			probe_count;
+
 	/*
 	 * 32 bit flags:
 	 *   bit 1:		enabled
@@ -274,6 +326,11 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 extern int trace_add_event_call(struct ftrace_event_call *call);
 extern void trace_remove_event_call(struct ftrace_event_call *call);

+extern int ftrace_event_register(struct ftrace_event_call *call, int type,
+				 struct event_trace_ops *ops);
+extern void ftrace_event_unregister(struct ftrace_event_call *call, int type,
+				    struct event_trace_ops *ops);
+
 #define is_signed_type(type)	(((type)(-1)) < (type)0)

 int trace_set_clr_event(const char *system, const char *event, int set);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 40dc5e8..c1f526a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -412,38 +412,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *
  * static struct ftrace_event_call event_<call>;
  *
- * static void ftrace_raw_event_<call>(void *__data, proto)
- * {
- *	struct ftrace_event_call *event_call = __data;
- *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
- *	struct ring_buffer_event *event;
- *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
- *	struct ring_buffer *buffer;
- *	unsigned long irq_flags;
- *	int __data_size;
- *	int pc;
- *
- *	local_save_flags(irq_flags);
- *	pc = preempt_count();
- *
- *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
- *
- *	event = trace_current_buffer_lock_reserve(&buffer,
- *				  event_<call>->event.type,
- *				  sizeof(*entry) + __data_size,
- *				  irq_flags, pc);
- *	if (!event)
- *		return;
- *	entry	= ring_buffer_event_data(event);
- *
- *	{ <assign>; }  <-- Here we assign the entries by the __field and
- *			   __array macros.
- *
- *	if (!filter_current_check_discard(buffer, event_call, entry, event))
- *		trace_current_buffer_unlock_commit(buffer,
- *						   event, irq_flags, pc);
- * }
- *
  * static struct trace_event ftrace_event_type_<call> = {
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
@@ -472,20 +440,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *
  */

-#ifdef CONFIG_PERF_EVENTS
-
-#define _TRACE_PERF_PROTO(call, proto)					\
-	static notrace void						\
-	perf_trace_##call(void *__data, proto);
-
-#define _TRACE_PERF_INIT(call)						\
-	.perf_probe		= perf_trace_##call,
-
-#else
-#define _TRACE_PERF_PROTO(call, proto)
-#define _TRACE_PERF_INIT(call)
-#endif /* CONFIG_PERF_EVENTS */
-
 #undef __entry
 #define __entry entry

@@ -509,44 +463,56 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args

+#ifdef CONFIG_PERF_EVENTS
+#undef __perf_addr
+#define __perf_addr(a) __desc.p.__addr = (a)
+
+#undef __perf_count
+#define __perf_count(c) __desc.p.__count = (c)
+
+#undef __perf_task
+#define __perf_task(t) __desc.p.__task = (t)
+
 #undef TP_perf_assign
-#define TP_perf_assign(args...)
+#define TP_perf_assign(args...) args
+#endif /* CONFIG_PERF_EVENTS */

 #undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)  \
 									\
-static notrace void							\
-ftrace_raw_event_##call(void *__data, proto)				\
-{									\
-	struct ftrace_event_call *event_call = __data;			\
+static notrace void                                                     \
+ftrace_raw_event_##call(void *__data, proto)                            \
+{                                                                       \
+	struct ftrace_event_call *event_call = __data;                  \
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ring_buffer_event *event;				\
-	struct ftrace_raw_##call *entry;				\
-	struct ring_buffer *buffer;					\
-	unsigned long irq_flags;					\
-	int __data_size;						\
-	int pc;								\
-									\
-	local_save_flags(irq_flags);					\
-	pc = preempt_count();						\
+	struct trace_descriptor_t __desc;				\
+	struct ftrace_raw_##call *entry;                                \
+	struct ftrace_probe *probe_data;				\
+	int __data_size, __entry_size;					\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
+	__entry_size = sizeof(*entry) + __data_size;			\
 									\
-	event = trace_current_buffer_lock_reserve(&buffer,		\
-				 event_call->event.type,		\
-				 sizeof(*entry) + __data_size,		\
-				 irq_flags, pc);			\
-	if (!event)							\
-		return;							\
-	entry	= ring_buffer_event_data(event);			\
+	list_for_each_entry_rcu(probe_data, &event_call->probe_ops_list,\
+				list) { \
+		struct event_trace_ops *probe_ops = probe_data->ops;	\
 									\
-	tstruct								\
+		if (probe_data->type == TRACE_REG_PERF)			\
+			perf_fetch_caller_regs(&__desc.p.__regs);	\
 									\
-	{ assign; }							\
+		entry = probe_ops->pre_trace(event_call, __entry_size,	\
+					     &__desc);			\
+		if (!entry)						\
+			continue;					\
 									\
-	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
-		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
+		tstruct							\
+									\
+		{ assign; }						\
+									\
+		probe_ops->do_trace(event_call, entry, __entry_size, &__desc); \
+	}								\
 }
+
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
  * to make sure that if the tracepoint handling changes, the ftrace probe will
@@ -579,7 +545,6 @@ static inline void ftrace_test_probe_##call(void)			\

 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-_TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
 static struct ftrace_event_class __used event_class_##call = {		\
 	.system			= __stringify(TRACE_SYSTEM),		\
@@ -588,7 +553,6 @@ static struct ftrace_event_class __used event_class_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.probe			= ftrace_raw_event_##call,		\
 	.reg			= ftrace_event_reg,			\
-	_TRACE_PERF_INIT(call)						\
 };

 #undef DEFINE_EVENT
@@ -619,91 +583,5 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call

 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)

-
-#ifdef CONFIG_PERF_EVENTS
-
-#undef __entry
-#define __entry entry
-
-#undef __get_dynamic_array
-#define __get_dynamic_array(field)	\
-		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
-
-#undef __get_str
-#define __get_str(field) (char *)__get_dynamic_array(field)
-
-#undef __perf_addr
-#define __perf_addr(a) __addr = (a)
-
-#undef __perf_count
-#define __perf_count(c) __count = (c)
-
-#undef __perf_task
-#define __perf_task(t) __task = (t)
-
-#undef TP_perf_assign
-#define TP_perf_assign(args...) args
-
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static notrace void							\
-perf_trace_##call(void *__data, proto)					\
-{									\
-	struct ftrace_event_call *event_call = __data;			\
-	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ftrace_raw_##call *entry;				\
-	struct pt_regs __regs;						\
-	u64 __addr = 0, __count = 1;					\
-	struct task_struct *__task = NULL;				\
-	struct hlist_head *head;					\
-	int __entry_size;						\
-	int __data_size;						\
-	int rctx;							\
-									\
-	perf_fetch_caller_regs(&__regs);				\
-									\
-	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
-	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
-			     sizeof(u64));				\
-	__entry_size -= sizeof(u32);					\
-									\
-	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
-		      "profile buffer not large enough"))		\
-		return;							\
-									\
-	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->event.type, &__regs, &rctx);	\
-	if (!entry)							\
-		return;							\
-									\
-	tstruct								\
-									\
-	{ assign; }							\
-									\
-	head = this_cpu_ptr(event_call->perf_events);			\
-	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head, __task);			\
-}
-
-/*
- * This part is compiled out, it is only here as a build time check
- * to make sure that if the tracepoint handling changes, the
- * perf probe will fail to compile unless it too is updated.
- */
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)			\
-static inline void perf_test_probe_##call(void)				\
-{									\
-	check_trace_callback_type_##call(perf_trace_##template);	\
-}
-
-
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
-
-#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-#endif /* CONFIG_PERF_EVENTS */
-
 #undef _TRACE_PROFILE_INIT

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 57e9b28..69304ff 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -142,33 +142,183 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 	if (!id)
 		return -ENODEV;

+	INIT_LIST_HEAD(&call->probe_ops_list);
+	call->probe_count = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);

+static void *ftrace_events_pre_trace(struct ftrace_event_call *event_call,
+				     int entry_size, void *data)
+{
+	struct ftrace_trace_descriptor_t *desc = &((struct trace_descriptor_t *)
+						 data)->f;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	event = trace_current_buffer_lock_reserve(&buffer,
+						  event_call->event.type,
+						  entry_size, irq_flags, pc);
+
+	if (!event)
+		return NULL;
+
+	desc->event = event;
+	desc->buffer = buffer;
+	desc->irq_flags = irq_flags;
+	desc->pc = pc;
+
+	return ring_buffer_event_data(event);
+}
+
+static void ftrace_events_do_trace(struct ftrace_event_call *event_call,
+				   void *entry, int entry_size, void *data)
+{
+	struct ftrace_trace_descriptor_t *desc = &((struct trace_descriptor_t *)
+						 data)->f;
+	struct ring_buffer_event *event = desc->event;
+	struct ring_buffer *buffer = desc->buffer;
+	unsigned long irq_flags = desc->irq_flags;
+	int pc = desc->pc;
+
+	if (!filter_current_check_discard(buffer, event_call, entry, event))
+		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+}
+
+static struct event_trace_ops ftrace_events_ops = {
+	.pre_trace = ftrace_events_pre_trace,
+	.do_trace  = ftrace_events_do_trace,
+};
+
+#ifdef CONFIG_PERF_EVENTS
+static void *perf_events_pre_trace(struct ftrace_event_call *event_call,
+				     int entry_size, void *data)
+{
+	struct perf_trace_descriptor_t *desc = &((struct trace_descriptor_t *)
+						data)->p;
+	struct pt_regs *__regs = &desc->__regs;
+	int *rctx = &desc->rctx;
+	int __entry_size;
+
+	__entry_size = ALIGN(entry_size + sizeof(u32), sizeof(u64));
+	__entry_size -= sizeof(u32);
+
+	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,
+		      "profile buffer not large enough"))
+		return NULL;
+
+	return perf_trace_buf_prepare(__entry_size, event_call->event.type,
+				      __regs, rctx);
+}
+
+static void perf_events_do_trace(struct ftrace_event_call *event_call,
+				    void *entry, int entry_size, void *data)
+{
+	struct perf_trace_descriptor_t *desc = &((struct trace_descriptor_t *)
+						data)->p;
+	struct hlist_head *head;
+
+	head = this_cpu_ptr(event_call->perf_events);
+	perf_trace_buf_submit(entry, entry_size, desc->rctx, desc->__addr,
+			      desc->__count, &desc->__regs, head, desc->__task);
+}
+
+static struct event_trace_ops perf_events_ops = {
+	.pre_trace = perf_events_pre_trace,
+	.do_trace  = perf_events_do_trace,
+};
+#endif /* CONFIG_PERF_EVENTS */
+
+int ftrace_event_register(struct ftrace_event_call *call, int type,
+			  struct event_trace_ops *ops)
+{
+	struct ftrace_probe *probe_data;
+	int ret = 0;
+
+	if (call->probe_count == 0) {
+		ret = tracepoint_probe_register(call->name,
+						call->class->probe, call);
+		if (ret)
+			return ret;
+	} else {
+		/* reject duplicate register */
+		list_for_each_entry_rcu(probe_data, &call->probe_ops_list,
+					list) {
+			if ((probe_data->type == type) &&
+			    (probe_data->ops == ops))
+				return -EBUSY;
+		}
+	}
+
+	probe_data = kmalloc(sizeof(struct ftrace_probe), GFP_KERNEL);
+	if (!probe_data)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&probe_data->list);
+	probe_data->ops = ops;
+	probe_data->type = type;
+	list_add_tail_rcu(&probe_data->list, &call->probe_ops_list);
+	call->probe_count++;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ftrace_event_register);
+
+void ftrace_event_unregister(struct ftrace_event_call *call, int type,
+			     struct event_trace_ops *ops)
+{
+	struct ftrace_probe *probe_data;
+	int found = 0;
+
+	if (call->probe_count == 0)
+		return;
+
+	list_for_each_entry_rcu(probe_data, &call->probe_ops_list, list) {
+		if ((probe_data->type == type) && (probe_data->ops == ops)) {
+			list_del_rcu(&probe_data->list);
+			kfree(probe_data);
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		return;
+
+	call->probe_count--;
+
+	if (!call->probe_count)
+		tracepoint_probe_unregister(call->name,
+					    call->class->probe, call);
+}
+EXPORT_SYMBOL_GPL(ftrace_event_unregister);
+
 int ftrace_event_reg(struct ftrace_event_call *call,
 		     enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return tracepoint_probe_register(call->name,
-						 call->class->probe,
-						 call);
+		return ftrace_event_register(call, TRACE_REG_FTRACE,
+					     &ftrace_events_ops);
+
 	case TRACE_REG_UNREGISTER:
-		tracepoint_probe_unregister(call->name,
-					    call->class->probe,
-					    call);
+		ftrace_event_unregister(call, TRACE_REG_FTRACE,
+					&ftrace_events_ops);
 		return 0;

 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return tracepoint_probe_register(call->name,
-						 call->class->perf_probe,
-						 call);
+		return ftrace_event_register(call, TRACE_REG_PERF,
+					     &perf_events_ops);
+
 	case TRACE_REG_PERF_UNREGISTER:
-		tracepoint_probe_unregister(call->name,
-					    call->class->perf_probe,
-					    call);
+		ftrace_event_unregister(call, TRACE_REG_PERF, &perf_events_ops);
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
-- 
1.7.9.7


