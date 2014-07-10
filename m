Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaGJNaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:30:52 -0400
Received: from 8bytes.org ([85.214.48.195]:52035 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaGJN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:00 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4/9] iommu/amd: Get rid of __unbind_pasid
Date: Thu, 10 Jul 2014 15:25:45 +0200
Message-Id: <1404998750-15536-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:25:59 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946720865517915711
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Unbind_pasid is only called from mn_release which already
has the pasid_state. Use this to simplify the unbind_pasid
path and get rid of __unbind_pasid.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index a621552..574c71b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -99,7 +99,6 @@ static struct workqueue_struct *iommu_wq;
 static u64 *empty_page_table;
 
 static void free_pasid_states(struct device_state *dev_state);
-static void unbind_pasid(struct device_state *dev_state, int pasid);
 
 static u16 device_id(struct pci_dev *pdev)
 {
@@ -301,7 +300,7 @@ static void put_pasid_state_wait(struct pasid_state *pasid_state)
 	free_pasid_state(pasid_state);
 }
 
-static void __unbind_pasid(struct pasid_state *pasid_state)
+static void unbind_pasid(struct pasid_state *pasid_state)
 {
 	struct iommu_domain *domain;
 
@@ -314,18 +313,6 @@ static void __unbind_pasid(struct pasid_state *pasid_state)
 	flush_workqueue(iommu_wq);
 }
 
-static void unbind_pasid(struct device_state *dev_state, int pasid)
-{
-	struct pasid_state *pasid_state;
-
-	pasid_state = get_pasid_state(dev_state, pasid);
-	if (pasid_state == NULL)
-		return;
-
-	__unbind_pasid(pasid_state);
-	put_pasid_state(pasid_state); /* Reference taken in this function */
-}
-
 static void free_pasid_states_level1(struct pasid_state **tbl)
 {
 	int i;
@@ -480,7 +467,7 @@ static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	if (pasid_state->device_state->inv_ctx_cb)
 		dev_state->inv_ctx_cb(dev_state->pdev, pasid_state->pasid);
 
-	unbind_pasid(dev_state, pasid_state->pasid);
+	unbind_pasid(pasid_state);
 }
 
 static struct mmu_notifier_ops iommu_mn = {
-- 
1.7.9.5


