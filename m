Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaGJN2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:28:49 -0400
Received: from 8bytes.org ([85.214.48.195]:52068 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbaGJN0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:14 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 8/9] iommu/amd: Don't hold a reference to task_struct
Date: Thu, 10 Jul 2014 15:25:49 +0200
Message-Id: <1404998750-15536-9-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:26:00 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946820861989213373
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Since we are only caring about the lifetime of the mm_struct
and not the task we can't safely keep a reference to it. The
reference is also not needed anymore, so remove that code
entirely.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 2b848c0..f7ca009 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -47,7 +47,6 @@ struct pasid_state {
 	atomic_t count;				/* Reference count */
 	unsigned mmu_notifier_count;		/* Counting nested mmu_notifier
 						   calls */
-	struct task_struct *task;		/* Task bound to this PASID */
 	struct mm_struct *mm;			/* mm_struct for the faults */
 	struct mmu_notifier mn;                 /* mmu_notifier handle */
 	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
@@ -531,7 +530,7 @@ static void do_fault(struct work_struct *work)
 	write = !!(fault->flags & PPR_FAULT_WRITE);
 
 	down_read(&fault->state->mm->mmap_sem);
-	npages = get_user_pages(fault->state->task, fault->state->mm,
+	npages = get_user_pages(NULL, fault->state->mm,
 				fault->address, 1, write, 0, &page, NULL);
 	up_read(&fault->state->mm->mmap_sem);
 
@@ -672,7 +671,6 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	spin_lock_init(&pasid_state->lock);
 
 	mm                        = get_task_mm(task);
-	pasid_state->task         = task;
 	pasid_state->mm           = mm;
 	pasid_state->device_state = dev_state;
 	pasid_state->pasid        = pasid;
-- 
1.7.9.5


