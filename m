Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaEROJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 10:09:04 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:63563 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaEROJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 10:09:02 -0400
From: Srikanth Thokala <sthokal@xilinx.com>
To: bhelgaas@google.com
Cc: will.deacon@arm.com, arnd@arndb.de, michals@xilinx.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH] PCI: Generic Configuration Access Mechanism support
Date: Sun, 18 May 2014 19:38:45 +0530
Message-Id: <1400422125-2209-1-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for a generic CAM and ECAM configuration
space accesses.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
---
This patch is created with reference from Will's patch series:
1/3 - "ARM: kconfig: allow PCI support to be selected with ARCH_MULTIPLATFORM"
2/3 - "PCI: ARM: add support for generic PCI host controller"
3/3 - "MAINTAINERS: add entry for generic PCI host controller driver"
---
 drivers/pci/Makefile  |    2 +-
 drivers/pci/pci-cfg.c |  162 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h   |   34 +++++++++++
 3 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pci/pci-cfg.c

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e04fe2d..37cfc33 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -4,7 +4,7 @@
 
 obj-y		+= access.o bus.o probe.o host-bridge.o remove.o pci.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
-			irq.o vpd.o setup-bus.o vc.o
+			irq.o vpd.o setup-bus.o vc.o pci-cfg.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSFS) += slot.o
 
