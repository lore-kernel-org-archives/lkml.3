Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaBFKvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:34349 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730AbaBFKvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="476902071"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Date: Thu,  6 Feb 2014 12:50:26 +0200
Message-Id: <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a perf event can have one ring buffer associated with it, that
is used for perf record stream. However, some pmus, such as instruction
tracing units, will generate binary streams of their own, for which it is
convenient to reuse the ring buffer code to export such streams to the
userspace. So, this patch extends the perf code to support more than one
ring buffer per event. All the existing functionality will default to
using the main ring buffer for everything and only the main buffer is
exported to userspace at this point.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h  |  11 ++-
 kernel/events/core.c        | 186 ++++++++++++++++++++++++--------------------
 kernel/events/internal.h    |   7 ++
 kernel/events/ring_buffer.c |   2 +-
 4 files changed, 118 insertions(+), 88 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..93cefb6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -289,6 +289,11 @@ struct swevent_hlist {
 struct perf_cgroup;
 struct ring_buffer;
 
+enum perf_event_rb {
+	PERF_RB_MAIN = 0,
+	PERF_NR_RB,
+};
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -398,10 +403,10 @@ struct perf_event {
 
 	/* mmap bits */
 	struct mutex			mmap_mutex;
-	atomic_t			mmap_count;
+	atomic_t			mmap_count[PERF_NR_RB];
 
-	struct ring_buffer		*rb;
-	struct list_head		rb_entry;
+	struct ring_buffer		*rb[PERF_NR_RB];
+	struct list_head		rb_entry[PERF_NR_RB];
 
 	/* poll related */
 	wait_queue_head_t		waitq;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6899741..533230c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3175,9 +3175,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
-
 static void unaccount_event_cpu(struct perf_event *event, int cpu)
 {
 	if (event->parent)
@@ -3231,28 +3228,31 @@ static void __free_event(struct perf_event *event)
 }
 static void free_event(struct perf_event *event)
 {
+	int rbx;
+
 	irq_work_sync(&event->pending);
 
 	unaccount_event(event);
 
-	if (event->rb) {
-		struct ring_buffer *rb;
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++)
+		if (event->rb[rbx]) {
+			struct ring_buffer *rb;
 
-		/*
-		 * Can happen when we close an event with re-directed output.
-		 *
-		 * Since we have a 0 refcount, perf_mmap_close() will skip
-		 * over us; possibly making our ring_buffer_put() the last.
-		 */
-		mutex_lock(&event->mmap_mutex);
-		rb = event->rb;
-		if (rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* could be last */
+			/*
+			 * Can happen when we close an event with re-directed output.
+			 *
+			 * Since we have a 0 refcount, perf_mmap_close() will skip
+			 * over us; possibly making our ring_buffer_put() the last.
+			 */
+			mutex_lock(&event->mmap_mutex);
+			rb = event->rb[rbx];
+			if (rb) {
+				rcu_assign_pointer(event->rb[rbx], NULL);
+				ring_buffer_detach(event, rb);
+				ring_buffer_put(rb); /* could be last */
+			}
+			mutex_unlock(&event->mmap_mutex);
 		}
-		mutex_unlock(&event->mmap_mutex);
-	}
 
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
@@ -3481,21 +3481,24 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
 	struct ring_buffer *rb;
-	unsigned int events = POLL_HUP;
+	unsigned int events = 0;
+	int rbx;
 
 	/*
 	 * Pin the event->rb by taking event->mmap_mutex; otherwise
 	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
 	 */
 	mutex_lock(&event->mmap_mutex);
-	rb = event->rb;
-	if (rb)
-		events = atomic_xchg(&rb->poll, 0);
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++) {
+		rb = event->rb[rbx];
+		if (rb)
+			events |= atomic_xchg(&rb->poll, 0);
+	}
 	mutex_unlock(&event->mmap_mutex);
 
 	poll_wait(file, &event->waitq, wait);
 
-	return events;
+	return events ? events : POLL_HUP;
 }
 
 static void perf_event_reset(struct perf_event *event)
@@ -3726,7 +3729,7 @@ static void perf_event_init_userpage(struct perf_event *event)
 	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (!rb)
 		goto unlock;
 
@@ -3756,7 +3759,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	u64 enabled, running, now;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (!rb)
 		goto unlock;
 
@@ -3812,7 +3815,7 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (!rb)
 		goto unlock;
 
@@ -3834,29 +3837,31 @@ unlock:
 	return ret;
 }
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb)
+void ring_buffer_attach(struct perf_event *event,
+			struct ring_buffer *rb)
 {
+	struct list_head *head = &event->rb_entry[PERF_RB_MAIN];
 	unsigned long flags;
 
-	if (!list_empty(&event->rb_entry))
+	if (!list_empty(head))
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	if (list_empty(&event->rb_entry))
-		list_add(&event->rb_entry, &rb->event_list);
+	if (list_empty(head))
+		list_add(head, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
+void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
+	struct list_head *head = &event->rb_entry[PERF_RB_MAIN];
 	unsigned long flags;
 
-	if (list_empty(&event->rb_entry))
+	if (list_empty(head))
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	list_del_init(&event->rb_entry);
+	list_del_init(head);
 	wake_up_all(&event->waitq);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
@@ -3864,12 +3869,16 @@ static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct ring_buffer *rb;
+	struct perf_event *iter;
+	int rbx;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
-	if (rb) {
-		list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
-			wake_up_all(&event->waitq);
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++) {
+		rb = rcu_dereference(event->rb[rbx]);
+		if (rb) {
+			list_for_each_entry_rcu(iter, &rb->event_list, rb_entry[rbx])
+				wake_up_all(&iter->waitq);
+		}
 	}
 	rcu_read_unlock();
 }
@@ -3882,12 +3891,12 @@ static void rb_free_rcu(struct rcu_head *rcu_head)
 	rb_free(rb);
 }
 
