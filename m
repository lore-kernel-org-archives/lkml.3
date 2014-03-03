Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaCCNmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:42:45 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44823 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaCCNmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:42:42 -0500
From: Srikanth Thokala <sthokal@xilinx.com>
To: bhelgaas@google.com, michal.simek@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: jgunthorpe@obsidianresearch.com, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH v2] pcie: Add Xilinx PCIe Host Bridge IP driver
Date: Mon,  3 Mar 2014 19:10:36 +0530
Message-Id: <1393854036-5244-1-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the driver for Xilinx AXI PCIe Host Bridge Soft IP

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
---
- Rebased on v3.14.0-rc5
- Removed IP specific DT properties like include-rc, axibar-num etc.,
  as suggested by Jason and Bjorn, Thanks
---
 .../devicetree/bindings/pci/xilinx-pcie.txt        |   23 +
 drivers/pci/host/Kconfig                           |    7 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-xilinx.c                      |  940 ++++++++++++++++++++
 4 files changed, 971 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/xilinx-pcie.txt
 create mode 100644 drivers/pci/host/pci-xilinx.c

diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
new file mode 100644
index 0000000..b0ea448
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
@@ -0,0 +1,23 @@
+* Xilinx AXI PCIe Root Port Bridge DT description
+
+Required properties:
+- #address-cells: Address representation for root ports, set to <3>
+- #size-cells: Size representation for root ports, set to <2>
+- compatible: Should contain "xlnx,axi-pcie-host-1.00.a"
+- reg: Should contain AXI PCIe registers location and length
+- interrupts: Should contain AXI PCIe interrupt
+- ranges: ranges for the PCI memory regions
+	Please refer to the standard PCI bus binding document for a more
+	detailed explanation
+
+Example:
+++++++++
+
+	pci_express: axi-pcie@50000000 {
+		#address-cells = <3>;
+		#size-cells = <2>;
+		compatible = "xlnx,axi-pcie-host-1.00.a";
+		reg = < 0x50000000 0x10000000 >;
+		interrupts = < 0 52 4 >;
+		ranges = < 0x02000000 0 0x60000000 0x60000000 0 0x10000000 >;
+	};
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 47d46c6..8771824 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -33,4 +33,11 @@ config PCI_RCAR_GEN2
 	  There are 3 internal PCI controllers available with a single
 	  built-in EHCI/OHCI host controller present on each one.
 
