Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3ENC3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:29:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3ENC2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:28:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/7] PCI: move resources and bus_list releasing to pci_release_dev
Date: Mon, 13 May 2013 19:28:21 -0700
Message-Id: <1368498506-25857-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not release resource in pci_destroy that is too early
as there could be still other use hold reference.

release them or remove it from bus devices list at last
in pci_release_dev instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c  |   20 ++++++++++++++++++++
 drivers/pci/remove.c |   19 -------------------
 2 files changed, 20 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1118,6 +1118,20 @@ static void pci_release_capabilities(str
 	pci_free_cap_save_buffers(dev);
 }
 
+static void pci_free_resources(struct pci_dev *dev)
+{
+	int i;
+
+	msi_remove_pci_irq_vectors(dev);
+
+	pci_cleanup_rom(dev);
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *res = dev->resource + i;
+		if (res->parent)
+			release_resource(res);
+	}
+}
+
 /**
  * pci_release_dev - free a pci device structure when all users of it are finished.
  * @dev: device that's been disconnected
@@ -1130,6 +1144,12 @@ static void pci_release_dev(struct devic
 	struct pci_dev *pci_dev;
 
 	pci_dev = to_pci_dev(dev);
+
+	down_write(&pci_bus_sem);
+	list_del(&pci_dev->bus_list);
+	up_write(&pci_bus_sem);
+	pci_free_resources(pci_dev);
+
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
 	kfree(pci_dev);
Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -3,20 +3,6 @@
 #include <linux/pci-aspm.h>
 #include "pci.h"
 
-static void pci_free_resources(struct pci_dev *dev)
-{
-	int i;
-
- 	msi_remove_pci_irq_vectors(dev);
-
-	pci_cleanup_rom(dev);
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *res = dev->resource + i;
-		if (res->parent)
-			release_resource(res);
-	}
-}
-
 static void pci_stop_dev(struct pci_dev *dev)
 {
 	pci_pme_active(dev, false);
@@ -34,11 +20,6 @@ static void pci_stop_dev(struct pci_dev
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	down_write(&pci_bus_sem);
-	list_del(&dev->bus_list);
-	up_write(&pci_bus_sem);
-
-	pci_free_resources(dev);
 	put_device(&dev->dev);
 }
 
