Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaKKOu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:50:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:5611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaKKOuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:50:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630166381"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v7 08/14] perf: Support overwrite mode for AUX area
Date: Tue, 11 Nov 2014 16:48:22 +0200
Message-Id: <1415717308-209223-9-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for overwrite mode in the AUX area, which means "keep
collecting data till you're stopped", turning AUX area into a circular
buffer, where new data overwrites old data. It does not depend on data
buffer's overwrite mode, so that it doesn't lose sideband data that is
instrumental for processing AUX data.

Overwrite mode is enabled at mapping AUX area read only. Even though
aux_tail in the buffer's user page might be user writable, it will be
ignored in this mode.

A PERF_RECORD_AUX with PERF_AUX_FLAG_OVERWRITE set is written to the perf
data stream every time an event writes new data to the AUX area. The pmu
driver might not be able to infer the exact beginning of the new data in
each snapshot, some drivers will only provide the tail, which is
aux_offset + aux_size in the AUX record. Consumer has to be able to tell
the new data from the old one, for example, by means of time stamps if
such are provided in the trace.

Consumer is also responsible for disabling any events that might write
to the AUX area (thus potentially racing with the consumer) before
collecting the data.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/internal.h        |  1 +
 kernel/events/ring_buffer.c     | 48 ++++++++++++++++++++++++++++-------------
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 272258380e..f36aac2ac5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -768,6 +768,7 @@ enum perf_callchain_context {
  * PERF_RECORD_AUX::flags bits
  */
 #define PERF_AUX_FLAG_TRUNCATED		0x01	/* record was truncated to fit */
+#define PERF_AUX_FLAG_OVERWRITE		0x02	/* snapshot from overwrite mode */
 
 #define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
 #define PERF_FLAG_FD_OUTPUT		(1UL << 1)
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b701ebc325..ffd51d9f59 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -40,6 +40,7 @@ struct ring_buffer {
 	local_t				aux_nest;
 	unsigned long			aux_pgoff;
 	int				aux_nr_pages;
+	int				aux_overwrite;
 	atomic_t			aux_mmap_count;
 	unsigned long			aux_mmap_locked;
 	void				(*free_aux)(void *);
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index e452776b62..6f8bc8e962 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -282,26 +282,33 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 		goto err_put;
 
 	aux_head = local_read(&rb->aux_head);
-	aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
 
 	handle->rb = rb;
 	handle->event = event;
 	handle->head = aux_head;
-	if (aux_head - aux_tail < perf_aux_size(rb))
-		handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
-	else
-		handle->size = 0;
+	handle->size = 0;
 
 	/*
-	 * handle->size computation depends on aux_tail load; this forms a
-	 * control dependency barrier separating aux_tail load from aux data
-	 * store that will be enabled on successful return
+	 * In overwrite mode, AUX data stores do not depend on aux_tail,
+	 * therefore (A) control dependency barrier does not exist. The
+	 * (B) <-> (C) ordering is still observed by the pmu driver.
 	 */
-	if (!handle->size) { /* A, matches D */
-		event->pending_disable = 1;
-		perf_output_wakeup(handle);
-		local_set(&rb->aux_nest, 0);
-		goto err_put;
+	if (!rb->aux_overwrite) {
+		aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
+		if (aux_head - aux_tail < perf_aux_size(rb))
+			handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
+
+		/*
+		 * handle->size computation depends on aux_tail load; this forms a
+		 * control dependency barrier separating aux_tail load from aux data
+		 * store that will be enabled on successful return
+		 */
+		if (!handle->size) { /* A, matches D */
+			event->pending_disable = 1;
+			perf_output_wakeup(handle);
+			local_set(&rb->aux_nest, 0);
+			goto err_put;
+		}
 	}
 
 	return handle->rb->aux_priv;
@@ -326,13 +333,22 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 			 bool truncated)
 {
 	struct ring_buffer *rb = handle->rb;
-	unsigned long aux_head = local_read(&rb->aux_head);
+	unsigned long aux_head;
 	u64 flags = 0;
 
 	if (truncated)
 		flags |= PERF_AUX_FLAG_TRUNCATED;
 
-	local_add(size, &rb->aux_head);
+	/* in overwrite mode, driver provides aux_head via handle */
+	if (rb->aux_overwrite) {
+		flags |= PERF_AUX_FLAG_OVERWRITE;
+
+		aux_head = handle->head;
+		local_set(&rb->aux_head, aux_head);
+	} else {
+		aux_head = local_read(&rb->aux_head);
+		local_add(size, &rb->aux_head);
+	}
 
 	if (size || flags) {
 		/*
@@ -476,6 +492,8 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	 */
 	atomic_set(&rb->aux_refcount, 1);
 
+	rb->aux_overwrite = overwrite;
+
 out:
 	if (!ret)
 		rb->aux_pgoff = pgoff;
-- 
2.1.1

