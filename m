Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaKZBiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:38:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:11842 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaKZBix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:38:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="421535318"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
Date: Wed, 26 Nov 2014 09:42:10 +0800
Message-Id: <1416966130-866-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's an off-by-one bug in function __domain_mapping(), which may
trigger the BUG_ON(nr_pages < lvl_pages) when
	(nr_pages + 1) & superpage_mask == 0

The issue was introduced by commit 9051aa0268dc "intel-iommu: Combine
domain_pfn_mapping() and domain_sg_mapping()", which sets sg_res to
"nr_pages + 1" to avoid some of the 'sg_res==0' code paths.

It's safe to remove extra "+1" because sg_res is only used to calculate
page size now.

Reported-And-Tested-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: <stable@vger.kernel.org> # 3.1
---
Hi David and Joerg,
	This issue was introduced in v2.6.31, but intel-iommu.c has
been moved into drivers/iommu in v3.1. So what's the preferred way
to deal with stable kernels between v2.6.31 and v3.1?
Thanks!
Gerry
---
 drivers/iommu/intel-iommu.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a27d6cb1a793..b26ad10ec697 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1983,7 +1983,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 {
 	struct dma_pte *first_pte = NULL, *pte = NULL;
 	phys_addr_t uninitialized_var(pteval);
-	unsigned long sg_res;
+	unsigned long sg_res = 0;
 	unsigned int largepage_lvl = 0;
 	unsigned long lvl_pages = 0;
 
@@ -1994,10 +1994,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 
 	prot &= DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP;
 
-	if (sg)
-		sg_res = 0;
-	else {
-		sg_res = nr_pages + 1;
+	if (!sg) {
+		sg_res = nr_pages;
 		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | prot;
 	}
 
-- 
1.7.10.4

