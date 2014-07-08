Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaGHIb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:31:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16131 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaGHI0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jul 2014 01:19:39 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 1/6] drm/ttm: expose CPU address of DMA-allocated pages
Date: Tue, 8 Jul 2014 17:25:56 +0900
Message-ID: <1404807961-30530-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
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
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 2 ++
 drivers/gpu/drm/ttm/ttm_tt.c             | 6 +++++-
 include/drm/ttm/ttm_bo_driver.h          | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

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
index 75f319090043..341594ede596 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -58,6 +58,8 @@ static void ttm_dma_tt_alloc_page_directory(struct ttm_dma_tt *ttm)
 	ttm->ttm.pages = drm_calloc_large(ttm->ttm.num_pages, sizeof(void*));
 	ttm->dma_address = drm_calloc_large(ttm->ttm.num_pages,
 					    sizeof(*ttm->dma_address));
+	ttm->cpu_address = drm_calloc_large(ttm->ttm.num_pages,
+					    sizeof(*ttm->cpu_address));
 }
 
 #ifdef CONFIG_X86
@@ -228,7 +230,7 @@ int ttm_dma_tt_init(struct ttm_dma_tt *ttm_dma, struct ttm_bo_device *bdev,
 
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	ttm_dma_tt_alloc_page_directory(ttm_dma);
-	if (!ttm->pages || !ttm_dma->dma_address) {
+	if (!ttm->pages || !ttm_dma->dma_address || !ttm_dma->cpu_address) {
 		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
@@ -243,6 +245,8 @@ void ttm_dma_tt_fini(struct ttm_dma_tt *ttm_dma)
 
 	drm_free_large(ttm->pages);
 	ttm->pages = NULL;
+	drm_free_large(ttm_dma->cpu_address);
+	ttm_dma->cpu_address = NULL;
 	drm_free_large(ttm_dma->dma_address);
 	ttm_dma->dma_address = NULL;
 }
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index a5183da3ef92..7d30f0666d24 100644
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
2.0.0

