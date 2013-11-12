Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3KLONe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:13:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61746 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab3KLONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:13:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,685,1378857600"; 
   d="scan'208";a="71018577"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/2] swiotlb-xen: add missing xen_dma_map_page call
Date: Tue, 12 Nov 2013 14:11:59 +0000
Message-ID: <1384265520-6833-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb-xen is missing a xen_dma_map_page call in
xen_swiotlb_map_sg_attrs, in the slow path.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index a224bc7..1eac073 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -555,6 +555,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				sg_dma_len(sgl) = 0;
 				return 0;
 			}
+			xen_dma_map_page(hwdev, pfn_to_page(map >> PAGE_SHIFT),
+						map & ~PAGE_MASK,
+						sg->length,
+						dir,
+						attrs);
 			sg->dma_address = xen_phys_to_bus(map);
 		} else {
 			/* we are not interested in the dma_addr returned by
-- 
1.7.2.5

