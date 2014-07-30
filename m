Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaG3OEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:04:54 -0400
Received: from 8bytes.org ([81.169.241.247]:59116 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaG3OEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:04:52 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/4] iommu/amd: Don't set pasid_state->mm to NULL in unbind_pasid
Date: Wed, 30 Jul 2014 16:04:37 +0200
Message-Id: <1406729080-2486-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

With calling te mmu_notifier_register function we hold a
reference to the mm_struct that needs to be released in
mmu_notifier_unregister. This is true even if the notifier
was already unregistered from exit_mmap and the .release
call-back has already run.

So make sure we call mmu_notifier_unregister unconditionally
in amd_iommu_unbind_pasid.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index a195c78..2b7de88 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -320,13 +320,6 @@ static void unbind_pasid(struct pasid_state *pasid_state)
 
 	/* Make sure no more pending faults are in the queue */
 	flush_workqueue(iommu_wq);
-
-	/*
-	 * No more faults are in the work queue and no new faults will be queued
-	 * from here on. We can safely set pasid_state->mm to NULL now as the
-	 * mm_struct might go away after we return.
-	 */
-	pasid_state->mm = NULL;
 }
 
 static void free_pasid_states_level1(struct pasid_state **tbl)
@@ -756,17 +749,10 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 	clear_pasid_state(dev_state, pasid_state->pasid);
 
 	/*
-	 * Check if pasid_state->mm is still valid. If mn_release has already
-	 * run it will be NULL and we can't (and don't need to) call
-	 * mmu_notifier_unregister() on it anymore.
+	 * Call mmu_notifier_unregister to drop our reference
+	 * to pasid_state->mm
 	 */
-	if (pasid_state->mm) {
-		/*
-		 * This will call the mn_release function and unbind
-		 * the PASID.
-		 */
-		mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
-	}
+	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 
 	put_pasid_state_wait(pasid_state); /* Reference taken in
 					      amd_iommu_pasid_bind */
-- 
1.9.1

