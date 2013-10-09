Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3JII0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:26:02 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:46079 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3JIIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:25:58 -0400
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2013 04:25:58 EDT
From: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
To: Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH] vfio, iommu: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits
Date: Wed,  9 Oct 2013 10:03:52 +0200
Message-Id: <1381305832-2900-1-git-send-email-jsteckli@os.inf.tu-dresden.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377704672.10408.81.camel@ul30vt.home>
References: <1377704672.10408.81.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/iommu/intel-iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 15e9b57..40203ad 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -782,7 +782,11 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
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
-- 
1.8.3.1

