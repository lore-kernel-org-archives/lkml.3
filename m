Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaCYAgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:36:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46256 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaCYAgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:36:07 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Mohit Kumar <mohit.kumar@st.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RESEND: RFC PATCH 2/3] pci: designware: enhancements to support keystone pcie
Date: Mon, 24 Mar 2014 20:35:24 -0400
Message-ID: <1395707726-20437-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keystone pcie hardware is based on designware hw version 3.65.
There is no support for ATU port and have registers in
application space to configure inbound/outbound access. Also
doesn't support PCI PVM option. So the MSI IRQ registers available
in application space is used to mask/unmask/enable the MSI IRQs.
This requires changes to designware core driver to support the
keystone pcie driver.

Also modified affected drivers to work with the APIs that
are modified for to keystone pcie driver.

CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/pci/host/pci-exynos.c      |    2 +-
 drivers/pci/host/pci-imx6.c        |    2 +-
 drivers/pci/host/pcie-designware.c |   99 ++++++++++++++++++++++++------------
 drivers/pci/host/pcie-designware.h |   14 ++++-
 4 files changed, 81 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
index 24beed3..3cae9b1 100644
--- a/drivers/pci/host/pci-exynos.c
+++ b/drivers/pci/host/pci-exynos.c
@@ -546,7 +546,7 @@ static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
 	pp->ops = &exynos_pcie_host_ops;
 
 	spin_lock_init(&pp->conf_lock);
-	ret = dw_pcie_host_init(pp);
+	ret = dw_pcie_host_init(pp, NULL, NULL);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize host\n");
 		return ret;
diff --git a/drivers/pci/host/pci-imx6.c b/drivers/pci/host/pci-imx6.c
index bd70af8..0d77047 100644
--- a/drivers/pci/host/pci-imx6.c
+++ b/drivers/pci/host/pci-imx6.c
@@ -397,7 +397,7 @@ static int imx6_add_pcie_port(struct pcie_port *pp,
 	pp->ops = &imx6_pcie_host_ops;
 
 	spin_lock_init(&pp->conf_lock);
-	ret = dw_pcie_host_init(pp);
+	ret = dw_pcie_host_init(pp, NULL, NULL);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize host\n");
 		return ret;
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index e33b68b..02d4d25 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -248,11 +248,15 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
 		irq_alloc_descs((irq + i), (irq + i), 1, 0);
 		irq_set_msi_desc(irq + i, desc);
 		/*Enable corresponding interrupt in MSI interrupt controller */
-		res = ((pos0 + i) / 32) * 12;
-		bit = (pos0 + i) % 32;
-		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
-		val |= 1 << bit;
-		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+		if (!(pp->version & DW_VERSION_PRE_3_70)) {
+			res = ((pos0 + i) / 32) * 12;
+			bit = (pos0 + i) % 32;
+			dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
+						 4, &val);
+			val |= 1 << bit;
+			dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
+						 4, val);
+		}
 		i++;
 	}
 
@@ -288,11 +292,13 @@ static void clear_irq(unsigned int irq)
 	clear_bit(pos, pp->msi_irq_in_use);
 
 	/* Disable corresponding interrupt on MSI interrupt controller */
-	res = (pos / 32) * 12;
-	bit = pos % 32;
-	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
-	val &= ~(1 << bit);
-	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+	if (!(pp->version & DW_VERSION_PRE_3_70)) {
+		res = (pos / 32) * 12;
+		bit = pos % 32;
+		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
+		val &= ~(1 << bit);
+		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+	}
 }
 
 static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
@@ -326,7 +332,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 				msg_ctr);
 	desc->msi_attrib.multiple = msgvec;
 
-	msg.address_lo = virt_to_phys((void *)pp->msi_data);
+	if (pp->ops->get_msi_data)
+		msg.address_lo = pp->ops->get_msi_data(pp);
+	else
+		msg.address_lo = virt_to_phys((void *)pp->msi_data);
 	msg.address_hi = 0x0;
 	msg.data = pos;
 	write_msi_msg(irq, &msg);
@@ -366,14 +375,27 @@ static const struct irq_domain_ops msi_domain_ops = {
 	.map = dw_pcie_msi_map,
 };
 
