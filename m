Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaBFKvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:64570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730AbaBFKvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="478983423"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 05/11] itrace: Add functionality to include traces in perf event samples
Date: Thu,  6 Feb 2014 12:50:28 +0200
Message-Id: <1391683834-29868-6-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace data from itrace PMUs can be used to annotate other perf events
by including it in sample records when PERF_SAMPLE_ITRACE flag is set. In
this case, a PT kernel counter is created for each such event and trace data
is retrieved from it and stored in the perf data stream.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/itrace.h          |  37 +++++++++
 include/linux/perf_event.h      |  15 ++++
 include/uapi/linux/perf_event.h |   5 +-
 kernel/events/core.c            |  35 +++++++++
 kernel/events/itrace.c          | 169 ++++++++++++++++++++++++++++++++++++++--
 5 files changed, 252 insertions(+), 9 deletions(-)

diff --git a/include/linux/itrace.h b/include/linux/itrace.h
index 735baaf4..6adbb32 100644
--- a/include/linux/itrace.h
+++ b/include/linux/itrace.h
@@ -54,12 +54,27 @@ struct itrace_pmu {
 
 	int			(*event_init)(struct perf_event *event);
 
+	/*
+	 * Calculate the size of a sample to be written out
+	 */
+	unsigned long		(*sample_trace)(struct perf_event *event,
+						struct perf_sample_data *data);
+
+	/*
+	 * Write out a trace sample to the given output handle
+	 */
+	void			(*sample_output)(struct perf_event *event,
+						 struct perf_output_handle *handle,
+						 struct perf_sample_data *data);
 	char			*name;
 };
 
 #define to_itrace_pmu(x) container_of((x), struct itrace_pmu, pmu)
 
 #ifdef CONFIG_PERF_EVENTS
+
+extern int itrace_kernel_event(struct perf_event *event,
+			       struct task_struct *task);
 extern int itrace_inherit_event(struct perf_event *event,
 				struct task_struct *task);
 extern void itrace_lost_data(struct perf_event *event, u64 offset);
@@ -72,7 +87,17 @@ extern void itrace_wake_up(struct perf_event *event);
 
 extern bool is_itrace_event(struct perf_event *event);
 
+extern int itrace_sampler_init(struct perf_event *event,
+			       struct task_struct *task);
+extern void itrace_sampler_fini(struct perf_event *event);
+extern unsigned long itrace_sampler_trace(struct perf_event *event,
+					  struct perf_sample_data *data);
+extern void itrace_sampler_output(struct perf_event *event,
+				  struct perf_output_handle *handle,
+				  struct perf_sample_data *data);
 #else
+static int itrace_kernel_event(struct perf_event *event,
+			       struct task_struct *task)	{ return 0; }
 static int itrace_inherit_event(struct perf_event *event,
 				struct task_struct *task)	{ return 0; }
 static inline void
@@ -84,6 +109,18 @@ itrace_event_installable(struct perf_event *event,
 			 struct perf_event_context *ctx)	{ return -EINVAL; }
 static inline void itrace_wake_up(struct perf_event *event)	{}
 static inline bool is_itrace_event(struct perf_event *event)	{ return false; }
+
+static inline int itrace_sampler_init(struct perf_event *event,
+				      struct task_struct *task)	{}
+static inline void
+itrace_sampler_fini(struct perf_event *event)			{}
+static inline unsigned long
+itrace_sampler_trace(struct perf_event *event,
+		     struct perf_sample_data *data)		{ return 0; }
+static inline void
+itrace_sampler_output(struct perf_event *event,
+		      struct perf_output_handle *handle,
+		      struct perf_sample_data *data)		{}
 #endif
 
 #endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b0147e0..11eb133 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -83,6 +83,12 @@ struct perf_regs_user {
 	struct pt_regs	*regs;
 };
 
+struct perf_trace_record {
+	u64		size;
+	unsigned long	from;
+	unsigned long	to;
+};
+
 struct task_struct;
 
 /*
@@ -97,6 +103,11 @@ struct hw_perf_event_extra {
 
 struct event_constraint;
 
+enum perf_itrace_counter_type {
+	PERF_ITRACE_USER	= BIT(1),
+	PERF_ITRACE_SAMPLING	= BIT(2),
+};
+
 /**
  * struct hw_perf_event - performance event hardware details:
  */
