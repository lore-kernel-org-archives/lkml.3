Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3HMM0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:26:18 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41413 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab3HMM0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:26:12 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 3/5] PCI: mvebu: remove subsys_initcall
Date: Tue, 13 Aug 2013 14:25:22 +0200
Message-Id: <1376396724-32048-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the subsys_initcall from the driver and converts it to
a normal platform_driver. Also, drvdata is set and a remove functions
is added to disable the clock and free resources. As pci driver removal
currently is not supported, set .suppress_bind_attrs to permit unbinding.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- do not add .remove and set .suppress_bind_attrs to permit currently
  unsupported driver unloading/unbinding (Reported by Thierry Reding and
  Thomas Petazzoni)
- Note: I left the platform_set_drvdata(), as we will require that later
  for device removal.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/host/pci-mvebu.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index d2e9ae7..bd7092a 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -165,7 +165,7 @@ static void mvebu_pcie_set_local_dev_nr(struct mvebu_pcie_port *port, int nr)
  * BAR[0,2] -> disabled, BAR[1] -> covers all DRAM banks
  * WIN[0-3] -> DRAM bank[0-3]
  */
-static void __init mvebu_pcie_setup_wins(struct mvebu_pcie_port *port)
+static void mvebu_pcie_setup_wins(struct mvebu_pcie_port *port)
 {
 	const struct mbus_dram_target_info *dram;
 	u32 size;
@@ -217,7 +217,7 @@ static void __init mvebu_pcie_setup_wins(struct mvebu_pcie_port *port)
 	       port->base + PCIE_BAR_CTRL_OFF(1));
 }
 
-static void __init mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
+static void mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
 {
 	u16 cmd;
 	u32 mask;
@@ -628,7 +628,7 @@ static struct pci_ops mvebu_pcie_ops = {
 	.write = mvebu_pcie_wr_conf,
 };
 
-static int __init mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
+static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 {
 	struct mvebu_pcie *pcie = sys_to_pcie(sys);
 	int i;
@@ -647,7 +647,7 @@ static int __init mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-static int __init mvebu_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+static int mvebu_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct of_irq oirq;
 	int ret;
@@ -704,7 +704,7 @@ resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
 		return start;
 }
 
-static void __init mvebu_pcie_enable(struct mvebu_pcie *pcie)
+static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
 {
 	struct hw_pci hw;
 
@@ -727,10 +727,8 @@ static void __init mvebu_pcie_enable(struct mvebu_pcie *pcie)
  * <...> property for one that matches the given port/lane. Once
  * found, maps it.
  */
-static void __iomem * __init
-mvebu_pcie_map_registers(struct platform_device *pdev,
-			 struct device_node *np,
-			 struct mvebu_pcie_port *port)
+static void __iomem *mvebu_pcie_map_registers(struct platform_device *pdev,
+		      struct device_node *np, struct mvebu_pcie_port *port)
 {
 	struct resource regs;
 	int ret = 0;
@@ -786,7 +784,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 	return -ENOENT;
 }
 
-static void __init mvebu_pcie_msi_enable(struct mvebu_pcie *pcie)
+static void mvebu_pcie_msi_enable(struct mvebu_pcie *pcie)
 {
 	struct device_node *msi_node;
 
@@ -801,7 +799,7 @@ static void __init mvebu_pcie_msi_enable(struct mvebu_pcie *pcie)
 		pcie->msi->dev = &pcie->pdev->dev;
 }
 
-static int __init mvebu_pcie_probe(struct platform_device *pdev)
+static int mvebu_pcie_probe(struct platform_device *pdev)
 {
 	struct mvebu_pcie *pcie;
 	struct device_node *np = pdev->dev.of_node;
@@ -814,6 +812,7 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pcie->pdev = pdev;
+	platform_set_drvdata(pdev, pcie);
 
 	/* Get the PCIe memory and I/O aperture */
 	mvebu_mbus_get_pcie_mem_aperture(&pcie->mem);
@@ -956,16 +955,12 @@ static struct platform_driver mvebu_pcie_driver = {
 		.name = "mvebu-pcie",
 		.of_match_table =
 		   of_match_ptr(mvebu_pcie_of_match_table),
+		/* driver unloading/unbinding currently not supported */
+		.suppress_bind_attrs = true,
 	},
+	.probe = mvebu_pcie_probe,
 };
-
-static int __init mvebu_pcie_init(void)
-{
-	return platform_driver_probe(&mvebu_pcie_driver,
-				     mvebu_pcie_probe);
-}
-
-subsys_initcall(mvebu_pcie_init);
+module_platform_driver(mvebu_pcie_driver);
 
 MODULE_AUTHOR("Thomas Petazzoni <thomas.petazzoni@free-electrons.com>");
 MODULE_DESCRIPTION("Marvell EBU PCIe driver");
-- 
1.7.10.4

