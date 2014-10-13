Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaJMNNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:13:05 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60936 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaJMNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:13:01 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 17/18] vfio: initialize the virqfd workqueue in VFIO generic code
Date: Mon, 13 Oct 2014 15:10:24 +0200
Message-Id: <1413205825-6370-18-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have finally completely decoupled virqfd from VFIO_PCI. We can
initialize it from the VFIO generic code, in order to safely use it from
multiple independent VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci.c | 8 --------
 drivers/vfio/vfio.c         | 8 ++++++++
 drivers/vfio/virqfd.c       | 4 ++--
 include/linux/vfio.h        | 4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f782533..40e176d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1034,7 +1034,6 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
 
@@ -1047,11 +1046,6 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		return ret;
 
-	/* Start the virqfd cleanup handler */
-	ret = vfio_pci_virqfd_init();
-	if (ret)
-		goto out_virqfd;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
@@ -1060,8 +1054,6 @@ static int __init vfio_pci_init(void)
 	return 0;
 
 out_driver:
-	vfio_pci_virqfd_exit();
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
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index ac63ec0..c28882f 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -18,7 +18,7 @@
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
 static spinlock_t lock;
 
-int __init vfio_pci_virqfd_init(void)
+int __init vfio_virqfd_init(void)
 {
 	vfio_irqfd_cleanup_wq =
 		create_singlethread_workqueue("vfio-irqfd-cleanup");
@@ -30,7 +30,7 @@ int __init vfio_pci_virqfd_init(void)
 	return 0;
 }
 
-void vfio_pci_virqfd_exit(void)
+void vfio_virqfd_exit(void)
 {
 	destroy_workqueue(vfio_irqfd_cleanup_wq);
 }
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ce23a42..9fa02c8 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -140,8 +140,8 @@ struct virqfd {
 	struct virqfd		**pvirqfd;
 };
 
-extern int vfio_pci_virqfd_init(void);
-extern void vfio_pci_virqfd_exit(void);
+extern int vfio_virqfd_init(void);
+extern void vfio_virqfd_exit(void);
 extern int virqfd_enable(void *opaque,
 			 int (*handler)(void *, void *),
 			 void (*thread)(void *, void *),
-- 
2.1.1

