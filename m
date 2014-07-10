Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaGJN04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:26:56 -0400
Received: from 8bytes.org ([85.214.48.195]:52069 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaGJN0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:15 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 9/9] iommu/amd: Don't call the inv_ctx_cb when pasid is not set up
Date: Thu, 10 Jul 2014 15:25:50 +0200
Message-Id: <1404998750-15536-10-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:26:00 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946820867610325201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

On the error path of amd_iommu_bind_pasid() we call
mmu_notifier_unregister() for cleanup. This calls
mn_release() which calls the users inv_ctx_cb function if
one is available. Since the pasid is not set up yet there is
nothing the user can to tear down in this call-back. So
don't call inv_ctx_cb on the error path of
amd_iommu_unbind_pasid() and make life of the users simpler.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index f7ca009..a195c78 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -52,7 +52,8 @@ struct pasid_state {
 	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
 	struct device_state *device_state;	/* Link to our device_state */
 	int pasid;				/* PASID index */
-	bool invalid;				/* Used during teardown */
+	bool invalid;				/* Used during setup and
+						   teardown of the pasid */
 	spinlock_t lock;			/* Protect pri_queues and
 						   mmu_notifer_count */
 	wait_queue_head_t wq;			/* To wait for count == 0 */
@@ -473,13 +474,15 @@ static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
+	bool run_inv_ctx_cb;
 
 	might_sleep();
 
-	pasid_state = mn_to_state(mn);
-	dev_state   = pasid_state->device_state;
+	pasid_state    = mn_to_state(mn);
+	dev_state      = pasid_state->device_state;
+	run_inv_ctx_cb = !pasid_state->invalid;
 
-	if (pasid_state->device_state->inv_ctx_cb)
+	if (run_inv_ctx_cb && pasid_state->device_state->inv_ctx_cb)
 		dev_state->inv_ctx_cb(dev_state->pdev, pasid_state->pasid);
 
 	unbind_pasid(pasid_state);
@@ -674,7 +677,8 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	pasid_state->mm           = mm;
 	pasid_state->device_state = dev_state;
 	pasid_state->pasid        = pasid;
-	pasid_state->invalid      = false;
+	pasid_state->invalid      = true; /* Mark as valid only if we are
+					     done with setting up the pasid */
 	pasid_state->mn.ops       = &iommu_mn;
 
 	if (pasid_state->mm == NULL)
@@ -691,6 +695,9 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	if (ret)
 		goto out_clear_state;
 
+	/* Now we are ready to handle faults */
+	pasid_state->invalid = false;
+
 	/*
 	 * Drop the reference to the mm_struct here. We rely on the
 	 * mmu_notifier release call-back to inform us when the mm
-- 
1.7.9.5


