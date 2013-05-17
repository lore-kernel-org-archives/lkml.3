Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3EQJDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:03:55 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39607 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3EQJDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:03:53 -0400
MIME-Version: 1.0
Date: Fri, 17 May 2013 17:03:52 +0800
Message-ID: <CAPgLHd_dXXj061Gv85eEO-XKBVJf7d0+1VSHQZaz73o+Ne_Txw@mail.gmail.com>
Subject: [PATCH v2] drm/exynos: fix error return code exynos_drm_load()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.
Change function exynos_plane_init() to return ERR_PTR(), so
the caller can use the error code from it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: change exynos_plane_init() to return ERR_PTR().
---
 drivers/gpu/drm/exynos/exynos_drm_plane.c | 4 ++--
 drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 4 ++--
 drivers/gpu/drm/exynos/exynos_drm_drv.c   | 4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.c b/drivers/gpu/drm/exynos/exynos_drm_plane.c
index 83efc66..2770f4b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_plane.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_plane.c
@@ -282,7 +282,7 @@ struct drm_plane *exynos_plane_init(struct drm_device *dev,
 	exynos_plane = kzalloc(sizeof(struct exynos_plane), GFP_KERNEL);
 	if (!exynos_plane) {
 		DRM_ERROR("failed to allocate plane\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	err = drm_plane_init(dev, &exynos_plane->base, possible_crtcs,
@@ -291,7 +291,7 @@ struct drm_plane *exynos_plane_init(struct drm_device *dev,
 	if (err) {
 		DRM_ERROR("failed to initialize plane\n");
 		kfree(exynos_plane);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	if (priv)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index e8894bc..21d0675 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -345,9 +345,9 @@ int exynos_drm_crtc_create(struct drm_device *dev, unsigned int nr)
 	exynos_crtc->pipe = nr;
 	exynos_crtc->dpms = DRM_MODE_DPMS_OFF;
 	exynos_crtc->plane = exynos_plane_init(dev, 1 << nr, true);
-	if (!exynos_crtc->plane) {
+	if (IS_ERR(exynos_crtc->plane)) {
 		kfree(exynos_crtc);
-		return -ENOMEM;
+		return PTR_ERR(exynos_crtc->plane);
 	}
 
 	crtc = &exynos_crtc->drm_crtc;

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index ba6d995..44f1d50 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -91,8 +91,10 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 		unsigned int possible_crtcs = (1 << MAX_CRTC) - 1;
 
 		plane = exynos_plane_init(dev, possible_crtcs, false);
-		if (!plane)
+		if (IS_ERR(plane) {
+			ret = PTR_ERR(plane);
 			goto err_release_iommu_mapping;
+		}
 	}
 
 	ret = drm_vblank_init(dev, MAX_CRTC);

