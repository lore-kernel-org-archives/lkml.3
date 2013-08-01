Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3HAVqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:46:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39738 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3HAVqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:46:33 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 12/51] DMA-API: net: intel/e1000: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50hA-0006qa-Vz@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:46:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 59ad007..34672f8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1018,19 +1018,14 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	pci_using_dac = 0;
 	if ((hw->bus_type == e1000_bus_type_pcix) &&
-	    !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-		/* according to DMA-API-HOWTO, coherent calls will always
-		 * succeed if the set call did
-		 */
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			pr_err("No usable DMA config, aborting\n");
 			goto err_dma;
 		}
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	}
 
 	netdev->netdev_ops = &e1000_netdev_ops;
-- 
1.7.4.4