-static struct ring_buffer *ring_buffer_get(struct perf_event *event)
+struct ring_buffer *ring_buffer_get(struct perf_event *event, int rbx)
 {
 	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[rbx]);
 	if (rb) {
 		if (!atomic_inc_not_zero(&rb->refcount))
 			rb = NULL;
@@ -3897,7 +3906,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct ring_buffer *rb)
 {
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
@@ -3911,8 +3920,8 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	atomic_inc(&event->mmap_count);
-	atomic_inc(&event->rb->mmap_count);
+	atomic_inc(&event->mmap_count[PERF_RB_MAIN]);
+	atomic_inc(&event->rb[PERF_RB_MAIN]->mmap_count);
 }
 
 /*
@@ -3926,19 +3935,20 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-
-	struct ring_buffer *rb = event->rb;
+	int rbx = PERF_RB_MAIN;
+	struct ring_buffer *rb = event->rb[rbx];
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
 
 	atomic_dec(&rb->mmap_count);
 
-	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
+	if (!atomic_dec_and_mutex_lock(&event->mmap_count[rbx],
+				       &event->mmap_mutex))
 		return;
 
 	/* Detach current event from the buffer. */
-	rcu_assign_pointer(event->rb, NULL);
+	rcu_assign_pointer(event->rb[rbx], NULL);
 	ring_buffer_detach(event, rb);
 	mutex_unlock(&event->mmap_mutex);
 
