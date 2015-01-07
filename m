Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbbAGSv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:51:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58923 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbbAGSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:50:47 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <joro@8bytes.org>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 3/4] of/pci: add of_pci_dma_configure() update dma configuration
Date: Wed, 7 Jan 2015 13:49:53 -0500
Message-ID: <1420656594-8908-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_pci_dma_configure() to allow updating the dma configuration
of the pci device using the configuration from DT of the parent of
the root bridge device.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/of/of_pci.c    |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_pci.h |   12 ++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 88471d3..34878c9 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -2,6 +2,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_device.h>
 #include <linux/of_pci.h>
 #include <linux/slab.h>
 
@@ -229,6 +230,44 @@ parse_failed:
 	return err;
 }
 EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
+
+/**
+ * of_get_pci_root_bridge_parent - get the OF node of the root bridge's parent
+ * @dev: ptr to pci_dev struct of the pci device
+ *
+ * This function will traverse the bus up to the root bus starting with
+ * the child and return the OF node ptr to root bridge device's parent device.
+ */
+struct device_node *of_get_pci_root_bridge_parent(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+	struct device *bridge;
+
+	while (!pci_is_root_bus(bus))
+		bus = bus->parent;
+	bridge = bus->bridge;
+
+	return bridge->parent->of_node;
+}
+EXPORT_SYMBOL_GPL(of_get_pci_root_bridge_parent);
+
+/**
+ * of_pci_dma_configure - Setup DMA configuration
+ * @dev: ptr to pci_dev struct of the pci device
+ *
+ * Function to update PCI devices's DMA configuration using the same
+ * info from the OF node of root host bridge's parent.
+ */
+void of_pci_dma_configure(struct pci_dev *pci_dev)
+{
+	struct device *dev = &pci_dev->dev;
+	struct device_node *parent_np;
+
+	parent_np = of_get_pci_root_bridge_parent(pci_dev);
+	of_dma_configure(dev, parent_np);
+}
+EXPORT_SYMBOL_GPL(of_pci_dma_configure);
+
 #endif /* CONFIG_OF_ADDRESS */
 
 #ifdef CONFIG_PCI_MSI
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index ce0e5ab..0465a2a 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -16,6 +16,8 @@ int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 int of_get_pci_domain_nr(struct device_node *node);
+struct device_node *of_get_pci_root_bridge_parent(struct pci_dev *dev);
+void of_pci_dma_configure(struct pci_dev *pci_dev);
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
@@ -50,6 +52,16 @@ of_get_pci_domain_nr(struct device_node *node)
 {
 	return -1;
 }
+
+static inline struct device_node
+*of_get_pci_root_bridge_parent(struct pci_dev *dev)
+{
+	return NULL;
+}
+
+static inline void of_pci_dma_configure(struct pci_dev *pci_dev)
+{
+}
 #endif
 
 #if defined(CONFIG_OF_ADDRESS)
-- 
1.7.9.5