@@ -129,6 +140,7 @@ struct hw_perf_event {
 		struct { /* itrace */
 			struct file		*itrace_file;
 			struct task_struct	*itrace_target;
+			unsigned int		counter_type;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		struct { /* breakpoint */
@@ -434,6 +446,7 @@ struct perf_event {
 	perf_overflow_handler_t		overflow_handler;
 	void				*overflow_handler_context;
 
+	struct perf_event		*trace_event;
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
@@ -591,6 +604,7 @@ struct perf_sample_data {
 	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct perf_trace_record	trace;
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
@@ -611,6 +625,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->period = period;
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
+	data->trace.from = data->trace.to = data->trace.size = 0;
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 2dd57db..a06cf4b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_ITRACE			= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -689,6 +690,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			size;
+	 *	  char			data[size]; } && PERF_SAMPLE_ITRACE
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ff6e286..e1388a5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1576,6 +1576,9 @@ void perf_event_disable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->trace_event)
+		perf_event_disable(event->trace_event);
+
 	if (!task) {
 		/*
 		 * Disable the event on the cpu that it's on
@@ -2070,6 +2073,8 @@ void perf_event_enable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->trace_event)
+		perf_event_enable(event->trace_event);
 	if (!task) {
 		/*
 		 * Enable the event on the cpu that it's on
@@ -3209,6 +3214,8 @@ static void unaccount_event(struct perf_event *event)
 		static_key_slow_dec_deferred(&perf_sched_events);
 	if (has_branch_stack(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
+	if ((event->attr.sample_type & PERF_SAMPLE_ITRACE) && event->trace_event)
+		itrace_sampler_fini(event);
 
 	unaccount_event_cpu(event, event->cpu);
 }
@@ -4664,6 +4671,13 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_ITRACE) {
+		perf_output_put(handle, data->trace.size);
+
+		if (data->trace.size)
+			itrace_sampler_output(event, handle, data);
+	}
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
@@ -4771,6 +4785,14 @@ void perf_prepare_sample(struct perf_event_header *header,
 		data->stack_user_size = stack_size;
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_ITRACE) {
+		u64 size = sizeof(u64);
+
+		size += itrace_sampler_trace(event, data);
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6795,6 +6817,15 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			if (err)
 				goto err_pmu;
 		}
+
+		if (event->attr.sample_type & PERF_SAMPLE_ITRACE) {
+			err = itrace_sampler_init(event, task);
+			if (err) {
+				/* XXX: either clean up callchain buffers too
+				   or forbid them to go together */
+				goto err_pmu;
+			}
+		}
 	}
 
 	return event;
@@ -7369,6 +7400,10 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	account_event(event);
 
+	err = itrace_kernel_event(event, task);
+	if (err)
+		goto err_free;
+
 	ctx = find_get_context(event->pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
index ec26373..f003530 100644
--- a/kernel/events/itrace.c
+++ b/kernel/events/itrace.c
@@ -89,6 +89,22 @@ bool is_itrace_event(struct perf_event *event)
 	return !!itrace_pmu_find(event->attr.type);
 }
 
+static void itrace_event_destroy(struct perf_event *event)
+{
+	struct ring_buffer *rb = event->rb[PERF_RB_ITRACE];
+
+	if (!rb)
+		return;
+
+	if (event->hw.counter_type != PERF_ITRACE_USER) {
+		atomic_dec(&rb->mmap_count);
+		atomic_dec(&event->mmap_count[PERF_RB_ITRACE]);
+		ring_buffer_detach(event, rb);
+		rcu_assign_pointer(event->rb[PERF_RB_ITRACE], NULL);
+		ring_buffer_put(rb); /* should be last */
+	}
+}
+
 int itrace_event_installable(struct perf_event *event,
 			     struct perf_event_context *ctx)
 {
@@ -115,8 +131,16 @@ int itrace_event_installable(struct perf_event *event,
 static int itrace_event_init(struct perf_event *event)
 {
 	struct itrace_pmu *ipmu = to_itrace_pmu(event->pmu);
+	int ret;
 
-	return ipmu->event_init(event);
+	ret = ipmu->event_init(event);
+	if (ret)
+		return ret;
+
+	event->destroy = itrace_event_destroy;
+	event->hw.counter_type = PERF_ITRACE_USER;
+
+	return 0;
 }
 
 static unsigned long itrace_rb_get_size(int nr_pages)
@@ -214,9 +238,16 @@ out:
 	mutex_unlock(&event->mmap_mutex);
 }
 
+static size_t roundup_buffer_size(u64 size)
+{
+	return 1ul << (__get_order(size) + PAGE_SHIFT);
+}
+
 int itrace_inherit_event(struct perf_event *event, struct task_struct *task)
 {
+	size_t size = event->attr.itrace_sample_size;
 	struct perf_event *parent = event->parent;
+	struct ring_buffer *rb;
 	struct itrace_pmu *ipmu;
 
 	if (!is_itrace_event(event))
@@ -224,14 +255,59 @@ int itrace_inherit_event(struct perf_event *event, struct task_struct *task)
 
 	ipmu = to_itrace_pmu(event->pmu);
 
-	/*
-	 * inherited user's counters should inherit buffers IF
-	 * they aren't cpu==-1
-	 */
-	if (parent->cpu == -1)
-		return -EINVAL;
+	if (parent->hw.counter_type == PERF_ITRACE_USER) {
+		/*
+		 * inherited user's counters should inherit buffers IF
+		 * they aren't cpu==-1
+		 */
+		if (parent->cpu == -1)
+			return -EINVAL;
+
+		itrace_set_output(event, parent);
+		return 0;
+	}
+
+	event->hw.counter_type = parent->hw.counter_type;
+
+	size = roundup_buffer_size(size);
+	rb = rb_alloc(event, size >> PAGE_SHIFT, 0, event->cpu, 0,
+		      &itrace_rb_ops);
+	if (!rb)
+		return -ENOMEM;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb[PERF_RB_ITRACE], rb);
+	atomic_set(&rb->mmap_count, 1);
+	atomic_set(&event->mmap_count[PERF_RB_ITRACE], 1);
+
+	return 0;
+}
+
+int itrace_kernel_event(struct perf_event *event, struct task_struct *task)
+{
+	struct itrace_pmu *ipmu;
+	struct ring_buffer *rb;
+	size_t size;
+
+	if (!is_itrace_event(event))
+		return 0;
 
-	itrace_set_output(event, parent);
+	ipmu = to_itrace_pmu(event->pmu);
+
+	if (!event->attr.itrace_sample_size)
+		return 0;
+
+	size = roundup_buffer_size(event->attr.itrace_sample_size);
+
+	rb = rb_alloc(event, size >> PAGE_SHIFT, 0, event->cpu, 0,
+		      &itrace_rb_ops);
+	if (!rb)
+		return -ENOMEM;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb[PERF_RB_ITRACE], rb);
+	atomic_set(&rb->mmap_count, 1);
+	atomic_set(&event->mmap_count[PERF_RB_ITRACE], 1);
 
 	return 0;
 }
