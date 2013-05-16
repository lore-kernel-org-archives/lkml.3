Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3EPG6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:58:40 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40015 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3EPG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:58:39 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ARM: davinci: dma: Convert to devm_* api
Date: Thu, 16 May 2013 12:28:22 +0530
Message-Id: <1368687502-15551-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Use devm_ioremap_resource instead of reques_mem_region()/ioremap() and
devm_request_irq() instead of request_irq().

This ensures more consistent error values and simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 NOte:- Boot tested on Logic-PD OMAP-L138 EVM

 arch/arm/mach-davinci/dma.c |   63 ++++++++++++++++--------------------------
 1 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
index 45b7c71..aeda496 100644
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/mach-davinci/dma.c
@@ -1402,7 +1402,6 @@ static int __init edma_probe(struct platform_device *pdev)
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
 	struct resource		*r[EDMA_MAX_CC] = {NULL};
-	resource_size_t		len[EDMA_MAX_CC];
 	char			res_name[10];
 	char			irq_name[10];
 
@@ -1422,25 +1421,16 @@ static int __init edma_probe(struct platform_device *pdev)
 			found = 1;
 		}
 
-		len[j] = resource_size(r[j]);
-
-		r[j] = request_mem_region(r[j]->start, len[j],
-			dev_name(&pdev->dev));
-		if (!r[j]) {
-			status = -EBUSY;
-			goto fail1;
-		}
-
-		edmacc_regs_base[j] = ioremap(r[j]->start, len[j]);
-		if (!edmacc_regs_base[j]) {
+		edmacc_regs_base[j] = devm_ioremap_resource(&pdev->dev, r[j]);
+		if (IS_ERR(edmacc_regs_base[j])) {
 			status = -EBUSY;
-			goto fail1;
+			goto fail;
 		}
 
 		edma_cc[j] = kzalloc(sizeof(struct edma), GFP_KERNEL);
 		if (!edma_cc[j]) {
 			status = -ENOMEM;
-			goto fail1;
+			goto fail;
 		}
 
 		edma_cc[j]->num_channels = min_t(unsigned, info[j]->n_channel,
@@ -1491,10 +1481,12 @@ static int __init edma_probe(struct platform_device *pdev)
 		sprintf(irq_name, "edma%d", j);
 		irq[j] = platform_get_irq_byname(pdev, irq_name);
 		edma_cc[j]->irq_res_start = irq[j];
-		status = request_irq(irq[j], dma_irq_handler, 0, "edma",
-					&pdev->dev);
+		status = devm_request_irq(&pdev->dev, irq[j],
+					  dma_irq_handler, 0, "edma",
+					  &pdev->dev);
 		if (status < 0) {
-			dev_dbg(&pdev->dev, "request_irq %d failed --> %d\n",
+			dev_dbg(&pdev->dev,
+				"devm_request_irq %d failed --> %d\n",
 				irq[j], status);
 			goto fail;
 		}
@@ -1502,10 +1494,12 @@ static int __init edma_probe(struct platform_device *pdev)
 		sprintf(irq_name, "edma%d_err", j);
 		err_irq[j] = platform_get_irq_byname(pdev, irq_name);
 		edma_cc[j]->irq_res_end = err_irq[j];
-		status = request_irq(err_irq[j], dma_ccerr_handler, 0,
-					"edma_error", &pdev->dev);
+		status = devm_request_irq(&pdev->dev, err_irq[j],
+					  dma_ccerr_handler, 0,
+					  "edma_error", &pdev->dev);
 		if (status < 0) {
-			dev_dbg(&pdev->dev, "request_irq %d failed --> %d\n",
+			dev_dbg(&pdev->dev,
+				"devm_request_irq %d failed --> %d\n",
 				err_irq[j], status);
 			goto fail;
 		}
@@ -1542,17 +1536,20 @@ static int __init edma_probe(struct platform_device *pdev)
 	}
 
 	if (tc_errs_handled) {
-		status = request_irq(IRQ_TCERRINT0, dma_tc0err_handler, 0,
-					"edma_tc0", &pdev->dev);
+		status = devm_request_irq(&pdev->dev, IRQ_TCERRINT0,
+					  dma_tc0err_handler, 0,
+					  "edma_tc0", &pdev->dev);
 		if (status < 0) {
-			dev_dbg(&pdev->dev, "request_irq %d failed --> %d\n",
+			dev_dbg(&pdev->dev,
+				"devm_request_irq %d failed --> %d\n",
 				IRQ_TCERRINT0, status);
 			return status;
 		}
-		status = request_irq(IRQ_TCERRINT, dma_tc1err_handler, 0,
-					"edma_tc1", &pdev->dev);
+		status = devm_request_irq(&pdev->dev, IRQ_TCERRINT,
+					  dma_tc1err_handler, 0,
+					  "edma_tc1", &pdev->dev);
 		if (status < 0) {
-			dev_dbg(&pdev->dev, "request_irq %d --> %d\n",
+			dev_dbg(&pdev->dev, "devm_request_irq %d --> %d\n",
 				IRQ_TCERRINT, status);
 			return status;
 		}
@@ -1561,20 +1558,8 @@ static int __init edma_probe(struct platform_device *pdev)
 	return 0;
 
 fail:
-	for (i = 0; i < EDMA_MAX_CC; i++) {
-		if (err_irq[i])
-			free_irq(err_irq[i], &pdev->dev);
-		if (irq[i])
-			free_irq(irq[i], &pdev->dev);
-	}
-fail1:
-	for (i = 0; i < EDMA_MAX_CC; i++) {
-		if (r[i])
-			release_mem_region(r[i]->start, len[i]);
-		if (edmacc_regs_base[i])
-			iounmap(edmacc_regs_base[i]);
+	for (i = 0; i < EDMA_MAX_CC; i++)
 		kfree(edma_cc[i]);
-	}
 	return status;
 }
 
-- 
1.7.4.1

