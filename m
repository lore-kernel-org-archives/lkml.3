Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbaHVQyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:54:43 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:39069 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856AbaHVQxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:48 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/15] percpu: implmeent pcpu_nr_empty_pop_pages and chunk->nr_populated
Date: Fri, 22 Aug 2014 12:53:17 -0400
Message-Id: <1408726399-4436-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_nr_empty_pop_pages counts the number of empty populated pages
across all chunks and chunk->nr_populated counts the number of
populated pages in a chunk.  Both will be used to implement pre/async
population for atomic allocations.

pcpu_chunk_[de]populated() are added to update chunk->populated,
chunk->nr_populated and pcpu_nr_empty_pop_pages together.  All
successful chunk [de]populations should be followed by the
corresponding pcpu_chunk_[de]populated() calls.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-km.c |   2 +-
 mm/percpu.c    | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index e662b49..10e3d0b 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
 	chunk->base_addr = page_address(pages) - pcpu_group_offsets[0];
 
 	spin_lock_irq(&pcpu_lock);
-	bitmap_fill(chunk->populated, nr_pages);
+	pcpu_chunk_populated(chunk, 0, nr_pages);
 	spin_unlock_irq(&pcpu_lock);
 
 	return chunk;
diff --git a/mm/percpu.c b/mm/percpu.c
index d6b36e7..7f076ed 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -113,6 +113,7 @@ struct pcpu_chunk {
 	void			*data;		/* chunk data */
 	int			first_free;	/* no free below this */
 	bool			immutable;	/* no [de]population allowed */
+	int			nr_populated;	/* # of populated pages */
 	unsigned long		populated[];	/* populated bitmap */
 };
 
@@ -161,6 +162,12 @@ static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop */
 
 static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 
+/*
+ * The number of empty populated pages, protected by pcpu_lock.  The
+ * reserved chunk doesn't contribute to the count.
+ */
+static int pcpu_nr_empty_pop_pages;
+
 /* reclaim work to release fully free chunks, scheduled from free path */
 static void pcpu_reclaim(struct work_struct *work);
 static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
@@ -296,6 +303,38 @@ static void pcpu_mem_free(void *ptr, size_t size)
 }
 
 /**
+ * pcpu_count_occupied_pages - count the number of pages an area occupies
+ * @chunk: chunk of interest
+ * @i: index of the area in question
+ *
+ * Count the number of pages chunk's @i'th area occupies.  When the area's
+ * start and/or end address isn't aligned to page boundary, the straddled
+ * page is included in the count iff the rest of the page is free.
+ */
+static int pcpu_count_occupied_pages(struct pcpu_chunk *chunk, int i)
+{
+	int off = chunk->map[i] & ~1;
+	int end = chunk->map[i + 1] & ~1;
+
+	if (!PAGE_ALIGNED(off) && i > 0) {
+		int prev = chunk->map[i - 1];
+
+		if (!(prev & 1) && prev <= round_down(off, PAGE_SIZE))
+			off = round_down(off, PAGE_SIZE);
+	}
+
+	if (!PAGE_ALIGNED(end) && i + 1 < chunk->map_used) {
+		int next = chunk->map[i + 1];
+		int nend = chunk->map[i + 2] & ~1;
+
+		if (!(next & 1) && nend >= round_up(end, PAGE_SIZE))
+			end = round_up(end, PAGE_SIZE);
+	}
+
+	return max_t(int, PFN_DOWN(end) - PFN_UP(off), 0);
+}
+
+/**
  * pcpu_chunk_relocate - put chunk in the appropriate chunk slot
  * @chunk: chunk of interest
  * @oslot: the previous slot it was on
@@ -483,6 +522,7 @@ static int pcpu_fit_in_area(struct pcpu_chunk *chunk, int off, int this_size,
  * @size: wanted size in bytes
  * @align: wanted align
  * @pop_only: allocate only from the populated area
+ * @occ_pages_p: out param for the number of pages the area occupies
  *
  * Try to allocate @size bytes area aligned at @align from @chunk.
  * Note that this function only allocates the offset.  It doesn't
@@ -498,7 +538,7 @@ static int pcpu_fit_in_area(struct pcpu_chunk *chunk, int off, int this_size,
  * found.
  */
 static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
