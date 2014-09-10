Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaIJLxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:53:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23039 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJLxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:53:22 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b0-54103badcc7a
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR E...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/exynos: remove ifdeferry from initialization code
Date: Wed, 10 Sep 2014 13:53:00 +0200
Message-id: <1410349980-10473-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xa7prrQVCDJquW1jcWneO1aL33Ekm
	iytf37NZTLo/gcXixb2LLBa9C66yWZxtesNucXnXHDaLGef3MVnMmPySzYHLY/u3B6we97uP
	M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvrtW5gKbjpXzPlwj62B8YZlFyMnh4SAicSm
	3w/ZIWwxiQv31rN1MXJxCAksZZRYs3k3lNPHJNH+dz0zSBWbgKbE38032UBsEQFliVX72tlB
	ipgF1jBLzHvSwQiSEBZwk3i++wMTiM0ioCpxc84asGZeAWeJEzOvsEGsk5M4eWwy6wRG7gWM
	DKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoLnyw7GxcesDjEKcDAq8fAWXuQPEWJNLCuu
	zD3EKMHBrCTCm2YkECLEm5JYWZValB9fVJqTWnyIkYmDU6qBMb9Iz3yLxN51NbOWZefpzr3k
	dVRxtRt3tbBFmFhyCJ+h98qMJQ9X9HpX99cyGfDuDpmd9u5yuO67eN6GlVctmrYvKWKJOrT/
	89fYsA+Smtsve3LUs6RzSj/Z/c5aeSHD2reZjoYl1/q6bljrWx29k7+j8OlUyWU+z1ZHKE9O
	fme9r/mkfFCtEktxRqKhFnNRcSIArUglb/wBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces separate calls to driver (de)registration by
loops over the array of drivers. As a result it significantly
decreases number of ifdefs. Additionally it moves device registration
related ifdefs to header file.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi Inki,

During testing your component match support patch [1] I have prepared patch
removing most ifdefs from exynos_drm_drv.c. It is based on your patch, but
I can rebase it if necessary.

[1]: http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/37031

Regards
Andrzej
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 170 +++++++-------------------------
 drivers/gpu/drm/exynos/exynos_drm_drv.h |  25 +++--
 2 files changed, 48 insertions(+), 147 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index b2c710a..a660e46 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -553,74 +553,54 @@ static const struct component_master_ops exynos_drm_ops = {
 	.unbind		= exynos_drm_unbind,
 };
 