+config PCI_XILINX
+	bool "Xilinx AXI PCIe host bridge support"
+	depends on ARCH_ZYNQ
+	help
+	  Say 'Y' here if you want kernel to support the Xilinx AXI PCIe
+	  Host Bridge driver.
+
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 13fb333..4e9c843 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
+obj-$(CONFIG_PCI_XILINX) += pci-xilinx.o
diff --git a/drivers/pci/host/pci-xilinx.c b/drivers/pci/host/pci-xilinx.c
new file mode 100644
index 0000000..209d2fb
--- /dev/null
+++ b/drivers/pci/host/pci-xilinx.c
@@ -0,0 +1,940 @@
+/*
+ * PCIe host controller driver for Xilinx AXI PCIe Bridge
+ *
+ * Copyright (c) 2012 - 2014 Xilinx, Inc.
+ *
+ * Based on the Tegra PCIe driver
+ *
+ * Bits taken from Synopsys Designware Host controller driver
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/msi.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+
+/* Register definitions */
+#define XILINX_PCIE_REG_VSECC		0x00000128
+#define XILINX_PCIE_REG_VSECH		0x0000012c
+#define XILINX_PCIE_REG_BIR		0x00000130
+#define XILINX_PCIE_REG_BSCR		0x00000134
+#define XILINX_PCIE_REG_IDR		0x00000138
+#define XILINX_PCIE_REG_IMR		0x0000013c
+#define XILINX_PCIE_REG_BLR		0x00000140
+#define XILINX_PCIE_REG_PSCR		0x00000144
+#define XILINX_PCIE_REG_RPSC		0x00000148
+#define XILINX_PCIE_REG_MSIBASE1	0x0000014c
+#define XILINX_PCIE_REG_MSIBASE2	0x00000150
+#define XILINX_PCIE_REG_RPEFR		0x00000154
+#define XILINX_PCIE_REG_RPIFR1		0x00000158
+#define XILINX_PCIE_REG_RPIFR2		0x0000015c
+#define XILINX_PCIE_REG_VSECC2		0x00000200
+#define XILINX_PCIE_REG_VSECH2		0x00000204
+
+/* Interrupt registers definitions */
+#define XILINX_PCIE_INTR_LINK_DOWN	BIT(0)
+#define XILINX_PCIE_INTR_ECRC_ERR	BIT(1)
+#define XILINX_PCIE_INTR_STR_ERR	BIT(2)
+#define XILINX_PCIE_INTR_HOT_RESET	BIT(3)
+#define XILINX_PCIE_INTR_CFG_COMPL	GENMASK(7, 5)
+#define XILINX_PCIE_INTR_CFG_TIMEOUT	BIT(8)
+#define XILINX_PCIE_INTR_CORRECTABLE	BIT(9)
+#define XILINX_PCIE_INTR_NONFATAL	BIT(10)
+#define XILINX_PCIE_INTR_FATAL		BIT(11)
+#define XILINX_PCIE_INTR_INTX		BIT(16)
+#define XILINX_PCIE_INTR_MSI		BIT(17)
+#define XILINX_PCIE_INTR_SLV_UNSUPP	BIT(20)
+#define XILINX_PCIE_INTR_SLV_UNEXP	BIT(21)
+#define XILINX_PCIE_INTR_SLV_COMPL	BIT(22)
+#define XILINX_PCIE_INTR_SLV_ERRP	BIT(23)
+#define XILINX_PCIE_INTR_SLV_CMPABT	BIT(24)
+#define XILINX_PCIE_INTR_SLV_ILLBUR	BIT(25)
+#define XILINX_PCIE_INTR_MST_DECERR	BIT(26)
+#define XILINX_PCIE_INTR_MST_SLVERR	BIT(27)
+#define XILINX_PCIE_INTR_MST_ERRP	BIT(28)
+#define XILINX_PCIE_IMR_ALL_MASK	0x1FF30FED
+#define XILINX_PCIE_IDR_ALL_MASK	0xFFFFFFFF
+
+/* Root Port Error FIFO Read Register definitions */
+#define XILINX_PCIE_RPEFR_ERR_VALID	BIT(18)
+#define XILINX_PCIE_RPEFR_REQ_ID	GENMASK(15, 0)
+#define XILINX_PCIE_RPEFR_ALL_MASK	0xFFFFFFFF
+
+/* Root Port Interrupt FIFO Read Register 1 definitions */
+#define XILINX_PCIE_RPIFR1_INTR_VALID	BIT(31)
+#define XILINX_PCIE_RPIFR1_MSI_INTR	BIT(30)
+#define XILINX_PCIE_RPIFR1_INTR_ASSRT	BIT(29)
+#define XILINX_PCIE_RPIFR1_MSI_ADR_MASK	GENMASK(26, 16)
+#define XILINX_PCIE_RPIFR1_ALL_MASK	0xFFFFFFFF
+#define XILINX_PCIE_RPIFR1_MSI_ADR_SHIFT	16
+
+/* Bridge Info Register definitions */
+#define XILINX_PCIE_BIR_ECAM_SZ_MASK	GENMASK(18, 16)
+#define XILINX_PCIE_BIR_ECAM_SZ_SHIFT	16
+
+/* Root Port Interrupt FIFO Read Register 2 definitions */
+#define XILINX_PCIE_RPIFR2_MSG_DATA	GENMASK(15, 0)
+
+/* Root Port Status/control Register definitions */
+#define XILINX_PCIE_REG_RPSC_BEN	BIT(0)
+
+/* Phy Status/Control Register definitions */
+#define XILINX_PCIE_REG_PSCR_LNKUP	BIT(11)
+
+/* ECAM definitions */
+#define ECAM_BUS_NUM_SHIFT		20
+#define ECAM_DEV_NUM_SHIFT		12
+
+/* PCI Configuration space Bus Number Register definitions */
+#define PCI_SECONDARY_BUS_NUM_SHIFT	8
+#define PCI_SUBORDINATE_BUS_NUM_SHIFT	16
+#define PCI_LATENCY_TIMER_MASK		GENMASK(31, 24)
+
+/* Number of MSI IRQs */
+#define XILINX_NUM_MSI_IRQS		128
+
+/* Number of Memory Resources */
+#define XILINX_MAX_NUM_RESOURCES	3
+
+/**
+ * struct xilinx_pcie_port - PCIe port information
+ * @reg_base: IO Mapped Register Base
+ * @phys_reg_base: Physical Register Base
+ * @reg_size: Register space
+ * @irq: Interrupt number
+ * @msg_addr: MSI message address
+ * @root_busno: Root Bus number
+ * @mem_resno: Number of memory resources
+ * @link_up: Link status flag
+ * @node: Device tree node
+ * @dev: Device pointer
+ * @irq_domain: IRQ domain pointer
+ * @mem: Memory Resources
+ */
+struct xilinx_pcie_port {
+	void __iomem *reg_base;
+	u32 phys_reg_base;
+	u32 reg_size;
+	u32 irq;
+	unsigned long msg_addr;
+	u8 root_busno;
+	u8 mem_resno;
+	bool link_up;
+	struct device_node *node;
+	struct device *dev;
+	struct irq_domain *irq_domain;
+	struct resource mem[XILINX_MAX_NUM_RESOURCES];
+};
+
+static DECLARE_BITMAP(msi_irq_in_use, XILINX_NUM_MSI_IRQS);
+
+static inline struct xilinx_pcie_port *sys_to_pcie(struct pci_sys_data *sys)
+{
+	return sys->private_data;
+}
+
+static inline u32 pcie_read(struct xilinx_pcie_port *port, u32 reg)
+{
+	return readl(port->reg_base + reg);
+}
+
+static inline void pcie_write(struct xilinx_pcie_port *port,
+					 u32 val, u32 reg)
+{
+	writel(val, port->reg_base + reg);
+}
+
+static inline bool xilinx_pcie_is_link_up(struct xilinx_pcie_port *port)
+{
+	return (pcie_read(port, XILINX_PCIE_REG_PSCR) &
+		XILINX_PCIE_REG_PSCR_LNKUP) ? 1 : 0;
+}
+
+/**
+ * xilinx_pcie_clear_err_interrupts - Clear Error Interrupts
+ * @port: PCIe port information
+ */
+static inline void
+xilinx_pcie_clear_err_interrupts(struct xilinx_pcie_port *port)
+{
+	u32 val = pcie_read(port, XILINX_PCIE_REG_RPEFR);
+
+	if (val & XILINX_PCIE_RPEFR_ERR_VALID) {
+		dev_dbg(port->dev, "Requester ID %d\n",
+			val & XILINX_PCIE_RPEFR_REQ_ID);
+		pcie_write(port, XILINX_PCIE_RPEFR_ALL_MASK,
+				XILINX_PCIE_REG_RPEFR);
+	}
+}
+
+/**
+ * xilinx_pcie_verify_config - Verify configuration
+ * @port: PCIe port information
+ * @bus: Bus structure of current bus
+ * @devfn: device/function
+ *
+ * Return: 0 on success and PCIBIOS_DEVICE_NOT_FOUND on error
+ */
+static int xilinx_pcie_verify_config(struct xilinx_pcie_port *port,
+					struct pci_bus *bus,
+					unsigned int devfn)
+{
+	/* Check if link is up when trying to access downstream ports */
+	if (bus->number != port->root_busno)
+		if (!xilinx_pcie_is_link_up(port))
+			return 0;
+
+	/* Only one device down on each root port */
+	if (bus->number == port->root_busno && devfn > 0)
+		return 0;
+
+	/*
+	 * Do not read more than one device on the bus directly attached
+	 * to RC.
+	 */
+	if (bus->primary == port->root_busno && devfn > 0)
+		return 0;
+
+	return 1;
+}
+
+/**
+ * xilinx_pcie_get_config_base - Get configuration base
+ * @port: PCIe port information
+ * @bus: Bus structure of current bus
+ * @devfn: Device/function
+ * @where: Offset from base
+ *
+ * Return: Base address of the configuration space needed to be
+ *	   accessed.
+ */
+static void __iomem *xilinx_pcie_get_config_base(struct xilinx_pcie_port *port,
+						 struct pci_bus *bus,
+						 unsigned int devfn,
+						 int where)
+{
+	int relbus;
+
+	relbus = (bus->number << ECAM_BUS_NUM_SHIFT) |
+		 (devfn << ECAM_DEV_NUM_SHIFT);
+
+	return port->reg_base + relbus + where;
+}
+
+/**
+ * xilinx_pcie_read_config - Read configuration space
+ * @bus: Bus structure of current bus
+ * @devfn: Device/function
+ * @where: Offset from base
+ * @size: Byte/word/dword
+ * @val: Value to be read
+ *
+ * Return: PCIBIOS_SUCCESSFUL on success
+ *	   EINVAL/PCIBIOS_DEVICE_NOT_FOUND/PCIBIOS_BAD_REGISTER_NUMBER
+ *	   on failure.
+ */
+static int xilinx_pcie_read_config(struct pci_bus *bus,
+				unsigned int devfn,
+				int where,
+				int size,
+				u32 *val)
+{
+	struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
+	void __iomem *addr;
+
+	if (!port) {
+		BUG();
+		return -EINVAL;
+	}
+
+	if (!xilinx_pcie_verify_config(port, bus, devfn)) {
+		*val = 0xFFFFFFFF;
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	addr = xilinx_pcie_get_config_base(port, bus, devfn, where);
+	if (!addr)
+		return PCIBIOS_BAD_REGISTER_NUMBER;
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
+		break;
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+/**
+ * xilinx_pcie_write_config - Write configuration space
+ * @bus: Bus structure of current bus
+ * @devfn: Device/function
+ * @where: Offset from base
+ * @size: Byte/word/dword
+ * @val: Value to be written to device
+ *
+ * Return: PCIBIOS_SUCCESSFUL on success,
+ *	   EINVAL/PCIBIOS_DEVICE_NOT_FOUND/PCIBIOS_BAD_REGISTER_NUMBER
+ *	   on failure.
+ */
+static int xilinx_pcie_write_config(struct pci_bus *bus,
+				unsigned int devfn,
+				int where,
+				int size,
+				u32 val)
+{
+	struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
+	void __iomem *addr;
+
+	if (!port) {
+		BUG();
+		return -EINVAL;
+	}
+
+	if (!xilinx_pcie_verify_config(port, bus, devfn))
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	addr = xilinx_pcie_get_config_base(port, bus, devfn, where);
+	if (!addr)
+		return PCIBIOS_BAD_REGISTER_NUMBER;
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
+		break;
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+/* PCIe operations */
+static struct pci_ops xilinx_pcie_ops = {
+	.read  = xilinx_pcie_read_config,
+	.write = xilinx_pcie_write_config,
+};
+
+/* MSI functions */
+
+/**
+ * xilinx_pcie_destroy_msi - Free MSI number
+ * @irq: IRQ to be freed
+ */
+static void xilinx_pcie_destroy_msi(unsigned int irq)
+{
+	struct irq_desc *desc;
+	struct msi_desc *msi;
+	struct xilinx_pcie_port *port;
+
+	desc = irq_to_desc(irq);
+	msi = irq_desc_get_msi_desc(desc);
+	port = sys_to_pcie(msi->dev->bus->sysdata);
+	if (!port) {
+		BUG();
+		return;
+	}
+
+	if (!test_bit(irq, msi_irq_in_use))
+		dev_err(port->dev, "Trying to free unused MSI#%d\n", irq);
+	else
+		clear_bit(irq, msi_irq_in_use);
+}
+
+/**
+ * xilinx_pcie_assign_msi - Allocate MSI number
+ * @port: PCIe port structure
+ *
+ * Return: A valid IRQ on success and error value on failure.
+ */
+static int xilinx_pcie_assign_msi(struct xilinx_pcie_port *port)
+{
+	int pos;
+
+	pos = find_first_zero_bit(msi_irq_in_use, XILINX_NUM_MSI_IRQS);
+	if (pos < XILINX_NUM_MSI_IRQS)
+		set_bit(pos, msi_irq_in_use);
+	else
+		return -ENOSPC;
+
+	return irq_find_mapping(port->irq_domain, pos);
+}
+
+/**
+ * xilinx_msi_teardown_irq - Destroy the MSI
+ * @chip: MSI Chip descriptor
+ * @irq: MSI IRQ to destroy
+ */
+static void xilinx_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+{
+	xilinx_pcie_destroy_msi(irq);
+}
+
+/**
+ * xilinx_pcie_msi_setup_irq - Setup MSI request
+ * @chip: MSI chip pointer
+ * @pdev: PCIe device pointer
+ * @desc: MSI descriptor pointer
+ *
+ * Return: '0' on success and error value on failure
+ */
+static int xilinx_pcie_msi_setup_irq(struct msi_chip *chip,
+					struct pci_dev *pdev,
+					struct msi_desc *desc)
+{
+	struct xilinx_pcie_port *port = sys_to_pcie(pdev->bus->sysdata);
+	int irq;
+	struct msi_msg msg;
+
+	if (!port) {
+		BUG();
+		return -EINVAL;
+	}
+
+	irq = xilinx_pcie_assign_msi(port);
+	if (irq < 0)
+		return irq;
+
+	irq_set_msi_desc(irq, desc);
+
+	msg.address_hi = 0;
+	msg.address_lo = virt_to_phys((void *)port->msg_addr);
+	msg.data = irq;
+
+	write_msi_msg(irq, &msg);
+
+	return 0;
+}
+
+/* MSI Chip Descriptor */
+static struct msi_chip xilinx_pcie_msi_chip = {
+	.setup_irq = xilinx_pcie_msi_setup_irq,
+	.teardown_irq = xilinx_msi_teardown_irq,
+};
+
+/* HW Interrupt Chip Descriptor */
+static struct irq_chip xilinx_msi_irq_chip = {
+	.name = "Xilinx PCIe MSI",
+	.irq_enable = unmask_msi_irq,
+	.irq_disable = mask_msi_irq,
+	.irq_mask = mask_msi_irq,
+	.irq_unmask = unmask_msi_irq,
+};
+
+/**
+ * xilinx_pcie_msi_map - Set the handler for the MSI and mark IRQ as valid
+ * @domain: IRQ domain
+ * @irq: Virtual IRQ number
+ * @hwirq: HW interrupt number
+ *
+ * Return: Always returns 0.
+ */
+static int xilinx_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
+				irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(irq, &xilinx_msi_irq_chip, handle_simple_irq);
+	irq_set_chip_data(irq, domain->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+/* IRQ Domain operations */
+static const struct irq_domain_ops msi_domain_ops = {
+	.map = xilinx_pcie_msi_map,
+};
+
+/**
+ * xilinx_pcie_enable_msi - Enable MSI support
+ * @port: PCIe port information
+ */
+static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
+{
+	port->msg_addr = __get_free_pages(GFP_KERNEL, 0);
+
+	pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);
+	pcie_write(port, virt_to_phys((void *)port->msg_addr),
+			XILINX_PCIE_REG_MSIBASE2);
+}
+
+/* PCIe HW Functions */
+
+/**
+ * xilinx_pcie_setup - Setup memory resources
+ * @nr: Bus number
+ * @sys: Per controller structure
+ *
+ * Return: '1' on success and '0' on failure
+ */
+static int xilinx_pcie_setup(int nr, struct pci_sys_data *sys)
+{
+	struct xilinx_pcie_port *port = sys_to_pcie(sys);
+	int i;
+
+	if (!port)
+		return 0;
+
+	for (i = 0; i < port->mem_resno; i++)
+		pci_add_resource_offset(&sys->resources, &port->mem[i],
+					sys->mem_offset);
+
+	return 1;
+}
+
+/**
+ * xilinx_pcie_add_bus - Add MSI chip info to PCIe bus
+ * @bus: PCIe bus
+ */
+static void xilinx_pcie_add_bus(struct pci_bus *bus)
+{
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
+
+		if (!port)
+			return;
+
+		xilinx_pcie_msi_chip.dev = port->dev;
+		bus->msi = &xilinx_pcie_msi_chip;
+	}
+}
+
+/**
+ * xilinx_pcie_scan_bus - Scan PCIe bus for devices
+ * @nr: Bus number
+ * @sys: Per controller structure
+ *
+ * Return: Valid Bus pointer on success and NULL on failure
+ */
+static struct pci_bus __init *xilinx_pcie_scan_bus(int nr,
+				struct pci_sys_data *sys)
+{
+	struct xilinx_pcie_port *port = sys_to_pcie(sys);
+	struct pci_bus *bus;
+
+	if (port) {
+		port->root_busno = sys->busnr;
+		bus = pci_scan_root_bus(NULL, sys->busnr, &xilinx_pcie_ops,
+					sys, &sys->resources);
+	} else {
+		bus = NULL;
+		BUG();
+	}
+
+	return bus;
+}
+
+/**
+ * xilinx_pcie_map_irq - Get the interrupt of this port
+ * @dev: PCIe device
+ * @slot: Bridge slot
+ * @pin: Interrupt pin
+ *
+ * Return: Interrupt number on success and error value on failure
+ */
+static int xilinx_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct xilinx_pcie_port *port = sys_to_pcie(dev->bus->sysdata);
+
+	if (!port)
+		return -EINVAL;
+
+	return port->irq;
+}
+
+/**
+ * xilinx_pcie_intr_handler - Interrupt Service Handler
+ * @irq: IRQ number
+ * @data: PCIe port information
+ *
+ * Return: IRQ_HANDLED on success and IRQ_NONE on failure
+ */
+static irqreturn_t xilinx_pcie_intr_handler(int irq, void *data)
+{
+	struct xilinx_pcie_port *port = (struct xilinx_pcie_port *)data;
+	u32 val, mask, status, msi_data;
+
+	/* Read interrupt decode and mask registers */
+	val = pcie_read(port, XILINX_PCIE_REG_IDR);
+	mask = pcie_read(port, XILINX_PCIE_REG_IMR);
+
+	status = val & mask;
+	if (!status)
+		return IRQ_NONE;
+
+	if (status & XILINX_PCIE_INTR_LINK_DOWN)
+		dev_warn(port->dev, "Link Down\n");
+
+	if (status & XILINX_PCIE_INTR_ECRC_ERR)
+		dev_warn(port->dev, "ECRC failed\n");
+
+	if (status & XILINX_PCIE_INTR_STR_ERR)
+		dev_warn(port->dev, "Streaming error\n");
+
+	if (status & XILINX_PCIE_INTR_HOT_RESET)
+		dev_info(port->dev, "Hot reset\n");
+
+	if (status & XILINX_PCIE_INTR_CFG_TIMEOUT)
+		dev_warn(port->dev, "ECAM access timeout\n");
+
+	if (status & XILINX_PCIE_INTR_CORRECTABLE) {
+		dev_warn(port->dev, "Correctable error message\n");
+		xilinx_pcie_clear_err_interrupts(port);
+	}
+
+	if (status & XILINX_PCIE_INTR_NONFATAL) {
+		dev_warn(port->dev, "Non fatal error message\n");
+		xilinx_pcie_clear_err_interrupts(port);
+	}
+
+	if (status & XILINX_PCIE_INTR_FATAL) {
+		dev_warn(port->dev, "Fatal error message\n");
+		xilinx_pcie_clear_err_interrupts(port);
+	}
+
+	if (status & XILINX_PCIE_INTR_INTX) {
+		/* INTx interrupt received */
+		val = pcie_read(port, XILINX_PCIE_REG_RPIFR1);
+
+		/* Check whether interrupt valid */
+		if (!(val & XILINX_PCIE_RPIFR1_INTR_VALID)) {
+			dev_warn(port->dev, "RP Intr FIFO1 read error\n");
+			return IRQ_HANDLED;
+		}
+
+		/* Check MSI or INTX */
+		if (!(val & XILINX_PCIE_RPIFR1_MSI_INTR)) {
+			if (val & XILINX_PCIE_RPIFR1_INTR_ASSRT)
+				dev_dbg(port->dev, "INTx assert\n");
+			else
+				dev_dbg(port->dev, "INTx deassert\n");
+		}
+
+		/* Clear interrupt FIFO register 1 */
+		pcie_write(port, XILINX_PCIE_RPIFR1_ALL_MASK,
+				XILINX_PCIE_REG_RPIFR1);
+	}
+
+	if (status & XILINX_PCIE_INTR_MSI) {
+		/* MSI Interrupt */
+		val = pcie_read(port, XILINX_PCIE_REG_RPIFR1);
+
+		if (!(val & XILINX_PCIE_RPIFR1_INTR_VALID)) {
+			dev_warn(port->dev, "RP Intr FIFO1 read error\n");
+			return IRQ_HANDLED;
+		}
+
+		if (val & XILINX_PCIE_RPIFR1_MSI_INTR) {
+			msi_data = pcie_read(port, XILINX_PCIE_REG_RPIFR2) &
+					XILINX_PCIE_RPIFR2_MSG_DATA;
+
+			/* Clear interrupt FIFO register 1 */
+			pcie_write(port, XILINX_PCIE_RPIFR1_ALL_MASK,
+				XILINX_PCIE_REG_RPIFR1);
+
+			if (IS_ENABLED(CONFIG_PCI_MSI)) {
+				/* Handle MSI Interrupt */
+				generic_handle_irq(msi_data);
+			}
+		}
+	}
+
+	if (status & XILINX_PCIE_INTR_SLV_UNSUPP)
+		dev_warn(port->dev, "Slave unsupported request\n");
+
+	if (status & XILINX_PCIE_INTR_SLV_UNEXP)
+		dev_warn(port->dev, "Slave unexpected completion\n");
+
+	if (status & XILINX_PCIE_INTR_SLV_COMPL)
+		dev_warn(port->dev, "Slave completion timeout\n");
+
+	if (status & XILINX_PCIE_INTR_SLV_ERRP)
+		dev_warn(port->dev, "Slave Error Poison\n");
+
+	if (status & XILINX_PCIE_INTR_SLV_CMPABT)
+		dev_warn(port->dev, "Slave Completer Abort\n");
+
+	if (status & XILINX_PCIE_INTR_SLV_ILLBUR)
+		dev_warn(port->dev, "Slave Illegal Burst\n");
+
+	if (status & XILINX_PCIE_INTR_MST_DECERR)
+		dev_warn(port->dev, "Master decode error\n");
+
+	if (status & XILINX_PCIE_INTR_MST_SLVERR)
+		dev_warn(port->dev, "Master slave error\n");
+
+	if (status & XILINX_PCIE_INTR_MST_ERRP)
+		dev_warn(port->dev, "Master error poison\n");
+
+	/* Clear the Interrupt Decode register */
+	pcie_write(port, status, XILINX_PCIE_REG_IDR);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * xilinx_pcie_init_port - Initialize hardware
+ * @port: PCIe port information
+ *
+ * Return: '0' on success and error value on failure
+ */
+static int xilinx_pcie_init_port(struct xilinx_pcie_port *port)
+{
+	int err;
+	u32 val, last, first = 0;
+
+	port->reg_base = devm_ioremap(port->dev, port->phys_reg_base,
+					port->reg_size);
+	if (!port->reg_base)
+		return -ENOMEM;
+
+	/* make sure it is root port before touching header */
+	pcie_write(port, PCI_COMMAND_MASTER, PCI_COMMAND);
+
+	/* Check if PCIe link is up? */
+	port->link_up = xilinx_pcie_is_link_up(port);
+	if (!port->link_up)
+		dev_info(port->dev, "PCIe Link is DOWN\n");
+	else
+		dev_info(port->dev, "PCIe Link is UP\n");
+
+	/* Disable all interrupts*/
+	pcie_write(port, ~XILINX_PCIE_IDR_ALL_MASK,
+				XILINX_PCIE_REG_IMR);
+
+	/* Clear pending interrupts */
+	pcie_write(port, pcie_read(port, XILINX_PCIE_REG_IDR) &
+			XILINX_PCIE_IMR_ALL_MASK,
+			XILINX_PCIE_REG_IDR);
+
+	/* Enable all interrupts*/
+	pcie_write(port, XILINX_PCIE_IMR_ALL_MASK,
+			XILINX_PCIE_REG_IMR);
+
+	/* Enable the 'Bridge enable' bit */
+	pcie_write(port, pcie_read(port, XILINX_PCIE_REG_RPSC) |
+			XILINX_PCIE_REG_RPSC_BEN, XILINX_PCIE_REG_RPSC);
+
+	/* Register Interrupt Handler */
+	err = request_irq(port->irq, xilinx_pcie_intr_handler,
+				IRQF_SHARED, "xilinx-pcie", port);
+	if (err) {
+		dev_err(port->dev,
+			"Could not allocate interrupt %d\n", port->irq);
+		return err;
+	}
+
+	/* Get last bus number */
+	val = pcie_read(port, XILINX_PCIE_REG_BIR);
+	last = (val & XILINX_PCIE_BIR_ECAM_SZ_MASK) >>
+		XILINX_PCIE_BIR_ECAM_SZ_SHIFT;
+
+	/* Write primary, secondary and subordinate bus numbers */
+	val = pcie_read(port, PCI_PRIMARY_BUS) & PCI_LATENCY_TIMER_MASK;
+	val |= first;
+	val |= (first + 1) << PCI_SECONDARY_BUS_NUM_SHIFT;
+	val |= last << PCI_SUBORDINATE_BUS_NUM_SHIFT;
+	pcie_write(port, val, PCI_PRIMARY_BUS);
+
+	return 0;
+}
+
+/**
+ * xilinx_pcie_parse_dt - Parse Device tree
+ * @port: PCIe port information
+ *
+ * Return: '0' on success and error value on failure
+ */
+static int xilinx_pcie_parse_dt(struct xilinx_pcie_port *port)
+{
+	struct platform_device *pdev = to_platform_device(port->dev);
+	struct device_node *node = port->dev->of_node;
+	struct resource *io, res;
+	struct of_pci_range_parser parser;
+	struct of_pci_range range;
+
+	/* Request and map I/O memory */
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	port->phys_reg_base = io->start;
+	port->reg_size = resource_size(io);
+
+	/* Map the IRQ */
+	port->irq = irq_of_parse_and_map(node, 0);
+	if (!port->irq) {
+		dev_err(port->dev, "Unable to get IRQ\n");
+		return -EINVAL;
+	}
+
+	if (of_pci_range_parser_init(&parser, node)) {
+		dev_err(port->dev, "missing \"ranges\" property\n");
+		return -EINVAL;
+	}
+
+	for_each_of_pci_range(&parser, &range) {
+		if (port->mem_resno >= XILINX_MAX_NUM_RESOURCES) {
+			dev_err(port->dev, "Maximum memory resources exceeded\n");
+			return -EINVAL;
+		}
+
+		of_pci_range_to_resource(&range, node, &res);
+
+		switch (res.flags & IORESOURCE_TYPE_BITS) {
+		case IORESOURCE_MEM:
+			if (res.flags & IORESOURCE_PREFETCH)
+				port->mem[port->mem_resno].name = "PREFETCH";
+			else
+				port->mem[port->mem_resno].name = "MEM";
+
+			memcpy(&port->mem[port->mem_resno], &res, sizeof(res));
+			port->mem_resno++;
+		/* Fallthrough */
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * xilinx_pcie_probe - Probe function
+ * @pdev: Platform device pointer
+ *
+ * Return: '0' on success and error value on failure
+ */
+static int xilinx_pcie_probe(struct platform_device *pdev)
+{
+	struct xilinx_pcie_port *port;
+	struct hw_pci hw;
+	int err;
+
+	port = devm_kzalloc(&pdev->dev, sizeof(struct xilinx_pcie_port *),
+				 GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	port->dev = &pdev->dev;
+
+	/* Parse the device tree */
+	err = xilinx_pcie_parse_dt(port);
+	if (err) {
+		dev_err(port->dev, "Parsing DT failed\n");
+		return err;
+	}
+
+	/* Initialize the hardware */
+	err = xilinx_pcie_init_port(port);
+	if (err) {
+		dev_err(port->dev, "HW Initalization failed\n");
+		return err;
+	}
+
+	/* Setup MSI */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		int i;
+
+		port->irq_domain = irq_domain_add_linear(port->dev->of_node,
+					XILINX_NUM_MSI_IRQS, &msi_domain_ops,
+					&xilinx_pcie_msi_chip);
+		if (!port->irq_domain) {
+			dev_err(port->dev, "Failed to get an IRQ domain\n");
+			return -ENXIO;
+		}
+
+		for (i = 0; i < XILINX_NUM_MSI_IRQS; i++)
+			irq_create_mapping(port->irq_domain, i);
+
+		xilinx_pcie_enable_msi(port);
+	}
+
+	memset(&hw, 0, sizeof(hw));
+
+	hw.nr_controllers = 1;
+	hw.private_data = (void **)&port;
+	hw.setup = xilinx_pcie_setup;
+	hw.map_irq = xilinx_pcie_map_irq;
+	hw.add_bus = xilinx_pcie_add_bus;
+	hw.scan = xilinx_pcie_scan_bus;
+	hw.ops = &xilinx_pcie_ops;
+
+	/* Register the device */
+	pci_common_init_dev(port->dev, &hw);
+
+	platform_set_drvdata(pdev, port);
+
+	return 0;
+}
+
+/**
+ * xilinx_pcie_remove - Remove function
+ * @pdev: Platform device pointer
+ *
+ * Return: '0' always
+ */
+static int xilinx_pcie_remove(struct platform_device *pdev)
+{
+	struct xilinx_pcie_port *port = platform_get_drvdata(pdev);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		int i;
+		u32 irq;
+
+		free_pages(port->msg_addr, 0);
+
+		for (i = 0; i < XILINX_NUM_MSI_IRQS; i++) {
+			irq = irq_find_mapping(port->irq_domain, i);
+			if (irq > 0)
+				irq_dispose_mapping(irq);
+		}
+
+		irq_domain_remove(port->irq_domain);
+	}
+
+	if (port->irq > 0)
+		free_irq(port->irq, port);
+
+	return 0;
+}
+
+static struct of_device_id xilinx_pcie_of_match[] = {
+	{ .compatible = "xlnx,axi-pcie-host-1.00.a" ,},
+	{}
+};
+
+static struct platform_driver xilinx_pcie_driver = {
+	.driver = {
+		.name = "xilinx-pcie",
+		.owner = THIS_MODULE,
+		.of_match_table = xilinx_pcie_of_match,
+		.suppress_bind_attrs = true,
+	},
+	.probe = xilinx_pcie_probe,
+	.remove = xilinx_pcie_remove,
+};
+module_platform_driver(xilinx_pcie_driver);
+
+MODULE_AUTHOR("Xilinx Inc");
+MODULE_DESCRIPTION("Xilinx AXI PCIe driver");
+MODULE_LICENSE("GPLv2");
-- 
1.7.9.5

