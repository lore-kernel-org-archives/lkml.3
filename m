Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbaGURBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:01:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47169 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126AbaGURAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:00:13 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v7 4/5] PCI: add PCI controller for keystone PCIe h/w
Date: Mon, 21 Jul 2014 12:58:44 -0400
Message-ID: <1405961925-27248-5-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com>
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keystone PCIe controller is based on v3.65 version of the
designware h/w. Main differences are
	1. No ATU support
	2. Legacy and MSI irq functions are implemented in
	   application register space
	3. MSI interrupts are multiplexed over 8 IRQ lines to the Host
	   side.
All of the Application register space handing code are organized into
pci-keystone-dw.c and the functions are called from pci-keystone.c
to implement PCI controller driver. Also add necessary DT documentation
for the driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Marek Vasut <marex@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Grant Likely <grant.likely@linaro.org>
---
 .../devicetree/bindings/pci/pci-keystone.txt       |   68 +++
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-keystone-dw.c                 |  521 ++++++++++++++++++++
 drivers/pci/host/pci-keystone.c                    |  386 +++++++++++++++
 drivers/pci/host/pci-keystone.h                    |   58 +++
 6 files changed, 1039 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
 create mode 100644 drivers/pci/host/pci-keystone-dw.c
 create mode 100644 drivers/pci/host/pci-keystone.c
 create mode 100644 drivers/pci/host/pci-keystone.h

diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
new file mode 100644
index 0000000..1bd0476
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
@@ -0,0 +1,68 @@
+TI Keystone PCIe interface
+
+Keystone PCI host Controller is based on Designware PCI h/w version 3.65.
+It shares common functions with PCIE Designware core driver and inherit
+common properties defined in
+Documentation/devicetree/bindings/pci/designware-pci.txt
+
+Please refer to Documentation/devicetree/bindings/pci/designware-pci.txt
+for the details of designware DT bindings. Additional properties are
+described here as well propeties that are not applicable.
+
+Required Properties:-
+
+compatibility: "ti,keystone-pcie"
+reg:	index 1 is the base address and length of DW application registers.
+	index 2 is the base address and length of PCI mode configuration
+	register.
+	index 3 is the base address and length of PCI device ID register.
+
+pcie_msi_intc : Interrupt controller device node for MSI irq chip
+	interrupt-cells: should be set to 1
+	interrupt-parent: Parent interrupt controller phandle
+	interrupts: GIC interrupt lines connected to PCI MSI interrupt lines
+
+ Example:
+	pcie_msi_intc: msi-interrupt-controller {
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 37 IRQ_TYPE_EDGE_RISING>;
+	};
+
+pcie_intc: Interrupt controller device node for Legacy irq chip
+	interrupt-cells: should be set to 1
+	interrupt-parent: Parent interrupt controller phandle
+	interrupts: GIC interrupt lines connected to PCI Legacy interrupt lines
+
+ Example:
+	pcie_intc: legacy-interrupt-controller {
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>,
+			<GIC_SPI 27 IRQ_TYPE_EDGE_RISING>,
+			<GIC_SPI 28 IRQ_TYPE_EDGE_RISING>,
+			<GIC_SPI 29 IRQ_TYPE_EDGE_RISING>;
+	};
+
+Optional properties:-
+	phys: phandle to Generic Keystone SerDes phy for PCI
+	phy-names: name of the Generic Keystine SerDes phy for PCI
+	  - If boot loader already does PCI link establishment, then phys and
+	    phy-names shouldn't be present.
+
+Designware DT Properties not applicable for Keystone PCI
+
+1. pcie_bus clock-names not used. Instead, a phandle to phys is used.
+
+Note for PCI driver usage
+=========================
+Driver requires pci=pcie_bus_perf in the bootargs for proper functioning.
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 21df477..f8bc475 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -46,4 +46,9 @@ config PCI_HOST_GENERIC
 	  Say Y here if you want to support a simple generic PCI host
 	  controller, such as the one emulated by kvmtool.
 
+config PCI_KEYSTONE
+	bool "TI Keystone PCIe controller"
+	depends on ARCH_KEYSTONE
+	select PCIE_DW
+	select PCIEPORTBUS
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 611ba4b..d1b6ce1 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
 obj-$(CONFIG_PCI_RCAR_GEN2_PCIE) += pcie-rcar.o
 obj-$(CONFIG_PCI_HOST_GENERIC) += pci-host-generic.o
