Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3LKU71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:59:27 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:33863 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3LKU70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:59:26 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/9] VFIO_IOMMU_TYPE1: Introduce the VFIO_DMA_MAP_FLAG_EXEC flag
Date: Wed, 11 Dec 2013 21:58:25 +0100
Message-Id: <1386795513-32426-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
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

