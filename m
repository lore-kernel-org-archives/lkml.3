Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaJGMCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:02:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27958 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaJGMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:01:30 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-bd-5433d61929c5
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR E...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] drm/exynos/dsi: remove global variable exynos_dsi_display
Date: Tue, 07 Oct 2014 14:01:08 +0200
Message-id: <1412683271-15835-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
References: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xK7qS14xDDB5+YLG4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaL3gVX2SzONr1ht7i8aw6bxYzz+5gs1h65y24xY/JLNgcuj/vdx5k8+ras
	YvT4vEkugDmKyyYlNSezLLVI3y6BK+Pegf9sBY+lKhbcmsPewNgn1sXIySEhYCLRdWEOI4Qt
	JnHh3nq2LkYuDiGBpYwSk5ecAksICfQxSXS0WoDYbAKaEn8332QDsUUElCVW7WtnB2lgFtjB
	LHH00lEmkISwgJ/Eza3rwGwWAVWJb/v3gg3iFXCW2Ph4BjPENjmJk8cms4LYnAIuEvM2vGKD
	WOYsMfn0VqYJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE2NcdjEuPWR1iFOBg
	VOLhXaFlHCLEmlhWXJl7iFGCg1lJhPf0RaAQb0piZVVqUX58UWlOavEhRiYOTqkGRvGXpdJx
	DZofZl9s8H5h/yvNes6N/DTRt680mCu/7JBoYVxfkvF61rz53It6jjf4GnIXnzz1cS373YpV
	y2XvLk6fnHnL426D5c1G6y+GR3paruY+e6GsaSk15UnzxcLvB8RVN790Cz37dvKptV92zPrz
	IKBBboqt3Ba22qen0jbz/bikLSCVeUaJpTgj0VCLuag4EQAmagS2DgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_dsi_display is used by internal Exynos DRM framework for
representing pair encoder->connecter. As it should be mapped 1:1 to dsi
private context it seems more reasonable to embed it directly
in that context. As a result further code simplification will be possible.
Moreover it will be possible to handle multiple DSI devices in the system.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 38 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index acf7e9e..84e3808 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -268,6 +268,7 @@ struct exynos_dsi_driver_data {
 };
 
 struct exynos_dsi {
+	struct exynos_drm_display display;
 	struct mipi_dsi_host dsi_host;
 	struct drm_connector connector;
 	struct drm_encoder *encoder;
@@ -1531,10 +1532,6 @@ static struct exynos_drm_display_ops exynos_dsi_display_ops = {
 	.dpms = exynos_dsi_dpms
 };
 
-static struct exynos_drm_display exynos_dsi_display = {
-	.type = EXYNOS_DISPLAY_TYPE_LCD,
-	.ops = &exynos_dsi_display_ops,
-};
 MODULE_DEVICE_TABLE(of, exynos_dsi_of_match);
 
 /* of_* functions will be removed after merge of of_graph patches */
@@ -1640,28 +1637,28 @@ end:
 static int exynos_dsi_bind(struct device *dev, struct device *master,
 				void *data)
 {
+	struct exynos_drm_display *display = dev_get_drvdata(dev);
+	struct exynos_dsi *dsi = display->ctx;
 	struct drm_device *drm_dev = data;
-	struct exynos_dsi *dsi;
 	int ret;
 
-	ret = exynos_drm_create_enc_conn(drm_dev, &exynos_dsi_display);
+	ret = exynos_drm_create_enc_conn(drm_dev, display);
 	if (ret) {
 		DRM_ERROR("Encoder create [%d] failed with %d\n",
-				exynos_dsi_display.type, ret);
+			  display->type, ret);
 		return ret;
 	}
 
-	dsi = exynos_dsi_display.ctx;
-
 	return mipi_dsi_host_register(&dsi->dsi_host);
 }
 
 static void exynos_dsi_unbind(struct device *dev, struct device *master,
 				void *data)
 {
-	struct exynos_dsi *dsi = exynos_dsi_display.ctx;
+	struct exynos_drm_display *display = dev_get_drvdata(dev);
+	struct exynos_dsi *dsi = display->ctx;
 
-	exynos_dsi_dpms(&exynos_dsi_display, DRM_MODE_DPMS_OFF);
+	exynos_dsi_dpms(display, DRM_MODE_DPMS_OFF);
 
 	mipi_dsi_host_unregister(&dsi->dsi_host);
 }
@@ -1673,22 +1670,23 @@ static const struct component_ops exynos_dsi_component_ops = {
 
 static int exynos_dsi_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct resource *res;
 	struct exynos_dsi *dsi;
 	int ret;
 
-	ret = exynos_drm_component_add(&pdev->dev, EXYNOS_DEVICE_TYPE_CONNECTOR,
-					exynos_dsi_display.type);
+	dsi = devm_kzalloc(dev, sizeof(*dsi), GFP_KERNEL);
+	if (!dsi)
+		return -ENOMEM;
+
+	dsi->display.type = EXYNOS_DISPLAY_TYPE_LCD;
+	dsi->display.ops = &exynos_dsi_display_ops;
+
+	ret = exynos_drm_component_add(dev, EXYNOS_DEVICE_TYPE_CONNECTOR,
+				       dsi->display.type);
 	if (ret)
 		return ret;
 
-	dsi = devm_kzalloc(&pdev->dev, sizeof(*dsi), GFP_KERNEL);
-	if (!dsi) {
-		dev_err(&pdev->dev, "failed to allocate dsi object.\n");
-		ret = -ENOMEM;
-		goto err_del_component;
-	}
-
 	/* To be checked as invalid one */
 	dsi->te_gpio = -ENOENT;
 
-- 
1.9.1

