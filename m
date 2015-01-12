Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbALSTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:19:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbbALSGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 068/216] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
Date: Mon, 12 Jan 2015 18:03:05 +0000
Message-Id: <1421085933-32536-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/intel-iommu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 382c1801a8f1..b36bd2886940 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1966,7 +1966,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	struct dma_pte *first_pte = NULL, *pte = NULL;
 	phys_addr_t uninitialized_var(pteval);
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
-	unsigned long sg_res;
+	unsigned long sg_res = 0;
 	unsigned int largepage_lvl = 0;
 	unsigned long lvl_pages = 0;
 
@@ -1977,10 +1977,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 
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
2.1.4

