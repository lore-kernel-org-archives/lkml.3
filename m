Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3CVIw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:52:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3CVIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:51:53 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/2] PCI: tegra: Use new MSI chip infrastructure
Date: Fri, 22 Mar 2013 09:51:47 +0100
Message-Id: <1363942307-9327-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:nNgJmP2ZIAnwIzatTatzu779xZC1XsmUnN2bLYV4k7l
 5wn429pgYxdXFq7nRMvfTw+3W/FJPr7Nt8QEk3KpLHOnlOyj6r
 aEOiiQgh3fo6TMBWNIOm2RQnKXHCRXdLh8j6+EeY8agcpKnxSq
 oUsP0R/r5dzNmxJ9PdBqoFB2bb2LFSccO8NFjXclsmX7WCSDoi
 SUxkVN+Qmz609dctzlk/Fyum5rggoazenxk8etHQvwGv3yOHkp
 jkvD75k+XA1LnlPKrYREeUYovM71hQiXGj92UK++3wUvV9CbKv
 SyJ3Bv+isAjh+PC1urTAiBM+1dfONaayLs77BdeTGVf3t3SQpV
 uN3XlnUjkHNL1mXKXn2/T2DGuV0Vq2oQFTA3ox0BmjMVu9DCDp
 z91zPAr6QufOORSxwbjWW439nXkbMr6vgPaUZoZ8PXdp/0LMji
 m21ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement an MSI chip that uses the Tegra PCIe controller's built-in
support to provide MSI services to the root bus and its children.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pci/host/pci-tegra.c | 105 ++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 45 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 1efd746..19c250f 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -183,14 +183,20 @@
 #define  PADS_PLL_CTL_TXCLKREF_DIV10		(0 << 20)
 #define  PADS_PLL_CTL_TXCLKREF_DIV5		(1 << 20)
 
-struct tegra_pcie_msi {
+struct tegra_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
+	struct msi_chip chip;
 	unsigned long pages;
 	struct mutex lock;
 	int irq;
 };
 
