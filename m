Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbaD3Nzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:55:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16995 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbaD3Ny0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 3/6] xen-pciback: Document when we FLR an PCI device.
Date: Wed, 30 Apr 2014 09:54:08 -0400
Message-Id: <1398866051-32714-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the toolstack wants us to drop or add an PCI device it
changes the XenBus state to Configuring - and as result of that
we find out which devices we should still be exporting out and
which ones not. For the ones we don't need anymore we need to
do an PCI reset so that it is ready for the next guest.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 2 ++
 drivers/xen/xen-pciback/xenbus.c   | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 36dd4f3..b84426a 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -551,6 +551,8 @@ static void pcistub_remove(struct pci_dev *dev)
 			pr_warn("****** shutdown driver domain before binding device\n");
 			pr_warn("****** to other drivers or domains\n");
 
+			/* N.B. This ends up calling pcistub_put_pci_dev which ends up
+			 * doing the FLR. */
 			xen_pcibk_release_pci_dev(found_psdev->pdev,
 						found_psdev->dev);
 		}
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index a9ed867..4a7e6e0 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -93,6 +93,8 @@ static void free_pdev(struct xen_pcibk_device *pdev)
 
 	xen_pcibk_disconnect(pdev);
 
+	/* N.B. This calls pcistub_put_pci_dev which does the FLR on all
+	 * of the PCIe devices. */
 	xen_pcibk_release_devices(pdev);
 
 	dev_set_drvdata(&pdev->xdev->dev, NULL);
@@ -286,6 +288,8 @@ static int xen_pcibk_remove_device(struct xen_pcibk_device *pdev,
 	dev_dbg(&dev->dev, "unregistering for %d\n", pdev->xdev->otherend_id);
 	xen_unregister_device_domain_owner(dev);
 
+	/* N.B. This ends up calling pcistub_put_pci_dev which ends up
+	 * doing the FLR. */
 	xen_pcibk_release_pci_dev(pdev, dev);
 
 out:
-- 
1.8.5.3

