Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaBQUZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:25:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbaBQUYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:24:02 -0500
Subject: [PATCH 2/4] vfio/type1: Add extension to test DMA cache coherence
 of IOMMU
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 13:24:01 -0700
Message-ID: <20140217202400.22775.78053.stgit@bling.home>
In-Reply-To: <20140217201324.22775.31904.stgit@bling.home>
References: <20140217201324.22775.31904.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the type1 IOMMU backend can support IOMMU_CACHE, we need to
be able to test whether coherency is currently enforced.  Add an
extension for this.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   21 +++++++++++++++++++++
 include/uapi/linux/vfio.h       |    5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8c7bb9b..1f90344 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -867,6 +867,23 @@ static void vfio_iommu_type1_release(void *iommu_data)
 	kfree(iommu);
 }
 
+static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *domain;
+	int ret = 1;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		if (!(domain->prot & IOMMU_CACHE)) {
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&iommu->lock);
+
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -878,6 +895,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		case VFIO_TYPE1_IOMMU:
 		case VFIO_TYPE1v2_IOMMU:
 			return 1;
+		case VFIO_DMA_CC_IOMMU:
+			if (!iommu)
+				return 0;
+			return vfio_domains_have_iommu_cache(iommu);
 		default:
 			return 0;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 460fdf2..cb9023d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -24,6 +24,11 @@
 #define VFIO_TYPE1_IOMMU		1
 #define VFIO_SPAPR_TCE_IOMMU		2
 #define VFIO_TYPE1v2_IOMMU		3
+/*
+ * IOMMU enforces DMA cache coherence (ex. PCIe NoSnoop stripping).  This
+ * capability is subject to change as groups are added or removed.
+ */
+#define VFIO_DMA_CC_IOMMU		4
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the

