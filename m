Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3JVVIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:62717 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3JVVIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,550,1378882800"; 
   d="scan'208";a="415395771"
Subject: [PATCH v2 04/13] dmaengine: reference counted unmap data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: linux@arm.linux.org.uk, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, dave.jiang@intel.com
Date: Tue, 22 Oct 2013 14:08:10 -0700
Message-ID: <20131022210809.31181.75168.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-5-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-5-git-send-email-b.zolnierkie@samsung.com>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hang a common 'unmap' object off of dma descriptors for the purpose of
providing a unified unmapping interface.  The lifetime of a mapping may
span multiple descriptors, so these unmap objects are reference counted
by related descriptor.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[bzolnier: fix IS_ENABLED() check]
[bzolnier: fix release ordering in dmaengine_destroy_unmap_pool()]
[bzolnier: fix check for success in dmaengine_init_unmap_pool()]
[bzolnier: use mempool_free() instead of kmem_cache_free()]
[bzolnier: add missing unmap->len initializations]
[bzolnier: add __init tag to dmaengine_init_unmap_pool()]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 drivers/dma/dmaengine.c   |  156 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/dmaengine.h |    3 +
 2 files changed, 150 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index bbc89df6bc56..e721a1caff7f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -65,6 +65,7 @@
 #include <linux/acpi.h>
 #include <linux/acpi_dma.h>
 #include <linux/of_dma.h>
+#include <linux/mempool.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
 static DEFINE_IDR(dma_idr);
@@ -901,6 +902,129 @@ void dma_async_device_unregister(struct dma_device *device)
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
+struct dmaengine_unmap_pool {
+	struct kmem_cache *cache;
+	const char *name;
+	mempool_t *pool;
+	size_t size;
+};
+
+#define __UNMAP_POOL(x) { .size = x, .name = "dmaengine-unmap-" __stringify(x) }
+static struct dmaengine_unmap_pool unmap_pool[] = {
+	__UNMAP_POOL(2),
+	#if IS_ENABLED(CONFIG_ASYNC_TX_DMA)
+	__UNMAP_POOL(16),
+	__UNMAP_POOL(128),
+	__UNMAP_POOL(256),
+	#endif
+};
+
+static struct dmaengine_unmap_pool *__get_unmap_pool(int nr)
+{
+	int order = get_count_order(nr);
+
+	switch (order) {
+	case 0 ... 1:
+		return &unmap_pool[0];
+	case 2 ... 4:
+		return &unmap_pool[1];
+	case 5 ... 7:
+		return &unmap_pool[2];
+	case 8:
+		return &unmap_pool[3];
+	default:
+		BUG();
+		return NULL;
+	}
+}
+
+static void dmaengine_unmap(struct kref *kref)
+{
+	struct dmaengine_unmap_data *unmap = container_of(kref, typeof(*unmap), kref);
+	struct device *dev = unmap->dev;
+	int cnt, i;
+
+	cnt = unmap->to_cnt;
+	for (i = 0; i < cnt; i++)
+		dma_unmap_page(dev, unmap->addr[i], unmap->len,
+			       DMA_TO_DEVICE);
+	cnt += unmap->from_cnt;
+	for (; i < cnt; i++)
+		dma_unmap_page(dev, unmap->addr[i], unmap->len,
+			       DMA_FROM_DEVICE);
+	cnt += unmap->bidi_cnt;
+	for (; i < cnt; i++)
+		dma_unmap_page(dev, unmap->addr[i], unmap->len,
+			       DMA_BIDIRECTIONAL);
+	mempool_free(unmap, __get_unmap_pool(cnt)->pool);
+}
+
+void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap)
+{
+	if (unmap)
+		kref_put(&unmap->kref, dmaengine_unmap);
+}
+EXPORT_SYMBOL_GPL(dmaengine_unmap_put);
+
+static void dmaengine_destroy_unmap_pool(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(unmap_pool); i++) {
+		struct dmaengine_unmap_pool *p = &unmap_pool[i];
+
+		if (p->pool)
+			mempool_destroy(p->pool);
+		p->pool = NULL;
+		if (p->cache)
+			kmem_cache_destroy(p->cache);
+		p->cache = NULL;
+	}
+}
+
+static int __init dmaengine_init_unmap_pool(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(unmap_pool); i++) {
+		struct dmaengine_unmap_pool *p = &unmap_pool[i];
+		size_t size;
+
+		size = sizeof(struct dmaengine_unmap_data) +
+		       sizeof(dma_addr_t) * p->size;
+
+		p->cache = kmem_cache_create(p->name, size, 0,
+					     SLAB_HWCACHE_ALIGN, NULL);
+		if (!p->cache)
+			break;
+		p->pool = mempool_create_slab_pool(1, p->cache);
+		if (!p->pool)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(unmap_pool))
+		return 0;
+
+	dmaengine_destroy_unmap_pool();
+	return -ENOMEM;
+}
+
+static struct dmaengine_unmap_data *
+dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
+{
+	struct dmaengine_unmap_data *unmap;
+
+	unmap = mempool_alloc(__get_unmap_pool(nr)->pool, flags);
+	if (!unmap)
+		return NULL;
+
+	memset(unmap, 0, sizeof(*unmap));
+	kref_init(&unmap->kref);
+	unmap->dev = dev;
+
+	return unmap;
+}
+
 /**
  * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
  * @chan: DMA channel to offload copy to
@@ -922,24 +1046,34 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 {
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
-	dma_addr_t dma_dest, dma_src;
+	struct dmaengine_unmap_data *unmap;
 	dma_cookie_t cookie;
 	unsigned long flags;
 
-	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
-	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
-				DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK;
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
+	unmap = dmaengine_get_unmap_data(dev->dev, 2, GFP_NOIO);
+	if (!unmap)
+		return -ENOMEM;
+
+	unmap->to_cnt = 1;
+	unmap->from_cnt = 1;
+	unmap->addr[0] = dma_map_page(dev->dev, src_pg, src_off, len,
+				      DMA_TO_DEVICE);
+	unmap->addr[1] = dma_map_page(dev->dev, dest_pg, dest_off, len,
+				      DMA_FROM_DEVICE);
+	unmap->len = len;
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
+		DMA_COMPL_SKIP_DEST_UNMAP;
+	tx = dev->device_prep_dma_memcpy(chan, unmap->addr[1], unmap->addr[0],
+					 len, flags);
 
 	if (!tx) {
-		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
-		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
+		dmaengine_unmap_put(unmap);
 		return -ENOMEM;
 	}
 
-	tx->callback = NULL;
+	dma_set_unmap(tx, unmap);
 	cookie = tx->tx_submit(tx);
+	dmaengine_unmap_put(unmap);
 
 	preempt_disable();
 	__this_cpu_add(chan->local->bytes_transferred, len);
@@ -1069,6 +1203,10 @@ EXPORT_SYMBOL_GPL(dma_run_dependencies);
 
 static int __init dma_bus_init(void)
 {
+	int err = dmaengine_init_unmap_pool();
+
+	if (err)
+		return err;
 	return class_register(&dma_devclass);
 }
 arch_initcall(dma_bus_init);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9070050fbcd8..2fe855a7cab1 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -464,9 +464,12 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 	tx->unmap = unmap;
 }
 
+void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
+
 static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)
 {
 	if (tx->unmap) {
+		dmaengine_unmap_put(tx->unmap);
 		tx->unmap = NULL;
 	}
 }

