Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3GMIvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:51:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36969 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab3GMIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:51:03 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/5] media: davinci: vpbe_venc: convert to devm_* api
Date: Sat, 13 Jul 2013 14:20:27 +0530
Message-Id: <1373705431-11500-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Replace existing resource handling in the driver with managed
device resource, this ensures more consistent error values and
simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_venc.c |   97 ++++++----------------------
 1 file changed, 19 insertions(+), 78 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index 87eef9b..14a023a 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -639,105 +639,46 @@ static int venc_probe(struct platform_device *pdev)
 	const struct platform_device_id *pdev_id;
 	struct venc_state *venc;
 	struct resource *res;
-	int ret;
 
-	venc = kzalloc(sizeof(struct venc_state), GFP_KERNEL);
+	if (!pdev->dev.platform_data) {
+		dev_err(&pdev->dev, "No platform data for VENC sub device");
+		return -EINVAL;
+	}
+
+	pdev_id = platform_get_device_id(pdev);
+	if (!pdev_id)
+		return -EINVAL;
+
+	venc = devm_kzalloc(&pdev->dev, sizeof(struct venc_state), GFP_KERNEL);
 	if (venc == NULL)
 		return -ENOMEM;
 
-	pdev_id = platform_get_device_id(pdev);
-	if (!pdev_id) {
-		ret = -EINVAL;
-		goto free_mem;
-	}
 	venc->venc_type = pdev_id->driver_data;
 	venc->pdev = &pdev->dev;
 	venc->pdata = pdev->dev.platform_data;
-	if (NULL == venc->pdata) {
-		dev_err(venc->pdev, "Unable to get platform data for"
-			" VENC sub device");
-		ret = -ENOENT;
-		goto free_mem;
-	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(venc->pdev,
-			"Unable to get VENC register address map\n");
-		ret = -ENODEV;
-		goto free_mem;
-	}
 
-	if (!request_mem_region(res->start, resource_size(res), "venc")) {
-		dev_err(venc->pdev, "Unable to reserve VENC MMIO region\n");
-		ret = -ENODEV;
-		goto free_mem;
-	}
-
-	venc->venc_base = ioremap_nocache(res->start, resource_size(res));
-	if (!venc->venc_base) {
-		dev_err(venc->pdev, "Unable to map VENC IO space\n");
-		ret = -ENODEV;
-		goto release_venc_mem_region;
-	}
+	venc->venc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(venc->venc_base))
+		return PTR_ERR(venc->venc_base);
 
 	if (venc->venc_type != VPBE_VERSION_1) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (!res) {
-			dev_err(venc->pdev,
-				"Unable to get VDAC_CONFIG address map\n");
-			ret = -ENODEV;
-			goto unmap_venc_io;
-		}
-
-		if (!request_mem_region(res->start,
-					resource_size(res), "venc")) {
-			dev_err(venc->pdev,
-				"Unable to reserve VDAC_CONFIG  MMIO region\n");
-			ret = -ENODEV;
-			goto unmap_venc_io;
-		}
-
-		venc->vdaccfg_reg = ioremap_nocache(res->start,
-						    resource_size(res));
-		if (!venc->vdaccfg_reg) {
-			dev_err(venc->pdev,
-				"Unable to map VDAC_CONFIG IO space\n");
-			ret = -ENODEV;
-			goto release_vdaccfg_mem_region;
-		}
+
+		venc->vdaccfg_reg = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(venc->vdaccfg_reg))
+			return PTR_ERR(venc->vdaccfg_reg);
 	}
 	spin_lock_init(&venc->lock);
 	platform_set_drvdata(pdev, venc);
 	dev_notice(venc->pdev, "VENC sub device probe success\n");
-	return 0;
 
-release_vdaccfg_mem_region:
-	release_mem_region(res->start, resource_size(res));
-unmap_venc_io:
-	iounmap(venc->venc_base);
-release_venc_mem_region:
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-free_mem:
-	kfree(venc);
-	return ret;
+	return 0;
 }
 
 static int venc_remove(struct platform_device *pdev)
 {
-	struct venc_state *venc = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	iounmap((void *)venc->venc_base);
-	release_mem_region(res->start, resource_size(res));
-	if (venc->venc_type != VPBE_VERSION_1) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		iounmap((void *)venc->vdaccfg_reg);
-		release_mem_region(res->start, resource_size(res));
-	}
-	kfree(venc);
-
 	return 0;
 }
 
-- 
1.7.9.5

