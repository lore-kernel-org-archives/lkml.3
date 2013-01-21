Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3AUKOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:14:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3AUKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:59 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 14/33] media: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:07 +0100
Message-Id: <1358762966-20791-15-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:kJ0LUlKLmBbKuGZFaoF1tpny1wCmgzPS9G59wMuMmow
 Qk+5D0/rV9aAAzjrPE1u7a6VjNBdy9dWCorTFvPa4N6rIz2wTx
 N/SvRxbCZPbgL4B3UvaRi/NOFRftKeSHDT/eS+F7cfwaffc6Oj
 ZHFXE8wu407SErtx5maKDbjb8EEWzmN76HVW+8TzFMeS+DVy+2
 LC4e9s1c4axXpypmbgAw8rAF0C4yNgoA65L2hko2NtT42Kk5q0
 dwHtHoLpCrPMf5uxNUgq9k5NOjDc13UE7MBC7092memeCtfequ
 H3mxX9FsnvDbA0qZvCSRFimYjVTJNEQ+9lY/VUC0dDYzsLHMvy
 IyC0Y/OieLFDEmW/QY/YY170+gnKBipKomHSKbI2ubJTi9b8U6
 hjBxRMUB60AYqnnMdM46tYKUBJxwIkIFk8AffGyCWXXKDmrkfL
 /x1f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/exynos-gsc/gsc-core.c   |  8 +++-----
 drivers/media/platform/mx2_emmaprp.c           |  6 +++---
 drivers/media/platform/s3c-camif/camif-core.c  |  8 +++-----
 drivers/media/platform/s5p-fimc/fimc-core.c    |  8 +++-----
 drivers/media/platform/s5p-fimc/fimc-lite.c    |  8 +++-----
 drivers/media/platform/s5p-fimc/mipi-csis.c    |  8 +++-----
 drivers/media/platform/s5p-g2d/g2d.c           |  8 +++-----
 drivers/media/platform/s5p-jpeg/jpeg-core.c    |  8 +++-----
 drivers/media/platform/s5p-mfc/s5p_mfc.c       |  8 +++-----
 drivers/media/platform/soc_camera/mx2_camera.c | 12 ++++++------
 10 files changed, 33 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 2b1b9f3..c1a0713 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1098,11 +1098,9 @@ static int gsc_probe(struct platform_device *pdev)
 	mutex_init(&gsc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	gsc->regs = devm_request_and_ioremap(dev, res);
-	if (!gsc->regs) {
-		dev_err(dev, "failed to map registers\n");
-		return -ENOENT;
-	}
+	gsc->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(gsc->regs))
+		return PTR_ERR(gsc->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 6b155d7..4b9e0a2 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -941,9 +941,9 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcdev);
 
-	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
-	if (!pcdev->base_emma) {
-		ret = -ENXIO;
+	pcdev->base_emma = devm_ioremap_resource(&pdev->dev, res_emma);
+	if (IS_ERR(pcdev->base_emma)) {
+		ret = PTR_ERR(pcdev->base_emma);
 		goto rel_vdev;
 	}
 
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index e2716c3..09a8c9c 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -433,11 +433,9 @@ static int s3c_camif_probe(struct platform_device *pdev)
 
 	mres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	camif->io_base = devm_request_and_ioremap(dev, mres);
-	if (!camif->io_base) {
-		dev_err(dev, "failed to obtain I/O memory\n");
-		return -ENOENT;
-	}
+	camif->io_base = devm_ioremap_resource(dev, mres);
+	if (IS_ERR(camif->io_base))
+		return PTR_ERR(camif->io_base);
 
 	ret = camif_request_irqs(pdev, camif);
 	if (ret < 0)
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 545b46a..acc0f84 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -909,11 +909,9 @@ static int fimc_probe(struct platform_device *pdev)
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	fimc->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (fimc->regs == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
-		return -ENOENT;
-	}
+	fimc->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fimc->regs))
+		return PTR_ERR(fimc->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index ed67220..67db9f8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1426,11 +1426,9 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	fimc->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (fimc->regs == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
-		return -ENOENT;
-	}
+	fimc->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fimc->regs))
+		return PTR_ERR(fimc->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index ec3fa7d..7abae01 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -686,11 +686,9 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	}
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	state->regs = devm_request_and_ioremap(&pdev->dev, mem_res);
-	if (state->regs == NULL) {
-		dev_err(&pdev->dev, "Failed to request and remap io memory\n");
-		return -ENXIO;
-	}
+	state->regs = devm_ioremap_resource(&pdev->dev, mem_res);
+	if (IS_ERR(state->regs))
+		return PTR_ERR(state->regs);
 
 	state->irq = platform_get_irq(pdev, 0);
 	if (state->irq < 0) {
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 1bfbc32..6ed259f 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -708,11 +708,9 @@ static int g2d_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	dev->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (dev->regs == NULL) {
-			dev_err(&pdev->dev, "Failed to obtain io memory\n");
-			return -ENOENT;
-	}
+	dev->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dev->regs))
+		return PTR_ERR(dev->regs);
 
 	dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
 	if (IS_ERR_OR_NULL(dev->clk)) {
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 17983c4..3b02375 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1325,11 +1325,9 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	/* memory-mapped registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	jpeg->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (jpeg->regs == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
-		return -ENOENT;
-	}
+	jpeg->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(jpeg->regs))
+		return PTR_ERR(jpeg->regs);
 
 	/* interrupt service routine registration */
 	jpeg->irq = ret = platform_get_irq(pdev, 0);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 379f574..b2e9e1a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1061,11 +1061,9 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	dev->regs_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (dev->regs_base == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
-		return -ENOENT;
-	}
+	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dev->regs_base))
+		return PTR_ERR(dev->regs_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 8bda2c9..1abdc7d 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1707,9 +1707,9 @@ static int mx27_camera_emma_init(struct platform_device *pdev)
 		goto out;
 	}
 
-	pcdev->base_emma = devm_request_and_ioremap(pcdev->dev, res_emma);
-	if (!pcdev->base_emma) {
-		err = -EADDRNOTAVAIL;
+	pcdev->base_emma = devm_ioremap_resource(pcdev->dev, res_emma);
+	if (IS_ERR(pcdev->base_emma)) {
+		err = PTR_ERR(pcdev->base_emma);
 		goto out;
 	}
 
@@ -1824,9 +1824,9 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcdev->discard);
 	spin_lock_init(&pcdev->lock);
 
-	pcdev->base_csi = devm_request_and_ioremap(&pdev->dev, res_csi);
-	if (!pcdev->base_csi) {
-		err = -EADDRNOTAVAIL;
+	pcdev->base_csi = devm_ioremap_resource(&pdev->dev, res_csi);
+	if (IS_ERR(pcdev->base_csi)) {
+		err = PTR_ERR(pcdev->base_csi);
 		goto exit;
 	}
 
-- 
1.8.1.1

