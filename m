Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3ENC3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:29:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3ENC2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:28:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/7] PCI: Detach driver in pci_stop_device
Date: Mon, 13 May 2013 19:28:22 -0700
Message-Id: <1368498506-25857-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pci_stop_dev actually detach driver only, and pci_remove_dev
device will do device_del instead. Then also could make hostbridge
to use device_unregister to be pair with device_register before.

Add is_removed to record if device_del is called already.

So mutliple calling will not cause false removing,
only right put_device will get device removed at last.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/remove.c |   12 ++++++++----
 include/linux/pci.h  |    3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -10,7 +10,7 @@ static void pci_stop_dev(struct pci_dev
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
-		device_del(&dev->dev);
+		device_release_driver(&dev->dev);
 		dev->is_added = 0;
 	}
 
@@ -20,7 +20,11 @@ static void pci_stop_dev(struct pci_dev
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	put_device(&dev->dev);
+	if (!dev->is_removed) {
+		device_del(&dev->dev);
+		dev->is_removed = 1;
+		put_device(&dev->dev);
+	}
 }
 
 void pci_remove_bus(struct pci_bus *bus)
@@ -107,7 +111,7 @@ void pci_stop_root_bus(struct pci_bus *b
 		pci_stop_bus_device(child);
 
 	/* stop the host bridge */
-	device_del(&host_bridge->dev);
+	device_release_driver(&host_bridge->dev);
 }
 
 void pci_remove_root_bus(struct pci_bus *bus)
@@ -126,5 +130,5 @@ void pci_remove_root_bus(struct pci_bus
 	host_bridge->bus = NULL;
 
 	/* remove the host bridge */
-	put_device(&host_bridge->dev);
+	device_unregister(&host_bridge->dev);
 }
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -307,7 +307,8 @@ struct pci_dev {
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
 	unsigned int	multifunction:1;/* Part of multi-function device */
 	/* keep track of device state */
-	unsigned int	is_added:1;
+	unsigned int	is_added:1;	/* driver is attached */
+	unsigned int	is_removed:1;	/* device_del is called */
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
 	unsigned int	block_cfg_access:1;	/* config space access is blocked */
