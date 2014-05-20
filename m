Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaETVTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:19:43 -0400
Received: from 8bytes.org ([85.214.48.195]:56071 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbaETVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:18:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jay.Cornwall@amd.com,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/5] iommu/amd: Implement mmu_notifier_release call-back
Date: Tue, 20 May 2014 23:18:24 +0200
Message-Id: <1400620706-21031-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400620706-21031-1-git-send-email-joro@8bytes.org>
References: <1400620706-21031-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 20 23:18:31 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537bc6a720868073542697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Since mmu_notifier call-backs can sleep (because they use
SRCU now) we can use them to tear down PASID mappings. This
allows us to finally remove the hack to use the task_exit
notifier from oprofile to get notified when a process dies.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   91 ++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 05e93f1..c06a29a 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -101,7 +101,6 @@ static u64 *empty_page_table;
 
 static void free_pasid_states(struct device_state *dev_state);
 static void unbind_pasid(struct device_state *dev_state, int pasid);
-static int task_exit(struct notifier_block *nb, unsigned long e, void *data);
 
 static u16 device_id(struct pci_dev *pdev)
 {
@@ -172,10 +171,6 @@ static void put_device_state_wait(struct device_state *dev_state)
 	free_device_state(dev_state);
 }
 
-static struct notifier_block profile_nb = {
-	.notifier_call = task_exit,
-};
-
 static void link_pasid_state(struct pasid_state *pasid_state)
 {
 	spin_lock(&ps_lock);
@@ -393,7 +388,12 @@ static void free_pasid_states(struct device_state *dev_state)
 			continue;
 
 		put_pasid_state(pasid_state);
-		unbind_pasid(dev_state, i);
+
+		/*
+		 * This will call the mn_release function and
+		 * unbind the PASID
+		 */
+		mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 	}
 
 	if (dev_state->pasid_levels == 2)
@@ -475,7 +475,24 @@ static void mn_invalidate_range_end(struct mmu_notifier *mn,
 				  __pa(pasid_state->mm->pgd));
 }
 
+static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
+{
+	struct pasid_state *pasid_state;
+	struct device_state *dev_state;
+
+	might_sleep();
+
+	pasid_state = mn_to_state(mn);
+	dev_state   = pasid_state->device_state;
+
+	if (pasid_state->device_state->inv_ctx_cb)
+		dev_state->inv_ctx_cb(dev_state->pdev, pasid_state->pasid);
+
+	unbind_pasid(dev_state, pasid_state->pasid);
+}
+
 static struct mmu_notifier_ops iommu_mn = {
+	.release		= mn_release,
 	.clear_flush_young      = mn_clear_flush_young,
 	.change_pte             = mn_change_pte,
 	.invalidate_page        = mn_invalidate_page,
@@ -618,53 +635,6 @@ static struct notifier_block ppr_nb = {
 	.notifier_call = ppr_notifier,
 };
 
-static int task_exit(struct notifier_block *nb, unsigned long e, void *data)
-{
-	struct pasid_state *pasid_state;
-	struct task_struct *task;
-
-	task = data;
-
-	/*
-	 * Using this notifier is a hack - but there is no other choice
-	 * at the moment. What I really want is a sleeping notifier that
-	 * is called when an MM goes down. But such a notifier doesn't
-	 * exist yet. The notifier needs to sleep because it has to make
-	 * sure that the device does not use the PASID and the address
-	 * space anymore before it is destroyed. This includes waiting
-	 * for pending PRI requests to pass the workqueue. The
-	 * MMU-Notifiers would be a good fit, but they use RCU and so
-	 * they are not allowed to sleep. Lets see how we can solve this
-	 * in a more intelligent way in the future.
-	 */
-again:
-	spin_lock(&ps_lock);
-	list_for_each_entry(pasid_state, &pasid_state_list, list) {
-		struct device_state *dev_state;
-		int pasid;
-
-		if (pasid_state->task != task)
-			continue;
-
-		/* Drop Lock and unbind */
-		spin_unlock(&ps_lock);
-
-		dev_state = pasid_state->device_state;
-		pasid     = pasid_state->pasid;
-
-		if (pasid_state->device_state->inv_ctx_cb)
-			dev_state->inv_ctx_cb(dev_state->pdev, pasid);
-
-		unbind_pasid(dev_state, pasid);
-
-		/* Task may be in the list multiple times */
-		goto again;
-	}
-	spin_unlock(&ps_lock);
-
-	return NOTIFY_OK;
-}
-
 int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 			 struct task_struct *task)
 {
@@ -739,6 +709,7 @@ EXPORT_SYMBOL(amd_iommu_bind_pasid);
 
 void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 {
+	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
 	u16 devid;
 
@@ -755,7 +726,17 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 	if (pasid < 0 || pasid >= dev_state->max_pasids)
 		goto out;
 
-	unbind_pasid(dev_state, pasid);
+	pasid_state = get_pasid_state(dev_state, pasid);
+	if (pasid_state == NULL)
+		goto out;
+	/*
+	 * Drop reference taken here. We are safe because we still hold
+	 * the reference taken in the amd_iommu_bind_pasid function.
+	 */
+	put_pasid_state(pasid_state);
+
+	/* This will call the mn_release function and unbind the PASID */
+	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 
 out:
 	put_device_state(dev_state);
@@ -961,7 +942,6 @@ static int __init amd_iommu_v2_init(void)
 		goto out_destroy_wq;
 
 	amd_iommu_register_ppr_notifier(&ppr_nb);
-	profile_event_register(PROFILE_TASK_EXIT, &profile_nb);
 
 	return 0;
 
@@ -980,7 +960,6 @@ static void __exit amd_iommu_v2_exit(void)
 	if (!amd_iommu_v2_supported())
 		return;
 
-	profile_event_unregister(PROFILE_TASK_EXIT, &profile_nb);
 	amd_iommu_unregister_ppr_notifier(&ppr_nb);
 
 	flush_workqueue(iommu_wq);
-- 
1.7.9.5


