Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaAQTqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:46:18 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:16016
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbaAQTqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:46:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <alex.williamson@redhat.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [RFC][PATCH] Remove bus dependency for iommu_domain_alloc.
Date: Sat, 18 Jan 2014 01:00:42 +0530
Message-ID: <1389987042-27352-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch attempts to remove iommu_domain_alloc function's dependency on the bus type.
This dependency is quiet restrictive in case of vfio, where it's possible to bind multiple
iommu groups (from different bus types) to the same iommu domain.

This patch is based on the assumption, that there is a single iommu for all bus types
on the system.

We maintain a list of bus types (for which iommu ops are registered). In the iommu_domain_alloc
function we ensure that all bus types correspond to the same set of iommu operations.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 arch/arm/mm/dma-mapping.c             |    2 +-
 drivers/gpu/drm/msm/msm_gpu.c         |    2 +-
 drivers/iommu/amd_iommu_v2.c          |    2 +-
 drivers/iommu/iommu.c                 |   32 +++++++++++++++++++++++++++++---
 drivers/media/platform/omap3isp/isp.c |    2 +-
 drivers/remoteproc/remoteproc_core.c  |    2 +-
 drivers/vfio/vfio_iommu_type1.c       |    2 +-
 include/linux/device.h                |    2 ++
 include/linux/iommu.h                 |    4 ++--
 virt/kvm/iommu.c                      |    2 +-
 10 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index f61a570..0e5a5f5 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1910,7 +1910,7 @@ arm_iommu_create_mapping(struct bus_type *bus, dma_addr_t base, size_t size,
 	mapping->order = order;
 	spin_lock_init(&mapping->lock);
 
-	mapping->domain = iommu_domain_alloc(bus);
+	mapping->domain = iommu_domain_alloc();
 	if (!mapping->domain)
 		goto err3;
 
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 4583d61..3e8636e 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -428,7 +428,7 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	 * and have separate page tables per context.  For now, to keep things
 	 * simple and to get something working, just use a single address space:
 	 */
-	gpu->iommu = iommu_domain_alloc(&platform_bus_type);
+	gpu->iommu = iommu_domain_alloc();
 	if (!gpu->iommu) {
 		dev_err(drm->dev, "failed to allocate IOMMU\n");
 		ret = -ENOMEM;
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 5208828..5c0737b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -785,7 +785,7 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 	if (dev_state->states == NULL)
 		goto out_free_dev_state;
 
-	dev_state->domain = iommu_domain_alloc(&pci_bus_type);
+	dev_state->domain = iommu_domain_alloc();
 	if (dev_state->domain == NULL)
 		goto out_free_states;
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e5555fc..799371b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -35,6 +35,9 @@ static struct kset *iommu_group_kset;
 static struct ida iommu_group_ida;
 static struct mutex iommu_group_mutex;
 
+static struct list_head bus_list;
+static struct mutex bus_list_mutex;
+
 struct iommu_group {
 	struct kobject kobj;
 	struct kobject *devices_kobj;
@@ -611,6 +614,10 @@ int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
 
 	bus->iommu_ops = ops;
 
+	mutex_lock(&bus_list_mutex);
+	list_add(&bus->bus_list, &bus_list);
+	mutex_unlock(&bus_list_mutex);
+
 	/* Do IOMMU specific setup for this bus-type */
 	iommu_bus_init(bus, ops);
 
@@ -647,19 +654,36 @@ void iommu_set_fault_handler(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_set_fault_handler);
 
-struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
+struct iommu_domain *iommu_domain_alloc(void)
 {
 	struct iommu_domain *domain;
+	struct iommu_ops *ops = NULL;
+	struct bus_type *bus;
 	int ret;
 
-	if (bus == NULL || bus->iommu_ops == NULL)
+	/*
+	 * Traverse the bus list and verify that same iommu_ops
+	 * are registered for all the bus types.
+	 */
+	mutex_lock(&bus_list_mutex);
+	list_for_each_entry(bus, &bus_list, bus_list) {
+		if (!bus->iommu_ops || (ops && (bus->iommu_ops != ops))) {
+			mutex_unlock(&bus_list_mutex);
+			return NULL;
+		} else if (!ops) {
+			ops = bus->iommu_ops;
+		}
+	}
+	mutex_unlock(&bus_list_mutex);
+
+	if (!ops)
 		return NULL;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
 		return NULL;
 
-	domain->ops = bus->iommu_ops;
+	domain->ops = ops;
 
 	ret = domain->ops->domain_init(domain);
 	if (ret)
@@ -924,6 +948,8 @@ static int __init iommu_init(void)
 					       NULL, kernel_kobj);
 	ida_init(&iommu_group_ida);
 	mutex_init(&iommu_group_mutex);
+	mutex_init(&bus_list_mutex);
+	INIT_LIST_HEAD(&bus_list);
 
 	BUG_ON(!iommu_group_kset);
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 561bce8..199d18e 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2248,7 +2248,7 @@ static int isp_probe(struct platform_device *pdev)
 		}
 	}
 
-	isp->domain = iommu_domain_alloc(pdev->dev.bus);
+	isp->domain = iommu_domain_alloc();
 	if (!isp->domain) {
 		dev_err(isp->dev, "can't alloc iommu domain\n");
 		ret = -ENOMEM;
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 3cd85a6..bf5e2a4 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -110,7 +110,7 @@ static int rproc_enable_iommu(struct rproc *rproc)
 		return 0;
 	}
 
-	domain = iommu_domain_alloc(dev->bus);
+	domain = iommu_domain_alloc();
 	if (!domain) {
 		dev_err(dev, "can't alloc iommu domain\n");
 		return -ENOMEM;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4fb7a8f..7a9d1e8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -783,7 +783,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	/*
 	 * Wish we didn't have to know about bus_type here.
 	 */
-	iommu->domain = iommu_domain_alloc(&pci_bus_type);
+	iommu->domain = iommu_domain_alloc();
 	if (!iommu->domain) {
 		kfree(iommu);
 		return ERR_PTR(-EIO);
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..a9e23de 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -88,6 +88,7 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * @iommu_ops:  IOMMU specific operations for this bus, used to attach IOMMU
  *              driver implementations to a bus and allow the driver to do
  *              bus-specific setup
+ * @bus_list:   List of bus types for which iommu operations have been setup
  * @p:		The private data of the driver core, only the driver core can
  *		touch this.
  * @lock_key:	Lock class key for use by the lock validator
@@ -125,6 +126,7 @@ struct bus_type {
 	const struct dev_pm_ops *pm;
 
 	struct iommu_ops *iommu_ops;
+	struct list_head bus_list;
 
 	struct subsys_private *p;
 	struct lock_class_key lock_key;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a444c79..dd17bc7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -141,7 +141,7 @@ struct iommu_ops {
 
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
-extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
+extern struct iommu_domain *iommu_domain_alloc(void);
 extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
 extern int iommu_attach_device(struct iommu_domain *domain,
@@ -242,7 +242,7 @@ static inline bool iommu_present(struct bus_type *bus)
 	return false;
 }
 
-static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
+static inline struct iommu_domain *iommu_domain_alloc(void)
 {
 	return NULL;
 }
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 0df7d4b..8018ccc 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -238,7 +238,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 
 	mutex_lock(&kvm->slots_lock);
 
-	kvm->arch.iommu_domain = iommu_domain_alloc(&pci_bus_type);
+	kvm->arch.iommu_domain = iommu_domain_alloc();
 	if (!kvm->arch.iommu_domain) {
 		r = -ENOMEM;
 		goto out_unlock;
-- 
1.7.9.5


