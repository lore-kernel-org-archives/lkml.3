Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3HAVpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:45:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39735 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3HAVpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:45:32 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 11/51] DMA-API: net: emulex/benet: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50gC-0006qU-Rl@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:45:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/emulex/benet/be_main.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 181edb5..808d1ac 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4232,19 +4232,11 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	adapter->netdev = netdev;
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
-	status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+	status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (!status) {
-		status = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-		if (status < 0) {
-			dev_err(&pdev->dev, "dma_set_coherent_mask failed\n");
-			goto free_netdev;
-		}
 		netdev->features |= NETIF_F_HIGHDMA;
 	} else {
-		status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (!status)
-			status = dma_set_coherent_mask(&pdev->dev,
-						       DMA_BIT_MASK(32));
+		status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (status) {
 			dev_err(&pdev->dev, "Could not set PCI DMA Mask\n");
 			goto free_netdev;
-- 
1.7.4.4

