Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbaEFNfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:35:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44236 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaEFNfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Marek Vasut <marex@denx.de>
Subject: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx controller
Date: Tue, 6 May 2014 19:03:51 +0530
Message-ID: <1399383244-14556-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for pcie controller in dra7xx. This driver re-uses
the designware core code that is already present in kernel.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/pci/ti-pci.txt |   33 ++
 drivers/pci/host/Kconfig                         |   10 +
 drivers/pci/host/Makefile                        |    1 +
 drivers/pci/host/pci-dra7xx.c                    |  385 ++++++++++++++++++++++
 4 files changed, 429 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
 create mode 100644 drivers/pci/host/pci-dra7xx.c

diff --git a/Documentation/devicetree/bindings/pci/ti-pci.txt b/Documentation/devicetree/bindings/pci/ti-pci.txt
new file mode 100644
index 0000000..6cb6f09
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/ti-pci.txt
@@ -0,0 +1,33 @@
+TI PCI Controllers
+
+PCIe Designware Controller
+This node should have the properties described in "designware-pcie.txt".
+ - compatible: Should be "ti,dra7xx-pcie""
+ - reg : Address and length of the register set for the device.
+ - reg-names : "ti_conf" for the TI specific registers and rc_dbics for the
+   "designware" registers.
+ - phys : the phandle for the PHY device (used by generic PHY framework)
+ - phy-names : the names of the PHY corresponding to the PHYs present in the
+   *phy* phandle.
+
+Example:
+pcie@51000000 {
+	compatible = "ti,dra7xx-pcie";
+	reg = <0x51002000 0x14c>, <0x51000000 0x2000>;
+	reg-names = "ti_conf", "rc_dbics";
+	interrupts = <0 232 0x4>, <0 233 0x4>;
+	#address-cells = <3>;
+	#size-cells = <2>;
+	device_type = "pci";
+	ti,device_type = <3>;
+	ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000  /* Configuration Space */
+		  0x81000000 0 0          0x20003000 0 0x00010000  /* IO Space */
+		  0x82000000 0 0x20013000 0x20013000 0 0xffed000>; /* MEM Space */
+	#interrupt-cells = <1>;
+	num-lanes = <1>;
+	interrupt-map-mask = <0 0 0 0>;
+	interrupt-map = <0x0 0 &gic 134>;
+	ti,hwmods = "pcie1";
+	phys = <&pcie1_phy>;
+	phy-names = "pcie-phy";
+};
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index a6f67ec..7be6393 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -1,6 +1,16 @@
 menu "PCI host controller drivers"
 	depends on PCI
 
+config PCI_DRA7XX
+	bool "TI DRA7xx PCIe controller"
+	select PCIE_DW
+	depends on OF || HAS_IOMEM || TI_PIPE3
+	help
+	 Enables support for the PCIE controller present in DRA7xx SoC. There
+	 are two instances of PCIE controller in DRA7xx. This controller can
+	 act both as EP and RC. This reuses the same Designware core as used
+	 by other SoCs.
+
 config PCI_MVEBU
 	bool "Marvell EBU PCIe controller"
 	depends on ARCH_MVEBU || ARCH_DOVE || ARCH_KIRKWOOD
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 13fb333..5216f55 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_PCIE_DW) += pcie-designware.o
+obj-$(CONFIG_PCI_DRA7XX) += pci-dra7xx.o
 obj-$(CONFIG_PCI_EXYNOS) += pci-exynos.o
 obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
