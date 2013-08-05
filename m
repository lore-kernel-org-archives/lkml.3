Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3HEUoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:44:32 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50986 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3HEUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:14 -0400
Message-ID: <4de821ec82393438f8124bebcdbc5158d037dd6b.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 17/20] tile PCI DMA: fix bug in non-page-aligned accessors
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code incorrectly masked with PAGE_OFFSET instead of
PAGE_SIZE-1.  This only matters when trying to do a
non page-aligned DMA; it was noticed during code inspection.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci-dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 3570ff7..cbc6fc4 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -257,7 +257,7 @@ static void tile_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 	BUG_ON(!valid_dma_direction(direction));
 
 	__dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
-			    dma_address & PAGE_OFFSET, size, direction);
+			    dma_address & (PAGE_SIZE - 1), size, direction);
 }
 
 static void tile_dma_sync_single_for_cpu(struct device *dev,
@@ -436,7 +436,7 @@ static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 	dma_address -= get_dma_offset(dev);
 
 	__dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
-			    dma_address & PAGE_OFFSET, size, direction);
+			    dma_address & (PAGE_SIZE - 1), size, direction);
 }
 
 static void tile_pci_dma_sync_single_for_cpu(struct device *dev,
-- 
1.8.3.1

