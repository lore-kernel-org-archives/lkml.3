Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaJ0SGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:06:38 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52650 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaJ0SGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:06:34 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-api@vger.kernel.org (open list:ABI/API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/6] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Mon, 27 Oct 2014 19:05:52 +0100
Message-Id: <1414433155-31600-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
This way the user can control whether the XN flag will be set on the
requested mappings. The IOMMU_NOEXEC flag needs to be available for all
the IOMMUs of the container used.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 include/uapi/linux/vfio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 1e39842..06d66c9 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -30,6 +30,7 @@ enum vfio_iommu_cap {
 	VFIO_DMA_CC_IOMMU	= 4, /* IOMMU enforces DMA cache coherence
 					(ex. PCIe NoSnoop stripping) */
 	VFIO_EEH		= 5, /* Check if EEH is supported */
+	VFIO_DMA_NOEXEC_IOMMU	= 6,
 };
 
 /*
@@ -394,12 +395,17 @@ struct vfio_iommu_type1_info {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * To use the VFIO_DMA_MAP_FLAG_NOEXEC flag, the container must support the
+ * VFIO_DMA_NOEXEC_IOMMU capability. If mappings are created using this flag,
+ * any groups subsequently added to the container must support this capability.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)	/* not executable from device */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
2.1.1