@@ -3955,7 +3965,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	 */
 again:
 	rcu_read_lock();
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry[rbx]) {
 		if (!atomic_long_inc_not_zero(&event->refcount)) {
 			/*
 			 * This event is en-route to free_event() which will
@@ -3976,8 +3986,8 @@ again:
 		 * still restart the iteration to make sure we're not now
 		 * iterating the wrong list.
 		 */
-		if (event->rb == rb) {
-			rcu_assign_pointer(event->rb, NULL);
+		if (event->rb[rbx] == rb) {
+			rcu_assign_pointer(event->rb[rbx], NULL);
 			ring_buffer_detach(event, rb);
 			ring_buffer_put(rb); /* can't be last, we still have one */
 		}
@@ -4026,6 +4036,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long nr_pages;
 	long user_extra, extra;
 	int ret = 0, flags = 0;
+	int rbx = PERF_RB_MAIN;
 
 	/*
 	 * Don't allow mmap() of inherited per-task counters. This would
@@ -4039,6 +4050,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
+
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
@@ -4057,13 +4069,14 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 again:
 	mutex_lock(&event->mmap_mutex);
-	if (event->rb) {
-		if (event->rb->nr_pages != nr_pages) {
+	rb = event->rb[rbx];
+	if (rb) {
+		if (rb->nr_pages != nr_pages) {
 			ret = -EINVAL;
 			goto unlock;
 		}
 
-		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+		if (!atomic_inc_not_zero(&rb->mmap_count)) {
 			/*
 			 * Raced against perf_mmap_close() through
 			 * perf_event_set_output(). Try again, hope for better
@@ -4100,7 +4113,7 @@ again:
 		goto unlock;
 	}
 
-	WARN_ON(event->rb);
+	WARN_ON(event->rb[rbx]);
 
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
@@ -4122,14 +4135,14 @@ again:
 	vma->vm_mm->pinned_vm += extra;
 
 	ring_buffer_attach(event, rb);
-	rcu_assign_pointer(event->rb, rb);
+	rcu_assign_pointer(event->rb[rbx], rb);
 
 	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
 
 unlock:
 	if (!ret)
-		atomic_inc(&event->mmap_count);
+		atomic_inc(&event->mmap_count[rbx]);
 	mutex_unlock(&event->mmap_mutex);
 
 	/*
@@ -6661,6 +6674,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err = -EINVAL;
+	int rbx;
 
 	if ((unsigned)cpu >= nr_cpu_ids) {
 		if (!task || cpu != -1)
@@ -6684,7 +6698,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
-	INIT_LIST_HEAD(&event->rb_entry);
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++)
+		INIT_LIST_HEAD(&event->rb_entry[rbx]);
 	INIT_LIST_HEAD(&event->active_entry);
 	INIT_HLIST_NODE(&event->hlist_entry);
 
@@ -6912,8 +6927,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct ring_buffer *rb = NULL, *old_rb = NULL;
-	int ret = -EINVAL;
+	int ret = -EINVAL, rbx;
 
 	if (!output_event)
 		goto set;
@@ -6936,39 +6950,43 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 
 set:
 	mutex_lock(&event->mmap_mutex);
-	/* Can't redirect output if we've got an active mmap() */
-	if (atomic_read(&event->mmap_count))
-		goto unlock;
 
-	old_rb = event->rb;
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++) {
+		struct ring_buffer *rb = NULL, *old_rb = NULL;
 
-	if (output_event) {
-		/* get the rb we want to redirect to */
-		rb = ring_buffer_get(output_event);
-		if (!rb)
-			goto unlock;
-	}
+		/* Can't redirect output if we've got an active mmap() */
+		if (atomic_read(&event->mmap_count[rbx]))
+			continue;
 
-	if (old_rb)
-		ring_buffer_detach(event, old_rb);
+		old_rb = event->rb[rbx];
 
-	if (rb)
-		ring_buffer_attach(event, rb);
+		if (output_event) {
+			/* get the rb we want to redirect to */
+			rb = ring_buffer_get(output_event, rbx);
+			if (!rb)
+				continue;
+		}
 
-	rcu_assign_pointer(event->rb, rb);
+		if (old_rb)
+			ring_buffer_detach(event, old_rb);
 
-	if (old_rb) {
-		ring_buffer_put(old_rb);
-		/*
-		 * Since we detached before setting the new rb, so that we
-		 * could attach the new rb, we could have missed a wakeup.
-		 * Provide it now.
-		 */
-		wake_up_all(&event->waitq);
+		if (rb)
+			ring_buffer_attach(event, rb);
+
+		rcu_assign_pointer(event->rb[rbx], rb);
+
+		if (old_rb) {
+			ring_buffer_put(old_rb);
+			/*
+			 * Since we detached before setting the new rb, so that we
+			 * could attach the new rb, we could have missed a wakeup.
+			 * Provide it now.
+			 */
+			wake_up_all(&event->waitq);
+		}
 	}
 
 	ret = 0;
-unlock:
 	mutex_unlock(&event->mmap_mutex);
 
 out:
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 6cb208f..841f7c4 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -63,6 +63,7 @@ struct ring_buffer {
 	atomic_t			mmap_count;
 	unsigned long			mmap_locked;
 	struct user_struct		*mmap_user;
+	void				*priv;
 
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
@@ -73,6 +74,12 @@ extern struct ring_buffer *
 rb_alloc(struct perf_event *event, int nr_pages, long watermark, int cpu,
 	 int flags, struct ring_buffer_ops *rb_ops);
 extern void perf_event_wakeup(struct perf_event *event);
+extern struct ring_buffer *ring_buffer_get(struct perf_event *event, int rbx);
+extern void ring_buffer_put(struct ring_buffer *rb);
+extern void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
+extern void ring_buffer_detach(struct perf_event *event,
+			       struct ring_buffer *rb);
 
 extern void
 perf_event_header__init_id(struct perf_event_header *header,
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 161a676..232d7de 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -120,7 +120,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (event->parent)
 		event = event->parent;
 
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (unlikely(!rb))
 		goto out;
 
-- 
1.8.5.2

