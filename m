Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaJMNsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:59865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaJMNsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="399419925"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 17/20] perf: Add infrastructure for using AUX data in perf samples
Date: Mon, 13 Oct 2014 16:45:45 +0300
Message-Id: <1413207948-28202-18-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AUX data can be used to annotate perf events such as performance counters
or tracepoints/breakpoints by including it in sample records when
PERF_SAMPLE_AUX flag is set. Such samples would be instrumental in debugging
and profiling by providing, for example, a history of instruction flow
leading up to the event's overflow.

To facilitate this, this patch adds code to create a kernel counter with a
ring buffer using rb_{alloc,free}_kernel() interface for each event that
needs to include AUX samples and to copy AUX data from it into the perf
data stream.

The user interface is extended to allow for this, new attribute fields are
added:

  * aux_sample_type: specify PMU on which the AUX data generating event
                     is created;
  * aux_sample_config: event config (maps to attribute's config field),
  * aux_sample_size: size of the sample to be written.

This kernel counter is configured similarly to the event that is being
annotated with regards to filtering (exclude_{hv,idle,user,kernel}) and
enabled state (disabled, enable_on_exec) to make sure that the two events
are scheduled at the same time and that no out of context activity is
sampled.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h      |   9 +++
 include/uapi/linux/perf_event.h |  18 ++++-
 kernel/events/core.c            | 172 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 282721b2df..de8cc714e9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -84,6 +84,12 @@ struct perf_regs_user {
 	struct pt_regs	*regs;
 };
 
+struct perf_aux_record {
+	u64		size;
+	unsigned long	from;
+	unsigned long	to;
+};
+
 struct task_struct;
 
 /*
@@ -458,6 +464,7 @@ struct perf_event {
 	perf_overflow_handler_t		overflow_handler;
 	void				*overflow_handler_context;
 
+	struct perf_event		*sampler;
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
@@ -628,6 +635,7 @@ struct perf_sample_data {
 	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct perf_aux_record		aux;
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
@@ -655,6 +663,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->period = period;
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
+	data->aux.from = data->aux.to = data->aux.size = 0;
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = PERF_MEM_NA;
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index a0cafbdc1c..ed2e21fa13 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_AUX				= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -239,6 +240,9 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
 					/* add: aux_watermark */
+#define PERF_ATTR_SIZE_VER4	120	/* add: aux_sample_config */
+					/* add: aux_sample_size */
+					/* add: aux_sample_type */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -337,6 +341,16 @@ struct perf_event_attr {
 	 * Wakeup watermark for AUX area
 	 */
 	__u32	aux_watermark;
+
+	/*
+	 * Itrace pmus' event config
+	 */
+	__u64	aux_sample_config;	/* event config for AUX sampling */
+	__u64	aux_sample_size;	/* desired sample size */
+	__u32	aux_sample_type;	/* pmu->type of an AUX PMU */
+
+	/* Align to u64. */
+	__u32	__reserved_2;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -710,6 +724,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			size;
+	 *	  char			data[size]; } && PERF_SAMPLE_AUX
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 92da1aecc7..5da1bc403f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1647,6 +1647,9 @@ void perf_event_disable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->sampler)
+		perf_event_disable(event->sampler);
+
 	if (!task) {
 		/*
 		 * Disable the event on the cpu that it's on
@@ -2149,6 +2152,8 @@ void perf_event_enable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->sampler)
+		perf_event_enable(event->sampler);
 	if (!task) {
 		/*
 		 * Enable the event on the cpu that it's on
@@ -3287,6 +3292,8 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
 }
 
+static void perf_aux_sampler_fini(struct perf_event *event);
+
 static void unaccount_event(struct perf_event *event)
 {
 	if (event->parent)
@@ -3306,6 +3313,8 @@ static void unaccount_event(struct perf_event *event)
 		static_key_slow_dec_deferred(&perf_sched_events);
 	if (has_branch_stack(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
+	if ((event->attr.sample_type & PERF_SAMPLE_AUX))
+		perf_aux_sampler_fini(event);
 
 	unaccount_event_cpu(event, event->cpu);
 }
@@ -4632,6 +4641,139 @@ perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
 	}
 }
 
+static void perf_aux_sampler_destroy(struct perf_event *event)
+{
+	struct ring_buffer *rb = event->rb;
+
+	if (!rb)
+		return;
+
+	ring_buffer_put(rb); /* can be last */
+}
+
+static int perf_aux_sampler_init(struct perf_event *event,
+				 struct task_struct *task,
+				 struct pmu *pmu)
+{
+	struct perf_event_attr attr;
+	struct perf_event *sampler;
+	struct ring_buffer *rb;
+	unsigned long nr_pages;
+
+	if (!pmu || !(pmu->setup_aux))
+		return -ENOTSUPP;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = pmu->type;
+	attr.config = event->attr.aux_sample_config;
+	attr.sample_type = 0;
+	attr.disabled = event->attr.disabled;
+	attr.enable_on_exec = event->attr.enable_on_exec;
+	attr.exclude_hv = event->attr.exclude_hv;
+	attr.exclude_idle = event->attr.exclude_idle;
+	attr.exclude_user = event->attr.exclude_user;
+	attr.exclude_kernel = event->attr.exclude_kernel;
+	attr.aux_sample_size = event->attr.aux_sample_size;
+
+	sampler = perf_event_create_kernel_counter(&attr, event->cpu, task,
+						   NULL, NULL);
+	if (IS_ERR(sampler))
+		return PTR_ERR(sampler);
+
+	nr_pages = 1ul << __get_order(event->attr.aux_sample_size);
+
+	rb = rb_alloc_kernel(sampler, 0, nr_pages);
+	if (!rb) {
+		perf_event_release_kernel(sampler);
+		return -ENOMEM;
+	}
+
+	event->sampler = sampler;
+	sampler->destroy = perf_aux_sampler_destroy;
+
+	return 0;
+}
+
+static void perf_aux_sampler_fini(struct perf_event *event)
+{
+	struct perf_event *sampler = event->sampler;
+
+	/* might get free'd from event->destroy() path */
+	if (!sampler)
+		return;
+
+	perf_event_release_kernel(sampler);
+
+	event->sampler = NULL;
+}
+
+static unsigned long perf_aux_sampler_trace(struct perf_event *event,
+					    struct perf_sample_data *data)
+{
+	struct perf_event *sampler = event->sampler;
+	struct ring_buffer *rb;
+
+	if (!sampler || sampler->state != PERF_EVENT_STATE_ACTIVE) {
+		data->aux.size = 0;
+		goto out;
+	}
+
+	rb = ring_buffer_get(sampler);
+	if (!rb) {
+		data->aux.size = 0;
+		goto out;
+	}
+
+	sampler->pmu->del(sampler, 0);
+
+	data->aux.to = local_read(&rb->aux_head);
+
+	if (data->aux.to < sampler->attr.aux_sample_size)
+		data->aux.from = rb->aux_nr_pages * PAGE_SIZE +
+			data->aux.to - sampler->attr.aux_sample_size;
+	else
+		data->aux.from = data->aux.to -
+			sampler->attr.aux_sample_size;
+	data->aux.size = ALIGN(sampler->attr.aux_sample_size, sizeof(u64));
+	ring_buffer_put(rb);
+
+out:
+	return data->aux.size;
+}
+
+static void perf_aux_sampler_output(struct perf_event *event,
+				    struct perf_output_handle *handle,
+				    struct perf_sample_data *data)
+{
+	struct perf_event *sampler = event->sampler;
+	struct ring_buffer *rb;
+	unsigned long pad;
+	int ret;
+
+	if (WARN_ON_ONCE(!sampler || !data->aux.size))
+		return;
+
+	rb = ring_buffer_get(sampler);
+	if (WARN_ON_ONCE(!rb))
+		return;
+	ret = rb_output_aux(rb, data->aux.from, data->aux.to,
+			    (aux_copyfn)perf_output_copy, handle);
+	if (ret < 0) {
+		pr_warn_ratelimited("failed to copy trace data\n");
+		goto out;
+	}
+
+	pad = data->aux.size - ret;
+	if (pad) {
+		u64 p = 0;
+
+		perf_output_copy(handle, &p, pad);
+	}
+out:
+	ring_buffer_put(rb);
+	sampler->pmu->add(sampler, PERF_EF_START);
+}
+
 static void __perf_event_header__init_id(struct perf_event_header *header,
 					 struct perf_sample_data *data,
 					 struct perf_event *event)
@@ -4918,6 +5060,13 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_AUX) {
+		perf_output_put(handle, data->aux.size);
+
+		if (data->aux.size)
+			perf_aux_sampler_output(event, handle, data);
+	}
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
@@ -5025,6 +5174,14 @@ void perf_prepare_sample(struct perf_event_header *header,
 		data->stack_user_size = stack_size;
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_AUX) {
+		u64 size = sizeof(u64);
+
+		size += perf_aux_sampler_trace(event, data);
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -7172,6 +7329,21 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			if (err)
 				goto err_pmu;
 		}
+
+		if (event->attr.sample_type & PERF_SAMPLE_AUX) {
+			struct pmu *aux_pmu;
+			int idx;
+
+			idx = srcu_read_lock(&pmus_srcu);
+			aux_pmu = __perf_find_pmu(event->attr.aux_sample_type);
+			err = perf_aux_sampler_init(event, task, aux_pmu);
+			srcu_read_unlock(&pmus_srcu, idx);
+
+			if (err) {
+				put_callchain_buffers();
+				goto err_pmu;
+			}
+		}
 	}
 
 	return event;
-- 
2.1.0

