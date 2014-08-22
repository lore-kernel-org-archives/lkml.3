Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaHVQxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:53:40 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63245 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaHVQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:34 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/15] percpu: remove the usage of separate populated bitmap in percpu-vm
Date: Fri, 22 Aug 2014 12:53:07 -0400
Message-Id: <1408726399-4436-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu-vm uses pcpu_get_pages_and_bitmap() to acquire temp pages array
and populated bitmap and uses the two during [de]population.  The temp
bitmap is used only to build the new bitmap that is copied to
chunk->populated after the operation succeeds; however, the new bitmap
can be trivially set after success without using the temp bitmap.

This patch removes the temp populated bitmap usage from percpu-vm.c.

* pcpu_get_pages_and_bitmap() is renamed to pcpu_get_pages() and no
  longer hands out the temp bitmap.

* @populated arugment is dropped from all the related functions.
  @populated updates in pcpu_[un]map_pages() are dropped.

* Two loops in pcpu_map_pages() are merged.

* pcpu_[de]populated_chunk() modify chunk->populated bitmap directly
  from @page_start and @page_end after success.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-vm.c | 93 ++++++++++++++++------------------------------------------
 1 file changed, 25 insertions(+), 68 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 5110816..47b47bf 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -20,46 +20,24 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 }
 
 /**
- * pcpu_get_pages_and_bitmap - get temp pages array and bitmap
+ * pcpu_get_pages - get temp pages array
  * @chunk: chunk of interest
- * @bitmapp: output parameter for bitmap
  * @may_alloc: may allocate the array
  *
- * Returns pointer to array of pointers to struct page and bitmap,
- * both of which can be indexed with pcpu_page_idx().  The returned
- * array is cleared to zero and *@bitmapp is copied from
- * @chunk->populated.  Note that there is only one array and bitmap
- * and access exclusion is the caller's responsibility.
- *
- * CONTEXT:
- * pcpu_alloc_mutex and does GFP_KERNEL allocation if @may_alloc.
- * Otherwise, don't care.
+ * Returns pointer to array of pointers to struct page which can be indexed
+ * with pcpu_page_idx().  Note that there is only one array and access
+ * exclusion is the caller's responsibility.
  *
  * RETURNS:
- * Pointer to temp pages array on success, NULL on failure.
+ * Pointer to temp pages array on success.
  */
-static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
-					       unsigned long **bitmapp,
-					       bool may_alloc)
+static struct page **pcpu_get_pages(struct pcpu_chunk *chunk, bool may_alloc)
 {
 	static struct page **pages;
-	static unsigned long *bitmap;
 	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
-	size_t bitmap_size = BITS_TO_LONGS(pcpu_unit_pages) *
-			     sizeof(unsigned long);
-
-	if (!pages || !bitmap) {
-		if (may_alloc && !pages)
-			pages = pcpu_mem_zalloc(pages_size);
-		if (may_alloc && !bitmap)
-			bitmap = pcpu_mem_zalloc(bitmap_size);
-		if (!pages || !bitmap)
-			return NULL;
-	}
 
-	bitmap_copy(bitmap, chunk->populated, pcpu_unit_pages);
-
-	*bitmapp = bitmap;
+	if (!pages && may_alloc)
+		pages = pcpu_mem_zalloc(pages_size);
 	return pages;
 }
 
@@ -67,7 +45,6 @@ static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
  * pcpu_free_pages - free pages which were allocated for @chunk
  * @chunk: chunk pages were allocated for
  * @pages: array of pages to be freed, indexed by pcpu_page_idx()
- * @populated: populated bitmap
  * @page_start: page index of the first page to be freed
  * @page_end: page index of the last page to be freed + 1
  *
@@ -75,8 +52,7 @@ static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
  * The pages were allocated for @chunk.
  */
 static void pcpu_free_pages(struct pcpu_chunk *chunk,
-			    struct page **pages, unsigned long *populated,
-			    int page_start, int page_end)
+			    struct page **pages, int page_start, int page_end)
 {
 	unsigned int cpu;
 	int i;
@@ -95,7 +71,6 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
  * pcpu_alloc_pages - allocates pages for @chunk
  * @chunk: target chunk
  * @pages: array to put the allocated pages into, indexed by pcpu_page_idx()
- * @populated: populated bitmap
  * @page_start: page index of the first page to be allocated
  * @page_end: page index of the last page to be allocated + 1
  *
@@ -104,8 +79,7 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
  * content of @pages and will pass it verbatim to pcpu_map_pages().
  */
 static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
-			    struct page **pages, unsigned long *populated,
-			    int page_start, int page_end)
+			    struct page **pages, int page_start, int page_end)
 {
 	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
 	unsigned int cpu, tcpu;
@@ -164,7 +138,6 @@ static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
  * pcpu_unmap_pages - unmap pages out of a pcpu_chunk
  * @chunk: chunk of interest
  * @pages: pages array which can be used to pass information to free
- * @populated: populated bitmap
  * @page_start: page index of the first page to unmap
  * @page_end: page index of the last page to unmap + 1
  *
@@ -175,8 +148,7 @@ static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
  * proper pre/post flush functions.
  */
 static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
-			     struct page **pages, unsigned long *populated,
-			     int page_start, int page_end)
+			     struct page **pages, int page_start, int page_end)
 {
 	unsigned int cpu;
 	int i;
@@ -192,8 +164,6 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
 				   page_end - page_start);
 	}
