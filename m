Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaI3UPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:15:36 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:35260 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaI3UPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:15:33 -0400
From: Sean Paul <seanpaul@chromium.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, lauraa@codeaurora.org,
        ritesh.harjani@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: olof@lixom.net, seanpaul@chromium.org
Subject: [PATCH] arm64: Use and error-check DMA_ERROR_CODE
Date: Tue, 30 Sep 2014 16:15:21 -0400
Message-Id: <1412108121-19262-1-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the static assignment of ~0 to dma_handle with
DMA_ERROR_CODE to be consistent with other platforms.

In addition to that, it also adds a check for DMA_ERROR_CODE before
calling __dma_free_coherent with an invalid dma_handle.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 arch/arm64/mm/dma-mapping.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 4164c5a..69fd2c4 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -125,7 +125,7 @@ static void *__dma_alloc_noncoherent(struct device *dev, size_t size,
 no_map:
 	__dma_free_coherent(dev, size, ptr, *dma_handle, attrs);
 no_mem:
-	*dma_handle = ~0;
+	*dma_handle = DMA_ERROR_CODE;
 	return NULL;
 }
 
@@ -136,7 +136,9 @@ static void __dma_free_noncoherent(struct device *dev, size_t size,
 	void *swiotlb_addr = phys_to_virt(dma_to_phys(dev, dma_handle));
 
 	vunmap(vaddr);
-	__dma_free_coherent(dev, size, swiotlb_addr, dma_handle, attrs);
+
+	if (dma_handle != DMA_ERROR_CODE)
+		__dma_free_coherent(dev, size, swiotlb_addr, dma_handle, attrs);
 }
 
 static dma_addr_t __swiotlb_map_page(struct device *dev, struct page *page,
-- 
2.1.1

