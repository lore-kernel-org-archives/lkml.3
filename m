Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaCDU5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:57:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbaCDUEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann@calxeda.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.13 138/172] iommu/arm-smmu: really fix page table locking
Date: Tue,  4 Mar 2014 12:03:42 -0800
Message-Id: <20140304200304.122780867@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -392,7 +392,7 @@ struct arm_smmu_domain {
 	struct arm_smmu_cfg		root_cfg;
 	phys_addr_t			output_mask;
 
-	struct mutex			lock;
+	spinlock_t			lock;
 };
 
 static DEFINE_SPINLOCK(arm_smmu_devices_lock);
@@ -900,7 +900,7 @@ static int arm_smmu_domain_init(struct i
 		goto out_free_domain;
 	smmu_domain->root_cfg.pgd = pgd;
 
-	mutex_init(&smmu_domain->lock);
+	spin_lock_init(&smmu_domain->lock);
 	domain->priv = smmu_domain;
 	return 0;
 
@@ -1137,7 +1137,7 @@ static int arm_smmu_attach_dev(struct io
 	 * Sanity check the domain. We don't currently support domains
 	 * that cross between different SMMU chains.
 	 */
-	mutex_lock(&smmu_domain->lock);
+	spin_lock(&smmu_domain->lock);
 	if (!smmu_domain->leaf_smmu) {
 		/* Now that we have a master, we can finalise the domain */
 		ret = arm_smmu_init_domain_context(domain, dev);
@@ -1152,7 +1152,7 @@ static int arm_smmu_attach_dev(struct io
 			dev_name(device_smmu->dev));
 		goto err_unlock;
 	}
-	mutex_unlock(&smmu_domain->lock);
+	spin_unlock(&smmu_domain->lock);
 
 	/* Looks ok, so add the device to the domain */
 	master = find_smmu_master(smmu_domain->leaf_smmu, dev->of_node);
@@ -1162,7 +1162,7 @@ static int arm_smmu_attach_dev(struct io
 	return arm_smmu_domain_add_master(smmu_domain, master);
 
 err_unlock:
-	mutex_unlock(&smmu_domain->lock);
+	spin_unlock(&smmu_domain->lock);
 	return ret;
 }
 
@@ -1209,7 +1209,7 @@ static int arm_smmu_alloc_init_pte(struc
 
 	if (pmd_none(*pmd)) {
 		/* Allocate a new set of tables */
-		pgtable_t table = alloc_page(PGALLOC_GFP);
+		pgtable_t table = alloc_page(GFP_ATOMIC|__GFP_ZERO);
 		if (!table)
 			return -ENOMEM;
 
@@ -1314,7 +1314,7 @@ static int arm_smmu_alloc_init_pmd(struc
 
 #ifndef __PAGETABLE_PMD_FOLDED
 	if (pud_none(*pud)) {
-		pmd = pmd_alloc_one(NULL, addr);
+		pmd = (pmd_t *)get_zeroed_page(GFP_ATOMIC);
 		if (!pmd)
 			return -ENOMEM;
 
@@ -1346,7 +1346,7 @@ static int arm_smmu_alloc_init_pud(struc
 
 #ifndef __PAGETABLE_PUD_FOLDED
 	if (pgd_none(*pgd)) {
-		pud = pud_alloc_one(NULL, addr);
+		pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
 		if (!pud)
 			return -ENOMEM;
 
@@ -1400,7 +1400,7 @@ static int arm_smmu_handle_mapping(struc
 	if (paddr & ~output_mask)
 		return -ERANGE;
 
-	mutex_lock(&smmu_domain->lock);
+	spin_lock(&smmu_domain->lock);
 	pgd += pgd_index(iova);
 	end = iova + size;
 	do {
@@ -1416,7 +1416,7 @@ static int arm_smmu_handle_mapping(struc
 	} while (pgd++, iova != end);
 
 out_unlock:
-	mutex_unlock(&smmu_domain->lock);
+	spin_unlock(&smmu_domain->lock);
 
 	/* Ensure new page tables are visible to the hardware walker */
 	if (smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)


