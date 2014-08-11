Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaHKFeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:34:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:3762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaHKFea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="574812756"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 20/23] perf: itrace: Infrastructure for sampling instruction flow traces
Date: Mon, 11 Aug 2014 08:19:49 +0300
Message-Id: <1407734392-31097-21-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction tracing PMUs are capable of recording a log of instruction
execution flow on a cpu core, which can be useful for profiling and crash
analysis. This patch adds itrace infrastructure for perf events and the
rest of the kernel to use.

This trace data can be used to annotate other perf events by including it
in sample records when PERF_SAMPLE_ITRACE flag is set. In this case, a
kernel counter is created for each such event and trace data is retrieved
from it and stored in the perf data stream.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/itrace.h          |  45 ++++++++++++
 include/linux/perf_event.h      |  14 ++++
 include/uapi/linux/perf_event.h |  14 +++-
 kernel/events/Makefile          |   2 +-
 kernel/events/core.c            |  38 ++++++++++
 kernel/events/itrace.c          | 159 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 269 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/itrace.h
 create mode 100644 kernel/events/itrace.c

diff --git a/include/linux/itrace.h b/include/linux/itrace.h
new file mode 100644
index 0000000000..c6c0674092
--- /dev/null
+++ b/include/linux/itrace.h
@@ -0,0 +1,45 @@
+/*
+ * Instruction flow trace unit infrastructure
+ * Copyright (c) 2013-2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _LINUX_ITRACE_H
+#define _LINUX_ITRACE_H
+
+#include <linux/perf_event.h>
+
+#ifdef CONFIG_PERF_EVENTS
+extern int itrace_sampler_init(struct perf_event *event,
+			       struct task_struct *task,
+			       struct pmu *pmu);
+extern void itrace_sampler_fini(struct perf_event *event);
+extern unsigned long itrace_sampler_trace(struct perf_event *event,
+					  struct perf_sample_data *data);
+extern void itrace_sampler_output(struct perf_event *event,
+				  struct perf_output_handle *handle,
+				  struct perf_sample_data *data);
+#else
+static inline int itrace_sampler_init(struct perf_event *event,
+				      struct task_struct *task,
+				      struct pmu *pmu)		{ return -EINVAL; }
+static inline void
+itrace_sampler_fini(struct perf_event *event)			{}
+static inline unsigned long
+itrace_sampler_trace(struct perf_event *event,
+		     struct perf_sample_data *data)		{ return 0; }
+static inline void
+itrace_sampler_output(struct perf_event *event,
+		      struct perf_output_handle *handle,
+		      struct perf_sample_data *data)		{}
+#endif
+
+#endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 46137cb4d6..94e667a530 100644
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
@@ -456,6 +462,7 @@ struct perf_event {
 	perf_overflow_handler_t		overflow_handler;
 	void				*overflow_handler_context;
 
+	struct perf_event		*trace_event;
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
@@ -623,6 +630,7 @@ struct perf_sample_data {
 	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct perf_trace_record	trace;
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
@@ -643,6 +651,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->period = period;
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
+	data->trace.from = data->trace.to = data->trace.size = 0;
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
@@ -804,6 +813,11 @@ static inline bool has_aux(struct perf_event *event)
 	return event->pmu->setup_aux;
 }
 
+static inline bool is_itrace_event(struct perf_event *event)
+{
+	return !!(event->pmu->capabilities & PERF_PMU_CAP_ITRACE);
+}
+
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 500e18b8e9..fbc2b51ad1 100644
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
@@ -239,7 +240,9 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
 					/* add: aux_watermark */
-#define PERF_ATTR_SIZE_VER4	104	/* add: itrace_config */
+#define PERF_ATTR_SIZE_VER4	120	/* add: itrace_config */
+					/* add: itrace_sample_size */
+					/* add: itrace_sample_type */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -343,6 +346,11 @@ struct perf_event_attr {
 	 * Itrace pmus' event config
 	 */
 	__u64	itrace_config;
+	__u64	itrace_sample_size;
+	__u32	itrace_sample_type;	/* pmu->type of the itrace PMU */
+
+	/* Align to u64. */
+	__u32	__reserved_2;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -716,6 +724,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			size;
+	 *	  char			data[size]; } && PERF_SAMPLE_ITRACE
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d147b..46a37708d0 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,7 +2,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o callchain.o
+obj-y := core.o ring_buffer.o callchain.o itrace.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c0f05f8748..7a3ffda1c0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -41,6 +41,7 @@
 #include <linux/cgroup.h>
 #include <linux/module.h>
 #include <linux/mman.h>
+#include <linux/itrace.h>
 
 #include "internal.h"
 
