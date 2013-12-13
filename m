Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3LMWmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:42:50 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62421 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3LMW1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 036/115] gpu: ion: Add ion_page_pool.
Date: Fri, 13 Dec 2013 14:24:10 -0800
Message-Id: <1386973529-4884-37-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This patch adds a new utility heaps can use to manage
memory.  In the past we have found it can be very
expensive to manage the caches when allocating memory,
but it is imposible to know whether a previous user of a
given memory allocation had a cached mapping. This patch
adds the ability to store a pool of pages that were
previously used uncached so that cache maintenance
only need be done when growing this pool.  The pool also
contains a shrinker so memory from the pool can be
recovered in low memory conditions.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Makefile        |   3 +-
 drivers/staging/android/ion/ion_page_pool.c | 163 ++++++++++++++++++++++++++++
 drivers/staging/android/ion/ion_priv.h      |  44 ++++++++
 3 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/android/ion/ion_page_pool.c

diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index 73fe3fa..d1ddebb 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -1,2 +1,3 @@
-obj-$(CONFIG_ION) +=	ion.o ion_heap.o ion_system_heap.o ion_carveout_heap.o
+obj-$(CONFIG_ION) +=	ion.o ion_heap.o ion_page_pool.o ion_system_heap.o \
+			ion_carveout_heap.o
 obj-$(CONFIG_ION_TEGRA) += tegra/
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
new file mode 100644
index 0000000..78f39f7
--- /dev/null
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -0,0 +1,163 @@
+/*
+ * drivers/staging/android/ion/ion_mem_pool.c
+ *
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/shrinker.h>
+#include "ion_priv.h"
+
+struct ion_page_pool_item {
+	struct page *page;
+	struct list_head list;
+};
+
+static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
+{
+	struct page *page = alloc_pages(pool->gfp_mask, pool->order);
+
+	if (!page)
+		return NULL;
+	/* this is only being used to flush the page for dma,
+	   this api is not really suitable for calling from a driver
+	   but no better way to flush a page for dma exist at this time */
+	__dma_page_cpu_to_dev(page, 0, PAGE_SIZE << pool->order,
+			      DMA_BIDIRECTIONAL);
+	return page;
+}
+
+static void ion_page_pool_free_pages(struct ion_page_pool *pool,
+				     struct page *page)
+{
+	__free_pages(page, pool->order);
+}
+
+static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
+{
+	struct ion_page_pool_item *item;
+
+	item = kmalloc(sizeof(struct ion_page_pool_item), GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+	item->page = page;
+	list_add_tail(&item->list, &pool->items);
+	pool->count++;
+	return 0;
+}
+
+static struct page *ion_page_pool_remove(struct ion_page_pool *pool)
+{
+	struct ion_page_pool_item *item;
+	struct page *page;
+
+	BUG_ON(!pool->count);
+	BUG_ON(list_empty(&pool->items));
+
+	item = list_first_entry(&pool->items, struct ion_page_pool_item, list);
+	list_del(&item->list);
+	page = item->page;
+	kfree(item);
+	pool->count--;
+	return page;
+}
+
+void *ion_page_pool_alloc(struct ion_page_pool *pool)
+{
+	struct page *page = NULL;
+
+	BUG_ON(!pool);
+
+	mutex_lock(&pool->mutex);
+	if (pool->count)
+		page = ion_page_pool_remove(pool);
+	else
+		page = ion_page_pool_alloc_pages(pool);
+	mutex_unlock(&pool->mutex);
+
+	return page;
+}
+
+void ion_page_pool_free(struct ion_page_pool *pool, struct page* page)
+{
+	int ret;
+
+	mutex_lock(&pool->mutex);
+	ret = ion_page_pool_add(pool, page);
+	if (ret)
+		ion_page_pool_free_pages(pool, page);
+	mutex_unlock(&pool->mutex);
+}
+
+static int ion_page_pool_shrink(struct shrinker *shrinker,
+				 struct shrink_control *sc)
+{
+	struct ion_page_pool *pool = container_of(shrinker,
+						 struct ion_page_pool,
+						 shrinker);
+	int nr_freed = 0;
+	int i;
+
+	if (sc->nr_to_scan == 0)
+		return pool->count * (1 << pool->order);
+
+	mutex_lock(&pool->mutex);
+	for (i = 0; i < sc->nr_to_scan && pool->count; i++) {
+		struct ion_page_pool_item *item;
+		struct page *page;
+
+		item = list_first_entry(&pool->items, struct ion_page_pool_item, list);
+		page = item->page;
+		if (PageHighMem(page) && !(sc->gfp_mask & __GFP_HIGHMEM)) {
+			list_move_tail(&item->list, &pool->items);
+			continue;
+		}
+		BUG_ON(page != ion_page_pool_remove(pool));
+		ion_page_pool_free_pages(pool, page);
+		nr_freed += (1 << pool->order);
+	}
+	pr_info("%s: shrunk page_pool of order %d by %d pages\n", __func__,
+		pool->order, nr_freed);
+	mutex_unlock(&pool->mutex);
+
+	return pool->count * (1 << pool->order);
+}
+
+struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
+{
+	struct ion_page_pool *pool = kmalloc(sizeof(struct ion_page_pool),
+					     GFP_KERNEL);
+	if (!pool)
+		return NULL;
+	pool->count = 0;
+	INIT_LIST_HEAD(&pool->items);
+	pool->shrinker.shrink = ion_page_pool_shrink;
+	pool->shrinker.seeks = DEFAULT_SEEKS * 16;
+	pool->shrinker.batch = 0;
+	register_shrinker(&pool->shrinker);
+	pool->gfp_mask = gfp_mask;
+	pool->order = order;
+	mutex_init(&pool->mutex);
+
+	return pool;
+}
+
+void ion_page_pool_destroy(struct ion_page_pool *pool)
+{
+	unregister_shrinker(&pool->shrinker);
+	kfree(pool);
+}
+
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 1027ef4..0707733 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -22,6 +22,8 @@
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
+#include <linux/shrinker.h>
+#include <linux/types.h>
 
 #include "ion.h"
 
@@ -195,4 +197,46 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
  */
 #define ION_CARVEOUT_ALLOCATE_FAIL -1
 
+/**
+ * functions for creating and destroying a heap pool -- allows you
+ * to keep a pool of pre allocated memory to use from your heap.  Keeping
+ * a pool of memory that is ready for dma, ie any cached mapping have been
+ * invalidated from the cache, provides a significant peformance benefit on
+ * many systems */
+
+/**
+ * struct ion_page_pool - pagepool struct
+ * @count:		number of items in the pool
+ * @items:		list of items
+ * @shrinker:		a shrinker for the items
+ * @mutex:		lock protecting this struct and especially the count
+ *			item list
+ * @alloc:		function to be used to allocate pageory when the pool
+ *			is empty
+ * @free:		function to be used to free pageory back to the system
+ *			when the shrinker fires
+ * @gfp_mask:		gfp_mask to use from alloc
+ * @order:		order of pages in the pool
+ *
+ * Allows you to keep a pool of pre allocated pages to use from your heap.
+ * Keeping a pool of pages that is ready for dma, ie any cached mapping have
+ * been invalidated from the cache, provides a significant peformance benefit
+ * on many systems
+ */
+struct ion_page_pool {
+	int count;
+	struct list_head items;
+	struct shrinker shrinker;
+	struct mutex mutex;
+	void *(*alloc)(struct ion_page_pool *pool);
+	void (*free)(struct ion_page_pool *pool, struct page *page);
+	gfp_t gfp_mask;
+	unsigned int order;
+};
+
+struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order);
+void ion_page_pool_destroy(struct ion_page_pool *);
+void *ion_page_pool_alloc(struct ion_page_pool *);
+void ion_page_pool_free(struct ion_page_pool *, struct page *);
+
 #endif /* _ION_PRIV_H */
-- 
1.8.3.2

