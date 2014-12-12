Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031128AbaLLRSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:18:20 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33755 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030990AbaLLRSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:18:17 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 4/5] PCI: qcom: Add Qualcomm PCIe controller driver
Date: Fri, 12 Dec 2014 19:14:00 +0200
Message-Id: <1418404441-5518-5-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe driver reuse the Designware common code for host
and MSI initialization, and also program the Qualcomm
application specific registers.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/pci/host/Kconfig     |    9 +
 drivers/pci/host/Makefile    |    1 +
 drivers/pci/host/pcie-qcom.c |  415 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 425 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/host/pcie-qcom.c

diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index c4b6568..1b138c1 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -102,4 +102,13 @@ config PCI_LAYERSCAPE
 	help
 	  Say Y here if you want PCIe controller support on Layerscape SoCs.
 
+config PCIE_QCOM
+	bool "Qualcomm PCIe controller"
+	depends on ARCH_QCOM && OF || (ARM && COMPILE_TEST)
+	select PCIE_DW
+	select PCIEPORTBUS
+	help
+	  Say Y here to enable PCIe controller support on Qualcomm SoCs. The
+	  PCIe controller use Designware core plus Qualcomm specific hardware
+	  wrappers.
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 44c2699..c45971a 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_PCI_KEYSTONE) += pci-keystone-dw.o pci-keystone.o
 obj-$(CONFIG_PCIE_XILINX) += pcie-xilinx.o
 obj-$(CONFIG_PCI_XGENE) += pci-xgene.o
 obj-$(CONFIG_PCI_LAYERSCAPE) += pci-layerscape.o
