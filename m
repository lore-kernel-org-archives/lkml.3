Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaK0RgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:36:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59235 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaK0RgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:36:03 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 19/20] vfio: initialize the virqfd workqueue in VFIO generic code
Date: Thu, 27 Nov 2014 18:32:59 +0100
Message-Id: <1417109580-10505-20-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have finally completely decoupled virqfd from VFIO_PCI. We can
initialize it from the VFIO generic code, in order to safely use it from
multiple independent VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Makefile       | 4 +++-
 drivers/vfio/pci/Makefile   | 3 +--
 drivers/vfio/pci/vfio_pci.c | 8 --------
 drivers/vfio/vfio.c         | 8 ++++++++
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index dadf0ca..d798b09 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,4 +1,6 @@
-obj-$(CONFIG_VFIO) += vfio.o
+vfio_core-y := vfio.o virqfd.o
+
+obj-$(CONFIG_VFIO) += vfio_core.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index c7c8644..1310792 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,5 +1,4 @@
 
-vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o \
-	      ../virqfd.o
+vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index fc4308c..8d156d7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1012,7 +1012,6 @@ put_devs:
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
 
@@ -1025,11 +1024,6 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		return ret;
 
-	/* Start the virqfd cleanup handler */
-	ret = vfio_virqfd_init();
-	if (ret)
-		goto out_virqfd;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
@@ -1038,8 +1032,6 @@ static int __init vfio_pci_init(void)
 	return 0;
 
 out_driver:
-	vfio_virqfd_exit();
-out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index f018d8d..8e84471 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1464,6 +1464,11 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_cdev_add;
 
+	/* Start the virqfd cleanup handler used by some VFIO bus drivers */
+	ret = vfio_virqfd_init();
+	if (ret)
+		goto err_virqfd;
+
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 	/*
@@ -1476,6 +1481,8 @@ static int __init vfio_init(void)
 
 	return 0;
 
+err_virqfd:
+	cdev_del(&vfio.group_cdev);
 err_cdev_add:
 	unregister_chrdev_region(vfio.group_devt, MINORMASK);
 err_alloc_chrdev:
@@ -1490,6 +1497,7 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
+	vfio_virqfd_exit();
 	idr_destroy(&vfio.group_idr);
 	cdev_del(&vfio.group_cdev);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK);
-- 
2.1.3

