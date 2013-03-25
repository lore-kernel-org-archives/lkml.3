Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3CYIVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:21:42 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:14289 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab3CYIVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:21:41 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: lizhenhua@hp.com, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@kernel.org>, Donald Dutile <ddutile@redhat.com>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] iommu: dmar_fault should only clear PPF/PFO field.
Date: Mon, 25 Mar 2013 16:20:52 +0800
Message-Id: <1364199652-10090-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there is a dmar irq, dmar_fault is called and all of the fields 
in FSTS are cleared. But ICE/IQE/ITE should not be cleared here, 
they need to be processed and cleared in function qi_check_fault.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/dmar.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index e5cdaf8..d620117 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1204,7 +1204,7 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 
 	/* TBD: ignore advanced fault log currently */
 	if (!(fault_status & DMA_FSTS_PPF))
-		goto clear_rest;
+		goto unlock_exit;
 
 	fault_index = dma_fsts_fault_record_index(fault_status);
 	reg = cap_fault_reg_offset(iommu->cap);
@@ -1245,11 +1245,12 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 			fault_index = 0;
 		raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	}
-clear_rest:
-	/* clear all the other faults */
-	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
-	writel(fault_status, iommu->reg + DMAR_FSTS_REG);
 
+	writel(DMA_FSTS_PPF, iommu->reg + DMAR_FSTS_REG);
+	if (fault_status & DMA_FSTS_PFO)
+		writel(DMA_FSTS_PFO, iommu->reg + DMAR_FSTS_REG);
+
+unlock_exit:
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 	return IRQ_HANDLED;
 }
@@ -1297,6 +1298,7 @@ int __init enable_drhd_fault_handling(void)
 	for_each_drhd_unit(drhd) {
 		int ret;
 		struct intel_iommu *iommu = drhd->iommu;
+		u32 fault_status;
 		ret = dmar_set_interrupt(iommu);
 
 		if (ret) {
@@ -1309,6 +1311,8 @@ int __init enable_drhd_fault_handling(void)
 		 * Clear any previous faults.
 		 */
 		dmar_fault(iommu->irq, iommu);
+		fault_status = readl(iommu->reg + DMAR_FSTS_REG);
+		writel(fault_status, iommu->reg + DMAR_FSTS_REG);
 	}
 
 	return 0;
-- 
1.7.10.4

