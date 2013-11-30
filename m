Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3K3Wlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51849 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3K3Wkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 03/12] PCI: Move resources and bus_list releasing to pci_release_dev
Date: Sat, 30 Nov 2013 14:40:29 -0800
Message-Id: <1385851238-21085-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not release resource in pci_destroy that is too early
as there could be still other use hold reference.

release them or remove it from bus devices list at last
in pci_release_dev instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c  | 21 +++++++++++++++++++--
 drivers/pci/remove.c | 19 -------------------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 173a9cf..12ec56c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1154,6 +1154,18 @@ static void pci_release_capabilities(struct pci_dev *dev)
 	pci_free_cap_save_buffers(dev);
 }
 
+static void pci_free_resources(struct pci_dev *dev)
+{
+	int i;
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
@@ -1163,9 +1175,14 @@ static void pci_release_capabilities(struct pci_dev *dev)
  */
 static void pci_release_dev(struct device *dev)
 {
-	struct pci_dev *pci_dev;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
+	down_write(&pci_bus_sem);
+	list_del(&pci_dev->bus_list);
+	up_write(&pci_bus_sem);
+
+	pci_free_resources(pci_dev);
 
-	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 692f4c3..f452148 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -3,20 +3,6 @@
 #include <linux/pci-aspm.h>
 #include "pci.h"
 
-static void pci_free_resources(struct pci_dev *dev)
-{
-	int i;
-
-	msi_remove_pci_irq_vectors(dev);
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
@@ -36,11 +22,6 @@ static void pci_destroy_dev(struct pci_dev *dev)
 {
 	device_del(&dev->dev);
 
-	down_write(&pci_bus_sem);
-	list_del(&dev->bus_list);
-	up_write(&pci_bus_sem);
-
-	pci_free_resources(dev);
 	put_device(&dev->dev);
 }
 
-- 
1.8.1.4

