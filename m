Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3HOLLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:11:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32581 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3HOLLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:11:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="42396943"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 02/10] swiotlb-xen: replace dma_length with sg_dma_len() macro
Date: Thu, 15 Aug 2013 12:10:46 +0100
Message-ID: <1376565054-24153-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb-xen has an implicit dependency on CONFIG_NEED_SG_DMA_LENGTH.
Remove it by replacing dma_length with sg_dma_len.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index aadffcf..1b2277c 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -506,13 +506,13 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				   to do proper error handling. */
 				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
 							   attrs);
-				sgl[0].dma_length = 0;
+				sg_dma_len(sgl) = 0;
 				return DMA_ERROR_CODE;
 			}
 			sg->dma_address = xen_phys_to_bus(map);
 		} else
 			sg->dma_address = dev_addr;
-		sg->dma_length = sg->length;
+		sg_dma_len(sg) = sg->length;
 	}
 	return nelems;
 }
@@ -533,7 +533,7 @@ xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i)
-		xen_unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+		xen_unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
 
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
@@ -555,7 +555,7 @@ xen_swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i)
 		xen_swiotlb_sync_single(hwdev, sg->dma_address,
-					sg->dma_length, dir, target);
+					sg_dma_len(sg), dir, target);
 }
 
 void
-- 
1.7.2.5