-static int exynos_drm_platform_probe(struct platform_device *pdev)
-{
-	struct component_match *match;
-	int ret;
-
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
-
+static struct platform_driver * const exynos_drm_drivers[] = {
 #ifdef CONFIG_DRM_EXYNOS_FIMD
-	ret = platform_driver_register(&fimd_driver);
-	if (ret < 0)
-		return ret;
+	&fimd_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_DP
-	ret = platform_driver_register(&dp_driver);
-	if (ret < 0)
-		goto err_unregister_fimd_drv;
+	&dp_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_DSI
-	ret = platform_driver_register(&dsi_driver);
-	if (ret < 0)
-		goto err_unregister_dp_drv;
+	&dsi_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_HDMI
-	ret = platform_driver_register(&mixer_driver);
-	if (ret < 0)
-		goto err_unregister_dsi_drv;
-	ret = platform_driver_register(&hdmi_driver);
-	if (ret < 0)
-		goto err_unregister_mixer_drv;
+	&mixer_driver,
+	&hdmi_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_G2D
-	ret = platform_driver_register(&g2d_driver);
-	if (ret < 0)
-		goto err_unregister_hdmi_drv;
+	&g2d_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_FIMC
-	ret = platform_driver_register(&fimc_driver);
-	if (ret < 0)
-		goto err_unregister_g2d_drv;
+	&fimc_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_ROTATOR
-	ret = platform_driver_register(&rotator_driver);
-	if (ret < 0)
-		goto err_unregister_fimc_drv;
+	&rotator_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_GSC
-	ret = platform_driver_register(&gsc_driver);
-	if (ret < 0)
-		goto err_unregister_rotator_drv;
+	&gsc_driver,
 #endif
-
 #ifdef CONFIG_DRM_EXYNOS_IPP
-	ret = platform_driver_register(&ipp_driver);
-	if (ret < 0)
-		goto err_unregister_gsc_drv;
+	&ipp_driver,
+#endif
+};
+
+static int exynos_drm_platform_probe(struct platform_device *pdev)
+{
+	struct component_match *match;
+	int ret, i;
+
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
+
+	for (i = 0; i < ARRAY_SIZE(exynos_drm_drivers); ++i) {
+		ret = platform_driver_register(exynos_drm_drivers[i]);
+		if (ret < 0)
+			goto err_unregister_drivers;
+	}
 
 	ret = exynos_platform_device_ipp_register();
 	if (ret < 0)
-		goto err_unregister_ipp_drv;
-#endif
+		goto err_unregister_drivers;
 
 	match = exynos_drm_match_add(&pdev->dev);
 	if (IS_ERR(match)) {
@@ -632,96 +612,24 @@ static int exynos_drm_platform_probe(struct platform_device *pdev)
 						match);
 
 err_unregister_ipp_dev:
-
-#ifdef CONFIG_DRM_EXYNOS_IPP
 	exynos_platform_device_ipp_unregister();
-err_unregister_ipp_drv:
-	platform_driver_unregister(&ipp_driver);
-err_unregister_gsc_drv:
-#endif
 
-#ifdef CONFIG_DRM_EXYNOS_GSC
-	platform_driver_unregister(&gsc_driver);
-err_unregister_rotator_drv:
-#endif
+err_unregister_drivers:
+	while (--i >= 0)
+		platform_driver_unregister(exynos_drm_drivers[i]);
 
-#ifdef CONFIG_DRM_EXYNOS_ROTATOR
-	platform_driver_unregister(&rotator_driver);
-err_unregister_fimc_drv:
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_FIMC
-	platform_driver_unregister(&fimc_driver);
-err_unregister_g2d_drv:
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_G2D
-	platform_driver_unregister(&g2d_driver);
-err_unregister_hdmi_drv:
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_HDMI
-	platform_driver_unregister(&hdmi_driver);
-err_unregister_mixer_drv:
-	platform_driver_unregister(&mixer_driver);
-err_unregister_dsi_drv:
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_DSI
-	platform_driver_unregister(&dsi_driver);
-err_unregister_dp_drv:
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_DP
-	platform_driver_unregister(&dp_driver);
-err_unregister_fimd_drv:
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_FIMD
-	platform_driver_unregister(&fimd_driver);
-#endif
 	return ret;
 }
 
 static int exynos_drm_platform_remove(struct platform_device *pdev)
 {
-#ifdef CONFIG_DRM_EXYNOS_IPP
-	exynos_platform_device_ipp_unregister();
-	platform_driver_unregister(&ipp_driver);
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_GSC
-	platform_driver_unregister(&gsc_driver);
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_ROTATOR
-	platform_driver_unregister(&rotator_driver);
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_FIMC
-	platform_driver_unregister(&fimc_driver);
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_G2D
-	platform_driver_unregister(&g2d_driver);
-#endif
-
-#ifdef CONFIG_DRM_EXYNOS_HDMI
-	platform_driver_unregister(&mixer_driver);
-	platform_driver_unregister(&hdmi_driver);
-#endif
+	int i;
 
-#ifdef CONFIG_DRM_EXYNOS_FIMD
-	platform_driver_unregister(&fimd_driver);
-#endif
+	exynos_platform_device_ipp_unregister();
 
-#ifdef CONFIG_DRM_EXYNOS_DSI
-	platform_driver_unregister(&dsi_driver);
-#endif
+	for (i = ARRAY_SIZE(exynos_drm_drivers) - 1; i >= 0; --i)
+		platform_driver_unregister(exynos_drm_drivers[i]);
 
-#ifdef CONFIG_DRM_EXYNOS_DP
-	platform_driver_unregister(&dp_driver);
-#endif
 	component_master_del(&pdev->dev, &exynos_drm_ops);
 	return 0;
 }
@@ -745,11 +653,9 @@ static int exynos_drm_init(void)
 	if (IS_ERR(exynos_drm_pdev))
 		return PTR_ERR(exynos_drm_pdev);
 
-#ifdef CONFIG_DRM_EXYNOS_VIDI
 	ret = exynos_drm_probe_vidi();
 	if (ret < 0)
 		goto err_unregister_pd;
-#endif
 
 	ret = platform_driver_register(&exynos_drm_platform_driver);
 	if (ret)
@@ -758,11 +664,9 @@ static int exynos_drm_init(void)
 	return 0;
 
 err_remove_vidi:
-#ifdef CONFIG_DRM_EXYNOS_VIDI
 	exynos_drm_remove_vidi();
 
 err_unregister_pd:
-#endif
 	platform_device_unregister(exynos_drm_pdev);
 
 	return ret;
@@ -771,9 +675,9 @@ err_unregister_pd:
 static void exynos_drm_exit(void)
 {
 	platform_driver_unregister(&exynos_drm_platform_driver);
-#ifdef CONFIG_DRM_EXYNOS_VIDI
+
 	exynos_drm_remove_vidi();
-#endif
+
 	platform_device_unregister(exynos_drm_pdev);
 }
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
index 69a6fa3..76d5d02 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
@@ -324,15 +324,14 @@ int exynos_platform_device_hdmi_register(void);
  */
 void exynos_platform_device_hdmi_unregister(void);
 
-/*
- * this function registers exynos drm ipp platform device.
- */
+#ifdef CONFIG_DRM_EXYNOS_IPP
 int exynos_platform_device_ipp_register(void);
-
-/*
- * this function unregisters exynos drm ipp platform device if it exists.
- */
 void exynos_platform_device_ipp_unregister(void);
+#else
+static inline int exynos_platform_device_ipp_register(void) { return 0; }
+static inline void exynos_platform_device_ipp_unregister(void) {}
+#endif
+
 
 #ifdef CONFIG_DRM_EXYNOS_DPI
 struct exynos_drm_display * exynos_dpi_probe(struct device *dev);
@@ -343,15 +342,13 @@ exynos_dpi_probe(struct device *dev) { return NULL; }
 static inline int exynos_dpi_remove(struct device *dev) { return 0; }
 #endif
 
-/*
- * this function registers exynos drm vidi platform device/driver.
- */
+#ifdef CONFIG_DRM_EXYNOS_VIDI
 int exynos_drm_probe_vidi(void);
-
-/*
- * this function unregister exynos drm vidi platform device/driver.
- */
 void exynos_drm_remove_vidi(void);
+#else
+static inline int exynos_drm_probe_vidi(void) { return 0; }
+static inline void exynos_drm_remove_vidi(void) {}
+#endif
 
 /* This function creates a encoder and a connector, and initializes them. */
 int exynos_drm_create_enc_conn(struct drm_device *dev,
-- 
1.9.1

