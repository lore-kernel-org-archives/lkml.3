Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816AbaFIWqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:46:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271AbaFIWqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 3.14 78/78] [stable PATCH] iommu/vt-d: Fix missing IOTLB flush in intel_iommu_unmap()
Date: Mon,  9 Jun 2014 15:48:58 -0700
Message-Id: <20140609224815.816758729@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

Based on commit ea8ea460c9ace60bbb5ac6e5521d637d5c15293d upstream

This missing IOTLB flush was added as a minor, inconsequential bug-fix
in commit ea8ea460c ("iommu/vt-d: Clean up and fix page table clear/free
behaviour") in 3.15. It wasn't originally intended for -stable but a
couple of users have reported issues which turn out to be fixed by
adding the missing flush.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
For 3.14 and earlier. As noted, this fix is in 3.15 already.

 drivers/iommu/intel-iommu.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4075,7 +4075,7 @@ static size_t intel_iommu_unmap(struct i
 			     unsigned long iova, size_t size)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
-	int order;
+	int order, iommu_id;
 
 	order = dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
@@ -4083,6 +4083,22 @@ static size_t intel_iommu_unmap(struct i
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
 


