Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaIERj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:39:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44063 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIERj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:39:57 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH] PCI: keystone: update to support multiple pci ports
Date: Fri, 5 Sep 2014 13:39:42 -0400
Message-ID: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K2E SoC has two PCI ports. The SATA controller is connected to second
PCI port (port 1). This patch enhances the driver to support multiple
ports.

Update the DT Documentation for the new attribute, ti,pcie-port and
remove the note for bootargs as this is no longer needed.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../devicetree/bindings/pci/pci-keystone.txt       |    8 ++++---
 drivers/pci/host/pci-keystone.c                    |   23 ++++++++++++++------
 drivers/pci/host/pci-keystone.h                    |    4 ++--
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
index ceb3e24..e279143 100644
--- a/Documentation/devicetree/bindings/pci/pci-keystone.txt
+++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
@@ -58,11 +58,13 @@ Optional properties:-
 	phy-names: name of the Generic Keystine SerDes phy for PCI
 	  - If boot loader already does PCI link establishment, then phys and
 	    phy-names shouldn't be present.
+	ti,pcie-port: PCI port number. This is used to configure the PCI port
+	    number. For example K2E SoC supports 2 PCI ports and PCI bindings
+	    for the second port adds ti,pcie-port = <1> to identify second port
+	    and driver uses this to configure the PCI mode register for second
+	    port. If not present, port number 0 is assumed.
 
 Designware DT Properties not applicable for Keystone PCI
 
 1. pcie_bus clock-names not used.  Instead, a phandle to phys is used.
 
-Note for PCI driver usage
-=========================
-Driver requires pci=pcie_bus_perf in the bootargs for proper functioning.
diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
index a132622..b4831e8 100644
--- a/drivers/pci/host/pci-keystone.c
+++ b/drivers/pci/host/pci-keystone.c
@@ -252,8 +252,8 @@ static int keystone_pcie_fault(unsigned long addr, unsigned int fsr,
 
 static void __init ks_pcie_host_init(struct pcie_port *pp)
 {
-	u32 vendor_device_id, val;
 	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u32 val;
 
 	ks_pcie_establish_link(ks_pcie);
 	ks_dw_pcie_setup_rc_app_regs(ks_pcie);
@@ -262,8 +262,7 @@ static void __init ks_pcie_host_init(struct pcie_port *pp)
 			pp->dbi_base + PCI_IO_BASE);
 
 	/* update the Vendor ID */
-	vendor_device_id = readl(ks_pcie->va_reg_pciid);
-	writew((vendor_device_id >> 16), pp->dbi_base + PCI_DEVICE_ID);
+	writew(ks_pcie->device_id, pp->dbi_base + PCI_DEVICE_ID);
 
 	/* update the DEV_STAT_CTRL to publish right mrrs */
 	val = readl(pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
@@ -344,12 +343,13 @@ static int __exit ks_pcie_remove(struct platform_device *pdev)
 static int __init ks_pcie_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct keystone_pcie *ks_pcie;
+	int ret = 0, port_id = 0;
 	struct pcie_port *pp;
 	struct resource *res;
 	void __iomem *reg_p;
 	struct phy *phy;
-	int ret = 0;
 	u32 val;
 
 	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
@@ -360,17 +360,24 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
 	}
 	pp = &ks_pcie->pp;
 
+	/* read the PCI port id */
+	of_property_read_u32(np, "ti,pcie-port", &port_id);
+
 	/* index 2 is the devcfg register for RC mode settings */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	reg_p = devm_ioremap_resource(dev, res);
 	if (IS_ERR(reg_p))
 		return PTR_ERR(reg_p);
 
+
 	/* enable RC mode in devcfg */
 	val = readl(reg_p);
-	val &= ~PCIE_MODE_MASK;
-	val |= PCIE_RC_MODE;
+	port_id <<= 1;
+	val &= ~(PCIE_MODE_MASK << port_id);
+	val |= (PCIE_RC_MODE << port_id);
 	writel(val, reg_p);
+	devm_iounmap(dev, reg_p);
+	devm_release_mem_region(dev, res->start, resource_size(res));
 
 	/* initialize SerDes Phy if present */
 	phy = devm_phy_get(dev, "pcie-phy");
@@ -385,7 +392,9 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
 	reg_p = devm_ioremap_resource(dev, res);
 	if (IS_ERR(reg_p))
 		return PTR_ERR(reg_p);
-	ks_pcie->va_reg_pciid = reg_p;
+	ks_pcie->device_id = readl(reg_p) >> 16;
+	devm_iounmap(dev, reg_p);
+	devm_release_mem_region(dev, res->start, resource_size(res));
 
 	pp->dev = dev;
 	platform_set_drvdata(pdev, ks_pcie);
diff --git a/drivers/pci/host/pci-keystone.h b/drivers/pci/host/pci-keystone.h
index 729ea7d..80cfa8e 100644
--- a/drivers/pci/host/pci-keystone.h
+++ b/drivers/pci/host/pci-keystone.h
@@ -19,8 +19,8 @@
 struct keystone_pcie {
 	struct	clk		*clk;
 	struct	pcie_port	pp;
-	void __iomem		*va_reg_pciid;
-
+	/* PCI Device ID */
+	u32			device_id;
 	int			num_legacy_host_irqs;
 	int			legacy_host_irqs[MAX_LEGACY_HOST_IRQS];
 	struct			device_node *legacy_intc_np;
-- 
1.7.9.5

