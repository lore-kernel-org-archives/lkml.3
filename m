Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425Ab3LFWFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:05:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479Ab3LFVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Stecklina <jsteckli@os.inf.tu-dresden.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3.10 52/58] iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits
Date: Fri,  6 Dec 2013 13:52:23 -0800
Message-Id: <20131206214849.709813126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>

commit f9423606ade08653dd8a43334f0a7fb45504c5cc upstream.

The BUG_ON in drivers/iommu/intel-iommu.c:785 can be triggered from userspace via
VFIO by calling the VFIO_IOMMU_MAP_DMA ioctl on a vfio device with any address
beyond the addressing capabilities of the IOMMU. The problem is that the ioctl code
calls iommu_iova_to_phys before it calls iommu_map. iommu_map handles the case that
it gets addresses beyond the addressing capabilities of its IOMMU.
intel_iommu_iova_to_phys does not.

This patch fixes iommu_iova_to_phys to return NULL for addresses beyond what the
IOMMU can handle. This in turn causes the ioctl call to fail in iommu_map and
(correctly) return EFAULT to the user with a helpful warning message in the kernel
log.

Signed-off-by: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -782,7 +782,11 @@ static struct dma_pte *pfn_to_dma_pte(st
 	int offset;
 
 	BUG_ON(!domain->pgd);
-	BUG_ON(addr_width < BITS_PER_LONG && pfn >> addr_width);
+
+	if (addr_width < BITS_PER_LONG && pfn >> addr_width)
+		/* Address beyond IOMMU's addressing capabilities. */
+		return NULL;
+
 	parent = domain->pgd;
 
 	while (level > 0) {


