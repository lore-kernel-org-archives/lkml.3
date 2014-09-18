Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaIRNRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:17:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51703 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaIRNRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:17:33 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-24-541adb6a178e
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR E...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list), drake@endlessm.com,
        daniel@ffwll.ch, m.szyprowski@samsung.com
Subject: [PATCH] drm/exynos: switch to universal plane API
Date: Thu, 18 Sep 2014 15:17:03 +0200
Message-id: <1411046223-22703-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t/xa7rZt6VCDMItbq07x2rRe+4kk8X/
	bROZLR7Nf8xsceXrezaLSfcnsFi8uHeRxaJ3wVU2i7NNb9gtLu+aw2Yx4/w+Jou1R+6yW8yY
	/JLNgddj0fcsj73fFrB4bP/2gNXjfvdxJo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKaOxb
	xVxwz73ibPND9gbGmdZdjJwcEgImElc/r2WDsMUkLtxbD2RzcQgJLGWU2Hv1FSOE08ckseXu
	UmaQKjYBTYm/m2+CdYgIKEus2tfODlLELPCWWeLH2ZssIAlhASuJB+engzWwCKhKHH77jx3E
	5hVwlmh8vowZYp2cxMljk1knMHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESaF92
	MC4+ZnWIUYCDUYmHV0JAKkSINbGsuDL3EKMEB7OSCC/fRaAQb0piZVVqUX58UWlOavEhRiYO
	TqkGxtzMW0fsjwv+XnDf9Gz800s+N0XKVATav+S6ZGZ/zFuf8aG1ZvmeNY/WnDmXtzfpcgjz
	LCeHFY2WepULSq6uU990YZWI6Y2todebVvKv1CuyydyhvMPi9Wdd5Tb3zACXXRoG23hfBDRN
	/79xcoup2/wd8/NVTGy/v6nm5szvMN59U8F9T9z+DiWW4oxEQy3mouJEAET5CSESAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces legacy functions
drm_plane_init() / drm_crtc_init() with
drm_universal_plane_init() and drm_crtc_init_with_planes().
It allows to replace fake primary plane with the real one.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi Inki,

I have tested this patch with trats board, it looks OK.
As a side effect it should solve fb refcounting issues
reported by me and Daniel Drake.

Regards
Andrzej
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 63 ++++++++++++++++---------------
 drivers/gpu/drm/exynos/exynos_drm_drv.c   |  5 ++-
 drivers/gpu/drm/exynos/exynos_drm_plane.c | 17 +++++----
 drivers/gpu/drm/exynos/exynos_drm_plane.h |  3 +-
 4 files changed, 47 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index b68e58f..d2f713e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -32,7 +32,6 @@ enum exynos_crtc_mode {
  * Exynos specific crtc structure.
  *
  * @drm_crtc: crtc object.
- * @drm_plane: pointer of private plane object for this crtc
  * @manager: the manager associated with this crtc
  * @pipe: a crtc index created at load() with a new crtc object creation
  *	and the crtc object would be set to private->crtc array
@@ -46,7 +45,6 @@ enum exynos_crtc_mode {
  */
 struct exynos_drm_crtc {
 	struct drm_crtc			drm_crtc;
-	struct drm_plane		*plane;
 	struct exynos_drm_manager	*manager;
 	unsigned int			pipe;
 	unsigned int			dpms;
@@ -94,12 +92,12 @@ static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
 
 	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
 
-	exynos_plane_commit(exynos_crtc->plane);
+	exynos_plane_commit(crtc->primary);
 
 	if (manager->ops->commit)
 		manager->ops->commit(manager);
 
-	exynos_plane_dpms(exynos_crtc->plane, DRM_MODE_DPMS_ON);
+	exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_ON);
 }
 
 static bool
@@ -123,10 +121,9 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
 {
 	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
 	struct exynos_drm_manager *manager = exynos_crtc->manager;
-	struct drm_plane *plane = exynos_crtc->plane;
+	struct drm_framebuffer *fb = crtc->primary->fb;
 	unsigned int crtc_w;
 	unsigned int crtc_h;
-	int ret;
 
 	/*
 	 * copy the mode data adjusted by mode_fixup() into crtc->mode
@@ -134,29 +131,21 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	 */
 	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
 
-	crtc_w = crtc->primary->fb->width - x;
-	crtc_h = crtc->primary->fb->height - y;
+	crtc_w = fb->width - x;
+	crtc_h = fb->height - y;
 
 	if (manager->ops->mode_set)
 		manager->ops->mode_set(manager, &crtc->mode);
 
-	ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
-				    x, y, crtc_w, crtc_h);
-	if (ret)
-		return ret;
-
-	plane->crtc = crtc;
-	plane->fb = crtc->primary->fb;
-	drm_framebuffer_reference(plane->fb);
-
-	return 0;
+	return exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
+				     crtc_w, crtc_h, x, y, crtc_w, crtc_h);
 }
 
 static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
 					  struct drm_framebuffer *old_fb)
 {
 	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
-	struct drm_plane *plane = exynos_crtc->plane;
+	struct drm_framebuffer *fb = crtc->primary->fb;
 	unsigned int crtc_w;
 	unsigned int crtc_h;
 	int ret;
@@ -167,11 +156,11 @@ static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
 		return -EPERM;
 	}
 
-	crtc_w = crtc->primary->fb->width - x;
-	crtc_h = crtc->primary->fb->height - y;
+	crtc_w = fb->width - x;
+	crtc_h = fb->height - y;
 
-	ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
-				    x, y, crtc_w, crtc_h);
+	ret = exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
+				    crtc_w, crtc_h, x, y, crtc_w, crtc_h);
 	if (ret)
 		return ret;
 