-			   bool pop_only)
+			   bool pop_only, int *occ_pages_p)
 {
 	int oslot = pcpu_chunk_slot(chunk);
 	int max_contig = 0;
@@ -587,6 +627,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
 		chunk->free_size -= size;
 		*p |= 1;
 
+		*occ_pages_p = pcpu_count_occupied_pages(chunk, i);
 		pcpu_chunk_relocate(chunk, oslot);
 		return off;
 	}
@@ -602,6 +643,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
  * pcpu_free_area - free area to a pcpu_chunk
  * @chunk: chunk of interest
  * @freeme: offset of area to free
+ * @occ_pages_p: out param for the number of pages the area occupies
  *
  * Free area starting from @freeme to @chunk.  Note that this function
  * only modifies the allocation map.  It doesn't depopulate or unmap
@@ -610,7 +652,8 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
  * CONTEXT:
  * pcpu_lock.
  */
-static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
+static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme,
+			   int *occ_pages_p)
 {
 	int oslot = pcpu_chunk_slot(chunk);
 	int off = 0;
@@ -641,6 +684,8 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 	*p = off &= ~1;
 	chunk->free_size += (p[1] & ~1) - off;
 
+	*occ_pages_p = pcpu_count_occupied_pages(chunk, i);
+
 	/* merge with next? */
 	if (!(p[1] & 1))
 		to_free++;
@@ -696,6 +741,50 @@ static void pcpu_free_chunk(struct pcpu_chunk *chunk)
 	pcpu_mem_free(chunk, pcpu_chunk_struct_size);
 }
 
+/**
+ * pcpu_chunk_populated - post-population bookkeeping
+ * @chunk: pcpu_chunk which got populated
+ * @page_start: the start page
+ * @page_end: the end page
+ *
+ * Pages in [@page_start,@page_end) have been populated to @chunk.  Update
+ * the bookkeeping information accordingly.  Must be called after each
+ * successful population.
+ */
+static void pcpu_chunk_populated(struct pcpu_chunk *chunk,
+				 int page_start, int page_end)
+{
+	int nr = page_end - page_start;
+
+	lockdep_assert_held(&pcpu_lock);
+
+	bitmap_set(chunk->populated, page_start, nr);
+	chunk->nr_populated += nr;
+	pcpu_nr_empty_pop_pages += nr;
+}
+
+/**
+ * pcpu_chunk_depopulated - post-depopulation bookkeeping
+ * @chunk: pcpu_chunk which got depopulated
+ * @page_start: the start page
+ * @page_end: the end page
+ *
+ * Pages in [@page_start,@page_end) have been depopulated from @chunk.
+ * Update the bookkeeping information accordingly.  Must be called after
+ * each successful depopulation.
+ */
+static void pcpu_chunk_depopulated(struct pcpu_chunk *chunk,
+				   int page_start, int page_end)
+{
+	int nr = page_end - page_start;
+
+	lockdep_assert_held(&pcpu_lock);
+
+	bitmap_clear(chunk->populated, page_start, nr);
+	chunk->nr_populated -= nr;
+	pcpu_nr_empty_pop_pages -= nr;
+}
+
 /*
  * Chunk management implementation.
  *
@@ -772,6 +861,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	struct pcpu_chunk *chunk;
 	const char *err;
 	bool is_atomic = !(gfp & GFP_KERNEL);
+	int occ_pages = 0;
 	int slot, off, new_alloc, cpu, ret;
 	unsigned long flags;
 	void __percpu *ptr;
@@ -812,7 +902,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 			spin_lock_irqsave(&pcpu_lock, flags);
 		}
 
-		off = pcpu_alloc_area(chunk, size, align, is_atomic);
+		off = pcpu_alloc_area(chunk, size, align, is_atomic,
+				      &occ_pages);
 		if (off >= 0)
 			goto area_found;
 
@@ -845,7 +936,8 @@ restart:
 				goto restart;
 			}
 
-			off = pcpu_alloc_area(chunk, size, align, is_atomic);
+			off = pcpu_alloc_area(chunk, size, align, is_atomic,
+					      &occ_pages);
 			if (off >= 0)
 				goto area_found;
 		}
@@ -899,17 +991,20 @@ area_found:
 			spin_lock_irqsave(&pcpu_lock, flags);
 			if (ret) {
 				mutex_unlock(&pcpu_alloc_mutex);
-				pcpu_free_area(chunk, off);
+				pcpu_free_area(chunk, off, &occ_pages);
 				err = "failed to populate";
 				goto fail_unlock;
 			}
-			bitmap_set(chunk->populated, rs, re - rs);
+			pcpu_chunk_populated(chunk, rs, re);
 			spin_unlock_irqrestore(&pcpu_lock, flags);
 		}
 
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
+	if (chunk != pcpu_reserved_chunk)
+		pcpu_nr_empty_pop_pages -= occ_pages;
+
 	/* clear the areas and return address relative to base address */
 	for_each_possible_cpu(cpu)
 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