@@ -1595,6 +1596,9 @@ void perf_event_disable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->trace_event)
+		perf_event_disable(event->trace_event);
+
 	if (!task) {
 		/*
 		 * Disable the event on the cpu that it's on
@@ -2094,6 +2098,8 @@ void perf_event_enable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->trace_event)
+		perf_event_enable(event->trace_event);
 	if (!task) {
 		/*
 		 * Enable the event on the cpu that it's on
@@ -3250,6 +3256,8 @@ static void unaccount_event(struct perf_event *event)
 		static_key_slow_dec_deferred(&perf_sched_events);
 	if (has_branch_stack(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
+	if ((event->attr.sample_type & PERF_SAMPLE_ITRACE))
+		itrace_sampler_fini(event);
 
 	unaccount_event_cpu(event, event->cpu);
 }
@@ -4781,6 +4789,13 @@ void perf_output_sample(struct perf_output_handle *handle,
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
 
@@ -4888,6 +4903,14 @@ void perf_prepare_sample(struct perf_event_header *header,
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
@@ -7040,6 +7063,21 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			if (err)
 				goto err_pmu;
 		}
+
+		if (event->attr.sample_type & PERF_SAMPLE_ITRACE) {
+			struct pmu *itrace_pmu;
+			int idx;
+
+			idx = srcu_read_lock(&pmus_srcu);
+			itrace_pmu = __perf_find_pmu(event->attr.itrace_sample_type);
+			err = itrace_sampler_init(event, task, itrace_pmu);
+			srcu_read_unlock(&pmus_srcu, idx);
+
+			if (err) {
+				put_callchain_buffers();
+				goto err_pmu;
+			}
+		}
 	}
 
 	return event;
diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
new file mode 100644
index 0000000000..f57b2ab31e
--- /dev/null
+++ b/kernel/events/itrace.c
@@ -0,0 +1,159 @@
+/*
+ * Instruction flow trace unit infrastructure
+ * Copyright (c) 2013-2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#undef DEBUG
+
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <linux/itrace.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+static void itrace_event_destroy(struct perf_event *event)
+{
+	struct ring_buffer *rb = event->rb;
+
+	if (!rb)
+		return;
+
+	ring_buffer_put(rb); /* can be last */
+}
+
+/*
+ * Trace sample annotation
+ * For events that have attr.sample_type & PERF_SAMPLE_ITRACE, perf calls here
+ * to configure and obtain itrace samples.
+ */
+
+int itrace_sampler_init(struct perf_event *event, struct task_struct *task,
+			struct pmu *pmu)
+{
+	struct perf_event_attr attr;
+	struct perf_event *tevt;
+	struct ring_buffer *rb;
+	unsigned long nr_pages;
+
+	if (!pmu || !(pmu->capabilities & PERF_PMU_CAP_ITRACE))
+		return -ENOTSUPP;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = pmu->type;
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
+	nr_pages = 1ul << __get_order(event->attr.itrace_sample_size);
+
+	rb = rb_alloc_kernel(tevt, 0, nr_pages);
+	if (!rb) {
+		perf_event_release_kernel(tevt);
+		return -ENOMEM;
+	}
+
+	event->trace_event = tevt;
+	tevt->destroy = itrace_event_destroy;
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
+	/* might get free'd from event->destroy() path */
+	if (!tevt)
+		return;
+
+	perf_event_release_kernel(tevt);
+
+	event->trace_event = NULL;
+}
+
+unsigned long itrace_sampler_trace(struct perf_event *event,
+				   struct perf_sample_data *data)
+{
+	struct perf_event *tevt = event->trace_event;
+	struct ring_buffer *rb;
+
+	if (!tevt || tevt->state != PERF_EVENT_STATE_ACTIVE) {
+		data->trace.size = 0;
+		goto out;
+	}
+
+	rb = ring_buffer_get(tevt);
+	if (!rb) {
+		data->trace.size = 0;
+		goto out;
+	}
+
+	tevt->pmu->del(tevt, 0);
+
+	data->trace.to = local_read(&rb->aux_head);
+
+	if (data->trace.to < tevt->attr.itrace_sample_size)
+		data->trace.from = rb->aux_nr_pages * PAGE_SIZE +
+			data->trace.to - tevt->attr.itrace_sample_size;
+	else
+		data->trace.from = data->trace.to -
+			tevt->attr.itrace_sample_size;
+	data->trace.size = ALIGN(tevt->attr.itrace_sample_size, sizeof(u64));
+	ring_buffer_put(rb);
+
+out:
+	return data->trace.size;
+}
+
+void itrace_sampler_output(struct perf_event *event,
+			   struct perf_output_handle *handle,
+			   struct perf_sample_data *data)
+{
+	struct perf_event *tevt = event->trace_event;
+	struct ring_buffer *rb;
+	unsigned long pad;
+	int ret;
+
+	if (WARN_ON_ONCE(!tevt || !data->trace.size))
+		return;
+
+	rb = ring_buffer_get(tevt);
+	if (WARN_ON_ONCE(!rb))
+		return;
+	ret = rb_output_aux(rb, data->trace.from, data->trace.to,
+			    (aux_copyfn)perf_output_copy, handle);
+	if (ret < 0) {
+		pr_warn_ratelimited("failed to copy trace data\n");
+		goto out;
+	}
+
+	pad = data->trace.size - ret;
+	if (pad) {
+		u64 p = 0;
+
+		perf_output_copy(handle, &p, pad);
+	}
+out:
+	ring_buffer_put(rb);
+	tevt->pmu->add(tevt, PERF_EF_START);
+}
-- 
2.1.0.rc1

