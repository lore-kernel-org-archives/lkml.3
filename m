Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaIJNnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:43:51 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60058 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaIJNnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:43:49 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] [media] coda: Improve runtime PM support
Date: Wed, 10 Sep 2014 15:43:33 +0200
Message-Id: <1410356613-16811-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For several reasons it's good practice to leave devices in runtime PM
active state while those have been probed.

In this cases we also want to prevent the device from going inactive,
until the firmware has been completely installed, especially when using
a PM domain.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/coda/coda-common.c | 42 ++++++++-----------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0997b5c..361f28d 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1703,39 +1703,16 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
 	release_firmware(fw);
 
-	if (pm_runtime_enabled(&pdev->dev) && pdev->dev.pm_domain) {
-		/*
-		 * Enabling power temporarily will cause coda_hw_init to be
-		 * called via coda_runtime_resume by the pm domain.
-		 */
-		ret = pm_runtime_get_sync(&dev->plat_dev->dev);
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "failed to power on: %d\n",
-				 ret);
-			return;
-		}
-
-		ret = coda_check_firmware(dev);
-		if (ret < 0)
-			return;
-
-		pm_runtime_put_sync(&dev->plat_dev->dev);
-	} else {
-		/*
-		 * If runtime pm is disabled or pm_domain is not set,
-		 * initialize once manually.
-		 */
-		ret = coda_hw_init(dev);
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
-			return;
-		}
-
-		ret = coda_check_firmware(dev);
-		if (ret < 0)
-			return;
+	ret = coda_hw_init(dev);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
+		return;
 	}
 
+	ret = coda_check_firmware(dev);
+	if (ret < 0)
+		return;
+
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
@@ -1771,6 +1748,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video[%d-%d]\n",
 		  dev->vfd[0].num, dev->vfd[1].num);
 
+	pm_runtime_put_sync(&pdev->dev);
 	return;
 
 rel_m2m:
@@ -1998,6 +1976,8 @@ static int coda_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
+	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	return coda_firmware_request(dev);
-- 
1.9.1