-int __init dw_pcie_host_init(struct pcie_port *pp)
+int __init dw_pcie_host_init(struct pcie_port *pp, struct hw_pci *hw,
+				const struct irq_domain_ops *irq_ops)
 {
 	struct device_node *np = pp->dev->of_node;
-	struct of_pci_range range;
+	const struct irq_domain_ops *irq_msi_ops;
 	struct of_pci_range_parser parser;
+	struct of_pci_range range;
+	struct hw_pci *hw_pci;
 	u32 val;
 	int i;
 
+	/* if glue driver provides its own hw ops, override the default */
+	hw_pci = hw;
+	if (!hw_pci)
+		hw_pci = &dw_pci;
+
+	/* if glue driver provides its own irq msi ops, override default */
+	irq_msi_ops = irq_ops;
+	if (!irq_msi_ops)
+		irq_msi_ops = &msi_domain_ops;
+
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
 		return -EINVAL;
@@ -422,17 +444,20 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	pp->io_base = pp->io.start;
 	pp->mem_base = pp->mem.start;
 
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
+	if (!(pp->version & DW_VERSION_PRE_3_70)) {
+		/* only version 3.70 or later support ATU port */
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
@@ -442,7 +467,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
-					MAX_MSI_IRQS, &msi_domain_ops,
+					MAX_MSI_IRQS, irq_msi_ops,
 					&dw_pcie_msi_chip);
 		if (!pp->irq_domain) {
 			dev_err(pp->dev, "irq domain init failed\n");
@@ -465,10 +490,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	val |= PORT_LOGIC_SPEED_CHANGE;
 	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
 
-	dw_pci.nr_controllers = 1;
-	dw_pci.private_data = (void **)&pp;
+	hw_pci->nr_controllers = 1;
+	hw_pci->private_data = (void **)&pp;
 
-	pci_common_init(&dw_pci);
+	pci_common_init(hw_pci);
 	pci_assign_unassigned_resources();
 #ifdef CONFIG_PCI_DOMAINS
 	dw_pci.domain++;
@@ -628,7 +653,11 @@ static int dw_pcie_rd_conf(struct pci_bus *bus, u32 devfn, int where,
 
 	spin_lock_irqsave(&pp->conf_lock, flags);
 	if (bus->number != pp->root_bus_nr)
-		ret = dw_pcie_rd_other_conf(pp, bus, devfn,
+		if (pp->ops->rd_other_conf)
+			ret = pp->ops->rd_other_conf(pp, bus, devfn,
+						where, size, val);
+		else
+			ret = dw_pcie_rd_other_conf(pp, bus, devfn,
 						where, size, val);
 	else
 		ret = dw_pcie_rd_own_conf(pp, where, size, val);
@@ -654,7 +683,11 @@ static int dw_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 
 	spin_lock_irqsave(&pp->conf_lock, flags);
 	if (bus->number != pp->root_bus_nr)
-		ret = dw_pcie_wr_other_conf(pp, bus, devfn,
+		if (pp->ops->wr_other_conf)
+			ret = pp->ops->wr_other_conf(pp, bus, devfn,
+						where, size, val);
+		else
+			ret = dw_pcie_wr_other_conf(pp, bus, devfn,
 						where, size, val);
 	else
 		ret = dw_pcie_wr_own_conf(pp, where, size, val);
@@ -668,7 +701,7 @@ static struct pci_ops dw_pcie_ops = {
 	.write = dw_pcie_wr_conf,
 };
 
-static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
+int dw_pcie_setup(int nr, struct pci_sys_data *sys)
 {
 	struct pcie_port *pp;
 
@@ -691,7 +724,7 @@ static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
+struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 {
 	struct pci_bus *bus;
 	struct pcie_port *pp = sys_to_pcie(sys);
@@ -715,7 +748,7 @@ static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return pp->irq;
 }
 
-static void dw_pcie_add_bus(struct pci_bus *bus)
+void dw_pcie_add_bus(struct pci_bus *bus)
 {
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index c15379b..da35a80 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -48,6 +48,8 @@ struct pcie_port {
 	struct pcie_port_info	config;
 	int			irq;
 	u32			lanes;
+#define DW_VERSION_PRE_3_70	BIT(0)
+	u32			version;
 	struct pcie_host_ops	*ops;
 	int			msi_irq;
 	struct irq_domain	*irq_domain;
@@ -62,8 +64,13 @@ struct pcie_host_ops {
 			u32 val, void __iomem *dbi_base);
 	int (*rd_own_conf)(struct pcie_port *pp, int where, int size, u32 *val);
 	int (*wr_own_conf)(struct pcie_port *pp, int where, int size, u32 val);
+	int (*rd_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
+			unsigned int devfn, int where, int size, u32 *val);
+	int (*wr_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
+			unsigned int devfn, int where, int size, u32 val);
 	int (*link_up)(struct pcie_port *pp);
 	void (*host_init)(struct pcie_port *pp);
+	u32 (*get_msi_data)(struct pcie_port *pp);
 };
 
 int cfg_read(void __iomem *addr, int where, int size, u32 *val);
@@ -72,6 +79,11 @@ void dw_handle_msi_irq(struct pcie_port *pp);
 void dw_pcie_msi_init(struct pcie_port *pp);
 int dw_pcie_link_up(struct pcie_port *pp);
 void dw_pcie_setup_rc(struct pcie_port *pp);
-int dw_pcie_host_init(struct pcie_port *pp);
+int dw_pcie_host_init(struct pcie_port *pp, struct hw_pci *dw_pci,
+		const struct irq_domain_ops *irq_ops);
+int dw_pcie_setup(int nr, struct pci_sys_data *sys);
+struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys);
+void dw_pcie_add_bus(struct pci_bus *bus);
+
 
 #endif /* _PCIE_DESIGNWARE_H */
-- 
1.7.9.5

