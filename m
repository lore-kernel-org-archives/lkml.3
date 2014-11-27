Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaK0RX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:23:56 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57910 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaK0RXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:23:33 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 5/6] vfio: type1: replace vfio_domains_have_iommu_cache with generic function
Date: Thu, 27 Nov 2014 18:22:55 +0100
Message-Id: <1417108976-10113-6-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417108976-10113-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417108976-10113-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the function vfio_domains_have_iommu_cache() with a more generic
function vfio_domains_have_iommu_cap() which allows to check all domains
of an vfio_iommu structure for a given cached capability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c54dab8..bdf7dc9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -81,6 +81,23 @@ struct vfio_group {
 	struct list_head	next;
 };
 
+static int vfio_domains_have_iommu_cap(struct vfio_iommu *iommu, int cap)
+{
+	struct vfio_domain *domain;
+	int ret = 1;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		if (!(domain->caps & cap)) {
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&iommu->lock);
+
+	return ret;
+}
+
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -886,23 +903,6 @@ static void vfio_iommu_type1_release(void *iommu_data)
 	kfree(iommu);
 }
 
-static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
-{
-	struct vfio_domain *domain;
-	int ret = 1;
-
-	mutex_lock(&iommu->lock);
-	list_for_each_entry(domain, &iommu->domain_list, next) {
-		if (!(domain->caps & IOMMU_CAP_CACHE_COHERENCY)) {
-			ret = 0;
-			break;
-		}
-	}
-	mutex_unlock(&iommu->lock);
-
-	return ret;
-}
-
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -918,7 +918,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		case VFIO_DMA_CC_IOMMU:
 			if (!iommu)
 				return 0;
-			return vfio_domains_have_iommu_cache(iommu);
+			return vfio_domains_have_iommu_cap(iommu,
+						  IOMMU_CAP_CACHE_COHERENCY);
 		default:
 			return 0;
 		}
-- 
2.1.3

