Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3KLONd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:13:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61746 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3KLONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:13:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,685,1378857600"; 
   d="scan'208";a="71018578"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/2] swiotlb-xen: xen_swiotlb_map_page: do not error out if dma_capable fails
Date: Tue, 12 Nov 2013 14:12:00 +0000
Message-ID: <1384265520-6833-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many ARM devices do not set the dma_mask correctly today.
As a consequence dma_capable fails for them regardless of the address
passed to it.
In xen_swiotlb_map_page we currently use dma_capable to check if the
address returned by the swiotlb is good for dma for the device.
However the check would often fail even if the address is correct.
Considering that we know that the swiotlb buffer has a low address,
skip the check.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 1eac073..543e30b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -402,13 +402,6 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 					map & ~PAGE_MASK, size, dir, attrs);
 	dev_addr = xen_phys_to_bus(map);
 
-	/*
-	 * Ensure that the address returned is DMA'ble
-	 */
-	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, map, size, dir);
-		dev_addr = 0;
-	}
 	return dev_addr;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
-- 
1.7.2.5

