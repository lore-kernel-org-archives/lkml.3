Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3JKNZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:25:24 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62181 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3JKNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:25:04 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM SMMU DRIVER),
        iommu@lists.linux-foundation.org (open list:IOMMU DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, agraf@suse.de, B08248@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [PATCH 2/2] ARM: SMMU: return NULL on error in arm_smmu_iova_to_phys
Date: Fri, 11 Oct 2013 15:24:47 +0200
Message-Id: <1381497887-14586-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of arm_smmu_iova_to_phys is directly passed to the
user of the IOMMU API via iommu_iova_to_phys; however the ARM SMMU
driver returns -EINVAL on error, which is not consistent with the
rest of the drivers implementing the IOMMU API. VFIO also relies on
the call returning NULL when a page has not been mapped already.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 8b71332..fe81b20 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1480,10 +1480,7 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
 
 err_unlock:
 	spin_unlock(&smmu_domain->lock);
-	dev_warn(smmu->dev,
-		 "invalid (corrupt?) page tables detected for iova 0x%llx\n",
-		 (unsigned long long)iova);
-	return -EINVAL;
+	return NULL;
 }
 
 static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
-- 
1.8.1.2

