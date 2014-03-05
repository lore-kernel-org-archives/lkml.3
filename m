Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaCEOYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbaCEOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/131] iommu/arm-smmu: really fix page table locking
Date: Wed,  5 Mar 2014 14:22:17 +0000
Message-Id: <1394029455-23128-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit c9d09e2748eaa55cac2af274574baa6368189bc1 upstream.

Commit a44a9791e778 ("iommu/arm-smmu: use mutex instead of spinlock for
locking page tables") replaced the page table spinlock with a mutex, to
allow blocking allocations to satisfy lazy mapping requests.

Unfortunately, it turns out that IOMMU mappings are created from atomic
context (e.g. spinlock held during a dma_map), so this change doesn't
really help us in practice.

This patch is a partial revert of the offending commit, bringing back
the original spinlock but replacing our page table allocations for any
levels below the pgd (which is allocated during domain init) with
GFP_ATOMIC instead of GFP_KERNEL.

Reported-by: Andreas Herrmann <andreas.herrmann@calxeda.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/arm-smmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 896a229..b066eef 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -391,7 +391,7 @@ struct arm_smmu_domain {
 	struct arm_smmu_cfg		root_cfg;
 	phys_addr_t			output_mask;
 
-	struct mutex			lock;
+	spinlock_t			lock;
 };
 
 static DEFINE_SPINLOCK(arm_smmu_devices_lock);
@@ -884,7 +884,7 @@ static int arm_smmu_domain_init(struct iommu_domain *domain)
 		goto out_free_domain;
 	smmu_domain->root_cfg.pgd = pgd;
 
-	mutex_init(&smmu_domain->lock);
+	spin_lock_init(&smmu_domain->lock);
 	domain->priv = smmu_domain;
 	return 0;
 
@@ -1116,7 +1116,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * Sanity check the domain. We don't currently support domains
 	 * that cross between different SMMU chains.
 	 */
-	mutex_lock(&smmu_domain->lock);
+	spin_lock(&smmu_domain->lock);
 	if (!smmu_domain->leaf_smmu) {
 		/* Now that we have a master, we can finalise the domain */
 		ret = arm_smmu_init_domain_context(domain, dev);
@@ -1131,7 +1131,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			dev_name(device_smmu->dev));
 		goto err_unlock;
 	}
-	mutex_unlock(&smmu_domain->lock);
+	spin_unlock(&smmu_domain->lock);
 
 	/* Looks ok, so add the device to the domain */
 	master = find_smmu_master(smmu_domain->leaf_smmu, dev->of_node);
@@ -1141,7 +1141,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return arm_smmu_domain_add_master(smmu_domain, master);
 
 err_unlock:
-	mutex_unlock(&smmu_domain->lock);
+	spin_unlock(&smmu_domain->lock);
 	return ret;
 }
 
@@ -1188,7 +1188,7 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
 
 	if (pmd_none(*pmd)) {
 		/* Allocate a new set of tables */
-		pgtable_t table = alloc_page(PGALLOC_GFP);
+		pgtable_t table = alloc_page(GFP_ATOMIC|__GFP_ZERO);
 		if (!table)
 			return -ENOMEM;
 
@@ -1290,7 +1290,7 @@ static int arm_smmu_alloc_init_pmd(struct arm_smmu_device *smmu, pud_t *pud,
 
 #ifndef __PAGETABLE_PMD_FOLDED
 	if (pud_none(*pud)) {
-		pmd = pmd_alloc_one(NULL, addr);
+		pmd = (pmd_t *)get_zeroed_page(GFP_ATOMIC);
 		if (!pmd)
 			return -ENOMEM;
 
@@ -1322,7 +1322,7 @@ static int arm_smmu_alloc_init_pud(struct arm_smmu_device *smmu, pgd_t *pgd,
 
 #ifndef __PAGETABLE_PUD_FOLDED
 	if (pgd_none(*pgd)) {
-		pud = pud_alloc_one(NULL, addr);
+		pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
 		if (!pud)
 			return -ENOMEM;
 
@@ -1376,7 +1376,7 @@ static int arm_smmu_handle_mapping(struct arm_smmu_domain *smmu_domain,
 	if (paddr & ~output_mask)
 		return -ERANGE;
 
-	mutex_lock(&smmu_domain->lock);
+	spin_lock(&smmu_domain->lock);
 	pgd += pgd_index(iova);
 	end = iova + size;
 	do {
@@ -1392,7 +1392,7 @@ static int arm_smmu_handle_mapping(struct arm_smmu_domain *smmu_domain,
 	} while (pgd++, iova != end);
 
 out_unlock:
-	mutex_unlock(&smmu_domain->lock);
+	spin_unlock(&smmu_domain->lock);
 
 	/* Ensure new page tables are visible to the hardware walker */
 	if (smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)
-- 
1.9.0

