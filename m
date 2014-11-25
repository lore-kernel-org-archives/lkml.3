Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaKYLuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:50:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58234 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaKYKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 054/254] drm/nouveau: ltc/gf100-: fix cbc issues on certain boards
Date: Tue, 25 Nov 2014 10:36:44 +0000
Message-Id: <1416912004-5928-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c   | 1 -
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c    | 1 +
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c | 2 ++
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c | 2 ++
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
index ca8139b9ab27..016ac9ae36a4 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
@@ -200,7 +200,6 @@ nvc0_bar_init(struct nouveau_object *object)
 
 	nv_mask(priv, 0x000200, 0x00000100, 0x00000000);
 	nv_mask(priv, 0x000200, 0x00000100, 0x00000100);
-	nv_mask(priv, 0x100c80, 0x00000001, 0x00000000);
 
 	nv_wr32(priv, 0x001704, 0x80000000 | priv->bar[1].mem->addr >> 12);
 	if (priv->bar[0].mem)
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
index 0670ae33ee45..0a6ca9fc337f 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
@@ -60,6 +60,7 @@ nvc0_fb_init(struct nouveau_object *object)
 
 	if (priv->r100c10_page)
 		nv_wr32(priv, 0x100c10, priv->r100c10 >> 8);
+	nv_mask(priv, 0x100c80, 0x00000001, 0x00000000); /* 128KiB lpg */
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c b/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c
index effe88888bf9..945464749e04 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c
@@ -200,6 +200,7 @@ gf100_ltcg_init(struct nouveau_object *object)
 {
 	struct nouveau_ltcg *ltcg = (struct nouveau_ltcg *)object;
 	struct gf100_ltcg_priv *priv = (struct gf100_ltcg_priv *)ltcg;
+	u32 lpg128 = !(nv_rd32(priv, 0x100c80) & 0x00000001);
 	int ret;
 
 	ret = nouveau_ltcg_init(ltcg);
@@ -211,6 +212,7 @@ gf100_ltcg_init(struct nouveau_object *object)
 	if (nv_device(ltcg)->card_type >= NV_E0)
 		nv_wr32(priv, 0x17e000, priv->ltc_nr);
 	nv_wr32(priv, 0x17e8d4, priv->tag_base);
+	nv_mask(priv, 0x17e8c0, 0x00000002, lpg128 ? 0x00000002 : 0x00000000);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c b/drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c
index e79d0e81de40..48ca7a460263 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c
@@ -119,6 +119,7 @@ gm107_ltcg_init(struct nouveau_object *object)
 {
 	struct nouveau_ltcg *ltcg = (struct nouveau_ltcg *)object;
 	struct gf100_ltcg_priv *priv = (struct gf100_ltcg_priv *)ltcg;
+	u32 lpg128 = !(nv_rd32(priv, 0x100c80) & 0x00000001);
 	int ret;
 
 	ret = nouveau_ltcg_init(ltcg);
@@ -127,6 +128,7 @@ gm107_ltcg_init(struct nouveau_object *object)
 
 	nv_wr32(priv, 0x17e27c, priv->ltc_nr);
 	nv_wr32(priv, 0x17e278, priv->tag_base);
+	nv_mask(priv, 0x17e264, 0x00000002, lpg128 ? 0x00000002 : 0x00000000);
 	return 0;
 }
 
-- 
2.1.0

