Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaEPUsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:48:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50238 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbaEPUsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:48:05 -0400
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
        Bjorn Helgaas <bhelgaas@google.com>
Subject: RE: [PATCH v1 4/5] pci: dw: add common functions to support old hw
 based pci driver
Thread-Topic: [PATCH v1 4/5] pci: dw: add common functions to support old hw
 based pci driver
Thread-Index: AQHPcFbzWcLuW2DExUK45mZ6zDwrqJtDr06w
Date: Fri, 16 May 2014 20:47:27 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7047421D3@DFLE11.ent.ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <1400169692-9677-5-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1400169692-9677-5-git-send-email-m-karicheri2@ti.com>
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
>Cc: Karicheri, Muralidharan; Shilimkar, Santosh; Mohit Kumar; Jingoo Han; Bjorn Helgaas
>Subject: [PATCH v1 4/5] pci: dw: add common functions to support old hw based pci driver
>
>The older version of DW hw has application space registers for MSI controller and
>inbound/outbound access configuration. Also the legacy interrupt has registers in the
>application space. Drivers such as keystone pci uses these common functions to implement
>the driver.
>These are re-factored from the original driver to separate files to allow re-use for the next
>driver that is based on old dw pci hw such as that found on keystone.
>
>CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>CC: Mohit Kumar <mohit.kumar@st.com>
>CC: Jingoo Han <jg1.han@samsung.com>
>CC: Bjorn Helgaas <bhelgaas@google.com>
>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>---
> drivers/pci/host/Kconfig          |    6 +-
> drivers/pci/host/Makefile         |    1 +
> drivers/pci/host/pci-dw-old-msi.c |  150 +++++++++++++++
> drivers/pci/host/pci-dw-old.c     |  371
>+++++++++++++++++++++++++++++++++++++
> drivers/pci/host/pci-dw-old.h     |   30 +++
> 5 files changed, 557 insertions(+), 1 deletion(-)  create mode 100644 drivers/pci/host/pci-
>dw-old-msi.c  create mode 100644 drivers/pci/host/pci-dw-old.c  create mode 100644
>drivers/pci/host/pci-dw-old.h
>
>diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig index a6f67ec..c4f4732
>100644
>--- a/drivers/pci/host/Kconfig
>+++ b/drivers/pci/host/Kconfig
>@@ -9,6 +9,11 @@ config PCI_MVEBU
> config PCIE_DW
> 	bool
>
>+config PCI_DW_OLD
>+	bool "Designware Old PCIe h/w"
>+	help
>+	   Say Y here if the DW h/w is old version (3.65)
>+
> config PCI_EXYNOS
> 	bool "Samsung Exynos PCIe controller"
> 	depends on SOC_EXYNOS5440
>@@ -32,5 +37,4 @@ config PCI_RCAR_GEN2
> 	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
> 	  There are 3 internal PCI controllers available with a single
> 	  built-in EHCI/OHCI host controller present on each one.
>-
> endmenu
>diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile index 13fb333..be5d939
>100644
>--- a/drivers/pci/host/Makefile
>+++ b/drivers/pci/host/Makefile
>@@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
> obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
> obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
> obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
>+obj-$(CONFIG_PCI_DW_OLD) += pci-dw-old-msi.o pci-dw-old.o
>diff --git a/drivers/pci/host/pci-dw-old-msi.c b/drivers/pci/host/pci-dw-old-msi.c
>new file mode 100644
>index 0000000..450bb2f
>--- /dev/null
>+++ b/drivers/pci/host/pci-dw-old-msi.c
>@@ -0,0 +1,150 @@
>+/*
>+ * Designware(dw) old MSI controller (v3.65 or similar)
>+ *
>+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
>+ *		http://www.ti.com
>+ *
>+ * Author: Murali Karicheri <m-karicheri2@ti.com>
>+ *
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+
>+#include <linux/of_irq.h>
>+#include <linux/kernel.h>
>+#include <linux/msi.h>
>+#include <linux/pci.h>
>+
>+#include "pcie-designware.h"
>+#include "pci-dw-old.h"
>+
>+#define MSI_IRQ				0x054
>+#define MSI0_IRQ_STATUS			0x104
>+#define MSI0_IRQ_ENABLE_SET		0x108
>+#define MSI0_IRQ_ENABLE_CLR		0x10c
>+#define IRQ_STATUS			0x184
>+#define IRQ_EOI                         0x050
>+#define MSI_IRQ_OFFSET			4
>+
>+static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys) {
>+	return sys->private_data;
>+}
>+
>+static inline void update_reg_offset_bit_pos(u32 offset, u32 *reg_offset,
>+					u32 *bit_pos)
>+{
>+	*reg_offset = offset % 8;
>+	*bit_pos = offset >> 3;
>+}
>+
>+inline u32 dw_old_get_msi_data(struct pcie_port *pp) {
>+	return pp->app_base + MSI_IRQ;
>+}
>+
>+void dw_old_handle_msi_irq(struct pcie_port *pp, int offset) {
>+	u32 pending, vector;
>+	int src, virq;
>+
>+	pending = readl(pp->va_app_base + MSI0_IRQ_STATUS + (offset << 4));
>+	/*
>+	 * MSI0, Status bit 0-3 shows vectors 0, 8, 16, 24, MSI1 status bit
>+	 * shows 1, 9, 17, 25 and so forth
>+	 */
>+	for (src = 0; src < 4; src++) {
>+		if (BIT(src) & pending) {
>+			vector = offset + (src << 3);
>+			virq = irq_linear_revmap(pp->irq_domain, vector);
>+			dev_dbg(pp->dev,
>+				"irq: bit %d, vector %d, virq %d\n",
>+				 src, vector, virq);
>+			generic_handle_irq(virq);
>+		}
>+	}
>+}
>+
>+static void dw_old_msi_irq_ack(struct irq_data *d) {
>+	u32 offset, reg_offset, bit_pos;
>+	unsigned int irq = d->irq;
>+	struct msi_desc *msi;
>+	struct pcie_port *pp;
>+
>+	msi = irq_get_msi_desc(irq);
>+	pp = sys_to_pcie(msi->dev->bus->sysdata);
>+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
>+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
>+
>+	writel(BIT(bit_pos),
>+		pp->va_app_base + MSI0_IRQ_STATUS + (reg_offset << 4));
>+	writel(reg_offset + MSI_IRQ_OFFSET, pp->va_app_base + IRQ_EOI); }
>+
>+static void dw_old_msi_irq_mask(struct irq_data *d) {
>+	u32 offset, reg_offset, bit_pos;
>+	unsigned int irq = d->irq;
>+	struct msi_desc *msi;
>+	struct pcie_port *pp;
>+
>+	msi = irq_get_msi_desc(irq);
>+	pp = sys_to_pcie(msi->dev->bus->sysdata);
>+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
>+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
>+
>+	/* mask the end point if PVM implemented */
>+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>+		if (msi->msi_attrib.maskbit)
>+			mask_msi_irq(d);
>+	}
>+
>+	writel(BIT(bit_pos),
>+		pp->va_app_base + MSI0_IRQ_ENABLE_CLR + (reg_offset << 4)); }
>+
>+static void dw_old_msi_irq_unmask(struct irq_data *d) {
>+	u32 offset, reg_offset, bit_pos;
>+	unsigned int irq = d->irq;
>+	struct msi_desc *msi;
>+	struct pcie_port *pp;
>+
>+	msi = irq_get_msi_desc(irq);
>+	pp = sys_to_pcie(msi->dev->bus->sysdata);
>+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
>+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
>+
>+	/* mask the end point if PVM implemented */
>+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>+		if (msi->msi_attrib.maskbit)
>+			unmask_msi_irq(d);
>+	}
>+
>+	writel(BIT(bit_pos),
>+		pp->va_app_base + MSI0_IRQ_ENABLE_SET + (reg_offset << 4)); }
>+
>+static struct irq_chip dw_old_msi_chip = {
>+	.name = "PCI-DW-MSI-OLD",
>+	.irq_ack = dw_old_msi_irq_ack,
>+	.irq_mask = dw_old_msi_irq_mask,
>+	.irq_unmask = dw_old_msi_irq_unmask,
>+};
>+
>+static int dw_old_msi_map(struct irq_domain *domain, unsigned int irq,
>+			irq_hw_number_t hwirq)
>+{
>+	irq_set_chip_and_handler(irq, &dw_old_msi_chip, handle_level_irq);
>+	irq_set_chip_data(irq, domain->host_data);
>+	set_irq_flags(irq, IRQF_VALID);
>+
>+	return 0;
>+}
>+
>+const struct irq_domain_ops dw_old_msi_domain_ops = {
>+	.map = dw_old_msi_map,
>+};
>diff --git a/drivers/pci/host/pci-dw-old.c b/drivers/pci/host/pci-dw-old.c new file mode
>100644 index 0000000..b805013
>--- /dev/null
>+++ b/drivers/pci/host/pci-dw-old.c
>@@ -0,0 +1,371 @@
>+/*
>+ * Designware(dw) old common functions (v3.65 or similar)
>+ *
>+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
>+ *		http://www.ti.com
>+ *
>+ * Author: Murali Karicheri <m-karicheri2@ti.com>
>+ *
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+
>+#include <linux/irq.h>
>+#include <linux/irqdomain.h>
>+#include <linux/module.h>
>+#include <linux/of_pci.h>
>+#include <linux/pci.h>
>+
>+#include "pcie-designware.h"
>+#include "pci-dw-old.h"
>+
>+/* Application register defines */
>+#define LTSSM_EN_VAL		        BIT(0)
>+#define LTSSM_STATE_MASK	        0x1f
>+#define LTSSM_STATE_L0		        0x11
>+#define DIR_SPD				(1 << 17)
>+#define DBI_CS2_EN_VAL		        BIT(5)
>+#define OB_XLAT_EN_VAL		        BIT(1)
>+
>+/* Application registers */
>+#define CMD_STATUS			0x004
>+#define CFG_SETUP			0x008
>+#define OB_SIZE				0x030
>+#define CFG_PCIM_WIN_SZ_IDX	        3
>+#define CFG_PCIM_WIN_CNT	        32
>+#define SPACE0_REMOTE_CFG_OFFSET	0x1000
>+#define OB_OFFSET_INDEX(n)		(0x200 + (8 * n))
>+#define OB_OFFSET_HI(n)			(0x204 + (8 * n))
>+#define IRQ_EOI                         0x050
>+#define IRQ_STATUS			0x184
>+#define IRQ_ENABLE_SET			0x188
>+#define IRQ_ENABLE_CLR			0x18c
>+
>+/* Config space registers */
>+#define DEBUG0			        0x728
>+#define PL_GEN2			        0x80c
>+
>+static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys) {
>+	return sys->private_data;
>+}
>+
>+void dw_old_enable_legacy_irqs(struct pcie_port *pp) {
>+	int i;
>+
>+	for (i = 0; i < MAX_LEGACY_IRQS; i++)
>+		writel(0x1, pp->va_app_base + IRQ_ENABLE_SET + (i << 4)); }
>+
>+void dw_old_handle_legacy_irq(struct pcie_port *pp, int offset) {
>+	u32 pending;
>+	int virq;
>+
>+	pending = readl(pp->va_app_base + IRQ_STATUS + (offset << 4));
>+
>+	if (BIT(0) & pending) {
>+		virq = irq_linear_revmap(pp->legacy_irq_domain, offset);
>+		dev_dbg(pp->dev,
>+			": irq: irq_offset %d, virq %d\n", offset, virq);
>+		generic_handle_irq(virq);
>+	}
>+
>+	/* EOI the INTx interrupt */
>+	writel(offset, pp->va_app_base + IRQ_EOI); }
>+
>+static void dw_old_ack_irq(struct irq_data *d) { }
>+
>+static void dw_old_mask_irq(struct irq_data *d) { }
>+
>+static void dw_old_unmask_irq(struct irq_data *d) { }
>+
>+struct irq_chip dw_old_legacy_irq_chip = {
>+	.name = "PCI-DW-LEGACY-old-irq",
>+	.irq_ack = dw_old_ack_irq,
>+	.irq_mask = dw_old_mask_irq,
>+	.irq_unmask = dw_old_unmask_irq,
>+};
>+
>+static int dw_old_init_legacy_irq_map(struct irq_domain *d, unsigned int irq,
>+				      irq_hw_number_t hw)
>+{
>+	irq_set_chip_and_handler(irq, &dw_old_legacy_irq_chip,
>+				handle_level_irq);
>+	irq_set_chip_data(irq, d->host_data);
>+	set_irq_flags(irq, IRQF_VALID);
>+
>+	return 0;
>+}
>+
>+static const struct irq_domain_ops dw_old_legacy_irq_domian_ops = {
>+	.map = dw_old_init_legacy_irq_map,
>+	.xlate = irq_domain_xlate_onetwocell,
>+};
>+
>+/**
>+ * dw_old_set_outbound_trans() - Set PHYADDR <-> BUSADDR
>+ * mapping for outbound
>+ */
>+void dw_old_setup_ob_regs(struct pcie_port *pp) {
>+	u32 start = pp->mem.start, end = pp->mem.end;
>+	int i, tr_size;
>+
>+	dev_dbg(pp->dev, "Setting outbound translation for %#x-%#x\n",
>+		start, end);
>+
>+	/* Set outbound translation size per window division */
>+	writel(CFG_PCIM_WIN_SZ_IDX & 0x7, pp->va_app_base + OB_SIZE);
>+
>+	tr_size = (1 << (CFG_PCIM_WIN_SZ_IDX & 0x7)) * SZ_1M;
>+
>+	/* Using Direct 1:1 mapping of RC <-> PCI memory space */
>+	for (i = 0; (i < CFG_PCIM_WIN_CNT) && (start < end); i++) {
>+		writel(start | 1, pp->va_app_base + OB_OFFSET_INDEX(i));
>+		writel(0, pp->va_app_base + OB_OFFSET_HI(i));
>+		start += tr_size;
>+	}
>+
>+	/* Enable OB translation */
>+	writel(OB_XLAT_EN_VAL | readl(pp->va_app_base + CMD_STATUS),
>+		pp->va_app_base + CMD_STATUS);
>+}
>+
>+/**
>+ * dw_old_set_dbi_mode() - Set DBI mode to access overlaid BAR mask
>+registers
>+ *
>+ * Since modification of dbi_cs2 involves different clock domain, read
>+the
>+ * status back to ensure the transition is complete.
>+ */
>+static inline void dw_old_set_dbi_mode(void __iomem *reg_virt) {
>+	u32 val;
>+
>+	writel(DBI_CS2_EN_VAL | readl(reg_virt + CMD_STATUS),
>+		     reg_virt + CMD_STATUS);
>+
>+	do {
>+		val = readl(reg_virt + CMD_STATUS);
>+	} while (!(val & DBI_CS2_EN_VAL));
>+}
>+
>+/**
>+ * dw_old_clear_dbi_mode() - Disable DBI mode
>+ *
>+ * Since modification of dbi_cs2 involves different clock domain, read
>+the
>+ * status back to ensure the transition is complete.
>+ */
>+static inline void dw_old_clear_dbi_mode(void __iomem *reg_virt) {
>+	u32 val;
>+
>+	writel(~DBI_CS2_EN_VAL & readl(reg_virt + CMD_STATUS),
>+		     reg_virt + CMD_STATUS);
>+
>+	do {
>+		val = readl(reg_virt + CMD_STATUS);
>+	} while (val & DBI_CS2_EN_VAL);
>+}
>+
>+void dw_old_disable_bars(struct pcie_port *pp) {
>+	dw_old_set_dbi_mode(pp->va_app_base);
>+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_0);
>+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_1);
>+	dw_old_clear_dbi_mode(pp->va_app_base);
>+}
>+
>+/**
>+ * dw_old_setup_config_addr() - Set up configuration space address for
>+a
>+ * device
>+ *
>+ * @pp: ptr to pcie_port structure
>+ * @bus: Bus number the device is residing on
>+ * @device: Device number
>+ * @function: Function number in device
>+ *
>+ * Forms and returns the address of configuration space mapped in
>+PCIESS
>+ * address space 0. Also configures CFG_SETUP for remote configuration
>+space
>+ * access.
>+ *
>+ * The address space has two regions to access configuration - local and remote.
>+ * We access local region for bus 0 (as RC is attached on bus 0) and
>+remote
>+ * region for others with TYPE 1 access when bus > 1. As for device on
>+bus = 1,
>+ * we will do TYPE 0 access as it will be on our secondary bus (logical).
>+ * CFG_SETUP is needed only for remote configuration access.
>+ */
>+static inline void __iomem *
>+dw_old_setup_config_addr(struct pcie_port *pp, u8 bus, u8 device, u8
>+function) {
>+	u32 regval;
>+
>+	if (bus == 0)
>+		return pp->dbi_base;
>+
>+	regval = (bus << 16) | (device << 8) | function;
>+	/*
>+	 * Since Bus#1 will be a virtual bus, we need to have TYPE0
>+	 * access only.
>+	 * TYPE 1
>+	 */
>+	if (bus != 1)
>+		regval |= BIT(24);
>+
>+	writel(regval, pp->va_app_base + CFG_SETUP);
>+
>+	return pp->dbi_base + SPACE0_REMOTE_CFG_OFFSET; }
>+
>+int dw_old_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
>+		unsigned int devfn, int where, int size, u32 *val) {
>+	u8 bus_num = bus->number;
>+	void __iomem *addr;
>+	int ret;
>+
>+	addr = dw_old_setup_config_addr(pp, bus_num, PCI_SLOT(devfn),
>+				 PCI_FUNC(devfn));
>+
>+	ret = dw_pcie_cfg_read(addr + (where & ~0x3), where, size, val);
>+
>+	return ret;
>+}
>+
>+int dw_old_wr_other_conf(struct pcie_port *pp,
>+		struct pci_bus *bus, unsigned int devfn, int where,
>+		int size, u32 val)
>+{
>+	u8 bus_num = bus->number;
>+	void __iomem *addr;
>+
>+	addr = dw_old_setup_config_addr(pp, bus_num, PCI_SLOT(devfn),
>+				PCI_FUNC(devfn));
>+	return dw_pcie_cfg_write(addr + (where & ~0x3), where, size, val); }
>+
>+/**
>+ * dw_old_set_ib_access() - Setup inbound access
>+ *
>+ * Configure BAR0 for inbound access. BAR0 is set up in h/w to have
>+ * access to PCIESS application register space and just needs to set up
>+ * inbound address (mainly used for MSI).
>+ */
>+static void dw_old_set_ib_access(struct pcie_port *pp) {
>+	/* Configure and set up BAR0 */
>+	dw_old_set_dbi_mode(pp->va_app_base);
>+
>+	/* Enable BAR0 */
>+	writel(1, pp->dbi_base + PCI_BASE_ADDRESS_0);
>+	writel(SZ_4K - 1, pp->dbi_base + PCI_BASE_ADDRESS_0);
>+
>+	dw_old_clear_dbi_mode(pp->va_app_base);
>+	 /*
>+	  * For BAR0, just setting bus address for inbound writes (MSI) should
>+	  * be sufficient. Use physical address to avoid any conflicts.
>+	  */
>+	writel(pp->app_base, pp->dbi_base + PCI_BASE_ADDRESS_0); }
>+
>+/**
>+ * dw_old_pcie_scan_bus() - common function to scan bus
>+ *
>+ * common functin to scan old dw based pci bus. This also sets inbound
>+access
>+ * after scan.
>+ */
>+static struct pci_bus *dw_old_pcie_scan_bus(int nr, struct pci_sys_data
>+*sys) {
>+	struct pcie_port *pp = sys_to_pcie(sys);
>+	struct pci_bus *bus;
>+
>+	bus = dw_pcie_scan_bus(nr, sys);
>+	if (bus)
>+		dw_old_set_ib_access(pp);
>+
>+	return bus;
>+}
>+
>+/**
>+ * dw_old_pcie_link_up() - Check if link up
>+ *
>+ * optionally enable link train using link_train option and check if link is up.
>+ */
>+int dw_old_pcie_link_up(struct pcie_port *pp, int link_train) {
>+	u32 val;
>+
>+	if (link_train) {
>+		/*
>+		 * KeyStone devices do not support h/w autonomous
>+		 * link up-training to GEN2 from GEN1 in either EP/RC modes.
>+		 * The software needs to initiate speed change.
>+		 */
>+		val = readl(pp->dbi_base + PL_GEN2);
>+		writel(val | DIR_SPD, pp->dbi_base + PL_GEN2);
>+		/*
>+		 * Initiate Link Training. We will delay for L0 as specified by
>+		 * standard, but will still proceed and return success
>+		 * irrespective of L0 status as this will be handled by explicit
>+		 * L0 state checks during enumeration.
>+		 */
>+		val = readl(pp->va_app_base + CMD_STATUS);
>+		writel(LTSSM_EN_VAL | val,  pp->va_app_base + CMD_STATUS);
>+
>+	}
>+
>+	val = readl(pp->dbi_base + DEBUG0);
>+
>+	return (val & LTSSM_STATE_MASK) == LTSSM_STATE_L0; }
>+
>+static struct hw_pci dw_old_pcie_hw = {
>+	.nr_controllers	= 1,
>+	.setup		= dw_pcie_setup,
>+	.scan		= dw_old_pcie_scan_bus,
>+	.swizzle        = pci_common_swizzle,
>+	.add_bus	= dw_pcie_add_bus,
>+	.map_irq	= of_irq_parse_and_map_pci,
>+};
>+
>+
>+/**
>+ * dw_old_pcie_host_init() - initialize host for old dw hardware
>+ *
>+ * Parse the pcie resources from DT bindings and then call common
>+ * dw function to do host initialization.
>+ */
>+int __init dw_old_pcie_host_init(struct pcie_port *pp, struct
>+device_node *np) {
>+	int ret;
>+
>+	if (!pp->va_app_base)
>+		return -EINVAL;
>+
>+	/* create legacy domain */
>+	pp->legacy_irq_domain = irq_domain_add_linear(np,
>+				MAX_LEGACY_IRQS,
>+				&dw_old_legacy_irq_domian_ops, NULL);
>+
>+	if (!pp->legacy_irq_domain) {
>+		dev_err(pp->dev, "Failed to add irq domain for legacy irqs\n");
>+		return -EINVAL;
>+	}
>+
>+	ret = dw_pcie_parse_resource(pp);
>+	if (ret)
>+		return ret;
>+
>+	return dw_pcie_common_host_init(pp, &dw_old_pcie_hw,
>+					&dw_old_msi_domain_ops);
>+}
>diff --git a/drivers/pci/host/pci-dw-old.h b/drivers/pci/host/pci-dw-old.h new file mode
>100644 index 0000000..6e1af50
>--- /dev/null
>+++ b/drivers/pci/host/pci-dw-old.h
>@@ -0,0 +1,30 @@
>+/*
>+ * Designware(dw) old MSI controller (v3.65 or similar) common includes
>+ *
>+ * Copyright (C) 2013-2014 Texas Instruments., Ltd.
>+ *		http://www.ti.com
>+ *
>+ * Author: Murali Karicheri <m-karicheri2@ti.com>
>+ *
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+
>+#define MAX_LEGACY_IRQS		4
>+
>+extern const struct irq_domain_ops dw_old_msi_domain_ops;
>+
>+void dw_old_handle_msi_irq(struct pcie_port *pp, int offset);
>+u32 dw_old_get_msi_data(struct pcie_port *pp); void
>+dw_old_enable_legacy_irqs(struct pcie_port *pp); void
>+dw_old_handle_legacy_irq(struct pcie_port *pp, int offset); int
>+dw_old_pcie_host_init(struct pcie_port *pp, struct device_node *np);
>+int dw_old_wr_other_conf(struct pcie_port *pp, struct pci_bus *bus,
>+		unsigned int devfn, int where, int size, u32 val); int
>+dw_old_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
>+		unsigned int devfn, int where, int size, u32 *val); void
>+dw_old_disable_bars(struct pcie_port *pp); void
>+dw_old_setup_ob_regs(struct pcie_port *pp); int
>+dw_old_pcie_link_up(struct pcie_port *pp, int link_train);
>--
>1.7.9.5

