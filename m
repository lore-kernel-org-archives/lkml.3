Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaEPUsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:48:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50255 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbaEPUs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:48:29 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "pratyush.anand@st.com" <pratyush.anand@st.com>,
        "r65037@freescale.com" <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "marex@denx.de" <marex@denx.de>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: RE: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Thread-Topic: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Thread-Index: AQHPcFbztypDCmZvGUCN81SEYe7oaptDr24w
Date: Fri, 16 May 2014 20:47:54 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7047421F0@DFLE11.ent.ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <1400169692-9677-6-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1400169692-9677-6-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding more people to the list for review.

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Thursday, May 15, 2014 12:02 PM
>To: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org
>Cc: Karicheri, Muralidharan; Shilimkar, Santosh; Mohit Kumar; Jingoo Han; Bjorn Helgaas;
>Strashko, Grygorii
>Subject: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core driver
>
>keystone pcie hardware is based on designware version 3.65.
>This driver make use of the functions from pci-dw-old.c and pci-dw-old-msi.c to implement
>the driver.
>
>Driver mainly handle the platform specific part of the PCI driver and depends on DW Old
>driver to configure application specific registers. Also routes the irq events and ack the
>interrupt after the same is acked by the end point device driver. This requires irqchip
>implementation for legacy and MSI irq handling. This patch adds a quirks to override the
>max read request size as PCI controller has a limit of 256 bytes.
>
>CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>CC: Mohit Kumar <mohit.kumar@st.com>
>CC: Jingoo Han <jg1.han@samsung.com>
>CC: Bjorn Helgaas <bhelgaas@google.com>
>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>---
> .../devicetree/bindings/pci/pcie-keystone.txt      |   68 ++++
> drivers/pci/host/Kconfig                           |    8 +
> drivers/pci/host/Makefile                          |    1 +
> drivers/pci/host/pci-keystone.c                    |  400 ++++++++++++++++++++
> drivers/pci/quirks.c                               |   13 +
> 5 files changed, 490 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/pci/pcie-keystone.txt
> create mode 100644 drivers/pci/host/pci-keystone.c
>
>diff --git a/Documentation/devicetree/bindings/pci/pcie-keystone.txt
>b/Documentation/devicetree/bindings/pci/pcie-keystone.txt
>new file mode 100644
>index 0000000..17cf261
>--- /dev/null
>+++ b/Documentation/devicetree/bindings/pci/pcie-keystone.txt
>@@ -0,0 +1,68 @@
>+Keystone PCIE Root complex device tree bindings
>+-----------------------------------------------
>+
>+Sample bindings shown below:-
>+
>+ - Remove ti,enable-linktrain if boot loader already does Link training and do EP
>+   configuration.
>+ - Remove ti,init-phy if boot loader already initialize the phy and sets up pcie
>+   link
>+
>+		pcie0_phy: pciephy@2320000 {
>+			#address-cells = <1>;
>+			#size-cells = <1>;
>+			#phy-cells = <0>;
>+			compatible = "ti,keystone-phy";
>+			reg = <0x02320000 0x4000>;
>+			reg-names = "reg_serdes";
>+		};
>+
>+		pcie@21800000 {
>+			compatible = "ti,keystone-pcie";
>+			device_type = "pci";
>+			clocks = <&clkpcie>;
>+			clock-names = "pcie";
>+			#address-cells = <3>;
>+			#size-cells = <2>;
>+			reg =  <0x21800000 0x1000>, <0x0262014c 4>;
>+			reg-names = "reg_rc_app", "reg_devcfg";
>+			interrupts = <GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 37 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 38 IRQ_TYPE_EDGE_RISING>; /* Error IRQ */
>+
>+			ranges = <0x00000800 0 0x21801000 0x21801000 0 0x0002000    /*
>Configuration space */
>+				  0x81000000 0 0          0x24000000 0 0x4000       /* downstream
>I/O */
>+				  0x82000000 0 0x50000000 0x50000000 0 0x10000000>; /*
>+non-prefetchable memory */
>+
>+			num-lanes = <2>;
>+			ti,enable-linktrain;
>+			ti,init-phy;
>+
>+			/* PCIE phy */
>+			phys = <&pcie0_phy>;
>+			phy-names = "pcie-phy";
>+
>+			#interrupt-cells = <1>;
>+			interrupt-map-mask = <0 0 0 0>;
>+			interrupt-map = <0 0 0 1 &pcie_intc 1>, // INT A
>+					<0 0 0 2 &pcie_intc 2>, // INT B
>+					<0 0 0 3 &pcie_intc 3>, // INT C
>+					<0 0 0 4 &pcie_intc 4>; // INT D
>+
>+			pcie_intc: legacy-interrupt-controller {
>+				interrupt-controller;
>+				#interrupt-cells = <1>;
>+				interrupt-parent = <&gic>;
>+				interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 27 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 28 IRQ_TYPE_EDGE_RISING>,
>+					<GIC_SPI 29 IRQ_TYPE_EDGE_RISING>;
>+			};
>+		};
>+
>diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig index c4f4732..066d611
>100644
>--- a/drivers/pci/host/Kconfig
>+++ b/drivers/pci/host/Kconfig
>@@ -37,4 +37,12 @@ config PCI_RCAR_GEN2
> 	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
> 	  There are 3 internal PCI controllers available with a single
> 	  built-in EHCI/OHCI host controller present on each one.
>+
>+config PCI_KEYSTONE
>+	bool "TI Keystone PCIe controller"
>+	depends on ARCH_KEYSTONE
>+	select PCIE_DW
>+	select PCI_DW_OLD
>+	select PCIEPORTBUS
>+	select PHY_TI_KEYSTONE
> endmenu
>diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile index be5d939..10e02f9
>100644
>--- a/drivers/pci/host/Makefile
>+++ b/drivers/pci/host/Makefile
>@@ -5,3 +5,4 @@ obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
> obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
> obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
> obj-$(CONFIG_PCI_DW_OLD) += pci-dw-old-msi.o pci-dw-old.o
>+obj-$(CONFIG_PCI_KEYSTONE) += pci-keystone.o
>diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c new file mode
>100644 index 0000000..2636717
>--- /dev/null
>+++ b/drivers/pci/host/pci-keystone.c
>@@ -0,0 +1,400 @@
>+/*
>+ * PCIe host controller driver for Texas Instruments Keystone SoCs
>+ *
>+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
>+ *		http://www.ti.com
>+ *
>+ * Author: Murali Karicheri <m-karicheri2@ti.com>
>+ * Implementation based on pci-exynos.c and pcie-designware.c
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+
>+#include <linux/irqchip/chained_irq.h>
>+#include <linux/clk.h>
>+#include <linux/delay.h>
>+#include <linux/irqdomain.h>
>+#include <linux/module.h>
>+#include <linux/msi.h>
>+#include <linux/of_irq.h>
>+#include <linux/of.h>
>+#include <linux/of_pci.h>
>+#include <linux/platform_device.h>
>+#include <linux/phy/phy.h>
>+#include <linux/resource.h>
>+#include <linux/signal.h>
>+
>+#include "pcie-designware.h"
>+#include "pci-dw-old.h"
>+
>+#define DRIVER_NAME	"keystone-pcie"
>+
>+/* driver specific constants */
>+#define MAX_MSI_HOST_IRQS		8
>+#define MAX_LEGACY_HOST_IRQS		4
>+
>+/* RC mode settings */
>+#define PCIE_RC_MODE		(BIT(2))
>+#define PCIE_MODE_MASK		(BIT(1) | BIT(2))
>+
>+static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys) {
>+	return sys->private_data;
>+}
>+
>+struct keystone_pcie {
>+	struct	clk		*clk;
>+	int			en_link_train;
>+	struct	pcie_port	pp;
>+
>+	int			num_legacy_host_irqs;
>+	int			legacy_host_irqs[MAX_LEGACY_HOST_IRQS];
>+	struct			device_node *np_intc;
>+
>+	int			num_msi_host_irqs;
>+	int			msi_host_irqs[MAX_MSI_HOST_IRQS];
>+};
>+
>+#define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
>+
>+static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie) {
>+	struct pcie_port *pp = &ks_pcie->pp;
>+	int count = 200;
>+
>+	dw_pcie_setup_rc(pp);
>+
>+	/* check if the link is up or not */
>+	while (!dw_pcie_link_up(pp)) {
>+		usleep_range(100, 1000);
>+		if (--count)
>+			continue;
>+		dev_err(pp->dev, "phy link never came up\n");
>+		return -EINVAL;
>+	}
>+
>+	return 0;
>+}
>+
>+static void ks_pcie_msi_irq_handler(unsigned int irq, struct irq_desc
>+*desc) {
>+	struct keystone_pcie *ks_pcie = irq_desc_get_handler_data(desc);
>+	u32 offset = irq - ks_pcie->msi_host_irqs[0];
>+	struct pcie_port *pp = &ks_pcie->pp;
>+	struct irq_chip *chip = irq_desc_get_chip(desc);
>+
>+	dev_dbg(pp->dev, "ks_pcie_msi_irq_handler, irq %d\n", irq);
>+
>+	/*
>+	 * The chained irq handler installation would have replaced normal
>+	 * interrupt driver handler so we need to take care of mask/unmask and
>+	 * ack operation.
>+	 */
>+	chained_irq_enter(chip, desc);
>+	dw_old_handle_msi_irq(pp, offset);
>+	chained_irq_exit(chip, desc);
>+}
>+
>+/**
>+ * ks_pcie_legacy_irq_handler() - Handle legacy interrupt
>+ * @irq: IRQ line for legacy interrupts
>+ * @desc: Pointer to irq descriptor
>+ *
>+ * Traverse through pending legacy interrupts and invoke handler for
>+each. Also
>+ * takes care of interrupt controller level mask/ack operation.
>+ */
>+static void ks_pcie_legacy_irq_handler(unsigned int irq, struct
>+irq_desc *desc) {
>+	struct keystone_pcie *ks_pcie = irq_desc_get_handler_data(desc);
>+	u32 irq_offset = irq - ks_pcie->legacy_host_irqs[0];
>+	struct irq_chip *chip = irq_desc_get_chip(desc);
>+	struct pcie_port *pp = &ks_pcie->pp;
>+
>+	dev_dbg(ks_pcie->pp.dev, ": Handling legacy irq %d\n", irq);
>+
>+	/*
>+	 * The chained irq handler installation would have replaced normal
>+	 * interrupt driver handler so we need to take care of mask/unmask and
>+	 * ack operation.
>+	 */
>+	chained_irq_enter(chip, desc);
>+	dw_old_handle_legacy_irq(pp, irq_offset);
>+	chained_irq_exit(chip, desc);
>+}
>+
>+static int ks_pcie_init_legacy_irqs(struct keystone_pcie *ks_pcie) {
>+	struct device *dev = ks_pcie->pp.dev;
>+	struct device_node *np_pcie = dev->of_node;
>+	int num_legacy_irqs;
>+	int ret = 0;
>+	int i;
>+
>+	/* get node */
>+	ks_pcie->np_intc = of_find_node_by_name(np_pcie,
>+						"legacy-interrupt-controller");
>+	if (!ks_pcie->np_intc) {
>+		dev_err(dev,
>+			"Node for legacy-interrupt-controller is absent\n");
>+		goto out;
>+	}
>+
>+	/* get number of IRQs */
>+	num_legacy_irqs = of_irq_count(ks_pcie->np_intc);
>+	if (!num_legacy_irqs)
>+		goto out;
>+
>+	if (num_legacy_irqs > MAX_LEGACY_HOST_IRQS) {
>+		dev_err(dev, "Too many legacy interrupts defined %u\n",
>+			num_legacy_irqs);
>+		num_legacy_irqs = MAX_LEGACY_HOST_IRQS;
>+	}
>+	/*
>+	 * support upto MAX_LEGACY_HOST_IRQS host and legacy IRQs.
>+	 * In dt from index 0 to 3
>+	 */
>+	for (i = 0; i < num_legacy_irqs; i++) {
>+		ks_pcie->legacy_host_irqs[i] =
>+			irq_of_parse_and_map(ks_pcie->np_intc, i);
>+		if (ks_pcie->legacy_host_irqs[i] < 0)
>+			break;
>+		ks_pcie->num_legacy_host_irqs++;
>+	}
>+
>+	if (!ks_pcie->num_legacy_host_irqs) {
>+		dev_err(dev, "Failed to get legacy interrupts\n");
>+		goto out;
>+	}
>+
>+out:
>+	return ret;
>+}
>+
>+static void ks_pcie_enable_interrupts(struct keystone_pcie *ks_pcie) {
>+	struct pcie_port *pp = &ks_pcie->pp;
>+	int i;
>+
>+	/* Legacy IRQ */
>+	for (i = 0; i < ks_pcie->num_legacy_host_irqs; i++) {
>+		irq_set_handler_data(ks_pcie->legacy_host_irqs[i], ks_pcie);
>+		irq_set_chained_handler(ks_pcie->legacy_host_irqs[i],
>+					ks_pcie_legacy_irq_handler);
>+	}
>+	dw_old_enable_legacy_irqs(pp);
>+
>+	/* MSI IRQ */
>+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>+		for (i = 0; i < ks_pcie->num_msi_host_irqs; i++) {
>+			irq_set_chained_handler(ks_pcie->msi_host_irqs[i],
>+				ks_pcie_msi_irq_handler);
>+			irq_set_handler_data(ks_pcie->msi_host_irqs[i],
>+						ks_pcie);
>+
>+		}
>+	}
>+
>+	return;
>+}
>+
>+static int
>+keystone_pcie_fault(unsigned long addr, unsigned int fsr,
>+		struct pt_regs *regs)
>+{
>+	unsigned long instr = *(unsigned long *) instruction_pointer(regs);
>+
>+	if ((instr & 0x0e100090) == 0x00100090) {
>+		int reg = (instr >> 12) & 15;
>+
>+		regs->uregs[reg] = -1;
>+		regs->ARM_pc += 4;
>+	}
>+
>+	return 0;
>+}
>+
>+static void __init ks_pcie_host_init(struct pcie_port *pp) {
>+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
>+
>+	ks_pcie_establish_link(ks_pcie);
>+	dw_old_disable_bars(pp);
>+	dw_old_setup_ob_regs(pp);
>+	ks_pcie_enable_interrupts(ks_pcie);
>+	writew(PCI_IO_RANGE_TYPE_32 | (PCI_IO_RANGE_TYPE_32 << 8),
>+			pp->dbi_base + PCI_IO_BASE);
>+	/*
>+	 * PCIe access errors that result into OCP errors are caught by ARM as
>+	 * "External aborts" (Precise).
>+	 */
>+	hook_fault_code(17, keystone_pcie_fault, SIGBUS, 0,
>+			"external abort on linefetch");
>+}
>+
>+int ks_pcie_link_up(struct pcie_port *pp) {
>+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
>+
>+	return dw_old_pcie_link_up(pp, ks_pcie->en_link_train); }
>+
>+static struct pcie_host_ops keystone_pcie_host_ops = {
>+	.rd_other_conf = dw_old_rd_other_conf,
>+	.wr_other_conf = dw_old_wr_other_conf,
>+	.link_up = ks_pcie_link_up,
>+	.host_init = ks_pcie_host_init,
>+	.get_msi_data = dw_old_get_msi_data,
>+};
>+
>+static int add_pcie_port(struct keystone_pcie *ks_pcie,
>+			 struct platform_device *pdev)
>+{
>+	struct device_node *np = pdev->dev.of_node;
>+	struct pcie_port *pp = &ks_pcie->pp;
>+	struct resource *res;
>+	int ret, i;
>+
>+	ret = ks_pcie_init_legacy_irqs(ks_pcie);
>+	if (ret)
>+		return ret;
>+
>+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>+		/*
>+		 * support upto 32 MSI irqs mapped to 8 host IRQs.
>+		 * In dt from index 4 to 11
>+		 */
>+		for (i = 0; i < MAX_MSI_HOST_IRQS; i++) {
>+			ks_pcie->msi_host_irqs[i] = irq_of_parse_and_map(np, i);
>+			if (ks_pcie->msi_host_irqs[i] < 0)
>+				break;
>+			ks_pcie->num_msi_host_irqs++;
>+		}
>+	}
>+
>+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg_rc_app");
>+	pp->va_app_base = devm_ioremap_resource(&pdev->dev, res);
>+	if (IS_ERR(pp->va_app_base))
>+		return PTR_ERR(pp->va_app_base);
>+	pp->app_base = res->start;
>+
>+	pp->root_bus_nr = -1;
>+	pp->version = DW_VERSION_OLD;
>+	pp->ops = &keystone_pcie_host_ops;
>+	spin_lock_init(&pp->conf_lock);
>+	ret = dw_old_pcie_host_init(pp, ks_pcie->np_intc);
>+	if (ret) {
>+		dev_err(&pdev->dev, "failed to initialize host\n");
>+		return ret;
>+	}
>+
>+	return ret;
>+}
>+
>+static const struct of_device_id ks_pcie_of_match[] = {
>+	{
>+		.type = "pci",
>+		.compatible = "ti,keystone-pcie",
>+	},
>+	{ },
>+};
>+MODULE_DEVICE_TABLE(of, ks_pcie_of_match);
>+
>+static int __exit ks_pcie_remove(struct platform_device *pdev) {
>+	struct keystone_pcie *ks_pcie = platform_get_drvdata(pdev);
>+
>+	clk_disable_unprepare(ks_pcie->clk);
>+
>+	return 0;
>+}
>+
>+static int __init ks_pcie_probe(struct platform_device *pdev) {
>+	struct device_node *np = pdev->dev.of_node;
>+	struct device *dev = &pdev->dev;
>+	struct keystone_pcie *ks_pcie;
>+	void __iomem *devstat;
>+	struct pcie_port *pp;
>+	struct resource *res;
>+	struct phy *phy;
>+	int ret = 0;
>+	u32 val;
>+
>+	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
>+				GFP_KERNEL);
>+	if (!ks_pcie) {
>+		dev_err(dev, "no memory for keystone pcie\n");
>+		return -ENOMEM;
>+	}
>+
>+	/* check if serdes phy needs to be enabled */
>+	if (of_get_property(np, "ti,init-phy", NULL) != NULL) {
>+		phy = devm_phy_get(dev, "pcie-phy");
>+			if (IS_ERR(phy))
>+				return PTR_ERR(phy);
>+
>+		ret = phy_init(phy);
>+		if (ret < 0)
>+			return ret;
>+	}
>+
>+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>+					   "reg_devcfg");
>+	devstat = devm_ioremap_resource(dev, res);
>+	if (IS_ERR(devstat))
>+		return PTR_ERR(devstat);
>+
>+	/* enable RC mode in devcfg */
>+	val = readl(devstat);
>+	val &= ~PCIE_MODE_MASK;
>+	val |= PCIE_RC_MODE;
>+	writel(val, devstat);
>+
>+	/* check if we need to enable link training */
>+	ks_pcie->en_link_train =
>+		(of_get_property(np, "ti,enable-linktrain", NULL) != NULL);
>+
>+	pp = &ks_pcie->pp;
>+	pp->dev = dev;
>+
>+	ks_pcie->clk = devm_clk_get(dev, "pcie");
>+	if (IS_ERR(ks_pcie->clk)) {
>+		dev_err(dev, "Failed to get pcie rc clock\n");
>+		return PTR_ERR(ks_pcie->clk);
>+	}
>+	ret = clk_prepare_enable(ks_pcie->clk);
>+	if (ret)
>+		return ret;
>+
>+	ret = add_pcie_port(ks_pcie, pdev);
>+	if (ret < 0)
>+		goto fail_clk;
>+
>+	platform_set_drvdata(pdev, ks_pcie);
>+	dev_info(dev, "pcie rc probe success\n");
>+
>+	return 0;
>+
>+fail_clk:
>+	clk_disable_unprepare(ks_pcie->clk);
>+
>+	return ret;
>+}
>+
>+static struct platform_driver ks_pcie_driver __refdata = {
>+	.probe  = ks_pcie_probe,
>+	.remove = __exit_p(ks_pcie_remove),
>+	.driver = {
>+		.name	= "keystone-pcie",
>+		.owner	= THIS_MODULE,
>+		.of_match_table = of_match_ptr(ks_pcie_of_match),
>+	},
>+};
>+
>+module_platform_driver(ks_pcie_driver);
>+
>+MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
>+MODULE_DESCRIPTION("Keystone PCIe host controller driver");
>+MODULE_LICENSE("GPL v2");
>diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index e729206..b3e12c2 100644
>--- a/drivers/pci/quirks.c
>+++ b/drivers/pci/quirks.c
>@@ -3651,3 +3651,16 @@ void pci_dev_specific_enable_acs(struct pci_dev *dev)
> 		}
> 	}
> }
>+#ifdef CONFIG_PCI_KEYSTONE
>+/*
>+ * The KeyStone PCIe controller has maximum read request size of 256 bytes.
>+ */
>+static void quirk_limit_readrequest(struct pci_dev *dev) {
>+	int readrq = pcie_get_readrq(dev);
>+
>+	if (readrq > 256)
>+		pcie_set_readrq(dev, 256);
>+}
>+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID,
>+quirk_limit_readrequest); #endif /* CONFIG_PCI_KEYSTONE */
>--
>1.7.9.5

