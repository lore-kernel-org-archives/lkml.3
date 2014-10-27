Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaJ0HIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:08:15 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:6873 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ0HIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:08:13 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 01/10] MSI: Rename msi_chip to msi_controller for better readability
Date: Mon, 27 Oct 2014 15:48:38 +0800
Message-ID: <1414396127-30023-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.544DEF33.00CF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: c1b767f0992bb70fbd11a9709757cd58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"msi_chip" name has bad readability, it easily confuses
people that some sort of semiconductor integrated circuit
involved. Rename it to "msi_controller", it's more
descriptive, and arm also use "msi-controller" property
to represent MSI interrupt controller in dts file.
Should no functional change.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/irqchip/irq-armada-370-xp.c |   22 +++++++++---------
 drivers/of/of_pci.c                 |   40 +++++++++++++++++-----------------
 drivers/pci/host/pci-keystone-dw.c  |    4 +-
 drivers/pci/host/pci-keystone.h     |    2 +-
 drivers/pci/host/pci-mvebu.c        |    4 +-
 drivers/pci/host/pci-tegra.c        |   26 +++++++++++-----------
 drivers/pci/host/pcie-designware.c  |   14 ++++++------
 drivers/pci/host/pcie-designware.h  |    2 +-
 drivers/pci/host/pcie-rcar.c        |   26 +++++++++++-----------
 drivers/pci/host/pcie-xilinx.c      |   12 +++++-----
 drivers/pci/msi.c                   |   12 +++++-----
 include/linux/msi.h                 |    6 ++--
 include/linux/of_pci.h              |   14 ++++++------
 include/linux/pci.h                 |    2 +-
 14 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 3e238cd..c778ab0 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -129,7 +129,7 @@ static void armada_370_xp_free_msi(int hwirq)
 	mutex_unlock(&msi_used_lock);
 }
 
-static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
+static int armada_370_xp_setup_msi_irq(struct msi_controller *ctrl,
 				       struct pci_dev *pdev,
 				       struct msi_desc *desc)
 {
@@ -160,7 +160,7 @@ static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
 	return 0;
 }
 
