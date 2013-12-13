Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3LMQKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:10:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LMQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:10:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH 3/5] xen-pciback: Document when we FLR an PCI device.
Date: Fri, 13 Dec 2013 11:09:36 -0500
Message-Id: <1386950978-8628-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the toolstack wants us to drop or add an PCI device it
changes the XenBus state to Configuring - and as result of that
we find out which devices we should still be exporting out and
which ones not. For the ones we don't need anymore we need to
do an PCI reset so that it is ready for the next guest.

We are already doing it - but it was not clear _how_
it was done. This should make it more obvious.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 12 +-----------
 drivers/xen/xen-pciback/xenbus.c   |  5 ++++-
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 36dd4f3..b6a856f 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -267,18 +267,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	/* Cleanup our device
 	 * (so it's ready for the next domain)
 	 */
+	pcistub_reset_pci_dev(dev);
 
-	/* This is OK - we are running from workqueue context
-	 * and want to inhibit the user from fiddling with 'reset'
-	 */
-	pci_reset_function(dev);
-	pci_restore_state(dev);
-
-	/* This disables the device. */
-	xen_pcibk_reset_device(dev);
-
-	/* And cleanup up our emulated fields. */
-	xen_pcibk_config_reset_dev(dev);
 	xen_pcibk_config_free_dyn_fields(dev);
 
 	xen_unregister_device_domain_owner(dev);
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index a9ed867..301d1bc 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -93,6 +93,8 @@ static void free_pdev(struct xen_pcibk_device *pdev)
 
 	xen_pcibk_disconnect(pdev);
 
+	/* N.B. This calls pcistub_put_pci_dev which does the FLR on all
+	 * of the PCIe devices. */
 	xen_pcibk_release_devices(pdev);
 
 	dev_set_drvdata(&pdev->xdev->dev, NULL);
@@ -252,7 +254,6 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 		xen_unregister_device_domain_owner(dev);
 		xen_register_device_domain_owner(dev, pdev->xdev->otherend_id);
 	}
-
 	/* TODO: It'd be nice to export a bridge and have all of its children
 	 * get exported with it. This may be best done in xend (which will
 	 * have to calculate resource usage anyway) but we probably want to
@@ -286,6 +287,8 @@ static int xen_pcibk_remove_device(struct xen_pcibk_device *pdev,
 	dev_dbg(&dev->dev, "unregistering for %d\n", pdev->xdev->otherend_id);
 	xen_unregister_device_domain_owner(dev);
 
+	/* N.B. This ends up calling pcistub_put_pci_dev which ends up
+	 * doing the FLR. */
 	xen_pcibk_release_pci_dev(pdev, dev);
 
 out:
-- 
1.8.3.1

