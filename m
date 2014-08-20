Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaHTMma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:42:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:43442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaHTMm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="579289937"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 10/22] perf: Add wakeup watermark control to AUX area
Date: Wed, 20 Aug 2014 15:36:07 +0300
Message-Id: <1408538179-792-11-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When AUX area gets a certain amount of new data, we want to wake up
userspace to collect it. This adds a new control to specify how much
data will cause a wakeup. This is then passed down to pmu drivers via
output handle's "wakeup" field, so that the driver can find the nearest
point where it can generate an interrupt.

We repurpose __reserved_2 in the event attribute for this, even though
it was never checked to be zero before, aux_watermark will only matter
for new AUX-aware code, so the old code should still be fine.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h |  7 +++++--
 kernel/events/core.c            |  3 ++-
 kernel/events/internal.h        |  4 +++-
 kernel/events/ring_buffer.c     | 14 +++++++++++---
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index c022c3d756..507b5e1f5b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -238,6 +238,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
+					/* add: aux_watermark */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -332,8 +333,10 @@ struct perf_event_attr {
 	 */
 	__u32	sample_stack_user;
 
-	/* Align to u64. */
-	__u32	__reserved_2;
+	/*
+	 * Wakeup watermark for AUX area
+	 */
+	__u32	aux_watermark;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0251983018..c4551ac324 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4356,7 +4356,8 @@ accounting:
 		perf_event_init_userpage(event);
 		perf_event_update_userpage(event);
 	} else {
-		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages, flags);
+		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
+				   event->attr.aux_watermark, flags);
 		if (ret)
 			atomic_dec(&rb->mmap_count);
 		else
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 4607742be8..4f99987bc3 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -27,6 +27,7 @@ struct ring_buffer {
 	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
+	long				aux_watermark;
 	/* poll crap */
 	spinlock_t			event_lock;
 	struct list_head		event_list;
@@ -38,6 +39,7 @@ struct ring_buffer {
 	/* AUX area */
 	local_t				aux_head;
 	local_t				aux_nest;
+	local_t				aux_wakeup;
 	unsigned long			aux_pgoff;
 	int				aux_nr_pages;
 	int				aux_overwrite;
@@ -55,7 +57,7 @@ extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
 extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
-			pgoff_t pgoff, int nr_pages, int flags);
+			pgoff_t pgoff, int nr_pages, long watermark, int flags);
 extern void rb_free_aux(struct ring_buffer *rb, struct perf_event *event);
 extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
 extern void ring_buffer_put(struct ring_buffer *rb);
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 5006caba63..27d1dd7cfa 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -270,6 +270,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 	handle->size = 0;
 	if (!rb->aux_overwrite) {
 		aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
+		handle->wakeup = local_read(&rb->aux_wakeup) + rb->aux_watermark;
 		if (aux_head - aux_tail < perf_aux_size(rb))
 			handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
 
@@ -313,9 +314,12 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 	}
 
 	smp_wmb();
-	rb->user_page->aux_head = local_read(&rb->aux_head);
+	aux_head = rb->user_page->aux_head = local_read(&rb->aux_head);
 
-	perf_output_wakeup(handle);
+	if (aux_head - local_read(&rb->aux_wakeup) >= rb->aux_watermark) {
+		perf_output_wakeup(handle);
+		local_add(rb->aux_watermark, &rb->aux_wakeup);
+	}
 	handle->event = NULL;
 
 	local_set(&rb->aux_nest, 0);
@@ -376,7 +380,7 @@ static void rb_free_aux_page(struct ring_buffer *rb, int idx)
 }
 
 int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
-		 pgoff_t pgoff, int nr_pages, int flags)
+		 pgoff_t pgoff, int nr_pages, long watermark, int flags)
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
 	int node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
@@ -423,6 +427,10 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	if (rb->aux_priv)
 		ret = 0;
 	rb->aux_overwrite = overwrite;
+	rb->aux_watermark = watermark;
+
+	if (!rb->aux_watermark && !rb->aux_overwrite)
+		rb->aux_watermark = nr_pages << (PAGE_SHIFT - 1);
 
 out:
 	if (!ret)
-- 
2.1.0

