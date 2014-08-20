Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaHTMmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:42:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:43462 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaHTMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:42:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="587437642"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 07/22] perf: Add api for pmus to write to AUX space
Date: Wed, 20 Aug 2014 15:36:04 +0300
Message-Id: <1408538179-792-8-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pmus that wish to write data to AUX space, provide
perf_aux_output_{begin,end}() calls to initiate/commit data writes,
similarly to perf_output_{begin,end}. These also use the same output
handle structure.

After the perf_aux_output_begin() returns successfully, handle->size
is set to the maximum amount of data that can be written wrt aux_tail
pointer, so that no data that the user hasn't seen will be overwritten.

PMU driver should pass the actual amount of data written as a parameter
to perf_aux_output_end().

Nested writers are forbidden and guards are in place to catch such
attempts.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h  | 23 ++++++++++++-
 kernel/events/core.c        |  5 ++-
 kernel/events/internal.h    |  4 +++
 kernel/events/ring_buffer.c | 84 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6bd3e743b1..63016a0e32 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -554,12 +554,22 @@ struct perf_output_handle {
 	struct ring_buffer		*rb;
 	unsigned long			wakeup;
 	unsigned long			size;
-	void				*addr;
+	union {
+		void			*addr;
+		unsigned long		head;
+	};
 	int				page;
 };
 
 #ifdef CONFIG_PERF_EVENTS
 
+extern void *perf_aux_output_begin(struct perf_output_handle *handle,
+				   struct perf_event *event);
+extern void perf_aux_output_end(struct perf_output_handle *handle,
+				unsigned long size, bool truncated);
+extern int perf_aux_output_skip(struct perf_output_handle *handle,
+				unsigned long size);
+extern void *perf_get_aux(struct perf_output_handle *handle);
 extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
@@ -816,6 +826,17 @@ extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
 #else /* !CONFIG_PERF_EVENTS: */
+static inline void *
+perf_aux_output_begin(struct perf_output_handle *handle,
+		      struct perf_event *event)				{ return NULL; }
+static inline void
+perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
+		    bool truncated)					{ }
+static inline int
+perf_aux_output_skip(struct perf_output_handle *handle,
+		     unsigned long size)				{ return -EINVAL; }
+static inline void *
+perf_get_aux(struct perf_output_handle *handle)				{ return NULL; }
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
 			 struct task_struct *task)			{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e36478564c..9fc9a7583b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3267,7 +3267,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
 static void ring_buffer_attach(struct perf_event *event,
 			       struct ring_buffer *rb);
 
@@ -4047,7 +4046,7 @@ static void rb_free_rcu(struct rcu_head *rcu_head)
 	rb_free(rb);
 }
 
-static struct ring_buffer *ring_buffer_get(struct perf_event *event)
+struct ring_buffer *ring_buffer_get(struct perf_event *event)
 {
 	struct ring_buffer *rb;
 
@@ -4062,7 +4061,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct ring_buffer *rb)
 {
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index e5374030b1..b8f6c193ea 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -36,6 +36,8 @@ struct ring_buffer {
 	struct user_struct		*mmap_user;
 
 	/* AUX area */
+	local_t				aux_head;
+	local_t				aux_nest;
 	unsigned long			aux_pgoff;
 	int				aux_nr_pages;
 	atomic_t			aux_mmap_count;
@@ -54,6 +56,8 @@ extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, int flags);
 extern void rb_free_aux(struct ring_buffer *rb, struct perf_event *event);
+extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
+extern void ring_buffer_put(struct ring_buffer *rb);
 
 static inline bool rb_has_aux(struct ring_buffer *rb)
 {
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index f5ee3669f8..3b3a915767 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -242,6 +242,90 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 	spin_lock_init(&rb->event_lock);
 }
 
+void *perf_aux_output_begin(struct perf_output_handle *handle,
+			    struct perf_event *event)
+{
+	unsigned long aux_head, aux_tail;
+	struct ring_buffer *rb;
+
+	rb = ring_buffer_get(event);
+	if (!rb)
+		return NULL;
+
+	if (!rb_has_aux(rb))
+		goto err;
+
+	/*
+	 * Nesting is not supported for AUX area, make sure nested
+	 * writers are caught early
+	 */
+	if (WARN_ON_ONCE(local_xchg(&rb->aux_nest, 1)))
+		goto err;
+
+	aux_head = local_read(&rb->aux_head);
+	aux_tail = ACCESS_ONCE(rb->user_page->aux_tail);
+
+	handle->rb = rb;
+	handle->event = event;
+	handle->head = aux_head;
+	if (aux_head - aux_tail < perf_aux_size(rb))
+		handle->size = CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
+	else
+		handle->size = 0;
+
+	if (!handle->size) {
+		event->pending_disable = 1;
+		event->hw.state = PERF_HES_STOPPED;
+		perf_output_wakeup(handle);
+		local_set(&rb->aux_nest, 0);
+		goto err;
+	}
+
+	return handle->rb->aux_priv;
+
+err:
+	ring_buffer_put(rb);
+	handle->event = NULL;
+
+	return NULL;
+}
+
+void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
+			 bool truncated)
+{
+	struct ring_buffer *rb = handle->rb;
+
+	local_add(size, &rb->aux_head);
+
+	smp_wmb();
+	rb->user_page->aux_head = local_read(&rb->aux_head);
+
+	perf_output_wakeup(handle);
+	handle->event = NULL;
+
+	local_set(&rb->aux_nest, 0);
+	ring_buffer_put(rb);
+}
+
+int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
+{
+	struct ring_buffer *rb = handle->rb;
+
+	if (size > handle->size)
+		return -ENOSPC;
+
+	local_add(size, &rb->aux_head);
+	handle->head = local_read(&rb->aux_head);
+	handle->size -= size;
+
+	return 0;
+}
+
+void *perf_get_aux(struct perf_output_handle *handle)
+{
+	return handle->rb->aux_priv;
+}
+
 #define PERF_AUX_GFP	(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY)
 
 static struct page *rb_alloc_aux_page(int node, int order)
-- 
2.1.0

