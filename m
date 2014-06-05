Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaFEREd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:04:33 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56693 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaFEREa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:04:30 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v6 07/20] vfio/iommu_type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Thu,  5 Jun 2014 19:03:15 +0200
Message-Id: <1401987808-23596-8-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMU drivers, such as the ARM SMMU driver, make available the
IOMMU_NOEXEC flag, to set the page tables for a device as XN (execute never).
This affects devices such as the ARM PL330 DMA Controller, which respects
this flag and will refuse to fetch DMA instructions from memory where the
XN flag has been set.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6673e7b..e2566fd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -80,6 +80,24 @@ struct vfio_group {
 	struct list_head	next;
 };
 
+static int vfio_domains_have_cap_noexec(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+	int ret = 1;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		if (!iommu_domain_has_cap(d->domain, IOMMU_CAP_NOEXEC)) {
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&iommu->lock);
+
+	return ret;
+}
+
+
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -542,6 +560,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		prot |= IOMMU_WRITE;
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
+	if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
+		if (!vfio_domains_have_cap_noexec(iommu))
+			return -EINVAL;
+		prot |= IOMMU_NOEXEC;
+	}
 
 	if (!prot)
 		return -EINVAL; /* No READ/WRITE? */
@@ -899,6 +922,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			if (!iommu)
 				return 0;
 			return vfio_domains_have_iommu_cache(iommu);
+		case VFIO_IOMMU_PROT_NOEXEC:
+			if (!iommu)
+				return 0;
+			return vfio_domains_have_cap_noexec(iommu);
 		default:
 			return 0;
 		}
@@ -922,7 +949,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_NOEXEC;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
-- 
1.8.3.2

