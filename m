Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaFJSxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:53:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59501 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbaFJSw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:52:57 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2 7/8] PCI: keystone: add pcie driver based on designware core driver
Date: Tue, 10 Jun 2014 14:51:26 -0400
Message-ID: <1402426287-31157-8-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keystone pcie hardware is based on designware version 3.65.
This driver make use of the functions from pci-dw-old.c and
pci-dw-old-msi.c to implement the driver.

Driver mainly handle the platform specific part of the
PCI driver and depends on DW Old driver to configure
application specific registers. Also routes the irq events
and ack the interrupt after the same is acked by the end
point device driver. This requires irqchip implementation
for legacy and MSI irq handling.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Pratyush Anand <pratyush.anand@st.com>
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
 .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
 .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++
 drivers/pci/host/Kconfig                           |    7 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-keystone.c                    |  418 ++++++++++++++++++++
 5 files changed, 524 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
 create mode 100644 drivers/pci/host/pci-keystone.c

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index d6fae13..3ea00f9 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -81,3 +81,45 @@ Board specific DT Entry:
 	pcie@2a0000 {
 		reset-gpio = <&pin_ctrl 22 0>;
 	};
+
+* Synopsys Designware PCIe interface for v3.65 hardware.
+========================================================
+
+v3.65 hardware has application registers for msi/irq and inbound/outbound
+translation configuration. So the core designware driver has changes to
+support this difference in hardware. Following are the diffs:-
+
+Required Properties:
+- compatible: should contain additionally "snps,dw-pcie-v3.65" to identify
+  v3.65 hardware.
+- reg: index0 should be base addresses and lengths of the config space (first
+  4K for RC and next 4K for EP). index1 is base address and length of
+  application space (4K). Other indexes are specific to an implementation.
+- interrupts: N/A
+- clock-names: from common clock binding: should be "pcie"
+
+Other Required properties are present
+
+Example
+
+	pcie@21800000 {
+		compatible = "ti,keystone-pcie", "snps,dw-pcie-v3.65", "snps,dw-pcie";
+		device_type = "pci";
+		clocks = <&clkpcie>;
+		clock-names = "pcie";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		reg =  <0x21801000 0x2000>, <0x21800000 0x1000>;
+
+		ranges = <0x81000000 0 0x00000000 0x24000000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0x50000000 0x50000000 0 0x10000000>; /* non-prefetchable memory */
+
+		num-lanes = <2>;
+
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 7>;
+		interrupt-map = <0 0 0 1 &pcie_intc 0>, // INT A
+				<0 0 0 2 &pcie_intc 1>, // INT B
+				<0 0 0 3 &pcie_intc 2>, // INT C
+				<0 0 0 4 &pcie_intc 3>; // INT D
+	};
diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
new file mode 100644
index 0000000..dd72cb2
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
@@ -0,0 +1,56 @@
+DT binding documentation for Keystone PCI Controller
+====================================================
+
+Keystone PCI Controller is compliant to Designware PCI controller v3.65.
+Please refer to Documentation/devicetree/bindings/pci/designware-pci.txt
+for the details. Additional attributes are described here.
+
+Required Properties:-
+
+reg:  index 2 is the base address and length of PCI mode configuration register
+      index 3 is the base address and length of PCI device ID register.
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
+	ti,enable-linktrain - Enable Link training.
+	  - If boot loader already does PCI link establishment, then this
+	    shouldn't be present.
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 2fcd9f9..a019b77 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -38,4 +38,11 @@ config PCI_RCAR_GEN2
 	  There are 3 internal PCI controllers available with a single
 	  built-in EHCI/OHCI host controller present on each one.
 
+config PCI_KEYSTONE
+	bool "TI Keystone PCIe controller"
+	depends on ARCH_KEYSTONE
+	select PCIE_DW
+	select PCI_DW_V3_65
+	select PCIEPORTBUS
+	select PHY_TI_KEYSTONE_SERDES
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index b44a878..d7c1857 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
 obj-$(CONFIG_PCI_DW_V3_65) += pci-dw-v3_65-msi.o pci-dw-v3_65.o
