Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3AUKNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:13:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3AUKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:02 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 09/33] drm: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:02 +0100
Message-Id: <1358762966-20791-10-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:Bi2QJVVDFWP4HAzMBK54sOKervQ4dTpXGDwx9KTfZrQ
 AN2kY1bSubvh+urFTWXeYsi/Nj9CnekiojS+WD1jKqMzLMdKEm
 FyRSaYLqJwUdVp9SagSNJKm4Oum8tszr4dN0DY+HT3xtVNVxt3
 uFOiHFNmYTZO8N5W649QWhSLl25/GRI3PVoWYj9jOtgJtr8m5D
 38nwtNDiiuIMyu2gclIIYHTKfYXKpxAJl066aQPhqxFGfUExlB
 2ladTCqnuPctXsIENyM7q1SYXSFVfkPTb7jLoSl+wt2iv7MPEq
 cRw/74uiLjO+lAm4ynmTTSLOzkSFdIXPWwSXkVNAFPC1cXUTQ8
 a+cEkcp1CUwdGBCfW6Kao1tYy+U2puI4EO7aMezVTxshstkhGZ
 hacdbG8s1T4Rx4iMMgYjF1dsgyZSCQ0b/6Zd7EzGyvI2RPq0YH
 W6auM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 8 +++-----
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    | 8 +++-----
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     | 7 +++----
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 8 +++-----
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 8 +++-----
 drivers/gpu/drm/exynos/exynos_hdmi.c        | 8 +++-----
 drivers/gpu/drm/tegra/dc.c                  | 8 +++-----
 drivers/gpu/drm/tegra/hdmi.c                | 6 +++---
 drivers/gpu/drm/tegra/host1x.c              | 6 +++---
 9 files changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 67a83e6..411f69b7 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1785,11 +1785,9 @@ static int fimc_probe(struct platform_device *pdev)
 
 	/* resource memory */
 	ctx->regs_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ctx->regs = devm_request_and_ioremap(dev, ctx->regs_res);
-	if (!ctx->regs) {
-		dev_err(dev, "failed to map registers.\n");
-		return -ENXIO;
-	}
+	ctx->regs = devm_ioremap_resource(dev, ctx->regs_res);
+	if (IS_ERR(ctx->regs))
+		return PTR_ERR(ctx->regs);
 
 	/* resource irq */
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..36493ce 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -913,11 +913,9 @@ static int fimd_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	ctx->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ctx->regs) {
-		dev_err(dev, "failed to map registers\n");
-		return -ENXIO;
-	}
+	ctx->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ctx->regs))
+		return PTR_ERR(ctx->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 36c3905..7329abd 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -1136,10 +1136,9 @@ static int g2d_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	g2d->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!g2d->regs) {
-		dev_err(dev, "failed to remap I/O memory\n");
-		ret = -ENXIO;
+	g2d->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(g2d->regs)) {
+		ret = PTR_ERR(g2d->regs);
 		goto err_put_clk;
 	}
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 8140753..7841c3b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1692,11 +1692,9 @@ static int gsc_probe(struct platform_device *pdev)
 
 	/* resource memory */
 	ctx->regs_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ctx->regs = devm_request_and_ioremap(dev, ctx->regs_res);
-	if (!ctx->regs) {
-		dev_err(dev, "failed to map registers.\n");
-		return -ENXIO;
-	}
+	ctx->regs = devm_ioremap_resource(dev, ctx->regs_res);
+	if (IS_ERR(ctx->regs))
+		return PTR_ERR(ctx->regs);
 
 	/* resource irq */
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_rotator.c b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
index e9e83ef..a6da774 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_rotator.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
@@ -656,11 +656,9 @@ static int rotator_probe(struct platform_device *pdev)
 				platform_get_device_id(pdev)->driver_data;
 
 	rot->regs_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	rot->regs = devm_request_and_ioremap(dev, rot->regs_res);
-	if (!rot->regs) {
-		dev_err(dev, "failed to map register\n");
-		return -ENXIO;
-	}
+	rot->regs = devm_ioremap_resource(dev, rot->regs_res);
+	if (IS_ERR(rot->regs))
+		return PTR_ERR(rot->regs);
 
 	rot->irq = platform_get_irq(pdev, 0);
 	if (rot->irq < 0) {
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 41ff79d..d4c3f3d 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2526,11 +2526,9 @@ static int hdmi_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	hdata->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hdata->regs) {
-		DRM_ERROR("failed to map registers\n");
-		return -ENXIO;
-	}
+	hdata->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hdata->regs))
+		return PTR_ERR(hdata->regs);
 
 	ret = devm_gpio_request(&pdev->dev, hdata->hpd_gpio, "HPD");
 	if (ret) {
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 656b2e3..d365c6d 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -764,11 +764,9 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	dc->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!dc->regs) {
-		dev_err(&pdev->dev, "failed to remap registers\n");
-		return -ENXIO;
-	}
+	dc->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(dc->regs))
+		return PTR_ERR(dc->regs);
 
 	dc->irq = platform_get_irq(pdev, 0);
 	if (dc->irq < 0) {
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index e060c7e..266af78 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1259,9 +1259,9 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	if (!regs)
 		return -ENXIO;
 
-	hdmi->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!hdmi->regs)
-		return -EADDRNOTAVAIL;
+	hdmi->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(hdmi->regs))
+		return PTR_ERR(hdmi->regs);
 
 	err = platform_get_irq(pdev, 0);
 	if (err < 0)
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
index 5d17b11..92e25a7 100644
--- a/drivers/gpu/drm/tegra/host1x.c
+++ b/drivers/gpu/drm/tegra/host1x.c
@@ -139,9 +139,9 @@ static int tegra_host1x_probe(struct platform_device *pdev)
 
 	host1x->irq = err;
 
-	host1x->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!host1x->regs) {
-		err = -EADDRNOTAVAIL;
+	host1x->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(host1x->regs)) {
+		err = PTR_ERR(host1x->regs);
 		goto err;
 	}
 
-- 
1.8.1.1

