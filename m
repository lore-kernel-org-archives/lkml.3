Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3I0QgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:36:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:36930 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3I0QgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:36:10 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="58131142"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 12/19] swiotlb: don't assume that io_tlb_start-io_tlb_end is coherent
Date: Fri, 27 Sep 2013 17:10:00 +0100
Message-ID: <1380298207-29151-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The swiotlb code has appropriate calls to dma_mark_clean in place for
buffers passed to swiotlb_map_page as an argument. However it assumes
that the swiotlb bounce buffer (io_tlb_start-io_tlb_end) is already
coherent and doesn't need any calls to dma_mark_clean.

On ARM the swiotlb bounce buffer is not coherent (the memory is
writealloc while it should be bufferable) and therefore we need to call
dma_mark_clean appropriately on the bounce buffer code paths too.

Note that most architecures have an empty dma_mark_clean implementation
anyway.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 lib/swiotlb.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 4e8686c..eb45d17 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -515,6 +515,7 @@ found:
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
+	dma_mark_clean(phys_to_virt(tlb_addr), size);
 
 	return tlb_addr;
 }
@@ -547,7 +548,10 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 	 * First, sync the memory before unmapping the entry
 	 */
 	if (orig_addr && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+	{
+		dma_mark_clean(phys_to_virt(tlb_addr), size);
 		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_FROM_DEVICE);
+	}
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -587,17 +591,20 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	switch (target) {
 	case SYNC_FOR_CPU:
-		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
+		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)) {
+			dma_mark_clean(phys_to_virt(tlb_addr), size);
 			swiotlb_bounce(orig_addr, tlb_addr,
 				       size, DMA_FROM_DEVICE);
+		}
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
-		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
+		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)) {
 			swiotlb_bounce(orig_addr, tlb_addr,
 				       size, DMA_TO_DEVICE);
-		else
+			dma_mark_clean(phys_to_virt(tlb_addr), size);
+		} else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
 	default:
-- 
1.7.2.5

