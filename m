Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaETVSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:18:38 -0400
Received: from 8bytes.org ([85.214.48.195]:56082 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaETVSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:18:34 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jay.Cornwall@amd.com,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5/5] iommu/amd: Handle parallel invalidate_range_start/end calls correctly
Date: Tue, 20 May 2014 23:18:26 +0200
Message-Id: <1400620706-21031-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400620706-21031-1-git-send-email-joro@8bytes.org>
References: <1400620706-21031-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 20 23:18:32 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537bc6a820862095366291
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add a counter to the pasid_state so that we do not restore
the original page-table before all invalidate_range_start
to invalidate_range_end sections have finished.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu_v2.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index d9309a0..9ed9da2 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -45,6 +45,8 @@ struct pri_queue {
 struct pasid_state {
 	struct list_head list;			/* For global state-list */
 	atomic_t count;				/* Reference count */
+	atomic_t mmu_notifier_count;		/* Counting nested mmu_notifier
+						   calls */
 	struct task_struct *task;		/* Task bound to this PASID */
 	struct mm_struct *mm;			/* mm_struct for the faults */
 	struct mmu_notifier mn;                 /* mmu_otifier handle */
@@ -433,8 +435,11 @@ static void mn_invalidate_range_start(struct mmu_notifier *mn,
 	pasid_state = mn_to_state(mn);
 	dev_state   = pasid_state->device_state;
 
-	amd_iommu_domain_set_gcr3(dev_state->domain, pasid_state->pasid,
-				  __pa(empty_page_table));
+	if (atomic_add_return(1, &pasid_state->mmu_notifier_count) == 1) {
+		amd_iommu_domain_set_gcr3(dev_state->domain,
+					  pasid_state->pasid,
+					  __pa(empty_page_table));
+	}
 }
 
 static void mn_invalidate_range_end(struct mmu_notifier *mn,
@@ -447,8 +452,11 @@ static void mn_invalidate_range_end(struct mmu_notifier *mn,
 	pasid_state = mn_to_state(mn);
 	dev_state   = pasid_state->device_state;
 
-	amd_iommu_domain_set_gcr3(dev_state->domain, pasid_state->pasid,
-				  __pa(pasid_state->mm->pgd));
+	if (atomic_dec_and_test(&pasid_state->mmu_notifier_count)) {
+		amd_iommu_domain_set_gcr3(dev_state->domain,
+					  pasid_state->pasid,
+					  __pa(pasid_state->mm->pgd));
+	}
 }
 
 static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -640,6 +648,7 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 		goto out;
 
 	atomic_set(&pasid_state->count, 1);
+	atomic_set(&pasid_state->mmu_notifier_count, 0);
 	init_waitqueue_head(&pasid_state->wq);
 	spin_lock_init(&pasid_state->lock);
 
-- 
1.7.9.5