@@ -279,6 +268,7 @@ static void exynos_drm_crtc_destroy(struct drm_crtc *crtc)
 
 	private->crtc[exynos_crtc->pipe] = NULL;
 
+	crtc->primary->funcs->destroy(crtc->primary);
 	drm_crtc_cleanup(crtc);
 	kfree(exynos_crtc);
 }
@@ -304,8 +294,7 @@ static int exynos_drm_crtc_set_property(struct drm_crtc *crtc,
 			exynos_drm_crtc_commit(crtc);
 			break;
 		case CRTC_MODE_BLANK:
-			exynos_plane_dpms(exynos_crtc->plane,
-					  DRM_MODE_DPMS_OFF);
+			exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_OFF);
 			break;
 		default:
 			break;
@@ -351,8 +340,10 @@ static void exynos_drm_crtc_attach_mode_property(struct drm_crtc *crtc)
 int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
 {
 	struct exynos_drm_crtc *exynos_crtc;
+	struct drm_plane *plane;
 	struct exynos_drm_private *private = manager->drm_dev->dev_private;
 	struct drm_crtc *crtc;
+	int ret;
 
 	exynos_crtc = kzalloc(sizeof(*exynos_crtc), GFP_KERNEL);
 	if (!exynos_crtc)
@@ -364,11 +355,11 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
 	exynos_crtc->dpms = DRM_MODE_DPMS_OFF;
 	exynos_crtc->manager = manager;
 	exynos_crtc->pipe = manager->pipe;
-	exynos_crtc->plane = exynos_plane_init(manager->drm_dev,
-				1 << manager->pipe, true);
-	if (!exynos_crtc->plane) {
-		kfree(exynos_crtc);
-		return -ENOMEM;
+	plane = exynos_plane_init(manager->drm_dev, 1 << manager->pipe,
+				  DRM_PLANE_TYPE_PRIMARY);
+	if (IS_ERR(plane)) {
+		ret = PTR_ERR(plane);
+		goto err_plane;
 	}
 
 	manager->crtc = &exynos_crtc->drm_crtc;
@@ -376,12 +367,22 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
 
 	private->crtc[manager->pipe] = crtc;
 
-	drm_crtc_init(manager->drm_dev, crtc, &exynos_crtc_funcs);
+	ret = drm_crtc_init_with_planes(manager->drm_dev, crtc, plane, NULL,
+					&exynos_crtc_funcs);
+	if (ret < 0)
+		goto err_crtc;
+
 	drm_crtc_helper_add(crtc, &exynos_crtc_helper_funcs);
 
 	exynos_drm_crtc_attach_mode_property(crtc);
 
 	return 0;
+
+err_crtc:
+	plane->funcs->destroy(plane);
+err_plane:
+	kfree(exynos_crtc);
+	return ret;
 }
 
 int exynos_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 9b00e4e..a439452 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -86,8 +86,9 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 		struct drm_plane *plane;
 		unsigned long possible_crtcs = (1 << MAX_CRTC) - 1;
 
-		plane = exynos_plane_init(dev, possible_crtcs, false);
-		if (!plane)
+		plane = exynos_plane_init(dev, possible_crtcs,
+					  DRM_PLANE_TYPE_OVERLAY);
+		if (IS_ERR(plane))
 			goto err_mode_config_cleanup;
 	}
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.c b/drivers/gpu/drm/exynos/exynos_drm_plane.c
index 8371cbd..15e37a0 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_plane.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_plane.c
@@ -139,6 +139,8 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
 			overlay->crtc_x, overlay->crtc_y,
 			overlay->crtc_width, overlay->crtc_height);
 
+	plane->crtc = crtc;
+
 	exynos_drm_crtc_plane_mode_set(crtc, overlay);
 
 	return 0;
@@ -254,25 +256,26 @@ static void exynos_plane_attach_zpos_property(struct drm_plane *plane)
 }
 
 struct drm_plane *exynos_plane_init(struct drm_device *dev,
-				    unsigned long possible_crtcs, bool priv)
+				    unsigned long possible_crtcs,
+				    enum drm_plane_type type)
 {
 	struct exynos_plane *exynos_plane;
 	int err;
 
 	exynos_plane = kzalloc(sizeof(struct exynos_plane), GFP_KERNEL);
 	if (!exynos_plane)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
-	err = drm_plane_init(dev, &exynos_plane->base, possible_crtcs,
-			      &exynos_plane_funcs, formats, ARRAY_SIZE(formats),
-			      priv);
+	err = drm_universal_plane_init(dev, &exynos_plane->base, possible_crtcs,
+				       &exynos_plane_funcs, formats,
+				       ARRAY_SIZE(formats), type);
 	if (err) {
 		DRM_ERROR("failed to initialize plane\n");
 		kfree(exynos_plane);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
-	if (priv)
+	if (type == DRM_PLANE_TYPE_PRIMARY)
 		exynos_plane->overlay.zpos = DEFAULT_ZPOS;
 	else
 		exynos_plane_attach_zpos_property(&exynos_plane->base);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.h b/drivers/gpu/drm/exynos/exynos_drm_plane.h
index 84d464c..0d1986b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_plane.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_plane.h
@@ -17,4 +17,5 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
 void exynos_plane_commit(struct drm_plane *plane);
 void exynos_plane_dpms(struct drm_plane *plane, int mode);
 struct drm_plane *exynos_plane_init(struct drm_device *dev,
-				    unsigned long possible_crtcs, bool priv);
+				    unsigned long possible_crtcs,
+				    enum drm_plane_type type);
-- 
1.9.1

