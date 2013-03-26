Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab3CZNO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:14:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:34842 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab3CZNO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="276111338"
From: Imre Deak <imre.deak@intel.com>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/2] lib/scatterlist: sg_page_iter: support sg lists w/o backing pages
Date: Tue, 26 Mar 2013 15:14:18 +0200
Message-Id: <1364303659-1951-2-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
References: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i915 driver uses sg lists for memory without backing 'struct page'
pages, similarly to other IO memory regions, setting only the DMA
address for these. It does this, so that it can program the HW MMU
tables in a uniform way both for sg lists with and without backing pages.

Without a valid page pointer we can't call nth_page to get the current
page in __sg_page_iter_next, so add a helper that relevant users can
call separately. Also add a helper to get the DMA address of the current
page (idea from Daniel).

Convert all places in i915, to use the new API.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/drm_cache.c            |    2 +-
 drivers/gpu/drm/i915/i915_drv.h        |    2 +-
 drivers/gpu/drm/i915/i915_gem.c        |    8 ++++----
 drivers/gpu/drm/i915/i915_gem_dmabuf.c |    2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c    |    6 ++----
 drivers/gpu/drm/i915/i915_gem_tiling.c |    4 ++--
 include/linux/scatterlist.h            |   28 +++++++++++++++++++++++-----
 lib/scatterlist.c                      |    4 +---
 8 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index bc8edbe..bb8f580 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -109,7 +109,7 @@ drm_clflush_sg(struct sg_table *st)
 
 		mb();
 		for_each_sg_page(st->sgl, &sg_iter, st->nents, 0)
