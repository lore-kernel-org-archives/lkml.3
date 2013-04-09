Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936258Ab3DIUPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:15:35 -0400
Received: from 8bytes.org ([85.214.48.195]:36413 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936063Ab3DIUNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:33 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/9] iommu/amd: Remove map_sg_no_iommu()
Date: Tue,  9 Apr 2013 22:12:56 +0200
Message-Id: <1365538384-12426-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:32 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766c23671334119222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was intended as a fall-back if the map_sg
function is called for a device not mapped by the IOMMU.
Since the AMD IOMMU driver uses per-device dma_ops this can
never happen. So this function isn't needed anymore.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b287ca3..3b2aff0 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2839,24 +2839,6 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 }
 
 /*
- * This is a special map_sg function which is used if we should map a
- * device which is not handled by an AMD IOMMU in the system.
- */
-static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
-			   int nelems, int dir)
-{
-	struct scatterlist *s;
-	int i;
-
-	for_each_sg(sglist, s, nelems, i) {
-		s->dma_address = (dma_addr_t)sg_phys(s);
-		s->dma_length  = s->length;
-	}
-
-	return nelems;
-}
-
-/*
  * The exported map_sg function for dma_ops (handles scatter-gather
  * lists).
  */
@@ -2875,9 +2857,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	INC_STATS_COUNTER(cnt_map_sg);
 
 	domain = get_domain(dev);
-	if (PTR_ERR(domain) == -EINVAL)
-		return map_sg_no_iommu(dev, sglist, nelems, dir);
-	else if (IS_ERR(domain))
+	if (IS_ERR(domain))
 		return 0;
 
 	dma_mask = *dev->dma_mask;
-- 
1.7.9.5


