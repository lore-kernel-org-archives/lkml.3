Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbaHVQ4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:56:54 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60441 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHVQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:39 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/15] percpu: move region iterations out of pcpu_[de]populate_chunk()
Date: Fri, 22 Aug 2014 12:53:10 -0400
Message-Id: <1408726399-4436-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, pcpu_[de]populate_chunk() were called with the range which
may contain multiple target regions in it and
pcpu_[de]populate_chunk() iterated over the regions.  This has the
benefit of batching up cache flushes for all the regions; however,
we're planning to add more bookkeeping logic around [de]population to
support atomic allocations and this delegation of iterations gets in
the way.

This patch moves the region iterations out of
pcpu_[de]populate_chunk() into its callers - pcpu_alloc() and
pcpu_reclaim() - so that we can later add logic to track more states
around them.  This change may make cache and tlb flushes more frequent
but multi-region [de]populations are rare anyway and if this actually
becomes a problem, it's not difficult to factor out cache flushes as
separate callbacks which are directly invoked from percpu.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-km.c |  6 ++++--
 mm/percpu-vm.c | 57 ++++++++++++++++-----------------------------------------
 mm/percpu.c    | 19 ++++++++-----------
 3 files changed, 28 insertions(+), 54 deletions(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 9a9096f..a6e34bc 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -33,12 +33,14 @@
 
 #include <linux/log2.h>
 
-static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
+			       int page_start, int page_end)
 {
 	return 0;
 }
 
-static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
+				  int page_start, int page_end)
 {
 	/* nada */
 }
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index edf7097..538998a 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -261,8 +261,8 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
 /**
  * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
  * @chunk: chunk of interest
- * @off: offset to the area to populate
- * @size: size of the area to populate in bytes
+ * @page_start: the start page
+ * @page_end: the end page
  *
  * For each cpu, populate and map pages [@page_start,@page_end) into
  * @chunk.
@@ -270,66 +270,43 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
  * CONTEXT:
  * pcpu_alloc_mutex, does GFP_KERNEL allocation.
  */
-static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
+			       int page_start, int page_end)
 {
-	int page_start = PFN_DOWN(off);
-	int page_end = PFN_UP(off + size);
-	int free_end = page_start, unmap_end = page_start;
 	struct page **pages;
-	int rs, re, rc;
 
 	pages = pcpu_get_pages(chunk);
 	if (!pages)
 		return -ENOMEM;
 
-	/* alloc and map */
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		rc = pcpu_alloc_pages(chunk, pages, rs, re);
-		if (rc)
-			goto err_free;
-		free_end = re;
-	}
+	if (pcpu_alloc_pages(chunk, pages, page_start, page_end))
+		return -ENOMEM;
 
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		rc = pcpu_map_pages(chunk, pages, rs, re);
-		if (rc)
-			goto err_unmap;
-		unmap_end = re;
+	if (pcpu_map_pages(chunk, pages, page_start, page_end)) {
+		pcpu_free_pages(chunk, pages, page_start, page_end);
+		return -ENOMEM;
 	}
 	pcpu_post_map_flush(chunk, page_start, page_end);
 
 	return 0;
-
-err_unmap:
-	pcpu_pre_unmap_flush(chunk, page_start, unmap_end);
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, unmap_end)
-		pcpu_unmap_pages(chunk, pages, rs, re);
-	pcpu_post_unmap_tlb_flush(chunk, page_start, unmap_end);
-err_free:
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, free_end)
-		pcpu_free_pages(chunk, pages, rs, re);
-	return rc;
 }
 
 /**
  * pcpu_depopulate_chunk - depopulate and unmap an area of a pcpu_chunk
  * @chunk: chunk to depopulate
- * @off: offset to the area to depopulate
- * @size: size of the area to depopulate in bytes
+ * @page_start: the start page
+ * @page_end: the end page
  *
  * For each cpu, depopulate and unmap pages [@page_start,@page_end)
- * from @chunk.  If @flush is true, vcache is flushed before unmapping
- * and tlb after.
+ * from @chunk.
  *
  * CONTEXT:
  * pcpu_alloc_mutex.
  */
-static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
+				  int page_start, int page_end)
 {
-	int page_start = PFN_DOWN(off);
-	int page_end = PFN_UP(off + size);
 	struct page **pages;
-	int rs, re;
 
 	/*
 	 * If control reaches here, there must have been at least one
@@ -342,13 +319,11 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	/* unmap and free */
 	pcpu_pre_unmap_flush(chunk, page_start, page_end);
 
-	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
-		pcpu_unmap_pages(chunk, pages, rs, re);
+	pcpu_unmap_pages(chunk, pages, page_start, page_end);
 
 	/* no need to flush tlb, vmalloc will handle it lazily */
 
-	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
-		pcpu_free_pages(chunk, pages, rs, re);
+	pcpu_free_pages(chunk, pages, page_start, page_end);
 }
 
 static struct pcpu_chunk *pcpu_create_chunk(void)
diff --git a/mm/percpu.c b/mm/percpu.c
index 12b0049..c8fe482 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -807,20 +807,17 @@ area_found:
 	page_start = PFN_DOWN(off);
 	page_end = PFN_UP(off + size);
 
-	rs = page_start;
-	pcpu_next_pop(chunk, &rs, &re, page_end);
-
-	if (rs != page_start || re != page_end) {
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
 		WARN_ON(chunk->immutable);
 
-		if (pcpu_populate_chunk(chunk, off, size)) {
+		if (pcpu_populate_chunk(chunk, rs, re)) {
 			spin_lock_irqsave(&pcpu_lock, flags);
 			pcpu_free_area(chunk, off);
 			err = "failed to populate";
 			goto fail_unlock;
 		}
 
-		bitmap_set(chunk->populated, page_start, page_end - page_start);
+		bitmap_set(chunk->populated, rs, re - rs);
 	}
 
 	mutex_unlock(&pcpu_alloc_mutex);
@@ -919,12 +916,12 @@ static void pcpu_reclaim(struct work_struct *work)
 	spin_unlock_irq(&pcpu_lock);
 
 	list_for_each_entry_safe(chunk, next, &todo, list) {
-		int rs = 0, re;
-
-		pcpu_next_unpop(chunk, &rs, &re, PFN_UP(pcpu_unit_size));
-		if (rs || re != PFN_UP(pcpu_unit_size))
-			pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
+		int rs, re;
 
+		pcpu_for_each_pop_region(chunk, rs, re, 0, pcpu_unit_pages) {
+			pcpu_depopulate_chunk(chunk, rs, re);
+			bitmap_clear(chunk->populated, rs, re - rs);
+		}
 		pcpu_destroy_chunk(chunk);
 	}
 
-- 
1.9.3

