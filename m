Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaJMNsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:63957 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbaJMNsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="604522484"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 20/20] perf: Allow AUX sampling of inherited events
Date: Mon, 13 Oct 2014 16:45:48 +0300
Message-Id: <1413207948-28202-21-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to find an AUX sampler event for the current event if none is linked
via event::sampler.

This is useful when these events (the one that is being sampled and the
one providing sample annotation) are allocated by inheritance path,
independently of one another and the latter is not yet referenced by the
former's event::sampler.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 94 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 32 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ad7b1e92dd..02fcd84b0f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4658,47 +4658,67 @@ static bool perf_aux_event_match(struct perf_event *e1, struct perf_event *e2)
 	return has_aux(e1) && exclusive_event_match(e1, e2);
 }
 
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
+		if (perf_aux_event_match(sampler, event) &&
+		    kernel_rb_event(sampler) &&
+		    sampler->attr.type == event->attr.aux_sample_type &&
+		    sampler->attr.config == event->attr.aux_sample_config &&
+		    sampler->attr.exclude_hv == event->attr.exclude_hv &&
+		    sampler->attr.exclude_idle == event->attr.exclude_idle &&
+		    sampler->attr.exclude_user == event->attr.exclude_user &&
+		    sampler->attr.exclude_kernel == event->attr.exclude_kernel &&
+		    sampler->attr.aux_sample_size >= event->attr.aux_sample_size &&
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
 static int perf_aux_sampler_init(struct perf_event *event,
 				 struct task_struct *task,
 				 struct pmu *pmu)
 {
-	struct perf_event_context *ctx;
 	struct perf_event_attr attr;
-	struct perf_event *sampler = NULL;
+	struct perf_event *sampler;
 	struct ring_buffer *rb;
-	unsigned long nr_pages, flags;
+	unsigned long nr_pages;
 
 	if (!pmu || !(pmu->setup_aux))
 		return -ENOTSUPP;
 
-	ctx = find_get_context(pmu, task, event->cpu);
-	if (ctx) {
-		raw_spin_lock_irqsave(&ctx->lock, flags);
-		list_for_each_entry(sampler, &ctx->event_list, event_entry) {
-			/*
-			 * event is not an aux event, but all the relevant
-			 * bits should match
-			 */
-			if (perf_aux_event_match(sampler, event) &&
-			    sampler->attr.type == event->attr.aux_sample_type &&
-			    sampler->attr.config == event->attr.aux_sample_config &&
-			    sampler->attr.exclude_hv == event->attr.exclude_hv &&
-			    sampler->attr.exclude_idle == event->attr.exclude_idle &&
-			    sampler->attr.exclude_user == event->attr.exclude_user &&
-			    sampler->attr.exclude_kernel == event->attr.exclude_kernel &&
-			    sampler->attr.aux_sample_size >= event->attr.aux_sample_size &&
-			    atomic_long_inc_not_zero(&sampler->refcount))
-				goto got_event;
-		}
-
-		sampler = NULL;
-
-got_event:
-		--ctx->pin_count;
-		put_ctx(ctx);
-		raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	}
-
+	sampler = find_sampling_counter(pmu, event, task);
 	if (!sampler) {
 		memset(&attr, 0, sizeof(attr));
 		attr.type = pmu->type;
@@ -4749,9 +4769,19 @@ static void perf_aux_sampler_fini(struct perf_event *event)
 static unsigned long perf_aux_sampler_trace(struct perf_event *event,
 					    struct perf_sample_data *data)
 {
-	struct perf_event *sampler = event->sampler;
+	struct perf_event *sampler;
 	struct ring_buffer *rb;
 
+	if (!event->sampler) {
+		/*
+		 * down this path, event->ctx is already locked IF it's the
+		 * same context
+		 */
+		event->sampler = __find_sampling_counter(event->ctx, event,
+							 event->ctx->task);
+	}
+
+	sampler = event->sampler;
 	if (!sampler || sampler->state != PERF_EVENT_STATE_ACTIVE) {
 		data->aux.size = 0;
 		goto out;
-- 
2.1.0

