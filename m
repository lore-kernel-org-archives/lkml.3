Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbaJIVJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbaJIVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 115/163] drm/nouveau: ltc/gf100-: fix cbc issues on certain boards
Date: Thu,  9 Oct 2014 14:02:20 -0700
Message-Id: <1412888588-26755-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit fe3d9c4b87bb98222a502cc585844a0b950786fb upstream.

A mismatch between FB and LTC's idea of how big a large page is causes
issues such as black "holes" in rendering to occur on some boards
(those where LTC is configured for 64KiB large pages) when compression
is used.

Confirmed to fix at least the GK107 MBP.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ kamal: backport to 3.13-stable: subdev/ltc/ not present in 3.13 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c | 1 -
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
index b2ec741..65c00d2 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
@@ -198,7 +198,6 @@ nvc0_bar_init(struct nouveau_object *object)
 
 	nv_mask(priv, 0x000200, 0x00000100, 0x00000000);
 	nv_mask(priv, 0x000200, 0x00000100, 0x00000100);
-	nv_mask(priv, 0x100c80, 0x00000001, 0x00000000);
 
 	nv_wr32(priv, 0x001704, 0x80000000 | priv->bar[1].mem->addr >> 12);
 	nv_wr32(priv, 0x001714, 0xc0000000 | priv->bar[0].mem->addr >> 12);
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
index e5fc37c..ebe1aa6 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
@@ -45,6 +45,7 @@ nvc0_fb_init(struct nouveau_object *object)
 
 	if (priv->r100c10_page)
 		nv_wr32(priv, 0x100c10, priv->r100c10 >> 8);
+	nv_mask(priv, 0x100c80, 0x00000001, 0x00000000); /* 128KiB lpg */
 	return 0;
 }
 
-- 
1.9.1

