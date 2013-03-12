Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3CLKFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:05:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab3CLKFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:05:36 -0400
Date: Tue, 12 Mar 2013 11:05:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCHv3] perf: Fix vmalloc ring buffer free function
Message-ID: <20130312100502.GC1348@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
 <1362994843.10972.40.camel@laptop>
 <20130311112105.GA9737@krava.brq.redhat.com>
 <1363019193.14933.14.camel@laptop>
 <20130311164309.GG13679@krava.brq.redhat.com>
 <1363023885.14933.16.camel@laptop>
 <20130311180229.GI13679@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311180229.GI13679@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we allocate perf ring buffer with the size of single page,
we will get memory corruption when releasing it. It's caused
by rb_free_work function (CONFIG_PERF_USE_VMALLOC option).

For single page sized ring buffer the page_order is -1 (because
nr_pages is 0). This needs to be recognized in the rb_free_work
function to release proper amount of pages.

Introducing page_nr function (CONFIG_PERF_USE_VMALLOC only)
that returns number of allocated pages. Using it in rb_free_work
and perf_mmap_to_page functions.

Also setting rb->nr_pages to 0 in case we have only user page
allocated, which will fail perf_output_begin function and
prevents sample storage.

v3 changes:
  - fixed perf_mmap_to_page check
  - keep page_order in handle->page computation

v2 changes:
  - fixed the perf_output_begin handling of single page buffer

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/ring_buffer.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..4219be6 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -312,11 +312,21 @@ void rb_free(struct ring_buffer *rb)
 }
 
 #else
+/*
+ * Returns the total number of pages allocated
+ * by ring buffer including the user page.
+ */
+static int page_nr(struct ring_buffer *rb)
+{
+	return page_order(rb) == -1 ?
+		1 :                        /* no data, just user page */
+		1 + (1 << page_order(rb)); /* user page + data pages */
+}
 
 struct page *
 perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
-	if (pgoff > (1UL << page_order(rb)))
+	if (pgoff >= page_nr(rb))
 		return NULL;
 
 	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
@@ -336,10 +346,10 @@ static void rb_free_work(struct work_struct *work)
 	int i, nr;
 
 	rb = container_of(work, struct ring_buffer, work);
-	nr = 1 << page_order(rb);
+	nr = page_nr(rb);
 
 	base = rb->user_page;
-	for (i = 0; i < nr + 1; i++)
+	for (i = 0; i < nr; i++)
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
@@ -371,9 +381,24 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 		goto fail_all_buf;
 
 	rb->user_page = all_buf;
-	rb->data_pages[0] = all_buf + PAGE_SIZE;
-	rb->page_order = ilog2(nr_pages);
-	rb->nr_pages = 1;
+
+	/*
+	 * For special case nr_pages == 0 we have
+	 * only the user page mmaped plus:
+	 *
+	 *   rb->data_pages[0] = NULL
+	 *   rb->nr_pages      = 0
+	 *   rb->page_order    = -1
+	 *
+	 * The perf_output_begin function is guarded
+	 * by (rb->nr_pages > 0) condition, so no
+	 * output code touches above setup if we
+	 * have only user page allocated.
+	 */
+
+	rb->data_pages[0] = nr_pages ? all_buf + PAGE_SIZE : NULL;
+	rb->nr_pages      = nr_pages ? 1 : 0;
+	rb->page_order    = ilog2(nr_pages);
 
 	ring_buffer_init(rb, watermark, flags);
 
-- 
1.7.11.7