@@ -269,3 +345,80 @@ int itrace_pmu_register(struct itrace_pmu *ipmu)
 
 	return ret;
 }
+
+/*
+ * Trace sample annotation
+ * For events that have attr.sample_type & PERF_SAMPLE_ITRACE, perf calls here
+ * to configure and obtain itrace samples.
+ */
+
+int itrace_sampler_init(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_event_attr attr;
+	struct perf_event *tevt;
+	struct itrace_pmu *ipmu;
+
+	ipmu = itrace_pmu_find(event->attr.itrace_sample_type);
+	if (!ipmu || !ipmu->sample_trace || !ipmu->sample_output)
+		return -ENOTSUPP;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = ipmu->pmu.type;
+	attr.config = 0;
+	attr.sample_type = 0;
+	attr.exclude_user = event->attr.exclude_user;
+	attr.exclude_kernel = event->attr.exclude_kernel;
+	attr.itrace_sample_size = event->attr.itrace_sample_size;
+	attr.itrace_config = event->attr.itrace_config;
+
+	tevt = perf_event_create_kernel_counter(&attr, event->cpu, task, NULL, NULL);
+	if (IS_ERR(tevt))
+		return PTR_ERR(tevt);
+
+	if (!itrace_priv(tevt)) {
+		perf_event_release_kernel(tevt);
+		return -EINVAL;
+	}
+
+	event->trace_event = tevt;
+	tevt->hw.counter_type = PERF_ITRACE_SAMPLING;
+	if (event->state != PERF_EVENT_STATE_OFF)
+		perf_event_enable(event->trace_event);
+
+	return 0;
+}
+
+void itrace_sampler_fini(struct perf_event *event)
+{
+	struct perf_event *tevt = event->trace_event;
+
+	perf_event_release_kernel(tevt);
+	event->trace_event = NULL;
+}
+
+unsigned long itrace_sampler_trace(struct perf_event *event,
+				   struct perf_sample_data *data)
+{
+	struct perf_event *tevt = event->trace_event;
+	struct itrace_pmu *ipmu;
+
+	if (!tevt)
+		return 0;
+
+	ipmu = to_itrace_pmu(tevt->pmu);
+	return ipmu->sample_trace(tevt, data);
+}
+
+void itrace_sampler_output(struct perf_event *event,
+			   struct perf_output_handle *handle,
+			   struct perf_sample_data *data)
+{
+	struct perf_event *tevt = event->trace_event;
+	struct itrace_pmu *ipmu;
+
+	if (!tevt || !data->trace.size)
+		return;
+
+	ipmu = to_itrace_pmu(tevt->pmu);
+	ipmu->sample_output(tevt, handle, data);
+}
-- 
1.8.5.2