+static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
+{
+	return container_of(chip, struct tegra_msi, chip);
+}
+
 struct tegra_pcie {
 	struct device *dev;
 
@@ -211,7 +217,7 @@ struct tegra_pcie {
 	struct clk *pcie_xclk;
 	struct clk *pll_e;
 
-	struct tegra_pcie_msi msi;
+	struct tegra_msi msi;
 
 	struct list_head ports;
 	unsigned int num_ports;
@@ -605,6 +611,9 @@ static struct pci_bus *tegra_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	if (!bus)
 		return NULL;
 
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		bus->msi = &pcie->msi.chip;
+
 	pci_scan_child_bus(bus);
 
 	return bus;
@@ -1001,38 +1010,41 @@ static int tegra_pcie_put_resources(struct tegra_pcie *pcie)
 	return 0;
 }
 
-static int tegra_pcie_msi_alloc(struct tegra_pcie *pcie)
+static int tegra_msi_alloc(struct tegra_msi *chip)
 {
 	int msi;
 
-	mutex_lock(&pcie->msi.lock);
+	mutex_lock(&chip->lock);
 
-	msi = find_first_zero_bit(pcie->msi.used, INT_PCI_MSI_NR);
+	msi = find_first_zero_bit(chip->used, INT_PCI_MSI_NR);
 	if (msi < INT_PCI_MSI_NR)
-		set_bit(msi, pcie->msi.used);
+		set_bit(msi, chip->used);
 	else
 		msi = -ENOSPC;
 
-	mutex_unlock(&pcie->msi.lock);
+	mutex_unlock(&chip->lock);
 
 	return msi;
 }
 
-static void tegra_pcie_msi_free(struct tegra_pcie *pcie, unsigned long irq)
+static void tegra_msi_free(struct tegra_msi *chip, unsigned long irq)
 {
-	mutex_lock(&pcie->msi.lock);
+	struct device *dev = chip->chip.dev;
+
+	mutex_lock(&chip->lock);
 
-	if (!test_bit(irq, pcie->msi.used))
-		dev_err(pcie->dev, "trying to free unused MSI#%lu\n", irq);
+	if (!test_bit(irq, chip->used))
+		dev_err(dev, "trying to free unused MSI#%lu\n", irq);
 	else
-		clear_bit(irq, pcie->msi.used);
+		clear_bit(irq, chip->used);
 
-	mutex_unlock(&pcie->msi.lock);
+	mutex_unlock(&chip->lock);
 }
 
 static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
 {
 	struct tegra_pcie *pcie = data;
+	struct tegra_msi *msi = &pcie->msi;
 	unsigned int i;
 
 	for (i = 0; i < 8; i++) {
@@ -1046,9 +1058,9 @@ static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
 			/* clear the interrupt */
 			afi_writel(pcie, 1 << offset, AFI_MSI_VEC0 + i * 4);
 
-			irq = irq_find_mapping(pcie->msi.domain, index);
+			irq = irq_find_mapping(msi->domain, index);
 			if (irq) {
-				if (test_bit(index, pcie->msi.used))
+				if (test_bit(index, msi->used))
 					generic_handle_irq(irq);
 				else
 					dev_info(pcie->dev, "unhandled MSI\n");
@@ -1068,20 +1080,20 @@ static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_PCI_MSI
-/* called by arch_setup_msi_irqs in drivers/pci/msi.c */
-int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+			       struct msi_desc *desc)
 {
-	struct tegra_pcie *pcie = sys_to_pcie(pdev->bus->sysdata);
+	struct tegra_msi *msi = to_tegra_msi(chip);
+	struct tegra_pcie *pcie = container_of(chip, struct tegra_pcie, msi.chip);
 	struct msi_msg msg;
 	unsigned int irq;
 	int hwirq;
 
-	hwirq = tegra_pcie_msi_alloc(pcie);
+	hwirq = tegra_msi_alloc(msi);
 	if (hwirq < 0)
 		return hwirq;
 
-	irq = irq_create_mapping(pcie->msi.domain, hwirq);
+	irq = irq_create_mapping(msi->domain, hwirq);
 	if (!irq)
 		return -EINVAL;
 
@@ -1097,16 +1109,15 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	return 0;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+static void tegra_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
 {
-	struct tegra_pcie *pcie = irq_get_chip_data(irq);
+	struct tegra_msi *msi = to_tegra_msi(chip);
 	struct irq_data *d = irq_get_irq_data(irq);
 
-	tegra_pcie_msi_free(pcie, d->hwirq);
+	tegra_msi_free(msi, d->hwirq);
 }
-#endif
 
-static struct irq_chip tegra_pcie_msi_irq_chip = {
+static struct irq_chip tegra_msi_irq_chip = {
 	.name = "Tegra PCIe MSI",
 	.irq_enable = unmask_msi_irq,
 	.irq_disable = mask_msi_irq,
@@ -1114,11 +1125,10 @@ static struct irq_chip tegra_pcie_msi_irq_chip = {
 	.irq_unmask = unmask_msi_irq,
 };
 
-static int tegra_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
-			      irq_hw_number_t hwirq)
+static int tegra_msi_map(struct irq_domain *domain, unsigned int irq,
+			 irq_hw_number_t hwirq)
 {
-	irq_set_chip_and_handler(irq, &tegra_pcie_msi_irq_chip,
-				 handle_simple_irq);
+	irq_set_chip_and_handler(irq, &tegra_msi_irq_chip, handle_simple_irq);
 	irq_set_chip_data(irq, domain->host_data);
 	set_irq_flags(irq, IRQF_VALID);
 
@@ -1126,22 +1136,26 @@ static int tegra_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
 }
 
 static const struct irq_domain_ops msi_domain_ops = {
-	.map = tegra_pcie_msi_map,
+	.map = tegra_msi_map,
 };
 
 static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 {
 	struct platform_device *pdev = to_platform_device(pcie->dev);
+	struct tegra_msi *msi = &pcie->msi;
 	unsigned long base;
 	int err;
 	u32 reg;
 
-	mutex_init(&pcie->msi.lock);
+	mutex_init(&msi->lock);
+
+	msi->chip.dev = pcie->dev;
+	msi->chip.setup_irq = tegra_msi_setup_irq;
+	msi->chip.teardown_irq = tegra_msi_teardown_irq;
 
-	pcie->msi.domain = irq_domain_add_linear(pcie->dev->of_node,
-						 INT_PCI_MSI_NR,
-						 &msi_domain_ops, pcie);
-	if (!pcie->msi.domain) {
+	msi->domain = irq_domain_add_linear(pcie->dev->of_node, INT_PCI_MSI_NR,
+					    &msi_domain_ops, &msi->chip);
+	if (!msi->domain) {
 		dev_err(&pdev->dev, "failed to create IRQ domain\n");
 		return -ENOMEM;
 	}
@@ -1152,18 +1166,18 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 		goto err;
 	}
 
-	pcie->msi.irq = err;
+	msi->irq = err;
 
-	err = devm_request_irq(&pdev->dev, pcie->msi.irq, tegra_pcie_msi_irq,
-			       0, tegra_pcie_msi_irq_chip.name, pcie);
+	err = devm_request_irq(&pdev->dev, msi->irq, tegra_pcie_msi_irq,
+			       0, tegra_msi_irq_chip.name, pcie);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to request IRQ: %d\n", err);
 		goto err;
 	}
 
 	/* setup AFI/FPCI range */
-	pcie->msi.pages = __get_free_pages(GFP_KERNEL, 3);
-	base = virt_to_phys((void *)pcie->msi.pages);
+	msi->pages = __get_free_pages(GFP_KERNEL, 3);
+	base = virt_to_phys((void *)msi->pages);
 
 	afi_writel(pcie, base, AFI_MSI_FPCI_BAR_ST);
 	afi_writel(pcie, base, AFI_MSI_AXI_BAR_ST);
@@ -1188,12 +1202,13 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 	return 0;
 
 err:
-	irq_domain_remove(pcie->msi.domain);
+	irq_domain_remove(msi->domain);
 	return err;
 }
 
 static int tegra_pcie_disable_msi(struct tegra_pcie *pcie)
 {
+	struct tegra_msi *msi = &pcie->msi;
 	unsigned int i, irq;
 	u32 value;
 
@@ -1212,15 +1227,15 @@ static int tegra_pcie_disable_msi(struct tegra_pcie *pcie)
 	afi_writel(pcie, 0, AFI_MSI_EN_VEC6);
 	afi_writel(pcie, 0, AFI_MSI_EN_VEC7);
 
-	free_pages(pcie->msi.pages, 3);
+	free_pages(msi->pages, 3);
 
 	for (i = 0; i < INT_PCI_MSI_NR; i++) {
-		irq = irq_find_mapping(pcie->msi.domain, i);
+		irq = irq_find_mapping(msi->domain, i);
 		if (irq > 0)
 			irq_dispose_mapping(irq);
 	}
 
-	irq_domain_remove(pcie->msi.domain);
+	irq_domain_remove(msi->domain);
 
 	return 0;
 }
-- 
1.8.1.5

