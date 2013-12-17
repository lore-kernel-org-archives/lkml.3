Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab3LQScu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:32:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3LQSOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>,
        Joerg Roedel <joro@8bytes.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 052/103] iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits
Date: Tue, 17 Dec 2013 18:12:41 +0000
Message-Id: <1387304012-23805-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/intel-iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e560f54..f3535d9 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -779,7 +779,11 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
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
1.8.3.2

