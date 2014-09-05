Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaIEKzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:55:41 -0400
Received: from 8bytes.org ([81.169.241.247]:37761 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbaIEKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:10 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 04/12] iommu/arm-smmu: Convert to iommu_capable() API function
Date: Fri,  5 Sep 2014 12:52:56 +0200
Message-Id: <1409914384-21191-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/arm-smmu.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index ca18d6d..47c2cb6 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1515,20 +1515,37 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
 	return __pfn_to_phys(pte_pfn(pte)) | (iova & ~PAGE_MASK);
 }
 
-static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
-				   unsigned long cap)
+static bool arm_smmu_capable(enum iommu_cap cap)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	u32 features = smmu ? smmu->features : 0;
+	struct arm_smmu_device *smmu;
+	bool ret = false;
 
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
-		return features & ARM_SMMU_FEAT_COHERENT_WALK;
+		/*
+		 * Use ARM_SMMU_FEAT_COHERENT_WALK as an indicator on whether
+		 * the SMMU can force coherency on the DMA transaction. If it
+		 * supports COHERENT_WALK it must be behind a coherent
+		 * interconnect.
+		 * A domain can be attached to any SMMU, so to reliably support
+		 * IOMMU_CAP_CACHE_COHERENCY all SMMUs in the system need to be
+		 * behind a coherent interconnect.
+		 */
+		spin_lock(&arm_smmu_devices_lock);
+		list_for_each_entry(smmu, &arm_smmu_devices, list) {
+			if (smmu->features & ARM_SMMU_FEAT_COHERENT_WALK) {
+				ret = true;
+			} else {
+				ret = false;
+				break;
+			}
+		}
+		spin_unlock(&arm_smmu_devices_lock);
+		return ret;
 	case IOMMU_CAP_INTR_REMAP:
-		return 1; /* MSIs are just memory writes */
+		return true; /* MSIs are just memory writes */
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -1598,6 +1615,7 @@ static void arm_smmu_remove_device(struct device *dev)
 }
 
 static const struct iommu_ops arm_smmu_ops = {
+	.capable	= arm_smmu_capable,
 	.domain_init	= arm_smmu_domain_init,
 	.domain_destroy	= arm_smmu_domain_destroy,
 	.attach_dev	= arm_smmu_attach_dev,
@@ -1605,7 +1623,6 @@ static const struct iommu_ops arm_smmu_ops = {
 	.map		= arm_smmu_map,
 	.unmap		= arm_smmu_unmap,
 	.iova_to_phys	= arm_smmu_iova_to_phys,
-	.domain_has_cap	= arm_smmu_domain_has_cap,
 	.add_device	= arm_smmu_add_device,
 	.remove_device	= arm_smmu_remove_device,
 	.pgsize_bitmap	= (SECTION_SIZE |
-- 
1.9.1

