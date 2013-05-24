Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab3EXAhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 20:37:07 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:35705 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab3EXAhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 20:37:05 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] x86/iommu: fix dma pte address size error
Date: Fri, 24 May 2013 08:35:56 +0800
Message-Id: <1369355756-1030-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Intel Vt-D specs, Chapter 9.3 Page-Table Entry,
The size of ADDR(address) field is 12:51, but the function dma_pte_addr
 treats it as 12:63.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c   |    4 ++--
 include/linux/dma_remapping.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b4f0e28..c6d2847 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -311,10 +311,10 @@ static inline void dma_set_pte_prot(struct dma_pte *pte, unsigned long prot)
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
-	return pte->val & VTD_PAGE_MASK;
+	return pte->val & DMA_PTE_MASK;
 #else
 	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
+	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & DMA_PTE_MASK;
 #endif
 }
 
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 57c9a8a..7a1e212 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -16,6 +16,8 @@
 #define DMA_PTE_WRITE (2)
 #define DMA_PTE_LARGE_PAGE (1 << 7)
 #define DMA_PTE_SNP (1 << 11)
+#define DMA_PTE_ADD_LENGTH (40)
+#define DMA_PTE_MASK	((((u64)1 << DMA_PTE_ADD_LENGTH) - 1) << VTD_PAGE_SHIFT)
 
 #define CONTEXT_TT_MULTI_LEVEL	0
 #define CONTEXT_TT_DEV_IOTLB	1
-- 
1.7.10.4

