Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaLHIjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:39:44 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6709 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaLHIjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:39:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 08 Dec 2014 00:37:57 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, Thierry Reding <treding@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
Date: Mon, 8 Dec 2014 17:39:27 +0900
Message-ID: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be any valid reason to allocate the pages array
with the same flags as the buffer itself. Doing so can eventually lead
to the following safeguard in mm/slab.c to be hit:

BUG_ON(flags & GFP_SLAB_BUG_MASK);

This happens when buffers are allocated with __GFP_DMA32 or
__GFP_HIGHMEM.

Fix this by allocating the pages array with GFP_KERNEL to follow what is
done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
is safe because atomic allocations are handled by __iommu_alloc_atomic().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/mm/dma-mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e8907117861e..bc495354c802 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1106,7 +1106,7 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 	int i = 0;
 
 	if (array_size <= PAGE_SIZE)
-		pages = kzalloc(array_size, gfp);
+		pages = kzalloc(array_size, GFP_KERNEL);
 	else
 		pages = vzalloc(array_size);
 	if (!pages)
-- 
2.1.3