-
-	bitmap_clear(populated, page_start, page_end - page_start);
 }
 
 /**
@@ -228,7 +198,6 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
  * pcpu_map_pages - map pages into a pcpu_chunk
  * @chunk: chunk of interest
  * @pages: pages array containing pages to be mapped
- * @populated: populated bitmap
  * @page_start: page index of the first page to map
  * @page_end: page index of the last page to map + 1
  *
@@ -236,13 +205,11 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
  * caller is responsible for calling pcpu_post_map_flush() after all
  * mappings are complete.
  *
- * This function is responsible for setting corresponding bits in
- * @chunk->populated bitmap and whatever is necessary for reverse
- * lookup (addr -> chunk).
+ * This function is responsible for setting up whatever is necessary for
+ * reverse lookup (addr -> chunk).
  */
 static int pcpu_map_pages(struct pcpu_chunk *chunk,
-			  struct page **pages, unsigned long *populated,
-			  int page_start, int page_end)
+			  struct page **pages, int page_start, int page_end)
 {
 	unsigned int cpu, tcpu;
 	int i, err;
@@ -253,18 +220,12 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 				       page_end - page_start);
 		if (err < 0)
 			goto err;
-	}
 
-	/* mapping successful, link chunk and mark populated */
-	for (i = page_start; i < page_end; i++) {
-		for_each_possible_cpu(cpu)
+		for (i = page_start; i < page_end; i++)
 			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
 					    chunk);
-		__set_bit(i, populated);
 	}
-
 	return 0;
-
 err:
 	for_each_possible_cpu(tcpu) {
 		if (tcpu == cpu)
@@ -314,7 +275,6 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int page_end = PFN_UP(off + size);
 	int free_end = page_start, unmap_end = page_start;
 	struct page **pages;
-	unsigned long *populated;
 	unsigned int cpu;
 	int rs, re, rc;
 
@@ -327,28 +287,27 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	/* need to allocate and map pages, this chunk can't be immutable */
 	WARN_ON(chunk->immutable);
 
-	pages = pcpu_get_pages_and_bitmap(chunk, &populated, true);
+	pages = pcpu_get_pages(chunk, true);
 	if (!pages)
 		return -ENOMEM;
 
 	/* alloc and map */
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		rc = pcpu_alloc_pages(chunk, pages, populated, rs, re);
+		rc = pcpu_alloc_pages(chunk, pages, rs, re);
 		if (rc)
 			goto err_free;
 		free_end = re;
 	}
 
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		rc = pcpu_map_pages(chunk, pages, populated, rs, re);
+		rc = pcpu_map_pages(chunk, pages, rs, re);
 		if (rc)
 			goto err_unmap;
 		unmap_end = re;
 	}
 	pcpu_post_map_flush(chunk, page_start, page_end);
 
-	/* commit new bitmap */
-	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
+	bitmap_set(chunk->populated, page_start, page_end - page_start);
 clear:
 	for_each_possible_cpu(cpu)
 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
@@ -357,11 +316,11 @@ clear:
 err_unmap:
 	pcpu_pre_unmap_flush(chunk, page_start, unmap_end);
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, unmap_end)
-		pcpu_unmap_pages(chunk, pages, populated, rs, re);
+		pcpu_unmap_pages(chunk, pages, rs, re);
 	pcpu_post_unmap_tlb_flush(chunk, page_start, unmap_end);
 err_free:
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, free_end)
-		pcpu_free_pages(chunk, pages, populated, rs, re);
+		pcpu_free_pages(chunk, pages, rs, re);
 	return rc;
 }
 
@@ -383,7 +342,6 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int page_start = PFN_DOWN(off);
 	int page_end = PFN_UP(off + size);
 	struct page **pages;
-	unsigned long *populated;
 	int rs, re;
 
 	/* quick path, check whether it's empty already */
@@ -400,22 +358,21 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	 * successful population attempt so the temp pages array must
 	 * be available now.
 	 */
-	pages = pcpu_get_pages_and_bitmap(chunk, &populated, false);
+	pages = pcpu_get_pages(chunk, false);
 	BUG_ON(!pages);
 
 	/* unmap and free */
 	pcpu_pre_unmap_flush(chunk, page_start, page_end);
 
 	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
-		pcpu_unmap_pages(chunk, pages, populated, rs, re);
+		pcpu_unmap_pages(chunk, pages, rs, re);
 
 	/* no need to flush tlb, vmalloc will handle it lazily */
 
 	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
-		pcpu_free_pages(chunk, pages, populated, rs, re);
+		pcpu_free_pages(chunk, pages, rs, re);
 
-	/* commit new bitmap */
-	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
+	bitmap_clear(chunk->populated, page_start, page_end - page_start);
 }
 
 static struct pcpu_chunk *pcpu_create_chunk(void)
-- 
1.9.3

