Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaFWIjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:39:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55632 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/111] iommu/vt-d: Fix missing IOTLB flush in intel_iommu_unmap()
Date: Mon, 23 Jun 2014 10:30:49 +0200
Message-Id: <4801cb6ba3527f1cbb2078e23d3fdbe03ebcc7e7.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

This is a small excerpt of the upstream commit
ea8ea460c9ace60bbb5ac6e5521d637d5c15293d (iommu/vt-d: Clean up and fix
page table clear/free behaviour).

This missing IOTLB flush was added as a minor, inconsequential bug-fix
in commit ea8ea460c ("iommu/vt-d: Clean up and fix page table clear/free
behaviour") in 3.15. It wasn't originally intended for -stable but a
couple of users have reported issues which turn out to be fixed by
adding the missing flush.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iommu/intel-iommu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index cae5a0866046..911ecb230b5a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4117,7 +4117,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 			     unsigned long iova, size_t size)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
-	int order;
+	int order, iommu_id;
 
 	order = dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
@@ -4125,6 +4125,22 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
+	for_each_set_bit(iommu_id, dmar_domain->iommu_bmp, g_num_of_iommus) {
+		struct intel_iommu *iommu = g_iommus[iommu_id];
+		int num, ndomains;
+
+		/*
+		 * find bit position of dmar_domain
+		 */
+		ndomains = cap_ndoms(iommu->cap);
+		for_each_set_bit(num, iommu->domain_ids, ndomains) {
+			if (iommu->domains[num] == dmar_domain)
+				iommu_flush_iotlb_psi(iommu, num,
+						      iova >> VTD_PAGE_SHIFT,
+						      1 << order, 0);
+		}
+	}
+
 	return PAGE_SIZE << order;
 }
 
-- 
2.0.0

