Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaGHTYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:24:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54194 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Woodhouse" <David.Woodhouse@intel.com>,
        "David Woodhouse" <dwmw2@infradead.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.164545206@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 119/125] iommu/vt-d: Fix missing IOTLB flush in
 intel_iommu_unmap()
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

Part of commit ea8ea460c9ace60bbb5ac6e5521d637d5c15293d upstream.

This missing IOTLB flush was added as a minor, inconsequential bug-fix
in commit ea8ea460c ("iommu/vt-d: Clean up and fix page table clear/free
behaviour") in 3.15. It wasn't originally intended for -stable but a
couple of users have reported issues which turn out to be fixed by
adding the missing flush.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Use &dmar_domain->iommu_bmp, as it is a single word not an array]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4070,7 +4070,7 @@ static int intel_iommu_unmap(struct iomm
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	size_t size = PAGE_SIZE << gfp_order;
-	int order;
+	int order, iommu_id;
 
 	order = dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
@@ -4078,6 +4078,22 @@ static int intel_iommu_unmap(struct iomm
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
+	for_each_set_bit(iommu_id, &dmar_domain->iommu_bmp, g_num_of_iommus) {
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
 	return order;
 }
 

