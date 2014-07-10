Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaGJCar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:30:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52509 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaGJCap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:30:45 -0400
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: linux@arm.linux.org.uk, m.szyprowski@samsung.com, will.deacon@arm.com,
        andreas.herrmann@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH] ARM: mm: fix the boundary checking on bitmaps
Date: Thu, 10 Jul 2014 10:28:33 +0800
Message-Id: <1404959313-15198-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue of boundary checking on bitmaps is introduced by this commit
in below.

commit 4d852ef8c2544ce21ae41414099a7504c61164a0
Author: Andreas Herrmann <andreas.herrmann@calxeda.com>
Date:   Tue Feb 25 13:09:53 2014 +0100

    arm: dma-mapping: Add support to extend DMA IOMMU mappings

Multiple bitmaps were introduced as extension. If it needs to extend
a bitmap, it still check whether the allocation exceeding the total
size, not current bitmap size. So change the condition from
mapping->bits to PAGE_SIZE.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 arch/arm/mm/dma-mapping.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 4c88935..d7da5c3 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1089,9 +1089,9 @@ static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
 	spin_lock_irqsave(&mapping->lock, flags);
 	for (i = 0; i < mapping->nr_bitmaps; i++) {
 		start = bitmap_find_next_zero_area(mapping->bitmaps[i],
-				mapping->bits, 0, count, align);
+				PAGE_SIZE, 0, count, align);
 
-		if (start > mapping->bits)
+		if (start > PAGE_SIZE)
 			continue;
 
 		bitmap_set(mapping->bitmaps[i], start, count);
@@ -1110,9 +1110,9 @@ static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
 		}
 
 		start = bitmap_find_next_zero_area(mapping->bitmaps[i],
-				mapping->bits, 0, count, align);
+				PAGE_SIZE, 0, count, align);
 
-		if (start > mapping->bits) {
+		if (start > PAGE_SIZE) {
 			spin_unlock_irqrestore(&mapping->lock, flags);
 			return DMA_ERROR_CODE;
 		}
-- 
1.9.1