@@ -1019,7 +1114,9 @@ static void pcpu_reclaim(struct work_struct *work)
 
 		pcpu_for_each_pop_region(chunk, rs, re, 0, pcpu_unit_pages) {
 			pcpu_depopulate_chunk(chunk, rs, re);
-			bitmap_clear(chunk->populated, rs, re - rs);
+			spin_lock_irq(&pcpu_lock);
+			pcpu_chunk_depopulated(chunk, rs, re);
+			spin_unlock_irq(&pcpu_lock);
 		}
 		pcpu_destroy_chunk(chunk);
 	}
@@ -1041,7 +1138,7 @@ void free_percpu(void __percpu *ptr)
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
-	int off;
+	int off, occ_pages;
 
 	if (!ptr)
 		return;
@@ -1055,7 +1152,10 @@ void free_percpu(void __percpu *ptr)
 	chunk = pcpu_chunk_addr_search(addr);
 	off = addr - chunk->base_addr;
 
-	pcpu_free_area(chunk, off);
+	pcpu_free_area(chunk, off, &occ_pages);
+
+	if (chunk != pcpu_reserved_chunk)
+		pcpu_nr_empty_pop_pages += occ_pages;
 
 	/* if there are more than one fully free chunks, wake up grim reaper */
 	if (chunk->free_size == pcpu_unit_size) {
@@ -1459,6 +1559,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	schunk->map_alloc = ARRAY_SIZE(smap);
 	schunk->immutable = true;
 	bitmap_fill(schunk->populated, pcpu_unit_pages);
+	schunk->nr_populated = pcpu_unit_pages;
 
 	if (ai->reserved_size) {
 		schunk->free_size = ai->reserved_size;
@@ -1488,6 +1589,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 		dchunk->map_alloc = ARRAY_SIZE(dmap);
 		dchunk->immutable = true;
 		bitmap_fill(dchunk->populated, pcpu_unit_pages);
+		dchunk->nr_populated = pcpu_unit_pages;
 
 		dchunk->contig_hint = dchunk->free_size = dyn_size;
 		dchunk->map[0] = 1;
@@ -1498,6 +1600,8 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 	/* link the first chunk in */
 	pcpu_first_chunk = dchunk ?: schunk;
+	pcpu_nr_empty_pop_pages +=
+		pcpu_count_occupied_pages(pcpu_first_chunk, 1);
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
 
 	/* we're done */
-- 
1.9.3

