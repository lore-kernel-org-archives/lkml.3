Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3C0ItV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:49:21 -0400
Received: from 8bytes.org ([85.214.48.195]:47068 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab3C0ItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:49:16 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Andreas Degert <andreas.degert@googlemail.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH] iommu/amd: Make sure dma_ops are set for hotplug devices
Date: Wed, 27 Mar 2013 09:49:06 +0100
Message-Id: <1364374146-3021-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 09:49:14 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5152b28a23671189319139
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug introduced with commit 27c2127 that causes
devices which are hot unplugged and then hot-replugged to
not have per-device dma_ops set. This causes these devices
to not function correctly. Fixed with this patch.

Cc: stable@vger.kernel.org
Reported-by: Andreas Degert <andreas.degert@googlemail.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c1c74e0..4647b50 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2466,18 +2466,16 @@ static int device_change_notifier(struct notifier_block *nb,
 
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
-		if (dma_domain)
-			goto out;
-		dma_domain = dma_ops_domain_alloc();
-		if (!dma_domain)
-			goto out;
-		dma_domain->target_dev = devid;
-
-		spin_lock_irqsave(&iommu_pd_list_lock, flags);
-		list_add_tail(&dma_domain->list, &iommu_pd_list);
-		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
-
-		dev_data = get_dev_data(dev);
+		if (!dma_domain) {
+			dma_domain = dma_ops_domain_alloc();
+			if (!dma_domain)
+				goto out;
+			dma_domain->target_dev = devid;
+
+			spin_lock_irqsave(&iommu_pd_list_lock, flags);
+			list_add_tail(&dma_domain->list, &iommu_pd_list);
+			spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		}
 
 		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
-- 
1.7.9.5


