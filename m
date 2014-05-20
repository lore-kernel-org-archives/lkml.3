Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaETVSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:18:34 -0400
Received: from 8bytes.org ([85.214.48.195]:56067 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaETVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:18:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jay.Cornwall@amd.com,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/5] iommu/amd: Don't access IOMMUv2 state_table directly
Date: Tue, 20 May 2014 23:18:22 +0200
Message-Id: <1400620706-21031-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400620706-21031-1-git-send-email-joro@8bytes.org>
References: <1400620706-21031-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 20 23:18:31 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537bc6a720861381021248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This is a preparation for converting the state_table into a
state_list.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 5208828..8c3086a 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -111,13 +111,18 @@ static u16 device_id(struct pci_dev *pdev)
 	return devid;
 }
 
+static struct device_state *__get_device_state(u16 devid)
+{
+	return state_table[devid];
+}
+
 static struct device_state *get_device_state(u16 devid)
 {
 	struct device_state *dev_state;
 	unsigned long flags;
 
 	spin_lock_irqsave(&state_lock, flags);
-	dev_state = state_table[devid];
+	dev_state = __get_device_state(devid);
 	if (dev_state != NULL)
 		atomic_inc(&dev_state->count);
 	spin_unlock_irqrestore(&state_lock, flags);
@@ -839,7 +844,7 @@ void amd_iommu_free_device(struct pci_dev *pdev)
 
 	spin_lock_irqsave(&state_lock, flags);
 
-	dev_state = state_table[devid];
+	dev_state = __get_device_state(devid);
 	if (dev_state == NULL) {
 		spin_unlock_irqrestore(&state_lock, flags);
 		return;
@@ -872,7 +877,7 @@ int amd_iommu_set_invalid_ppr_cb(struct pci_dev *pdev,
 	spin_lock_irqsave(&state_lock, flags);
 
 	ret = -EINVAL;
-	dev_state = state_table[devid];
+	dev_state = __get_device_state(devid);
 	if (dev_state == NULL)
 		goto out_unlock;
 
@@ -903,7 +908,7 @@ int amd_iommu_set_invalidate_ctx_cb(struct pci_dev *pdev,
 	spin_lock_irqsave(&state_lock, flags);
 
 	ret = -EINVAL;
-	dev_state = state_table[devid];
+	dev_state = __get_device_state(devid);
 	if (dev_state == NULL)
 		goto out_unlock;
 
-- 
1.7.9.5


