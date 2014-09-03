Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaICKOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:14:03 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57306 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756071AbaICJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:53 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 29/56] drm: omapdrm: fix compiler errors
Date: Wed,  3 Sep 2014 11:26:48 +0200
Message-Id: <8d46ae9b0ae92fde0d5b19406b43707a9562ff9c.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2d31ca3ad7d5d44c8adc7f253c96ce33f3a2e931 upstream.

Regular randconfig nightly testing has detected problems with omapdrm.

omapdrm fails to build when the kernel is built to support 64-bit DMA
addresses and/or 64-bit physical addresses due to an assumption about
the width of these types.

Use %pad to print DMA addresses, rather than %x or %Zx (which is even
more wrong than %x).  Avoid passing a uint32_t pointer into a function
which expects dma_addr_t pointer.

drivers/gpu/drm/omapdrm/omap_plane.c: In function 'omap_plane_pre_apply':
drivers/gpu/drm/omapdrm/omap_plane.c:145:2: error: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Werror=format]
drivers/gpu/drm/omapdrm/omap_plane.c:145:2: error: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Werror=format]
make[5]: *** [drivers/gpu/drm/omapdrm/omap_plane.o] Error 1
drivers/gpu/drm/omapdrm/omap_gem.c: In function 'omap_gem_get_paddr':
drivers/gpu/drm/omapdrm/omap_gem.c:794:4: error: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Werror=format]
drivers/gpu/drm/omapdrm/omap_gem.c: In function 'omap_gem_describe':
drivers/gpu/drm/omapdrm/omap_gem.c:991:4: error: format '%Zx' expects argument of type 'size_t', but argument 7 has type 'dma_addr_t' [-Werror=format]
drivers/gpu/drm/omapdrm/omap_gem.c: In function 'omap_gem_init':
drivers/gpu/drm/omapdrm/omap_gem.c:1470:4: error: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Werror=format]
make[5]: *** [drivers/gpu/drm/omapdrm/omap_gem.o] Error 1
drivers/gpu/drm/omapdrm/omap_dmm_tiler.c: In function 'dmm_txn_append':
drivers/gpu/drm/omapdrm/omap_dmm_tiler.c:226:2: error: passing argument 3 of 'alloc_dma' from incompatible pointer type [-Werror]
make[5]: *** [drivers/gpu/drm/omapdrm/omap_dmm_tiler.o] Error 1
make[5]: Target `__build' not remade because of errors.
make[4]: *** [drivers/gpu/drm/omapdrm] Error 2

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c |  6 ++++--
 drivers/gpu/drm/omapdrm/omap_gem.c       | 10 +++++-----
 drivers/gpu/drm/omapdrm/omap_plane.c     |  4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
index acf667859cb6..9501728bf479 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -199,7 +199,7 @@ static struct dmm_txn *dmm_txn_init(struct dmm *dmm, struct tcm *tcm)
 static void dmm_txn_append(struct dmm_txn *txn, struct pat_area *area,
 		struct page **pages, uint32_t npages, uint32_t roll)
 {
-	dma_addr_t pat_pa = 0;
+	dma_addr_t pat_pa = 0, data_pa = 0;
 	uint32_t *data;
 	struct pat *pat;
 	struct refill_engine *engine = txn->engine_handle;
@@ -223,7 +223,9 @@ static void dmm_txn_append(struct dmm_txn *txn, struct pat_area *area,
 			.lut_id = engine->tcm->lut_id,
 		};
 
-	data = alloc_dma(txn, 4*i, &pat->data_pa);
+	data = alloc_dma(txn, 4*i, &data_pa);
+	/* FIXME: what if data_pa is more than 32-bit ? */
+	pat->data_pa = data_pa;
 
 	while (i--) {
 		int n = i + roll;
diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 533f6ebec531..6b01276a7fe8 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -791,7 +791,7 @@ int omap_gem_get_paddr(struct drm_gem_object *obj,
 			omap_obj->paddr = tiler_ssptr(block);
 			omap_obj->block = block;
 
-			DBG("got paddr: %08x", omap_obj->paddr);
+			DBG("got paddr: %pad", &omap_obj->paddr);
 		}
 
 		omap_obj->paddr_cnt++;
@@ -988,9 +988,9 @@ void omap_gem_describe(struct drm_gem_object *obj, struct seq_file *m)
 
 	off = drm_vma_node_start(&obj->vma_node);
 
-	seq_printf(m, "%08x: %2d (%2d) %08llx %08Zx (%2d) %p %4d",
+	seq_printf(m, "%08x: %2d (%2d) %08llx %pad (%2d) %p %4d",
 			omap_obj->flags, obj->name, obj->refcount.refcount.counter,
-			off, omap_obj->paddr, omap_obj->paddr_cnt,
+			off, &omap_obj->paddr, omap_obj->paddr_cnt,
 			omap_obj->vaddr, omap_obj->roll);
 
 	if (omap_obj->flags & OMAP_BO_TILED) {
@@ -1473,8 +1473,8 @@ void omap_gem_init(struct drm_device *dev)
 			entry->paddr = tiler_ssptr(block);
 			entry->block = block;
 
-			DBG("%d:%d: %dx%d: paddr=%08x stride=%d", i, j, w, h,
-					entry->paddr,
+			DBG("%d:%d: %dx%d: paddr=%pad stride=%d", i, j, w, h,
+					&entry->paddr,
 					usergart[i].stride_pfn << PAGE_SHIFT);
 		}
 	}
diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 046d5e660c04..5b62e212cbe5 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -142,8 +142,8 @@ static void omap_plane_pre_apply(struct omap_drm_apply *apply)
 	DBG("%dx%d -> %dx%d (%d)", info->width, info->height,
 			info->out_width, info->out_height,
 			info->screen_width);
-	DBG("%d,%d %08x %08x", info->pos_x, info->pos_y,
-			info->paddr, info->p_uv_addr);
+	DBG("%d,%d %pad %pad", info->pos_x, info->pos_y,
+			&info->paddr, &info->p_uv_addr);
 
 	/* TODO: */
 	ilace = false;
-- 
2.1.0

