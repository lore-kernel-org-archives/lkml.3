Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaFJSw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:52:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59494 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaFJSwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:52:53 -0400
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
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2 4/8] PCI: designware: add msi controller functions for v3.65 hw
Date: Tue, 10 Jun 2014 14:51:23 -0400
Message-ID: <1402426287-31157-5-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dw msi controller functions for v3.65 hw. This adds dw_v3_65_msi_chip
and dw_v3_65_msi_domain_ops so that can be used on this version of the hw.
This required since MSI irq registers reside in the application space
for v3.65 hw. The functions are used by v3.65 dw pci core functions to
support implementation of PCI controllers based on this hw version.

While at it, move the ATU hw specific variable and msi irq to a separate
struct inside a union and add another struct inside the union to hold
dw v3.65 specific variables.

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
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Grant Likely <grant.likely@linaro.org> 

---
 drivers/pci/host/Kconfig            |    5 ++
 drivers/pci/host/Makefile           |    1 +
 drivers/pci/host/pci-dw-v3_65-msi.c |  149 +++++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-dw-v3_65.h     |   20 +++++
 drivers/pci/host/pcie-designware.h  |   21 +++--
 5 files changed, 191 insertions(+), 5 deletions(-)
 create mode 100644 drivers/pci/host/pci-dw-v3_65-msi.c
 create mode 100644 drivers/pci/host/pci-dw-v3_65.h

diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index a6f67ec..2fcd9f9 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -9,6 +9,11 @@ config PCI_MVEBU
 config PCIE_DW
 	bool
 
+config PCI_DW_V3_65
+	bool "Designware PCIe h/w v3.65"
+	help
+	   Say Y here if the DW h/w version is 3.65
+
 config PCI_EXYNOS
 	bool "Samsung Exynos PCIe controller"
 	depends on SOC_EXYNOS5440
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 13fb333..28af710 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
+obj-$(CONFIG_PCI_DW_V3_65) += pci-dw-v3_65-msi.o
diff --git a/drivers/pci/host/pci-dw-v3_65-msi.c b/drivers/pci/host/pci-dw-v3_65-msi.c
new file mode 100644
index 0000000..a26ffdd
--- /dev/null
+++ b/drivers/pci/host/pci-dw-v3_65-msi.c
@@ -0,0 +1,149 @@
+/*
+ * Designware(dw) MSI controller version 3.65
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
+#include <linux/of_irq.h>
+#include <linux/kernel.h>
+#include <linux/msi.h>
+#include <linux/pci.h>
+
+#include "pcie-designware.h"
+
+#define MSI_IRQ				0x054
+#define MSI0_IRQ_STATUS			0x104
+#define MSI0_IRQ_ENABLE_SET		0x108
+#define MSI0_IRQ_ENABLE_CLR		0x10c
+#define IRQ_STATUS			0x184
+#define IRQ_EOI                         0x050
+#define MSI_IRQ_OFFSET			4
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
+inline u32 dw_v3_65_get_msi_data(struct pcie_port *pp)
+{
+	return pp->app.start + MSI_IRQ;
+}
+
+void dw_v3_65_handle_msi_irq(struct pcie_port *pp, int offset)
+{
+	u32 pending, vector;
+	int src, virq;
+
+	pending = readl(pp->va_app_base + MSI0_IRQ_STATUS + (offset << 4));
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
+static void dw_v3_65_msi_irq_ack(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+
+	msi = irq_get_msi_desc(irq);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
+
+	writel(BIT(bit_pos),
+		pp->va_app_base + MSI0_IRQ_STATUS + (reg_offset << 4));
+	writel(reg_offset + MSI_IRQ_OFFSET, pp->va_app_base + IRQ_EOI);
+}
+
+static void dw_v3_65_msi_irq_mask(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+
+	msi = irq_get_msi_desc(irq);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
+
+	/* mask the end point if PVM implemented */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (msi->msi_attrib.maskbit)
+			mask_msi_irq(d);
+	}
+
+	writel(BIT(bit_pos),
+		pp->va_app_base + MSI0_IRQ_ENABLE_CLR + (reg_offset << 4));
+}
+
+static void dw_v3_65_msi_irq_unmask(struct irq_data *d)
+{
+	u32 offset, reg_offset, bit_pos;
+	unsigned int irq = d->irq;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+
+	msi = irq_get_msi_desc(irq);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	offset = irq - irq_linear_revmap(pp->irq_domain, 0);
+	update_reg_offset_bit_pos(offset, &reg_offset, &bit_pos);
+
+	/* mask the end point if PVM implemented */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (msi->msi_attrib.maskbit)
+			unmask_msi_irq(d);
+	}
+
+	writel(BIT(bit_pos),
+		pp->va_app_base + MSI0_IRQ_ENABLE_SET + (reg_offset << 4));
+}
+
+static struct irq_chip dw_v3_65_msi_chip = {
+	.name = "PCI-DW-MSI-OLD",
+	.irq_ack = dw_v3_65_msi_irq_ack,
+	.irq_mask = dw_v3_65_msi_irq_mask,
+	.irq_unmask = dw_v3_65_msi_irq_unmask,
+};
+
+static int dw_v3_65_msi_map(struct irq_domain *domain, unsigned int irq,
+			irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(irq, &dw_v3_65_msi_chip, handle_level_irq);
+	irq_set_chip_data(irq, domain->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+const struct irq_domain_ops dw_v3_65_msi_domain_ops = {
+	.map = dw_v3_65_msi_map,
+};
diff --git a/drivers/pci/host/pci-dw-v3_65.h b/drivers/pci/host/pci-dw-v3_65.h
new file mode 100644
index 0000000..689256a
--- /dev/null
+++ b/drivers/pci/host/pci-dw-v3_65.h
@@ -0,0 +1,20 @@
+/*
+ * Designware(dw) v3.65 controller common includes
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
+#define MAX_LEGACY_IRQS		4
+
+/* v3.65 specific MSI controller APIs/definitions */
+extern const struct irq_domain_ops dw_v3_65_msi_domain_ops;
+void dw_v3_65_handle_msi_irq(struct pcie_port *pp, int offset);
+u32 dw_v3_65_get_msi_data(struct pcie_port *pp);
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 3a6a6eb..05bb590 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -35,16 +35,27 @@ struct pcie_port {
 	struct device		*dev;
 	u8			root_bus_nr;
 	void __iomem		*dbi_base;
-	u64			cfg0_base;
-	void __iomem		*va_cfg0_base;
-	u64			cfg1_base;
-	void __iomem		*va_cfg1_base;
 	/*
 	 * v3.65 DW hw implements application register space for
 	 * MSI and has no ATU view port
 	 */
 #define DW_V3_65		BIT(0)
 	u32			version;
+	union {
+		/* New DW hw specific */
+		struct {
+			u64			cfg0_base;
+			void __iomem		*va_cfg0_base;
+			u64			cfg1_base;
+			void __iomem		*va_cfg1_base;
+			int			msi_irq;
+		};
+		/* v3.65 DW hw specific */
+		struct  {
+			void __iomem		*va_app_base;
+			struct resource		app;
+		};
+	};
 	u64			io_base;
 	u64			mem_base;
 	spinlock_t		conf_lock;
@@ -55,7 +66,7 @@ struct pcie_port {
 	int			irq;
 	u32			lanes;
 	struct pcie_host_ops	*ops;
-	int			msi_irq;
+	/* msi irq domain */
 	struct irq_domain	*irq_domain;
 	unsigned long		msi_data;
 	DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
-- 
1.7.9.5

