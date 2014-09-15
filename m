Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaIOWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027AbaIOWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 149/187] drm/ttm: Pass GFP flags in order to avoid deadlock.
Date: Mon, 15 Sep 2014 15:09:19 -0700
Message-Id: <1410818997-9432-150-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit a91576d7916f6cce76d30303e60e1ac47cf4a76d upstream.

Commit 7dc19d5a "drivers: convert shrinkers to new count/scan API" added
deadlock warnings that ttm_page_pool_free() and ttm_dma_page_pool_free()
are currently doing GFP_KERNEL allocation.

But these functions did not get updated to receive gfp_t argument.
This patch explicitly passes sc->gfp_mask or GFP_KERNEL to these functions,
and removes the deadlock warning.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c     | 19 ++++++++++---------
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 19 +++++++++----------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index deba59b..cf4bad2 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -297,8 +297,10 @@ static void ttm_pool_update_free_locked(struct ttm_page_pool *pool,
  *
  * @pool: to free the pages from
  * @free_all: If set to true will free all pages in pool
+ * @gfp: GFP flags.
  **/
-static int ttm_page_pool_free(struct ttm_page_pool *pool, unsigned nr_free)
+static int ttm_page_pool_free(struct ttm_page_pool *pool, unsigned nr_free,
+			      gfp_t gfp)
 {
 	unsigned long irq_flags;
 	struct page *p;
@@ -309,8 +311,7 @@ static int ttm_page_pool_free(struct ttm_page_pool *pool, unsigned nr_free)
 	if (NUM_PAGES_TO_ALLOC < nr_free)
 		npages_to_free = NUM_PAGES_TO_ALLOC;
 
-	pages_to_free = kmalloc(npages_to_free * sizeof(struct page *),
-			GFP_KERNEL);
+	pages_to_free = kmalloc(npages_to_free * sizeof(struct page *), gfp);
 	if (!pages_to_free) {
 		pr_err("Failed to allocate memory for pool free operation\n");
 		return 0;
@@ -382,9 +383,7 @@ out:
  *
  * XXX: (dchinner) Deadlock warning!
  *
- * ttm_page_pool_free() does memory allocation using GFP_KERNEL.  that means
- * this can deadlock when called a sc->gfp_mask that is not equal to
- * GFP_KERNEL.
+ * We need to pass sc->gfp_mask to ttm_page_pool_free().
  *
  * This code is crying out for a shrinker per pool....
  */
@@ -408,7 +407,8 @@ ttm_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		if (shrink_pages == 0)
 			break;
 		pool = &_manager->pools[(i + pool_offset)%NUM_POOLS];
-		shrink_pages = ttm_page_pool_free(pool, nr_free);
+		shrink_pages = ttm_page_pool_free(pool, nr_free,
+						  sc->gfp_mask);
 		freed += nr_free - shrink_pages;
 	}
 	mutex_unlock(&lock);
@@ -710,7 +710,7 @@ static void ttm_put_pages(struct page **pages, unsigned npages, int flags,
 	}
 	spin_unlock_irqrestore(&pool->lock, irq_flags);
 	if (npages)
-		ttm_page_pool_free(pool, npages);
+		ttm_page_pool_free(pool, npages, GFP_KERNEL);
 }
 
 /*
@@ -850,7 +850,8 @@ void ttm_page_alloc_fini(void)
 	ttm_pool_mm_shrink_fini(_manager);
 
 	for (i = 0; i < NUM_POOLS; ++i)
-		ttm_page_pool_free(&_manager->pools[i], FREE_ALL_PAGES);
+		ttm_page_pool_free(&_manager->pools[i], FREE_ALL_PAGES,
+				   GFP_KERNEL);
 
 	kobject_put(&_manager->kobj);
 	_manager = NULL;
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 524cc1a..ca65df1 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -411,8 +411,10 @@ static void ttm_dma_page_put(struct dma_pool *pool, struct dma_page *d_page)
  *
  * @pool: to free the pages from
  * @nr_free: If set to true will free all pages in pool
+ * @gfp: GFP flags.
  **/
-static unsigned ttm_dma_page_pool_free(struct dma_pool *pool, unsigned nr_free)
+static unsigned ttm_dma_page_pool_free(struct dma_pool *pool, unsigned nr_free,
+				       gfp_t gfp)
 {
 	unsigned long irq_flags;
 	struct dma_page *dma_p, *tmp;
@@ -430,8 +432,7 @@ static unsigned ttm_dma_page_pool_free(struct dma_pool *pool, unsigned nr_free)
 			 npages_to_free, nr_free);
 	}
 #endif
-	pages_to_free = kmalloc(npages_to_free * sizeof(struct page *),
-			GFP_KERNEL);
+	pages_to_free = kmalloc(npages_to_free * sizeof(struct page *), gfp);
 
 	if (!pages_to_free) {
 		pr_err("%s: Failed to allocate memory for pool free operation\n",
@@ -530,7 +531,7 @@ static void ttm_dma_free_pool(struct device *dev, enum pool_type type)
 		if (pool->type != type)
 			continue;
 		/* Takes a spinlock.. */
-		ttm_dma_page_pool_free(pool, FREE_ALL_PAGES);
+		ttm_dma_page_pool_free(pool, FREE_ALL_PAGES, GFP_KERNEL);
 		WARN_ON(((pool->npages_in_use + pool->npages_free) != 0));
 		/* This code path is called after _all_ references to the
 		 * struct device has been dropped - so nobody should be
@@ -983,7 +984,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 
 	/* shrink pool if necessary (only on !is_cached pools)*/
 	if (npages)
-		ttm_dma_page_pool_free(pool, npages);
+		ttm_dma_page_pool_free(pool, npages, GFP_KERNEL);
 	ttm->state = tt_unpopulated;
 }
 EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
@@ -993,10 +994,7 @@ EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
  *
  * XXX: (dchinner) Deadlock warning!
  *
- * ttm_dma_page_pool_free() does GFP_KERNEL memory allocation, and so attention
- * needs to be paid to sc->gfp_mask to determine if this can be done or not.
- * GFP_KERNEL memory allocation in a GFP_ATOMIC reclaim context woul dbe really
- * bad.
+ * We need to pass sc->gfp_mask to ttm_dma_page_pool_free().
  *
  * I'm getting sadder as I hear more pathetical whimpers about needing per-pool
  * shrinkers
@@ -1030,7 +1028,8 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		if (++idx < pool_offset)
 			continue;
 		nr_free = shrink_pages;
-		shrink_pages = ttm_dma_page_pool_free(p->pool, nr_free);
+		shrink_pages = ttm_dma_page_pool_free(p->pool, nr_free,
+						      sc->gfp_mask);
 		freed += nr_free - shrink_pages;
 
 		pr_debug("%s: (%s:%d) Asked to shrink %d, have %d more to go\n",
-- 
1.9.1