+obj-$(CONFIG_PCI_KEYSTONE) += pci-keystone.o
diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
new file mode 100644
index 0000000..d82ac7f
--- /dev/null
+++ b/drivers/pci/host/pci-keystone.c
@@ -0,0 +1,418 @@
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
+#include "pci-dw-v3_65.h"
+
+#define DRIVER_NAME	"keystone-pcie"
+
+/* driver specific constants */
+#define MAX_MSI_HOST_IRQS		8
+#define MAX_LEGACY_HOST_IRQS		4
+
+/* RC mode settings */
+#define PCIE_RC_MODE		(BIT(2))
+#define PCIE_MODE_MASK		(BIT(1) | BIT(2))
+
+/* DEV_STAT_CTRL */
+#define PCIE_CAP_BASE       0x70
+
+struct keystone_pcie {
+	struct	clk		*clk;
+	int			en_link_train;
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
+};
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
+	/* check if the link is up or not */
+	while (!dw_pcie_link_up(pp)) {
+		usleep_range(100, 1000);
+		if (--count)
+			continue;
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
+	dev_dbg(pp->dev, "ks_pcie_msi_irq_handler, irq %d\n", irq);
+
+	/*
+	 * The chained irq handler installation would have replaced normal
+	 * interrupt driver handler so we need to take care of mask/unmask and
+	 * ack operation.
+	 */
+	chained_irq_enter(chip, desc);
+	dw_v3_65_handle_msi_irq(pp, offset);
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
+	u32 irq_offset = irq - ks_pcie->legacy_host_irqs[0];
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct pcie_port *pp = &ks_pcie->pp;
+
+	dev_dbg(ks_pcie->pp.dev, ": Handling legacy irq %d\n", irq);
+
+	/*
+	 * The chained irq handler installation would have replaced normal
+	 * interrupt driver handler so we need to take care of mask/unmask and
+	 * ack operation.
+	 */
+	chained_irq_enter(chip, desc);
+	dw_v3_65_handle_legacy_irq(pp, irq_offset);
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
+static void ks_pcie_enable_interrupts(struct keystone_pcie *ks_pcie)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	int i;
+
+	/* Legacy IRQ */
+	for (i = 0; i < ks_pcie->num_legacy_host_irqs; i++) {
+		irq_set_handler_data(ks_pcie->legacy_host_irqs[i], ks_pcie);
+		irq_set_chained_handler(ks_pcie->legacy_host_irqs[i],
+					ks_pcie_legacy_irq_handler);
+	}
+	dw_v3_65_enable_legacy_irqs(pp);
+
+	/* MSI IRQ */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		for (i = 0; i < ks_pcie->num_msi_host_irqs; i++) {
+			irq_set_chained_handler(ks_pcie->msi_host_irqs[i],
+				ks_pcie_msi_irq_handler);
+			irq_set_handler_data(ks_pcie->msi_host_irqs[i],
+						ks_pcie);
+
+		}
+	}
+
+	return;
+}
+
+/*
+ * When a PCI device does not exist during config cycles, keystone host gets a
+ * bus error instead of returning 0xffffffff. This handler always returns 0
+ * for this kind of faults.
+ */
+static int
+keystone_pcie_fault(unsigned long addr, unsigned int fsr,
+		struct pt_regs *regs)
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
+	dw_v3_65_disable_bars(pp);
+	dw_v3_65_setup_ob_regs(pp);
+	ks_pcie_enable_interrupts(ks_pcie);
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
+int ks_pcie_link_up(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	return dw_v3_65_pcie_link_up(pp, ks_pcie->en_link_train);
+}
+
+static struct pcie_host_ops keystone_pcie_host_ops = {
+	.rd_other_conf = dw_v3_65_rd_other_conf,
+	.wr_other_conf = dw_v3_65_wr_other_conf,
+	.link_up = ks_pcie_link_up,
+	.host_init = ks_pcie_host_init,
+	.get_msi_data = dw_v3_65_get_msi_data,
+};
+
+static int add_pcie_port(struct keystone_pcie *ks_pcie,
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
+	spin_lock_init(&pp->conf_lock);
+	ret = dw_v3_65_pcie_host_init(pp, ks_pcie->legacy_intc_np,
+				      ks_pcie->msi_intc_np);
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
+	struct device_node *np = pdev->dev.of_node;
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
+
+	pp = &ks_pcie->pp;
+
+	/* If phy is initialized by a boot loader, the below can be skipped */
+	phy = devm_phy_get(dev, "pcie-phy");
+	if (phy) {
+		ret = phy_init(phy);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* index 0 is the config reg. space address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pp->cfg = *res;
+
+	/* index 1 is the application reg. space address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	pp->app = *res;
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
+	/* index 3 is to read PCI DEVICE_ID */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	reg_p = devm_ioremap_resource(dev, res);
+	if (IS_ERR(reg_p))
+		return PTR_ERR(reg_p);
+	ks_pcie->va_reg_pciid = reg_p;
+
+	/* check if we need to enable link training */
+	ks_pcie->en_link_train =
+		(of_get_property(np, "ti,enable-linktrain", NULL) != NULL);
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
+	ret = add_pcie_port(ks_pcie, pdev);
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
-- 
1.7.9.5

