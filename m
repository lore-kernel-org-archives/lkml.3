Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaANXew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:34:52 -0500
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:57410 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751958AbaANXeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:34:44 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [RFC PATCH V2 1/4] pci: APM X-Gene PCIe controller driver
Date: Tue, 14 Jan 2014 15:34:15 -0800
Message-Id: <1389742458-7693-2-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
X-Gene PCIe controller supports maxmum upto 8 lanes and GEN3 speed.
X-Gene has maximum 5 PCIe ports supported.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/pci/host/Kconfig     |   10 +
 drivers/pci/host/Makefile    |    1 +
 drivers/pci/host/pci-xgene.c |  934 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 945 insertions(+)
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
index 0000000..54b2d4f
--- /dev/null
+++ b/drivers/pci/host/pci-xgene.c
@@ -0,0 +1,934 @@
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
+#include <asm/pcibios.h>
+
+#define PCIECORE_LTSSM			0x4c
+#define PCIECORE_CTLANDSTATUS		0x50
+#define PIPE_PHY_RATE_RD(src)		((0xc000 & (u32)(src)) >> 0xe)
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
+#define CFGBARL				0x154
+#define CFGBARH				0x158
+#define CFGCTL				0x15c
+#define RTDID				0x160
+#define BRIDGE_CFG_0			0x2000
+#define BRIDGE_CFG_1			0x2004
+#define BRIDGE_CFG_4			0x2010
+#define BRIDGE_CFG_32			0x2030
+#define BRIDGE_CFG_14			0x2038
+#define BRIDGE_8G_CFG_0			0x2100
+#define BRIDGE_8G_CFG_4			0x2110
+#define BRIDGE_8G_CFG_8			0x2120
+#define BRIDGE_8G_CFG_9			0x2124
+#define BRIDGE_8G_CFG_10		0x2128
+#define BRIDGE_8G_CFG_11		0x212c
+#define BRIDGE_CTRL_1			0x2204
+#define BRIDGE_CTRL_2			0x2208
+#define BRIDGE_CTRL_5			0x2214
+#define BRIDGE_STATUS_0			0x2600
+#define MEM_RAM_SHUTDOWN                0xd070
+#define BLOCK_MEM_RDY                   0xd074
+
+#define PCI_PRIMARY_BUS_MASK		0x00ffffff
+#define REVISION_ID_MASK		0x000000ff
+#define SLOT_IMPLEMENTED_MASK		0x04000000
+#define DEVICE_PORT_TYPE_MASK		0x03c00000
+#define ADVT_INFINITE_CREDITS		0x00000200
+#define PM_FORCE_RP_MODE_MASK		0x00000400
+#define SWITCH_PORT_MODE_MASK		0x00000800
+#define CLASS_CODE_MASK			0xffffff00
+#define LINK_UP_MASK			0x00000100
+#define AER_OPTIONAL_ERROR_EN		0xffc00000
+#define DWNSTRM_EQ_SKP_PHS_2_3		0x00010000
+#define DIRECT_TO_5GTS_MASK		0x00020000
+#define SUPPORT_5GTS_MASK		0x00010000
+#define DIRECT_TO_8GTS_MASK		0x00008000
+#define SUPPORT_8GTS_MASK		0x00004000
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
+#define XGENE_PCIE_TIMEOUT		(500*1000) /* us */
+#define XGENE_LTSSM_DETECT_WAIT		20
+#define XGENE_LTSSM_L0_WAIT		4
+#define XGENE_PCIE_MAX_PORTS		5
+#define SZ_1T				(SZ_1G*1024ULL)
+
+struct xgene_res_cfg {
+	struct resource		res;
+	u64			pci_addr;
+};
+
+struct xgene_pcie_port {
+	struct device_node		*node;
+	struct xgene_res_cfg		mem;
+	struct xgene_res_cfg		io;
+	u8				link_up;
+	u8				link_speed;
+	u32				first_busno;
+	void				*csr_base;
+	void				*cfg_base;
+	u64				cfg_addr;
+	struct device			*dev;
+	struct clk			*clk;
+};
+
+static inline u32 pcie_bar_low_val(u32 addr, u32 flags)
+{
+	return (addr & PCI_BASE_ADDRESS_MEM_MASK) | flags;
+}
+
+static inline u32 eq_pre_cursor_lane0_set(u32 dst, u32 src)
+{
+	return (dst & ~0xff) | (src & 0xff);
+}
+
+static inline u32 eq_pre_cursor_lane1_set(u32 dst, u32 src)
+{
+	return (dst & ~0xff0000) | ((src << 0x10) & 0xff0000);
+}
+
+static inline struct xgene_pcie_port *
+xgene_pcie_sys_to_port(struct pci_sys_data *sys)
+{
+	return sys->private_data;
+}
+
+static inline struct xgene_pcie_port *
+xgene_pcie_bus_to_port(struct pci_bus *bus)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	return xgene_pcie_sys_to_port(sys);
+}
+
+/* PCIE Configuration Out/In */
+static inline void xgene_pcie_cfg_out32(void *addr, u32 val)
+{
+	writel(val, addr);
+}
+
+static inline void xgene_pcie_cfg_out16(void *addr, u16 val)
+{
+	u64 temp_addr = (u64) addr & ~0x3;
+	u32 val32 = readl((void *)temp_addr);
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
+	writel(val32, (void *)temp_addr);
+}
+
+static inline void xgene_pcie_cfg_out8(void *addr, u8 val)
+{
+	phys_addr_t temp_addr = (u64) addr & ~0x3;
+	u32 val32 = readl((void *)temp_addr);
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
+	writel(val32, (void *)temp_addr);
+}
+
+static inline void xgene_pcie_cfg_in32(void *addr, u32 *val)
+{
+	*val = readl(addr);
+}
+
+static inline void xgene_pcie_cfg_in16(void *addr, u16 *val)
+{
+	u64 temp_addr = (u64)addr & ~0x3;
+	u32 val32;
+
+	val32 = readl((void *)temp_addr);
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
+static inline void xgene_pcie_cfg_in8(void *addr, u8 *val)
+{
+	u64 temp_addr = (u64)addr & ~0x3;
+	u32 val32;
+
+	val32 = readl((void *)temp_addr);
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
+	struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
+	u64 addr = (u64)port->cfg_base;
+
+	if (bus->number >= (port->first_busno + 1))
+		addr |= AXI_EP_CFG_ACCESS;
+
+	return (void *)addr;
+}
+
+/* For Configuration request, RTDID register is used as Bus Number,
+ * Device Number and Function number of the header fields.
+ */
+static void xgene_pcie_set_rtdid_reg(struct pci_bus *bus, uint devfn)
+{
+	struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
+	unsigned int b, d, f;
+	u32 rtdid_val = 0;
+
+	b = bus->number;
+	d = PCI_SLOT(devfn);
+	f = PCI_FUNC(devfn);
+
+	if (bus->number == port->first_busno)
+		rtdid_val = (b << 24) | (d << 19) | (f << 16);
+	else if (bus->number >= (port->first_busno + 1))
+		rtdid_val = (port->first_busno << 24) |
+			    (b << 8) | (d << 3) | f;
+
+	writel(rtdid_val, port->csr_base + RTDID);
+	/* read the register back to ensure flush */
+	readl(port->csr_base + RTDID);
+}
+
+static int xgene_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
+				  int offset, int len, u32 *val)
+{
+	struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
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
+	struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
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
+static void xgene_pcie_setup_lanes(struct xgene_pcie_port *port)
+{
+	void *csr_base = port->csr_base;
+	u32 val;
+
+	val = readl(csr_base + BRIDGE_8G_CFG_8);
+	val = eq_pre_cursor_lane0_set(val, 0x7);
+	val = eq_pre_cursor_lane1_set(val, 0x7);
+	writel(val, csr_base + BRIDGE_8G_CFG_8);
+
+	val = readl(csr_base + BRIDGE_8G_CFG_9);
+	val = eq_pre_cursor_lane0_set(val, 0x7);
+	val = eq_pre_cursor_lane1_set(val, 0x7);
+	writel(val, csr_base + BRIDGE_8G_CFG_9);
+
+	val = readl(csr_base + BRIDGE_8G_CFG_10);
+	val = eq_pre_cursor_lane0_set(val, 0x7);
+	val = eq_pre_cursor_lane1_set(val, 0x7);
+	writel(val, csr_base + BRIDGE_8G_CFG_10);
+
+	val = readl(csr_base + BRIDGE_8G_CFG_11);
+	val = eq_pre_cursor_lane0_set(val, 0x7);
+	val = eq_pre_cursor_lane1_set(val, 0x7);
+	writel(val, csr_base + BRIDGE_8G_CFG_11);
+
+	val = readl(csr_base + BRIDGE_8G_CFG_4);
+	val = (val & ~0x30) | (1 << 4);
+	writel(val, csr_base + BRIDGE_8G_CFG_4);
+}
+
+static void xgene_pcie_setup_link(struct xgene_pcie_port *port)
+{
+	void *csr_base = port->csr_base;
+	u32 val;
+
+	val = readl(csr_base + BRIDGE_CFG_14);
+	val |= DIRECT_TO_8GTS_MASK;
+	val |= SUPPORT_5GTS_MASK;
+	val |= SUPPORT_8GTS_MASK;
+	val |= DIRECT_TO_5GTS_MASK;
+	writel(val, csr_base + BRIDGE_CFG_14);
+
+	val = readl(csr_base + BRIDGE_CFG_14);
+	val &= ~ADVT_INFINITE_CREDITS;
+	writel(val, csr_base + BRIDGE_CFG_14);
+
+	val = readl(csr_base + BRIDGE_8G_CFG_0);
+	val |= (val & ~0xf) | 7;
+	val |= (val & ~0xf00) | ((7 << 8) & 0xf00);
+	writel(val, csr_base + BRIDGE_8G_CFG_0);
+
+	val = readl(csr_base + BRIDGE_8G_CFG_0);
+	val |= DWNSTRM_EQ_SKP_PHS_2_3;
+	writel(val, csr_base + BRIDGE_8G_CFG_0);
+}
+
+static void xgene_pcie_program_core(void *csr_base)
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
+static u64 xgene_pcie_set_ib_mask(void *csr_base, u32 addr, u32 flags, u64 size)
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
+static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port, u32 *lanes)
+{
+	void *csr_base = port->csr_base;
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
+			port->link_speed = PIPE_PHY_RATE_RD(val32);
+			val32 = readl(csr_base + BRIDGE_STATUS_0);
+			*lanes = val32 >> 26;
+		}
+		time = jiffies_to_msecs(jiffies - start_time);
+	} while ((!port->link_up) || (time <= XGENE_LTSSM_L0_WAIT));
+}
+
+static void xgene_pcie_setup_root_complex(struct xgene_pcie_port *port)
+{
+	void *csr_base = port->csr_base;
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
+	xgene_pcie_setup_link(port);
+	xgene_pcie_setup_lanes(port);
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
+	void *csr_base = port->csr_base;
+	int timeout = XGENE_PCIE_TIMEOUT;
+	u32 val;
+
+	val = readl(csr_base + MEM_RAM_SHUTDOWN);
+	if (val == 0)
+		return 0;
+	writel(0x0, csr_base + MEM_RAM_SHUTDOWN);
+	do {
+		val = readl(csr_base + BLOCK_MEM_RDY);
+		udelay(1);
+	} while ((val != BLOCK_MEM_RDY_VAL) && timeout--);
+
+	return !(timeout > 0);
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
+struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
+
+	return of_node_get(port->node);
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
+static void xgene_pcie_setup_primary_bus(struct xgene_pcie_port *port,
+					 u32 first_busno, u32 last_busno)
+{
+	u32 val;
+	void *cfg_addr = port->cfg_base;
+
+	val = readl(cfg_addr + PCI_PRIMARY_BUS);
+	val &= ~PCI_PRIMARY_BUS_MASK;
+	val |= (last_busno << 16) | ((first_busno + 1) << 8) | (first_busno);
+	writel(val, cfg_addr + PCI_PRIMARY_BUS);
+}
+
+/*
+ * read configuration values from DTS
+ */
+static int xgene_pcie_read_dts_config(struct xgene_pcie_port *port)
+{
+	struct device_node *np = port->node;
+	struct resource csr_res;
+	struct resource cfg_res;
+
+	/* Get CSR space registers address */
+	if (of_address_to_resource(np, 0, &csr_res))
+		return -EINVAL;
+
+	port->csr_base = devm_ioremap_nocache(port->dev, csr_res.start,
+					      resource_size(&csr_res));
+	if (port->csr_base == NULL)
+		return -ENOMEM;
+
+	/* Get CFG space registers address */
+	if (of_address_to_resource(np, 1, &cfg_res))
+		return -EINVAL;
+
+	port->cfg_addr = cfg_res.start;
+	port->cfg_base = devm_ioremap_nocache(port->dev, cfg_res.start,
+					      resource_size(&cfg_res));
+	if (port->csr_base == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void xgene_pcie_setup_ob_reg(struct xgene_pcie_port *port,
+				    u32 addr, u32 restype)
+{
+	struct resource *res = NULL;
+	void *base = port->csr_base + addr;
+	resource_size_t size;
+	u64 cpu_addr = 0;
+	u64 pci_addr = 0;
+	u64 mask = 0;
+	u32 min_size = 0;
+	u32 flag = EN_REG;
+
+	switch (restype) {
+	case IORESOURCE_MEM:
+		res = &port->mem.res;
+		pci_addr = port->mem.pci_addr;
+		min_size = SZ_128M;
+		break;
+	case IORESOURCE_IO:
+		res = &port->io.res;
+		pci_addr = port->io.pci_addr;
+		min_size = 128;
+		flag |= OB_LO_IO;
+		break;
+	}
+	size = resource_size(res);
+	if (size >= min_size)
+		mask = ~(size - 1) | flag;
+	else
+		dev_warn(port->dev, "res size 0x%llx less than minimum 0x%x\n",
+			 (u64)size, min_size);
+	cpu_addr = res->start;
+	writel(lower_32_bits(cpu_addr), base);
+	writel(upper_32_bits(cpu_addr), base + 0x04);
+	writel(lower_32_bits(mask), base + 0x08);
+	writel(upper_32_bits(mask), base + 0x0c);
+	writel(lower_32_bits(pci_addr), base + 0x10);
+	writel(upper_32_bits(pci_addr), base + 0x14);
+}
+
+static void xgene_pcie_setup_cfg_reg(struct xgene_pcie_port *port)
+{
+	void *csr_base = port->csr_base;
+	u64 addr = port->cfg_addr;
+
+	writel(lower_32_bits(addr), csr_base + CFGBARL);
+	writel(upper_32_bits(addr), csr_base + CFGBARH);
+	writel(EN_REG, csr_base + CFGCTL);
+}
+
+static int xgene_pcie_parse_map_ranges(struct xgene_pcie_port *port)
+{
+	struct device_node *np = port->node;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	struct device *dev = port->dev;
+
+	if (of_pci_range_parser_init(&parser, np)) {
+		dev_err(dev, "missing ranges property\n");
+		return -EINVAL;
+	}
+
+	/* Get the I/O, memory, config ranges from DT */
+	for_each_of_pci_range(&parser, &range) {
+		struct resource *res = NULL;
+		u64 restype = range.flags & IORESOURCE_TYPE_BITS;
+		u64 end = range.cpu_addr + range.size - 1;
+		dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
+			range.flags, range.cpu_addr, end, range.pci_addr);
+
+		switch (restype) {
+		case IORESOURCE_IO:
+			res = &port->io.res;
+			port->io.pci_addr = range.pci_addr;
+			of_pci_range_to_resource(&range, np, res);
+			xgene_pcie_setup_ob_reg(port, OMR1BARL, restype);
+			break;
+		case IORESOURCE_MEM:
+			res = &port->mem.res;
+			port->mem.pci_addr = range.pci_addr;
+			of_pci_range_to_resource(&range, np, res);
+			xgene_pcie_setup_ob_reg(port, OMR2BARL, restype);
+			break;
+		default:
+			dev_err(dev, "invalid io resource!");
+			return -EINVAL;
+		}
+	}
+	xgene_pcie_setup_cfg_reg(port);
+	return 0;
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
+	if (parser->range == NULL)
+		return -ENOENT;
+
+	parser->end = parser->range + rlen / sizeof(__be32);
+
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
+static void xgene_pcie_setup_ib_reg(struct xgene_pcie_port *port,
+				    struct of_pci_range *range, u64 restype,
+				    u32 region)
+{
+	void *csr_base = port->csr_base;
+	void *cfg_base = port->cfg_base;
+	void *bar_addr;
+	void *pim_addr;
+	u64 cpu_addr = range->cpu_addr;
+	u64 pci_addr = range->pci_addr;
+	u64 size = range->size;
+	u64 mask = ~(size - 1) | EN_REG;
+	u32 flags = PCI_BASE_ADDRESS_MEM_TYPE_64;
+	u32 bar_low;
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
+	xgene_pcie_setup_pims(pim_addr, pci_addr, size);
+}
+
+/* X-Gene PCIe support maximum 3 inbound memory regions
+ * This function helps to select a region based on size of region
+ */
+static int xgene_pcie_select_ib_reg(u64 size)
+{
+	static u8 ib_reg_mask;
+
+	if ((size > 4) && (size < SZ_16M) && !(ib_reg_mask & (1 << 1))) {
+		ib_reg_mask |= (1 << 1);
+		return 1;
+	}
+
+	if ((size > SZ_1K) && (size < SZ_1T) && !(ib_reg_mask & (1 << 0))) {
+		ib_reg_mask |= (1 << 0);
+		return 0;
+	}
+
+	if ((size > SZ_1M) && (size < SZ_1T) && !(ib_reg_mask & (1 << 2))) {
+		ib_reg_mask |= (1 << 2);
+		return 2;
+	}
+	return -EINVAL;
+}
+
+static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie_port *port)
+{
+	struct device_node *np = port->node;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	struct device *dev = port->dev;
+	int region;
+
+	if (pci_dma_range_parser_init(&parser, np)) {
+		dev_err(dev, "missing dma-ranges property\n");
+		return -EINVAL;
+	}
+
+	/* Get the dma-ranges from DT */
+	for_each_of_pci_range(&parser, &range) {
+		u64 restype = range.flags & IORESOURCE_TYPE_BITS;
+		u64 end = range.cpu_addr + range.size - 1;
+		dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
+			range.flags, range.cpu_addr, end, range.pci_addr);
+		region = xgene_pcie_select_ib_reg(range.size);
+		if (region == -EINVAL) {
+			dev_warn(port->dev, "invalid pcie dma-range config\n");
+			continue;
+		}
+		xgene_pcie_setup_ib_reg(port, &range, restype, region);
+	}
+	return 0;
+}
+
+static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
+{
+	struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
+
+	if (pp == NULL)
+		return 0;
+
+	sys->mem_offset = pp->mem.res.start - pp->mem.pci_addr;
+	pci_add_resource_offset(&sys->resources, &pp->mem.res,
+				sys->mem_offset);
+	return 1;
+}
+
+static struct pci_bus __init *xgene_pcie_scan_bus(int nr,
+						  struct pci_sys_data *sys)
+{
+	struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
+
+	pp->first_busno = sys->busnr;
+	xgene_pcie_setup_primary_bus(pp, sys->busnr, 0xff);
+	return pci_scan_root_bus(NULL, sys->busnr, &xgene_pcie_ops,
+				 sys, &sys->resources);
+}
+
+static struct hw_pci xgene_pcie_hw __initdata = {
+	.nr_controllers = XGENE_PCIE_MAX_PORTS,
+	.setup = xgene_pcie_setup,
+	.scan = xgene_pcie_scan_bus,
+	.map_irq = of_irq_parse_and_map_pci,
+};
+
+static int __init xgene_pcie_probe_bridge(struct platform_device *pdev)
+{
+	struct device_node *np = of_node_get(pdev->dev.of_node);
+	struct xgene_pcie_port *port;
+	static int index;
+	u32 lanes = 0;
+	int ret;
+
+	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
+	if (port == NULL)
+		return -ENOMEM;
+	port->node = np;
+	port->dev = &pdev->dev;
+
+	ret = xgene_pcie_read_dts_config(port);
+	if (ret)
+		return ret;
+
+	ret = xgene_pcie_init_port(port);
+	if (ret)
+		goto skip;
+	xgene_pcie_program_core(port->csr_base);
+	xgene_pcie_setup_root_complex(port);
+	ret = xgene_pcie_parse_map_ranges(port);
+	if (ret)
+		goto skip;
+	ret = xgene_pcie_parse_map_dma_ranges(port);
+	if (ret)
+		goto skip;
+	xgene_pcie_poll_linkup(port, &lanes);
+skip:
+	if (!port->link_up)
+		dev_info(port->dev, "(rc) link down\n");
+	else
+		dev_info(port->dev, "(rc) x%d gen-%d link up\n",
+				lanes, port->link_speed + 1);
+#ifdef CONFIG_PCI_DOMAINS
+	xgene_pcie_hw.domain++;
+#endif
+	xgene_pcie_hw.private_data[index++] = port;
+	platform_set_drvdata(pdev, port);
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
+};
+
+static int __init xgene_pcie_init(void)
+{
+	void *private;
+	int ret;
+
+	pr_info("X-Gene: PCIe driver\n");
+
+	/* allocate private data to keep xgene_pcie_port information */
+	private = kzalloc((XGENE_PCIE_MAX_PORTS * sizeof(void *)), GFP_KERNEL);
+	if (private == NULL)
+		return -ENOMEM;
+	xgene_pcie_hw.private_data = private;
+	ret = platform_driver_probe(&xgene_pcie_driver,
+				    xgene_pcie_probe_bridge);
+	if (ret)
+		return ret;
+	pci_common_init(&xgene_pcie_hw);
+	return 0;
+}
+
+module_init(xgene_pcie_init);
+
+MODULE_AUTHOR("Tanmay Inamdar <tinamdar@apm.com>");
+MODULE_DESCRIPTION("APM X-Gene PCIe driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

