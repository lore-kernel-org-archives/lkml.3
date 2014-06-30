Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaF3Vqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:46:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51712 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbaF3Vq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:46:28 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
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
Subject: [PATCH v3 3/5] PCI: designware: refactor host init code to re-use on keystone PCI
Date: Mon, 30 Jun 2014 17:45:18 -0400
Message-ID: <1404164720-11066-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactor the host controller init code to support Keystone
PCI controller.

Current DW PCI host controller init code has code specific to newer
DW hw such as ATU port resource parse and ioremap. Conditionally
execute this code if DW h/w is not v3.65. Keystone PCI controller
is based on v3.65 DW PCI h/w and it has MSI controller implemented
in application space and requires different controller initialization
code. So factor out the MSI host init code to a separate function.

Rename dw_pcie_host_init() to dw_pcie_common_host_init() that takes an
additional arg, ptr to hw_pci structure. This allows to re-use the code
for Keystone PCI that can now provide it's own pci hw ops and msi irq
ops.  dw_pcie_host_init() is now a wrapper function that calls
dw_pcie_common_host_init() for pci common initialization.

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
 drivers/pci/host/pcie-designware.c |  105 +++++++++++++++++++++++++-----------
 drivers/pci/host/pcie-designware.h |    3 +-
 2 files changed, 75 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 905941c..c11e4de 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -415,19 +415,24 @@ static const struct irq_domain_ops msi_domain_ops = {
 	.map = dw_pcie_msi_map,
 };
 
-int __init dw_pcie_host_init(struct pcie_port *pp)
+static int __init dw_pcie_common_host_init(struct pcie_port *pp,
+					   struct hw_pci *hw)
 {
 	struct device_node *np = pp->dev->of_node;
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
+	struct hw_pci *pci_hw = hw;
 	u32 val;
-	int i;
 
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
 		return -EINVAL;
 	}
 
+	/* Default to dw_pci if no hw ops provided */
+	if (!pci_hw)
+		pci_hw = &dw_pci;
+
 	/* Get the I/O and memory ranges from DT */
 	for_each_of_pci_range(&parser, &range) {
 		unsigned long restype = range.flags & IORESOURCE_TYPE_BITS;
@@ -467,21 +472,24 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		}
 	}
 
-	pp->cfg0_base = pp->cfg.start;
-	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
 	pp->mem_base = pp->mem.start;
-
-	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
-					pp->config.cfg0_size);
-	if (!pp->va_cfg0_base) {
-		dev_err(pp->dev, "error with ioremap in function\n");
-		return -ENOMEM;
-	}
-	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
-					pp->config.cfg1_size);
-	if (!pp->va_cfg1_base) {
-		dev_err(pp->dev, "error with ioremap\n");
-		return -ENOMEM;
+	if (!pp->version & DW_HW_V3_65) {
+		/* Default is with ATU port. */
+		pp->cfg0_base = pp->cfg.start;
+		pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
+
+		pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
+						pp->config.cfg0_size);
+		if (!pp->va_cfg0_base) {
+			dev_err(pp->dev, "error with ioremap in function\n");
+			return -ENOMEM;
+		}
+		pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
+						pp->config.cfg1_size);
+		if (!pp->va_cfg1_base) {
+			dev_err(pp->dev, "error with ioremap\n");
+			return -ENOMEM;
+		}
 	}
 
 	if (of_property_read_u32(np, "num-lanes", &pp->lanes)) {
@@ -489,19 +497,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		return -EINVAL;
 	}
 
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
-					MAX_MSI_IRQS, &msi_domain_ops,
-					&dw_pcie_msi_chip);
-		if (!pp->irq_domain) {
-			dev_err(pp->dev, "irq domain init failed\n");
-			return -ENXIO;
-		}
-
-		for (i = 0; i < MAX_MSI_IRQS; i++)
-			irq_create_mapping(pp->irq_domain, i);
-	}
-
 	if (pp->ops->host_init)
 		pp->ops->host_init(pp);
 
@@ -514,10 +509,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	val |= PORT_LOGIC_SPEED_CHANGE;
 	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
 
-	dw_pci.nr_controllers = 1;
-	dw_pci.private_data = (void **)&pp;
+	pci_hw->nr_controllers = 1;
+	pci_hw->private_data = (void **)&pp;
 
-	pci_common_init_dev(pp->dev, &dw_pci);
+	pci_common_init_dev(pp->dev, pci_hw);
 	pci_assign_unassigned_resources();
 #ifdef CONFIG_PCI_DOMAINS
 	dw_pci.domain++;
@@ -526,6 +521,52 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	return 0;
 }
 
+/*
+ * dw_pcie_msi_host_init() - Function to initialize msi host controller
+ * @pp: ptr to pcie port
+ * @msi_irqc_np: device node ptr to msi irq controller
+ * @irq_msi_ops: ptr to MSI irq_domain_ops struct
+ *
+ * Function register irq domain for msi irq controller and create mappings
+ * for MSI irqs.
+ */
+static int dw_pcie_msi_host_init(struct pcie_port *pp,
+				 struct device_node *msi_irqc_np,
+				 const struct irq_domain_ops *msi_irq_ops)
+{
+	const struct irq_domain_ops *msi_irq_domain_ops = msi_irq_ops;
+	int i;
+
+	/* Default to  msi_domain_ops if no msi irq domain ops provided */
+	if (!msi_irq_domain_ops)
+		msi_irq_domain_ops = &msi_domain_ops;
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		pp->irq_domain = irq_domain_add_linear(msi_irqc_np,
+					MAX_MSI_IRQS, msi_irq_domain_ops,
+					&dw_pcie_msi_chip);
+		if (!pp->irq_domain) {
+			dev_err(pp->dev, "irq domain init failed\n");
+			return -ENXIO;
+		}
+
+		for (i = 0; i < MAX_MSI_IRQS; i++)
+			irq_create_mapping(pp->irq_domain, i);
+	}
+	return 0;
+}
+
+int __init dw_pcie_host_init(struct pcie_port *pp)
+{
+	int ret;
+
+	ret = dw_pcie_msi_host_init(pp, pp->dev->of_node, NULL);
+	if (ret)
+		return ret;
+
+	return dw_pcie_common_host_init(pp, NULL);
+}
+
 static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
 {
 	/* Program viewport 0 : OUTBOUND : CFG0 */
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 387f69e..db0260f 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -51,6 +51,8 @@ struct pcie_port {
 	int			msi_irq;
 	struct irq_domain	*irq_domain;
 	unsigned long		msi_data;
+#define DW_HW_V3_65		BIT(0)
+	u32			version;
 	DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
 };
 
@@ -79,5 +81,4 @@ void dw_pcie_msi_init(struct pcie_port *pp);
 int dw_pcie_link_up(struct pcie_port *pp);
 void dw_pcie_setup_rc(struct pcie_port *pp);
 int dw_pcie_host_init(struct pcie_port *pp);
-
 #endif /* _PCIE_DESIGNWARE_H */
-- 
1.7.9.5

