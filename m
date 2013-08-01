Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3HAVic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:38:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39711 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3HAVia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:38:30 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 02/51] DMA-API: net: brocade/bna/bnad.c: fix 32-bit DMA
 mask handling
Message-Id: <E1V50XS-0006pV-By@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:36:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fallback to 32-bit DMA mask is rather odd:
	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
		*using_dac = true;
	} else {
		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
		if (err) {
			err = dma_set_coherent_mask(&pdev->dev,
						    DMA_BIT_MASK(32));
			if (err)
				goto release_regions;
		}

This means we only try and set the coherent DMA mask if we failed to
set a 32-bit DMA mask, and only if both fail do we fail the driver.
Adjust this so that if either setting fails, we fail the driver - and
thereby end up properly setting both the DMA mask and the coherent
DMA mask in the fallback case.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/brocade/bna/bnad.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index b78e69e..45ce6e2 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3300,17 +3300,12 @@ bnad_pci_init(struct bnad *bnad,
 	err = pci_request_regions(pdev, BNAD_NAME);
 	if (err)
 		goto disable_device;
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
-	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 		*using_dac = true;
 	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			err = dma_set_coherent_mask(&pdev->dev,
-						    DMA_BIT_MASK(32));
-			if (err)
-				goto release_regions;
-		}
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (err)
+			goto release_regions;
 		*using_dac = false;
 	}
 	pci_set_master(pdev);
-- 
1.7.4.4

