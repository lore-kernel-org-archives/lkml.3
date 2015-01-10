Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbbAJCgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:36:00 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58319 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbbAJCf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:56 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/16] pci/host: xgene: convert to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:49 -0600
Message-Id: <1420857290-8373-16-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the xgene host PCI driver to use the generic config access
functions.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/pci/host/pci-xgene.c | 150 +++----------------------------------------
 1 file changed, 9 insertions(+), 141 deletions(-)

diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
index b1d0596..ee6a3d3 100644
--- a/drivers/pci/host/pci-xgene.c
+++ b/drivers/pci/host/pci-xgene.c
@@ -74,92 +74,6 @@ static inline u32 pcie_bar_low_val(u32 addr, u32 flags)
 	return (addr & PCI_BASE_ADDRESS_MEM_MASK) | flags;
 }
 
-/* PCIe Configuration Out/In */
-static inline void xgene_pcie_cfg_out32(void __iomem *addr, int offset, u32 val)
-{
-	writel(val, addr + offset);
-}
-
-static inline void xgene_pcie_cfg_out16(void __iomem *addr, int offset, u16 val)
-{
-	u32 val32 = readl(addr + (offset & ~0x3));
-
-	switch (offset & 0x3) {
-	case 2:
-		val32 &= ~0xFFFF0000;
-		val32 |= (u32)val << 16;
-		break;
-	case 0:
-	default:
-		val32 &= ~0xFFFF;
-		val32 |= val;
-		break;
-	}
-	writel(val32, addr + (offset & ~0x3));
-}
-
-static inline void xgene_pcie_cfg_out8(void __iomem *addr, int offset, u8 val)
-{
-	u32 val32 = readl(addr + (offset & ~0x3));
-
-	switch (offset & 0x3) {
-	case 0:
-		val32 &= ~0xFF;
-		val32 |= val;
-		break;
-	case 1:
-		val32 &= ~0xFF00;
-		val32 |= (u32)val << 8;
-		break;
-	case 2:
-		val32 &= ~0xFF0000;
-		val32 |= (u32)val << 16;
-		break;
-	case 3:
-	default:
-		val32 &= ~0xFF000000;
-		val32 |= (u32)val << 24;
-		break;
-	}
-	writel(val32, addr + (offset & ~0x3));
-}
-
-static inline void xgene_pcie_cfg_in32(void __iomem *addr, int offset, u32 *val)
-{
-	*val = readl(addr + offset);
-}
-
-static inline void xgene_pcie_cfg_in16(void __iomem *addr, int offset, u32 *val)
-{
-	*val = readl(addr + (offset & ~0x3));
-
-	switch (offset & 0x3) {
-	case 2:
-		*val >>= 16;
-		break;
-	}
-
-	*val &= 0xFFFF;
-}
-
-static inline void xgene_pcie_cfg_in8(void __iomem *addr, int offset, u32 *val)
-{
-	*val = readl(addr + (offset & ~0x3));
-
-	switch (offset & 0x3) {
-	case 3:
-		*val = *val >> 24;
-		break;
-	case 2:
-		*val = *val >> 16;
-		break;
-	case 1:
-		*val = *val >> 8;
-		break;
-	}
-	*val &= 0xFF;
-}
-
 /*
  * When the address bit [17:16] is 2'b01, the Configuration access will be
  * treated as Type 1 and it will be forwarded to external PCIe device.
@@ -213,69 +127,23 @@ static bool xgene_pcie_hide_rc_bars(struct pci_bus *bus, int offset)
 	return false;
 }
 
-static int xgene_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
-				  int offset, int len, u32 *val)
-{
-	struct xgene_pcie_port *port = bus->sysdata;
-	void __iomem *addr;
-
-	if ((pci_is_root_bus(bus) && devfn != 0) || !port->link_up)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	if (xgene_pcie_hide_rc_bars(bus, offset)) {
-		*val = 0;
-		return PCIBIOS_SUCCESSFUL;
-	}
-
-	xgene_pcie_set_rtdid_reg(bus, devfn);
-	addr = xgene_pcie_get_cfg_base(bus);
-	switch (len) {
-	case 1:
-		xgene_pcie_cfg_in8(addr, offset, val);
-		break;
-	case 2:
-		xgene_pcie_cfg_in16(addr, offset, val);
-		break;
-	default:
-		xgene_pcie_cfg_in32(addr, offset, val);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int xgene_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
-				   int offset, int len, u32 val)
+static int xgene_pcie_map_bus(struct pci_bus *bus, unsigned int devfn,
+			      int offset)
 {
 	struct xgene_pcie_port *port = bus->sysdata;
-	void __iomem *addr;
 
-	if ((pci_is_root_bus(bus) && devfn != 0) || !port->link_up)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	if (xgene_pcie_hide_rc_bars(bus, offset))
-		return PCIBIOS_SUCCESSFUL;
+	if ((pci_is_root_bus(bus) && devfn != 0) || !port->link_up ||
+	    xgene_pcie_hide_rc_bars(bus, offset))
+		return NULL;
 
 	xgene_pcie_set_rtdid_reg(bus, devfn);
-	addr = xgene_pcie_get_cfg_base(bus);
-	switch (len) {
-	case 1:
-		xgene_pcie_cfg_out8(addr, offset, (u8)val);
-		break;
-	case 2:
-		xgene_pcie_cfg_out16(addr, offset, (u16)val);
-		break;
-	default:
-		xgene_pcie_cfg_out32(addr, offset, val);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
+	return xgene_pcie_get_cfg_base(bus);
 }
 
 static struct pci_ops xgene_pcie_ops = {
-	.read = xgene_pcie_read_config,
-	.write = xgene_pcie_write_config
+	.map_bus = xgene_pcie_map_bus,
+	.read = pci_generic_config_read32,
+	.write = pci_generic_config_write32,
 };
 
 static u64 xgene_pcie_set_ib_mask(void __iomem *csr_base, u32 addr,
-- 
2.1.0

