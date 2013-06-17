Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3FQO6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:58:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39024 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3FQO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:58:20 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        Mark Brown <broonie@linaro.org>, Chris Ball <cjb@laptop.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] ARM: edma: Convert to devm_* api
Date: Mon, 17 Jun 2013 20:27:58 +0530
Message-Id: <1371481078-18058-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Use devm_ioremap_resource instead of reques_mem_region()/ioremap(),
devm_request_irq() instead of request_irq() and kzalloc() calls to
devm_kzalloc().

This ensures more consistent error values and simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 This patch is boot tested on DA850 EVM.
 
 Changes for v2:
 1: Fixed review comments pointed by Sergei.
 2: Rebased the patch on http://www.spinics.net/lists/arm-kernel/msg252087.html
 
 arch/arm/common/edma.c |   64 ++++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 45 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index a1db6cd..565ddda 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1382,7 +1382,6 @@ static int __init edma_probe(struct platform_device *pdev)
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
 	struct resource		*r[EDMA_MAX_CC] = {NULL};
-	resource_size_t		len[EDMA_MAX_CC];
 	char			res_name[10];
 	char			irq_name[10];
 
@@ -1402,26 +1401,14 @@ static int __init edma_probe(struct platform_device *pdev)
 			found = 1;
 		}
 
-		len[j] = resource_size(r[j]);
+		edmacc_regs_base[j] = devm_ioremap_resource(&pdev->dev, r[j]);
+		if (IS_ERR(edmacc_regs_base[j]))
+			return PTR_ERR(edmacc_regs_base[j]);
 
-		r[j] = request_mem_region(r[j]->start, len[j],
-			dev_name(&pdev->dev));
-		if (!r[j]) {
-			status = -EBUSY;
-			goto fail1;
-		}
-
-		edmacc_regs_base[j] = ioremap(r[j]->start, len[j]);
-		if (!edmacc_regs_base[j]) {
-			status = -EBUSY;
-			goto fail1;
-		}
-
-		edma_cc[j] = kzalloc(sizeof(struct edma), GFP_KERNEL);
-		if (!edma_cc[j]) {
-			status = -ENOMEM;
-			goto fail1;
-		}
+		edma_cc[j] = devm_kzalloc(&pdev->dev, sizeof(struct edma),
+					  GFP_KERNEL);
+		if (!edma_cc[j])
+			return -ENOMEM;
 
 		edma_cc[j]->num_channels = min_t(unsigned, info[j]->n_channel,
 							EDMA_MAX_DMACH);
@@ -1471,23 +1458,27 @@ static int __init edma_probe(struct platform_device *pdev)
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
-			goto fail;
+			return status;
 		}
 
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
-			goto fail;
+			return status;
 		}
 
 		for (i = 0; i < edma_cc[j]->num_channels; i++)
@@ -1522,23 +1513,6 @@ static int __init edma_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-
-fail:
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
-		kfree(edma_cc[i]);
-	}
-	return status;
 }
 
 
-- 
1.7.9.5

