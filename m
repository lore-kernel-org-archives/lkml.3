Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbbAJChm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:37:42 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:44514 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbbAJCfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:47 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 11/16] powerpc: powermac: convert PCI to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:45 -0600
Message-Id: <1420857290-8373-12-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the powermac PCI driver to use the generic config access functions.

This changes accesses from (in|out)_(8|le16|le32) to readX/writeX
variants. I believe these should be equivalent for PCI config space
accesses, but confirmation would be nice.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/powermac/pci.c | 209 +++++++---------------------------
 1 file changed, 39 insertions(+), 170 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index 04702db..f4071a6 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -133,17 +133,23 @@ static void __init fixup_bus_range(struct device_node *bridge)
 	|(((unsigned int)(off)) & 0xFCUL) \
 	|1UL)
 
-static volatile void __iomem *macrisc_cfg_access(struct pci_controller* hose,
-					       u8 bus, u8 dev_fn, u8 offset)
+static void __iomem *macrisc_cfg_map_bus(struct pci_bus *bus,
+					 unsigned int dev_fn,
+					 int offset)
 {
 	unsigned int caddr;
+	struct pci_controller *hose;
 
-	if (bus == hose->first_busno) {
+	hose = pci_bus_to_host(bus);
+	if (hose == NULL)
+		return NULL;
+
+	if (bus->number == hose->first_busno) {
 		if (dev_fn < (11 << 3))
 			return NULL;
 		caddr = MACRISC_CFA0(dev_fn, offset);
 	} else
-		caddr = MACRISC_CFA1(bus, dev_fn, offset);
+		caddr = MACRISC_CFA1(bus->number, dev_fn, offset);
 
 	/* Uninorth will return garbage if we don't read back the value ! */
 	do {
@@ -154,129 +160,46 @@ static volatile void __iomem *macrisc_cfg_access(struct pci_controller* hose,
 	return hose->cfg_data + offset;
 }
 
-static int macrisc_read_config(struct pci_bus *bus, unsigned int devfn,
-				      int offset, int len, u32 *val)
-{
-	struct pci_controller *hose;
-	volatile void __iomem *addr;
-
-	hose = pci_bus_to_host(bus);
-	if (hose == NULL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	if (offset >= 0x100)
-		return  PCIBIOS_BAD_REGISTER_NUMBER;
-	addr = macrisc_cfg_access(hose, bus->number, devfn, offset);
-	if (!addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	/*
-	 * Note: the caller has already checked that offset is
-	 * suitably aligned and that len is 1, 2 or 4.
-	 */
-	switch (len) {
-	case 1:
-		*val = in_8(addr);
-		break;
-	case 2:
-		*val = in_le16(addr);
-		break;
-	default:
-		*val = in_le32(addr);
-		break;
-	}
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int macrisc_write_config(struct pci_bus *bus, unsigned int devfn,
-				       int offset, int len, u32 val)
-{
-	struct pci_controller *hose;
-	volatile void __iomem *addr;
-
-	hose = pci_bus_to_host(bus);
-	if (hose == NULL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	if (offset >= 0x100)
-		return  PCIBIOS_BAD_REGISTER_NUMBER;
-	addr = macrisc_cfg_access(hose, bus->number, devfn, offset);
-	if (!addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	/*
-	 * Note: the caller has already checked that offset is
-	 * suitably aligned and that len is 1, 2 or 4.
-	 */
-	switch (len) {
-	case 1:
-		out_8(addr, val);
-		break;
-	case 2:
-		out_le16(addr, val);
-		break;
-	default:
-		out_le32(addr, val);
-		break;
-	}
-	return PCIBIOS_SUCCESSFUL;
-}
-
 static struct pci_ops macrisc_pci_ops =
 {
-	.read = macrisc_read_config,
-	.write = macrisc_write_config,
+	.map_bus = macrisc_cfg_map_bus,
+	.read = pci_generic_config_read,
+	.write = pci_generic_config_write,
 };
 
 #ifdef CONFIG_PPC32
 /*
  * Verify that a specific (bus, dev_fn) exists on chaos
  */
-static int chaos_validate_dev(struct pci_bus *bus, int devfn, int offset)
+static void __iomem *chaos_map_bus(struct pci_bus *bus, unsigned int devfn,
+				   int offset)
 {
 	struct device_node *np;
 	const u32 *vendor, *device;
 
 	if (offset >= 0x100)
-		return  PCIBIOS_BAD_REGISTER_NUMBER;
+		return NULL;
 	np = of_pci_find_child_device(bus->dev.of_node, devfn);
 	if (np == NULL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
+		return NULL;
 
 	vendor = of_get_property(np, "vendor-id", NULL);
 	device = of_get_property(np, "device-id", NULL);
 	if (vendor == NULL || device == NULL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
+		return NULL;
 
 	if ((*vendor == 0x106b) && (*device == 3) && (offset >= 0x10)
 	    && (offset != 0x14) && (offset != 0x18) && (offset <= 0x24))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	return PCIBIOS_SUCCESSFUL;
-}
+		return NULL;
 
-static int
-chaos_read_config(struct pci_bus *bus, unsigned int devfn, int offset,
-		  int len, u32 *val)
-{
-	int result = chaos_validate_dev(bus, devfn, offset);
-	if (result == PCIBIOS_BAD_REGISTER_NUMBER)
-		*val = ~0U;
-	if (result != PCIBIOS_SUCCESSFUL)
-		return result;
-	return macrisc_read_config(bus, devfn, offset, len, val);
-}
-
-static int
-chaos_write_config(struct pci_bus *bus, unsigned int devfn, int offset,
-		   int len, u32 val)
-{
-	int result = chaos_validate_dev(bus, devfn, offset);
-	if (result != PCIBIOS_SUCCESSFUL)
-		return result;
-	return macrisc_write_config(bus, devfn, offset, len, val);
+	return macrisc_cfg_map_bus(bus, devfn, offset);
 }
 
 static struct pci_ops chaos_pci_ops =
 {
-	.read = chaos_read_config,
-	.write = chaos_write_config,
+	.map_bus = chaos_map_bus,
+	.read = pci_generic_config_read,
+	.write = pci_generic_config_write,
 };
 
 static void __init setup_chaos(struct pci_controller *hose,
@@ -471,15 +394,24 @@ static struct pci_ops u3_ht_pci_ops =
 	 |(((unsigned int)(off)) & 0xfcU)	\
 	 |1UL)
 
-static volatile void __iomem *u4_pcie_cfg_access(struct pci_controller* hose,
-					u8 bus, u8 dev_fn, int offset)
+static void __iomem *u4_pcie_cfg_map_bus(struct pci_bus *bus,
+					 unsigned int dev_fn,
+					 int offset)
 {
+	struct pci_controller *hose;
 	unsigned int caddr;
 
-	if (bus == hose->first_busno) {
+	if (offset >= 0x1000)
+		return NULL;
+
+	hose = pci_bus_to_host(bus);
+	if (!hose)
+		return NULL;
+
+	if (bus->number == hose->first_busno) {
 		caddr = U4_PCIE_CFA0(dev_fn, offset);
 	} else
-		caddr = U4_PCIE_CFA1(bus, dev_fn, offset);
+		caddr = U4_PCIE_CFA1(bus->number, dev_fn, offset);
 
 	/* Uninorth will return garbage if we don't read back the value ! */
 	do {
@@ -490,74 +422,11 @@ static volatile void __iomem *u4_pcie_cfg_access(struct pci_controller* hose,
 	return hose->cfg_data + offset;
 }
 
-static int u4_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
-			       int offset, int len, u32 *val)
-{
-	struct pci_controller *hose;
-	volatile void __iomem *addr;
-
-	hose = pci_bus_to_host(bus);
-	if (hose == NULL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	if (offset >= 0x1000)
-		return  PCIBIOS_BAD_REGISTER_NUMBER;
-	addr = u4_pcie_cfg_access(hose, bus->number, devfn, offset);
-	if (!addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	/*
-	 * Note: the caller has already checked that offset is
-	 * suitably aligned and that len is 1, 2 or 4.
-	 */
-	switch (len) {
-	case 1:
-		*val = in_8(addr);
-		break;
-	case 2:
-		*val = in_le16(addr);
-		break;
-	default:
-		*val = in_le32(addr);
-		break;
-	}
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int u4_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
-				int offset, int len, u32 val)
-{
-	struct pci_controller *hose;
-	volatile void __iomem *addr;
-
-	hose = pci_bus_to_host(bus);
-	if (hose == NULL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	if (offset >= 0x1000)
-		return  PCIBIOS_BAD_REGISTER_NUMBER;
-	addr = u4_pcie_cfg_access(hose, bus->number, devfn, offset);
-	if (!addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	/*
-	 * Note: the caller has already checked that offset is
-	 * suitably aligned and that len is 1, 2 or 4.
-	 */
-	switch (len) {
-	case 1:
-		out_8(addr, val);
-		break;
-	case 2:
-		out_le16(addr, val);
-		break;
-	default:
-		out_le32(addr, val);
-		break;
-	}
-	return PCIBIOS_SUCCESSFUL;
-}
-
 static struct pci_ops u4_pcie_pci_ops =
 {
-	.read = u4_pcie_read_config,
-	.write = u4_pcie_write_config,
+	.map_bus = u4_pcie_cfg_map_bus,
+	.read = pci_generic_config_read,
+	.write = pci_generic_config_write,
 };
 
 static void pmac_pci_fixup_u4_of_node(struct pci_dev *dev)
-- 
2.1.0

