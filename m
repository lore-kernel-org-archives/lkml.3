Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKKL2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:28:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:64854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaKKL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="634998819"
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
Subject: [PATCH v6 09/14] perf: Add wakeup watermark control to AUX area
Date: Tue, 11 Nov 2014 13:26:55 +0200
Message-Id: <1415705221-182873-10-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
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
 kernel/events/ring_buffer.c     | 22 +++++++++++++++++++---
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index f36aac2ac5..ffd52c0861 100644
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
index 48b8dc0d36..da2e44aedd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4419,7 +4419,8 @@ accounting:
 		perf_event_init_userpage(event);
 		perf_event_update_userpage(event);
 	} else {
-		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages, flags);
+		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
+				   event->attr.aux_watermark, flags);
 		if (!ret)
 			rb->aux_mmap_locked = extra;
 	}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b1ed80f87d..4715aae48b 100644
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
@@ -57,7 +59,7 @@ extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
 extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
-			pgoff_t pgoff, int nr_pages, int flags);
+			pgoff_t pgoff, int nr_pages, long watermark, int flags);
 extern void rb_free_aux(struct ring_buffer *rb);
 extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
 extern void ring_buffer_put(struct ring_buffer *rb);
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index b94fd5ad51..12a01d67a9 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -295,6 +295,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 	 */
 	if (!rb->aux_overwrite) {
 		aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
+		handle->wakeup = local_read(&rb->aux_wakeup) + rb->aux_watermark;
 		if (aux_head - aux_tail < perf_aux_size(rb))
 			handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
 
@@ -358,9 +359,12 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 		perf_event_aux_event(handle->event, aux_head, size, flags);
 	}
 
-	rb->user_page->aux_head = local_read(&rb->aux_head);
+	aux_head = rb->user_page->aux_head = local_read(&rb->aux_head);
 
-	perf_output_wakeup(handle);
+	if (aux_head - local_read(&rb->aux_wakeup) >= rb->aux_watermark) {
+		perf_output_wakeup(handle);
+		local_add(rb->aux_watermark, &rb->aux_wakeup);
+	}
 	handle->event = NULL;
 
 	local_set(&rb->aux_nest, 0);
@@ -382,6 +386,14 @@ int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
 
 	local_add(size, &rb->aux_head);
 
+	aux_head = rb->user_page->aux_head = local_read(&rb->aux_head);
+	if (aux_head - local_read(&rb->aux_wakeup) >= rb->aux_watermark) {
+		perf_output_wakeup(handle);
+		local_add(rb->aux_watermark, &rb->aux_wakeup);
+		handle->wakeup = local_read(&rb->aux_wakeup) +
+				 rb->aux_watermark;
+	}
+
 	handle->head = aux_head;
 	handle->size -= size;
 
@@ -432,7 +444,7 @@ static void rb_free_aux_page(struct ring_buffer *rb, int idx)
 }
 
 int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
-		 pgoff_t pgoff, int nr_pages, int flags)
+		 pgoff_t pgoff, int nr_pages, long watermark, int flags)
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
 	int node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
@@ -493,6 +505,10 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	kref_init(&rb->aux_refcount);
 
 	rb->aux_overwrite = overwrite;
+	rb->aux_watermark = watermark;
+
+	if (!rb->aux_watermark && !rb->aux_overwrite)
+		rb->aux_watermark = nr_pages << (PAGE_SHIFT - 1);
 
 out:
 	if (!ret)
-- 
2.1.1

