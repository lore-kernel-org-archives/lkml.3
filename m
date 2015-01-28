Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbbA2DN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:13:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbbA2Cgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 067/139] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
Date: Wed, 28 Jan 2015 14:20:10 -0800
Message-Id: <1422483682-15393-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@linux.intel.com>

commit cc4f14aa170d895c9a43bdb56f62070c8a6da908 upstream.

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
Acked-By: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/intel-iommu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 59779e1..79cc9f1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1796,7 +1796,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	struct dma_pte *first_pte = NULL, *pte = NULL;
 	phys_addr_t uninitialized_var(pteval);
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
-	unsigned long sg_res;
+	unsigned long sg_res = 0;
 	unsigned int largepage_lvl = 0;
 	unsigned long lvl_pages = 0;
 
@@ -1807,10 +1807,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 
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
1.9.1

