Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaCYAgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:36:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46267 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbaCYAg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:36:26 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Mohit Kumar <mohit.kumar@st.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based on designware core driver
Date: Mon, 24 Mar 2014 20:35:26 -0400
Message-ID: <1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keystone pcie hardware is based on designware version 3.65. This
doesn't support standard MSI controller and ATU port available
on newer version of the designware hardware. In keystone dw hardware
the application register space implements the legacy and MSI
irq controller registers and has registers to allow outbound and
inbound translations. So the outbound/inbound configuration is
done by the keystone pcie driver.

Driver needs to handle irq as there are EOI registers available to
ack the interrupt after the same is acked by the end point device
driver. This requires irqchip implementation for legacy and MSI
irq handling. The driver however re-uses functions from dw core
wherever possible by making their prototype available in the dw
header file and calling the same from the keystone pcie driver.

Also add dts binding documentation for configuration details.

CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 .../devicetree/bindings/pci/pcie-keystone.txt      |   32 +
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/k2-platform.c                     |  191 +++++
 drivers/pci/host/pcie-keystone.c                   |  860 ++++++++++++++++++++
 drivers/pci/host/pcie-ks-pdata.h                   |   19 +
 drivers/pci/quirks.c                               |   12 +
 7 files changed, 1120 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/pcie-keystone.txt
 create mode 100644 drivers/pci/host/k2-platform.c
 create mode 100644 drivers/pci/host/pcie-keystone.c
 create mode 100644 drivers/pci/host/pcie-ks-pdata.h

diff --git a/Documentation/devicetree/bindings/pci/pcie-keystone.txt b/Documentation/devicetree/bindings/pci/pcie-keystone.txt
new file mode 100644
index 0000000..b7b7651
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/pcie-keystone.txt
@@ -0,0 +1,32 @@
+Keystone PCIE Root complex device tree bindings
+-----------------------------------------------
+
+Sample bindings shown below:-
+
+ - Remove enable-linktrain if boot loader already does Link training and do EP
+   configuration.
+ - To Disable SERDES initialization during Linux boot up, remove the "reg_serdes"
+   reg values from the reg property.
+
+	pcie@21800000 {
+		compatible = "ti,keystone2-pcie";
+		device_type = "pci";
+		clocks = <&clkpcie>;
+		clock-names = "pcie";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		#interrupt-cells = <1>;
+		reg =  <0x21800000 0x1000>, <0x0262014c 4>, <0x02320000 0x4000>;
+		reg-names = "reg_rc_app", "reg_devcfg", "reg_serdes";
+		interrupts =	<0 26 0xf01>, <0 27 0xf01>, <0 28 0xf01>, <0 29 0xf01>,
+				<0 30 0xf01>, <0 31 0xf01>, <0 32 0xf01>, <0 33 0xf01>,
+				<0 34 0xf01>, <0 35 0xf01>, <0 36 0xf01>, <0 37 0xf01>,
+				<0 38 0xf01>; /* Error IRQ */
+
+		ranges = <0x00000800 0 0x21801000 0x21801000 0 0x0002000   /* Configuration space */
+			  0x81000000 0 0	  0x24000000 0 0x4000	   /* downstream I/O */
+			  0x82000000 0 0x50000000 0x50000000 0 0x10000000>; /* non-prefetchable memory */
+
+		num-lanes = <2>;
+		ti,enable-linktrain;
+	};
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 47d46c6..9e45260 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -33,4 +33,9 @@ config PCI_RCAR_GEN2
 	  There are 3 internal PCI controllers available with a single
 	  built-in EHCI/OHCI host controller present on each one.
 