diff --git a/drivers/pci/host/pci-dra7xx.c b/drivers/pci/host/pci-dra7xx.c
new file mode 100644
index 0000000..a37c25c
--- /dev/null
+++ b/drivers/pci/host/pci-dra7xx.c
@@ -0,0 +1,385 @@
+/*
+ * pcie-dra7xx - PCIe controller driver for TI DRA7xx SoCs
+ *
+ * Copyright (C) 2013-2014 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Authors: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/resource.h>
+#include <linux/types.h>
+
+#include "pcie-designware.h"
+
+/* PCIe controller wrapper DRA7XX configuration registers */
+
+#define	PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN		0x0024
+#define	PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MAIN		0x0028
+#define	ERR_SYS						BIT(0)
+#define	ERR_FATAL					BIT(1)
+#define	ERR_NONFATAL					BIT(2)
+#define	ERR_COR						BIT(3)
+#define	ERR_AXI						BIT(4)
+#define	ERR_ECRC					BIT(5)
+#define	PME_TURN_OFF					BIT(8)
+#define	PME_TO_ACK					BIT(9)
+#define	PM_PME						BIT(10)
+#define	LINK_REQ_RST					BIT(11)
+#define	LINK_UP_EVT					BIT(12)
+#define	CFG_BME_EVT					BIT(13)
+#define	CFG_MSE_EVT					BIT(14)
+#define	INTERRUPTS (ERR_SYS | ERR_FATAL | ERR_NONFATAL | ERR_COR | ERR_AXI | \
+			ERR_ECRC | PME_TURN_OFF | PME_TO_ACK | PM_PME | \
+			LINK_REQ_RST | LINK_UP_EVT | CFG_BME_EVT | CFG_MSE_EVT)
+
+#define	PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI		0x0034
+#define	PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI		0x0038
+#define	INTA						BIT(0)
+#define	INTB						BIT(1)
+#define	INTC						BIT(2)
+#define	INTD						BIT(3)
+#define	MSI						BIT(4)
+#define	LEG_EP_INTERRUPTS (INTA | INTB | INTC | INTD)
+
+#define	PCIECTRL_DRA7XX_CONF_DEVICE_CMD			0x0104
+#define	LTSSM_EN					0x1
+
+#define	PCIECTRL_DRA7XX_CONF_PHY_CS			0x010C
+#define	LINK_UP						BIT(16)
+
+struct dra7xx_pcie {
+	void __iomem		*base;
+	struct phy		*phy;
+	struct device		*dev;
+	struct pcie_port	pp;
+};
+
+#define to_dra7xx_pcie(x)	container_of((x), struct dra7xx_pcie, pp)
+
+static inline u32 dra7xx_pcie_readl(void __iomem *base, u32 offset)
+{
+	return readl(base + offset);
+}
+
+static inline void dra7xx_pcie_writel(void __iomem *base, u32 offset, u32 value)
+{
+	writel(value, base + offset);
+}
+
+static int dra7xx_pcie_link_up(struct pcie_port *pp)
+{
+	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
+	u32 reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_PHY_CS);
+
+	if (reg & LINK_UP)
+		return true;
+	return false;
+}
+
+static int dra7xx_pcie_establish_link(struct pcie_port *pp)
+{
+	u32 reg;
+	int retries = 1000;
+	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
+
+	if (dw_pcie_link_up(pp)) {
+		dev_err(pp->dev, "link is already up\n");
+		return 0;
+	}
+
+	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
+	reg |= LTSSM_EN;
+	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);
+
+	while (--retries) {
+		reg = dra7xx_pcie_readl(dra7xx->base,
+					PCIECTRL_DRA7XX_CONF_PHY_CS);
+		if (reg & LINK_UP)
+			break;
+		usleep_range(10, 20);
+	}
+
+	if (retries <= 0) {
+		dev_err(pp->dev, "link is not up\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static void dra7xx_pcie_enable_interrupts(struct pcie_port *pp)
+{
+	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
+
+	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN,
+			   ~INTERRUPTS);
+	dra7xx_pcie_writel(dra7xx->base,
+			   PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MAIN, INTERRUPTS);
+	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI,
+			   ~LEG_EP_INTERRUPTS & ~MSI);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		dra7xx_pcie_writel(dra7xx->base,
+				   PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI, MSI);
+	else
+		dra7xx_pcie_writel(dra7xx->base,
+				   PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI,
+				   LEG_EP_INTERRUPTS);
+}
+
+static void dra7xx_pcie_host_init(struct pcie_port *pp)
+{
+	dw_pcie_setup_rc(pp);
+	dra7xx_pcie_establish_link(pp);
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		dw_pcie_msi_init(pp);
+	dra7xx_pcie_enable_interrupts(pp);
+}
+
+static struct pcie_host_ops dra7xx_pcie_host_ops = {
+	.link_up = dra7xx_pcie_link_up,
+	.host_init = dra7xx_pcie_host_init,
+};
+
+static irqreturn_t dra7xx_pcie_msi_irq_handler(int irq, void *arg)
+{
+	struct pcie_port *pp = arg;
+	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
+	u32 reg;
+
+	reg = dra7xx_pcie_readl(dra7xx->base,
+				PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI);
+	dw_handle_msi_irq(pp);
+	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI,
+			   reg);
+
+	return IRQ_HANDLED;
+}
+
+
+static irqreturn_t dra7xx_pcie_irq_handler(int irq, void *arg)
+{
+	struct dra7xx_pcie *dra7xx = arg;
+	u32 reg;
+
+	reg = dra7xx_pcie_readl(dra7xx->base,
+				PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN);
+
+	if (reg & ERR_SYS)
+		dev_dbg(dra7xx->dev, "System Error\n");
+
+	if (reg & ERR_FATAL)
+		dev_dbg(dra7xx->dev, "Fatal Error\n");
+
+	if (reg & ERR_NONFATAL)
+		dev_dbg(dra7xx->dev, "Non Fatal Error\n");
+
+	if (reg & ERR_COR)
+		dev_dbg(dra7xx->dev, "Correctable Error\n");
+
+	if (reg & ERR_AXI)
+		dev_dbg(dra7xx->dev, "AXI tag lookup fatal Error\n");
+
+	if (reg & ERR_ECRC)
+		dev_dbg(dra7xx->dev, "ECRC Error\n");
+
+	if (reg & PME_TURN_OFF)
+		dev_dbg(dra7xx->dev,
+			"Power Management Event Turn-Off message received\n");
+
+	if (reg & PME_TO_ACK)
+		dev_dbg(dra7xx->dev,
+			"Power Management Turn-Off Ack message received\n");
+
+	if (reg & PM_PME)
+		dev_dbg(dra7xx->dev,
+			"PM Power Management Event message received\n");
+
+	if (reg & LINK_REQ_RST)
+		dev_dbg(dra7xx->dev, "Link Request Reset\n");
+
+	if (reg & LINK_UP_EVT)
+		dev_dbg(dra7xx->dev, "Link-up state change\n");
+
+	if (reg & CFG_BME_EVT)
+		dev_dbg(dra7xx->dev, "CFG 'Bus Master Enable' change\n");
+
+	if (reg & CFG_MSE_EVT)
+		dev_dbg(dra7xx->dev, "CFG 'Memory Space Enable' change\n");
+
+	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN,
+			   reg);
+
+	return IRQ_HANDLED;
+}
+
+static int add_pcie_port(struct dra7xx_pcie *dra7xx,
+			  struct platform_device *pdev)
+{
+	int ret;
+	struct pcie_port *pp;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+
+	pp = &dra7xx->pp;
+	pp->dev = dev;
+	pp->ops = &dra7xx_pcie_host_ops;
+
+	spin_lock_init(&pp->conf_lock);
+
+	pp->irq = platform_get_irq(pdev, 1);
+	if (pp->irq < 0) {
+		dev_err(dev, "missing IRQ resource\n");
+		return -EINVAL;
+	}
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		ret = devm_request_irq(&pdev->dev, pp->irq,
+				       dra7xx_pcie_msi_irq_handler, IRQF_SHARED,
+				       "dra7-pcie-msi",	pp);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to request irq\n");
+			return ret;
+		}
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rc_dbics");
+	pp->dbi_base = devm_ioremap_nocache(dev, res->start,
+		resource_size(res));
+	if (!pp->dbi_base)
+		return -ENOMEM;
+
+	ret = dw_pcie_host_init(pp);
+	if (ret) {
+		dev_err(dra7xx->dev, "failed to initialize host\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __init dra7xx_pcie_probe(struct platform_device *pdev)
+{
+	u32 reg;
+	int ret;
+	int irq;
+	struct phy *phy;
+	void __iomem *base;
+	struct resource *res;
+	struct dra7xx_pcie *dra7xx;
+	struct device *dev = &pdev->dev;
+
+	dra7xx = devm_kzalloc(&pdev->dev, sizeof(*dra7xx), GFP_KERNEL);
+	if (!dra7xx)
+		return -ENOMEM;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "missing IRQ resource\n");
+		return -EINVAL;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, dra7xx_pcie_irq_handler,
+			       IRQF_SHARED, "dra7xx-pcie-main", dra7xx);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		return ret;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ti_conf");
+	base = devm_ioremap_nocache(dev, res->start, resource_size(res));
+	if (!base)
+		return -ENOMEM;
+
+	phy = devm_phy_get(dev, "pcie-phy");
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	ret = phy_init(phy);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_power_on(phy);
+	if (ret < 0)
+		goto err_power_on;
+
+	dra7xx->base = base;
+	dra7xx->phy = phy;
+	dra7xx->dev = dev;
+
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(dev, "pm_runtime_get_sync failed\n");
+		goto err_runtime_get;
+	}
+
+	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
+	reg &= ~LTSSM_EN;
+	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);
+
+	ret = add_pcie_port(dra7xx, pdev);
+	if (ret < 0)
+		goto err_add_port;
+
+	platform_set_drvdata(pdev, dra7xx);
+	return 0;
+
+err_power_on:
+	phy_exit(phy);
+
+err_runtime_get:
+	phy_power_off(phy);
+
+err_add_port:
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return ret;
+}
+
+static int __exit dra7xx_pcie_remove(struct platform_device *pdev)
+{
+	struct dra7xx_pcie *dra7xx = platform_get_drvdata(pdev);
+
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	phy_power_off(dra7xx->phy);
+	phy_exit(dra7xx->phy);
+
+	return 0;
+}
+
+static const struct of_device_id of_dra7xx_pcie_match[] = {
+	{ .compatible = "ti,dra7xx-pcie", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_dra7xx_pcie_match);
+
+static struct platform_driver dra7xx_pcie_driver = {
+	.remove		= __exit_p(dra7xx_pcie_remove),
+	.driver = {
+		.name	= "dra7xx-pcie",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_dra7xx_pcie_match,
+	},
+};
+
+module_platform_driver_probe(dra7xx_pcie_driver, dra7xx_pcie_probe);
+
+MODULE_AUTHOR("Kishon Vijay Abraham I <kishon@ti.com>");
+MODULE_DESCRIPTION("TI PCIe controller driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

