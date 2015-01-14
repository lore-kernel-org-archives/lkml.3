Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbbANMW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:22:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:27793 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbbANMW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:22:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="440423683"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v9 02/14] perf: Add AUX area to ring buffer for raw data streams
Date: Wed, 14 Jan 2015 14:18:11 +0200
Message-Id: <1421237903-181015-3-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

This patch introduces "AUX space" in the perf mmap buffer, intended for
exporting high bandwidth data streams to userspace, such as instruction
flow traces.

AUX space is a ring buffer, defined by aux_{offset,size} fields in the
user_page structure, and read/write pointers aux_{head,tail}, which abide
by the same rules as data_* counterparts of the main perf buffer.

In order to allocate/mmap AUX, userspace needs to set up aux_offset to
such an offset that will be greater than data_offset+data_size and
aux_size to be the desired buffer size. Both need to be page aligned.
Then, same aux_offset and aux_size should be passed to mmap() call and
if everything adds up, you should have an AUX buffer as a result.

Pages that are mapped into this buffer also come out of user's mlock
rlimit plus perf_event_mlock_kb allowance.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h      |  17 +++++
 include/uapi/linux/perf_event.h |  16 +++++
 kernel/events/core.c            | 140 +++++++++++++++++++++++++++++++++-------
 kernel/events/internal.h        |  23 +++++++
 kernel/events/ring_buffer.c     |  97 ++++++++++++++++++++++++++--
 5 files changed, 264 insertions(+), 29 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 486e84ccb1..e8bcb7c6ef 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -263,6 +263,18 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * Set up pmu-private data structures for an AUX area
+	 */
+	void *(*setup_aux)		(int cpu, void **pages,
+					 int nr_pages, bool overwrite);
+					/* optional */
+
+	/*
+	 * Free pmu-private AUX data structures
+	 */
+	void (*free_aux)		(void *aux); /* optional */
 };
 
 /**
@@ -785,6 +797,11 @@ static inline bool has_branch_stack(struct perf_event *event)
 	return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
 }
 
+static inline bool has_aux(struct perf_event *event)
+{
+	return event->pmu->setup_aux;
+}
+
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 58839d97ee..b7ccdf5e93 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -508,6 +508,22 @@ struct perf_event_mmap_page {
 	__u64	data_tail;		/* user-space written tail */
 	__u64	data_offset;		/* where the buffer starts */
 	__u64	data_size;		/* data buffer size */
+
+	/*
+	 * AUX area is defined by aux_{offset,size} fields that should be set
+	 * by the userspace, so that
+	 *
+	 *   aux_offset >= data_offset + data_size
+	 *
+	 * prior to mmap()ing it. Size of the mmap()ed area should be aux_size.
+	 *
+	 * Ring buffer pointers aux_{head,tail} have the same semantics as
+	 * data_{head,tail} and same ordering rules apply.
+	 */
+	__u64	aux_head;
+	__u64	aux_tail;
+	__u64	aux_offset;
+	__u64	aux_size;
 };
 
 #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 97ebe31b7c..08e3fcfde6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4143,6 +4143,8 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 
 	atomic_inc(&event->mmap_count);
 	atomic_inc(&event->rb->mmap_count);
+	if (vma->vm_pgoff)
+		atomic_inc(&event->rb->aux_mmap_count);
 }
 
 /*
@@ -4162,6 +4164,20 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
 
+	/*
+	 * rb->aux_mmap_count will always drop before rb->mmap_count and
+	 * event->mmap_count, so it is ok to use event->mmap_mutex to
+	 * serialize with perf_mmap here.
+	 */
+	if (rb_has_aux(rb) && vma->vm_pgoff == rb->aux_pgoff &&
+	    atomic_dec_and_mutex_lock(&rb->aux_mmap_count, &event->mmap_mutex)) {
+		atomic_long_sub(rb->aux_nr_pages, &mmap_user->locked_vm);
+		vma->vm_mm->pinned_vm -= rb->aux_mmap_locked;
+
+		rb_free_aux(rb);
+		mutex_unlock(&event->mmap_mutex);
+	}
+
 	atomic_dec(&rb->mmap_count);
 
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
@@ -4235,7 +4251,7 @@ out_put:
 
 static const struct vm_operations_struct perf_mmap_vmops = {
 	.open		= perf_mmap_open,
-	.close		= perf_mmap_close,
+	.close		= perf_mmap_close, /* non mergable */
 	.fault		= perf_mmap_fault,
 	.page_mkwrite	= perf_mmap_fault,
 };
@@ -4246,10 +4262,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
-	struct ring_buffer *rb;
+	struct ring_buffer *rb = NULL;
 	unsigned long vma_size;
 	unsigned long nr_pages;
