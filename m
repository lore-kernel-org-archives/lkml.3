Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaESGvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:51:36 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19073 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaESGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:51:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 18 May 2014 23:46:42 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] drm/gk20a/fb: fix compile error whith CMA and module
Date: Mon, 19 May 2014 15:51:08 +0900
Message-ID: <1400482268-4971-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
References: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CMA functions are not available to kernel modules, but the GK20A FB
driver currently (and temporarily) relies on them.

This patch replaces the calls to CMA functions in problematic cases (CMA
enabled and Nouveau compiled as a module) with dummy stubs that will
make this particular driver fail, but at least won't produce a compile
error.

This is a temporary fix until a better memory allocation scheme is
devised.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 25 +++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
index 5904af52e6d6..fa867ce5449e 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
@@ -39,6 +39,27 @@ struct gk20a_mem {
 	struct list_head head;
 };
 
+/*
+ * CMA is not available to modules. Until we find a better solution, make
+ * memory allocations fail in that case.
+ */
+#if IS_ENABLED(CONFIG_CMA) && IS_MODULE(CONFIG_DRM_NOUVEAU)
+static inline struct page *
+alloc_contiguous_memory(struct device *dev, int count, unsigned int order)
+{
+	dev_err(dev, "cannot use CMA from a module - allocation failed\n");
+	return NULL;
+}
+
+static inline void
+release_contiguous_memory(struct device *dev, struct page *page, int count)
+{
+}
+#else
+#define alloc_contiguous_memory(d, c, o) dma_alloc_from_contiguous(d, c, o)
+#define release_contiguous_memory(d, p, c) dma_release_from_contiguous(d, p, c)
+#endif
+
 static void
 gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
 {
@@ -51,7 +72,7 @@ gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
 		return;
 
 	list_for_each_entry_safe(chunk, n, &mem->head, list) {
-		dma_release_from_contiguous(dev, chunk->pages, chunk->npages);
+		release_contiguous_memory(dev, chunk->pages, chunk->npages);
 		kfree(chunk);
 	}
 
@@ -128,7 +149,7 @@ gk20a_ram_get(struct nouveau_fb *pfb, u64 size, u32 align, u32 ncmin,
 			return -ENOMEM;
 		}
 
-		chunk->pages = dma_alloc_from_contiguous(dev, ncmin, order);
+		chunk->pages = alloc_contiguous_memory(dev, ncmin, order);
 		if (!chunk->pages) {
 			kfree(chunk);
 			gk20a_ram_put(pfb, pmem);
-- 
1.9.2

