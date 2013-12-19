Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3LSL7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3LSL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 159/208] iommu/arm-smmu: use mutex instead of spinlock for locking page tables
Date: Thu, 19 Dec 2013 11:54:17 +0000
Message-Id: <1387454106-19326-160-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit a44a9791e778d9ccda50d5534028ed4057a9a45b upstream.

When creating IO mappings, we lazily allocate our page tables using the
standard, non-atomic allocator functions. This presents us with a
problem, since our page tables are protected with a spinlock.

This patch reworks the smmu_domain lock to use a mutex instead of a
spinlock. iova_to_phys is then reworked so that it only reads the page
tables, and can run in a lockless fashion, leaving the mutex to guard
against concurrent mapping threads.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/arm-smmu.c | 62 ++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 44e5276..320894b 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -391,7 +391,7 @@ struct arm_smmu_domain {
 	struct arm_smmu_cfg		root_cfg;
 	phys_addr_t			output_mask;
 
-	spinlock_t			lock;
+	struct mutex			lock;
 };
 
 static DEFINE_SPINLOCK(arm_smmu_devices_lock);
@@ -884,7 +884,7 @@ static int arm_smmu_domain_init(struct iommu_domain *domain)
 		goto out_free_domain;
 	smmu_domain->root_cfg.pgd = pgd;
 
-	spin_lock_init(&smmu_domain->lock);
+	mutex_init(&smmu_domain->lock);
 	domain->priv = smmu_domain;
 	return 0;
 
@@ -1116,7 +1116,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * Sanity check the domain. We don't currently support domains
 	 * that cross between different SMMU chains.
 	 */
-	spin_lock(&smmu_domain->lock);
+	mutex_lock(&smmu_domain->lock);
 	if (!smmu_domain->leaf_smmu) {
 		/* Now that we have a master, we can finalise the domain */
 		ret = arm_smmu_init_domain_context(domain, dev);
@@ -1131,7 +1131,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			dev_name(device_smmu->dev));
 		goto err_unlock;
 	}
-	spin_unlock(&smmu_domain->lock);
+	mutex_unlock(&smmu_domain->lock);
 
 	/* Looks ok, so add the device to the domain */
 	master = find_smmu_master(smmu_domain->leaf_smmu, dev->of_node);
@@ -1141,7 +1141,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return arm_smmu_domain_add_master(smmu_domain, master);
 
 err_unlock:
-	spin_unlock(&smmu_domain->lock);
+	mutex_unlock(&smmu_domain->lock);
 	return ret;
 }
 
@@ -1370,7 +1370,7 @@ static int arm_smmu_handle_mapping(struct arm_smmu_domain *smmu_domain,
 	if (paddr & ~output_mask)
 		return -ERANGE;
 
-	spin_lock(&smmu_domain->lock);
+	mutex_lock(&smmu_domain->lock);
 	pgd += pgd_index(iova);
 	end = iova + size;
 	do {
@@ -1386,7 +1386,7 @@ static int arm_smmu_handle_mapping(struct arm_smmu_domain *smmu_domain,
 	} while (pgd++, iova != end);
 
 out_unlock:
-	spin_unlock(&smmu_domain->lock);
+	mutex_unlock(&smmu_domain->lock);
 
 	/* Ensure new page tables are visible to the hardware walker */
 	if (smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)
@@ -1429,44 +1429,34 @@ static size_t arm_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
 static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
 					 dma_addr_t iova)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
+	pgd_t *pgdp, pgd;
+	pud_t pud;
+	pmd_t pmd;
+	pte_t pte;
 	struct arm_smmu_domain *smmu_domain = domain->priv;
 	struct arm_smmu_cfg *root_cfg = &smmu_domain->root_cfg;
-	struct arm_smmu_device *smmu = root_cfg->smmu;
 
-	spin_lock(&smmu_domain->lock);
-	pgd = root_cfg->pgd;
-	if (!pgd)
-		goto err_unlock;
+	pgdp = root_cfg->pgd;
+	if (!pgdp)
+		return 0;
 
-	pgd += pgd_index(iova);
-	if (pgd_none_or_clear_bad(pgd))
-		goto err_unlock;
+	pgd = *(pgdp + pgd_index(iova));
+	if (pgd_none(pgd))
+		return 0;
 
-	pud = pud_offset(pgd, iova);
-	if (pud_none_or_clear_bad(pud))
-		goto err_unlock;
+	pud = *pud_offset(&pgd, iova);
+	if (pud_none(pud))
+		return 0;
 
-	pmd = pmd_offset(pud, iova);
-	if (pmd_none_or_clear_bad(pmd))
-		goto err_unlock;
+	pmd = *pmd_offset(&pud, iova);
+	if (pmd_none(pmd))
+		return 0;
 
-	pte = pmd_page_vaddr(*pmd) + pte_index(iova);
+	pte = *(pmd_page_vaddr(pmd) + pte_index(iova));
 	if (pte_none(pte))
-		goto err_unlock;
-
-	spin_unlock(&smmu_domain->lock);
-	return __pfn_to_phys(pte_pfn(*pte)) | (iova & ~PAGE_MASK);
+		return 0;
 
-err_unlock:
-	spin_unlock(&smmu_domain->lock);
-	dev_warn(smmu->dev,
-		 "invalid (corrupt?) page tables detected for iova 0x%llx\n",
-		 (unsigned long long)iova);
-	return -EINVAL;
+	return __pfn_to_phys(pte_pfn(pte)) | (iova & ~PAGE_MASK);
 }
 
 static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
-- 
1.8.3.2

