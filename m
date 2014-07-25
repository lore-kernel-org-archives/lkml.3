Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272AbaGYRhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:37:53 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35310 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934960AbaGYRhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:37:51 -0400
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv2 1/2] gpu: drm: omapdrm: Use %pad format for values of the dma_addr_t type
Date: Fri, 25 Jul 2014 21:37:36 +0400
Message-Id: <1406309857-11141-1-git-send-email-matwey.kornilov@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

The format change is to fix the following compilation issue:

../drivers/gpu/drm/omapdrm/omap_plane.c: In function 'omap_plane_pre_apply':
../drivers/gpu/drm/omapdrm/omap_plane.c:145:2: error: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Werror=format=]
  DBG("%d,%d %08x %08x", info->pos_x, info->pos_y,
  ^
../drivers/gpu/drm/omapdrm/omap_plane.c:145:2: error: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Werror=format=]
cc1: all warnings being treated as errors
../scripts/Makefile.build:273: recipe for target 'drivers/gpu/drm/omapdrm/omap_plane.o' failed

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/gpu/drm/omapdrm/omap_gem.c   | 10 +++++-----
 drivers/gpu/drm/omapdrm/omap_plane.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 95dbce2..d9f5e524 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -791,7 +791,7 @@ int omap_gem_get_paddr(struct drm_gem_object *obj,
 			omap_obj->paddr = tiler_ssptr(block);
 			omap_obj->block = block;
 
-			DBG("got paddr: %08x", omap_obj->paddr);
+			DBG("got paddr: %pad", &omap_obj->paddr);
 		}
 
 		omap_obj->paddr_cnt++;
@@ -985,9 +985,9 @@ void omap_gem_describe(struct drm_gem_object *obj, struct seq_file *m)
 
 	off = drm_vma_node_start(&obj->vma_node);
 
-	seq_printf(m, "%08x: %2d (%2d) %08llx %08Zx (%2d) %p %4d",
+	seq_printf(m, "%08x: %2d (%2d) %08llx %pad (%2d) %p %4d",
 			omap_obj->flags, obj->name, obj->refcount.refcount.counter,
-			off, omap_obj->paddr, omap_obj->paddr_cnt,
+			off, &omap_obj->paddr, omap_obj->paddr_cnt,
 			omap_obj->vaddr, omap_obj->roll);
 
 	if (omap_obj->flags & OMAP_BO_TILED) {
@@ -1467,8 +1467,8 @@ void omap_gem_init(struct drm_device *dev)
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
index 3cf31ee..6af3398 100644
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
1.8.1.4

