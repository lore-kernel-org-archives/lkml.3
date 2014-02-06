Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaBFKxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:53:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:4417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbaBFKvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="450662657"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 02/11] perf: Abstract ring_buffer backing store operations
Date: Thu,  6 Feb 2014 12:50:25 +0200
Message-Id: <1391683834-29868-3-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends perf's ring_buffer code so that buffers with different
backing can be allocated simultaneously with rb_alloc(). This allows the reuse
of ring_buffer code for exporting hardware-written trace buffers (such as
those of Intel PT) to userspace.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c        |   4 +-
 kernel/events/internal.h    |  32 +++++++-
 kernel/events/ring_buffer.c | 176 +++++++++++++++++++++++++++-----------------
 3 files changed, 143 insertions(+), 69 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..6899741 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4105,9 +4105,9 @@ again:
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
 
-	rb = rb_alloc(nr_pages, 
+	rb = rb_alloc(event, nr_pages,
 		event->attr.watermark ? event->attr.wakeup_watermark : 0,
-		event->cpu, flags);
+		event->cpu, flags, NULL);
 
 	if (!rb) {
 		ret = -ENOMEM;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b2187..6cb208f 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -6,6 +6,33 @@
 
 /* Buffer handling */
 
+struct ring_buffer;
+
+struct ring_buffer_ops {
+	/*
+	 * How much memory should be allocated for struct ring_buffer, taking into
+	 * account data_pages[] array.
+	 */
+	unsigned long	(*get_size)(int);
+	/*
+	 * Allocate user_page for this buffer, can be NULL, in which case it is
+	 * allocated by alloc_data_page().
+	 */
+	int		(*alloc_user_page)(struct ring_buffer *, int, int);
+	/*
+	 * Allocate data_pages for this buffer.
+	 */
+	int		(*alloc_data_page)(struct ring_buffer *, int, int, int);
+	/*
+	 * Free the buffer.
+	 */
+	void		(*free_buffer)(struct ring_buffer *);
+	/*
+	 * Get a struct page for a given page index in the buffer.
+	 */
+	struct page	*(*mmap_to_page)(struct ring_buffer *, unsigned long);
+};
+
 #define RING_BUFFER_WRITABLE		0x01
 
 struct ring_buffer {
@@ -15,6 +42,8 @@ struct ring_buffer {
 	struct work_struct		work;
 	int				page_order;	/* allocation order  */
 #endif
+	struct ring_buffer_ops		*ops;
+	struct perf_event		*event;
 	int				nr_pages;	/* nr of data pages  */
 	int				overwrite;	/* can overwrite itself */
 
@@ -41,7 +70,8 @@ struct ring_buffer {
 
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
-rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+rb_alloc(struct perf_event *event, int nr_pages, long watermark, int cpu,
+	 int flags, struct ring_buffer_ops *rb_ops);
 extern void perf_event_wakeup(struct perf_event *event);
 
 extern void
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a579..161a676 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -248,18 +248,6 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
  * Back perf_mmap() with regular GFP_KERNEL-0 pages.
  */
 
-struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
-{
-	if (pgoff > rb->nr_pages)
-		return NULL;
-
-	if (pgoff == 0)
-		return virt_to_page(rb->user_page);
-
-	return virt_to_page(rb->data_pages[pgoff - 1]);
-}
-
 static void *perf_mmap_alloc_page(int cpu)
 {
 	struct page *page;
@@ -273,46 +261,31 @@ static void *perf_mmap_alloc_page(int cpu)
 	return page_address(page);
 }
 
-struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+static int perf_mmap_alloc_user_page(struct ring_buffer *rb, int cpu,
+				     int flags)
 {
-	struct ring_buffer *rb;
-	unsigned long size;
-	int i;
-
-	size = sizeof(struct ring_buffer);
-	size += nr_pages * sizeof(void *);
-
-	rb = kzalloc(size, GFP_KERNEL);
-	if (!rb)
-		goto fail;
-
 	rb->user_page = perf_mmap_alloc_page(cpu);
 	if (!rb->user_page)
-		goto fail_user_page;
-
-	for (i = 0; i < nr_pages; i++) {
-		rb->data_pages[i] = perf_mmap_alloc_page(cpu);
-		if (!rb->data_pages[i])
-			goto fail_data_pages;
-	}
+		return -ENOMEM;
 
-	rb->nr_pages = nr_pages;
-
-	ring_buffer_init(rb, watermark, flags);
+	return 0;
+}
 
-	return rb;
+static int perf_mmap_alloc_data_page(struct ring_buffer *rb, int cpu,
+				     int nr_pages, int flags)
+{
+	void *data;
 
-fail_data_pages:
-	for (i--; i >= 0; i--)
-		free_page((unsigned long)rb->data_pages[i]);
+	if (nr_pages != 1)
+		return -EINVAL;
 
-	free_page((unsigned long)rb->user_page);
+	data = perf_mmap_alloc_page(cpu);
+	if (!data)
+		return -ENOMEM;
 
-fail_user_page:
-	kfree(rb);
+	rb->data_pages[rb->nr_pages] = data;
 
-fail:
-	return NULL;
+	return 0;
 }
 
 static void perf_mmap_free_page(unsigned long addr)
@@ -323,24 +296,51 @@ static void perf_mmap_free_page(unsigned long addr)
 	__free_page(page);
 }
 
-void rb_free(struct ring_buffer *rb)
+static void perf_mmap_gfp0_free(struct ring_buffer *rb)
 {
 	int i;
 
-	perf_mmap_free_page((unsigned long)rb->user_page);
+	if (rb->user_page)
+		perf_mmap_free_page((unsigned long)rb->user_page);
 	for (i = 0; i < rb->nr_pages; i++)
 		perf_mmap_free_page((unsigned long)rb->data_pages[i]);
 	kfree(rb);
 }
 
+struct page *
+perf_mmap_gfp0_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (pgoff > rb->nr_pages)
+		return NULL;
+
+	if (pgoff == 0)
+		return virt_to_page(rb->user_page);
+
+	return virt_to_page(rb->data_pages[pgoff - 1]);
+}
+
+static unsigned long perf_mmap_gfp0_get_size(int nr_pages)
+{
+	return sizeof(struct ring_buffer) + sizeof(void *) * nr_pages;
+}
+
+struct ring_buffer_ops perf_rb_ops = {
+	.get_size		= perf_mmap_gfp0_get_size,
+	.alloc_user_page	= perf_mmap_alloc_user_page,
+	.alloc_data_page	= perf_mmap_alloc_data_page,
+	.free_buffer		= perf_mmap_gfp0_free,
+	.mmap_to_page		= perf_mmap_gfp0_to_page,
+};
+
 #else
+
 static int data_page_nr(struct ring_buffer *rb)
 {
 	return rb->nr_pages << page_order(rb);
 }
 
 struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+perf_mmap_vmalloc_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
 	/* The '>' counts in the user page. */
 	if (pgoff > data_page_nr(rb))
@@ -349,14 +349,14 @@ perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
 }
 
-static void perf_mmap_unmark_page(void *addr)
+static void perf_mmap_vmalloc_unmark_page(void *addr)
 {
 	struct page *page = vmalloc_to_page(addr);
 
 	page->mapping = NULL;
 }
 
-static void rb_free_work(struct work_struct *work)
+static void perf_mmap_vmalloc_free_work(struct work_struct *work)
 {
 	struct ring_buffer *rb;
 	void *base;
@@ -368,50 +368,94 @@ static void rb_free_work(struct work_struct *work)
 	base = rb->user_page;
 	/* The '<=' counts in the user page. */
 	for (i = 0; i <= nr; i++)
-		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+		perf_mmap_vmalloc_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
 	kfree(rb);
 }
 
-void rb_free(struct ring_buffer *rb)
+static void perf_mmap_vmalloc_free(struct ring_buffer *rb)
 {
 	schedule_work(&rb->work);
 }
 
-struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+static int perf_mmap_vmalloc_data_pages(struct ring_buffer *rb, int cpu,
+					int nr_pages, int flags)
 {
-	struct ring_buffer *rb;
-	unsigned long size;
 	void *all_buf;
 
-	size = sizeof(struct ring_buffer);
-	size += sizeof(void *);
-
-	rb = kzalloc(size, GFP_KERNEL);
-	if (!rb)
-		goto fail;
-
-	INIT_WORK(&rb->work, rb_free_work);
+	INIT_WORK(&rb->work, perf_mmap_vmalloc_free_work);
 
 	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
 	if (!all_buf)
-		goto fail_all_buf;
+		return -ENOMEM;
 
 	rb->user_page = all_buf;
 	rb->data_pages[0] = all_buf + PAGE_SIZE;
 	rb->page_order = ilog2(nr_pages);
 	rb->nr_pages = !!nr_pages;
 
+	return 0;
+}
+
+static unsigned long perf_mmap_vmalloc_get_size(int nr_pages)
+{
+	return sizeof(struct ring_buffer) + sizeof(void *);
+}
+
+struct ring_buffer_ops perf_rb_ops = {
+	.get_size		= perf_mmap_vmalloc_get_size,
+	.alloc_data_page	= perf_mmap_vmalloc_data_pages,
+	.free_buffer		= perf_mmap_vmalloc_free,
+	.mmap_to_page		= perf_mmap_vmalloc_to_page,
+};
+
+#endif
+
+struct ring_buffer *rb_alloc(struct perf_event *event, int nr_pages,
+			     long watermark, int cpu, int flags,
+			     struct ring_buffer_ops *rb_ops)
+{
+	struct ring_buffer *rb;
+	int i;
+
+	if (!rb_ops)
+		rb_ops = &perf_rb_ops;
+
+	rb = kzalloc(rb_ops->get_size(nr_pages), GFP_KERNEL);
+	if (!rb)
+		return NULL;
+
+	rb->event = event;
+	rb->ops = rb_ops;
+	if (rb->ops->alloc_user_page) {
+		if (rb->ops->alloc_user_page(rb, cpu, flags))
+			goto fail;
+
+		for (i = 0; i < nr_pages; i++, rb->nr_pages++)
+			if (rb->ops->alloc_data_page(rb, cpu, 1, flags))
+				goto fail;
+	} else {
+		if (rb->ops->alloc_data_page(rb, cpu, nr_pages, flags))
+			goto fail;
+	}
+
 	ring_buffer_init(rb, watermark, flags);
 
 	return rb;
 
-fail_all_buf:
-	kfree(rb);
-
 fail:
+	rb->ops->free_buffer(rb);
 	return NULL;
 }
 
-#endif
+void rb_free(struct ring_buffer *rb)
+{
+	rb->ops->free_buffer(rb);
+}
+
+struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	return rb->ops->mmap_to_page(rb, pgoff);
+}
-- 
1.8.5.2

