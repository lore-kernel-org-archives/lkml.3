Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab3APQDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3APQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 100/222] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Wed, 16 Jan 2013 13:55:00 -0200
Message-Id: <1358351822-7675-101-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 387870f2d6d679746020fa8e25ef786ff338dc98 upstream.

dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
regardless the flags provided by the caller. This causes excessive
pruning of emergency memory pools without any good reason. Additionaly,
on ARM architecture any driver which is using dmapools will sooner or
later  trigger the following error:
"ERROR: 256 KiB atomic DMA coherent pool is too small!
Please increase it with coherent_pool= kernel parameter!".
Increasing the coherent pool size usually doesn't help much and only
delays such error, because all GFP_ATOMIC DMA allocations are always
served from the special, very limited memory pool.

This patch changes the dmapool code to correctly use gfp flags provided
by the dmapool caller.

Reported-by: Soeren Moch <smoch@web.de>
Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Soeren Moch <smoch@web.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/dmapool.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..da1b0f0 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -50,7 +50,6 @@ struct dma_pool {		/* the pool */
 	size_t allocation;
 	size_t boundary;
 	char name[32];
-	wait_queue_head_t waitq;
 	struct list_head pools;
 };
 
@@ -62,8 +61,6 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
 	unsigned int offset;
 };
 
-#define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
-
 static DEFINE_MUTEX(pools_lock);
 
 static ssize_t
@@ -172,7 +169,6 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	retval->size = size;
 	retval->boundary = boundary;
 	retval->allocation = allocation;
-	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
 		int ret;
@@ -227,7 +223,6 @@ static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
-		list_add(&page->page_list, &pool->page_list);
 		page->in_use = 0;
 		page->offset = 0;
 	} else {
@@ -315,30 +310,21 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	might_sleep_if(mem_flags & __GFP_WAIT);
 
 	spin_lock_irqsave(&pool->lock, flags);
- restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (page->offset < pool->allocation)
 			goto ready;
 	}
-	page = pool_alloc_page(pool, GFP_ATOMIC);
-	if (!page) {
-		if (mem_flags & __GFP_WAIT) {
-			DECLARE_WAITQUEUE(wait, current);
 
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			__add_wait_queue(&pool->waitq, &wait);
-			spin_unlock_irqrestore(&pool->lock, flags);
+	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
+	spin_unlock_irqrestore(&pool->lock, flags);
 
-			schedule_timeout(POOL_TIMEOUT_JIFFIES);
+	page = pool_alloc_page(pool, mem_flags);
+	if (!page)
+		return NULL;
 
-			spin_lock_irqsave(&pool->lock, flags);
-			__remove_wait_queue(&pool->waitq, &wait);
-			goto restart;
-		}
-		retval = NULL;
-		goto done;
-	}
+	spin_lock_irqsave(&pool->lock, flags);
 
+	list_add(&page->page_list, &pool->page_list);
  ready:
 	page->in_use++;
 	offset = page->offset;
@@ -348,7 +334,6 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 #ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
- done:
 	spin_unlock_irqrestore(&pool->lock, flags);
 	return retval;
 }
@@ -435,8 +420,6 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 	page->in_use--;
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
-	if (waitqueue_active(&pool->waitq))
-		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
-- 
1.7.9.5

