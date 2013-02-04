Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3BDNTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:19:09 -0500
Received: from 8bytes.org ([85.214.48.195]:33806 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab3BDNTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:19:03 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>, Stuart Yoder <b08248@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/5] iommu: Check for valid pgsize_bitmap in iommu_map/unmap
Date: Mon,  4 Feb 2013 14:18:40 +0100
Message-Id: <1359983924-28952-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359983924-28952-1-git-send-email-joro@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 14:19:02 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fb54622973387112397
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


