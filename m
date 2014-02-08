Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaBHRcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 12:32:10 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43881 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBHRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 12:32:07 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [RFC PATCH v4 02/10] VFIO_IOMMU_TYPE1: Introduce the VFIO_DMA_MAP_FLAG_EXEC flag
Date: Sat,  8 Feb 2014 18:29:32 +0100
Message-Id: <1391880580-471-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM SMMU driver expects the IOMMU_EXEC flag, otherwise it will
set the page tables for a device as XN (execute never). This affects
devices such as the ARM PL330 DMA Controller, which fails to operate
if the XN flag is set on the memory it tries to fetch its instructions
from.

We introduce the VFIO_DMA_MAP_FLAG_EXEC to VFIO, and use it in
VFIO_IOMMU_TYPE1 to set the IOMMU_EXEC flag. This way the user can
control whether the XN flag will be set on the requested mappings.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 ++++-
 include/uapi/linux/vfio.h       | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4fb7a8f..ad7a1f6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -557,6 +557,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		prot |= IOMMU_WRITE;
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
+	if (map->flags & VFIO_DMA_MAP_FLAG_EXEC)
+		prot |= IOMMU_EXEC;
 
 	if (!prot)
 		return -EINVAL; /* No READ/WRITE? */
@@ -865,7 +867,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_EXEC;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0fd47f5..d8e9e99 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -392,6 +392,7 @@ struct vfio_iommu_type1_dma_map {
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_EXEC (1 << 2)		/* executable from device */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
1.8.3.2

