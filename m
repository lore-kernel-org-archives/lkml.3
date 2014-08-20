Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaHTMnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:43:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:57745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaHTMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="590749935"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
Date: Wed, 20 Aug 2014 15:36:06 +0300
Message-Id: <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for overwrite mode in the AUX area, which means "keep
collecting data till you're stopped". It does not depend on data buffer's
overwrite mode, so that it doesn't lose sideband data that is instrumental
for processing AUX data.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/internal.h    |  1 +
 kernel/events/ring_buffer.c | 43 +++++++++++++++++++++++++++++--------------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index c6b2987afe..4607742be8 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -40,6 +40,7 @@ struct ring_buffer {
 	local_t				aux_nest;
 	unsigned long			aux_pgoff;
 	int				aux_nr_pages;
+	int				aux_overwrite;
 	atomic_t			aux_mmap_count;
 	unsigned long			aux_mmap_locked;
 	void				**aux_pages;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 925f369947..5006caba63 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -263,22 +263,23 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 		goto err;
 
 	aux_head = local_read(&rb->aux_head);
-	aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
 
 	handle->rb = rb;
 	handle->event = event;
 	handle->head = aux_head;
-	if (aux_head - aux_tail < perf_aux_size(rb))
-		handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
-	else
-		handle->size = 0;
-
-	if (!handle->size) {
-		event->pending_disable = 1;
-		event->hw.state = PERF_HES_STOPPED;
-		perf_output_wakeup(handle);
-		local_set(&rb->aux_nest, 0);
-		goto err;
+	handle->size = 0;
+	if (!rb->aux_overwrite) {
+		aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
+		if (aux_head - aux_tail < perf_aux_size(rb))
+			handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
+
+		if (!handle->size) {
+			event->pending_disable = 1;
+			event->hw.state = PERF_HES_STOPPED;
+			perf_output_wakeup(handle);
+			local_set(&rb->aux_nest, 0);
+			goto err;
+		}
 	}
 
 	return handle->rb->aux_priv;
@@ -294,9 +295,22 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 			 bool truncated)
 {
 	struct ring_buffer *rb = handle->rb;
+	unsigned long aux_head;
 
-	local_add(size, &rb->aux_head);
-	perf_event_aux_event(handle->event, aux_head, size, truncated);
+	aux_head = local_read(&rb->aux_head);
+
+	if (rb->aux_overwrite) {
+		local_set(&rb->aux_head, size);
+
+		/*
+		 * Send a RECORD_AUX with size==0 to communicate aux_head
+		 * of this snapshot to userspace
+		 */
+		perf_event_aux_event(handle->event, size, 0, truncated);
+	} else {
+		local_add(size, &rb->aux_head);
+		perf_event_aux_event(handle->event, aux_head, size, truncated);
+	}
 
 	smp_wmb();
 	rb->user_page->aux_head = local_read(&rb->aux_head);
@@ -408,6 +422,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 					     overwrite);
 	if (rb->aux_priv)
 		ret = 0;
+	rb->aux_overwrite = overwrite;
 
 out:
 	if (!ret)
-- 
2.1.0

