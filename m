Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaFERGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:06:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53756 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaFERGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:06:11 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v6 19/20] vfio: initialize the virqfd workqueue in VFIO generic code
Date: Thu,  5 Jun 2014 19:03:27 +0200
Message-Id: <1401987808-23596-20-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have finally completely decoupled virqfd from VFIO_PCI. We can
initialize it from the VFIO generic code, in order to safely use it from
many different VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci.c | 8 --------
 drivers/vfio/vfio.c         | 8 ++++++++
 drivers/vfio/virqfd.c       | 4 ++--
 include/linux/vfio.h        | 4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7ba0424..9969eaf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -899,7 +899,6 @@ static struct pci_driver vfio_pci_driver = {
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
 
@@ -912,11 +911,6 @@ static int __init vfio_pci_init(void)
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
@@ -925,8 +919,6 @@ static int __init vfio_pci_init(void)
 	return 0;
 
 out_driver:
-	vfio_pci_virqfd_exit();
-out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 512f479..4f95a17 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1470,6 +1470,11 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_cdev_add;
 
+	/* Start the virqfd cleanup handler used by some VFIO bus drivers */
+	ret = vfio_virqfd_init();
+	if (ret)
+		goto err_virqfd;
+
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 	/*
@@ -1482,6 +1487,8 @@ static int __init vfio_init(void)
 
 	return 0;
 
+err_virqfd:
+	cdev_del(&vfio.group_cdev);
 err_cdev_add:
 	unregister_chrdev_region(vfio.group_devt, MINORMASK);
 err_alloc_chrdev:
@@ -1496,6 +1503,7 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
+	vfio_virqfd_exit();
 	idr_destroy(&vfio.group_idr);
 	cdev_del(&vfio.group_cdev);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK);
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 8c97e2e..8d286ca 100644
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
index e4f7de8..132e61f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -117,8 +117,8 @@ struct virqfd {
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
1.8.3.2

