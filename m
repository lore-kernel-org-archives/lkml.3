Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaJMNsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:1676 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbaJMNsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="617731470"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 19/20] perf: Allow AUX sampling for multiple events
Date: Mon, 13 Oct 2014 16:45:47 +0300
Message-Id: <1413207948-28202-20-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, only one perf event in a context at a time can be annotated with
AUX data, because AUX pmus will normally have only one event scheduled at a
time, however it should be possible to annotate several events with similar
configuration (wrt exclude_{hv,idle,user,kernel}, config and other event
attribute fields) using the same AUX event.

This patch changes the behavior so that every time, before a kernel counter
is created for AUX sampling, we first look for an existing counter that is
suitable in terms of configuration and we use it to annotate the new event
as well. If no such event is found, we fall back to the old path and try
to allocate a new kernel counter.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 93 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 66 insertions(+), 27 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 60e354d668..ad7b1e92dd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4651,45 +4651,84 @@ static void perf_aux_sampler_destroy(struct perf_event *event)
 	ring_buffer_put(rb); /* can be last */
 }
 
+static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2);
+
+static bool perf_aux_event_match(struct perf_event *e1, struct perf_event *e2)
+{
+	return has_aux(e1) && exclusive_event_match(e1, e2);
+}
+
 static int perf_aux_sampler_init(struct perf_event *event,
 				 struct task_struct *task,
 				 struct pmu *pmu)
 {
+	struct perf_event_context *ctx;
 	struct perf_event_attr attr;
-	struct perf_event *sampler;
+	struct perf_event *sampler = NULL;
 	struct ring_buffer *rb;
-	unsigned long nr_pages;
+	unsigned long nr_pages, flags;
 
 	if (!pmu || !(pmu->setup_aux))
 		return -ENOTSUPP;
 
-	memset(&attr, 0, sizeof(attr));
-	attr.type = pmu->type;
-	attr.config = event->attr.aux_sample_config;
-	attr.sample_type = 0;
-	attr.disabled = event->attr.disabled;
-	attr.enable_on_exec = event->attr.enable_on_exec;
-	attr.exclude_hv = event->attr.exclude_hv;
-	attr.exclude_idle = event->attr.exclude_idle;
-	attr.exclude_user = event->attr.exclude_user;
-	attr.exclude_kernel = event->attr.exclude_kernel;
-	attr.aux_sample_size = event->attr.aux_sample_size;
-
-	sampler = perf_event_create_kernel_counter(&attr, event->cpu, task,
-						   NULL, NULL);
-	if (IS_ERR(sampler))
-		return PTR_ERR(sampler);
-
-	nr_pages = 1ul << __get_order(event->attr.aux_sample_size);
-
-	rb = rb_alloc_kernel(sampler, 0, nr_pages);
-	if (!rb) {
-		perf_event_release_kernel(sampler);
-		return -ENOMEM;
+	ctx = find_get_context(pmu, task, event->cpu);
+	if (ctx) {
+		raw_spin_lock_irqsave(&ctx->lock, flags);
+		list_for_each_entry(sampler, &ctx->event_list, event_entry) {
+			/*
+			 * event is not an aux event, but all the relevant
+			 * bits should match
+			 */
+			if (perf_aux_event_match(sampler, event) &&
+			    sampler->attr.type == event->attr.aux_sample_type &&
+			    sampler->attr.config == event->attr.aux_sample_config &&
+			    sampler->attr.exclude_hv == event->attr.exclude_hv &&
+			    sampler->attr.exclude_idle == event->attr.exclude_idle &&
+			    sampler->attr.exclude_user == event->attr.exclude_user &&
+			    sampler->attr.exclude_kernel == event->attr.exclude_kernel &&
+			    sampler->attr.aux_sample_size >= event->attr.aux_sample_size &&
+			    atomic_long_inc_not_zero(&sampler->refcount))
+				goto got_event;
+		}
+
+		sampler = NULL;
+
+got_event:
+		--ctx->pin_count;
+		put_ctx(ctx);
+		raw_spin_unlock_irqrestore(&ctx->lock, flags);
+	}
+
+	if (!sampler) {
+		memset(&attr, 0, sizeof(attr));
+		attr.type = pmu->type;
+		attr.config = event->attr.aux_sample_config;
+		attr.sample_type = 0;
+		attr.disabled = event->attr.disabled;
+		attr.enable_on_exec = event->attr.enable_on_exec;
+		attr.exclude_hv = event->attr.exclude_hv;
+		attr.exclude_idle = event->attr.exclude_idle;
+		attr.exclude_user = event->attr.exclude_user;
+		attr.exclude_kernel = event->attr.exclude_kernel;
+		attr.aux_sample_size = event->attr.aux_sample_size;
+
+		sampler = perf_event_create_kernel_counter(&attr, event->cpu,
+							   task, NULL, NULL);
+		if (IS_ERR(sampler))
+			return PTR_ERR(sampler);
+
+		nr_pages = 1ul << __get_order(event->attr.aux_sample_size);
+
+		rb = rb_alloc_kernel(sampler, 0, nr_pages);
+		if (!rb) {
+			perf_event_release_kernel(sampler);
+			return -ENOMEM;
+		}
+
+		sampler->destroy = perf_aux_sampler_destroy;
 	}
 
 	event->sampler = sampler;
-	sampler->destroy = perf_aux_sampler_destroy;
 
 	return 0;
 }
@@ -4702,7 +4741,7 @@ static void perf_aux_sampler_fini(struct perf_event *event)
 	if (!sampler)
 		return;
 
-	perf_event_release_kernel(sampler);
+	put_event(sampler);
 
 	event->sampler = NULL;
 }
-- 
2.1.0

