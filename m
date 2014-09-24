Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaIXPj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:39:58 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63544 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIXPiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:38:03 -0400
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 1/6] pci, thunder: Add support for Thunder PCIe host controller
Date: Wed, 24 Sep 2014 17:37:43 +0200
Message-Id: <1411573068-12952-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411573068-12952-1-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Goutham <sgoutham@cavium.com>

This patch adds support for PCI host controller of Cavium Thunder
SoCs.

Signed-off-by: Sunil Goutham <sgoutham@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 drivers/pci/host/Kconfig        |   8 ++
 drivers/pci/host/Makefile       |   1 +
 drivers/pci/host/pcie-thunder.c | 246 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h         |   2 +
 4 files changed, 257 insertions(+)
 create mode 100644 drivers/pci/host/pcie-thunder.c

diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 90f5ccacce4b..269c3ff786bc 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -63,4 +63,12 @@ config PCIE_SPEAR13XX
 	help
 	  Say Y here if you want PCIe support on SPEAr13XX SoCs.
 
+config PCI_THUNDER
+	bool "Thunder PCIe host controller"
+	depends on ARM64 || COMPILE_TEST
+	depends on OF_PCI
+	depends on PCI_MSI
+	help
+	  Say Y here if you want internal PCI support on Thunder SoC.
+
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index d0e88f114ff9..fd8041da1719 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
 obj-$(CONFIG_PCI_RCAR_GEN2_PCIE) += pcie-rcar.o
 obj-$(CONFIG_PCI_HOST_GENERIC) += pci-host-generic.o
 obj-$(CONFIG_PCIE_SPEAR13XX) += pcie-spear13xx.o