+config PCIE_KEYSTONE
+	bool "TI Keystone PCIe controller"
+	depends on ARCH_KEYSTONE
+	select PCIE_DW
+	select PCIEPORTBUS
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 13fb333..34e28c9 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
+obj-$(CONFIG_PCIE_KEYSTONE) += pcie-keystone.o k2-platform.o
diff --git a/drivers/pci/host/k2-platform.c b/drivers/pci/host/k2-platform.c
new file mode 100644
index 0000000..e10db00
--- /dev/null
+++ b/drivers/pci/host/k2-platform.c
@@ -0,0 +1,191 @@
+/*
+ * PCIe Keystone platform specific driver code
+ *
+ * Copyright (C) 2013-2014 Texas Instruments, Inc.
+ *		http://www.ti.com
+ *
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/setup.h>
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+
+#include "pcie-ks-pdata.h"
+
+#define reg_dump(addr, mask) \
+		pr_debug("reg %p has value %x\n", (void *)addr, \
+				(__raw_readl(addr) & ~mask))
+
+#define PCIE_RC_MODE		(BIT(2))
+#define PCIE_MODE_MASK		(BIT(1) | BIT(2))
+
+static inline void reg_rmw(void __iomem *addr, u32 mask, u32 val)
+{
+	u32 read_data, data;
+	read_data = readl(addr);
+	data = (val & ~mask) | (read_data & mask);
+	writel(data, addr);
+}
+
+struct serdes_config {
+	u32 reg;
+	u32 mask;
+	u32 val;
+};
+
+/* SERDES configuration */
+static struct serdes_config k2_pcie_serdes_cfg[] = {
+	{ 0x000, 0xffff00ff, 0x00000800 },
+	{ 0x060, 0xff000000, 0x00041c5c },
+	{ 0x064, 0x000000ff, 0x0343c700 },
+	{ 0x06c, 0xffffff00, 0x00000012 },
+	{ 0x068, 0xff00ffff, 0x00070000 },
+	{ 0x078, 0xffff00ff, 0x0000c000 },
+	{ 0x200, 0xffffff00, 0x00000000 },
+	{ 0x204, 0x00ffff00, 0x5e000080 },
+	{ 0x208, 0xffffff00, 0x00000006 },
+	{ 0x210, 0xffffff00, 0x00000023 },
+	{ 0x214, 0x00ff0000, 0x2e003060 },
+	{ 0x218, 0x00ffffff, 0x76000000 },
+	{ 0x22c, 0xff00ff00, 0x00100002 },
+	{ 0x2a0, 0x0000ffff, 0xffee0000 },
+	{ 0x2a4, 0xffffff00, 0x0000000f },
+	{ 0x204, 0x00ffffff, 0x5e000000 },
+	{ 0x208, 0xffffff00, 0x00000006 },
+	{ 0x278, 0xffff00ff, 0x00002000 },
+	{ 0x280, 0xff00ff00, 0x00280028 },
+	{ 0x284, 0x00000000, 0x2d0f0385 },
+	{ 0x250, 0x00ffffff, 0xd0000000 },
+	{ 0x284, 0xffffff00, 0x00000085 },
+	{ 0x294, 0x00ffffff, 0x20000000 },
+
+	{ 0x400, 0xffffff00, 0x00000000 },
+	{ 0x404, 0x00ffff00, 0x5e000080 },
+	{ 0x408, 0xffffff00, 0x00000006 },
+	{ 0x410, 0xffffff00, 0x00000023 },
+	{ 0x414, 0x00ff0000, 0x2e003060 },
+	{ 0x418, 0x00ffffff, 0x76000000 },
+	{ 0x42c, 0xff00ff00, 0x00100002 },
+	{ 0x4a0, 0x0000ffff, 0xffee0000 },
+	{ 0x4a4, 0xffffff00, 0x0000000f },
+	{ 0x404, 0x00ffffff, 0x5e000000 },
+	{ 0x408, 0xffffff00, 0x00000006 },
+	{ 0x478, 0xffff00ff, 0x00002000 },
+	{ 0x480, 0xff00ff00, 0x00280028 },
+	{ 0x484, 0x00000000, 0x2d0f0385 },
+	{ 0x450, 0x00ffffff, 0xd0000000 },
+	{ 0x494, 0x00ffffff, 0x20000000 },
+
+	{ 0x604, 0xffffff00, 0x00000080 },
+	{ 0x600, 0xffffff00, 0x00000000 },
+	{ 0x604, 0x00ffffff, 0x5e000000 },
+	{ 0x608, 0xffffff00, 0x00000006 },
+	{ 0x610, 0xffffff00, 0x00000023 },
+	{ 0x614, 0x00ff0000, 0x2e003060 },
+	{ 0x618, 0x00ffffff, 0x76000000 },
+	{ 0x62c, 0xff00ff00, 0x00100002 },
+	{ 0x6a0, 0x0000ffff, 0xffee0000 },
+	{ 0x6a4, 0xffffff00, 0x0000000f },
+	{ 0x604, 0x00ffffff, 0x5e000000 },
+	{ 0x608, 0xffffff00, 0x00000006 },
+	{ 0x678, 0xffff00ff, 0x00002000 },
+	{ 0x680, 0xff00ff00, 0x00280028 },
+	{ 0x684, 0x00000000, 0x2d0f0385 },
+	{ 0x650, 0x00ffffff, 0xd0000000 },
+	{ 0x694, 0x00ffffff, 0x20000000 },
+
+	{ 0x800, 0xffffff00, 0x00000000 },
+	{ 0x804, 0x00ffff00, 0x5e000080 },
+	{ 0x808, 0xffffff00, 0x00000006 },
+	{ 0x810, 0xffffff00, 0x00000023 },
+	{ 0x814, 0x00ff0000, 0x2e003060 },
+	{ 0x818, 0x00ffffff, 0x76000000 },
+	{ 0x82c, 0xff00ff00, 0x00100002 },
+	{ 0x8a0, 0x0000ffff, 0xffee0000 },
+	{ 0x8a4, 0xffffff00, 0x0000000f },
+	{ 0x804, 0x00ffffff, 0x5e000000 },
+	{ 0x808, 0xffffff00, 0x00000006 },
+	{ 0x878, 0xffff00ff, 0x00002000 },
+	{ 0x880, 0xff00ff00, 0x00280028 },
+	{ 0x884, 0x00000000, 0x2d0f0385 },
+	{ 0x850, 0x00ffffff, 0xd0000000 },
+	{ 0x894, 0x00ffffff, 0x20000000 },
+
+	{ 0xa00, 0xffff00ff, 0x00000100 },
+	{ 0xa08, 0xff000000, 0x00e12c08 },
+	{ 0xa0c, 0xffffff00, 0x00000081 },
+	{ 0xa18, 0xff00ffff, 0x00e80000 },
+	{ 0xa30, 0x00ffff00, 0x002f2f00 },
+	{ 0xa48, 0xff0000ff, 0x00e3ce00 },
+	{ 0xa4c, 0x0000ffff, 0xac820000 },
+	{ 0xa54, 0x00ffffff, 0xc0000000 },
+	{ 0xa58, 0xffff0000, 0x00001441 },
+	{ 0xa84, 0xffff0000, 0x00000301 },
+
+	{ 0xa8c, 0x0000ffff, 0x81030000 },
+	{ 0xa90, 0xffff0000, 0x00006001 },
+	{ 0xa94, 0x00ffffff, 0x01000000 },
+	{ 0xaa0, 0x00ffffff, 0x81000000 },
+	{ 0xabc, 0x00ffffff, 0xff000000 },
+	{ 0xac0, 0xffffff00, 0x0000008b },
+
+	{ 0x000, 0xffffff00, 0x00000003 },
+	{ 0xa00, 0xffffff00, 0x0000009f },
+};
+
+int k2_pcie_platform_setup(struct platform_device *pdev)
+{
+	struct resource *phy_base_r, *devstat_r;
+	void __iomem *phy_base, *devstat;
+	u32 val;
+	int i;
+
+	devstat_r = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						 "reg_devcfg");
+	if (!devstat_r)
+		return -ENODEV;
+
+	devstat = devm_ioremap_resource(&pdev->dev, devstat_r);
+	if (IS_ERR(devstat)) {
+		dev_warn(&pdev->dev, "pcie devstat bindings missing\n");
+		return PTR_ERR(devstat);
+	}
+
+	phy_base_r = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						 "reg_serdes");
+	if (phy_base_r) {
+		phy_base = devm_ioremap_resource(&pdev->dev, phy_base_r);
+		if (IS_ERR(phy_base))
+			dev_info(&pdev->dev,
+				"phy (serdes) initialized by boot loader\n");
+		if (phy_base) {
+			for (i = 0; i < ARRAY_SIZE(k2_pcie_serdes_cfg); i++) {
+				reg_rmw((phy_base + k2_pcie_serdes_cfg[i].reg),
+					k2_pcie_serdes_cfg[i].mask,
+					k2_pcie_serdes_cfg[i].val);
+				reg_dump((phy_base + k2_pcie_serdes_cfg[i].reg),
+					k2_pcie_serdes_cfg[i].mask);
+			}
+		}
+	}
+
+	udelay(2000);
+
+	/* enable RC mode in devcfg */
+	val = readl(devstat);
+	val &= ~PCIE_MODE_MASK;
+	val |= PCIE_RC_MODE;
+	writel(val, devstat);
+	return 0;
+}
diff --git a/drivers/pci/host/pcie-keystone.c b/drivers/pci/host/pcie-keystone.c
new file mode 100644
index 0000000..aed203f
--- /dev/null
+++ b/drivers/pci/host/pcie-keystone.c
@@ -0,0 +1,860 @@
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
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/msi.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/resource.h>
+#include <linux/signal.h>
+#include <linux/types.h>
+
+#include "pcie-designware.h"
+#include "pcie-ks-pdata.h"
+
+#define DRIVER_NAME	"keystone-pcie"
+/*
+ *  Application Register Offsets
+ */
+#define CMD_STATUS			0x004
+#define CFG_SETUP			0x008
+#define IOBASE				0x00c
+#define OB_SIZE				0x030
+#define IRQ_EOI                         0x050
+#define MSI_IRQ				0x054
+#define MSI0_IRQ_STATUS			0x104
+#define MSI0_IRQ_ENABLE_SET		0x108
+#define MSI0_IRQ_ENABLE_CLR		0x10c
+#define IRQ_STATUS			0x184
+#define IRQ_ENABLE_SET			0x188
+#define IRQ_ENABLE_CLR			0x18c
+#define IB_BAR0				0x300
+#define IB_START0_LO			0x304
+#define IB_START0_HI			0x308
+#define IB_OFFSET0			0x30c
+/* 32 Registers */
+#define OB_OFFSET_INDEX(n)		(0x200 + (8 * n))
+/* 32 Registers */
+#define OB_OFFSET_HI(n)			(0x204 + (8 * n))
+
+/*
+ * PCIe Config Register Offsets
+ */
+#define DEBUG0			        0x728
+#define PL_GEN2			        0x80c
+
+/* Application command register values */
+#define DBI_CS2_EN_VAL		        BIT(5)
+#define IB_XLAT_EN_VAL		        BIT(2)
+#define OB_XLAT_EN_VAL		        BIT(1)
+#define LTSSM_EN_VAL		        BIT(0)
+
+/* Link training encodings as indicated in DEBUG0 register */
+#define LTSSM_STATE_MASK	        0x1f
+#define LTSSM_STATE_L0		        0x11
+
+/* Directed Speed Change */
+#define DIR_SPD				(1 << 17)
+
+/* Outbound window size specified as power of 2 MB */
+#define CFG_PCIM_WIN_SZ_IDX	        3
+#define CFG_PCIM_WIN_CNT	        32
+
+/* offset relative to SPACE0_LOCAL_CFG_OFFSET */
+#define SPACE0_REMOTE_CFG_OFFSET	0x1000
+
+/* driver specific constants */
+#define MAX_MSI_HOST_IRQS		8
+#define MSI_IRQ_OFFSET			4
+#define MAX_LEGACY_HOST_IRQS		4
+
+static struct keystone_pcie_pdata keystone2_data = {
+	.setup = k2_pcie_platform_setup,
+};
+
+struct keystone_pcie {
+	const struct keystone_pcie_pdata *pdata;
+	struct	clk		*clk;
+	struct	resource	reg_app;
+	void	__iomem		*va_reg_app;
+	int			en_link_train;
+	struct	pcie_port	pp;
+
+	int			num_legacy_host_irqs;
+	int			legacy_host_irqs[MAX_LEGACY_HOST_IRQS];
+	int			virqs[MAX_LEGACY_HOST_IRQS];
+	struct	irq_domain	*legacy_irqd;
+
+	int			num_msi_host_irqs;
+	int			msi_host_irqs[MAX_MSI_HOST_IRQS];
+};
+
+#define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
+
+static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
+{
+	return sys->private_data;
+}
+
+static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+	int count = 0;
+
+	dw_pcie_setup_rc(pp);
+
+	/* check if the link is up or not */
+	while (!dw_pcie_link_up(pp)) {
+		mdelay(100);
+		count++;
+		if (count == 10)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static void ks_mask_legacy_irq(void __iomem *reg_virt, int i)
+{
+	writel(0x1, reg_virt + IRQ_ENABLE_CLR + (i << 4));
+}
+
+static void ks_unmask_legacy_irq(void __iomem *reg_virt, int i)
+{
+	writel(0x1, reg_virt + IRQ_ENABLE_SET + (i << 4));
+}
+
+static void ks_pcie_msi_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct keystone_pcie *ks_pcie = irq_desc_get_handler_data(desc);
+	u32 offset = irq - ks_pcie->msi_host_irqs[0], pending, vector;
+	struct pcie_port *pp = &ks_pcie->pp;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	int src, virq;
+
+	dev_dbg(pp->dev, "ks_pcie_msi_irq_handler, irq %d\n", irq);
+
+	/*
+	 * The chained irq handler installation would have replaced normal
+	 * interrupt driver handler so we need to take care of mask/unmask and
+	 * ack operation.
+	 */
+	chip->irq_mask(&desc->irq_data);
+	if (chip->irq_ack)
+		chip->irq_ack(&desc->irq_data);
+
+	pending = readl(ks_pcie->va_reg_app + MSI0_IRQ_STATUS + (offset << 4));
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
+
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
+	chip->irq_unmask(&desc->irq_data);
+}
+
+static void ks_pcie_ack_msi(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	struct keystone_pcie *ks_pcie;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct irq_desc *desc;
+	struct pcie_port *pp;
+
+	desc = irq_to_desc(irq);
+	msi = irq_desc_get_msi_desc(desc);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	ks_pcie = to_keystone_pcie(pp);
+
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+
+	reg_offset = offset % 8;
+	bit_pos = offset >> 3;
+
+	writel(BIT(bit_pos),
+		ks_pcie->va_reg_app + MSI0_IRQ_STATUS + (reg_offset << 4));
+	writel(reg_offset + MSI_IRQ_OFFSET, ks_pcie->va_reg_app + IRQ_EOI);
+}
+
+static void ks_pcie_mask_msi(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	struct keystone_pcie *ks_pcie;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+	struct irq_desc *desc;
+
+
+	desc = irq_to_desc(irq);
+	msi = irq_desc_get_msi_desc(desc);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	ks_pcie = to_keystone_pcie(pp);
+
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+
+	reg_offset = offset % 8;
+	bit_pos = offset >> 3;
+
+	/* mask the end point if PVM implemented */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (msi->msi_attrib.maskbit)
+			mask_msi_irq(d);
+	}
+
+	writel(BIT(bit_pos),
+		ks_pcie->va_reg_app + MSI0_IRQ_ENABLE_CLR + (reg_offset << 4));
+}
+
+static void ks_pcie_unmask_msi(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	struct keystone_pcie *ks_pcie;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct irq_desc *desc;
+	struct pcie_port *pp;
+
+	desc = irq_to_desc(irq);
+	msi = irq_desc_get_msi_desc(desc);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	ks_pcie = to_keystone_pcie(pp);
+
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+
+	reg_offset = offset % 8;
+	bit_pos = offset >> 3;
+
+	/* mask the end point if PVM implemented */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (msi->msi_attrib.maskbit)
+			unmask_msi_irq(d);
+	}
+
+	writel(BIT(bit_pos),
+		ks_pcie->va_reg_app + MSI0_IRQ_ENABLE_SET + (reg_offset << 4));
+}
+
+static struct irq_chip ks_pcie_msi_chip = {
+	.name = "PCIe-MSI",
+	.irq_ack = ks_pcie_ack_msi,
+	.irq_mask = ks_pcie_mask_msi,
+	.irq_unmask = ks_pcie_unmask_msi,
+};
+
+static int ks_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
+			irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(irq, &ks_pcie_msi_chip, handle_level_irq);
+	irq_set_chip_data(irq, domain->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+static const struct irq_domain_ops msi_domain_ops = {
+	.map = ks_pcie_msi_map,
+};
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
+	u32 irq_offset = irq - ks_pcie->legacy_host_irqs[0], pending;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	int virq;
+
+	dev_dbg(ks_pcie->pp.dev, ": Handling legacy irq %d\n", irq);
+
+	/*
+	 * The chained irq handler installation would have replaced normal
+	 * interrupt driver handler so we need to take care of mask/unmask and
+	 * ack operation.
+	 */
+	chip->irq_mask(&desc->irq_data);
+	if (chip->irq_ack)
+		chip->irq_ack(&desc->irq_data);
+
+	pending = readl(ks_pcie->va_reg_app + IRQ_STATUS + (irq_offset << 4));
+
+	if (BIT(0) & pending) {
+		virq = irq_linear_revmap(ks_pcie->legacy_irqd, irq_offset);
+		dev_dbg(ks_pcie->pp.dev,
+			": irq: irq_offset %d, virq %d\n", irq_offset, virq);
+		generic_handle_irq(virq);
+	}
+
+	/* EOI the INTx interrupt */
+	writel(irq_offset, ks_pcie->va_reg_app + IRQ_EOI);
+
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
+	chip->irq_unmask(&desc->irq_data);
+}
+
+static void ks_pcie_enable_interrupts(struct keystone_pcie *ks_pcie)
+{
+	int i;
+
+	if (ks_pcie->num_legacy_host_irqs) {
+		for (i = 0; i < ks_pcie->num_legacy_host_irqs; i++) {
+			if (ks_pcie->legacy_host_irqs[i] >= 0)
+				ks_unmask_legacy_irq(ks_pcie->va_reg_app, i);
+			else
+				ks_mask_legacy_irq(ks_pcie->va_reg_app, i);
+		}
+	}
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		for (i = 0; i < ks_pcie->num_msi_host_irqs; i++) {
+			irq_set_chained_handler(ks_pcie->msi_host_irqs[i],
+				ks_pcie_msi_irq_handler);
+			irq_set_handler_data(ks_pcie->msi_host_irqs[i],
+						ks_pcie);
+
+		}
+	}
+	return;
+}
+
+/**
+ * ks_pcie_set_outbound_trans() - Set PHYADDR <-> BUSADDR
+ * mapping for outbound
+ */
+static void ks_pcie_set_outbound_trans(struct keystone_pcie *ks_pcie)
+{
+	u32 start = ks_pcie->pp.mem.start, end = ks_pcie->pp.mem.end;
+	int i, tr_size;
+
+	dev_dbg(ks_pcie->pp.dev,
+		"Setting outbound translation for %#x-%#x\n",
+		 start, end);
+
+	/* Set outbound translation size per window division */
+	writel(CFG_PCIM_WIN_SZ_IDX & 0x7, ks_pcie->va_reg_app + OB_SIZE);
+
+	tr_size = (1 << (CFG_PCIM_WIN_SZ_IDX & 0x7)) * SZ_1M;
+
+	/* Using Direct 1:1 mapping of RC <-> PCI memory space */
+	for (i = 0; (i < CFG_PCIM_WIN_CNT) && (start < end); i++) {
+		writel(start | 1, ks_pcie->va_reg_app + OB_OFFSET_INDEX(i));
+		writel(0, ks_pcie->va_reg_app + OB_OFFSET_HI(i));
+		start += tr_size;
+	}
+
+	/* Enable OB translation */
+	writel(OB_XLAT_EN_VAL | readl(ks_pcie->va_reg_app + CMD_STATUS),
+		ks_pcie->va_reg_app + CMD_STATUS);
+}
+
+/**
+ * ks_pcie_set_dbi_mode() - Set DBI mode to access overlaid BAR mask registers
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static inline void ks_pcie_set_dbi_mode(void __iomem *reg_virt)
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
+ * ks_pcie_clear_dbi_mode() - Disable DBI mode
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static inline void ks_pcie_clear_dbi_mode(void __iomem *reg_virt)
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
+static void ks_pcie_disable_bars(struct keystone_pcie *ks_pcie)
+{
+	struct pcie_port *pp = &ks_pcie->pp;
+
+	ks_pcie_set_dbi_mode(ks_pcie->va_reg_app);
+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_0);
+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_1);
+	ks_pcie_clear_dbi_mode(ks_pcie->va_reg_app);
+}
+
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
+	return 0;
+}
+
+static void __init ks_pcie_host_init(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	ks_pcie_establish_link(ks_pcie);
+	ks_pcie_disable_bars(ks_pcie);
+	ks_pcie_set_outbound_trans(ks_pcie);
+	ks_pcie_enable_interrupts(ks_pcie);
+
+	/* Enable 32-bit IO addressing support */
+	writew(PCI_IO_RANGE_TYPE_32 | (PCI_IO_RANGE_TYPE_32 << 8),
+			pp->dbi_base + PCI_IO_BASE);
+	/*
+	 * PCIe access errors that result into OCP errors are caught by ARM as
+	 * "External aborts" (Precise).
+	 */
+	hook_fault_code(17, keystone_pcie_fault, SIGBUS, 0,
+			"external abort on linefetch");
+}
+
+static int ks_pcie_link_up(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u32 val;
+
+	if (ks_pcie->en_link_train) {
+		/*
+		 * KeyStone devices do not support h/w autonomous
+		 * link up-training to GEN2 from GEN1 in either EP/RC modes.
+		 * The software needs to initiate speed change.
+		 */
+		val = readl(pp->dbi_base + PL_GEN2);
+		writel(val | DIR_SPD, pp->dbi_base + PL_GEN2);
+		/*
+		 * Initiate Link Training. We will delay for L0 as specified by
+		 * standard, but will still proceed and return success
+		 * irrespective of L0 status as this will be handled by explicit
+		 * L0 state checks during enumeration.
+		 */
+		val = readl(ks_pcie->va_reg_app + CMD_STATUS);
+		writel(LTSSM_EN_VAL | val,  ks_pcie->va_reg_app + CMD_STATUS);
+
+	}
+
+	val = readl(pp->dbi_base + DEBUG0);
+	return (val & LTSSM_STATE_MASK) == LTSSM_STATE_L0;
+}
+
+/**
+ * ks_pcie_setup_config_addr() - Set up configuration space address for a
+ * device
+ *
+ * @pp: ptr to pcie_port structure
+ * @bus: Bus number the device is residing on
+ * @device: Device number
+ * @function: Function number in device
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
+static inline void __iomem *
+ks_pcie_setup_config_addr(struct pcie_port *pp,
+			u8 bus, u8 device, u8 function)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u32 regval;
+
+	if (!ks_pcie)
+		return ks_pcie;
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
+	writel(regval, ks_pcie->va_reg_app + CFG_SETUP);
+	return pp->dbi_base + SPACE0_REMOTE_CFG_OFFSET;
+}
+
+static int ks_pcie_rd_other_conf(struct pcie_port *pp,
+		struct pci_bus *bus, unsigned int devfn, int where,
+		int size, u32 *val)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u8 bus_num = bus->number;
+	void __iomem *addr;
+	int ret;
+
+	if (!ks_pcie) {
+		dev_err(pp->dev, ": Can't get driver data\n");
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	addr = ks_pcie_setup_config_addr(pp, bus_num, PCI_SLOT(devfn),
+				 PCI_FUNC(devfn));
+
+	ret = cfg_read(addr + (where & ~0x3), where, size, val);
+	return ret;
+}
+
+static int ks_pcie_wr_other_conf(struct pcie_port *pp,
+		struct pci_bus *bus, unsigned int devfn, int where,
+		int size, u32 val)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u8 bus_num = bus->number;
+	void __iomem *addr;
+
+	if (!ks_pcie) {
+		dev_err(pp->dev,
+			"ks_pcie_wr_other_conf: Can't get driver data\n");
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	addr = ks_pcie_setup_config_addr(pp, bus_num, PCI_SLOT(devfn),
+				PCI_FUNC(devfn));
+	return cfg_write(addr + (where & ~0x3), where, size, val);
+}
+
+/**
+ * ks_pcie_set_inbound_trans() - Setup inbound access
+ *
+ * Configure BAR0 for inbound access. BAR0 is set up in h/w to have
+ * access to PCIESS application register space and just needs to set up
+ * inbound address (mainly used for MSI).
+ */
+static void ks_pcie_set_inbound_trans(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	/* Configure and set up BAR0 */
+	ks_pcie_set_dbi_mode(ks_pcie->va_reg_app);
+
+	/* Enable BAR0 */
+	writel(1, pp->dbi_base + PCI_BASE_ADDRESS_0);
+	writel(SZ_4K - 1, pp->dbi_base + PCI_BASE_ADDRESS_0);
+
+	ks_pcie_clear_dbi_mode(ks_pcie->va_reg_app);
+
+	 /*
+	  * For BAR0, just setting bus address for inbound writes (MSI) should
+	  * be sufficient. Use physical address to avoid any conflicts.
+	  */
+	writel(ks_pcie->reg_app.start, pp->dbi_base + PCI_BASE_ADDRESS_0);
+}
+
+static u32 ks_get_msi_data(struct pcie_port *pp)
+{
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	return ks_pcie->reg_app.start + MSI_IRQ;
+}
+
+static struct pcie_host_ops keystone_pcie_host_ops = {
+	.rd_other_conf = ks_pcie_rd_other_conf,
+	.wr_other_conf = ks_pcie_wr_other_conf,
+	.link_up = ks_pcie_link_up,
+	.host_init = ks_pcie_host_init,
+	.get_msi_data = ks_get_msi_data,
+};
+
+struct pci_bus *ks_pcie_scan_bus(int nr, struct pci_sys_data *sys)
+{
+	struct pcie_port *pp = sys_to_pcie(sys);
+	struct pci_bus *bus;
+
+	bus = dw_pcie_scan_bus(nr, sys);
+	if (bus)
+		ks_pcie_set_inbound_trans(pp);
+	return bus;
+}
+
+static int ks_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct pcie_port *pp = sys_to_pcie(dev->bus->sysdata);
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+
+	dev_info(pp->dev, "ks_pcie_map_irq: pin %d\n", pin);
+
+	if (!pin || pin > ks_pcie->num_legacy_host_irqs) {
+		dev_err(pp->dev, "pci irq pin out of range\n");
+		return -1;
+	}
+
+	/* pin has values from 1-4 */
+	return (ks_pcie->virqs[pin - 1] >= 0) ?
+		ks_pcie->virqs[pin - 1] : -1;
+}
+
+static struct hw_pci keystone_pcie_hw = {
+	.nr_controllers	= 1,
+	.setup		= dw_pcie_setup,
+	.scan		= ks_pcie_scan_bus,
+	.swizzle        = pci_common_swizzle,
+	.add_bus	= dw_pcie_add_bus,
+	.map_irq	= ks_pcie_map_irq,
+};
+
+static void ack_irq(struct irq_data *d)
+{
+}
+
+static void mask_irq(struct irq_data *d)
+{
+}
+
+static void unmask_irq(struct irq_data *d)
+{
+}
+
+static struct irq_chip ks_pcie_legacy_irq_chip = {
+	.name = "PCIe-LEGACY-IRQ",
+	.irq_ack = ack_irq,
+	.irq_mask = mask_irq,
+	.irq_unmask = unmask_irq,
+};
+
+static int add_pcie_port(struct keystone_pcie *ks_pcie,
+			 struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct pcie_port *pp = &ks_pcie->pp;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int ret, i;
+
+	/*
+	 * support upto MAX_LEGACY_HOST_IRQS host and legacy IRQs.
+	 * In dt from index 0 to 3
+	 */
+	for (i = 0; i < MAX_LEGACY_HOST_IRQS; i++) {
+		ks_pcie->legacy_host_irqs[i] = irq_of_parse_and_map(np, i);
+		if (ks_pcie->legacy_host_irqs[i] < 0)
+			break;
+		ks_pcie->num_legacy_host_irqs++;
+	}
+
+	if (ks_pcie->num_legacy_host_irqs) {
+		ks_pcie->legacy_irqd = irq_domain_add_linear(np,
+					ks_pcie->num_legacy_host_irqs,
+					&irq_domain_simple_ops, NULL);
+
+		if (!ks_pcie->legacy_irqd) {
+			dev_err(dev,
+				"Failed to add irq domain for legacy irqs\n");
+			return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < ks_pcie->num_legacy_host_irqs; i++) {
+		ks_pcie->virqs[i] =
+			irq_create_mapping(ks_pcie->legacy_irqd, i);
+		irq_set_chip_and_handler(ks_pcie->virqs[i],
+			&ks_pcie_legacy_irq_chip, handle_level_irq);
+		irq_set_chip_data(ks_pcie->virqs[i], ks_pcie);
+		set_irq_flags(ks_pcie->virqs[i], IRQF_VALID);
+
+		if (ks_pcie->legacy_host_irqs[i] >= 0) {
+			irq_set_handler_data(ks_pcie->legacy_host_irqs[i],
+				ks_pcie);
+			irq_set_chained_handler(ks_pcie->legacy_host_irqs[i],
+				ks_pcie_legacy_irq_handler);
+		}
+		set_irq_flags(ks_pcie->legacy_host_irqs[i], IRQF_VALID);
+	}
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		/*
+		 * support upto 32 MSI irqs mapped to 8 host IRQs.
+		 * In dt from index 4 to 11
+		 */
+		for (i = 0; i < MAX_MSI_HOST_IRQS; i++) {
+			ks_pcie->msi_host_irqs[i] =
+				irq_of_parse_and_map(np,
+					ks_pcie->num_legacy_host_irqs + i);
+			if (ks_pcie->msi_host_irqs[i] < 0)
+				break;
+			ks_pcie->num_msi_host_irqs++;
+		}
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg_rc_app");
+	if (!res) {
+
+		dev_err(dev, "missing dbics base resource\n");
+		return -EINVAL;
+	}
+	ks_pcie->reg_app = *res;
+	ks_pcie->va_reg_app = devm_ioremap_nocache(dev, res->start,
+					resource_size(res));
+
+	if (!ks_pcie->va_reg_app) {
+		dev_err(dev, "ioremap failed\n");
+		return -ENODEV;
+	}
+
+	pp->root_bus_nr = -1;
+	pp->version = DW_VERSION_PRE_3_70;
+	pp->ops = &keystone_pcie_host_ops;
+	spin_lock_init(&pp->conf_lock);
+	ret = dw_pcie_host_init(pp, &keystone_pcie_hw, &msi_domain_ops);
+	if (ret) {
+		dev_err(dev, "failed to initialize host\n");
+		return ret;
+	}
+	return ret;
+}
+
+static const struct of_device_id ks_pcie_of_match[] = {
+	{
+		.type = "pci",
+		.compatible = "ti,keystone2-pcie",
+		.data =  &keystone2_data,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ks_pcie_of_match);
+
+static int __exit ks_pcie_remove(struct platform_device *pdev)
+{
+	struct keystone_pcie *ks_pcie = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(ks_pcie->clk);
+	return 0;
+}
+
+static int __init ks_pcie_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+	struct keystone_pcie *ks_pcie;
+	struct pcie_port *pp;
+	int ret = 0;
+
+	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
+				GFP_KERNEL);
+	if (!ks_pcie) {
+		dev_err(dev, "no memory for keystone pcie\n");
+		return -ENOMEM;
+	}
+
+	match = of_match_device(of_match_ptr(ks_pcie_of_match), dev);
+	ks_pcie->pdata = match ? match->data : 0;
+	if (ks_pcie->pdata) {
+		if (ks_pcie->pdata->setup)
+			ret = ks_pcie->pdata->setup(pdev);
+		if (ret < 0)
+			return -ENODEV;
+	}
+
+	/* check if we need to enable link training */
+	ks_pcie->en_link_train =
+		(of_get_property(np, "ti,enable-linktrain", NULL) != NULL);
+
+	pp = &ks_pcie->pp;
+	pp->dev = &pdev->dev;
+
+	ks_pcie->clk = devm_clk_get(&pdev->dev, "pcie");
+	if (IS_ERR(ks_pcie->clk)) {
+		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
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
+	platform_set_drvdata(pdev, ks_pcie);
+	return 0;
+
+fail_clk:
+	clk_disable_unprepare(ks_pcie->clk);
+	return ret;
+}
+
+static struct platform_driver ks_pcie_driver = {
+	.remove		= __exit_p(ks_pcie_remove),
+	.driver = {
+		.name	= "keystone-pcie",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ks_pcie_of_match),
+	},
+};
+
+/* Keystone PCIe driver does not allow module unload */
+static int __init ks_pcie_init(void)
+{
+	return platform_driver_probe(&ks_pcie_driver, ks_pcie_probe);
+}
+subsys_initcall(ks_pcie_init);
+
+MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
+MODULE_DESCRIPTION("Keystone PCIe host controller driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pci/host/pcie-ks-pdata.h b/drivers/pci/host/pcie-ks-pdata.h
new file mode 100644
index 0000000..a7626de
--- /dev/null
+++ b/drivers/pci/host/pcie-ks-pdata.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
+ *		http://www.ti.com
+ *
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* platform specific setup for k2 pcie */
+int k2_pcie_platform_setup(struct platform_device *pdev);
+
+/* keystone pcie pdata configurations */
+struct keystone_pcie_pdata {
+	int (*setup)(struct platform_device *pdev);
+};
+
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3a02717..7c3f777 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3461,3 +3461,15 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 
 	return -ENOTTY;
 }
+
+#ifdef CONFIG_PCIE_KEYSTONE
+/*
+ * The KeyStone PCIe controller has maximum read request size of 256 bytes.
+ * Force this configuration for all EP including bridges.
+ */
+static void quirk_limit_readrequest(struct pci_dev *dev)
+{
+	pcie_set_readrq(dev, 256);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
+#endif /* CONFIG_TI_KEYSTONE_PCIE */
-- 
1.7.9.5