+obj-$(CONFIG_PCIE_QCOM) += pcie-qcom.o
diff --git a/drivers/pci/host/pcie-qcom.c b/drivers/pci/host/pcie-qcom.c
new file mode 100644
index 0000000..cc7df56
--- /dev/null
+++ b/drivers/pci/host/pcie-qcom.c
@@ -0,0 +1,415 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/phy/phy.h>
+#include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "pcie-designware.h"
+
+#define PCIE20_PARF_DBI_BASE_ADDR		0x168
+#define PCIE20_PARF_SLV_ADDR_SPACE_SIZE		0x16c
+#define PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT	0x178
+
+#define PCIE20_ELBI_SYS_CTRL			0x04
+#define PCIE20_ELBI_SYS_STTS			0x08
+#define XMLH_LINK_UP				BIT(10)
+
+#define PCIE20_CAP				0x70
+#define PCIE20_CAP_LINKCTRLSTATUS		(PCIE20_CAP + 0x10)
+
+#define PERST_DELAY_MIN_US			1000
+#define PERST_DELAY_MAX_US			1005
+
+#define LINKUP_DELAY_MIN_US			5000
+#define LINKUP_DELAY_MAX_US			5100
+#define LINKUP_RETRIES_COUNT			20
+
+struct qcom_pcie {
+	struct pcie_port pp;
+	struct device *dev;
+	struct regulator *vdd_pc;
+	struct clk *aux;
+	struct clk *iface;
+	struct clk *master_bus;
+	struct clk *slave_bus;
+	struct clk *pipe;
+	struct reset_control *res_core;
+	void __iomem *parf;
+	void __iomem *dbi;
+	void __iomem *elbi;
+	struct phy *phy;
+	int reset_gpio;
+};
+
+#define to_qcom_pcie(x)		container_of(x, struct qcom_pcie, pp)
+
+static inline void
+writel_masked(void __iomem *addr, u32 clear_mask, u32 set_mask)
+{
+	u32 val = readl(addr);
+
+	val &= ~clear_mask;
+	val |= set_mask;
+	writel(val, addr);
+}
+
+static void qcom_ep_reset_assert_deassert(struct qcom_pcie *pcie, int assert)
+{
+	if (pcie->reset_gpio < 0)
+		return;
+
+	if (assert)
+		gpio_set_value(pcie->reset_gpio, 0);
+	else
+		gpio_set_value(pcie->reset_gpio, 1);
+
+	usleep_range(PERST_DELAY_MIN_US, PERST_DELAY_MAX_US);
+}
+
+static void qcom_ep_reset_assert(struct qcom_pcie *pcie)
+{
+	qcom_ep_reset_assert_deassert(pcie, 1);
+}
+
+static void qcom_ep_reset_deassert(struct qcom_pcie *pcie)
+{
+	qcom_ep_reset_assert_deassert(pcie, 0);
+}
+
+static irqreturn_t qcom_pcie_msi_irq_handler(int irq, void *arg)
+{
+	struct pcie_port *pp = arg;
+
+	return dw_handle_msi_irq(pp);
+}
+
+static int qcom_pcie_link_up(struct pcie_port *pp)
+{
+	struct qcom_pcie *pcie = to_qcom_pcie(pp);
+	u32 val = readl(pcie->dbi + PCIE20_CAP_LINKCTRLSTATUS);
+
+	return val & BIT(29) ? 1 : 0;
+}
+
+static void qcom_pcie_disable_resources(struct qcom_pcie *pcie)
+{
+	reset_control_assert(pcie->res_core);
+	clk_disable_unprepare(pcie->slave_bus);
+	clk_disable_unprepare(pcie->master_bus);
+	clk_disable_unprepare(pcie->iface);
+	clk_disable_unprepare(pcie->aux);
+	regulator_disable(pcie->vdd_pc);
+}
+
+static int qcom_pcie_enable_resources(struct qcom_pcie *pcie)
+{
+	struct device *dev = pcie->dev;
+	int ret;
+
+	ret = regulator_enable(pcie->vdd_pc);
+	if (ret) {
+		dev_err(dev, "cannot enable vdd_pc regulator\n");
+		return ret;
+	}
+
+	ret = regulator_set_mode(pcie->vdd_pc, REGULATOR_MODE_NORMAL);
+	if (ret) {
+		dev_err(dev, "cannot set vdd_pc regulator normal mode\n");
+		goto err_reg;
+	}
+
+	ret = reset_control_deassert(pcie->res_core);
+	if (ret) {
+		dev_err(dev, "cannot deassert core reset\n");
+		goto err_reg;
+	}
+
+	ret = clk_prepare_enable(pcie->aux);
+	if (ret) {
+		dev_err(dev, "cannot prepare/enable aux clock\n");
+		goto err_res;
+	}
+
+	ret = clk_prepare_enable(pcie->iface);
+	if (ret) {
+		dev_err(dev, "cannot prepare/enable iface clock\n");
+		goto err_aux;
+	}
+
+	ret = clk_prepare_enable(pcie->master_bus);
+	if (ret) {
+		dev_err(dev, "cannot prepare/enable master_bus clock\n");
+		goto err_iface;
+	}
+
+	ret = clk_prepare_enable(pcie->slave_bus);
+	if (ret) {
+		dev_err(dev, "cannot prepare/enable slave_bus clock\n");
+		goto err_master_bus;
+	}
+
+	return 0;
+
+err_master_bus:
+	clk_disable_unprepare(pcie->master_bus);
+err_iface:
+	clk_disable_unprepare(pcie->iface);
+err_aux:
+	clk_disable_unprepare(pcie->aux);
+err_res:
+	reset_control_assert(pcie->res_core);
+err_reg:
+	regulator_disable(pcie->vdd_pc);
+
+	return ret;
+}
+
+static void qcom_pcie_host_init(struct pcie_port *pp)
+{
+	struct qcom_pcie *pcie = to_qcom_pcie(pp);
+	struct device *dev = pp->dev;
+	int retries, ret;
+	u32 val;
+
+	qcom_ep_reset_assert(pcie);
+
+	ret = qcom_pcie_enable_resources(pcie);
+	if (ret)
+		goto err_assert;
+
+	/* change DBI base address */
+	writel(0, pcie->parf + PCIE20_PARF_DBI_BASE_ADDR);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		writel_masked(pcie->parf + PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT,
+			      0, BIT(31));
+
+	ret = phy_init(pcie->phy);
+	if (ret)
+		goto err_res;
+
+	ret = phy_power_on(pcie->phy);
+	if (ret)
+		goto err_phy;
+
+	dw_pcie_setup_rc(pp);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		dw_pcie_msi_init(pp);
+
+	qcom_ep_reset_deassert(pcie);
+
+	/* enable link training */
+	writel_masked(pcie->elbi + PCIE20_ELBI_SYS_CTRL, 0, BIT(0));
+
+	/* wait for up to 100ms for the link to come up */
+	retries = LINKUP_RETRIES_COUNT;
+	do {
+		val = readl(pcie->elbi + PCIE20_ELBI_SYS_STTS);
+		if (val & XMLH_LINK_UP)
+			break;
+		usleep_range(LINKUP_DELAY_MIN_US, LINKUP_DELAY_MAX_US);
+	} while (retries--);
+
+	if (retries < 0 || !dw_pcie_link_up(pp)) {
+		dev_err(dev, "link initialization failed\n");
+		goto err;
+	}
+
+	return;
+
+err:
+	phy_power_off(pcie->phy);
+err_phy:
+	phy_exit(pcie->phy);
+err_res:
+	qcom_pcie_disable_resources(pcie);
+err_assert:
+	qcom_ep_reset_assert(pcie);
+}
+
+static int
+qcom_pcie_rd_own_conf(struct pcie_port *pp, int where, int size, u32 *val)
+{
+	if (where == PCI_CLASS_REVISION && size == 4) {
+		*val = readl(pp->dbi_base + PCI_CLASS_REVISION);
+		*val &= ~(0xffff << 16);
+		*val |= PCI_CLASS_BRIDGE_PCI << 16;
+		return PCIBIOS_SUCCESSFUL;
+	}
+
+	return dw_pcie_cfg_read(pp->dbi_base + (where & ~0x3), where,
+				size, val);
+}
+
+static struct pcie_host_ops qcom_pcie_host_ops = {
+	.link_up = qcom_pcie_link_up,
+	.host_init = qcom_pcie_host_init,
+	.rd_own_conf = qcom_pcie_rd_own_conf,
+};
+
+static int __init qcom_pcie_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct resource *res;
+	struct qcom_pcie *pcie;
+	struct pcie_port *pp;
+	enum of_gpio_flags gp_flags;
+	int ret;
+
+	pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
+	if (!pcie)
+		return -ENOMEM;
+
+	pcie->reset_gpio = of_get_gpio_flags(np, 0, &gp_flags);
+	if (pcie->reset_gpio > 0) {
+		ret = devm_gpio_request_one(dev, pcie->reset_gpio, gp_flags,
+					    "perst");
+		if (ret < 0)
+			return ret;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "parf");
+	pcie->parf = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pcie->parf))
+		return PTR_ERR(pcie->parf);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dbi");
+	pcie->dbi = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pcie->dbi))
+		return PTR_ERR(pcie->dbi);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "elbi");
+	pcie->elbi = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pcie->elbi))
+		return PTR_ERR(pcie->elbi);
+
+	pcie->phy = devm_phy_get(dev, "pciephy");
+	if (IS_ERR(pcie->phy))
+		return PTR_ERR(pcie->phy);
+
+	pcie->aux = devm_clk_get(dev, "aux");
+	if (IS_ERR(pcie->aux)) {
+		dev_err(dev, "failed to get aux clock\n");
+		return PTR_ERR(pcie->aux);
+	}
+
+	pcie->iface = devm_clk_get(dev, "iface");
+	if (IS_ERR(pcie->iface)) {
+		dev_err(dev, "failed to get iface clock\n");
+		return PTR_ERR(pcie->iface);
+	}
+
+	pcie->master_bus = devm_clk_get(dev, "master_bus");
+	if (IS_ERR(pcie->master_bus)) {
+		dev_err(dev, "failed to get master_bus clock\n");
+		return PTR_ERR(pcie->master_bus);
+	}
+
+	pcie->slave_bus = devm_clk_get(dev, "slave_bus");
+	if (IS_ERR(pcie->slave_bus)) {
+		dev_err(dev, "failed to get slave_bus clock\n");
+		return PTR_ERR(pcie->slave_bus);
+	}
+
+	pcie->vdd_pc = devm_regulator_get(dev, "vdd_pc");
+	if (IS_ERR(pcie->vdd_pc)) {
+		dev_err(dev, "failed to get vdd_pc regulator\n");
+		return PTR_ERR(pcie->vdd_pc);
+	}
+
+	pcie->res_core = devm_reset_control_get(dev, "core");
+	if (IS_ERR(pcie->res_core)) {
+		dev_err(dev, "cannot get core reset controller");
+		return PTR_ERR(pcie->res_core);
+	}
+
+	pcie->dev = dev;
+	pp = &pcie->pp;
+	pp->dev = dev;
+	pp->dbi_base = pcie->dbi;
+	pp->root_bus_nr = -1;
+	pp->ops = &qcom_pcie_host_ops;
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		pp->msi_irq = platform_get_irq_byname(pdev, "msi");
+		if (pp->msi_irq < 0) {
+			dev_err(dev, "failed to get msi irq\n");
+			return pp->msi_irq;
+		}
+
+		ret = devm_request_irq(dev, pp->msi_irq,
+				       qcom_pcie_msi_irq_handler,
+				       IRQF_SHARED, "qcom-pcie-msi", pp);
+		if (ret) {
+			dev_err(dev, "failed to request msi irq\n");
+			return ret;
+		}
+	}
+
+	ret = dw_pcie_host_init(pp);
+	if (ret) {
+		dev_err(dev, "failed to initialize host\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, pcie);
+
+	return 0;
+}
+
+static int qcom_pcie_remove(struct platform_device *pdev)
+{
+	struct qcom_pcie *pcie = platform_get_drvdata(pdev);
+
+	qcom_ep_reset_assert(pcie);
+	phy_power_off(pcie->phy);
+	phy_exit(pcie->phy);
+	qcom_pcie_disable_resources(pcie);
+
+	return 0;
+}
+
+static struct of_device_id qcom_pcie_match[] = {
+	{ .compatible = "qcom,pcie", },
+	{ }
+};
+
+static struct platform_driver __refdata qcom_pcie_driver = {
+	.probe = qcom_pcie_probe,
+	.remove = qcom_pcie_remove,
+	.driver = {
+		.name = "qcom-pcie",
+		.of_match_table = qcom_pcie_match,
+	},
+};
+
+module_platform_driver(qcom_pcie_driver);
+
+MODULE_AUTHOR("Stanimir Varbanov <svarbanov@mm-sol.com>");
+MODULE_DESCRIPTION("Qualcomm PCIe root complex driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:qcom-pcie");
-- 
1.7.0.4

