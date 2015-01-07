Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbbAGJ1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:27:47 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40267 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbAGJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:27:45 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Mark Yao <mark.yao@rock-chips.com>
Cc: Pawel Osciak <posciak@chromium.org>, linux-rockchip@lists.infradead.org,
        Daniel Kurtz <djkurtz@chromium.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/rockchip: fix dma_alloc_attrs() error check
Date: Wed,  7 Jan 2015 17:27:06 +0800
Message-Id: <1420622830-8608-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_alloc_attrs() returns NULL if it cannot allocate a dma buffer (or
mapping), not a negative error code.

Rerported-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index bc98a22..7ca8799e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -34,12 +34,9 @@ static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj)
 	rk_obj->kvaddr = dma_alloc_attrs(drm->dev, obj->size,
 					 &rk_obj->dma_addr, GFP_KERNEL,
 					 &rk_obj->dma_attrs);
-	if (IS_ERR(rk_obj->kvaddr)) {
-		int ret = PTR_ERR(rk_obj->kvaddr);
-
-		DRM_ERROR("failed to allocate %#x byte dma buffer, %d",
-			  obj->size, ret);
-		return ret;
+	if (!rk_obj->kvaddr) {
+		DRM_ERROR("failed to allocate %#x byte dma buffer", obj->size);
+		return -ENOMEM;
 	}
 
 	return 0;
-- 
2.2.0.rc0.207.ga3a616c

