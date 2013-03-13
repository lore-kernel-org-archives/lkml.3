Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab3CMX2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:28:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854Ab3CMX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 21/27] PCI: Add addon_resource support for pci devices
Date: Wed, 13 Mar 2013 16:28:16 -0700
Message-Id: <1363217302-14383-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is some non normal pci resources other than standard,rom,
sriov, bridges.
Some could be same as standard reg, but using different position.
Some could have own way to read/write to them.

Kernel are using different way to hack those resources like abusing
pci bridge resource spot on non bridge pci device.

Add addon_resources list in pci_dev for those non-standard resources.
With this patch, will treat addon-resource like standard resources with
special ops.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   38 +++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h |   20 +++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 263a575..9e659c7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -107,22 +107,53 @@ postcore_initcall(pcibus_class_init);
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
 {
-	if (n >= 0 && n < PCI_NUM_RESOURCES)
+	struct pci_dev_addon_resource *addon_res;
+
+	if (n < 0)
+		return NULL;
+
+	if (n < PCI_NUM_RESOURCES)
 		return &dev->resource[n];
 
+	n -= PCI_NUM_RESOURCES;
+	list_for_each_entry(addon_res, &dev->addon_resources, list) {
+		if (n-- == 0)
+			return &addon_res->res;
+	}
+
 	return NULL;
 }
 EXPORT_SYMBOL(pci_dev_resource_n);
 
 int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
 {
+	struct pci_dev_addon_resource *addon_res;
+	int n;
+
 	if (res >= dev->resource &&
 	    res <= dev->resource + (PCI_NUM_RESOURCES - 1))
 		return res - dev->resource;
 
+	n = PCI_NUM_RESOURCES;
+	list_for_each_entry(addon_res, &dev->addon_resources, list) {
+		if (res == &addon_res->res)
+			return n;
+		n++;
+	}
+
 	return -1;
 }
 
+static void pci_release_dev_addon_resource(struct pci_dev *dev)
+{
+	struct pci_dev_addon_resource *addon_res, *tmp;
+
+	list_for_each_entry_safe(addon_res, tmp, &dev->addon_resources, list) {
+		list_del(&addon_res->list);
+		kfree(addon_res);
+	}
+}
+
 static void __init_res_idx_mask(unsigned long *mask, int flag)
 {
 	bitmap_zero(mask, PCI_NUM_RESOURCES);
@@ -167,6 +198,9 @@ int pci_next_resource_idx(int i, int flag)
 	if (i < PCI_NUM_RESOURCES)
 		return i;
 
+	if (flag & PCI_ADDON_RES)
+		return i;
+
 	return -1;
 }
 EXPORT_SYMBOL(pci_next_resource_idx);
@@ -1199,6 +1233,7 @@ static void pci_release_dev(struct device *dev)
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
+	pci_release_dev_addon_resource(pci_dev);
 	kfree(pci_dev);
 }
 
@@ -1276,6 +1311,7 @@ struct pci_dev *alloc_pci_dev(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&dev->bus_list);
+	INIT_LIST_HEAD(&dev->addon_resources);
 
 	return dev;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 94935fc..b73245b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -308,6 +308,7 @@ struct pci_dev {
 	 */
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
+	struct list_head addon_resources; /* addon I/O and memory resource */
 
 	bool match_driver;		/* Skip attaching driver */
 	/* These fields are used by common fixups */
@@ -361,6 +362,21 @@ struct pci_dev {
 	size_t romlen; /* Length of ROM if it's not from the BAR */
 };
 
+struct resource_ops {
+	int (*read)(struct pci_dev *dev, struct resource *res, int addr);
+	int (*write)(struct pci_dev *dev, struct resource *res, int addr);
+};
+
+struct pci_dev_addon_resource {
+	struct list_head list;
+	int reg_addr;
+	int size;
+	struct resource res;
+	struct resource_ops *ops;
+};
+#define	to_pci_dev_addon_resource(n)					\
+	container_of(n, struct pci_dev_addon_resource, res)
+
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
 int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
 
@@ -369,8 +385,10 @@ int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
 #define PCI_IOV_RES		(1<<2)
 #define PCI_BRIDGE_RES		(1<<3)
 #define PCI_RES_BLOCK_NUM	4
+/* addon does not need use bitmap ...*/
+#define PCI_ADDON_RES		(1<<4)
 
-#define PCI_ALL_RES		(PCI_STD_RES | PCI_ROM_RES | PCI_BRIDGE_RES | PCI_IOV_RES)
+#define PCI_ALL_RES		(PCI_STD_RES | PCI_ROM_RES | PCI_BRIDGE_RES | PCI_IOV_RES | PCI_ADDON_RES)
 #define PCI_NOSTD_RES		(PCI_ALL_RES & ~PCI_STD_RES)
 #define PCI_NOIOV_RES		(PCI_ALL_RES & ~PCI_IOV_RES)
 #define PCI_NOROM_RES		(PCI_ALL_RES & ~PCI_ROM_RES)
-- 
1.7.10.4

