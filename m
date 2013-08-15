Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3HOLLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:11:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32581 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3HOLLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:11:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="42396942"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, EUNBONG SONG <eunb.song@samsung.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 01/10] swiotlb: replace dma_length with sg_dma_len() macro
Date: Thu, 15 Aug 2013 12:10:45 +0100
Message-ID: <1376565054-24153-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: EUNBONG SONG <eunb.song@samsung.com>

This patch replace dma_length in "lib/swiotlb.c" to sg_dma_len() macro,
because the build error can occur if CONFIG_NEED_SG_DMA_LENGTH is not
set, and CONFIG_SWIOTLB is set.

Singed-off-by: EunBong Song <eunb.song@samsung.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 lib/swiotlb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d23762e..4e8686c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -870,13 +870,13 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				swiotlb_full(hwdev, sg->length, dir, 0);
 				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
 						       attrs);
-				sgl[0].dma_length = 0;
+				sg_dma_len(sgl) = 0;
 				return 0;
 			}
 			sg->dma_address = phys_to_dma(hwdev, map);
 		} else
 			sg->dma_address = dev_addr;
-		sg->dma_length = sg->length;
+		sg_dma_len(sg) = sg->length;
 	}
 	return nelems;
 }
@@ -904,7 +904,7 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i)
-		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+		unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
 
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -934,7 +934,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i)
 		swiotlb_sync_single(hwdev, sg->dma_address,
-				    sg->dma_length, dir, target);
+				    sg_dma_len(sg), dir, target);
 }
 
 void
-- 
1.7.2.5

