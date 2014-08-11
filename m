Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaHKFjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:39:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:27340 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaHKFi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="574813740"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 23/23] perf: itrace: Allow sampling of inherited events
Date: Mon, 11 Aug 2014 08:19:52 +0300
Message-Id: <1407734392-31097-24-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to find an itrace sampler event for the current event if none is linked.
This is useful when these events are allocated by inheritance path,
independently of one another.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/itrace.c | 91 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 31 deletions(-)

diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
index eae85cf578..7dbac8ac63 100644
--- a/kernel/events/itrace.c
+++ b/kernel/events/itrace.c
@@ -48,46 +48,66 @@ static bool itrace_event_match(struct perf_event *e1, struct perf_event *e2)
  * to configure and obtain itrace samples.
  */
 
+struct perf_event *__find_sampling_counter(struct perf_event_context *ctx,
+					   struct perf_event *event,
+					   struct task_struct *task)
+{
+	struct perf_event *sampler = NULL;
+
+	list_for_each_entry(sampler, &ctx->event_list, event_entry) {
+		/*
+		 * event is not an itrace event, but all the relevant
+		 * bits should match
+		 */
+		if (itrace_event_match(sampler, event) &&
+		    kernel_rb_event(sampler) &&
+		    sampler->attr.exclude_hv == event->attr.exclude_hv &&
+		    sampler->attr.exclude_idle == event->attr.exclude_idle &&
+		    sampler->attr.exclude_user == event->attr.exclude_user &&
+		    sampler->attr.exclude_kernel == event->attr.exclude_kernel &&
+		    sampler->attr.itrace_config == event->attr.itrace_config &&
+		    sampler->attr.type == event->attr.itrace_sample_type &&
+		    sampler->attr.itrace_sample_size >= event->attr.itrace_sample_size &&
+		    atomic_long_inc_not_zero(&sampler->refcount))
+			return sampler;
+	}
+
+	return NULL;
+}
+
+struct perf_event *find_sampling_counter(struct pmu *pmu,
+					 struct perf_event *event,
+					 struct task_struct *task)
+{
+	struct perf_event_context *ctx;
+	struct perf_event *sampler = NULL;
+	unsigned long flags;
+
+	ctx = find_get_context(pmu, task, event->cpu);
+	if (!ctx)
+		return NULL;
+
+	raw_spin_lock_irqsave(&ctx->lock, flags);
+	sampler = __find_sampling_counter(ctx, event, task);
+	--ctx->pin_count;
+	put_ctx(ctx);
+	raw_spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return sampler;
+}
+
 int itrace_sampler_init(struct perf_event *event, struct task_struct *task,
 			struct pmu *pmu)
 {
-	struct perf_event_context *ctx;
 	struct perf_event_attr attr;
 	struct perf_event *tevt = NULL;
 	struct ring_buffer *rb;
-	unsigned long nr_pages, flags;
+	unsigned long nr_pages;
 
 	if (!pmu || !(pmu->capabilities & PERF_PMU_CAP_ITRACE))
 		return -ENOTSUPP;
 
-	ctx = find_get_context(pmu, task, event->cpu);
-	if (ctx) {
-		raw_spin_lock_irqsave(&ctx->lock, flags);
-		list_for_each_entry(tevt, &ctx->event_list, event_entry) {
-			/*
-			 * event is not an itrace event, but all the relevant
-			 * bits should match
-			 */
-			if (itrace_event_match(tevt, event) &&
-			    tevt->attr.exclude_hv == event->attr.exclude_hv &&
-			    tevt->attr.exclude_idle == event->attr.exclude_idle &&
-			    tevt->attr.exclude_user == event->attr.exclude_user &&
-			    tevt->attr.exclude_kernel == event->attr.exclude_kernel &&
-			    tevt->attr.itrace_config == event->attr.itrace_config &&
-			    tevt->attr.type == event->attr.itrace_sample_type &&
-			    tevt->attr.itrace_sample_size >= event->attr.itrace_sample_size &&
-			    atomic_long_inc_not_zero(&tevt->refcount))
-				goto got_event;
-		}
-
-		tevt = NULL;
-
-got_event:
-		--ctx->pin_count;
-		put_ctx(ctx);
-		raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	}
-
+	tevt = find_sampling_counter(pmu, event, task);
 	if (!tevt) {
 		memset(&attr, 0, sizeof(attr));
 		attr.type = pmu->type;
@@ -139,9 +159,18 @@ void itrace_sampler_fini(struct perf_event *event)
 unsigned long itrace_sampler_trace(struct perf_event *event,
 				   struct perf_sample_data *data)
 {
-	struct perf_event *tevt = event->trace_event;
+	struct perf_event *tevt;
 	struct ring_buffer *rb;
 
+	if (!event->trace_event) {
+		/*
+		 * down this path, event->ctx is already locked IF it's the
+		 * same context
+		 */
+		event->trace_event = __find_sampling_counter(event->ctx, event, event->ctx->task);
+	}
+
+	tevt = event->trace_event;
 	/* Don't go further if the event is being scheduled out */
 	if (!tevt || tevt->state != PERF_EVENT_STATE_ACTIVE) {
 		data->trace.size = 0;
-- 
2.1.0.rc1