+obj-$(CONFIG_PCI_KEYSTONE) += pci-keystone-dw.o pci-keystone.o
diff --git a/drivers/pci/host/pci-keystone-dw.c b/drivers/pci/host/pci-keystone-dw.c
new file mode 100644
index 0000000..701acb4
--- /dev/null
+++ b/drivers/pci/host/pci-keystone-dw.c
@@ -0,0 +1,521 @@
+/*
+ * Designware application register space functions for Keystone PCI controller
+ *
+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
+ *		http://www.ti.com
+ *
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_pci.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+
+#include "pcie-designware.h"
+#include "pci-keystone.h"
+
+/* Application register defines */
+#define LTSSM_EN_VAL		        1
+#define LTSSM_STATE_MASK		0x1f
+#define LTSSM_STATE_L0			0x11
+#define DBI_CS2_EN_VAL			0x20
+#define OB_XLAT_EN_VAL		        2
+
+/* Application registers */
+#define CMD_STATUS			0x004
+#define CFG_SETUP			0x008
+#define OB_SIZE				0x030
+#define CFG_PCIM_WIN_SZ_IDX		3
+#define CFG_PCIM_WIN_CNT		32
+#define SPACE0_REMOTE_CFG_OFFSET	0x1000
+#define OB_OFFSET_INDEX(n)		(0x200 + (8 * n))
+#define OB_OFFSET_HI(n)			(0x204 + (8 * n))
+
+/* IRQ register defines */
+#define IRQ_EOI				0x050
+#define IRQ_STATUS			0x184
+#define IRQ_ENABLE_SET			0x188
+#define IRQ_ENABLE_CLR			0x18c
+
+#define MSI_IRQ				0x054
+#define MSI0_IRQ_STATUS			0x104
+#define MSI0_IRQ_ENABLE_SET		0x108
+#define MSI0_IRQ_ENABLE_CLR		0x10c
+#define IRQ_STATUS			0x184
+#define MSI_IRQ_OFFSET			4
+
+/* Config space registers */
+#define DEBUG0				0x728
+
+#define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
+
+static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
+{
+	return sys->private_data;
+}
+
+static inline void update_reg_offset_bit_pos(u32 offset, u32 *reg_offset,
+					u32 *bit_pos)
+{
+	*reg_offset = offset % 8;
+	*bit_pos = offset >> 3;
+}
+
+u32 ks_dw_pcie_get_msi_data(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	return ks_pcie->app.start + MSI_IRQ;
+}
+
+void ks_dw_pcie_handle_msi_irq(struct keystone_pcie *ks_pcie , int offset)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	u32 pending, vector;
+	int src, virq;
+
+	pending = readl(ks_pcie->va_app_base + MSI0_IRQ_STATUS + (offset << 4));
+	/*
+	 * MSI0, Status bit 0-3 shows vectors 0, 8, 16, 24, MSI1 status bit
+	 * shows 1, 9, 17, 25 and so forth
+	 */
+	for (src = 0; src < 4; src++) {
+		if (BIT(src) & pending) {
+			vector = offset + (src << 3);
+			virq = irq_linear_revmap(pp->irq_domain, vector);
+			dev_dbg(pp->dev,
+				"irq: bit %d, vector %d, virq %d\n",
+				 src, vector, virq);
+			generic_handle_irq(virq);
+		}
+	}
+}
+
+static void ks_dw_pcie_msi_irq_ack(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	struct keystone_pcie *ks_pcie;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+
+	msi = irq_get_msi_desc(irq);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	ks_pcie = to_keystone_pcie(pp);
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
+
+	writel(BIT(bit_pos),
+		ks_pcie->va_app_base + MSI0_IRQ_STATUS + (reg_offset << 4));
+	writel(reg_offset + MSI_IRQ_OFFSET, ks_pcie->va_app_base + IRQ_EOI);
+}
+
+void ks_dw_pcie_msi_set_irq(struct pcie_port *pp, int irq)
+{
+	u32 reg_offset, bit_pos;
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	update_reg_offset_bit_pos(irq, &reg_offset, &bit_pos);
+	writel(BIT(bit_pos),
+		ks_pcie->va_app_base + MSI0_IRQ_ENABLE_SET + (reg_offset << 4));
+}
+
+void ks_dw_pcie_msi_clear_irq(struct pcie_port *pp, int irq)
+{
+	u32 reg_offset, bit_pos;
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	update_reg_offset_bit_pos(irq, &reg_offset, &bit_pos);
+	writel(BIT(bit_pos),
+		ks_pcie->va_app_base + MSI0_IRQ_ENABLE_CLR + (reg_offset << 4));
+}
+
+static void ks_dw_pcie_msi_irq_mask(struct irq_data *d)
+{
+	struct keystone_pcie *ks_pcie;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+	u32 offset;
+
+	msi = irq_get_msi_desc(irq);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	ks_pcie = to_keystone_pcie(pp);
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+
+	/* mask the end point if PVM implemented */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (msi->msi_attrib.maskbit)
+			mask_msi_irq(d);
+	}
+
+	ks_dw_pcie_msi_clear_irq(pp, offset);
+}
+
+static void ks_dw_pcie_msi_irq_unmask(struct irq_data *d)
+{
+	struct keystone_pcie *ks_pcie;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+	u32 offset;
+
+	msi = irq_get_msi_desc(irq);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	ks_pcie = to_keystone_pcie(pp);
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+
+	/* mask the end point if PVM implemented */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (msi->msi_attrib.maskbit)
+			unmask_msi_irq(d);
+	}
+
+	ks_dw_pcie_msi_set_irq(pp, offset);
+}
+
+static struct irq_chip ks_dw_pcie_msi_irq_chip = {
+	.name = "Keystone-PCIe-MSI-IRQ",
+	.irq_ack = ks_dw_pcie_msi_irq_ack,
+	.irq_mask = ks_dw_pcie_msi_irq_mask,
+	.irq_unmask = ks_dw_pcie_msi_irq_unmask,
+};
+
+static int ks_dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
+			irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(irq, &ks_dw_pcie_msi_irq_chip,
+				 handle_level_irq);
+	irq_set_chip_data(irq, domain->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+const struct irq_domain_ops ks_dw_pcie_msi_domain_ops = {
+	.map = ks_dw_pcie_msi_map,
+};
+
+int ks_dw_pcie_msi_host_init(struct pcie_port *pp,
+					struct msi_chip *chip)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	int i;
+
+	pp->irq_domain = irq_domain_add_linear(ks_pcie->msi_intc_np,
+					MAX_MSI_IRQS,
+					&ks_dw_pcie_msi_domain_ops,
+					chip);
+	if (!pp->irq_domain) {
+		dev_err(pp->dev, "irq domain init failed\n");
+		return -ENXIO;
+	}
+
+	for (i = 0; i < MAX_MSI_IRQS; i++)
+		irq_create_mapping(pp->irq_domain, i);
+
+	return 0;
+}
+
+void ks_dw_pcie_enable_legacy_irqs(struct keystone_pcie *ks_pcie)
+{
+	int i;
+
+	for (i = 0; i < MAX_LEGACY_IRQS; i++)
+		writel(0x1, ks_pcie->va_app_base + IRQ_ENABLE_SET + (i << 4));
+}
+
+void ks_dw_pcie_handle_legacy_irq(struct keystone_pcie *ks_pcie, int offset)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	u32 pending;
+	int virq;
+
+	pending = readl(ks_pcie->va_app_base + IRQ_STATUS + (offset << 4));
+
+	if (BIT(0) & pending) {
+		virq = irq_linear_revmap(ks_pcie->legacy_irq_domain, offset);
+		dev_dbg(pp->dev,
+			": irq: irq_offset %d, virq %d\n", offset, virq);
+		generic_handle_irq(virq);
+	}
+
+	/* EOI the INTx interrupt */
+	writel(offset, ks_pcie->va_app_base + IRQ_EOI);
+}
+
+static void ks_dw_pcie_ack_legacy_irq(struct irq_data *d)
+{
+}
+
+static void ks_dw_pcie_mask_legacy_irq(struct irq_data *d)
+{
+}
+
+static void ks_dw_pcie_unmask_legacy_irq(struct irq_data *d)
+{
+}
+
+static struct irq_chip ks_dw_pcie_legacy_irq_chip = {
+	.name = "Keystone-PCI-Legacy-IRQ",
+	.irq_ack = ks_dw_pcie_ack_legacy_irq,
+	.irq_mask = ks_dw_pcie_mask_legacy_irq,
+	.irq_unmask = ks_dw_pcie_unmask_legacy_irq,
+};
+
+static int ks_dw_pcie_init_legacy_irq_map(struct irq_domain *d,
+				unsigned int irq, irq_hw_number_t hw_irq)
+{
+	irq_set_chip_and_handler(irq, &ks_dw_pcie_legacy_irq_chip,
+				handle_level_irq);
+	irq_set_chip_data(irq, d->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+static const struct irq_domain_ops ks_dw_pcie_legacy_irq_domian_ops = {
+	.map = ks_dw_pcie_init_legacy_irq_map,
+	.xlate = irq_domain_xlate_onetwocell,
+};
+
+/**
+ * ks_dw_pcie_set_dbi_mode() - Set DBI mode to access overlaid BAR mask registers
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static void ks_dw_pcie_set_dbi_mode(void __iomem *reg_virt)
+{
+	u32 val;
+
+	writel(DBI_CS2_EN_VAL | readl(reg_virt + CMD_STATUS),
+		     reg_virt + CMD_STATUS);
+
+	do {
+		val = readl(reg_virt + CMD_STATUS);
+	} while (!(val & DBI_CS2_EN_VAL));
+}
+
+/**
+ * ks_dw_pcie_clear_dbi_mode() - Disable DBI mode
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static void ks_dw_pcie_clear_dbi_mode(void __iomem *reg_virt)
+{
+	u32 val;
+
+	writel(~DBI_CS2_EN_VAL & readl(reg_virt + CMD_STATUS),
+		     reg_virt + CMD_STATUS);
+
+	do {
+		val = readl(reg_virt + CMD_STATUS);
+	} while (val & DBI_CS2_EN_VAL);
+}
+
+void ks_dw_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	u32 start = pp->mem.start, end = pp->mem.end;
+	int i, tr_size;
+
+	/* disable BARS for inbound access */
+	ks_dw_pcie_set_dbi_mode(ks_pcie->va_app_base);
+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_0);
+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_1);
+	ks_dw_pcie_clear_dbi_mode(ks_pcie->va_app_base);
+
+	/* Set outbound translation size per window division */
+	writel(CFG_PCIM_WIN_SZ_IDX & 0x7, ks_pcie->va_app_base + OB_SIZE);
+
+	tr_size = (1 << (CFG_PCIM_WIN_SZ_IDX & 0x7)) * SZ_1M;
+
+	/* Using Direct 1:1 mapping of RC <-> PCI memory space */
+	for (i = 0; (i < CFG_PCIM_WIN_CNT) && (start < end); i++) {
+		writel(start | 1, ks_pcie->va_app_base + OB_OFFSET_INDEX(i));
+		writel(0, ks_pcie->va_app_base + OB_OFFSET_HI(i));
+		start += tr_size;
+	}
+
+	/* Enable OB translation */
+	writel(OB_XLAT_EN_VAL | readl(ks_pcie->va_app_base + CMD_STATUS),
+		ks_pcie->va_app_base + CMD_STATUS);
+}
+
+/**
+ * ks_pcie_cfg_setup() - Set up configuration space address for a
+ * device
+ *
+ * @ks_pcie: ptr to keystone_pcie structure
+ * @bus: Bus number the device is residing on
+ * @devfn: device, function number info
+ *
+ * Forms and returns the address of configuration space mapped in PCIESS
+ * address space 0. Also configures CFG_SETUP for remote configuration space
+ * access.
+ *
+ * The address space has two regions to access configuration - local and remote.
+ * We access local region for bus 0 (as RC is attached on bus 0) and remote
+ * region for others with TYPE 1 access when bus > 1. As for device on bus = 1,
+ * we will do TYPE 0 access as it will be on our secondary bus (logical).
+ * CFG_SETUP is needed only for remote configuration access.
+ */
+static void __iomem *ks_pcie_cfg_setup(struct keystone_pcie *ks_pcie, u8 bus,
+					unsigned int devfn)
+{
+	u8 device = PCI_SLOT(devfn), function = PCI_FUNC(devfn);
+	struct pcie_port *pp = &ks_pcie->pp;
+	u32 regval;
+
+	if (bus == 0)
+		return pp->dbi_base;
+
+	regval = (bus << 16) | (device << 8) | function;
+	/*
+	 * Since Bus#1 will be a virtual bus, we need to have TYPE0
+	 * access only.
+	 * TYPE 1
+	 */
+	if (bus != 1)
+		regval |= BIT(24);
+
+	writel(regval, ks_pcie->va_app_base + CFG_SETUP);
+	return pp->va_cfg0_base;
+}
+
+int ks_dw_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		unsigned int devfn, int where, int size, u32 *val)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u8 bus_num = bus->number;
+	void __iomem *addr;
+	int ret;
+
+	addr = ks_pcie_cfg_setup(ks_pcie, bus_num, devfn);
+	ret = dw_pcie_cfg_read(addr + (where & ~0x3), where, size, val);
+
+	return ret;
+}
+
+int ks_dw_pcie_wr_other_conf(struct pcie_port *pp,
+		struct pci_bus *bus, unsigned int devfn, int where,
+		int size, u32 val)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u8 bus_num = bus->number;
+	void __iomem *addr;
+
+	addr = ks_pcie_cfg_setup(ks_pcie, bus_num, devfn);
+
+	return dw_pcie_cfg_write(addr + (where & ~0x3), where, size, val);
+}
+
+/**
+ * ks_dw_pcie_v3_65_scan_bus() - keystone scan_bus post initialization
+ *
+ * This sets BAR0 to enable inbound access for MSI_IRQ register
+ */
+void ks_dw_pcie_v3_65_scan_bus(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	/* Configure and set up BAR0 */
+	ks_dw_pcie_set_dbi_mode(ks_pcie->va_app_base);
+
+	/* Enable BAR0 */
+	writel(1, pp->dbi_base + PCI_BASE_ADDRESS_0);
+	writel(SZ_4K - 1, pp->dbi_base + PCI_BASE_ADDRESS_0);
+
+	ks_dw_pcie_clear_dbi_mode(ks_pcie->va_app_base);
+
+	 /*
+	  * For BAR0, just setting bus address for inbound writes (MSI) should
+	  * be sufficient. Use physical address to avoid any conflicts.
+	  */
+	writel(ks_pcie->app.start, pp->dbi_base + PCI_BASE_ADDRESS_0);
+}
+
+/**
+ * ks_dw_pcie_link_up() - Check if link up
+ *
+ */
+int ks_dw_pcie_link_up(struct pcie_port *pp)
+{
+	u32 val = readl(pp->dbi_base + DEBUG0);
+
+	return (val & LTSSM_STATE_MASK) == LTSSM_STATE_L0;
+}
+
+void ks_dw_pcie_initiate_link_train(struct keystone_pcie *ks_pcie)
+{
+	u32 val;
+
+	/* first disable Link training */
+	val = readl(ks_pcie->va_app_base + CMD_STATUS);
+	val &= ~LTSSM_EN_VAL;
+	writel(LTSSM_EN_VAL | val,  ks_pcie->va_app_base + CMD_STATUS);
+
+	/* Initiate Link Training.  */
+	val = readl(ks_pcie->va_app_base + CMD_STATUS);
+	writel(LTSSM_EN_VAL | val,  ks_pcie->va_app_base + CMD_STATUS);
+}
+
+/**
+ * ks_dw_pcie_host_init() - initialize host for v3_65 dw hardware
+ *
+ * It ioremap the register resources, initialize legacy irq domain
+ * and then call dw_pcie_v3_65_host_init() API to intialize the Keystone
+ * PCI host controller.
+ *
+ */
+int __init ks_dw_pcie_host_init(struct keystone_pcie *ks_pcie,
+				struct device_node *msi_intc_np)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	struct platform_device *pdev = to_platform_device(pp->dev);
+	struct resource *res;
+
+	/* index 0 is the config reg. space address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pp->dbi_base = devm_ioremap_resource(pp->dev, res);
+	if (IS_ERR(pp->dbi_base))
+		return PTR_ERR(pp->dbi_base);
+
+	/*
+	 * we set these same and is used in pcie rd/wr_other_conf
+	 * functions
+	 */
+	pp->va_cfg0_base = pp->dbi_base + SPACE0_REMOTE_CFG_OFFSET;
+	pp->va_cfg1_base = pp->va_cfg0_base;
+
+	/* index 1 is the application reg. space address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	ks_pcie->app = *res;
+	ks_pcie->va_app_base = devm_ioremap_resource(pp->dev, res);
+	if (IS_ERR(ks_pcie->va_app_base))
+		return PTR_ERR(ks_pcie->va_app_base);
+
+	/* create legacy irq domain */
+	ks_pcie->legacy_irq_domain =
+			irq_domain_add_linear(ks_pcie->legacy_intc_np,
+					MAX_LEGACY_IRQS,
+					&ks_dw_pcie_legacy_irq_domian_ops,
+					NULL);
+	if (!ks_pcie->legacy_irq_domain) {
+		dev_err(pp->dev, "Failed to add irq domain for legacy irqs\n");
+		return -EINVAL;
+	}
+
+	return dw_pcie_host_init(pp);
+}
diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
new file mode 100644
index 0000000..c1cfaef
--- /dev/null
+++ b/drivers/pci/host/pci-keystone.c
@@ -0,0 +1,386 @@
+/*
+ * PCIe host controller driver for Texas Instruments Keystone SoCs
+ *
+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
+ *		http://www.ti.com
+ *
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ * Implementation based on pci-exynos.c and pcie-designware.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/irqchip/chained_irq.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/msi.h>
+#include <linux/of_irq.h>
+#include <linux/of.h>
+#include <linux/of_pci.h>
+#include <linux/platform_device.h>
+#include <linux/phy/phy.h>
+#include <linux/resource.h>
+#include <linux/signal.h>
+
+#include "pcie-designware.h"
+#include "pci-keystone.h"
+
+#define DRIVER_NAME	"keystone-pcie"
+
+/* driver specific constants */
+#define MAX_MSI_HOST_IRQS		8
+#define MAX_LEGACY_HOST_IRQS		4
+
+/* RC mode settings masks */
+#define PCIE_RC_MODE		BIT(2)
+#define PCIE_MODE_MASK		(BIT(1) | BIT(2))
+
+/* DEV_STAT_CTRL */
+#define PCIE_CAP_BASE		0x70
+
+#define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
+
+static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	int count = 200;
+
+	dw_pcie_setup_rc(pp);
+
+	if (dw_pcie_link_up(pp)) {
+		dev_err(pp->dev, "Link already up\n");
+		return 0;
+	}
+
+	ks_dw_pcie_initiate_link_train(ks_pcie);
+	/* check if the link is up or not */
+	while (!dw_pcie_link_up(pp)) {
+		usleep_range(100, 1000);
+		if (--count) {
+			ks_dw_pcie_initiate_link_train(ks_pcie);
+			continue;
+		}
+		dev_err(pp->dev, "phy link never came up\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ks_pcie_msi_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct keystone_pcie *ks_pcie = irq_desc_get_handler_data(desc);
+	u32 offset = irq - ks_pcie->msi_host_irqs[0];
+	struct pcie_port *pp = &ks_pcie->pp;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	dev_dbg(pp->dev, "ks_pci_msi_irq_handler, irq %d\n", irq);
+
+	/*
+	 * The chained irq handler installation would have replaced normal
+	 * interrupt driver handler so we need to take care of mask/unmask and
+	 * ack operation.
+	 */
+	chained_irq_enter(chip, desc);
+	ks_dw_pcie_handle_msi_irq(ks_pcie, offset);
+	chained_irq_exit(chip, desc);
+}
+
+/**
+ * ks_pcie_legacy_irq_handler() - Handle legacy interrupt
+ * @irq: IRQ line for legacy interrupts
+ * @desc: Pointer to irq descriptor
+ *
+ * Traverse through pending legacy interrupts and invoke handler for each. Also
+ * takes care of interrupt controller level mask/ack operation.
+ */
+static void ks_pcie_legacy_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct keystone_pcie *ks_pcie = irq_desc_get_handler_data(desc);
+	struct pcie_port *pp = &ks_pcie->pp;
+	u32 irq_offset = irq - ks_pcie->legacy_host_irqs[0];
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	dev_dbg(pp->dev, ": Handling legacy irq %d\n", irq);
+
+	/*
+	 * The chained irq handler installation would have replaced normal
+	 * interrupt driver handler so we need to take care of mask/unmask and
+	 * ack operation.
+	 */
+	chained_irq_enter(chip, desc);
+	ks_dw_pcie_handle_legacy_irq(ks_pcie, irq_offset);
+	chained_irq_exit(chip, desc);
+}
+
+static int ks_pcie_get_irq_controller_info(struct keystone_pcie *ks_pcie,
+					   char *controller, int *num_irqs)
+{
+	int temp, max_host_irqs, legacy = 1, *host_irqs, ret = -EINVAL;
+	struct device *dev = ks_pcie->pp.dev;
+	struct device_node *np_pcie = dev->of_node, **np_temp;
+
+	if (!strcmp(controller, "msi-interrupt-controller"))
+		legacy = 0;
+
+	if (legacy) {
+		np_temp = &ks_pcie->legacy_intc_np;
+		max_host_irqs = MAX_LEGACY_HOST_IRQS;
+		host_irqs = &ks_pcie->legacy_host_irqs[0];
+	} else {
+		np_temp = &ks_pcie->msi_intc_np;
+		max_host_irqs = MAX_MSI_HOST_IRQS;
+		host_irqs =  &ks_pcie->msi_host_irqs[0];
+	}
+
+	/* interrupt controller is in a child node */
+	*np_temp = of_find_node_by_name(np_pcie, controller);
+	if (!(*np_temp)) {
+		dev_err(dev, "Node for %s is absent\n", controller);
+		goto out;
+	}
+	temp = of_irq_count(*np_temp);
+	if (!temp)
+		goto out;
+	if (temp > max_host_irqs)
+		dev_warn(dev, "Too many %s interrupts defined %u\n",
+			(legacy ? "legacy" : "MSI"), temp);
+
+	/*
+	 * support upto max_host_irqs. In dt from index 0 to 3 (legacy) or 0 to
+	 * 7 (MSI)
+	 */
+	for (temp = 0; temp < max_host_irqs; temp++) {
+		host_irqs[temp] = irq_of_parse_and_map(*np_temp, temp);
+		if (host_irqs[temp] < 0)
+			break;
+	}
+	if (temp) {
+		*num_irqs = temp;
+		ret = 0;
+	}
+out:
+	return ret;
+}
+
+static void ks_pcie_setup_interrupts(struct keystone_pcie *ks_pcie)
+{
+	int i;
+
+	/* Legacy IRQ */
+	for (i = 0; i < ks_pcie->num_legacy_host_irqs; i++) {
+		irq_set_handler_data(ks_pcie->legacy_host_irqs[i], ks_pcie);
+		irq_set_chained_handler(ks_pcie->legacy_host_irqs[i],
+					ks_pcie_legacy_irq_handler);
+	}
+	ks_dw_pcie_enable_legacy_irqs(ks_pcie);
+
+	/* MSI IRQ */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		for (i = 0; i < ks_pcie->num_msi_host_irqs; i++) {
+			irq_set_chained_handler(ks_pcie->msi_host_irqs[i],
+						ks_pcie_msi_irq_handler);
+			irq_set_handler_data(ks_pcie->msi_host_irqs[i],
+					     ks_pcie);
+		}
+	}
+}
+
+/*
+ * When a PCI device does not exist during config cycles, keystone host gets a
+ * bus error instead of returning 0xffffffff. This handler always returns 0
+ * for this kind of faults.
+ */
+static int keystone_pcie_fault(unsigned long addr, unsigned int fsr,
+				struct pt_regs *regs)
+{
+	unsigned long instr = *(unsigned long *) instruction_pointer(regs);
+
+	if ((instr & 0x0e100090) == 0x00100090) {
+		int reg = (instr >> 12) & 15;
+
+		regs->uregs[reg] = -1;
+		regs->ARM_pc += 4;
+	}
+
+	return 0;
+}
+
+static void __init ks_pcie_host_init(struct pcie_port *pp)
+{
+	u32 vendor_device_id, val;
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	ks_pcie_establish_link(ks_pcie);
+	ks_dw_pcie_setup_rc_app_regs(ks_pcie);
+	ks_pcie_setup_interrupts(ks_pcie);
+	writew(PCI_IO_RANGE_TYPE_32 | (PCI_IO_RANGE_TYPE_32 << 8),
+			pp->dbi_base + PCI_IO_BASE);
+
+	/* update the Vendor ID */
+	vendor_device_id = readl(ks_pcie->va_reg_pciid);
+	writew((vendor_device_id >> 16), pp->dbi_base + PCI_DEVICE_ID);
+
+	/* update the DEV_STAT_CTRL to publish right mrrs */
+	val = readl(pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
+	val &= ~PCI_EXP_DEVCTL_READRQ;
+	/* set the mrrs to 256 bytes */
+	val |= BIT(12);
+	writel(val, pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
+
+	/*
+	 * PCIe access errors that result into OCP errors are caught by ARM as
+	 * "External aborts"
+	 */
+	hook_fault_code(17, keystone_pcie_fault, SIGBUS, 0,
+			"Asynchronous external abort");
+}
+
+static struct pcie_host_ops keystone_pcie_host_ops = {
+	.rd_other_conf = ks_dw_pcie_rd_other_conf,
+	.wr_other_conf = ks_dw_pcie_wr_other_conf,
+	.link_up = ks_dw_pcie_link_up,
+	.host_init = ks_pcie_host_init,
+	.msi_set_irq = ks_dw_pcie_msi_set_irq,
+	.msi_clear_irq = ks_dw_pcie_msi_clear_irq,
+	.get_msi_data = ks_dw_pcie_get_msi_data,
+	.msi_host_init = ks_dw_pcie_msi_host_init,
+	.scan_bus = ks_dw_pcie_v3_65_scan_bus,
+};
+
+static int __init ks_add_pcie_port(struct keystone_pcie *ks_pcie,
+			 struct platform_device *pdev)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	int ret;
+
+	ret = ks_pcie_get_irq_controller_info(ks_pcie,
+					"legacy-interrupt-controller",
+					&ks_pcie->num_legacy_host_irqs);
+	if (ret)
+		return ret;
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		ret = ks_pcie_get_irq_controller_info(ks_pcie,
+						"msi-interrupt-controller",
+						&ks_pcie->num_msi_host_irqs);
+		if (ret)
+			return ret;
+	}
+
+	pp->root_bus_nr = -1;
+	pp->ops = &keystone_pcie_host_ops;
+	ret = ks_dw_pcie_host_init(ks_pcie, ks_pcie->msi_intc_np);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to initialize host\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static const struct of_device_id ks_pcie_of_match[] = {
+	{
+		.type = "pci",
+		.compatible = "ti,keystone-pcie",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ks_pcie_of_match);
+
+static int __exit ks_pcie_remove(struct platform_device *pdev)
+{
+	struct keystone_pcie *ks_pcie = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(ks_pcie->clk);
+
+	return 0;
+}
+
+static int __init ks_pcie_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct keystone_pcie *ks_pcie;
+	struct pcie_port *pp;
+	struct resource *res;
+	void __iomem *reg_p;
+	struct phy *phy;
+	int ret = 0;
+	u32 val;
+
+	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
+				GFP_KERNEL);
+	if (!ks_pcie) {
+		dev_err(dev, "no memory for keystone pcie\n");
+		return -ENOMEM;
+	}
+	pp = &ks_pcie->pp;
+
+	/* index 2 is the devcfg register for RC mode settings */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	reg_p = devm_ioremap_resource(dev, res);
+	if (IS_ERR(reg_p))
+		return PTR_ERR(reg_p);
+
+	/* enable RC mode in devcfg */
+	val = readl(reg_p);
+	val &= ~PCIE_MODE_MASK;
+	val |= PCIE_RC_MODE;
+	writel(val, reg_p);
+
+	/* initialize SerDes Phy if present */
+	phy = devm_phy_get(dev, "pcie-phy");
+	if (!IS_ERR_OR_NULL(phy)) {
+		ret = phy_init(phy);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* index 3 is to read PCI DEVICE_ID */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	reg_p = devm_ioremap_resource(dev, res);
+	if (IS_ERR(reg_p))
+		return PTR_ERR(reg_p);
+	ks_pcie->va_reg_pciid = reg_p;
+
+	pp->dev = dev;
+	platform_set_drvdata(pdev, ks_pcie);
+	ks_pcie->clk = devm_clk_get(dev, "pcie");
+	if (IS_ERR(ks_pcie->clk)) {
+		dev_err(dev, "Failed to get pcie rc clock\n");
+		return PTR_ERR(ks_pcie->clk);
+	}
+	ret = clk_prepare_enable(ks_pcie->clk);
+	if (ret)
+		return ret;
+
+	ret = ks_add_pcie_port(ks_pcie, pdev);
+	if (ret < 0)
+		goto fail_clk;
+
+	return 0;
+fail_clk:
+	clk_disable_unprepare(ks_pcie->clk);
+
+	return ret;
+}
+
+static struct platform_driver ks_pcie_driver __refdata = {
+	.probe  = ks_pcie_probe,
+	.remove = __exit_p(ks_pcie_remove),
+	.driver = {
+		.name	= "keystone-pcie",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ks_pcie_of_match),
+	},
+};
+
+module_platform_driver(ks_pcie_driver);
+
+MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
+MODULE_DESCRIPTION("Keystone PCIe host controller driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pci/host/pci-keystone.h b/drivers/pci/host/pci-keystone.h
new file mode 100644
index 0000000..729ea7d
--- /dev/null
+++ b/drivers/pci/host/pci-keystone.h
@@ -0,0 +1,58 @@
+/*
+ * Keystone PCI Controller's common includes
+ *
+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
+ *		http://www.ti.com
+ *
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define MAX_LEGACY_IRQS			4
+#define MAX_MSI_HOST_IRQS		8
+#define MAX_LEGACY_HOST_IRQS		4
+
+struct keystone_pcie {
+	struct	clk		*clk;
+	struct	pcie_port	pp;
+	void __iomem		*va_reg_pciid;
+
+	int			num_legacy_host_irqs;
+	int			legacy_host_irqs[MAX_LEGACY_HOST_IRQS];
+	struct			device_node *legacy_intc_np;
+
+	int			num_msi_host_irqs;
+	int			msi_host_irqs[MAX_MSI_HOST_IRQS];
+	struct			device_node *msi_intc_np;
+	struct irq_domain	*legacy_irq_domain;
+
+	/* Application register space */
+	void __iomem		*va_app_base;
+	struct resource		app;
+};
+
+/* Keystone DW specific MSI controller APIs/definitions */
+void ks_dw_pcie_handle_msi_irq(struct keystone_pcie *ks_pcie, int offset);
+u32 ks_dw_pcie_get_msi_data(struct pcie_port *pp);
+
+/* Keystone specific PCI controller APIs */
+void ks_dw_pcie_enable_legacy_irqs(struct keystone_pcie *ks_pcie);
+void ks_dw_pcie_handle_legacy_irq(struct keystone_pcie *ks_pcie, int offset);
+int  ks_dw_pcie_host_init(struct keystone_pcie *ks_pcie,
+			struct device_node *msi_intc_np);
+int ks_dw_pcie_wr_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		unsigned int devfn, int where, int size, u32 val);
+int ks_dw_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		unsigned int devfn, int where, int size, u32 *val);
+void ks_dw_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie);
+int ks_dw_pcie_link_up(struct pcie_port *pp);
+void ks_dw_pcie_initiate_link_train(struct keystone_pcie *ks_pcie);
+void ks_dw_pcie_msi_set_irq(struct pcie_port *pp, int irq);
+void ks_dw_pcie_msi_clear_irq(struct pcie_port *pp, int irq);
+void ks_dw_pcie_v3_65_scan_bus(struct pcie_port *pp);
+int ks_dw_pcie_msi_host_init(struct pcie_port *pp,
+		struct msi_chip *chip);
-- 
1.7.9.5