diff --git a/drivers/pci/pci-cfg.c b/drivers/pci/pci-cfg.c
new file mode 100644
index 0000000..2b15fe4
--- /dev/null
+++ b/drivers/pci/pci-cfg.c
@@ -0,0 +1,162 @@
+/*
+ * PCI generic configuration access mechanism
+ *
+ * Copyright (C) 2014 ARM Limited
+ * Copyright (c) 2014 Xilinx, Inc.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/of_pci.h>
+
+/* CAM definitions */
+#define PCI_CFG_CAM_BUS_NUM	16
+#define PCI_CFG_CAM_DEV_NUM	8
+
+/* ECAM definitions */
+#define PCI_CFG_ECAM_BUS_NUM	20
+#define PCI_CFG_ECAM_DEV_NUM	12
+
+/* Invalid device/function value */
+#define PCI_CFG_INVALID_DEVFN	0xFFFFFFFF
+
+/**
+ * pci_cfg_map_bus_cam - Get the CAM based configuration space address
+ * @bus: PCI Bus pointer
+ * @devfn: Device/Function
+ * @where: Offset from base
+ *
+ * Return: Configuration Space address
+ */
+static void __iomem *pci_cfg_map_bus_cam(struct pci_bus *bus,
+					 unsigned int devfn,
+					 int where)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	struct pci_cfg_windows *cfg = sys->private_data;
+	resource_size_t idx = bus->number - cfg->bus_range.start;
+
+	return cfg->win[idx] + ((devfn << PCI_CFG_CAM_DEV_NUM) | where);
+}
+
+/**
+ * pci_cfg_map_bus_ecam - Get the ECAM based configuration space address
+ * @bus: PCI bus pointer
+ * @devfn: Device/Function
+ * @where: Offset from base
+ *
+ * Return: Configuration space address
+ */
+static void __iomem *pci_cfg_map_bus_ecam(struct pci_bus *bus,
+					  unsigned int devfn,
+					  int where)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	struct pci_cfg_windows *cfg = sys->private_data;
+	resource_size_t idx = bus->number - cfg->bus_range.start;
+
+	return cfg->win[idx] + ((devfn << PCI_CFG_ECAM_DEV_NUM) | where);
+}
+
+/**
+ * pci_cfg_read - Read configuration space
+ * @bus: PCI bus pointer
+ * @devfn: Device/function
+ * @where: Offset from base
+ * @size: Byte/word/dword
+ * @val: Value to be read
+ *
+ * Return: PCIBIOS_SUCCESSFUL on success
+ *	   PCIBIOS_DEVICE_NOT_FOUND on failure
+ */
+static int pci_cfg_read(struct pci_bus *bus, unsigned int devfn,
+			int where, int size, unsigned int *val)
+{
+	void __iomem *addr;
+	struct pci_sys_data *sys = bus->sysdata;
+	struct pci_cfg_windows *cfg = sys->private_data;
+
+	if (cfg->ops->is_valid_cfg_access) {
+		if (!cfg->ops->is_valid_cfg_access(bus, devfn)) {
+			*val = PCI_CFG_INVALID_DEVFN;
+			return PCIBIOS_DEVICE_NOT_FOUND;
+		}
+	}
+
+	addr = cfg->ops->map_bus(bus, devfn, where);
+
+	switch (size) {
+	case 1:
+		*val = readb(addr);
+		break;
+	case 2:
+		*val = readw(addr);
+		break;
+	default:
+		*val = readl(addr);
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+/**
+ * pci_cfg_write - Write configuration space
+ * @bus: PCI bus pointer
+ * @devfn: Device/function
+ * @where: Offset from base
+ * @size: Byte/word/dword
+ * @val: Value to write
+ *
+ * Return: PCIBIOS_SUCCESSFUL on success
+ *	   PCIBIOS_DEVICE_NOT_FOUND on failure
+ */
+static int pci_cfg_write(struct pci_bus *bus, unsigned int devfn,
+			 int where, int size, unsigned int val)
+{
+	void __iomem *addr;
+	struct pci_sys_data *sys = bus->sysdata;
+	struct pci_cfg_windows *cfg = sys->private_data;
+
+	if (cfg->ops->is_valid_cfg_access)
+		if (!cfg->ops->is_valid_cfg_access(bus, devfn))
+			return PCIBIOS_DEVICE_NOT_FOUND;
+
+	addr = cfg->ops->map_bus(bus, devfn, where);
+
+	switch (size) {
+	case 1:
+		writeb(val, addr);
+		break;
+	case 2:
+		writew(val, addr);
+		break;
+	default:
+		writel(val, addr);
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+/* Generic PCI CAM/ECAM Configuration Bus Operations */
+
+struct pci_cfg_bus_ops pci_cfg_cam_bus_ops = {
+	.bus_shift	= PCI_CFG_CAM_BUS_NUM,
+	.map_bus	= pci_cfg_map_bus_cam,
+};
+EXPORT_SYMBOL_GPL(pci_cfg_cam_bus_ops);
+
+struct pci_cfg_bus_ops pci_cfg_ecam_bus_ops = {
+	.bus_shift	= PCI_CFG_ECAM_BUS_NUM,
+	.map_bus	= pci_cfg_map_bus_ecam,
+};
+EXPORT_SYMBOL_GPL(pci_cfg_ecam_bus_ops);
+
+struct pci_ops pci_cfg_ops = {
+	.read	= pci_cfg_read,
+	.write	= pci_cfg_write,
+};
+EXPORT_SYMBOL_GPL(pci_cfg_ops);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aab57b4..6ebe21e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1806,4 +1806,38 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
  */
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
 
+/**
+ * struct pci_cfg_bus_ops - PCI bus configuration operations
+ * @bus_shift: Bus number
+ * @map_bus: Function pointer to get the configuration space address
+ * @is_valid_cfg_access: Function pointer to check for a valid device/function
+ */
+struct pci_cfg_bus_ops {
+	u32 bus_shift;
+	void __iomem *(*map_bus)(struct pci_bus *, unsigned int, int);
+	/*
+	 * This function pointer is to check if we are addressing a valid
+	 * device's function under a particular bus.
+	 */
+	int (*is_valid_cfg_access)(struct pci_bus *, unsigned int);
+};
+
+/**
+ * struct pci_cfg_windows - PCI bus configuration memory windows
+ * @res: Configuration space resource
+ * @bus_range: Bus range
+ * @win: Configuration space memory windows
+ * @ops: PCI bus configuration operations
+ */
+struct pci_cfg_windows {
+	struct resource	res;
+	struct resource	bus_range;
+	void __iomem **win;
+	struct pci_cfg_bus_ops *ops;
+};
+
+extern struct pci_ops pci_cfg_ops;
+extern struct pci_cfg_bus_ops pci_cfg_ecam_bus_ops;
+extern struct pci_cfg_bus_ops pci_cfg_cam_bus_ops;
+
 #endif /* LINUX_PCI_H */
-- 
1.7.9.5

