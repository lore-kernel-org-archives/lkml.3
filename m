Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3CKHk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:40:27 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49282 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3CKHk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:40:26 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@redhat.com, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] soc_camera: convert to devm_ioremap_resource()
Date: Mon, 11 Mar 2013 09:40:21 +0200
Message-Id: <1362987621-6527-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/media/platform/soc_camera/pxa_camera.c     |    6 +++---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    8 +++-----
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    8 +++-----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 395e2e0..e94ed6c 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1710,9 +1710,9 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	/*
 	 * Request the regions.
 	 */
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -ENOMEM;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 	pcdev->irq = irq;
 	pcdev->base = base;
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index bb08a46..8cdee71 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2110,11 +2110,9 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->max_width = pcdev->pdata->max_width ? : 2560;
 	pcdev->max_height = pcdev->pdata->max_height ? : 1920;
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base) {
-		dev_err(&pdev->dev, "Unable to ioremap CEU registers.\n");
-		return -ENXIO;
-	}
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	pcdev->irq = irq;
 	pcdev->base = base;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 42c559e..3ec7735 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -324,11 +324,9 @@ static int sh_csi2_probe(struct platform_device *pdev)
 
 	priv->irq = irq;
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv->base) {
-		dev_err(&pdev->dev, "Unable to ioremap CSI2 registers.\n");
-		return -ENXIO;
-	}
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
 
 	priv->pdev = pdev;
 	platform_set_drvdata(pdev, priv);
-- 
1.7.9.5

