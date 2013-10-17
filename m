Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab3JQSFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:05:21 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13606 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608Ab3JQSFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:05:20 -0400
X-IronPort-AV: E=Sophos;i="4.93,515,1378857600"; 
   d="scan'208";a="64695223"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 18/19] swiotlb-xen: no need to do execute two bus_to_phys translations in a row
Date: Thu, 17 Oct 2013 18:43:33 +0100
Message-ID: <1382031814-8782-18-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_unmap_single calls xen_bus_to_phys, then passes dev_addr to
is_xen_swiotlb_buffer that calls xen_bus_to_phys again.
xen_bus_to_phys is potentially a slow operation that might involve
walking a tree.
We can avoid calling xen_bus_to_phys twice by removing the
is_xen_swiotlb_buffer call and doing the check directly in
xen_unmap_single using the physical address.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 4d50058..6d9ca61 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -426,8 +426,8 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 
 	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
 
-	/* NOTE: We use dev_addr here, not paddr! */
-	if (is_xen_swiotlb_buffer(dev_addr)) {
+	if (paddr >= virt_to_phys(xen_io_tlb_start) &&
+		paddr < virt_to_phys(xen_io_tlb_end)) {
 		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
 		return;
 	}
-- 
1.7.2.5

