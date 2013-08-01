Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3HAWGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:06:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39801 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3HAWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:06:38 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 32/51] DMA-API: mmc: sdhci-acpi: use
 dma_coerce_mask_and_coherent()
Message-Id: <E1V510d-0006so-6W@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:06:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code sequence:
	dev->dma_mask = &dev->coherent_dma_mask;
	dev->coherent_dma_mask = dma_mask;
bypasses the architectures check on the DMA mask.  It can be replaced
with dma_coerce_mask_and_coherent(), avoiding the direct initialization
of this mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/mmc/host/sdhci-acpi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index cdd4ce0..ef19874 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -310,8 +310,9 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
 			dma_mask = DMA_BIT_MASK(32);
 		}
 
-		dev->dma_mask = &dev->coherent_dma_mask;
-		dev->coherent_dma_mask = dma_mask;
+		err = dma_coerce_mask_and_coherent(dev, dma_mask);
+		if (err)
+			goto err_free;
 	}
 
 	if (c->slot) {
-- 
1.7.4.4

