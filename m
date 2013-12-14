Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3LND1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:49 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60418 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3LND1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:06 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 105/115] ion: remove ion_heap_alloc_pages
Date: Fri, 13 Dec 2013 19:26:25 -0800
Message-Id: <1386991595-6251-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Now that ion_vm_fault doesn't need a struct page with a nonzero
refcount, there is no need allocate heap memory for cached pages using
split_page.  Remove the ion_heap_alloc_pages and ion_heap_free_pages
helpers in favor of direct calls to alloc_pages and __free_pages,
and remove the special handling in the system heap.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c        | 27 ---------------------------
 drivers/staging/android/ion/ion_priv.h        | 13 -------------
 drivers/staging/android/ion/ion_system_heap.c |  7 +------
 3 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index ecc14fd..8054611 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -148,33 +148,6 @@ end:
 	return ret;
 }
 
-struct page *ion_heap_alloc_pages(struct ion_buffer *buffer, gfp_t gfp_flags,
-				  unsigned int order)
-{
-	struct page *page = alloc_pages(gfp_flags, order);
-
-	if (!page)
-		return page;
-
-	if (ion_buffer_fault_user_mappings(buffer))
-		split_page(page, order);
-
-	return page;
-}
-
-void ion_heap_free_pages(struct ion_buffer *buffer, struct page *page,
-			 unsigned int order)
-{
-	int i;
-
-	if (!ion_buffer_fault_user_mappings(buffer)) {
-		__free_pages(page, order);
-		return;
-	}
-	for (i = 0; i < (1 << order); i++)
-		__free_page(page + i);
-}
-
 void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer * buffer)
 {
 	rt_mutex_lock(&heap->lock);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index d1fa771..c9b507d 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -217,19 +217,6 @@ int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
 int ion_heap_buffer_zero(struct ion_buffer *buffer);
 
 /**
- * ion_heap_alloc_pages - allocate pages from alloc_pages
- * @buffer:		the buffer to allocate for, used to extract the flags
- * @gfp_flags:		the gfp_t for the allocation
- * @order:		the order of the allocatoin
- *
- * This funciton allocations from alloc pages and also does any other
- * necessary operations based on the buffer->flags.  For buffers which
- * will be faulted in the pages are split using split_page
- */
-struct page *ion_heap_alloc_pages(struct ion_buffer *buffer, gfp_t gfp_flags,
-				  unsigned int order);
-
-/**
  * ion_heap_init_deferred_free -- initialize deferred free functionality
  * @heap:		the heap
  *
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index bec9d45..a4bcf09 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -74,7 +74,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 		if (order > 4)
 			gfp_flags = high_order_gfp_flags;
-		page = ion_heap_alloc_pages(buffer, gfp_flags, order);
+		page = alloc_pages(gfp_flags, order);
 		if (!page)
 			return 0;
 		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
@@ -91,15 +91,10 @@ static void free_buffer_page(struct ion_system_heap *heap,
 			     unsigned int order)
 {
 	bool cached = ion_buffer_cached(buffer);
-	bool split_pages = ion_buffer_fault_user_mappings(buffer);
-	int i;
 
 	if (!cached) {
 		struct ion_page_pool *pool = heap->pools[order_to_index(order)];
 		ion_page_pool_free(pool, page);
-	} else if (split_pages) {
-		for (i = 0; i < (1 << order); i++)
-			__free_page(page + i);
 	} else {
 		__free_pages(page, order);
 	}
-- 
1.8.3.2