-static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
+static void armada_370_xp_teardown_msi_irq(struct msi_controller *ctrl,
 					   unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
@@ -195,34 +195,34 @@ static const struct irq_domain_ops armada_370_xp_msi_irq_ops = {
 static int armada_370_xp_msi_init(struct device_node *node,
 				  phys_addr_t main_int_phys_base)
 {
-	struct msi_chip *msi_chip;
+	struct msi_controller *ctrl;
 	u32 reg;
 	int ret;
 
 	msi_doorbell_addr = main_int_phys_base +
 		ARMADA_370_XP_SW_TRIG_INT_OFFS;
 
-	msi_chip = kzalloc(sizeof(*msi_chip), GFP_KERNEL);
-	if (!msi_chip)
+	ctrl = kzalloc(sizeof(*msi_controller), GFP_KERNEL);
+	if (!ctrl)
 		return -ENOMEM;
 
-	msi_chip->setup_irq = armada_370_xp_setup_msi_irq;
-	msi_chip->teardown_irq = armada_370_xp_teardown_msi_irq;
-	msi_chip->of_node = node;
+	ctrl->setup_irq = armada_370_xp_setup_msi_irq;
+	ctrl->teardown_irq = armada_370_xp_teardown_msi_irq;
+	ctrl->of_node = node;
 
 	armada_370_xp_msi_domain =
 		irq_domain_add_linear(NULL, PCI_MSI_DOORBELL_NR,
 				      &armada_370_xp_msi_irq_ops,
 				      NULL);
 	if (!armada_370_xp_msi_domain) {
-		kfree(msi_chip);
+		kfree(ctrl);
 		return -ENOMEM;
 	}
 
-	ret = of_pci_msi_chip_add(msi_chip);
+	ret = of_pci_msi_controller_add(ctrl);
 	if (ret < 0) {
 		irq_domain_remove(armada_370_xp_msi_domain);
-		kfree(msi_chip);
+		kfree(ctrl);
 		return ret;
 	}
 
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 8882b46..ab136ea 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -233,45 +233,45 @@ EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
 
 #ifdef CONFIG_PCI_MSI
 
-static LIST_HEAD(of_pci_msi_chip_list);
-static DEFINE_MUTEX(of_pci_msi_chip_mutex);
+static LIST_HEAD(of_pci_msi_controller_list);
+static DEFINE_MUTEX(of_pci_msi_controller_mutex);
 
-int of_pci_msi_chip_add(struct msi_chip *chip)
+int of_pci_msi_controller_add(struct msi_controller *ctrl)
 {
-	if (!of_property_read_bool(chip->of_node, "msi-controller"))
+	if (!of_property_read_bool(ctrl->of_node, "msi-controller"))
 		return -EINVAL;
 
-	mutex_lock(&of_pci_msi_chip_mutex);
-	list_add(&chip->list, &of_pci_msi_chip_list);
-	mutex_unlock(&of_pci_msi_chip_mutex);
+	mutex_lock(&of_pci_msi_controller_mutex);
+	list_add(&ctrl->list, &of_pci_msi_controller_list);
+	mutex_unlock(&of_pci_msi_controller_mutex);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(of_pci_msi_chip_add);
+EXPORT_SYMBOL_GPL(of_pci_msi_controller_add);
 
-void of_pci_msi_chip_remove(struct msi_chip *chip)
+void of_pci_msi_controller_remove(struct msi_controller *ctrl)
 {
-	mutex_lock(&of_pci_msi_chip_mutex);
-	list_del(&chip->list);
-	mutex_unlock(&of_pci_msi_chip_mutex);
+	mutex_lock(&of_pci_msi_controller_mutex);
+	list_del(&ctrl->list);
+	mutex_unlock(&of_pci_msi_controller_mutex);
 }
-EXPORT_SYMBOL_GPL(of_pci_msi_chip_remove);
+EXPORT_SYMBOL_GPL(of_pci_msi_controller_remove);
 
-struct msi_chip *of_pci_find_msi_chip_by_node(struct device_node *of_node)
+struct msi_controller *of_pci_find_msi_controller_by_node(struct device_node *of_node)
 {
-	struct msi_chip *c;
+	struct msi_controller *c;
 
-	mutex_lock(&of_pci_msi_chip_mutex);
-	list_for_each_entry(c, &of_pci_msi_chip_list, list) {
+	mutex_lock(&of_pci_msi_controller_mutex);
+	list_for_each_entry(c, &of_pci_msi_controller_list, list) {
 		if (c->of_node == of_node) {
-			mutex_unlock(&of_pci_msi_chip_mutex);
+			mutex_unlock(&of_pci_msi_controller_mutex);
 			return c;
 		}
 	}
-	mutex_unlock(&of_pci_msi_chip_mutex);
+	mutex_unlock(&of_pci_msi_controller_mutex);
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(of_pci_find_msi_chip_by_node);
+EXPORT_SYMBOL_GPL(of_pci_find_msi_controller_by_node);
 
 #endif /* CONFIG_PCI_MSI */
diff --git a/drivers/pci/host/pci-keystone-dw.c b/drivers/pci/host/pci-keystone-dw.c
index 34086ce..6db4a5b 100644
--- a/drivers/pci/host/pci-keystone-dw.c
+++ b/drivers/pci/host/pci-keystone-dw.c
@@ -205,7 +205,7 @@ const struct irq_domain_ops ks_dw_pcie_msi_domain_ops = {
 	.map = ks_dw_pcie_msi_map,
 };
 
-int ks_dw_pcie_msi_host_init(struct pcie_port *pp, struct msi_chip *chip)
+int ks_dw_pcie_msi_host_init(struct pcie_port *pp, struct msi_controller *ctrl)
 {
 	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
 	int i;
@@ -213,7 +213,7 @@ int ks_dw_pcie_msi_host_init(struct pcie_port *pp, struct msi_chip *chip)
 	pp->irq_domain = irq_domain_add_linear(ks_pcie->msi_intc_np,
 					MAX_MSI_IRQS,
 					&ks_dw_pcie_msi_domain_ops,
-					chip);
+					ctrl);
 	if (!pp->irq_domain) {
 		dev_err(pp->dev, "irq domain init failed\n");
 		return -ENXIO;
diff --git a/drivers/pci/host/pci-keystone.h b/drivers/pci/host/pci-keystone.h
index 1fc1fce..4484001 100644
--- a/drivers/pci/host/pci-keystone.h
+++ b/drivers/pci/host/pci-keystone.h
@@ -55,4 +55,4 @@ void ks_dw_pcie_msi_set_irq(struct pcie_port *pp, int irq);
 void ks_dw_pcie_msi_clear_irq(struct pcie_port *pp, int irq);
 void ks_dw_pcie_v3_65_scan_bus(struct pcie_port *pp);
 int ks_dw_pcie_msi_host_init(struct pcie_port *pp,
-		struct msi_chip *chip);
+		struct msi_controller *ctrl);
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index b1315e1..5ab7d16 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -99,7 +99,7 @@ struct mvebu_pcie_port;
 struct mvebu_pcie {
 	struct platform_device *pdev;
 	struct mvebu_pcie_port *ports;
-	struct msi_chip *msi;
+	struct msi_controller *msi;
 	struct resource io;
 	char io_name[30];
 	struct resource realio;
@@ -905,7 +905,7 @@ static void mvebu_pcie_msi_enable(struct mvebu_pcie *pcie)
 	if (!msi_node)
 		return;
 
-	pcie->msi = of_pci_find_msi_chip_by_node(msi_node);
+	pcie->msi = of_pci_find_msi_controller_by_node(msi_node);
 
 	if (pcie->msi)
 		pcie->msi->dev = &pcie->pdev->dev;
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 3d43874..7c3d354 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -238,7 +238,7 @@
 	)
 
 struct tegra_msi {
-	struct msi_chip chip;
+	struct msi_controller ctrl;
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
 	unsigned long pages;
@@ -259,9 +259,9 @@ struct tegra_pcie_soc_data {
 	bool has_gen2;
 };
 
-static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
+static inline struct tegra_msi *to_tegra_msi(struct msi_controller *ctrl)
 {
-	return container_of(chip, struct tegra_msi, chip);
+	return container_of(ctrl, struct tegra_msi, ctrl);
 }
 
 struct tegra_pcie {
@@ -699,7 +699,7 @@ static void tegra_pcie_add_bus(struct pci_bus *bus)
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		struct tegra_pcie *pcie = sys_to_pcie(bus->sysdata);
 
-		bus->msi = &pcie->msi.chip;
+		bus->msi = &pcie->msi.ctrl;
 	}
 }
 
@@ -1230,7 +1230,7 @@ static int tegra_msi_alloc(struct tegra_msi *chip)
 
 static void tegra_msi_free(struct tegra_msi *chip, unsigned long irq)
 {
-	struct device *dev = chip->chip.dev;
+	struct device *dev = chip->ctrl.dev;
 
 	mutex_lock(&chip->lock);
 
@@ -1283,10 +1283,10 @@ static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
 	return processed > 0 ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+static int tegra_msi_setup_irq(struct msi_controller *ctrl, struct pci_dev *pdev,
 			       struct msi_desc *desc)
 {
-	struct tegra_msi *msi = to_tegra_msi(chip);
+	struct tegra_msi *msi = to_tegra_msi(ctrl);
 	struct msi_msg msg;
 	unsigned int irq;
 	int hwirq;
@@ -1313,9 +1313,9 @@ static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	return 0;
 }
 
-static void tegra_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void tegra_msi_teardown_irq(struct msi_controller *ctrl, unsigned int irq)
 {
-	struct tegra_msi *msi = to_tegra_msi(chip);
+	struct tegra_msi *msi = to_tegra_msi(ctrl);
 	struct irq_data *d = irq_get_irq_data(irq);
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
@@ -1358,12 +1358,12 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 
 	mutex_init(&msi->lock);
 
-	msi->chip.dev = pcie->dev;
-	msi->chip.setup_irq = tegra_msi_setup_irq;
-	msi->chip.teardown_irq = tegra_msi_teardown_irq;
+	msi->ctrl.dev = pcie->dev;
+	msi->ctrl.setup_irq = tegra_msi_setup_irq;
+	msi->ctrl.teardown_irq = tegra_msi_teardown_irq;
 
 	msi->domain = irq_domain_add_linear(pcie->dev->of_node, INT_PCI_MSI_NR,
-					    &msi_domain_ops, &msi->chip);
+					    &msi_domain_ops, &msi->ctrl);
 	if (!msi->domain) {
 		dev_err(&pdev->dev, "failed to create IRQ domain\n");
 		return -ENOMEM;
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index dfed00a..0839b92 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -276,7 +276,7 @@ no_valid_irq:
 	return -ENOSPC;
 }
 
-static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+static int dw_msi_setup_irq(struct msi_controller *ctrl, struct pci_dev *pdev,
 			struct msi_desc *desc)
 {
 	int irq, pos;
@@ -303,7 +303,7 @@ static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	return 0;
 }
 
-static void dw_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void dw_msi_teardown_irq(struct msi_controller *ctrl, unsigned int irq)
 {
 	struct irq_data *data = irq_get_irq_data(irq);
 	struct msi_desc *msi = irq_data_get_msi(data);
@@ -312,7 +312,7 @@ static void dw_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
 	clear_irq_range(pp, irq, 1, data->hwirq);
 }
 
-static struct msi_chip dw_pcie_msi_chip = {
+static struct msi_controller dw_pcie_msi_controller = {
 	.setup_irq = dw_msi_setup_irq,
 	.teardown_irq = dw_msi_teardown_irq,
 };
@@ -471,7 +471,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		if (!pp->ops->msi_host_init) {
 			pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
 						MAX_MSI_IRQS, &msi_domain_ops,
-						&dw_pcie_msi_chip);
+						&dw_pcie_msi_controller);
 			if (!pp->irq_domain) {
 				dev_err(pp->dev, "irq domain init failed\n");
 				return -ENXIO;
@@ -480,7 +480,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 			for (i = 0; i < MAX_MSI_IRQS; i++)
 				irq_create_mapping(pp->irq_domain, i);
 		} else {
-			ret = pp->ops->msi_host_init(pp, &dw_pcie_msi_chip);
+			ret = pp->ops->msi_host_init(pp, &dw_pcie_msi_controller);
 			if (ret < 0)
 				return ret;
 		}
@@ -752,8 +752,8 @@ static void dw_pcie_add_bus(struct pci_bus *bus)
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
 
-		dw_pcie_msi_chip.dev = pp->dev;
-		bus->msi = &dw_pcie_msi_chip;
+		dw_pcie_msi_controller.dev = pp->dev;
+		bus->msi = &dw_pcie_msi_controller;
 	}
 }
 
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index c625675..d39912d 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -73,7 +73,7 @@ struct pcie_host_ops {
 	u32 (*get_msi_addr)(struct pcie_port *pp);
 	u32 (*get_msi_data)(struct pcie_port *pp, int pos);
 	void (*scan_bus)(struct pcie_port *pp);
-	int (*msi_host_init)(struct pcie_port *pp, struct msi_chip *chip);
+	int (*msi_host_init)(struct pcie_port *pp, struct msi_controller *ctrl);
 };
 
 int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
index 61158e0..48221aa 100644
--- a/drivers/pci/host/pcie-rcar.c
+++ b/drivers/pci/host/pcie-rcar.c
@@ -111,16 +111,16 @@
 struct rcar_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
-	struct msi_chip chip;
+	struct msi_controller ctrl;
 	unsigned long pages;
 	struct mutex lock;
 	int irq1;
 	int irq2;
 };
 
-static inline struct rcar_msi *to_rcar_msi(struct msi_chip *chip)
+static inline struct rcar_msi *to_rcar_msi(struct msi_controller *ctrl)
 {
-	return container_of(chip, struct rcar_msi, chip);
+	return container_of(ctrl, struct rcar_msi, ctrl);
 }
 
 /* Structure representing the PCIe interface */
@@ -385,7 +385,7 @@ static void rcar_pcie_add_bus(struct pci_bus *bus)
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		struct rcar_pcie *pcie = sys_to_pcie(bus->sysdata);
 
-		bus->msi = &pcie->msi.chip;
+		bus->msi = &pcie->msi.ctrl;
 	}
 }
 
@@ -622,11 +622,11 @@ static irqreturn_t rcar_pcie_msi_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int rcar_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+static int rcar_msi_setup_irq(struct msi_controller *ctrl, struct pci_dev *pdev,
 			      struct msi_desc *desc)
 {
-	struct rcar_msi *msi = to_rcar_msi(chip);
-	struct rcar_pcie *pcie = container_of(chip, struct rcar_pcie, msi.chip);
+	struct rcar_msi *msi = to_rcar_msi(ctrl);
+	struct rcar_pcie *pcie = container_of(ctrl, struct rcar_pcie, msi.ctrl);
 	struct msi_msg msg;
 	unsigned int irq;
 	int hwirq;
@@ -652,9 +652,9 @@ static int rcar_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	return 0;
 }
 
-static void rcar_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void rcar_msi_teardown_irq(struct msi_controller *ctrl, unsigned int irq)
 {
-	struct rcar_msi *msi = to_rcar_msi(chip);
+	struct rcar_msi *msi = to_rcar_msi(ctrl);
 	struct irq_data *d = irq_get_irq_data(irq);
 
 	rcar_msi_free(msi, d->hwirq);
@@ -691,12 +691,12 @@ static int rcar_pcie_enable_msi(struct rcar_pcie *pcie)
 
 	mutex_init(&msi->lock);
 
-	msi->chip.dev = pcie->dev;
-	msi->chip.setup_irq = rcar_msi_setup_irq;
-	msi->chip.teardown_irq = rcar_msi_teardown_irq;
+	msi->ctrl.dev = pcie->dev;
+	msi->ctrl.setup_irq = rcar_msi_setup_irq;
+	msi->ctrl.teardown_irq = rcar_msi_teardown_irq;
 
 	msi->domain = irq_domain_add_linear(pcie->dev->of_node, INT_PCI_MSI_NR,
-					    &msi_domain_ops, &msi->chip);
+					    &msi_domain_ops, &msi->ctrl);
 	if (!msi->domain) {
 		dev_err(&pdev->dev, "failed to create IRQ domain\n");
 		return -ENOMEM;
diff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c
index ccc496b..ce19133 100644
--- a/drivers/pci/host/pcie-xilinx.c
+++ b/drivers/pci/host/pcie-xilinx.c
@@ -335,7 +335,7 @@ static int xilinx_pcie_assign_msi(struct xilinx_pcie_port *port)
  * @chip: MSI Chip descriptor
  * @irq: MSI IRQ to destroy
  */
-static void xilinx_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void xilinx_msi_teardown_irq(struct msi_controller *chip, unsigned int irq)
 {
 	xilinx_pcie_destroy_msi(irq);
 }
@@ -348,7 +348,7 @@ static void xilinx_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
  *
  * Return: '0' on success and error value on failure
  */
-static int xilinx_pcie_msi_setup_irq(struct msi_chip *chip,
+static int xilinx_pcie_msi_setup_irq(struct msi_controller *chip,
 				     struct pci_dev *pdev,
 				     struct msi_desc *desc)
 {
@@ -380,7 +380,7 @@ static int xilinx_pcie_msi_setup_irq(struct msi_chip *chip,
 }
 
 /* MSI Chip Descriptor */
-static struct msi_chip xilinx_pcie_msi_chip = {
+static struct msi_controller xilinx_pcie_msi_controller = {
 	.setup_irq = xilinx_pcie_msi_setup_irq,
 	.teardown_irq = xilinx_msi_teardown_irq,
 };
@@ -440,8 +440,8 @@ static void xilinx_pcie_add_bus(struct pci_bus *bus)
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
 
-		xilinx_pcie_msi_chip.dev = port->dev;
-		bus->msi = &xilinx_pcie_msi_chip;
+		xilinx_pcie_msi_controller.dev = port->dev;
+		bus->msi = &xilinx_pcie_msi_controller;
 	}
 }
 
@@ -660,7 +660,7 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)
 		port->irq_domain = irq_domain_add_linear(node,
 							 XILINX_NUM_MSI_IRQS,
 							 &msi_domain_ops,
-							 &xilinx_pcie_msi_chip);
+							 &xilinx_pcie_msi_controller);
 		if (!port->irq_domain) {
 			dev_err(dev, "Failed to get a MSI IRQ domain\n");
 			return PTR_ERR(port->irq_domain);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 805c7d8..1c7ca4a 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -32,13 +32,13 @@ int pci_msi_ignore_mask;
 
 int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
-	struct msi_chip *chip = dev->bus->msi;
+	struct msi_controller *ctrl = dev->bus->msi;
 	int err;
 
-	if (!chip || !chip->setup_irq)
+	if (!ctrl || !ctrl->setup_irq)
 		return -EINVAL;
 
-	err = chip->setup_irq(chip, dev, desc);
+	err = ctrl->setup_irq(ctrl, dev, desc);
 	if (err < 0)
 		return err;
 
@@ -48,12 +48,12 @@ int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 void __weak arch_teardown_msi_irq(unsigned int irq)
 {
 	struct msi_desc *entry = irq_get_msi_desc(irq);
-	struct msi_chip *chip = entry->dev->bus->msi;
+	struct msi_controller *ctrl = entry->dev->bus->msi;
 
-	if (!chip || !chip->teardown_irq)
+	if (!ctrl || !ctrl->teardown_irq)
 		return;
 
-	chip->teardown_irq(chip, irq);
+	ctrl->teardown_irq(ctrl, irq);
 }
 
 int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index efad127..6704991 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -65,15 +65,15 @@ void arch_restore_msi_irqs(struct pci_dev *dev);
 void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev);
 
-struct msi_chip {
+struct msi_controller {
 	struct module *owner;
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
 
-	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
+	int (*setup_irq)(struct msi_controller *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
-	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
+	void (*teardown_irq)(struct msi_controller *chip, unsigned int irq);
 };
 
 #endif /* LINUX_MSI_H */
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 1fd207e..8d9d068 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -59,14 +59,14 @@ int of_pci_get_host_bridge_resources(struct device_node *dev,
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
-int of_pci_msi_chip_add(struct msi_chip *chip);
-void of_pci_msi_chip_remove(struct msi_chip *chip);
-struct msi_chip *of_pci_find_msi_chip_by_node(struct device_node *of_node);
+int of_pci_msi_controller_add(struct msi_controller *chip);
+void of_pci_msi_controller_remove(struct msi_controller *chip);
+struct msi_controller *of_pci_find_msi_controller_by_node(struct device_node *of_node);
 #else
-static inline int of_pci_msi_chip_add(struct msi_chip *chip) { return -EINVAL; }
-static inline void of_pci_msi_chip_remove(struct msi_chip *chip) { }
-static inline struct msi_chip *
-of_pci_find_msi_chip_by_node(struct device_node *of_node) { return NULL; }
+static inline int of_pci_msi_controller_add(struct msi_controller *chip) { return -EINVAL; }
+static inline void of_pci_msi_controller_remove(struct msi_controller *chip) { }
+static inline struct msi_controller *
+of_pci_find_msi_controller_by_node(struct device_node *of_node) { return NULL; }
 #endif
 
 #endif
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5be8db4..f9e039f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -449,7 +449,7 @@ struct pci_bus {
 	struct resource busn_res;	/* bus numbers routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
-	struct msi_chip	*msi;		/* MSI controller */
+	struct msi_controller *msi;		/* MSI controller */
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
 
-- 
1.7.1

