Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaIIURc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:17:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51782 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbaIIURb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:17:31 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bhelgaas@google.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v2 2/2] PCI: keystone: update to support multiple pci ports
Date: Tue, 9 Sep 2014 16:17:15 -0400
Message-ID: <1410293835-13050-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com>
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com>
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
---
 - updated based on comment against v1
 .../devicetree/bindings/pci/pci-keystone.txt       |    8 +++++---
 drivers/pci/host/pci-keystone.c                    |   15 ++++++++++-----
 drivers/pci/host/pci-keystone.h                    |    4 ++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
index bedacf0..c8f5773 100644
--- a/Documentation/devicetree/bindings/pci/pci-keystone.txt
+++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
@@ -56,11 +56,13 @@ Optional properties:-
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
index f1119eb..893820d 100644
--- a/drivers/pci/host/pci-keystone.c
+++ b/drivers/pci/host/pci-keystone.c
@@ -253,8 +253,8 @@ static int keystone_pcie_fault(unsigned long addr, unsigned int fsr,
 
 static void __init ks_pcie_host_init(struct pcie_port *pp)
 {
-	u32 vendor_device_id, val;
 	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
+	u32 val;
 
 	ks_pcie_establish_link(ks_pcie);
 	ks_dw_pcie_setup_rc_app_regs(ks_pcie);
@@ -263,8 +263,7 @@ static void __init ks_pcie_host_init(struct pcie_port *pp)
 			pp->dbi_base + PCI_IO_BASE);
 
 	/* update the Vendor ID */
-	vendor_device_id = readl(ks_pcie->va_reg_pciid);
-	writew((vendor_device_id >> 16), pp->dbi_base + PCI_DEVICE_ID);
+	writew(ks_pcie->device_id, pp->dbi_base + PCI_DEVICE_ID);
 
 	/* update the DEV_STAT_CTRL to publish right mrrs */
 	val = readl(pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
@@ -345,12 +344,13 @@ static int __exit ks_pcie_remove(struct platform_device *pdev)
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
 
 	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
 				GFP_KERNEL);
@@ -360,6 +360,9 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
 	}
 	pp = &ks_pcie->pp;
 
+	/* read the PCI port id */
+	of_property_read_u32(np, "ti,pcie-port", &port_id);
+
 	/* initialize SerDes Phy if present */
 	phy = devm_phy_get(dev, "pcie-phy");
 	if (!IS_ERR_OR_NULL(phy)) {
@@ -373,7 +376,9 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
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

