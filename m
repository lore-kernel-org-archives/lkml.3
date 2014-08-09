Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaHIRFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:05:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60462 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaHIRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:05:02 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] vfio: Fix build failure seen if vfio is built as module and EEH is enabled
Date: Sat,  9 Aug 2014 10:04:47 -0700
Message-Id: <1407603887-1419-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following build failure is seen with ppc:allmodconfig.

ERROR: ".vfio_spapr_iommu_eeh_ioctl" [drivers/vfio/vfio_iommu_spapr_tce.ko] undefined!
ERROR: ".vfio_spapr_pci_eeh_open" [drivers/vfio/pci/vfio-pci.ko] undefined!
ERROR: ".vfio_spapr_pci_eeh_release" [drivers/vfio/pci/vfio-pci.ko] undefined!

Simply exporting the missing symbols is insufficient, since drivers/vfio
can be built as module but drivers/vfio/vfio_spapr_eeh.c depends on
EEH which is boolean. The combination of obj-m for drivers/vfio and obj-y
for drivers/vfio/vfio_spapr_eeh.o results in the symbols being missed even
if exported.

Export missing symbols and introduce new tristate configuration option
VFIO_EEH depending on both EEH and VFIO to fix the problem.

Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/vfio/Kconfig          | 6 ++++++
 drivers/vfio/Makefile         | 2 +-
 drivers/vfio/vfio_spapr_eeh.c | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index af7b204..06adecd 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -8,12 +8,18 @@ config VFIO_IOMMU_SPAPR_TCE
 	depends on VFIO && SPAPR_TCE_IOMMU
 	default n
 
+config VFIO_EEH
+	tristate
+	depends on VFIO && EEH
+	default n
+
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
 	select VFIO_IOMMU_TYPE1 if X86
 	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
 	select ANON_INODES
+	select VFIO_EEH if EEH
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/vfio.txt for more details.
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 50e30bc..26016cd 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_VFIO) += vfio.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
-obj-$(CONFIG_EEH) += vfio_spapr_eeh.o
+obj-$(CONFIG_VFIO_EEH) += vfio_spapr_eeh.o
 obj-$(CONFIG_VFIO_PCI) += pci/
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index f834b4c..e827309 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/export.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <asm/eeh.h>
@@ -18,11 +19,13 @@ int vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
 {
 	return eeh_dev_open(pdev);
 }
+EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_open);
 
 void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
 {
 	eeh_dev_release(pdev);
 }
+EXPORT_SYMBOL(vfio_spapr_pci_eeh_release);
 
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 				unsigned int cmd, unsigned long arg)
@@ -85,3 +88,4 @@ long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 
 	return ret;
 }
+EXPORT_SYMBOL(vfio_spapr_iommu_eeh_ioctl);
-- 
1.9.1

