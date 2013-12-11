Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3LKU7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:59:34 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35586 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:59:29 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/9] VFIO_IOMMU_TYPE1: workaround to build for platform devices
Date: Wed, 11 Dec 2013 21:58:26 +0100
Message-Id: <1386795513-32426-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a workaround to make the VFIO_IOMMU_TYPE1 driver usable with
platform devices instead of PCI. A future permanent fix should support
both. This is required in order to use the Exynos SMMU, or ARM SMMU
driver with VFIO.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Kconfig            |  2 +-
 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 26b3d9d..bd50721 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -11,7 +11,7 @@ config VFIO_IOMMU_SPAPR_TCE
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
-	select VFIO_IOMMU_TYPE1 if X86
+	select VFIO_IOMMU_TYPE1 if X86 || ARM
 	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ad7a1f6..81e65f4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -30,7 +30,8 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/pci.h>		/* pci_bus_type */
+#include <linux/pci.h>			/* pci_bus_type */
+#include <linux/platform_device.h>	/* platform_bus_type */
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -47,6 +48,8 @@ module_param_named(allow_unsafe_interrupts,
 		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(allow_unsafe_interrupts,
 		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
+static struct bus_type *iommu_bus_type = NULL;
+static bool require_cap_intr_remap = false;
 
 static bool disable_hugepages;
 module_param_named(disable_hugepages,
@@ -785,7 +788,8 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	/*
 	 * Wish we didn't have to know about bus_type here.
 	 */
-	iommu->domain = iommu_domain_alloc(&pci_bus_type);
+	iommu->domain = iommu_domain_alloc(iommu_bus_type);
+
 	if (!iommu->domain) {
 		kfree(iommu);
 		return ERR_PTR(-EIO);
@@ -797,7 +801,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	 * the way.  Fortunately we know interrupt remapping is global for
 	 * our iommus.
 	 */
-	if (!allow_unsafe_interrupts &&
+	if (require_cap_intr_remap && !allow_unsafe_interrupts &&
 	    !iommu_domain_has_cap(iommu->domain, IOMMU_CAP_INTR_REMAP)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
@@ -914,7 +918,17 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 
 static int __init vfio_iommu_type1_init(void)
 {
-	if (!iommu_present(&pci_bus_type))
+#ifdef CONFIG_PCI
+	if (iommu_present(&pci_bus_type)) {
+		iommu_bus_type = &pci_bus_type;
+		/* For PCI targets, IOMMU_CAP_INTR_REMAP is required */
+		require_cap_intr_remap = true;
+	}
+#endif
+	if (!iommu_bus_type && iommu_present(&platform_bus_type))
+		iommu_bus_type = &platform_bus_type;
+
+	if(!iommu_bus_type)
 		return -ENODEV;
 
 	return vfio_register_iommu_driver(&vfio_iommu_driver_ops_type1);
-- 
1.8.3.2