-	long user_extra, extra;
+	long user_extra = 0, extra = 0;
 	int ret = 0, flags = 0;
 
 	/*
@@ -4264,7 +4280,66 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
-	nr_pages = (vma_size / PAGE_SIZE) - 1;
+
+	if (vma->vm_pgoff == 0) {
+		nr_pages = (vma_size / PAGE_SIZE) - 1;
+	} else {
+		/*
+		 * AUX area mapping: if rb->aux_nr_pages != 0, it's already
+		 * mapped, all subsequent mappings should have the same size
+		 * and offset. Must be above the normal perf buffer.
+		 */
+		u64 aux_offset, aux_size;
+
+		if (!event->rb)
+			return -EINVAL;
+
+		nr_pages = vma_size / PAGE_SIZE;
+
+		mutex_lock(&event->mmap_mutex);
+		ret = -EINVAL;
+
+		rb = event->rb;
+		if (!rb)
+			goto aux_unlock;
+
+		aux_offset = ACCESS_ONCE(rb->user_page->aux_offset);
+		aux_size = ACCESS_ONCE(rb->user_page->aux_size);
+
+		if (aux_offset < perf_data_size(rb) + PAGE_SIZE)
+			goto aux_unlock;
+
+		if (aux_offset != vma->vm_pgoff << PAGE_SHIFT)
+			goto aux_unlock;
+
+		/* already mapped with a different offset */
+		if (rb_has_aux(rb) && rb->aux_pgoff != vma->vm_pgoff)
+			goto aux_unlock;
+
+		if (aux_size != vma_size || aux_size != nr_pages * PAGE_SIZE)
+			goto aux_unlock;
+
+		/* already mapped with a different size */
+		if (rb_has_aux(rb) && rb->aux_nr_pages != nr_pages)
+			goto aux_unlock;
+
+		if (!is_power_of_2(nr_pages))
+			goto aux_unlock;
+
+		if (!atomic_inc_not_zero(&rb->mmap_count))
+			goto aux_unlock;
+
+		if (rb_has_aux(rb)) {
+			atomic_inc(&rb->aux_mmap_count);
+			ret = 0;
+			goto unlock;
+		}
+
+		atomic_set(&rb->aux_mmap_count, 1);
+		user_extra = nr_pages;
+
+		goto accounting;
+	}
 
 	/*
 	 * If we have rb pages ensure they're a power-of-two number, so we
@@ -4276,9 +4351,6 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))
 		return -EINVAL;
 
-	if (vma->vm_pgoff != 0)
-		return -EINVAL;
-
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 again:
 	mutex_lock(&event->mmap_mutex);
@@ -4302,6 +4374,8 @@ again:
 	}
 
 	user_extra = nr_pages + 1;
+
+accounting:
 	user_lock_limit = sysctl_perf_event_mlock >> (PAGE_SHIFT - 10);
 
 	/*
@@ -4311,7 +4385,6 @@ again:
 
 	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
 
-	extra = 0;
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;
 
@@ -4325,35 +4398,45 @@ again:
 		goto unlock;
 	}
 
-	WARN_ON(event->rb);
+	WARN_ON(!rb && event->rb);
 
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
 
-	rb = rb_alloc(nr_pages, 
-		event->attr.watermark ? event->attr.wakeup_watermark : 0,
-		event->cpu, flags);
-
 	if (!rb) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+		rb = rb_alloc(nr_pages,
+			      event->attr.watermark ? event->attr.wakeup_watermark : 0,
+			      event->cpu, flags);
 
-	atomic_set(&rb->mmap_count, 1);
-	rb->mmap_locked = extra;
-	rb->mmap_user = get_current_user();
+		if (!rb) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 
-	atomic_long_add(user_extra, &user->locked_vm);
-	vma->vm_mm->pinned_vm += extra;
+		atomic_set(&rb->mmap_count, 1);
+		rb->mmap_user = get_current_user();
+		rb->mmap_locked = extra;
 
-	ring_buffer_attach(event, rb);
+		ring_buffer_attach(event, rb);
 
-	perf_event_init_userpage(event);
-	perf_event_update_userpage(event);
+		perf_event_init_userpage(event);
+		perf_event_update_userpage(event);
+	} else {
+		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages, flags);
+		if (!ret)
+			rb->aux_mmap_locked = extra;
+	}
 
 unlock:
-	if (!ret)
+	if (!ret) {
+		atomic_long_add(user_extra, &user->locked_vm);
+		vma->vm_mm->pinned_vm += extra;
+
 		atomic_inc(&event->mmap_count);
+	} else if (rb) {
+		atomic_dec(&rb->mmap_count);
+	}
+aux_unlock:
 	mutex_unlock(&event->mmap_mutex);
 
 	/*
@@ -7229,6 +7312,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
 
+	/*
+	 * If both events generate aux data, they must be on the same PMU
+	 */
+	if (has_aux(event) && has_aux(output_event) &&
+	    event->pmu != output_event->pmu)
+		goto out;
+
 set:
 	mutex_lock(&event->mmap_mutex);
 	/* Can't redirect output if we've got an active mmap() */
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b218782..0f6d080159 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -35,6 +35,16 @@ struct ring_buffer {
 	unsigned long			mmap_locked;
 	struct user_struct		*mmap_user;
 
+	/* AUX area */
+	unsigned long			aux_pgoff;
+	int				aux_nr_pages;
+	atomic_t			aux_mmap_count;
+	unsigned long			aux_mmap_locked;
+	void				(*free_aux)(void *);
+	atomic_t			aux_refcount;
+	void				**aux_pages;
+	void				*aux_priv;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
@@ -43,6 +53,14 @@ extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
 extern void perf_event_wakeup(struct perf_event *event);
+extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
+			pgoff_t pgoff, int nr_pages, int flags);
+extern void rb_free_aux(struct ring_buffer *rb);
+
+static inline bool rb_has_aux(struct ring_buffer *rb)
+{
+	return !!rb->aux_nr_pages;
+}
 
 extern void
 perf_event_header__init_id(struct perf_event_header *header,
@@ -81,6 +99,11 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
 
+static inline unsigned long perf_aux_size(struct ring_buffer *rb)
+{
+	return rb->aux_nr_pages << PAGE_SHIFT;
+}
+
 #define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
 static inline unsigned long						\
 func_name(struct perf_output_handle *handle,				\
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a5792b1..c6fdce4ea0 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -242,14 +242,87 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 	spin_lock_init(&rb->event_lock);
 }
 
+int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
+		 pgoff_t pgoff, int nr_pages, int flags)
+{
+	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
+	int node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
+	int ret = -ENOMEM;
+
+	if (!has_aux(event))
+		return -ENOTSUPP;
+
+	rb->aux_pages = kzalloc_node(nr_pages * sizeof(void *), GFP_KERNEL, node);
+	if (!rb->aux_pages)
+		return -ENOMEM;
+
+	rb->free_aux = event->pmu->free_aux;
+	for (rb->aux_nr_pages = 0; rb->aux_nr_pages < nr_pages;
+	     rb->aux_nr_pages++) {
+		struct page *page;
+
+		page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		if (!page)
+			goto out;
+
+		rb->aux_pages[rb->aux_nr_pages] = page_address(page);
+	}
+
+	rb->aux_priv = event->pmu->setup_aux(event->cpu, rb->aux_pages, nr_pages,
+					     overwrite);
+	if (!rb->aux_priv)
+		goto out;
+
+	ret = 0;
+
+	/*
+	 * aux_pages (and pmu driver's private data, aux_priv) will be
+	 * referenced in both producer's and consumer's contexts, thus
+	 * we keep a refcount here to make sure either of the two can
+	 * reference them safely.
+	 */
+	atomic_set(&rb->aux_refcount, 1);
+
+out:
+	if (!ret)
+		rb->aux_pgoff = pgoff;
+	else
+		rb_free_aux(rb);
+
+	return ret;
+}
+
+static void __rb_free_aux(struct ring_buffer *rb)
+{
+	int pg;
+
+	if (rb->aux_priv) {
+		rb->free_aux(rb->aux_priv);
+		rb->free_aux = NULL;
+		rb->aux_priv = NULL;
+	}
+
+	for (pg = 0; pg < rb->aux_nr_pages; pg++)
+		free_page((unsigned long)rb->aux_pages[pg]);
+
+	kfree(rb->aux_pages);
+	rb->aux_nr_pages = 0;
+}
+
+void rb_free_aux(struct ring_buffer *rb)
+{
+	if (atomic_dec_and_test(&rb->aux_refcount))
+		__rb_free_aux(rb);
+}
+
 #ifndef CONFIG_PERF_USE_VMALLOC
 
 /*
  * Back perf_mmap() with regular GFP_KERNEL-0 pages.
  */
 
-struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+static struct page *
+__perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
 	if (pgoff > rb->nr_pages)
 		return NULL;
@@ -339,8 +412,8 @@ static int data_page_nr(struct ring_buffer *rb)
 	return rb->nr_pages << page_order(rb);
 }
 
-struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+static struct page *
+__perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
 	/* The '>' counts in the user page. */
 	if (pgoff > data_page_nr(rb))
@@ -415,3 +488,19 @@ fail:
 }
 
 #endif
+
+struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (rb->aux_nr_pages) {
+		/* above AUX space */
+		if (pgoff > rb->aux_pgoff + rb->aux_nr_pages)
+			return NULL;
+
+		/* AUX space */
+		if (pgoff >= rb->aux_pgoff)
+			return virt_to_page(rb->aux_pages[pgoff - rb->aux_pgoff]);
+	}
+
+	return __perf_mmap_to_page(rb, pgoff);
+}
-- 
2.1.4

