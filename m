Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaI1Pwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 11:52:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57950 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaI1Pwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 11:52:32 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH 2/2] intel-iommu: don't unnecessarily call dma_alloc_from_contiguous()
Date: Mon, 29 Sep 2014 00:52:04 +0900
Message-Id: <1411919524-3666-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411919524-3666-1-git-send-email-akinobu.mita@gmail.com>
References: <1411919524-3666-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_DMA_CMA is enabled, intel_alloc_coherent() tries to allocate
memory region by dma_alloc_from_contiguous() before trying to use
alloc_pages().

This wastes CMA region by small DMA-coherent buffers which can be
allocated by alloc_pages().  And it also causes performance degradation,
as this is trying to drive _all_ dma mapping allocations through a
_very_ small window, reported by Peter Hurley.

This fixes it by trying to allocate by alloc_pages() first in
intel_alloc_coherent() as dma_alloc_from_contiguous should be called
only for huge allocation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/intel-iommu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 3441615..f9794fa 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3250,7 +3250,8 @@ static void *intel_alloc_coherent(struct device *dev, size_t size,
 			flags |= GFP_DMA32;
 	}
 
-	if (flags & __GFP_WAIT) {
+	page = alloc_pages(flags | __GFP_NOWARN, order);
+	if (!page && (flags & __GFP_WAIT)) {
 		unsigned int count = size >> PAGE_SHIFT;
 
 		page = dma_alloc_from_contiguous(dev, count, order);
@@ -3261,10 +3262,10 @@ static void *intel_alloc_coherent(struct device *dev, size_t size,
 		}
 	}
 
-	if (!page)
-		page = alloc_pages(flags, order);
-	if (!page)
+	if (!page) {
+		warn_alloc_failed(flags, order, NULL);
 		return NULL;
+	}
 	memset(page_address(page), 0, size);
 
 	*dma_handle = __intel_map_single(dev, page_to_phys(page), size,
-- 
1.9.1

