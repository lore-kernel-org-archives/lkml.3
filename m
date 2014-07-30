Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaG3OEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:04:53 -0400
Received: from 8bytes.org ([81.169.241.247]:59119 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbaG3OEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:04:52 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/4] iommu/amd: Fix device_state reference counting
Date: Wed, 30 Jul 2014 16:04:39 +0200
Message-Id: <1406729080-2486-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406729080-2486-1-git-send-email-joro@8bytes.org>
References: <1406729080-2486-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The references to the device state are not dropped
everywhere. This might cause a dead-lock in
amd_iommu_free_device(). Fix it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 524fd67..2de13be 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -368,6 +368,9 @@ static void free_pasid_states(struct device_state *dev_state)
 
 		put_pasid_state_wait(pasid_state); /* Reference taken in
 						      amd_iommu_pasid_bind */
+
+		/* Drop reference taken in amd_iommu_bind_pasid */
+		put_device_state(dev_state);
 	}
 
 	if (dev_state->pasid_levels == 2)
@@ -748,6 +751,10 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 	put_pasid_state_wait(pasid_state); /* Reference taken in
 					      amd_iommu_pasid_bind */
 out:
+	/* Drop reference taken in this function */
+	put_device_state(dev_state);
+
+	/* Drop reference taken in amd_iommu_bind_pasid */
 	put_device_state(dev_state);
 }
 EXPORT_SYMBOL(amd_iommu_unbind_pasid);
-- 
1.9.1

