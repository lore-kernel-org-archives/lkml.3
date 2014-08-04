Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaHDJ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:29:15 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12325 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaHDJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:29:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Aug 2014 02:20:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2] drm/ttm: expose CPU address of DMA-allocated pages
Date: Mon, 4 Aug 2014 18:28:54 +0900
Message-ID: <1407144534-2494-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages allocated using the DMA API have a coherent memory mapping. Make
this mapping visible to drivers so they can decide to use it instead of
creating their own redundant one.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: David Airlie <airlied@linux.ie>
---
Changes since v1:
- Perform only one allocation for pages, CPU and DMA addresses
- Added David's ack

 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |  2 ++
 drivers/gpu/drm/ttm/ttm_tt.c             | 13 ++++++++-----
 include/drm/ttm/ttm_bo_driver.h          |  2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index fb8259f69839..0301fac5badd 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -847,6 +847,7 @@ static int ttm_dma_pool_get_pages(struct dma_pool *pool,
 	if (count) {
 		d_page = list_first_entry(&pool->free_list, struct dma_page, page_list);
 		ttm->pages[index] = d_page->p;
+		ttm_dma->cpu_address[index] = d_page->vaddr;
 		ttm_dma->dma_address[index] = d_page->dma;
 		list_move_tail(&d_page->page_list, &ttm_dma->pages_list);
 		r = 0;
@@ -978,6 +979,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	for (i = 0; i < ttm->num_pages; i++) {
 		ttm->pages[i] = NULL;
+		ttm_dma->cpu_address[i] = 0;
 		ttm_dma->dma_address[i] = 0;
 	}
 
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 75f319090043..bf080abc86d1 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -55,9 +55,12 @@ static void ttm_tt_alloc_page_directory(struct ttm_tt *ttm)
 
 static void ttm_dma_tt_alloc_page_directory(struct ttm_dma_tt *ttm)
 {
-	ttm->ttm.pages = drm_calloc_large(ttm->ttm.num_pages, sizeof(void*));
-	ttm->dma_address = drm_calloc_large(ttm->ttm.num_pages,
-					    sizeof(*ttm->dma_address));
+	ttm->ttm.pages = drm_calloc_large(ttm->ttm.num_pages,
+					  sizeof(*ttm->ttm.pages) +
+					  sizeof(*ttm->dma_address) +
+					  sizeof(*ttm->cpu_address));
+	ttm->cpu_address = (void *) (ttm->ttm.pages + ttm->ttm.num_pages);
+	ttm->dma_address = (void *) (ttm->cpu_address + ttm->ttm.num_pages);
 }
 
 #ifdef CONFIG_X86
@@ -228,7 +231,7 @@ int ttm_dma_tt_init(struct ttm_dma_tt *ttm_dma, struct ttm_bo_device *bdev,
 
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	ttm_dma_tt_alloc_page_directory(ttm_dma);
-	if (!ttm->pages || !ttm_dma->dma_address) {
+	if (!ttm->pages) {
 		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
@@ -243,7 +246,7 @@ void ttm_dma_tt_fini(struct ttm_dma_tt *ttm_dma)
 
 	drm_free_large(ttm->pages);
 	ttm->pages = NULL;
-	drm_free_large(ttm_dma->dma_address);
+	ttm_dma->cpu_address = NULL;
 	ttm_dma->dma_address = NULL;
 }
 EXPORT_SYMBOL(ttm_dma_tt_fini);
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 202f0a7171e8..1d9f0f1ff52d 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -133,6 +133,7 @@ struct ttm_tt {
  * struct ttm_dma_tt
  *
  * @ttm: Base ttm_tt struct.
+ * @cpu_address: The CPU address of the pages
  * @dma_address: The DMA (bus) addresses of the pages
  * @pages_list: used by some page allocation backend
  *
@@ -142,6 +143,7 @@ struct ttm_tt {
  */
 struct ttm_dma_tt {
 	struct ttm_tt ttm;
+	void **cpu_address;
 	dma_addr_t *dma_address;
 	struct list_head pages_list;
 };
-- 
2.0.3

