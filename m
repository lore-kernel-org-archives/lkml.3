Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaFJSwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:52:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54515 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaFJSwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:52:17 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 5/8] PCI: designware: add PCI controller functions for v3.65 DW hw
Date: Tue, 10 Jun 2014 14:51:24 -0400
Message-ID: <1402426287-31157-6-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common PCI controller functions for v3.65 DW hw version. This
provides a function, dw_v3_65_pcie_host_init() to initialize the host.
It check compatibility string dw,snps-pcie-v3.65 that is expected
to be present in the device node of a v3.65 compliant hw and initialize
the controller using other APIs (existing and newly added). Added
new fields in the port struct to support the new hw version.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

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

---
 drivers/pci/host/Makefile          |    2 +-
 drivers/pci/host/pci-dw-v3_65.c    |  390 ++++++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-dw-v3_65.h    |   14 ++
 drivers/pci/host/pcie-designware.h |    1 +
 4 files changed, 406 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pci/host/pci-dw-v3_65.c

diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 28af710..b44a878 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
-obj-$(CONFIG_PCI_DW_V3_65) += pci-dw-v3_65-msi.o
+obj-$(CONFIG_PCI_DW_V3_65) += pci-dw-v3_65-msi.o pci-dw-v3_65.o
diff --git a/drivers/pci/host/pci-dw-v3_65.c b/drivers/pci/host/pci-dw-v3_65.c
new file mode 100644
index 0000000..fde50a1
--- /dev/null
+++ b/drivers/pci/host/pci-dw-v3_65.c
@@ -0,0 +1,390 @@
+/*
+ * Designware(dw) v3.65 common functions
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
+#include "pci-dw-v3_65.h"
+
+/* Application register defines */
+#define LTSSM_EN_VAL		        BIT(0)
+#define LTSSM_STATE_MASK	        0x1f
+#define LTSSM_STATE_L0		        0x11
+#define DIR_SPD				(1 << 17)
+#define DBI_CS2_EN_VAL		        BIT(5)
+#define OB_XLAT_EN_VAL		        BIT(1)
+
+/* Application registers */
+#define CMD_STATUS			0x004
+#define CFG_SETUP			0x008
+#define OB_SIZE				0x030
+#define CFG_PCIM_WIN_SZ_IDX	        3
+#define CFG_PCIM_WIN_CNT	        32
+#define SPACE0_REMOTE_CFG_OFFSET	0x1000
+#define OB_OFFSET_INDEX(n)		(0x200 + (8 * n))
+#define OB_OFFSET_HI(n)			(0x204 + (8 * n))
+#define IRQ_EOI                         0x050
+#define IRQ_STATUS			0x184
+#define IRQ_ENABLE_SET			0x188
+#define IRQ_ENABLE_CLR			0x18c
+
+/* Config space registers */
+#define DEBUG0			        0x728
+#define PL_GEN2			        0x80c
+
+static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
+{
+	return sys->private_data;
+}
+
+void dw_v3_65_enable_legacy_irqs(struct pcie_port *pp)
+{
+	int i;
+
+	for (i = 0; i < MAX_LEGACY_IRQS; i++)
+		writel(0x1, pp->va_app_base + IRQ_ENABLE_SET + (i << 4));
+}
+
+void dw_v3_65_handle_legacy_irq(struct pcie_port *pp, int offset)
+{
+	u32 pending;
+	int virq;
+
+	pending = readl(pp->va_app_base + IRQ_STATUS + (offset << 4));
+
+	if (BIT(0) & pending) {
+		virq = irq_linear_revmap(pp->legacy_irq_domain, offset);
+		dev_dbg(pp->dev,
+			": irq: irq_offset %d, virq %d\n", offset, virq);
+		generic_handle_irq(virq);
+	}
+
+	/* EOI the INTx interrupt */
+	writel(offset, pp->va_app_base + IRQ_EOI);
+}
+
+static void dw_v3_65_ack_irq(struct irq_data *d)
+{
+}
+
+static void dw_v3_65_mask_irq(struct irq_data *d)
+{
+}
+
+static void dw_v3_65_unmask_irq(struct irq_data *d)
+{
+}
+
+static struct irq_chip dw_v3_65_legacy_irq_chip = {
+	.name = "PCI-DW-Legacy-v3.65-irq",
+	.irq_ack = dw_v3_65_ack_irq,
+	.irq_mask = dw_v3_65_mask_irq,
+	.irq_unmask = dw_v3_65_unmask_irq,
+};
+
+static int dw_v3_65_init_legacy_irq_map(struct irq_domain *d, unsigned int irq,
+				      irq_hw_number_t hw_irq)
+{
+	irq_set_chip_and_handler(irq, &dw_v3_65_legacy_irq_chip,
+				handle_level_irq);
+	irq_set_chip_data(irq, d->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+static const struct irq_domain_ops dw_v3_65_legacy_irq_domian_ops = {
+	.map = dw_v3_65_init_legacy_irq_map,
+	.xlate = irq_domain_xlate_onetwocell,
+};
+
+/**
+ * dw_v3_65_set_ob_regs() - Set PHYADDR <-> BUSADDR
+ * mapping for outbound
+ */
+void dw_v3_65_setup_ob_regs(struct pcie_port *pp)
+{
+	u32 start = pp->mem.start, end = pp->mem.end;
+	int i, tr_size;
+
+	dev_dbg(pp->dev, "Setting outbound translation for %#x-%#x\n",
+		start, end);
+
+	/* Set outbound translation size per window division */
+	writel(CFG_PCIM_WIN_SZ_IDX & 0x7, pp->va_app_base + OB_SIZE);
+
+	tr_size = (1 << (CFG_PCIM_WIN_SZ_IDX & 0x7)) * SZ_1M;
+
+	/* Using Direct 1:1 mapping of RC <-> PCI memory space */
+	for (i = 0; (i < CFG_PCIM_WIN_CNT) && (start < end); i++) {
+		writel(start | 1, pp->va_app_base + OB_OFFSET_INDEX(i));
+		writel(0, pp->va_app_base + OB_OFFSET_HI(i));
+		start += tr_size;
+	}
+
+	/* Enable OB translation */
+	writel(OB_XLAT_EN_VAL | readl(pp->va_app_base + CMD_STATUS),
+		pp->va_app_base + CMD_STATUS);
+}
+
+/**
+ * dw_v3_65_set_dbi_mode() - Set DBI mode to access overlaid BAR mask registers
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static inline void dw_v3_65_set_dbi_mode(void __iomem *reg_virt)
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
+ * dw_v3_65_clear_dbi_mode() - Disable DBI mode
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static inline void dw_v3_65_clear_dbi_mode(void __iomem *reg_virt)
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
+void dw_v3_65_disable_bars(struct pcie_port *pp)
+{
+	dw_v3_65_set_dbi_mode(pp->va_app_base);
+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_0);
+	writel(0, pp->dbi_base + PCI_BASE_ADDRESS_1);
+	dw_v3_65_clear_dbi_mode(pp->va_app_base);
+}
+
+/**
+ * dw_v3_65_setup_config_addr() - Set up configuration space address for a
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
+dw_v3_65_setup_config_addr(struct pcie_port *pp, u8 bus, u8 device, u8 function)
+{
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
+	writel(regval, pp->va_app_base + CFG_SETUP);
+
+	return pp->dbi_base + SPACE0_REMOTE_CFG_OFFSET;
+}
+
+int dw_v3_65_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		unsigned int devfn, int where, int size, u32 *val)
+{
+	u8 bus_num = bus->number;
+	void __iomem *addr;
+	int ret;
+
+	addr = dw_v3_65_setup_config_addr(pp, bus_num, PCI_SLOT(devfn),
+				 PCI_FUNC(devfn));
+
+	ret = dw_pcie_cfg_read(addr + (where & ~0x3), where, size, val);
+
+	return ret;
+}
+
+int dw_v3_65_wr_other_conf(struct pcie_port *pp,
+		struct pci_bus *bus, unsigned int devfn, int where,
+		int size, u32 val)
+{
+	u8 bus_num = bus->number;
+	void __iomem *addr;
+
+	addr = dw_v3_65_setup_config_addr(pp, bus_num, PCI_SLOT(devfn),
+				PCI_FUNC(devfn));
+	return dw_pcie_cfg_write(addr + (where & ~0x3), where, size, val);
+}
+
+/**
+ * dw_v3_65_set_ib_access() - Setup inbound access
+ *
+ * Configure BAR0 for inbound access. BAR0 is set up in h/w to have
+ * access to PCIESS application register space and just needs to set up
+ * inbound address (mainly used for MSI).
+ */
+static void dw_v3_65_set_ib_access(struct pcie_port *pp)
+{
+	/* Configure and set up BAR0 */
+	dw_v3_65_set_dbi_mode(pp->va_app_base);
+
+	/* Enable BAR0 */
+	writel(1, pp->dbi_base + PCI_BASE_ADDRESS_0);
+	writel(SZ_4K - 1, pp->dbi_base + PCI_BASE_ADDRESS_0);
+
+	dw_v3_65_clear_dbi_mode(pp->va_app_base);
+	 /*
+	  * For BAR0, just setting bus address for inbound writes (MSI) should
+	  * be sufficient. Use physical address to avoid any conflicts.
+	  */
+	writel(pp->app.start, pp->dbi_base + PCI_BASE_ADDRESS_0);
+}
+
+/**
+ * dw_v3_65_pcie_scan_bus() - common function to scan bus
+ *
+ * common functin to scan v3_65 dw based pci bus. This also sets inbound access
+ * after scan.
+ */
+static struct pci_bus *dw_v3_65_pcie_scan_bus(int nr, struct pci_sys_data *sys)
+{
+	struct pcie_port *pp = sys_to_pcie(sys);
+	struct pci_bus *bus;
+
+	bus = dw_pcie_scan_bus(nr, sys);
+	if (bus)
+		dw_v3_65_set_ib_access(pp);
+
+	return bus;
+}
+
+/**
+ * dw_v3_65_pcie_link_up() - Check if link up
+ *
+ * optionally enable link train using link_train option and check if link is up.
+ */
+int dw_v3_65_pcie_link_up(struct pcie_port *pp, int link_train)
+{
+	u32 val;
+
+	if (link_train) {
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
+		val = readl(pp->va_app_base + CMD_STATUS);
+		writel(LTSSM_EN_VAL | val,  pp->va_app_base + CMD_STATUS);
+
+	}
+
+	val = readl(pp->dbi_base + DEBUG0);
+
+	return (val & LTSSM_STATE_MASK) == LTSSM_STATE_L0;
+}
+
+static struct hw_pci dw_v3_65_pcie_hw = {
+	.nr_controllers	= 1,
+	.setup		= dw_pcie_setup,
+	.scan		= dw_v3_65_pcie_scan_bus,
+	.add_bus	= dw_pcie_add_bus,
+	.map_irq	= dw_pcie_map_irq,
+};
+
+
+/**
+ * dw_v3_65_pcie_host_init() - initialize host for v3_65 dw hardware
+ *
+ * Parse the pcie resources from DT bindings and then call common
+ * dw functions to do host initialization.
+ */
+int __init dw_v3_65_pcie_host_init(struct pcie_port *pp,
+				struct device_node *legacy_intc_np,
+				struct device_node *msi_intc_np)
+{
+	int ret;
+
+	/* check if compatible with v3.65 DW h/w */
+	if (!of_device_is_compatible(pp->dev->of_node, "snps,dw-pcie-v3.65")) {
+		dev_err(pp->dev, "Host driver not compatible\n");
+		return -EINVAL;
+	}
+
+	pp->version = DW_V3_65;
+	/* parse PCI bus resources */
+	ret = dw_pcie_parse_resource(pp);
+	if (ret)
+		return ret;
+
+	pp->dbi_base = devm_ioremap_resource(pp->dev, &pp->cfg);
+	if (IS_ERR(pp->dbi_base))
+		return PTR_ERR(pp->dbi_base);
+
+	pp->va_app_base = devm_ioremap_resource(pp->dev, &pp->app);
+	if (IS_ERR(pp->va_app_base))
+		return PTR_ERR(pp->va_app_base);
+
+	/* create legacy irq domain */
+	pp->legacy_irq_domain = irq_domain_add_linear(legacy_intc_np,
+					MAX_LEGACY_IRQS,
+					&dw_v3_65_legacy_irq_domian_ops, NULL);
+
+	if (!pp->legacy_irq_domain) {
+		dev_err(pp->dev, "Failed to add irq domain for legacy irqs\n");
+		return -EINVAL;
+	}
+
+	ret = dw_pcie_msi_host_init(pp, msi_intc_np, &dw_v3_65_msi_domain_ops);
+	if (ret)
+		return ret;
+
+	return dw_pcie_common_host_init(pp, &dw_v3_65_pcie_hw);
+}
diff --git a/drivers/pci/host/pci-dw-v3_65.h b/drivers/pci/host/pci-dw-v3_65.h
index 689256a..a7584e8 100644
--- a/drivers/pci/host/pci-dw-v3_65.h
+++ b/drivers/pci/host/pci-dw-v3_65.h
@@ -18,3 +18,17 @@
 extern const struct irq_domain_ops dw_v3_65_msi_domain_ops;
 void dw_v3_65_handle_msi_irq(struct pcie_port *pp, int offset);
 u32 dw_v3_65_get_msi_data(struct pcie_port *pp);
+
+/* v3.65 specific PCI controller APIs */
+void dw_v3_65_enable_legacy_irqs(struct pcie_port *pp);
+void dw_v3_65_handle_legacy_irq(struct pcie_port *pp, int offset);
+int  dw_v3_65_pcie_host_init(struct pcie_port *pp,
+			struct device_node *legacy_intc_np,
+			struct device_node *msi_intc_np);
+int dw_v3_65_wr_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		unsigned int devfn, int where, int size, u32 val);
+int dw_v3_65_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		unsigned int devfn, int where, int size, u32 *val);
+void dw_v3_65_disable_bars(struct pcie_port *pp);
+void dw_v3_65_setup_ob_regs(struct pcie_port *pp);
+int dw_v3_65_pcie_link_up(struct pcie_port *pp, int link_train);
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 05bb590..715928e 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -54,6 +54,7 @@ struct pcie_port {
 		struct  {
 			void __iomem		*va_app_base;
 			struct resource		app;
+			struct irq_domain	*legacy_irq_domain;
 		};
 	};
 	u64			io_base;
-- 
1.7.9.5

