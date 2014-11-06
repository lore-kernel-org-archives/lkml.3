Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaKFMkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:40:20 -0500
Received: from 8bytes.org ([81.169.241.247]:49008 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaKFMkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:40:17 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oded.Gabbay@amd.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] iommu/amd: Use new invalidate_range mmu-notifier
Date: Thu,  6 Nov 2014 13:40:08 +0100
Message-Id: <1415277608-23688-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Make use of the new invalidate_range mmu_notifier call-back
and remove the old logic of assigning an empty page-table
between invalidate_range_start and invalidate_range_end.

Tested-by: Oded Gabbay <oded.gabbay@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu_v2.c | 61 +++++++-------------------------------------
 1 file changed, 9 insertions(+), 52 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 90d734b..f724bdc 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -92,13 +92,6 @@ static spinlock_t state_lock;
 
 static struct workqueue_struct *iommu_wq;
 
-/*
- * Empty page table - Used between
- * mmu_notifier_invalidate_range_start and
- * mmu_notifier_invalidate_range_end
- */
-static u64 *empty_page_table;
-
 static void free_pasid_states(struct device_state *dev_state);
 
 static u16 device_id(struct pci_dev *pdev)
@@ -418,46 +411,21 @@ static void mn_invalidate_page(struct mmu_notifier *mn,
 	__mn_flush_page(mn, address);
 }
 
-static void mn_invalidate_range_start(struct mmu_notifier *mn,
-				      struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	struct pasid_state *pasid_state;
-	struct device_state *dev_state;
-	unsigned long flags;
-
-	pasid_state = mn_to_state(mn);
-	dev_state   = pasid_state->device_state;
-
-	spin_lock_irqsave(&pasid_state->lock, flags);
-	if (pasid_state->mmu_notifier_count == 0) {
-		amd_iommu_domain_set_gcr3(dev_state->domain,
-					  pasid_state->pasid,
-					  __pa(empty_page_table));
-	}
-	pasid_state->mmu_notifier_count += 1;
-	spin_unlock_irqrestore(&pasid_state->lock, flags);
-}
-
-static void mn_invalidate_range_end(struct mmu_notifier *mn,
-				    struct mm_struct *mm,
-				    unsigned long start, unsigned long end)
+static void mn_invalidate_range(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long start, unsigned long end)
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
-	unsigned long flags;
 
 	pasid_state = mn_to_state(mn);
 	dev_state   = pasid_state->device_state;
 
-	spin_lock_irqsave(&pasid_state->lock, flags);
-	pasid_state->mmu_notifier_count -= 1;
-	if (pasid_state->mmu_notifier_count == 0) {
-		amd_iommu_domain_set_gcr3(dev_state->domain,
-					  pasid_state->pasid,
-					  __pa(pasid_state->mm->pgd));
-	}
-	spin_unlock_irqrestore(&pasid_state->lock, flags);
+	if ((start ^ (end - 1)) < PAGE_SIZE)
+		amd_iommu_flush_page(dev_state->domain, pasid_state->pasid,
+				     start);
+	else
+		amd_iommu_flush_tlb(dev_state->domain, pasid_state->pasid);
 }
 
 static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -482,8 +450,7 @@ static struct mmu_notifier_ops iommu_mn = {
 	.release		= mn_release,
 	.clear_flush_young      = mn_clear_flush_young,
 	.invalidate_page        = mn_invalidate_page,
-	.invalidate_range_start = mn_invalidate_range_start,
-	.invalidate_range_end   = mn_invalidate_range_end,
+	.invalidate_range       = mn_invalidate_range,
 };
 
 static void set_pri_tag_status(struct pasid_state *pasid_state,
@@ -954,18 +921,10 @@ static int __init amd_iommu_v2_init(void)
 	if (iommu_wq == NULL)
 		goto out;
 
-	ret = -ENOMEM;
-	empty_page_table = (u64 *)get_zeroed_page(GFP_KERNEL);
-	if (empty_page_table == NULL)
-		goto out_destroy_wq;
-
 	amd_iommu_register_ppr_notifier(&ppr_nb);
 
 	return 0;
 
-out_destroy_wq:
-	destroy_workqueue(iommu_wq);
-
 out:
 	return ret;
 }
@@ -999,8 +958,6 @@ static void __exit amd_iommu_v2_exit(void)
 	}
 
 	destroy_workqueue(iommu_wq);
-
-	free_page((unsigned long)empty_page_table);
 }
 
 module_init(amd_iommu_v2_init);
-- 
1.9.1

