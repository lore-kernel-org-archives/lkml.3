Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaHELlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:41:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64494 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbaHELlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:41:11 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm: Implement drm_get_pci_dev() dummy for !PCI
Date: Tue,  5 Aug 2014 13:41:01 +0200
Message-Id: <1407238861-14257-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Implementing a dummy of this function allows drivers that use it to be
built on platforms that don't have PCI. This can happen for example if
the nouveau driver is built on Tegra without PCI enabled (or on 64-bit
ARM where PCI is not yet implemented).

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/drm/drmP.h    |  9 +++++++++
 include/linux/iommu.h | 18 +++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 0e4c13c3cf33..d71a00af1796 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1663,9 +1663,18 @@ void drm_pci_agp_destroy(struct drm_device *dev);
 
 extern int drm_pci_init(struct drm_driver *driver, struct pci_driver *pdriver);
 extern void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver);
+#ifdef CONFIG_PCI
 extern int drm_get_pci_dev(struct pci_dev *pdev,
 			   const struct pci_device_id *ent,
 			   struct drm_driver *driver);
+#else
+static inline int drm_get_pci_dev(struct pci_dev *pdev,
+				  const struct pci_device_id *ent,
+				  struct drm_driver *driver)
+{
+	return -ENOSYS;
+}
+#endif
 
 #define DRM_PCIE_SPEED_25 1
 #define DRM_PCIE_SPEED_50 2
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7118b0c9b1ad..584e0f8b7173 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -44,16 +44,12 @@ typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
 
 struct iommu {
+	const struct iommu_ops *ops;
 	struct device *dev;
 
 	struct list_head list;
-
-	const struct iommu_ops *ops;
 };
 
-int iommu_add(struct iommu *iommu);
-void iommu_remove(struct iommu *iommu);
-
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
 	dma_addr_t aperture_end;   /* Last address that can be mapped     */
@@ -154,6 +150,9 @@ struct iommu_ops {
 
 #ifdef CONFIG_IOMMU_API
 
+extern int iommu_add(struct iommu *iommu);
+extern void iommu_remove(struct iommu *iommu);
+
 extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
@@ -260,6 +259,15 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 
 #else /* CONFIG_IOMMU_API */
 
+static inline int iommu_add(struct iommu *iommu)
+{
+	return -ENOSYS;
+}
+
+static inline void iommu_remove(struct iommu *iommu)
+{
+}
+
 static inline int bus_set_iommu(struct bus_type *bus,
 				const struct iommu_ops *ops)
 {
-- 
2.0.4

