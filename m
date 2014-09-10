Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaIJRMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:12:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49821 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaIJRMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:12:52 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bhelgaas@google.com>, <arnd@arndb.de>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 1/2] PCI: keystone: remove handle of PCI mode configuration
Date: Wed, 10 Sep 2014 13:12:38 -0400
Message-ID: <1410369159-11564-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keystone PCI hardware supports both RC and EP modes and devcfg
register has bits to boot strap the device to either of these modes.
It seems proper to add this functionality to the boot loader rather
than in the driver as device will be operating in either mode, not
both any time. Currently the driver supports only RC mode and hence
register configuration in the driver is not needed and driver can
assume this is a RC hardware.

Also update the DT documentation accordingly.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
	v3 - No change
	v2 - Added this separate patch to remove pci mode handling
 .../devicetree/bindings/pci/pci-keystone.txt       |    4 +---
 drivers/pci/host/pci-keystone.c                    |   21 ++------------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
index ceb3e24..bedacf0 100644
--- a/Documentation/devicetree/bindings/pci/pci-keystone.txt
+++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
@@ -13,9 +13,7 @@ Required Properties:-
 
 compatibility: "ti,keystone-pcie"
 reg:	index 1 is the base address and length of DW application registers.
-	index 2 is the base address and length of PCI mode configuration
-	register.
-	index 3 is the base address and length of PCI device ID register.
+	index 2 is the base address and length of PCI device ID register.
 
 pcie_msi_intc : Interrupt controller device node for MSI IRQ chip
 	interrupt-cells: should be set to 1
diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
index ff8ed25..f1119eb 100644
--- a/drivers/pci/host/pci-keystone.c
+++ b/drivers/pci/host/pci-keystone.c
@@ -35,10 +35,6 @@
 #define MAX_MSI_HOST_IRQS		8
 #define MAX_LEGACY_HOST_IRQS		4
 
-/* RC mode settings masks */
-#define PCIE_RC_MODE		BIT(2)
-#define PCIE_MODE_MASK		(BIT(1) | BIT(2))
-
 /* DEV_STAT_CTRL */
 #define PCIE_CAP_BASE		0x70
 
@@ -355,7 +351,6 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
 	void __iomem *reg_p;
 	struct phy *phy;
 	int ret = 0;
-	u32 val;
 
 	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
 				GFP_KERNEL);
@@ -365,18 +360,6 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
 	}
 	pp = &ks_pcie->pp;
 
-	/* index 2 is the devcfg register for RC mode settings */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	reg_p = devm_ioremap_resource(dev, res);
-	if (IS_ERR(reg_p))
-		return PTR_ERR(reg_p);
-
-	/* enable RC mode in devcfg */
-	val = readl(reg_p);
-	val &= ~PCIE_MODE_MASK;
-	val |= PCIE_RC_MODE;
-	writel(val, reg_p);
-
 	/* initialize SerDes Phy if present */
 	phy = devm_phy_get(dev, "pcie-phy");
 	if (!IS_ERR_OR_NULL(phy)) {
@@ -385,8 +368,8 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	/* index 3 is to read PCI DEVICE_ID */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	/* index 2 is to read PCI DEVICE_ID */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	reg_p = devm_ioremap_resource(dev, res);
 	if (IS_ERR(reg_p))
 		return PTR_ERR(reg_p);
-- 
1.7.9.5

