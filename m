Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaHKFbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:31:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:13915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbaHKFbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:31:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="574811920"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 10/23] perf: Add wakeup watermark control to AUX area
Date: Mon, 11 Aug 2014 08:19:39 +0300
Message-Id: <1407734392-31097-11-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When AUX area gets a certain amount of new data, we want to wake up
userspace to collect it. This adds a new control to specify how much
data will cause a wakeup.

We repurpose __reserved_2 in the event attribute for this, even though
it was never checked to be zero before, aux_watermark will only matter
for new AUX-aware code, so the old code should still be fine.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h |  7 +++++--
 kernel/events/core.c            |  3 ++-
 kernel/events/internal.h        |  4 +++-
 kernel/events/ring_buffer.c     | 17 ++++++++++++++---
 4 files changed, 24 insertions(+), 7 deletions(-)

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
index 25aad70812..2de7d40cb6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4257,7 +4257,8 @@ accounting:
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
index 4ee7723d87..85858d201c 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -269,8 +269,12 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 	handle->head = aux_head;
 	if (!rb->aux_overwrite) {
 		aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
+		handle->wakeup = local_read(&rb->aux_wakeup);
 		handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
 
+		if (rb->aux_watermark && handle->size > rb->aux_watermark)
+			handle->size = rb->aux_watermark;
+
 		if (!handle->size) {
 			event->pending_disable = 1;
 			event->hw.state = PERF_HES_STOPPED;
@@ -313,9 +317,12 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 	}
 
 	smp_wmb();
-	rb->user_page->aux_head = local_read(&rb->aux_head);
+	aux_head = rb->user_page->aux_head = local_read(&rb->aux_head);
 
-	perf_output_wakeup(handle);
+	if (aux_head - local_read(&rb->aux_wakeup) > rb->aux_watermark) {
+		perf_output_wakeup(handle);
+		local_add(rb->aux_watermark, &rb->aux_wakeup);
+	}
 	handle->event = NULL;
 
 	local_set(&rb->aux_nest, 0);
@@ -376,7 +383,7 @@ static void rb_free_aux_page(struct ring_buffer *rb, int idx)
 }
 
 int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
-		 pgoff_t pgoff, int nr_pages, int flags)
+		 pgoff_t pgoff, int nr_pages, long watermark, int flags)
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
 	int node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
@@ -423,6 +430,10 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
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
2.1.0.rc1

