Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaKKOuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:50:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:5805 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaKKOuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:50:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414838825"
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
Subject: [PATCH v7 07/14] perf: Add api for pmus to write to AUX area
Date: Tue, 11 Nov 2014 16:48:21 +0200
Message-Id: <1415717308-209223-8-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415717308-209223-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pmus that wish to write data to ring buffer's AUX area, provide
perf_aux_output_{begin,end}() calls to initiate/commit data writes,
similarly to perf_output_{begin,end}. These also use the same output
handle structure. Also, similarly to software counterparts, these
will direct inherited events' output to parents' ring buffers.

After the perf_aux_output_begin() returns successfully, handle->size
is set to the maximum amount of data that can be written wrt aux_tail
pointer, so that no data that the user hasn't seen will be overwritten,
therefore this should always be called before hardware writing is
enabled. On success, this will return the pointer to pmu driver's
private structure allocated for this aux area by pmu::setup_aux. Same
pointer can also be retrieved using perf_get_aux() while hardware
writing is enabled.

PMU driver should pass the actual amount of data written as a parameter
to perf_aux_output_end(). All hardware writes should be completed and
visible before this one is called.

Additionally, perf_aux_output_skip() will adjust output handle and
aux_head in case some part of the buffer has to be skipped over to
maintain hardware's alignment constraints.

Nested writers are forbidden and guards are in place to catch such
attempts.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h  |  23 +++++++-
 kernel/events/core.c        |   5 +-
 kernel/events/internal.h    |   4 ++
 kernel/events/ring_buffer.c | 139 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 167 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5c3dee021c..f126eb89e6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -555,12 +555,22 @@ struct perf_output_handle {
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
 
@@ -817,6 +827,17 @@ extern void perf_event_disable(struct perf_event *event);
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
index 779f60d300..48b8dc0d36 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3293,7 +3293,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
 static void ring_buffer_attach(struct perf_event *event,
 			       struct ring_buffer *rb);
 
@@ -4110,7 +4109,7 @@ static void rb_free_rcu(struct rcu_head *rcu_head)
 	rb_free(rb);
 }
 
-static struct ring_buffer *ring_buffer_get(struct perf_event *event)
+struct ring_buffer *ring_buffer_get(struct perf_event *event)
 {
 	struct ring_buffer *rb;
 
@@ -4125,7 +4124,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct ring_buffer *rb)
 {
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 4d117a9814..b701ebc325 100644
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
@@ -56,6 +58,8 @@ extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, int flags);
 extern void rb_free_aux(struct ring_buffer *rb);
+extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
+extern void ring_buffer_put(struct ring_buffer *rb);
 
 static inline bool rb_has_aux(struct ring_buffer *rb)
 {
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 1b4b593a32..e452776b62 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -242,6 +242,145 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 	spin_lock_init(&rb->event_lock);
 }
 
+/*
+ * This is called before hardware starts writing to the AUX area to
+ * obtain an output handle and make sure there's room in the buffer.
+ * When the capture completes, call perf_aux_output_end() to commit
+ * the recorded data to the buffer.
+ *
+ * The ordering is similar to that of perf_output_{begin,end}, with
+ * the exception of (B), which should be taken care of by the pmu
+ * driver, since ordering rules will differ depending on hardware.
+ */
+void *perf_aux_output_begin(struct perf_output_handle *handle,
+			    struct perf_event *event)
+{
+	struct perf_event *output_event = event;
+	unsigned long aux_head, aux_tail;
+	struct ring_buffer *rb;
+
+	if (output_event->parent)
+		output_event = output_event->parent;
+
+	/*
+	 * Since this will typically be open across pmu::add/pmu::del, we
+	 * grab ring_buffer's refcount instead of holding rcu read lock
+	 * to make sure it doesn't disappear under us.
+	 */
+	rb = ring_buffer_get(output_event);
+	if (!rb)
+		return NULL;
+
+	if (!rb_has_aux(rb) || !atomic_inc_not_zero(&rb->aux_refcount))
+		goto err;
+
+	/*
+	 * Nesting is not supported for AUX area, make sure nested
+	 * writers are caught early
+	 */
+	if (WARN_ON_ONCE(local_xchg(&rb->aux_nest, 1)))
+		goto err_put;
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
+	/*
+	 * handle->size computation depends on aux_tail load; this forms a
+	 * control dependency barrier separating aux_tail load from aux data
+	 * store that will be enabled on successful return
+	 */
+	if (!handle->size) { /* A, matches D */
+		event->pending_disable = 1;
+		perf_output_wakeup(handle);
+		local_set(&rb->aux_nest, 0);
+		goto err_put;
+	}
+
+	return handle->rb->aux_priv;
+
+err_put:
+	rb_free_aux(rb);
+
+err:
+	ring_buffer_put(rb);
+	handle->event = NULL;
+
+	return NULL;
+}
+
+/*
+ * Commit the data written by hardware into the ring buffer by adjusting
+ * aux_head and posting a PERF_RECORD_AUX into the perf buffer. It is the
+ * pmu driver's responsibility to observe ordering rules of the hardware,
+ * so that all the data is externally visible before this is called.
+ */
+void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
+			 bool truncated)
+{
+	struct ring_buffer *rb = handle->rb;
+	unsigned long aux_head = local_read(&rb->aux_head);
+	u64 flags = 0;
+
+	if (truncated)
+		flags |= PERF_AUX_FLAG_TRUNCATED;
+
+	local_add(size, &rb->aux_head);
+
+	if (size || flags) {
+		/*
+		 * Only send RECORD_AUX if we have something useful to communicate
+		 */
+
+		perf_event_aux_event(handle->event, aux_head, size, flags);
+	}
+
+	rb->user_page->aux_head = local_read(&rb->aux_head);
+
+	perf_output_wakeup(handle);
+	handle->event = NULL;
+
+	local_set(&rb->aux_nest, 0);
+	rb_free_aux(rb);
+	ring_buffer_put(rb);
+}
+
+/*
+ * Skip over a given number of bytes in the AUX buffer, due to, for example,
+ * hardware's alignment constraints.
+ */
+int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
+{
+	struct ring_buffer *rb = handle->rb;
+	unsigned long aux_head;
+
+	if (size > handle->size)
+		return -ENOSPC;
+
+	local_add(size, &rb->aux_head);
+
+	handle->head = aux_head;
+	handle->size -= size;
+
+	return 0;
+}
+
+void *perf_get_aux(struct perf_output_handle *handle)
+{
+	/* this is only valid between perf_aux_output_begin and *_end */
+	if (!handle->event)
+		return NULL;
+
+	return handle->rb->aux_priv;
+}
+
 #define PERF_AUX_GFP	(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY)
 
 static struct page *rb_alloc_aux_page(int node, int order)
-- 
2.1.1

