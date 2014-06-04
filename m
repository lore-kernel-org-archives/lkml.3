Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaFDLgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:36:14 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58900 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbaFDLgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:06 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 05/21] dma: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:05 +0400
Message-Id: <1401880402-30091-6-git-send-email-nyushchenko@dev.rtsoft.ru>
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
 drivers/dma/moxart-dma.c  |    4 ++--
 drivers/dma/mpc512x_dma.c |   14 ++++----------
 drivers/dma/mv_xor.c      |   18 +++++++-----------
 drivers/dma/sirf-dma.c    |   23 ++++++++---------------
 4 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/drivers/dma/moxart-dma.c b/drivers/dma/moxart-dma.c
index 3258e48..30a8261 100644
--- a/drivers/dma/moxart-dma.c
+++ b/drivers/dma/moxart-dma.c
@@ -598,8 +598,8 @@ static int moxart_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	irq = irq_of_parse_and_map(node, 0);
-	if (irq == NO_IRQ) {
+	irq = devm_irq_of_parse_and_map(dev, node, 0);
+	if (irq <= 0) {
 		dev_err(dev, "no IRQ resource\n");
 		return -EINVAL;
 	}
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 448750d..c603492 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -652,16 +652,16 @@ static int mpc_dma_probe(struct platform_device *op)
 		return -ENOMEM;
 	}
 
-	mdma->irq = irq_of_parse_and_map(dn, 0);
-	if (mdma->irq == NO_IRQ) {
+	mdma->irq = devm_irq_of_parse_and_map(dev, dn, 0);
+	if (mdma->irq <= 0) {
 		dev_err(dev, "Error mapping IRQ!\n");
 		return -EINVAL;
 	}
 
 	if (of_device_is_compatible(dn, "fsl,mpc8308-dma")) {
 		mdma->is_mpc8308 = 1;
-		mdma->irq2 = irq_of_parse_and_map(dn, 1);
-		if (mdma->irq2 == NO_IRQ) {
+		mdma->irq2 = devm_irq_of_parse_and_map(dev, dn, 1);
+		if (mdma->irq2 <= 0) {
 			dev_err(dev, "Error mapping IRQ!\n");
 			return -EINVAL;
 		}
@@ -785,10 +785,6 @@ static int mpc_dma_probe(struct platform_device *op)
 	/* Register DMA engine */
 	dev_set_drvdata(dev, mdma);
 	retval = dma_async_device_register(dma);
-	if (retval) {
-		devm_free_irq(dev, mdma->irq, mdma);
-		irq_dispose_mapping(mdma->irq);
-	}
 
 	return retval;
 }
@@ -799,8 +795,6 @@ static int mpc_dma_remove(struct platform_device *op)
 	struct mpc_dma *mdma = dev_get_drvdata(dev);
 
 	dma_async_device_unregister(&mdma->dma);
-	devm_free_irq(dev, mdma->irq, mdma);
-	irq_dispose_mapping(mdma->irq);
 
 	return 0;
 }
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 394cbc5..63410db 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1063,8 +1063,9 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	/* clear errors before enabling interrupts */
 	mv_xor_device_clear_err_status(mv_chan);
 
-	ret = request_irq(mv_chan->irq, mv_xor_interrupt_handler,
-			  0, dev_name(&pdev->dev), mv_chan);
+	ret = devm_request_irq(&pdev->dev, mv_chan->irq,
+			       mv_xor_interrupt_handler,
+			       0, dev_name(&pdev->dev), mv_chan);
 	if (ret)
 		goto err_free_dma;
 
@@ -1085,14 +1086,14 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 		ret = mv_xor_memcpy_self_test(mv_chan);
 		dev_dbg(&pdev->dev, "memcpy self test returned %d\n", ret);
 		if (ret)
-			goto err_free_irq;
+			goto err_free_dma;
 	}
 
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		ret = mv_xor_xor_self_test(mv_chan);
 		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
 		if (ret)
-			goto err_free_irq;
+			goto err_free_dma;
 	}
 
 	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s)\n",
