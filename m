Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaHKFhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:37:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:50093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaHKFhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="556699977"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 22/23] perf: itrace: Allow itrace sampling for multiple events
Date: Mon, 11 Aug 2014 08:19:51 +0300
Message-Id: <1407734392-31097-23-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, only one perf event can be annotated with itrace data, however
it should be possible to annotate several events with similar configuration
(wrt exclude_{hv,idle,user,kernel}, itrace_config, etc).

So every time, before a kernel counter is created for itrace sampling, we
first look for an existing counter that is suitable in terms of configuration
and we use it to annotate the new event as well.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c     |  6 ++--
 kernel/events/internal.h |  4 +++
 kernel/events/itrace.c   | 94 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 77 insertions(+), 27 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c2f02ea6d7..89d61178df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -891,7 +891,7 @@ static void get_ctx(struct perf_event_context *ctx)
 	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
-static void put_ctx(struct perf_event_context *ctx)
+void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
 		if (ctx->parent_ctx)
@@ -3130,7 +3130,7 @@ errout:
 /*
  * Returns a matching context with refcount and pincount.
  */
-static struct perf_event_context *
+struct perf_event_context *
 find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 {
 	struct perf_event_context *ctx;
@@ -3324,7 +3324,7 @@ static void free_event(struct perf_event *event)
 /*
  * Called when the last reference to the file is gone.
  */
-static void put_event(struct perf_event *event)
+void put_event(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b306bc9307..4cea5578b9 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -55,6 +55,10 @@ struct ring_buffer {
 typedef unsigned long (*aux_copyfn)(void *data, const void *src,
 				    unsigned long len);
 
+extern struct perf_event_context *
+find_get_context(struct pmu *pmu, struct task_struct *task, int cpu);
+extern void put_ctx(struct perf_event_context *ctx);
+void put_event(struct perf_event *event);
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
index f57b2ab31e..eae85cf578 100644
--- a/kernel/events/itrace.c
+++ b/kernel/events/itrace.c
@@ -32,6 +32,16 @@ static void itrace_event_destroy(struct perf_event *event)
 	ring_buffer_put(rb); /* can be last */
 }
 
+static bool itrace_event_match(struct perf_event *e1, struct perf_event *e2)
+{
+	if (is_itrace_event(e1) &&
+	    (e1->cpu == e2->cpu ||
+	     e1->cpu == -1 ||
+	     e2->cpu == -1))
+		return true;
+	return false;
+}
+
 /*
  * Trace sample annotation
  * For events that have attr.sample_type & PERF_SAMPLE_ITRACE, perf calls here
@@ -41,39 +51,74 @@ static void itrace_event_destroy(struct perf_event *event)
 int itrace_sampler_init(struct perf_event *event, struct task_struct *task,
 			struct pmu *pmu)
 {
+	struct perf_event_context *ctx;
 	struct perf_event_attr attr;
-	struct perf_event *tevt;
+	struct perf_event *tevt = NULL;
 	struct ring_buffer *rb;
-	unsigned long nr_pages;
+	unsigned long nr_pages, flags;
 
 	if (!pmu || !(pmu->capabilities & PERF_PMU_CAP_ITRACE))
 		return -ENOTSUPP;
 
-	memset(&attr, 0, sizeof(attr));
-	attr.type = pmu->type;
-	attr.config = 0;
-	attr.sample_type = 0;
-	attr.exclude_user = event->attr.exclude_user;
-	attr.exclude_kernel = event->attr.exclude_kernel;
-	attr.itrace_sample_size = event->attr.itrace_sample_size;
-	attr.itrace_config = event->attr.itrace_config;
-
-	tevt = perf_event_create_kernel_counter(&attr, event->cpu, task, NULL, NULL);
-	if (IS_ERR(tevt))
-		return PTR_ERR(tevt);
-
-	nr_pages = 1ul << __get_order(event->attr.itrace_sample_size);
+	ctx = find_get_context(pmu, task, event->cpu);
+	if (ctx) {
+		raw_spin_lock_irqsave(&ctx->lock, flags);
+		list_for_each_entry(tevt, &ctx->event_list, event_entry) {
+			/*
+			 * event is not an itrace event, but all the relevant
+			 * bits should match
+			 */
+			if (itrace_event_match(tevt, event) &&
+			    tevt->attr.exclude_hv == event->attr.exclude_hv &&
+			    tevt->attr.exclude_idle == event->attr.exclude_idle &&
+			    tevt->attr.exclude_user == event->attr.exclude_user &&
+			    tevt->attr.exclude_kernel == event->attr.exclude_kernel &&
+			    tevt->attr.itrace_config == event->attr.itrace_config &&
+			    tevt->attr.type == event->attr.itrace_sample_type &&
+			    tevt->attr.itrace_sample_size >= event->attr.itrace_sample_size &&
+			    atomic_long_inc_not_zero(&tevt->refcount))
+				goto got_event;
+		}
+
+		tevt = NULL;
+
+got_event:
+		--ctx->pin_count;
+		put_ctx(ctx);
+		raw_spin_unlock_irqrestore(&ctx->lock, flags);
+	}
 
-	rb = rb_alloc_kernel(tevt, 0, nr_pages);
-	if (!rb) {
-		perf_event_release_kernel(tevt);
-		return -ENOMEM;
+	if (!tevt) {
+		memset(&attr, 0, sizeof(attr));
+		attr.type = pmu->type;
+		attr.config = 0;
+		attr.sample_type = 0;
+		attr.exclude_hv = event->attr.exclude_hv;
+		attr.exclude_idle = event->attr.exclude_idle;
+		attr.exclude_user = event->attr.exclude_user;
+		attr.exclude_kernel = event->attr.exclude_kernel;
+		attr.itrace_sample_size = event->attr.itrace_sample_size;
+		attr.itrace_config = event->attr.itrace_config;
+
+		tevt = perf_event_create_kernel_counter(&attr, event->cpu, task,
+							NULL, NULL);
+		if (IS_ERR(tevt))
+			return PTR_ERR(tevt);
+
+		nr_pages = 1ul << __get_order(event->attr.itrace_sample_size);
+
+		rb = rb_alloc_kernel(tevt, 0, nr_pages);
+		if (!rb) {
+			perf_event_release_kernel(tevt);
+			return -ENOMEM;
+		}
+
+		tevt->destroy = itrace_event_destroy;
+		if (event->state != PERF_EVENT_STATE_OFF)
+			perf_event_enable(event->trace_event);
 	}
 
 	event->trace_event = tevt;
-	tevt->destroy = itrace_event_destroy;
-	if (event->state != PERF_EVENT_STATE_OFF)
-		perf_event_enable(event->trace_event);
 
 	return 0;
 }
@@ -86,7 +131,7 @@ void itrace_sampler_fini(struct perf_event *event)
 	if (!tevt)
 		return;
 
-	perf_event_release_kernel(tevt);
+	put_event(tevt);
 
 	event->trace_event = NULL;
 }
@@ -97,6 +142,7 @@ unsigned long itrace_sampler_trace(struct perf_event *event,
 	struct perf_event *tevt = event->trace_event;
 	struct ring_buffer *rb;
 
+	/* Don't go further if the event is being scheduled out */
 	if (!tevt || tevt->state != PERF_EVENT_STATE_ACTIVE) {
 		data->trace.size = 0;
 		goto out;
-- 
2.1.0.rc1