+obj-$(CONFIG_PCI_THUNDER) += pcie-thunder.o
diff --git a/drivers/pci/host/pcie-thunder.c b/drivers/pci/host/pcie-thunder.c
new file mode 100644
index 000000000000..947fad3b1980
--- /dev/null
+++ b/drivers/pci/host/pcie-thunder.c
@@ -0,0 +1,246 @@
+/*
+ * PCIe host controller driver for Cavium Thunder SOC
+ *
+ * Copyright (C) 2014, Cavium Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/of_irq.h>
+#include <linux/of_pci.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/msi.h>
+
+#define PCI_DEVICE_ID_THUNDER_BRIDGE	0xa002
+
+#define THUNDER_PCIE_BUS_SHIFT		20
+#define THUNDER_PCIE_DEV_SHIFT		15
+#define THUNDER_PCIE_FUNC_SHIFT		12
+
+struct thunder_pcie {
+	struct device_node	*node;
+	struct device		*dev;
+	void __iomem		*cfg_base;
+	struct msi_chip		*msi;
+};
+
+/*
+ * This bridge is just for the sake of supporting ARI for
+ * downstream devices. No resources are attached to it.
+ * Copy upstream root bus resources to bridge which aide in
+ * resource claiming for downstream devices
+ */
+static void pci_bridge_resource_fixup(struct pci_dev *dev)
+{
+	struct pci_bus *bus;
+	int resno;
+
+	bus = dev->subordinate;
+	for (resno = 0; resno < PCI_BRIDGE_RESOURCE_NUM; resno++) {
+		bus->resource[resno] = pci_bus_resource_n(bus->parent,
+			PCI_BRIDGE_RESOURCE_NUM + resno);
+	}
+
+	for (resno = PCI_BRIDGE_RESOURCES;
+		resno <= PCI_BRIDGE_RESOURCE_END; resno++) {
+		dev->resource[resno].start = dev->resource[resno].end = 0;
+		dev->resource[resno].flags = 0;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CAVIUM, PCI_DEVICE_ID_THUNDER_BRIDGE,
+			pci_bridge_resource_fixup);
+
+/*
+ * All PCIe devices in Thunder have fixed resources, shouldn't be reassigned.
+ * Also claim the device's valid resources to set 'res->parent' hierarchy.
+ */
+static void pci_dev_resource_fixup(struct pci_dev *dev)
+{
+	struct resource *res;
+	int resno;
+
+	for (resno = 0; resno < PCI_NUM_RESOURCES; resno++)
+		dev->resource[resno].flags |= IORESOURCE_PCI_FIXED;
+
+	for (resno = 0; resno < PCI_BRIDGE_RESOURCES; resno++) {
+		res = &dev->resource[resno];
+		if (res->parent || !(res->flags & IORESOURCE_MEM))
+			continue;
+		pci_claim_resource(dev, resno);
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CAVIUM, PCI_ANY_ID,
+			pci_dev_resource_fixup);
+
+static void __iomem *thunder_pcie_cfg_base(struct thunder_pcie *pcie,
+				 unsigned int bus, unsigned int devfn)
+{
+	return  pcie->cfg_base + ((bus << THUNDER_PCIE_BUS_SHIFT)
+		| (PCI_SLOT(devfn) << THUNDER_PCIE_DEV_SHIFT)
+		| (PCI_FUNC(devfn) << THUNDER_PCIE_FUNC_SHIFT));
+}
+
+static int thunder_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
+				  int reg, int size, u32 *val)
+{
+	struct thunder_pcie *pcie = bus->sysdata;
+	void __iomem *addr;
+	unsigned int busnr = bus->number;
+
+	if (busnr > 255 || devfn > 255 || reg > 4095)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	addr = thunder_pcie_cfg_base(pcie, busnr, devfn) + reg;
+
+	switch (size) {
+	case 1:
+		*val = readb(addr);
+		break;
+	case 2:
+		*val = readw(addr);
+		break;
+	case 4:
+		*val = readl(addr);
+		break;
+	default:
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int thunder_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
+				  int reg, int size, u32 val)
+{
+	struct thunder_pcie *pcie = bus->sysdata;
+	void __iomem *addr;
+	unsigned int busnr = bus->number;
+
+	if (busnr > 255 || devfn > 255 || reg > 4095)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	addr = thunder_pcie_cfg_base(pcie, busnr, devfn) + reg;
+
+	switch (size) {
+	case 1:
+		writeb(val, addr);
+		break;
+	case 2:
+		writew(val, addr);
+		break;
+	case 4:
+		writel(val, addr);
+		break;
+	default:
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static struct pci_ops thunder_pcie_ops = {
+	.read	= thunder_pcie_read_config,
+	.write	= thunder_pcie_write_config,
+};
+
+static int thunder_pcie_msi_enable(struct thunder_pcie *pcie,
+					struct pci_bus *bus)
+{
+	struct device_node *msi_node;
+
+	msi_node = of_parse_phandle(pcie->node, "msi-parent", 0);
+	if (!msi_node)
+		return -ENODEV;
+
+	pcie->msi = of_pci_find_msi_chip_by_node(msi_node);
+	if (!pcie->msi)
+		return -ENODEV;
+
+	pcie->msi->dev = pcie->dev;
+	bus->msi = pcie->msi;
+
+	return 0;
+}
+
+static int thunder_pcie_probe(struct platform_device *pdev)
+{
+	struct thunder_pcie *pcie;
+	struct resource *cfg_base;
+	struct pci_bus *bus;
+	int ret;
+	LIST_HEAD(res);
+
+	pcie = devm_kzalloc(&pdev->dev, sizeof(*pcie), GFP_KERNEL);
+	if (!pcie)
+		return -ENOMEM;
+
+	pcie->node = of_node_get(pdev->dev.of_node);
+	pcie->dev = &pdev->dev;
+
+	/* Get controller's configuration space range */
+	cfg_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pcie->cfg_base = devm_ioremap_resource(&pdev->dev, cfg_base);
+	if (IS_ERR(pcie->cfg_base)) {
+		ret = PTR_ERR(pcie->cfg_base);
+		goto err_ioremap;
+	}
+
+	ret = of_pci_get_host_bridge_resources(pdev->dev.of_node,
+					       0, 255, &res, NULL);
+	if (ret)
+		goto err_get_host;
+
+	bus = pci_create_root_bus(&pdev->dev, 0, &thunder_pcie_ops, pcie, &res);
+	if (!bus) {
+		ret = -ENODEV;
+		goto err_root_bus;
+	}
+
+	/* Set reference to MSI chip */
+	ret = thunder_pcie_msi_enable(pcie, bus);
+	if (ret)
+		goto err_msi;
+
+	platform_set_drvdata(pdev, pcie);
+
+	pci_scan_child_bus(bus);
+	pci_bus_add_devices(bus);
+
+	return 0;
+err_msi:
+	pci_remove_root_bus(bus);
+err_root_bus:
+	pci_free_resource_list(&res);
+err_get_host:
+	devm_ioremap_release(pcie->dev, pcie->cfg_base);
+err_ioremap:
+	of_node_put(pcie->node);
+	kfree(pcie);
+	return ret;
+}
+
+static const struct of_device_id thunder_pcie_of_match[] = {
+	{ .compatible = "cavium,thunder-pcie", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, thunder_pcie_of_match);
+
+static struct platform_driver thunder_pcie_driver = {
+	.driver = {
+		.name = "thunder-pcie",
+		.owner = THIS_MODULE,
+		.of_match_table = thunder_pcie_of_match,
+	},
+	.probe = thunder_pcie_probe,
+};
+module_platform_driver(thunder_pcie_driver);
+
+MODULE_AUTHOR("Sunil Goutham");
+MODULE_DESCRIPTION("Cavium Thunder PCIe host controller driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb73a864..60f16b888c9d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2322,6 +2322,8 @@
 #define PCI_DEVICE_ID_ALTIMA_AC9100	0x03ea
 #define PCI_DEVICE_ID_ALTIMA_AC1003	0x03eb
 
+#define PCI_VENDOR_ID_CAVIUM		0x177d
+
 #define PCI_VENDOR_ID_BELKIN		0x1799
 #define PCI_DEVICE_ID_BELKIN_F5D7010V7	0x701f
 
-- 
2.1.0

