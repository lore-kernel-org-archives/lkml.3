Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3EYNwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:52:10 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39737 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3EYNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:52:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donald Dutile <ddutile@redhat.com>, Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v3, part1 09/10] PCI, IOV: simplify IOV implementation
Date: Sat, 25 May 2013 21:48:37 +0800
Message-Id: <1369489718-25869-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial changes to IOV:
1) use new PCI interfaces to simplify IOV implementation
2) fix some reference count related race windows

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/iov.c | 58 +++++++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 8f1e117..3e33499 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -51,43 +51,30 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
 	return child;
 }
 
-static void virtfn_remove_bus(struct pci_bus *bus, int busnr)
+static void virtfn_remove_bus(struct pci_bus *physbus, struct pci_bus *virtbus)
 {
-	struct pci_bus *child;
-
-	if (bus->number == busnr)
-		return;
-
-	child = pci_find_bus(pci_domain_nr(bus), busnr);
-	BUG_ON(!child);
-
-	if (list_empty(&child->devices))
-		pci_remove_bus(child);
+	if (physbus != virtbus && list_empty(&virtbus->devices))
+		pci_remove_bus(virtbus);
 }
 
 static int virtfn_add(struct pci_dev *dev, int id, int reset)
 {
 	int i;
-	int rc;
+	int rc = -ENOMEM;
 	u64 size;
 	char buf[VIRTFN_ID_LEN];
-	struct pci_dev *virtfn;
+	struct pci_dev *virtfn = NULL;
 	struct resource *res;
 	struct pci_sriov *iov = dev->sriov;
 	struct pci_bus *bus;
 
-	virtfn = pci_alloc_dev(NULL);
-	if (!virtfn)
-		return -ENOMEM;
-
 	mutex_lock(&iov->dev->sriov->lock);
 	bus = virtfn_add_bus(dev->bus, virtfn_bus(dev, id));
-	if (!bus) {
-		kfree(virtfn);
-		mutex_unlock(&iov->dev->sriov->lock);
-		return -ENOMEM;
-	}
-	virtfn->bus = pci_bus_get(bus);
+	if (bus)
+		virtfn = pci_alloc_dev(bus);
+	if (!virtfn)
+		goto failed0;
+
 	virtfn->devfn = virtfn_devfn(dev, id);
 	virtfn->vendor = dev->vendor;
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
@@ -136,7 +123,8 @@ failed1:
 	pci_dev_put(dev);
 	mutex_lock(&iov->dev->sriov->lock);
 	pci_stop_and_remove_bus_device(virtfn);
-	virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
+	virtfn_remove_bus(dev->bus, bus);
+failed0:
 	mutex_unlock(&iov->dev->sriov->lock);
 
 	return rc;
@@ -145,20 +133,15 @@ failed1:
 static void virtfn_remove(struct pci_dev *dev, int id, int reset)
 {
 	char buf[VIRTFN_ID_LEN];
-	struct pci_bus *bus;
 	struct pci_dev *virtfn;
 	struct pci_sriov *iov = dev->sriov;
 
-	bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
-	if (!bus)
-		return;
-
-	virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
+	virtfn = pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus),
+					     virtfn_bus(dev, id),
+					     virtfn_devfn(dev, id));
 	if (!virtfn)
 		return;
 
-	pci_dev_put(virtfn);
-
 	if (reset) {
 		device_release_driver(&virtfn->dev);
 		__pci_reset_function(virtfn);
@@ -176,9 +159,11 @@ static void virtfn_remove(struct pci_dev *dev, int id, int reset)
 
 	mutex_lock(&iov->dev->sriov->lock);
 	pci_stop_and_remove_bus_device(virtfn);
-	virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
+	virtfn_remove_bus(dev->bus, virtfn->bus);
 	mutex_unlock(&iov->dev->sriov->lock);
 
+	/* balance pci_get_domain_bus_and_slot() */
+	pci_dev_put(virtfn);
 	pci_dev_put(dev);
 }
 
@@ -335,13 +320,14 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 		if (!pdev)
 			return -ENODEV;
 
-		pci_dev_put(pdev);
-
-		if (!pdev->is_physfn)
+		if (!pdev->is_physfn) {
+			pci_dev_put(pdev);
 			return -ENODEV;
+		}
 
 		rc = sysfs_create_link(&dev->dev.kobj,
 					&pdev->dev.kobj, "dep_link");
+		pci_dev_put(pdev);
 		if (rc)
 			return rc;
 	}
-- 
1.8.1.2

