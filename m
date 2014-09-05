Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbaIEKyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:54:23 -0400
Received: from 8bytes.org ([81.169.241.247]:37796 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbaIEKxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:12 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 06/12] iommu/vt-d: Convert to iommu_capable() API function
Date: Fri,  5 Sep 2014 12:52:58 +0200
Message-Id: <1409914384-21191-7-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 5619f26..bc1a203 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4415,17 +4415,14 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
-static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
-				      unsigned long cap)
+static bool intel_iommu_capable(enum iommu_cap cap)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
-
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
-		return dmar_domain->iommu_snooping;
+		return domain_update_iommu_snooping(NULL) == 1;
 	if (cap == IOMMU_CAP_INTR_REMAP)
-		return irq_remapping_enabled;
+		return irq_remapping_enabled == 1;
 
-	return 0;
+	return false;
 }
 
 static int intel_iommu_add_device(struct device *dev)
@@ -4464,6 +4461,7 @@ static void intel_iommu_remove_device(struct device *dev)
 }
 
 static const struct iommu_ops intel_iommu_ops = {
+	.capable	= intel_iommu_capable,
 	.domain_init	= intel_iommu_domain_init,
 	.domain_destroy = intel_iommu_domain_destroy,
 	.attach_dev	= intel_iommu_attach_device,
@@ -4471,7 +4469,6 @@ static const struct iommu_ops intel_iommu_ops = {
 	.map		= intel_iommu_map,
 	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
-	.domain_has_cap = intel_iommu_domain_has_cap,
 	.add_device	= intel_iommu_add_device,
 	.remove_device	= intel_iommu_remove_device,
 	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
-- 
1.9.1

