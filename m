Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3HAVrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:47:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39741 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3HAVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:47:32 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 13/51] DMA-API: net: sfc/efx.c: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50i9-0006qf-Ed@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:47:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/sfc/efx.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c729688..37c3f7e 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1164,7 +1164,7 @@ static int efx_init_io(struct efx_nic *efx)
 	 */
 	while (dma_mask > 0x7fffffffUL) {
 		if (dma_supported(&pci_dev->dev, dma_mask)) {
-			rc = dma_set_mask(&pci_dev->dev, dma_mask);
+			rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
 			if (rc == 0)
 				break;
 		}
@@ -1177,16 +1177,6 @@ static int efx_init_io(struct efx_nic *efx)
 	}
 	netif_dbg(efx, probe, efx->net_dev,
 		  "using DMA mask %llx\n", (unsigned long long) dma_mask);
-	rc = dma_set_coherent_mask(&pci_dev->dev, dma_mask);
-	if (rc) {
-		/* dma_set_coherent_mask() is not *allowed* to
-		 * fail with a mask that dma_set_mask() accepted,
-		 * but just in case...
-		 */
-		netif_err(efx, probe, efx->net_dev,
-			  "failed to set consistent DMA mask\n");
-		goto fail2;
-	}
 
 	efx->membase_phys = pci_resource_start(efx->pci_dev, EFX_MEM_BAR);
 	rc = pci_request_region(pci_dev, EFX_MEM_BAR, "sfc");
-- 
1.7.4.4

