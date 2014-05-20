Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaETVSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:18:36 -0400
Received: from 8bytes.org ([85.214.48.195]:56072 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaETVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:18:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jay.Cornwall@amd.com,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4/5] iommu/amd: Remove IOMMUv2 pasid_state_list
Date: Tue, 20 May 2014 23:18:25 +0200
Message-Id: <1400620706-21031-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400620706-21031-1-git-send-email-joro@8bytes.org>
References: <1400620706-21031-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 20 23:18:31 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537bc6a720861733518498
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This list was only used for the task_exit notifier function.
Now that it is gone we can remove it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index c06a29a..d9309a0 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -86,10 +86,6 @@ struct fault {
 static LIST_HEAD(state_list);
 static spinlock_t state_lock;
 
-/* List and lock for all pasid_states */
-static LIST_HEAD(pasid_state_list);
-static DEFINE_SPINLOCK(ps_lock);
-
 static struct workqueue_struct *iommu_wq;
 
 /*
@@ -171,25 +167,6 @@ static void put_device_state_wait(struct device_state *dev_state)
 	free_device_state(dev_state);
 }
 
-static void link_pasid_state(struct pasid_state *pasid_state)
-{
-	spin_lock(&ps_lock);
-	list_add_tail(&pasid_state->list, &pasid_state_list);
-	spin_unlock(&ps_lock);
-}
-
-static void __unlink_pasid_state(struct pasid_state *pasid_state)
-{
-	list_del(&pasid_state->list);
-}
-
-static void unlink_pasid_state(struct pasid_state *pasid_state)
-{
-	spin_lock(&ps_lock);
-	__unlink_pasid_state(pasid_state);
-	spin_unlock(&ps_lock);
-}
-
 /* Must be called under dev_state->lock */
 static struct pasid_state **__get_pasid_state_ptr(struct device_state *dev_state,
 						  int pasid, bool alloc)
@@ -346,7 +323,6 @@ static void unbind_pasid(struct device_state *dev_state, int pasid)
 	if (pasid_state == NULL)
 		return;
 
-	unlink_pasid_state(pasid_state);
 	__unbind_pasid(pasid_state);
 	put_pasid_state_wait(pasid_state); /* Reference taken in this function */
 }
@@ -687,8 +663,6 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	if (ret)
 		goto out_clear_state;
 
-	link_pasid_state(pasid_state);
-
 	return 0;
 
 out_clear_state:
-- 
1.7.9.5


