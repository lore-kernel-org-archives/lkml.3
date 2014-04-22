Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaDVHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:09:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:3413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaDVHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,902,1389772800"; 
   d="scan'208";a="517082141"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part3 V1 19/22] iommu/vt-d: simplify intel_unmap_sg() and kill duplicated code
Date: Tue, 22 Apr 2014 15:07:30 +0800
Message-Id: <1398150453-28141-20-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
References: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify intel_unmap_sg() by calling intel_unmap_page() and
kill duplicated code, no functionality changes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   63 +++++++++++++------------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f2143b59ad68..4738e64fe097 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -979,6 +979,8 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
 	BUG_ON(start_pfn > last_pfn);
 
+	dma_pte_clear_range(domain, start_pfn, last_pfn);
+
 	/* We don't need lock here; nobody else touches the iova range */
 	dma_pte_free_level(domain, agaw_to_level(domain->agaw),
 			   domain->pgd, 0, start_pfn, last_pfn);
@@ -2031,12 +2033,14 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			/* It is large page*/
 			if (largepage_lvl > 1) {
 				pteval |= DMA_PTE_LARGE_PAGE;
-				/* Ensure that old small page tables are removed to make room
-				   for superpage, if they exist. */
-				dma_pte_clear_range(domain, iov_pfn,
-						    iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+				lvl_pages = lvl_to_nr_pages(largepage_lvl);
+				/*
+				 * Ensure that old small page tables are
+				 * removed to make room for superpage,
+				 * if they exist.
+				 */
 				dma_pte_free_pagetable(domain, iov_pfn,
-						       iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+						       iov_pfn + lvl_pages - 1);
 			} else {
 				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
 			}
@@ -3256,43 +3260,17 @@ static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			   int nelems, enum dma_data_direction dir,
 			   struct dma_attrs *attrs)
 {
-	struct dmar_domain *domain;
-	unsigned long start_pfn, last_pfn;
-	struct iova *iova;
-	struct intel_iommu *iommu;
-	struct page *freelist;
-
-	if (iommu_no_mapping(dev))
-		return;
-
-	domain = find_domain(dev);
-	BUG_ON(!domain);
-
-	iommu = domain_get_iommu(domain);
-
-	iova = find_iova(&domain->iovad, IOVA_PFN(sglist[0].dma_address));
-	if (WARN_ONCE(!iova, "Driver unmaps unmatched sglist at PFN %llx\n",
-		      (unsigned long long)sglist[0].dma_address))
-		return;
-
-	start_pfn = mm_to_dma_pfn(iova->pfn_lo);
-	last_pfn = mm_to_dma_pfn(iova->pfn_hi + 1) - 1;
+	size_t size = 0;
+#if 0
+	/* current the third argument of intel_unmap_page is unsued */
+	int i;
+	struct scatterlist *sg;
 
-	freelist = domain_unmap(domain, start_pfn, last_pfn);
+	for_each_sg(sglist, sg, nelems, i)
+		size += sg->length;
+#endif
 
-	if (intel_iommu_strict) {
-		iommu_flush_iotlb_psi(iommu, domain->id, start_pfn,
-				      last_pfn - start_pfn + 1, !freelist, 0);
-		/* free iova */
-		__free_iova(&domain->iovad, iova);
-		dma_free_pagelist(freelist);
-	} else {
-		add_unmap(domain, iova, freelist);
-		/*
-		 * queue up the release of the unmap to save the 1/6th of the
-		 * cpu used up by the iotlb flush operation...
-		 */
-	}
+	intel_unmap_page(dev, sglist[0].dma_address, size, dir, attrs);
 }
 
 static int intel_nontranslate_map_sg(struct device *hddev,
@@ -3356,13 +3334,8 @@ static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nele
 
 	ret = domain_sg_mapping(domain, start_vpfn, sglist, size, prot);
 	if (unlikely(ret)) {
-		/*  clear the page */
-		dma_pte_clear_range(domain, start_vpfn,
-				    start_vpfn + size - 1);
-		/* free page tables */
 		dma_pte_free_pagetable(domain, start_vpfn,
 				       start_vpfn + size - 1);
-		/* free iova */
 		__free_iova(&domain->iovad, iova);
 		return 0;
 	}
-- 
1.7.10.4

