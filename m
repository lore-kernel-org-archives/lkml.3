Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbbA2JtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:49:00 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44816 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbbA2JER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/176] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
Date: Wed, 28 Jan 2015 15:27:29 +0100
Message-Id: <b377e72cf3c79fcba0fad4b0925fde850d353a15.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iommu/intel-iommu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 911ecb230b5a..fd0516c9fbfe 100644
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
2.2.2

