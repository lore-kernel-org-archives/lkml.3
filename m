Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaBKUAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:00:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaBKTHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.12 080/107] drm/nouveau: fix m2mf copy to tiled gart
Date: Tue, 11 Feb 2014 11:05:46 -0800
Message-Id: <20140211184750.479409712@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit ce8f7699f2b6ffe4aa8368b8d9d370875accaa5f upstream.

Commit de7b7d59d54852c introduced tiled GART, but a linear copy is
still performed. This may result in errors on eviction, fix it by
checking tiling from memtype.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_bo.c |   33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -802,25 +802,25 @@ nv50_bo_move_m2mf(struct nouveau_channel
 		  struct ttm_mem_reg *old_mem, struct ttm_mem_reg *new_mem)
 {
 	struct nouveau_mem *node = old_mem->mm_node;
-	struct nouveau_bo *nvbo = nouveau_bo(bo);
 	u64 length = (new_mem->num_pages << PAGE_SHIFT);
 	u64 src_offset = node->vma[0].offset;
 	u64 dst_offset = node->vma[1].offset;
+	int src_tiled = !!node->memtype;
+	int dst_tiled = !!((struct nouveau_mem *)new_mem->mm_node)->memtype;
 	int ret;
 
 	while (length) {
 		u32 amount, stride, height;
 
+		ret = RING_SPACE(chan, 18 + 6 * (src_tiled + dst_tiled));
+		if (ret)
+			return ret;
+
 		amount  = min(length, (u64)(4 * 1024 * 1024));
 		stride  = 16 * 4;
 		height  = amount / stride;
 
-		if (old_mem->mem_type == TTM_PL_VRAM &&
-		    nouveau_bo_tile_layout(nvbo)) {
-			ret = RING_SPACE(chan, 8);
-			if (ret)
-				return ret;
-
+		if (src_tiled) {
 			BEGIN_NV04(chan, NvSubCopy, 0x0200, 7);
 			OUT_RING  (chan, 0);
 			OUT_RING  (chan, 0);
@@ -830,19 +830,10 @@ nv50_bo_move_m2mf(struct nouveau_channel
 			OUT_RING  (chan, 0);
 			OUT_RING  (chan, 0);
 		} else {
-			ret = RING_SPACE(chan, 2);
-			if (ret)
-				return ret;
-
 			BEGIN_NV04(chan, NvSubCopy, 0x0200, 1);
 			OUT_RING  (chan, 1);
 		}
-		if (new_mem->mem_type == TTM_PL_VRAM &&
-		    nouveau_bo_tile_layout(nvbo)) {
-			ret = RING_SPACE(chan, 8);
-			if (ret)
-				return ret;
-
+		if (dst_tiled) {
 			BEGIN_NV04(chan, NvSubCopy, 0x021c, 7);
 			OUT_RING  (chan, 0);
 			OUT_RING  (chan, 0);
@@ -852,18 +843,10 @@ nv50_bo_move_m2mf(struct nouveau_channel
 			OUT_RING  (chan, 0);
 			OUT_RING  (chan, 0);
 		} else {
-			ret = RING_SPACE(chan, 2);
-			if (ret)
-				return ret;
-
 			BEGIN_NV04(chan, NvSubCopy, 0x021c, 1);
 			OUT_RING  (chan, 1);
 		}
 
-		ret = RING_SPACE(chan, 14);
-		if (ret)
-			return ret;
-
 		BEGIN_NV04(chan, NvSubCopy, 0x0238, 2);
 		OUT_RING  (chan, upper_32_bits(src_offset));
 		OUT_RING  (chan, upper_32_bits(dst_offset));


