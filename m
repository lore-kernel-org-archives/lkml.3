Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaJMNJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:09:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36429 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaJMNJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:09:37 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/5] vfio: type1: replace vfio_domains_have_iommu_cache with generic function
Date: Mon, 13 Oct 2014 15:09:07 +0200
Message-Id: <1413205748-6300-5-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
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
index 62a8b4d..8b4202a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -80,6 +80,23 @@ struct vfio_group {
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
@@ -867,23 +884,6 @@ static void vfio_iommu_type1_release(void *iommu_data)
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
@@ -898,7 +898,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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
2.1.1

