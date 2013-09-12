Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3ILVXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab3ILVXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:23:13 -0400
Subject: [RFC PATCH 2/3] vfio: Add check extension interface to external
 user support
To: kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, bsd@redhat.com,
        linux-kernel@vger.kernel.org, mst@redhat.com
Date: Thu, 12 Sep 2013 15:23:08 -0600
Message-ID: <20130912212308.8542.97753.stgit@bling.home>
In-Reply-To: <20130912211401.8542.82932.stgit@bling.home>
References: <20130912211401.8542.82932.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ability for an external user to check VFIO extensions.
The first one we care about is support for IOMMU cache coherency.
Without this, external users, like KVM, would need to assume the IOMMU
allows No-Snoop transactions which are not coherent with processor
cache.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c             |    8 ++++++++
 drivers/vfio/vfio_iommu_type1.c |    4 ++++
 include/linux/vfio.h            |    2 ++
 include/uapi/linux/vfio.h       |    1 +
 4 files changed, 15 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1eab4ac..b55979e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1414,6 +1414,14 @@ int vfio_external_user_iommu_id(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
 
+int vfio_external_user_check_extension(struct vfio_group *group,
+				       unsigned long arg)
+{
+	return vfio_ioctl_check_extension(group->container, arg);
+
+}
+EXPORT_SYMBOL_GPL(vfio_external_user_check_extension);
+
 /**
  * Module/class support
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a9807de..b88b9f7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -840,6 +840,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		switch (arg) {
 		case VFIO_TYPE1_IOMMU:
 			return 1;
+		case VFIO_IOMMU_CAP_CACHE_COHERENCY:
+			return !iommu ? 0 :
+				iommu_domain_has_cap(iommu->domain,
+						     IOMMU_CAP_CACHE_COHERENCY);
 		default:
 			return 0;
 		}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 24579a0..fe528e8 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -96,5 +96,7 @@ extern void vfio_unregister_iommu_driver(
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
+extern int vfio_external_user_check_extension(struct vfio_group *group,
+					      unsigned long arg);
 
 #endif /* VFIO_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0fd47f5..1c8bad6 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -23,6 +23,7 @@
 
 #define VFIO_TYPE1_IOMMU		1
 #define VFIO_SPAPR_TCE_IOMMU		2
+#define VFIO_IOMMU_CAP_CACHE_COHERENCY	3
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the