@@ -1103,8 +1104,6 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	dma_async_device_register(dma_dev);
 	return mv_chan;
 
-err_free_irq:
-	free_irq(mv_chan->irq, mv_chan);
  err_free_dma:
 	dma_free_coherent(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
@@ -1209,8 +1208,8 @@ static int mv_xor_probe(struct platform_device *pdev)
 			if (of_property_read_bool(np, "dmacap,interrupt"))
 				dma_cap_set(DMA_INTERRUPT, cap_mask);
 
-			irq = irq_of_parse_and_map(np, 0);
-			if (!irq) {
+			irq = devm_irq_of_parse_and_map(&pdev->dev, np, 0);
+			if (irq <= 0) {
 				ret = -ENODEV;
 				goto err_channel_add;
 			}
@@ -1219,7 +1218,6 @@ static int mv_xor_probe(struct platform_device *pdev)
 						  cap_mask, irq);
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
-				irq_dispose_mapping(irq);
 				goto err_channel_add;
 			}
 
@@ -1261,8 +1259,6 @@ err_channel_add:
 	for (i = 0; i < MV_XOR_MAX_CHANNELS; i++)
 		if (xordev->channels[i]) {
 			mv_xor_channel_remove(xordev->channels[i]);
-			if (pdev->dev.of_node)
-				irq_dispose_mapping(xordev->channels[i]->irq);
 		}
 
 	if (!IS_ERR(xordev->clk)) {
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 03f7820..95af51d 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -698,8 +698,8 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 		return -ENODEV;
 	}
 
-	sdma->irq = irq_of_parse_and_map(dn, 0);
-	if (sdma->irq == NO_IRQ) {
+	sdma->irq = devm_irq_of_parse_and_map(dev, dn, 0);
+	if (sdma->irq <= 0) {
 		dev_err(dev, "Error mapping IRQ!\n");
 		return -EINVAL;
 	}
@@ -713,7 +713,7 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 	ret = of_address_to_resource(dn, 0, &res);
 	if (ret) {
 		dev_err(dev, "Error parsing memory region!\n");
-		goto irq_dispose;
+		return ret;
 	}
 
 	regs_start = res.start;
@@ -722,15 +722,14 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 	sdma->base = devm_ioremap(dev, regs_start, regs_size);
 	if (!sdma->base) {
 		dev_err(dev, "Error mapping memory region!\n");
-		ret = -ENOMEM;
-		goto irq_dispose;
+		return -ENOMEM;
 	}
 
-	ret = request_irq(sdma->irq, &sirfsoc_dma_irq, 0, DRV_NAME, sdma);
+	ret = devm_request_irq(dev, sdma->irq, &sirfsoc_dma_irq, 0, DRV_NAME,
+			sdma);
 	if (ret) {
 		dev_err(dev, "Error requesting IRQ!\n");
-		ret = -EINVAL;
-		goto irq_dispose;
+		return -EINVAL;
 	}
 
 	dma = &sdma->dma;
@@ -775,7 +774,7 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 
 	ret = dma_async_device_register(dma);
 	if (ret)
-		goto free_irq;
+		return ret;
 
 	/* Device-tree DMA controller registration */
 	ret = of_dma_controller_register(dn, of_dma_sirfsoc_xlate, sdma);
@@ -791,10 +790,6 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 
 unreg_dma_dev:
 	dma_async_device_unregister(dma);
-free_irq:
-	free_irq(sdma->irq, sdma);
-irq_dispose:
-	irq_dispose_mapping(sdma->irq);
 	return ret;
 }
 
@@ -805,8 +800,6 @@ static int sirfsoc_dma_remove(struct platform_device *op)
 
 	of_dma_controller_free(op->dev.of_node);
 	dma_async_device_unregister(&sdma->dma);
-	free_irq(sdma->irq, sdma);
-	irq_dispose_mapping(sdma->irq);
 	pm_runtime_disable(&op->dev);
 	if (!pm_runtime_status_suspended(&op->dev))
 		sirfsoc_dma_runtime_suspend(&op->dev);
-- 
1.7.10.4

