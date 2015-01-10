Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbbAJCfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:35:42 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:49308 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbbAJCfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:39 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/16] ARM: cns3xxx: convert PCI to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:40 -0600
Message-Id: <1420857290-8373-7-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the cns3xxx PCI driver to use the generic config access functions.

This changes accesses from __raw_readl/__raw_writel to readl/writel.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Krzysztof Halasa <khalasa@piap.pl>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-cns3xxx/pcie.c | 52 +++++++++-----------------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-cns3xxx/pcie.c b/arch/arm/mach-cns3xxx/pcie.c
index 45d6bd0..19b4e20 100644
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -54,8 +54,8 @@ static struct cns3xxx_pcie *pbus_to_cnspci(struct pci_bus *bus)
 	return sysdata_to_cnspci(bus->sysdata);
 }
 
-static void __iomem *cns3xxx_pci_cfg_base(struct pci_bus *bus,
-				  unsigned int devfn, int where)
+static void __iomem *cns3xxx_pci_map_bus(struct pci_bus *bus,
+					 unsigned int devfn, int where)
 {
 	struct cns3xxx_pcie *cnspci = pbus_to_cnspci(bus);
 	int busno = bus->number;
@@ -91,55 +91,22 @@ static void __iomem *cns3xxx_pci_cfg_base(struct pci_bus *bus,
 static int cns3xxx_pci_read_config(struct pci_bus *bus, unsigned int devfn,
 				   int where, int size, u32 *val)
 {
-	u32 v;
-	void __iomem *base;
+	int ret;
 	u32 mask = (0x1ull << (size * 8)) - 1;
 	int shift = (where % 4) * 8;
 
-	base = cns3xxx_pci_cfg_base(bus, devfn, where);
-	if (!base) {
-		*val = 0xffffffff;
-		return PCIBIOS_SUCCESSFUL;
-	}
-
-	v = __raw_readl(base);
+	ret = pci_generic_config_read32(bus, devfn, where, size, val);
 
-	if (bus->number == 0 && devfn == 0 &&
-			(where & 0xffc) == PCI_CLASS_REVISION) {
+	if (ret == PCIBIOS_SUCCESSFUL && !bus->number && !devfn &&
+	    (where & 0xffc) == PCI_CLASS_REVISION)
 		/*
 		 * RC's class is 0xb, but Linux PCI driver needs 0x604
 		 * for a PCIe bridge. So we must fixup the class code
 		 * to 0x604 here.
 		 */
-		v &= 0xff;
-		v |= 0x604 << 16;
-	}
-
-	*val = (v >> shift) & mask;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int cns3xxx_pci_write_config(struct pci_bus *bus, unsigned int devfn,
-				    int where, int size, u32 val)
-{
-	u32 v;
-	void __iomem *base;
-	u32 mask = (0x1ull << (size * 8)) - 1;
-	int shift = (where % 4) * 8;
-
-	base = cns3xxx_pci_cfg_base(bus, devfn, where);
-	if (!base)
-		return PCIBIOS_SUCCESSFUL;
-
-	v = __raw_readl(base);
-
-	v &= ~(mask << shift);
-	v |= (val & mask) << shift;
-
-	__raw_writel(v, base);
+		*val = (((((*val << shift) & 0xff) | (0x604 << 16)) >> shift) & mask;
 
-	return PCIBIOS_SUCCESSFUL;
+	return ret;
 }
 
 static int cns3xxx_pci_setup(int nr, struct pci_sys_data *sys)
@@ -158,8 +125,9 @@ static int cns3xxx_pci_setup(int nr, struct pci_sys_data *sys)
 }
 
 static struct pci_ops cns3xxx_pcie_ops = {
+	.map_bus = cns3xxx_pci_map_bus,
 	.read = cns3xxx_pci_read_config,
-	.write = cns3xxx_pci_write_config,
+	.write = pci_generic_config_write,
 };
 
 static int cns3xxx_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
-- 
2.1.0

