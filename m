Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaGJN0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:26:18 -0400
Received: from 8bytes.org ([85.214.48.195]:52028 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbaGJN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:00 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/9] iommu/amd: Don't free pasid_state in mn_release path
Date: Thu, 10 Jul 2014 15:25:44 +0200
Message-Id: <1404998750-15536-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:25:59 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946720861139414009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The mmu_notifier state is part of pasid_state so it can't be
freed in the mn_release path. Free the pasid_state after
mmu_notifer_unregister has completed.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 1fdd22c..a621552 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -312,8 +312,6 @@ static void __unbind_pasid(struct pasid_state *pasid_state)
 
 	/* Make sure no more pending faults are in the queue */
 	flush_workqueue(iommu_wq);
-
-	put_pasid_state(pasid_state); /* Reference taken in bind() function */
 }
 
 static void unbind_pasid(struct device_state *dev_state, int pasid)
@@ -325,7 +323,7 @@ static void unbind_pasid(struct device_state *dev_state, int pasid)
 		return;
 
 	__unbind_pasid(pasid_state);
-	put_pasid_state_wait(pasid_state); /* Reference taken in this function */
+	put_pasid_state(pasid_state); /* Reference taken in this function */
 }
 
 static void free_pasid_states_level1(struct pasid_state **tbl)
@@ -371,6 +369,9 @@ static void free_pasid_states(struct device_state *dev_state)
 		 * unbind the PASID
 		 */
 		mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
+
+		put_pasid_state_wait(pasid_state); /* Reference taken in
+						      amd_iommu_pasid_bind */
 	}
 
 	if (dev_state->pasid_levels == 2)
@@ -690,6 +691,7 @@ out_unregister:
 	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 
 out_free:
+	mmput(pasid_state->mm);
 	free_pasid_state(pasid_state);
 
 out:
@@ -730,6 +732,8 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 	/* This will call the mn_release function and unbind the PASID */
 	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 
+	put_pasid_state_wait(pasid_state); /* Reference taken in
+					      amd_iommu_pasid_bind */
 out:
 	put_device_state(dev_state);
 }
-- 
1.7.9.5


