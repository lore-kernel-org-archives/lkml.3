Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbaCEPdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:33:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaCEOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 014/131] iommu/arm-smmu: fix table flushing during initial allocations
Date: Wed,  5 Mar 2014 14:22:18 +0000
Message-Id: <1394029455-23128-15-git-send-email-luis.henriques@canonical.com>
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

commit 6dd35f45b8dac827b6f9dd86f5aca6436cdd2410 upstream.

Now that we populate page tables as we traverse them ("iommu/arm-smmu:
fix pud/pmd entry fill sequence"), we need to ensure that we flush out
our zeroed tables after initial allocation, to prevent speculative TLB
fills using bogus data.

This patch adds additional calls to arm_smmu_flush_pgtable during
initial table allocation, and moves the dsb required by coherent table
walkers into the helper.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/arm-smmu.c | 51 +++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index b066eef..0b98867 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -81,7 +81,6 @@
 
 #define ARM_SMMU_PTE_CONT_SIZE		(PAGE_SIZE * ARM_SMMU_PTE_CONT_ENTRIES)
 #define ARM_SMMU_PTE_CONT_MASK		(~(ARM_SMMU_PTE_CONT_SIZE - 1))
-#define ARM_SMMU_PTE_HWTABLE_SIZE	(PTRS_PER_PTE * sizeof(pte_t))
 
 /* Stage-1 PTE */
 #define ARM_SMMU_PTE_AP_UNPRIV		(((pteval_t)1) << 6)
@@ -605,6 +604,28 @@ static irqreturn_t arm_smmu_global_fault(int irq, void *dev)
 	return IRQ_NONE;
 }
 
+static void arm_smmu_flush_pgtable(struct arm_smmu_device *smmu, void *addr,
+				   size_t size)
+{
+	unsigned long offset = (unsigned long)addr & ~PAGE_MASK;
+
+
+	/* Ensure new page tables are visible to the hardware walker */
+	if (smmu->features & ARM_SMMU_FEAT_COHERENT_WALK) {
+		dsb();
+	} else {
+		/*
+		 * If the SMMU can't walk tables in the CPU caches, treat them
+		 * like non-coherent DMA since we need to flush the new entries
+		 * all the way out to memory. There's no possibility of
+		 * recursion here as the SMMU table walker will not be wired
+		 * through another SMMU.
+		 */
+		dma_map_page(smmu->dev, virt_to_page(addr), offset, size,
+				DMA_TO_DEVICE);
+	}
+}
+
 static void arm_smmu_init_context_bank(struct arm_smmu_domain *smmu_domain)
 {
 	u32 reg;
@@ -687,6 +708,8 @@ static void arm_smmu_init_context_bank(struct arm_smmu_domain *smmu_domain)
 	}
 
 	/* TTBR0 */
+	arm_smmu_flush_pgtable(smmu, root_cfg->pgd,
+			       PTRS_PER_PGD * sizeof(pgd_t));
 	reg = __pa(root_cfg->pgd);
 #ifndef __BIG_ENDIAN
 	writel_relaxed(reg, cb_base + ARM_SMMU_CB_TTBR0_LO);
@@ -1155,23 +1178,6 @@ static void arm_smmu_detach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_domain_remove_master(smmu_domain, master);
 }
 
-static void arm_smmu_flush_pgtable(struct arm_smmu_device *smmu, void *addr,
-				   size_t size)
-{
-	unsigned long offset = (unsigned long)addr & ~PAGE_MASK;
-
-	/*
-	 * If the SMMU can't walk tables in the CPU caches, treat them
-	 * like non-coherent DMA since we need to flush the new entries
-	 * all the way out to memory. There's no possibility of recursion
-	 * here as the SMMU table walker will not be wired through another
-	 * SMMU.
-	 */
-	if (!(smmu->features & ARM_SMMU_FEAT_COHERENT_WALK))
-		dma_map_page(smmu->dev, virt_to_page(addr), offset, size,
-			     DMA_TO_DEVICE);
-}
-
 static bool arm_smmu_pte_is_contiguous_range(unsigned long addr,
 					     unsigned long end)
 {
@@ -1192,8 +1198,7 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
 		if (!table)
 			return -ENOMEM;
 
-		arm_smmu_flush_pgtable(smmu, page_address(table),
-				       ARM_SMMU_PTE_HWTABLE_SIZE);
+		arm_smmu_flush_pgtable(smmu, page_address(table), PAGE_SIZE);
 		pgtable_page_ctor(table);
 		pmd_populate(NULL, pmd, table);
 		arm_smmu_flush_pgtable(smmu, pmd, sizeof(*pmd));
@@ -1294,6 +1299,7 @@ static int arm_smmu_alloc_init_pmd(struct arm_smmu_device *smmu, pud_t *pud,
 		if (!pmd)
 			return -ENOMEM;
 
+		arm_smmu_flush_pgtable(smmu, pmd, PAGE_SIZE);
 		pud_populate(NULL, pud, pmd);
 		arm_smmu_flush_pgtable(smmu, pud, sizeof(*pud));
 
@@ -1326,6 +1332,7 @@ static int arm_smmu_alloc_init_pud(struct arm_smmu_device *smmu, pgd_t *pgd,
 		if (!pud)
 			return -ENOMEM;
 
+		arm_smmu_flush_pgtable(smmu, pud, PAGE_SIZE);
 		pgd_populate(NULL, pgd, pud);
 		arm_smmu_flush_pgtable(smmu, pgd, sizeof(*pgd));
 
@@ -1394,10 +1401,6 @@ static int arm_smmu_handle_mapping(struct arm_smmu_domain *smmu_domain,
 out_unlock:
 	spin_unlock(&smmu_domain->lock);
 
-	/* Ensure new page tables are visible to the hardware walker */
-	if (smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)
-		dsb();
-
 	return ret;
 }
 
-- 
1.9.0

