Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3BOVyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 16:54:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35170 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3BOVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 16:54:03 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Dan Williams <djbw@fb.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dma: tegra: assume CONFIG_OF
Date: Fri, 15 Feb 2013 14:53:57 -0700
Message-Id: <1360965237-14857-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Tegra only supports, and always enables, device tree. Remove all ifdefs
and runtime checks for DT support from the driver.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index fcee27e..5a0b66c 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1213,7 +1213,6 @@ static const struct tegra_dma_chip_data tegra20_dma_chip_data = {
 	.support_channel_pause	= false,
 };
 
-#if defined(CONFIG_OF)
 /* Tegra30 specific DMA controller information */
 static const struct tegra_dma_chip_data tegra30_dma_chip_data = {
 	.nr_channels		= 32,
@@ -1243,7 +1242,6 @@ static const struct of_device_id tegra_dma_of_match[] = {
 	},
 };
 MODULE_DEVICE_TABLE(of, tegra_dma_of_match);
-#endif
 
 static int tegra_dma_probe(struct platform_device *pdev)
 {
@@ -1252,20 +1250,14 @@ static int tegra_dma_probe(struct platform_device *pdev)
 	int ret;
 	int i;
 	const struct tegra_dma_chip_data *cdata = NULL;
+	const struct of_device_id *match;
 
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
-		match = of_match_device(of_match_ptr(tegra_dma_of_match),
-					&pdev->dev);
-		if (!match) {
-			dev_err(&pdev->dev, "Error: No device match found\n");
-			return -ENODEV;
-		}
-		cdata = match->data;
-	} else {
-		/* If no device tree then fallback to tegra20 */
-		cdata = &tegra20_dma_chip_data;
+	match = of_match_device(tegra_dma_of_match, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "Error: No device match found\n");
+		return -ENODEV;
 	}
+	cdata = match->data;
 
 	tdma = devm_kzalloc(&pdev->dev, sizeof(*tdma) + cdata->nr_channels *
 			sizeof(struct tegra_dma_channel), GFP_KERNEL);
@@ -1460,7 +1452,7 @@ static struct platform_driver tegra_dmac_driver = {
 		.name	= "tegra-apbdma",
 		.owner = THIS_MODULE,
 		.pm	= &tegra_dma_dev_pm_ops,
-		.of_match_table = of_match_ptr(tegra_dma_of_match),
+		.of_match_table = tegra_dma_of_match,
 	},
 	.probe		= tegra_dma_probe,
 	.remove		= tegra_dma_remove,
-- 
1.7.10.4