-			drm_clflush_page(sg_iter.page);
+			drm_clflush_page(sg_page_iter_page(&sg_iter));
 		mb();
 
 		return;
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 625cccf..76238fe 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1532,7 +1532,7 @@ static inline struct page *i915_gem_object_get_page(struct drm_i915_gem_object *
 	struct sg_page_iter sg_iter;
 
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, n)
-		return sg_iter.page;
+		return sg_page_iter_page(&sg_iter);
 
 	return NULL;
 }
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 8a2cbee..c1ce462 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -442,7 +442,7 @@ i915_gem_shmem_pread(struct drm_device *dev,
 
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents,
 			 offset >> PAGE_SHIFT) {
-		struct page *page = sg_iter.page;
+		struct page *page = sg_page_iter_page(&sg_iter);
 
 		if (remain <= 0)
 			break;
@@ -765,7 +765,7 @@ i915_gem_shmem_pwrite(struct drm_device *dev,
 
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents,
 			 offset >> PAGE_SHIFT) {
-		struct page *page = sg_iter.page;
+		struct page *page = sg_page_iter_page(&sg_iter);
 		int partial_cacheline_write;
 
 		if (remain <= 0)
@@ -1647,7 +1647,7 @@ i915_gem_object_put_pages_gtt(struct drm_i915_gem_object *obj)
 		obj->dirty = 0;
 
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
-		struct page *page = sg_iter.page;
+		struct page *page = sg_page_iter_page(&sg_iter);
 
 		if (obj->dirty)
 			set_page_dirty(page);
@@ -1827,7 +1827,7 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 err_pages:
 	sg_mark_end(sg);
 	for_each_sg_page(st->sgl, &sg_iter, st->nents, 0)
-		page_cache_release(sg_iter.page);
+		page_cache_release(sg_page_iter_page(&sg_iter));
 	sg_free_table(st);
 	kfree(st);
 	return PTR_ERR(page);
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 898615d..c6dfc14 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -130,7 +130,7 @@ static void *i915_gem_dmabuf_vmap(struct dma_buf *dma_buf)
 
 	i = 0;
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0);
-		pages[i++] = sg_iter.page;
+		pages[i++] = sg_page_iter_page(&sg_iter);
 
 	obj->dma_buf_vmapping = vmap(pages, i, 0, PAGE_KERNEL);
 	drm_free_large(pages);
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 4cbae7b..24a23b3 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -123,8 +123,7 @@ static void gen6_ppgtt_insert_entries(struct i915_hw_ppgtt *ppgtt,
 	for_each_sg_page(pages->sgl, &sg_iter, pages->nents, 0) {
 		dma_addr_t page_addr;
 
-		page_addr = sg_dma_address(sg_iter.sg) +
-				(sg_iter.sg_pgoffset << PAGE_SHIFT);
+		page_addr = sg_page_iter_dma_address(&sg_iter);
 		pt_vaddr[act_pte] = gen6_pte_encode(ppgtt->dev, page_addr,
 						    cache_level);
 		if (++act_pte == I915_PPGTT_PT_ENTRIES) {
@@ -424,8 +423,7 @@ static void gen6_ggtt_insert_entries(struct drm_device *dev,
 	dma_addr_t addr;
 
 	for_each_sg_page(st->sgl, &sg_iter, st->nents, 0) {
-		addr = sg_dma_address(sg_iter.sg) +
-			(sg_iter.sg_pgoffset << PAGE_SHIFT);
+		addr = sg_page_iter_dma_address(&sg_iter);
 		iowrite32(gen6_pte_encode(dev, addr, level), &gtt_entries[i]);
 		i++;
 	}
diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c b/drivers/gpu/drm/i915/i915_gem_tiling.c
index f799708..c807eb9 100644
--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -481,7 +481,7 @@ i915_gem_object_do_bit_17_swizzle(struct drm_i915_gem_object *obj)
 
 	i = 0;
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
-		struct page *page = sg_iter.page;
+		struct page *page = sg_page_iter_page(&sg_iter);
 		char new_bit_17 = page_to_phys(page) >> 17;
 		if ((new_bit_17 & 0x1) !=
 		    (test_bit(i, obj->bit_17) != 0)) {
@@ -511,7 +511,7 @@ i915_gem_object_save_bit_17_swizzle(struct drm_i915_gem_object *obj)
 
 	i = 0;
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
-		if (page_to_phys(sg_iter.page) & (1 << 17))
+		if (page_to_phys(sg_page_iter_page(&sg_iter)) & (1 << 17))
 			__set_bit(i, obj->bit_17);
 		else
 			__clear_bit(i, obj->bit_17);
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2d8bdae..e96b954 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -235,13 +235,13 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
  * sg page iterator
  *
  * Iterates over sg entries page-by-page.  On each successful iteration,
- * @piter->page points to the current page, @piter->sg to the sg holding this
- * page and @piter->sg_pgoffset to the page's page offset within the sg. The
- * iteration will stop either when a maximum number of sg entries was reached
- * or a terminating sg (sg_last(sg) == true) was reached.
+ * you can call sg_page_iter_page(@piter) and sg_page_iter_dma_address(@piter)
+ * to get the current page and its dma address. @piter->sg will point to the
+ * sg holding this page and @piter->sg_pgoffset to the page's page offset
+ * within the sg. The iteration will stop either when a maximum number of sg
+ * entries was reached or a terminating sg (sg_last(sg) == true) was reached.
  */
 struct sg_page_iter {
-	struct page		*page;		/* current page */
 	struct scatterlist	*sg;		/* sg holding the page */
 	unsigned int		sg_pgoffset;	/* page offset within the sg */
 
@@ -255,6 +255,24 @@ bool __sg_page_iter_next(struct sg_page_iter *piter);
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset);
+/**
+ * sg_page_iter_page - get the current page held by the page iterator
+ * @piter:	page iterator holding the page
+ */
+static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
+{
+	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+}
+
+/**
+ * sg_page_iter_dma_address - get the dma address of the current page held by
+ * the page iterator.
+ * @piter:	page iterator holding the page
+ */
+static inline dma_addr_t sg_page_iter_dma_address(struct sg_page_iter *piter)
+{
+	return sg_dma_address(piter->sg) + (piter->sg_pgoffset << PAGE_SHIFT);
+}
 
 /**
  * for_each_sg_page - iterate over the pages of the given sg list
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b83c144..a1cf8ca 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -401,7 +401,6 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
 	piter->__pg_advance = 0;
 	piter->__nents = nents;
 
-	piter->page = NULL;
 	piter->sg = sglist;
 	piter->sg_pgoffset = pgoffset;
 }
@@ -426,7 +425,6 @@ bool __sg_page_iter_next(struct sg_page_iter *piter)
 		if (!--piter->__nents || !piter->sg)
 			return false;
 	}
-	piter->page = nth_page(sg_page(piter->sg), piter->sg_pgoffset);
 
 	return true;
 }
@@ -496,7 +494,7 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 		miter->__remaining = min_t(unsigned long, miter->__remaining,
 					   PAGE_SIZE - miter->__offset);
 	}
-	miter->page = miter->piter.page;
+	miter->page = sg_page_iter_page(&miter->piter);
 	miter->consumed = miter->length = miter->__remaining;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-- 
1.7.10.4

