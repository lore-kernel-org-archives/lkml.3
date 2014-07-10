Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaGJN0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:26:55 -0400
Received: from 8bytes.org ([85.214.48.195]:52067 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaGJN0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:15 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 7/9] iommu/amd: Don't hold a reference to mm_struct
Date: Thu, 10 Jul 2014 15:25:48 +0200
Message-Id: <1404998750-15536-8-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:26:00 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946820861986225410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

With mmu_notifiers we don't need to hold a reference to the
mm_struct during the time the pasid is bound to a device. We
can rely on the .mn_release call back to inform us when the
mm_struct goes away.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 69a46f1..2b848c0 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -297,7 +297,6 @@ static void put_pasid_state_wait(struct pasid_state *pasid_state)
 		schedule();
 
 	finish_wait(&pasid_state->wq, &wait);
-	mmput(pasid_state->mm);
 	free_pasid_state(pasid_state);
 }
 
@@ -321,6 +320,13 @@ static void unbind_pasid(struct pasid_state *pasid_state)
 
 	/* Make sure no more pending faults are in the queue */
 	flush_workqueue(iommu_wq);
+
+	/*
+	 * No more faults are in the work queue and no new faults will be queued
+	 * from here on. We can safely set pasid_state->mm to NULL now as the
+	 * mm_struct might go away after we return.
+	 */
+	pasid_state->mm = NULL;
 }
 
 static void free_pasid_states_level1(struct pasid_state **tbl)
@@ -636,6 +642,7 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
+	struct mm_struct *mm;
 	u16 devid;
 	int ret;
 
@@ -659,12 +666,14 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	if (pasid_state == NULL)
 		goto out;
 
+
 	atomic_set(&pasid_state->count, 1);
 	init_waitqueue_head(&pasid_state->wq);
 	spin_lock_init(&pasid_state->lock);
 
+	mm                        = get_task_mm(task);
 	pasid_state->task         = task;
-	pasid_state->mm           = get_task_mm(task);
+	pasid_state->mm           = mm;
 	pasid_state->device_state = dev_state;
 	pasid_state->pasid        = pasid;
 	pasid_state->invalid      = false;
@@ -673,7 +682,7 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	if (pasid_state->mm == NULL)
 		goto out_free;
 
-	mmu_notifier_register(&pasid_state->mn, pasid_state->mm);
+	mmu_notifier_register(&pasid_state->mn, mm);
 
 	ret = set_pasid_state(dev_state, pasid_state, pasid);
 	if (ret)
@@ -684,16 +693,23 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	if (ret)
 		goto out_clear_state;
 
+	/*
+	 * Drop the reference to the mm_struct here. We rely on the
+	 * mmu_notifier release call-back to inform us when the mm
+	 * is going away.
+	 */
+	mmput(mm);
+
 	return 0;
 
 out_clear_state:
 	clear_pasid_state(dev_state, pasid);
 
 out_unregister:
-	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
+	mmu_notifier_unregister(&pasid_state->mn, mm);
 
 out_free:
-	mmput(pasid_state->mm);
+	mmput(mm);
 	free_pasid_state(pasid_state);
 
 out:
@@ -734,8 +750,18 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 	/* Clear the pasid state so that the pasid can be re-used */
 	clear_pasid_state(dev_state, pasid_state->pasid);
 
-	/* This will call the mn_release function and unbind the PASID */
-	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
+	/*
+	 * Check if pasid_state->mm is still valid. If mn_release has already
+	 * run it will be NULL and we can't (and don't need to) call
+	 * mmu_notifier_unregister() on it anymore.
+	 */
+	if (pasid_state->mm) {
+		/*
+		 * This will call the mn_release function and unbind
+		 * the PASID.
+		 */
+		mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
+	}
 
 	put_pasid_state_wait(pasid_state); /* Reference taken in
 					      amd_iommu_pasid_bind */
-- 
1.7.9.5


