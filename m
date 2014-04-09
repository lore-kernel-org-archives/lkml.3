Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaDICUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:20:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:14468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbaDICUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:20:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,822,1389772800"; 
   d="scan'208";a="517154974"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: David Woodhouse <David.Woodhouse@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/vt-d: fix memory leakage caused by commit ea8ea46
Date: Wed,  9 Apr 2014 10:20:39 +0800
Message-Id: <1397010039-1295-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ea8ea46 "iommu/vt-d: Clean up and fix page table clear/free
behaviour" introduces possible leakage of DMA page tables due to:
        for (pte = page_address(pg); !first_pte_in_page(pte); pte++) {
                if (dma_pte_present(pte) && !dma_pte_superpage(pte))
                        freelist = dma_pte_list_pagetables(domain, level - 1,
                                                           pte, freelist);
        }

For the first pte in a page, first_pte_in_page(pte) will always be true,
thus dma_pte_list_pagetables() will never be called and leak DMA page
tables if level is bigger than 1.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 69fa7da..13dc231 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1009,11 +1009,13 @@ static struct page *dma_pte_list_pagetables(struct dmar_domain *domain,
 	if (level == 1)
 		return freelist;
 
-	for (pte = page_address(pg); !first_pte_in_page(pte); pte++) {
+	pte = page_address(pg);
+	do {
 		if (dma_pte_present(pte) && !dma_pte_superpage(pte))
 			freelist = dma_pte_list_pagetables(domain, level - 1,
 							   pte, freelist);
-	}
+		pte++;
+	} while (!first_pte_in_page(pte));
 
 	return freelist;
 }
-- 
1.7.10.4

