Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3HVORk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:17:40 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48609 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3HVOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:41 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 03/12] perf, mmap: Factor out perf_alloc/free_rb()
Date: Thu, 22 Aug 2013 16:13:18 +0200
Message-Id: <1377180807-12758-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Factor out code to allocate and deallocate ringbuffers. We need this
later to setup the sampling buffer for persistent events.

While at this, replacing get_current_user() with get_uid(user).

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/core.c     | 75 +++++++++++++++++++++++++++++-------------------
 kernel/events/internal.h |  3 ++
 2 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c9a5d4c..24810d5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3124,8 +3124,44 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
+static void ring_buffer_attach(struct perf_event *event, struct ring_buffer *rb);
 static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
+/*
+ * Must be called with &event->mmap_mutex held. event->rb must be
+ * NULL. perf_alloc_rb() requires &event->mmap_count to be incremented
+ * on success which corresponds to &rb->mmap_count that is initialized
+ * with 1.
+ */
+int perf_alloc_rb(struct perf_event *event, int nr_pages, int flags)
+{
+	struct ring_buffer *rb;
+
+	rb = rb_alloc(nr_pages,
+		event->attr.watermark ? event->attr.wakeup_watermark : 0,
+		event->cpu, flags);
+	if (!rb)
+		return -ENOMEM;
+
+	atomic_set(&rb->mmap_count, 1);
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb, rb);
+
+	perf_event_update_userpage(event);
+
+	return 0;
+}
+
+/* Must be called with &event->mmap_mutex held. event->rb must be set. */
+void perf_free_rb(struct perf_event *event)
+{
+	struct ring_buffer *rb = event->rb;
+
+	rcu_assign_pointer(event->rb, NULL);
+	ring_buffer_detach(event, rb);
+	ring_buffer_put(rb);
+}
+
 static void unaccount_event_cpu(struct perf_event *event, int cpu)
 {
 	if (event->parent)
@@ -3177,6 +3213,7 @@ static void __free_event(struct perf_event *event)
 
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
+
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -3184,8 +3221,6 @@ static void free_event(struct perf_event *event)
 	unaccount_event(event);
 
 	if (event->rb) {
-		struct ring_buffer *rb;
-
 		/*
 		 * Can happen when we close an event with re-directed output.
 		 *
@@ -3193,12 +3228,8 @@ static void free_event(struct perf_event *event)
 		 * over us; possibly making our ring_buffer_put() the last.
 		 */
 		mutex_lock(&event->mmap_mutex);
-		rb = event->rb;
-		if (rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* could be last */
-		}
+		if (event->rb)
+			perf_free_rb(event);
 		mutex_unlock(&event->mmap_mutex);
 	}
 
@@ -3798,11 +3829,8 @@ static void ring_buffer_detach_all(struct ring_buffer *rb)
 		 * still restart the iteration to make sure we're not now
 		 * iterating the wrong list.
 		 */
-		if (event->rb == rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* can't be last, we still have one */
-		}
+		if (event->rb == rb)
+			perf_free_rb(event);
 		mutex_unlock(&event->mmap_mutex);
 		put_event(event);
 
@@ -3938,7 +3966,6 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
-	struct ring_buffer *rb;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
@@ -4022,27 +4049,15 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
 
-	rb = rb_alloc(nr_pages, 
-		event->attr.watermark ? event->attr.wakeup_watermark : 0,
-		event->cpu, flags);
-
-	if (!rb) {
-		ret = -ENOMEM;
+	ret = perf_alloc_rb(event, nr_pages, flags);
+	if (ret)
 		goto unlock;
-	}
 
-	atomic_set(&rb->mmap_count, 1);
-	rb->mmap_locked = extra;
-	rb->mmap_user = get_current_user();
+	event->rb->mmap_locked = extra;
+	event->rb->mmap_user = get_uid(user);
 
 	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->pinned_vm += extra;
-
-	ring_buffer_attach(event, rb);
-	rcu_assign_pointer(event->rb, rb);
-
-	perf_event_update_userpage(event);
-
 unlock:
 	if (!ret)
 		atomic_inc(&event->mmap_count);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 96a07d2..8ddaf57 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -190,4 +190,7 @@ static inline void put_event(struct perf_event *event)
 	__put_event(event);
 }
 
+extern int perf_alloc_rb(struct perf_event *event, int nr_pages, int flags);
+extern void perf_free_rb(struct perf_event *event);
+
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
-- 
1.8.3.2

