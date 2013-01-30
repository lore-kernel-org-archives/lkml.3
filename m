Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3A3VoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:44:00 -0500
Received: from 8bytes.org ([85.214.48.195]:56854 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab3A3Vn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:43:57 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/4] iommu: Check for valid pgsize_bitmap in iommu_map/unmap
Date: Wed, 30 Jan 2013 22:43:46 +0100
Message-Id: <1359582228-21552-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359582228-21552-1-git-send-email-joro@8bytes.org>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan 30 22:43:56 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5109941c22971965114903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the page-size bitmap is zero the code path in
iommu_map and iommu_unmap is undefined. Make it defined and
return -ENODEV in this case.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/iommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ddbdaca..622360f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -734,7 +734,8 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	size_t orig_size = size;
 	int ret = 0;
 
-	if (unlikely(domain->ops->map == NULL))
+	if (unlikely(domain->ops->unmap == NULL ||
+		     domain->ops->pgsize_bitmap == 0UL))
 		return -ENODEV;
 
 	/* find out the minimum page size supported */
@@ -808,7 +809,8 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 	size_t unmapped_page, unmapped = 0;
 	unsigned int min_pagesz;
 
-	if (unlikely(domain->ops->unmap == NULL))
+	if (unlikely(domain->ops->unmap == NULL ||
+		     domain->ops->pgsize_bitmap == 0UL))
 		return -ENODEV;
 
 	/* find out the minimum page size supported */
-- 
1.7.9.5


