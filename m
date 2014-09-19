Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaISM5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:57:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33861 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaISM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:57:33 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c2-541c283a3334
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
Subject: [PATCH] drm/exynos: init vblank with real number of crtcs
Date: Fri, 19 Sep 2014 14:57:20 +0200
Message-id: <1411131440-15395-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e/4NV0rDZkQg9+HFC1urTvHatF77iST
	xf9tE5ktHs1/zGxx5et7NotJ9yewWLy4d5HFonfBVTaLs01v2C0u75rDZjHj/D4mi7VH7rJb
	zJj8ks2B12PR9yyPvd8WsHhs//aA1eN+93Emj74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mp4
	9eMIW8E6gYq571vZGxjv8nYxcnJICJhITL79jhnCFpO4cG89WxcjF4eQwFJGiQO3/rNCOH1M
	Enuau9lAqtgENCX+br4JZosIKEus2tfODlLELPCWWeLH2ZssIAlhASeJi/3dQAkODhYBVYkj
	zfEgYV4BZ4kPMx5CbZOTOHlsMusERu4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJC
	7esOxqXHrA4xCnAwKvHweqRJhwixJpYVV+YeYpTgYFYS4eUTkwkR4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwDgp821fruwNI40uUZX6hx2L7Cx3FS3J52F20OA2LottnDjF3D8nd65FeYK8kf+5
	bVMfzVS9fi+W6Z9g6/66y/emSvvf2FjXukvQJKc+KD/udp+XwYqDgSHHSnoNP9uad94Jrvc/
	debU4bJ5p3xYo55on3VMX7jBJiIztc6w+pbT71uZNX8PKrEUZyQaajEXFScCADV9tGcTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialization of vblank with MAX_CRTC caused attempts
to disabling vblanks for non-existing crtcs in case
drm used fewer crtcs. The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 9b00e4e..dc4affd 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -94,10 +94,6 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 	/* init kms poll for handling hpd */
 	drm_kms_helper_poll_init(dev);
 
-	ret = drm_vblank_init(dev, MAX_CRTC);
-	if (ret)
-		goto err_mode_config_cleanup;
-
 	/* setup possible_clones. */
 	exynos_drm_encoder_setup(dev);
 
@@ -106,22 +102,26 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 	/* Try to bind all sub drivers. */
 	ret = component_bind_all(dev->dev, dev);
 	if (ret)
-		goto err_cleanup_vblank;
+		goto err_mode_config_cleanup;
+
+	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
+	if (ret)
+		goto err_unbind_all;
 
 	/* Probe non kms sub drivers and virtual display driver. */
 	ret = exynos_drm_device_subdrv_probe(dev);
 	if (ret)
-		goto err_unbind_all;
+		goto err_cleanup_vblank;
 
 	/* force connectors detection */
 	drm_helper_hpd_irq_event(dev);
 
 	return 0;
 
-err_unbind_all:
-	component_unbind_all(dev->dev, dev);
 err_cleanup_vblank:
 	drm_vblank_cleanup(dev);
+err_unbind_all:
+	component_unbind_all(dev->dev, dev);
 err_mode_config_cleanup:
 	drm_mode_config_cleanup(dev);
 	drm_release_iommu_mapping(dev);
@@ -138,8 +138,8 @@ static int exynos_drm_unload(struct drm_device *dev)
 	exynos_drm_fbdev_fini(dev);
 	drm_kms_helper_poll_fini(dev);
 
-	component_unbind_all(dev->dev, dev);
 	drm_vblank_cleanup(dev);
+	component_unbind_all(dev->dev, dev);
 	drm_mode_config_cleanup(dev);
 	drm_release_iommu_mapping(dev);
 
-- 
1.9.1

