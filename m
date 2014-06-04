Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaFDLhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:37:05 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58925 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbaFDLgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:09 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 10/21] media: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:10 +0400
Message-Id: <1401880402-30091-11-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/media/platform/exynos4-is/fimc-is.c |   14 ++++++--------
 drivers/media/platform/fsl-viu.c            |   25 +++++++++----------------
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 128b73b..b90b9c1 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -810,10 +810,10 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (!is->pmu_regs)
 		return -ENOMEM;
 
-	is->irq = irq_of_parse_and_map(dev->of_node, 0);
-	if (is->irq < 0) {
+	is->irq = devm_irq_of_parse_and_map(dev, dev->of_node, 0);
+	if (is->irq <= 0) {
 		dev_err(dev, "no irq found\n");
-		return is->irq;
+		return is->irq ? is->irq : -EINVAL;
 	}
 
 	ret = fimc_is_get_clocks(is);
@@ -822,7 +822,8 @@ static int fimc_is_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, is);
 
-	ret = request_irq(is->irq, fimc_is_irq_handler, 0, dev_name(dev), is);
+	ret = devm_request_irq(dev, is->irq, fimc_is_irq_handler, 0,
+			dev_name(dev), is);
 	if (ret < 0) {
 		dev_err(dev, "irq request failed\n");
 		goto err_clk;
@@ -832,7 +833,7 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (!pm_runtime_enabled(dev)) {
 		ret = fimc_is_runtime_resume(dev);
 		if (ret < 0)
-			goto err_irq;
+			goto err_clk;
 	}
 
 	ret = pm_runtime_get_sync(dev);
@@ -874,8 +875,6 @@ err_vb:
 err_pm:
 	if (!pm_runtime_enabled(dev))
 		fimc_is_runtime_suspend(dev);
-err_irq:
-	free_irq(is->irq, is);
 err_clk:
 	fimc_is_put_clocks(is);
 	return ret;
@@ -929,7 +928,6 @@ static int fimc_is_remove(struct platform_device *pdev)
 	pm_runtime_set_suspended(dev);
 	if (!pm_runtime_status_suspended(dev))
 		fimc_is_runtime_suspend(dev);
-	free_irq(is->irq, is);
 	fimc_is_unregister_subdevs(is);
 	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 	fimc_is_put_clocks(is);
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index dbf0ce3..ca9c04f 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1495,34 +1495,31 @@ static int viu_of_probe(struct platform_device *op)
 		return -ENODEV;
 	}
 
-	viu_irq = irq_of_parse_and_map(op->dev.of_node, 0);
-	if (viu_irq == NO_IRQ) {
+	viu_irq = devm_irq_of_parse_and_map(&op->dev, op->dev.of_node, 0);
+	if (viu_irq <= 0) {
 		dev_err(&op->dev, "Error while mapping the irq\n");
-		return -EINVAL;
+		return viu_irq ? viu_irq : -EINVAL;
 	}
 
 	/* request mem region */
 	if (!devm_request_mem_region(&op->dev, r.start,
 				     sizeof(struct viu_reg), DRV_NAME)) {
 		dev_err(&op->dev, "Error while requesting mem region\n");
-		ret = -EBUSY;
-		goto err;
+		return -EBUSY;
 	}
 
 	/* remap registers */
 	viu_regs = devm_ioremap(&op->dev, r.start, sizeof(struct viu_reg));
 	if (!viu_regs) {
 		dev_err(&op->dev, "Can't map register set\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	/* Prepare our private structure */
 	viu_dev = devm_kzalloc(&op->dev, sizeof(struct viu_dev), GFP_ATOMIC);
 	if (!viu_dev) {
 		dev_err(&op->dev, "Can't allocate private structure\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	viu_dev->vr = viu_regs;
@@ -1538,7 +1535,7 @@ static int viu_of_probe(struct platform_device *op)
 	ret = v4l2_device_register(viu_dev->dev, &viu_dev->v4l2_dev);
 	if (ret < 0) {
 		dev_err(&op->dev, "v4l2_device_register() failed: %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	ad = i2c_get_adapter(0);
@@ -1597,7 +1594,8 @@ static int viu_of_probe(struct platform_device *op)
 	viu_reset(viu_dev->vr);
 
 	/* install interrupt handler */
-	if (request_irq(viu_dev->irq, viu_intr, 0, "viu", (void *)viu_dev)) {
+	if (devm_request_irq(&op->dev, viu_dev->irq, viu_intr, 0, "viu",
+				(void *)viu_dev)) {
 		dev_err(&op->dev, "Request VIU IRQ failed.\n");
 		ret = -ENODEV;
 		goto err_irq;
@@ -1616,8 +1614,6 @@ err_vdev:
 	mutex_unlock(&viu_dev->lock);
 	i2c_put_adapter(ad);
 	v4l2_device_unregister(&viu_dev->v4l2_dev);
-err:
-	irq_dispose_mapping(viu_irq);
 	return ret;
 }
 
@@ -1629,9 +1625,6 @@ static int viu_of_remove(struct platform_device *op)
 					      struct v4l2_subdev, list);
 	struct i2c_client *client = v4l2_get_subdevdata(sdev);
 
-	free_irq(dev->irq, (void *)dev);
-	irq_dispose_mapping(dev->irq);
-
 	clk_disable_unprepare(dev->clk);
 
 	video_unregister_device(dev->vdev);
-- 
1.7.10.4

