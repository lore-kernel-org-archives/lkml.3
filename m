Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3GMIv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:51:27 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42177 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab3GMIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:51:25 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/5] media: davinci: vpbe_osd: convert to devm_* api
Date: Sat, 13 Jul 2013 14:20:28 +0530
Message-Id: <1373705431-11500-3-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpbe_osd.c |   45 +++++++----------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 6ed82e8..d053c26 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -1547,61 +1547,36 @@ static int osd_probe(struct platform_device *pdev)
 	const struct platform_device_id *pdev_id;
 	struct osd_state *osd;
 	struct resource *res;
-	int ret = 0;
 
-	osd = kzalloc(sizeof(struct osd_state), GFP_KERNEL);
+	pdev_id = platform_get_device_id(pdev);
+	if (!pdev_id)
+		return -EINVAL;
+
+	osd = devm_kzalloc(&pdev->dev, sizeof(struct osd_state), GFP_KERNEL);
 	if (osd == NULL)
 		return -ENOMEM;
 
-	pdev_id = platform_get_device_id(pdev);
-	if (!pdev_id) {
-		ret = -EINVAL;
-		goto free_mem;
-	}
 
 	osd->dev = &pdev->dev;
 	osd->vpbe_type = pdev_id->driver_data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(osd->dev, "Unable to get OSD register address map\n");
-		ret = -ENODEV;
-		goto free_mem;
-	}
+	osd->osd_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(osd->osd_base))
+		return PTR_ERR(osd->osd_base);
+
 	osd->osd_base_phys = res->start;
 	osd->osd_size = resource_size(res);
-	if (!request_mem_region(osd->osd_base_phys, osd->osd_size,
-				MODULE_NAME)) {
-		dev_err(osd->dev, "Unable to reserve OSD MMIO region\n");
-		ret = -ENODEV;
-		goto free_mem;
-	}
-	osd->osd_base = ioremap_nocache(res->start, osd->osd_size);
-	if (!osd->osd_base) {
-		dev_err(osd->dev, "Unable to map the OSD region\n");
-		ret = -ENODEV;
-		goto release_mem_region;
-	}
 	spin_lock_init(&osd->lock);
 	osd->ops = osd_ops;
 	platform_set_drvdata(pdev, osd);
 	dev_notice(osd->dev, "OSD sub device probe success\n");
-	return ret;
 
-release_mem_region:
-	release_mem_region(osd->osd_base_phys, osd->osd_size);
-free_mem:
-	kfree(osd);
-	return ret;
+	return 0;
 }
 
 static int osd_remove(struct platform_device *pdev)
 {
-	struct osd_state *osd = platform_get_drvdata(pdev);
-
-	iounmap((void *)osd->osd_base);
-	release_mem_region(osd->osd_base_phys, osd->osd_size);
-	kfree(osd);
 	return 0;
 }
 
-- 
1.7.9.5

