Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaCFGGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:06:32 -0500
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:55562 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751477AbaCFGGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:06:21 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH v4 1/4] pci: APM X-Gene PCIe controller driver
Date: Wed,  5 Mar 2014 22:06:00 -0800
Message-Id: <1394085963-27553-2-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
X-Gene PCIe controller supports maxmum upto 8 lanes and GEN3 speed.
X-Gene SOC supports maximum 5 PCIe ports.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/pci/host/Kconfig     |   10 +
 drivers/pci/host/Makefile    |    1 +
 drivers/pci/host/pci-xgene.c |  739 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 750 insertions(+)
 create mode 100644 drivers/pci/host/pci-xgene.c

diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 47d46c6..19ce97d 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -33,4 +33,14 @@ config PCI_RCAR_GEN2
 	  There are 3 internal PCI controllers available with a single
 	  built-in EHCI/OHCI host controller present on each one.
 
+config PCI_XGENE
+	bool "X-Gene PCIe controller"
+	depends on ARCH_XGENE
+	depends on OF
+	select PCIEPORTBUS
+	help
+	  Say Y here if you want internal PCI support on APM X-Gene SoC.
+	  There are 5 internal PCIe ports available. Each port is GEN3 capable
+	  and have varied lanes from x1 to x8.
+
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 13fb333..34c7c36 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
+obj-$(CONFIG_PCI_XGENE) += pci-xgene.o
diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
new file mode 100644
index 0000000..ca16d1b
--- /dev/null
+++ b/drivers/pci/host/pci-xgene.c
@@ -0,0 +1,739 @@
+/**
+ * APM X-Gene PCIe Driver
+ *
+ * Copyright (c) 2013 Applied Micro Circuits Corporation.
+ *
+ * Author: Tanmay Inamdar <tinamdar@apm.com>.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/clk-private.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/memblock.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_pci.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PCIECORE_LTSSM			0x4c
+#define PCIECORE_CTLANDSTATUS		0x50
+#define INTXSTATUSMASK			0x6c
+#define PIM1_1L				0x80
+#define IBAR2				0x98
+#define IR2MSK				0x9c
+#define PIM2_1L				0xa0
+#define IBAR3L				0xb4
+#define IR3MSKL				0xbc
+#define PIM3_1L				0xc4
+#define OMR1BARL			0x100
+#define OMR2BARL			0x118
+#define OMR3BARL			0x130
+#define CFGBARL				0x154
+#define CFGBARH				0x158
+#define CFGCTL				0x15c
+#define RTDID				0x160
+#define BRIDGE_CFG_0			0x2000
+#define BRIDGE_CFG_1			0x2004
+#define BRIDGE_CFG_4			0x2010
+#define BRIDGE_CFG_32			0x2030
+#define BRIDGE_CFG_14			0x2038
+#define BRIDGE_CTRL_1			0x2204
+#define BRIDGE_CTRL_2			0x2208
+#define BRIDGE_CTRL_5			0x2214
+#define BRIDGE_STATUS_0			0x2600
+#define MEM_RAM_SHUTDOWN                0xd070
+#define BLOCK_MEM_RDY                   0xd074
+
+#define DEVICE_PORT_TYPE_MASK		0x03c00000
+#define PM_FORCE_RP_MODE_MASK		0x00000400
+#define SWITCH_PORT_MODE_MASK		0x00000800
+#define CLASS_CODE_MASK			0xffffff00
+#define LINK_UP_MASK			0x00000100
+#define AER_OPTIONAL_ERROR_EN		0xffc00000
+#define XGENE_PCIE_DEV_CTRL		0x2f0f
+#define AXI_EP_CFG_ACCESS		0x10000
+#define ENABLE_ASPM			0x08000000
+#define XGENE_PORT_TYPE_RC		0x05000000
+#define BLOCK_MEM_RDY_VAL               0xFFFFFFFF
+#define EN_COHERENCY			0xF0000000
+#define EN_REG				0x00000001
+#define OB_LO_IO			0x00000002
+#define XGENE_PCIE_VENDORID		0xE008
+#define XGENE_PCIE_DEVICEID		0xE004
+#define XGENE_PCIE_ECC_TIMEOUT		10 /* ms */
+#define XGENE_LTSSM_DETECT_WAIT		20 /* ms */
+#define XGENE_LTSSM_L0_WAIT		4  /* ms */
+#define SZ_1T				(SZ_1G*1024ULL)
+#define PIPE_PHY_RATE_RD(src)		((0xc000 & (u32)(src)) >> 0xe)
+
+struct xgene_pcie_port {
+	struct device_node	*node;
+	struct device		*dev;
+	struct clk		*clk;
+	void __iomem		*csr_base;
+	void __iomem		*cfg_base;
+	u8			link_up;
+};
+
+static inline u32 pcie_bar_low_val(u32 addr, u32 flags)
+{
+	return (addr & PCI_BASE_ADDRESS_MEM_MASK) | flags;
+}
+
+/* PCIE Configuration Out/In */
+static inline void xgene_pcie_cfg_out32(void __iomem *addr, u32 val)
+{
+	writel(val, addr);
+}
+
+static inline void xgene_pcie_cfg_out16(void __iomem *addr, u16 val)
+{
+	u64 temp_addr = (u64)addr & ~0x3;
+	u32 val32 = readl((void __iomem *)temp_addr);
+
+	switch ((u64) addr & 0x3) {
+	case 2:
+		val32 &= ~0xFFFF0000;
+		val32 |= (u32) val << 16;
+		break;
+	case 0:
+	default:
+		val32 &= ~0xFFFF;
+		val32 |= val;
+		break;
+	}
+	writel(val32, (void __iomem *)temp_addr);
+}
+
+static inline void xgene_pcie_cfg_out8(void __iomem *addr, u8 val)
+{
+	phys_addr_t temp_addr = (u64) addr & ~0x3;
+	u32 val32 = readl((void __iomem *)temp_addr);
+
+	switch ((u64) addr & 0x3) {
+	case 0:
+		val32 &= ~0xFF;
+		val32 |= val;
+		break;
+	case 1:
+		val32 &= ~0xFF00;
+		val32 |= (u32) val << 8;
+		break;
+	case 2:
+		val32 &= ~0xFF0000;
+		val32 |= (u32) val << 16;
+		break;
+	case 3:
+	default:
+		val32 &= ~0xFF000000;
+		val32 |= (u32) val << 24;
+		break;
+	}
+	writel(val32, (void __iomem *)temp_addr);
+}
+
+static inline void xgene_pcie_cfg_in32(void __iomem *addr, u32 *val)
+{
+	*val = readl(addr);
+}
+
+static inline void xgene_pcie_cfg_in16(void __iomem *addr, u16 *val)
+{
+	u64 temp_addr = (u64)addr & ~0x3;
+	u32 val32;
+
+	val32 = readl((void __iomem *)temp_addr);
+
+	switch ((u64)addr & 0x3) {
+	case 2:
+		*val = val32 >> 16;
+		break;
+	case 0:
+	default:
+		*val = val32;
+		break;
+	}
+}
+
+static inline void xgene_pcie_cfg_in8(void __iomem *addr, u8 *val)
+{
+	u64 temp_addr = (u64)addr & ~0x3;
+	u32 val32;
+
+	val32 = readl((void __iomem *)temp_addr);
+
+	switch ((u64)addr & 0x3) {
+	case 3:
+		*val = val32 >> 24;
+		break;
+	case 2:
+		*val = val32 >> 16;
+		break;
+	case 1:
+		*val = val32 >> 8;
+		break;
+	case 0:
+	default:
+		*val = val32;
+		break;
+	}
+}
+
+/* When the address bit [17:16] is 2'b01, the Configuration access will be
+ * treated as Type 1 and it will be forwarded to external PCIe device.
+ */
+static void __iomem *xgene_pcie_get_cfg_base(struct pci_bus *bus)
+{
+	struct xgene_pcie_port *port = bus->sysdata;
+
+	if (bus->number >= (bus->primary + 1))
+		return port->cfg_base + AXI_EP_CFG_ACCESS;
+
+	return port->cfg_base;
+}
+
+/* For Configuration request, RTDID register is used as Bus Number,
+ * Device Number and Function number of the header fields.
+ */
+static void xgene_pcie_set_rtdid_reg(struct pci_bus *bus, uint devfn)
+{
+	struct xgene_pcie_port *port = bus->sysdata;
+	unsigned int b, d, f;
+	u32 rtdid_val = 0;
+
+	b = bus->number;
+	d = PCI_SLOT(devfn);
+	f = PCI_FUNC(devfn);
+
+	if (!pci_is_root_bus(bus))
+		rtdid_val = (b << 8) | (d << 3) | f;
+
+	writel(rtdid_val, port->csr_base + RTDID);
+	/* read the register back to ensure flush */
+	readl(port->csr_base + RTDID);
+}
+
+static int xgene_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
+				  int offset, int len, u32 *val)
+{
+	struct xgene_pcie_port *port = bus->sysdata;
+	void __iomem *addr;
+	u8 val8;
+	u16 val16;
+
+	if ((pci_is_root_bus(bus) && devfn != 0) || !port->link_up)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	xgene_pcie_set_rtdid_reg(bus, devfn);
+	addr = xgene_pcie_get_cfg_base(bus);
+	switch (len) {
+	case 1:
+		xgene_pcie_cfg_in8(addr + offset, &val8);
+		*val = val8;
+		break;
+	case 2:
+		xgene_pcie_cfg_in16(addr + offset, &val16);
+		*val = val16;
+		break;
+	default:
+		xgene_pcie_cfg_in32(addr + offset, val);
+		break;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int xgene_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
+				   int offset, int len, u32 val)
+{
+	struct xgene_pcie_port *port = bus->sysdata;
+	void __iomem *addr;
+
+	if ((pci_is_root_bus(bus) && devfn != 0) || !port->link_up)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	xgene_pcie_set_rtdid_reg(bus, devfn);
+	addr = xgene_pcie_get_cfg_base(bus);
+	switch (len) {
+	case 1:
+		xgene_pcie_cfg_out8(addr + offset, (u8) val);
+		break;
+	case 2:
+		xgene_pcie_cfg_out16(addr + offset, (u16) val);
+		break;
+	default:
+		xgene_pcie_cfg_out32(addr + offset, val);
+		break;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static struct pci_ops xgene_pcie_ops = {
+	.read = xgene_pcie_read_config,
+	.write = xgene_pcie_write_config
+};
+
+static void xgene_pcie_program_core(void __iomem *csr_base)
+{
+	u32 val;
+
+	val = readl(csr_base + BRIDGE_CFG_0);
+	val |= AER_OPTIONAL_ERROR_EN;
+	writel(val, csr_base + BRIDGE_CFG_0);
+	writel(0x0, csr_base + INTXSTATUSMASK);
+	val = readl(csr_base + BRIDGE_CTRL_1);
+	val = (val & ~0xffff) | XGENE_PCIE_DEV_CTRL;
+	writel(val, csr_base + BRIDGE_CTRL_1);
+}
+
+static u64 xgene_pcie_set_ib_mask(void __iomem *csr_base, u32 addr,
+				  u32 flags, u64 size)
+{
+	u64 mask = (~(size - 1) & PCI_BASE_ADDRESS_MEM_MASK) | flags;
+	u32 val32 = 0;
+	u32 val;
+
+	val32 = readl(csr_base + addr);
+	val = (val32 & 0x0000ffff) | (lower_32_bits(mask) << 16);
+	writel(val, csr_base + addr);
+
+	val32 = readl(csr_base + addr + 0x04);
+	val = (val32 & 0xffff0000) | (lower_32_bits(mask) >> 16);
+	writel(val, csr_base + addr + 0x04);
+
+	val32 = readl(csr_base + addr + 0x04);
+	val = (val32 & 0x0000ffff) | (upper_32_bits(mask) << 16);
+	writel(val, csr_base + addr + 0x04);
+
+	val32 = readl(csr_base + addr + 0x08);
+	val = (val32 & 0xffff0000) | (upper_32_bits(mask) >> 16);
+	writel(val, csr_base + addr + 0x08);
+
+	return mask;
+}
+
+static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port,
+				   u32 *lanes, u32 *speed)
+{
+	void __iomem *csr_base = port->csr_base;
+	u32 val32;
+	u64 start_time, time;
+
+	/*
+	 * A component enters the LTSSM Detect state within
+	 * 20ms of the end of fundamental core reset.
+	 */
+	msleep(XGENE_LTSSM_DETECT_WAIT);
+	port->link_up = 0;
+	start_time = jiffies;
+	do {
+		val32 = readl(csr_base + PCIECORE_CTLANDSTATUS);
+		if (val32 & LINK_UP_MASK) {
+			port->link_up = 1;
+			*speed = PIPE_PHY_RATE_RD(val32);
+			val32 = readl(csr_base + BRIDGE_STATUS_0);
+			*lanes = val32 >> 26;
+			break;
+		}
+		msleep(1);
+		time = jiffies_to_msecs(jiffies - start_time);
+	} while (time <= XGENE_LTSSM_L0_WAIT);
+}
+
+static void xgene_pcie_setup_root_complex(struct xgene_pcie_port *port)
+{
+	void __iomem *csr_base = port->csr_base;
+	u32 val;
+
+	val = (XGENE_PCIE_DEVICEID << 16) | XGENE_PCIE_VENDORID;
+	writel(val, csr_base + BRIDGE_CFG_0);
+
+	val = readl(csr_base + BRIDGE_CFG_1);
+	val &= ~CLASS_CODE_MASK;
+	val |= PCI_CLASS_BRIDGE_PCI << 16;
+	writel(val, csr_base + BRIDGE_CFG_1);
+
+	val = readl(csr_base + BRIDGE_CFG_14);
+	val |= SWITCH_PORT_MODE_MASK;
+	val &= ~PM_FORCE_RP_MODE_MASK;
+	writel(val, csr_base + BRIDGE_CFG_14);
+
+	val = readl(csr_base + BRIDGE_CTRL_5);
+	val &= ~DEVICE_PORT_TYPE_MASK;
+	val |= XGENE_PORT_TYPE_RC;
+	writel(val, csr_base + BRIDGE_CTRL_5);
+
+	val = readl(csr_base + BRIDGE_CTRL_2);
+	val |= ENABLE_ASPM;
+	writel(val, csr_base + BRIDGE_CTRL_2);
+
+	val = readl(csr_base + BRIDGE_CFG_32);
+	writel(val | (1 << 19), csr_base + BRIDGE_CFG_32);
+}
+
+/* Return 0 on success */
+static int xgene_pcie_init_ecc(struct xgene_pcie_port *port)
+{
+	void __iomem *csr_base = port->csr_base;
+	u64 start_time, time = 0;
+	u32 val;
+
+	val = readl(csr_base + MEM_RAM_SHUTDOWN);
+	if (!val)
+		return 0;
+	writel(0x0, csr_base + MEM_RAM_SHUTDOWN);
+	start_time = jiffies;
+	do {
+		val = readl(csr_base + BLOCK_MEM_RDY);
+		if (val == BLOCK_MEM_RDY_VAL)
+			break;
+		msleep(1);
+		time = jiffies_to_msecs(jiffies - start_time);
+	} while (time < XGENE_PCIE_ECC_TIMEOUT);
+
+	return time >= XGENE_PCIE_ECC_TIMEOUT;
+}
+
+static int xgene_pcie_init_port(struct xgene_pcie_port *port)
+{
+	int rc;
+
+	port->clk = clk_get(port->dev, NULL);
+	if (IS_ERR_OR_NULL(port->clk)) {
+		dev_err(port->dev, "clock not available\n");
+		return -ENODEV;
+	}
+
+	rc = clk_prepare_enable(port->clk);
+	if (rc) {
+		dev_err(port->dev, "clock enable failed\n");
+		return rc;
+	}
+
+	rc = xgene_pcie_init_ecc(port);
+	if (rc) {
+		dev_err(port->dev, "memory init failed\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
+{
+	int i;
+
+	/* Hide the PCI host BARs from the kernel as their content doesn't
+	 * fit well in the resource management
+	 */
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		dev->resource[i].start = dev->resource[i].end = 0;
+		dev->resource[i].flags = 0;
+	}
+	dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
+		 pci_name(dev));
+}
+DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
+			 xgene_pcie_fixup_bridge);
+
+static int xgene_pcie_map_reg(struct xgene_pcie_port *port,
+			      struct platform_device *pdev, u64 *cfg_addr)
+{
+	struct resource *res;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "csr");
+	port->csr_base = devm_ioremap_resource(port->dev, res);
+	if (IS_ERR(port->csr_base))
+		return PTR_ERR(port->csr_base);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg");
+	port->cfg_base = devm_ioremap_resource(port->dev, res);
+	if (IS_ERR(port->cfg_base))
+		return PTR_ERR(port->cfg_base);
+	*cfg_addr = res->start;
+
+	return 0;
+}
+
+static void xgene_pcie_setup_ob_reg(struct xgene_pcie_port *port,
+				    struct resource *res, u32 offset, u64 addr)
+{
+	void __iomem *base = port->csr_base + offset;
+	resource_size_t size = resource_size(res);
+	u64 restype = resource_type(res);
+	u64 cpu_addr, pci_addr;
+	u64 mask = 0;
+	u32 min_size;
+	u32 flag = EN_REG;
+
+	if (restype == IORESOURCE_MEM) {
+		cpu_addr = res->start;
+		pci_addr = addr;
+		min_size = SZ_128M;
+	} else {
+		cpu_addr = addr;
+		pci_addr = res->start;
+		min_size = 128;
+		flag |= OB_LO_IO;
+	}
+	if (size >= min_size)
+		mask = ~(size - 1) | flag;
+	else
+		dev_warn(port->dev, "res size 0x%llx less than minimum 0x%x\n",
+			 (u64)size, min_size);
+	writel(lower_32_bits(cpu_addr), base);
+	writel(upper_32_bits(cpu_addr), base + 0x04);
+	writel(lower_32_bits(mask), base + 0x08);
+	writel(upper_32_bits(mask), base + 0x0c);
+	writel(lower_32_bits(pci_addr), base + 0x10);
+	writel(upper_32_bits(pci_addr), base + 0x14);
+}
+
+static void xgene_pcie_setup_cfg_reg(void __iomem *csr_base, u64 addr)
+{
+	writel(lower_32_bits(addr), csr_base + CFGBARL);
+	writel(upper_32_bits(addr), csr_base + CFGBARH);
+	writel(EN_REG, csr_base + CFGCTL);
+}
+
+static int xgene_pcie_map_ranges(struct xgene_pcie_port *port,
+				 struct pci_host_bridge *bridge,
+				 u64 cfg_addr)
+{
+	struct device *dev = port->dev;
+	struct pci_host_bridge_window *window;
+
+	list_for_each_entry(window, &bridge->windows, list) {
+		struct resource *res = window->res;
+		u64 restype = resource_type(res);
+		dev_dbg(port->dev, "0x%08lx 0x%016llx...0x%016llx\n",
+			res->flags, res->start, res->end);
+
+		switch (restype) {
+		case IORESOURCE_IO:
+			xgene_pcie_setup_ob_reg(port, res, OMR2BARL,
+						bridge->io_base);
+			BUG_ON(pci_ioremap_io(res, bridge->io_base) < 0);
+			break;
+		case IORESOURCE_MEM:
+			xgene_pcie_setup_ob_reg(port, res, OMR3BARL,
+						res->start - window->offset);
+			break;
+		case IORESOURCE_BUS:
+			break;
+		default:
+			dev_err(dev, "invalid io resource!");
+			return -EINVAL;
+		}
+	}
+	xgene_pcie_setup_cfg_reg(port->csr_base, cfg_addr);
+	return 0;
+}
+
+static void xgene_pcie_setup_pims(void *addr, u64 pim, u64 size)
+{
+	writel(lower_32_bits(pim), addr);
+	writel(upper_32_bits(pim) | EN_COHERENCY, addr + 0x04);
+	writel(lower_32_bits(size), addr + 0x10);
+	writel(upper_32_bits(size), addr + 0x14);
+}
+
+/*
+ * X-Gene PCIe support maximum 3 inbound memory regions
+ * This function helps to select a region based on size of region
+ */
+static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
+{
+	if ((size > 4) && (size < SZ_16M) && !(*ib_reg_mask & (1 << 1))) {
+		*ib_reg_mask |= (1 << 1);
+		return 1;
+	}
+
+	if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
+		*ib_reg_mask |= (1 << 0);
+		return 0;
+	}
+
+	if ((size > SZ_1M) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 2))) {
+		*ib_reg_mask |= (1 << 2);
+		return 2;
+	}
+	return -EINVAL;
+}
+
+static void xgene_pcie_setup_ib_reg(struct xgene_pcie_port *port,
+				    struct of_pci_range *range, u8 *ib_reg_mask)
+{
+	void __iomem *csr_base = port->csr_base;
+	void __iomem *cfg_base = port->cfg_base;
+	void *bar_addr;
+	void *pim_addr;
+	u64 restype = range->flags & IORESOURCE_TYPE_BITS;
+	u64 cpu_addr = range->cpu_addr;
+	u64 pci_addr = range->pci_addr;
+	u64 size = range->size;
+	u64 mask = ~(size - 1) | EN_REG;
+	u32 flags = PCI_BASE_ADDRESS_MEM_TYPE_64;
+	u32 bar_low;
+	int region;
+
+	region = xgene_pcie_select_ib_reg(ib_reg_mask, range->size);
+	if (region < 0) {
+		dev_warn(port->dev, "invalid pcie dma-range config\n");
+		return;
+	}
+
+	if (restype == PCI_BASE_ADDRESS_MEM_PREFETCH)
+		flags |= PCI_BASE_ADDRESS_MEM_PREFETCH;
+
+	bar_low = pcie_bar_low_val((u32)cpu_addr, flags);
+	switch (region) {
+	case 0:
+		xgene_pcie_set_ib_mask(csr_base, BRIDGE_CFG_4, flags, size);
+		bar_addr = cfg_base + PCI_BASE_ADDRESS_0;
+		writel(bar_low, bar_addr);
+		writel(upper_32_bits(cpu_addr), bar_addr + 0x4);
+		pim_addr = csr_base + PIM1_1L;
+		break;
+	case 1:
+		bar_addr = csr_base + IBAR2;
+		writel(bar_low, bar_addr);
+		writel(lower_32_bits(mask), csr_base + IR2MSK);
+		pim_addr = csr_base + PIM2_1L;
+		break;
+	case 2:
+		bar_addr = csr_base + IBAR3L;
+		writel(bar_low, bar_addr);
+		writel(upper_32_bits(cpu_addr), bar_addr + 0x4);
+		writel(lower_32_bits(mask), csr_base + IR3MSKL);
+		writel(upper_32_bits(mask), csr_base + IR3MSKL + 0x4);
+		pim_addr = csr_base + PIM3_1L;
+		break;
+	}
+
+	xgene_pcie_setup_pims(pim_addr, pci_addr, size);
+}
+
+static int pci_dma_range_parser_init(struct of_pci_range_parser *parser,
+				     struct device_node *node)
+{
+	const int na = 3, ns = 2;
+	int rlen;
+
+	parser->node = node;
+	parser->pna = of_n_addr_cells(node);
+	parser->np = parser->pna + na + ns;
+
+	parser->range = of_get_property(node, "dma-ranges", &rlen);
+	if (!parser->range)
+		return -ENOENT;
+
+	parser->end = parser->range + rlen / sizeof(__be32);
+	return 0;
+}
+
+static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie_port *port)
+{
+	struct device_node *np = port->node;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	struct device *dev = port->dev;
+	u8 ib_reg_mask = 0;
+
+	if (pci_dma_range_parser_init(&parser, np)) {
+		dev_err(dev, "missing dma-ranges property\n");
+		return -EINVAL;
+	}
+
+	/* Get the dma-ranges from DT */
+	for_each_of_pci_range(&parser, &range) {
+		u64 end = range.cpu_addr + range.size - 1;
+		dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
+			range.flags, range.cpu_addr, end, range.pci_addr);
+		xgene_pcie_setup_ib_reg(port, &range, &ib_reg_mask);
+	}
+	return 0;
+}
+
+static int __init xgene_pcie_probe_bridge(struct platform_device *pdev)
+{
+	struct device_node *np = of_node_get(pdev->dev.of_node);
+	struct xgene_pcie_port *port;
+	struct pci_host_bridge *bridge;
+	resource_size_t lastbus;
+	u32 lanes = 0, speed = 0;
+	u64 cfg_addr = 0;
+	int ret;
+
+	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+	port->node = np;
+	port->dev = &pdev->dev;
+
+	ret = xgene_pcie_map_reg(port, pdev, &cfg_addr);
+	if (ret)
+		return ret;
+
+	ret = xgene_pcie_init_port(port);
+	if (ret)
+		return ret;
+	xgene_pcie_program_core(port->csr_base);
+	xgene_pcie_setup_root_complex(port);
+
+	bridge = of_create_pci_host_bridge(&pdev->dev, &xgene_pcie_ops, port);
+	if (IS_ERR_OR_NULL(bridge))
+		return PTR_ERR(bridge);
+
+	ret = xgene_pcie_map_ranges(port, bridge, cfg_addr);
+	if (ret)
+		return ret;
+
+	ret = xgene_pcie_parse_map_dma_ranges(port);
+	if (ret)
+		return ret;
+
+	xgene_pcie_poll_linkup(port, &lanes, &speed);
+	if (!port->link_up)
+		dev_info(port->dev, "(rc) link down\n");
+	else
+		dev_info(port->dev, "(rc) x%d gen-%d link up\n",
+				lanes, speed + 1);
+	platform_set_drvdata(pdev, port);
+	lastbus = pci_rescan_bus(bridge->bus);
+	pci_bus_update_busn_res_end(bridge->bus, lastbus);
+	return 0;
+}
+
+static const struct of_device_id xgene_pcie_match_table[] __initconst = {
+	{.compatible = "apm,xgene-pcie",},
+	{},
+};
+
+static struct platform_driver xgene_pcie_driver = {
+	.driver = {
+		   .name = "xgene-pcie",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(xgene_pcie_match_table),
+		  },
+	.probe = xgene_pcie_probe_bridge,
+};
+module_platform_driver(xgene_pcie_driver);
+
+MODULE_AUTHOR("Tanmay Inamdar <tinamdar@apm.com>");
+MODULE_DESCRIPTION("APM X-Gene PCIe driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

