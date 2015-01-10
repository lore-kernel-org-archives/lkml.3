Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbbAJCgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:36:21 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45264 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbbAJCf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:58 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/16] pci/host: xilinx: convert to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:50 -0600
Message-Id: <1420857290-8373-17-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the Xilinx host PCI driver to use the generic config access
functions.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: "Sören Brinkmann" <soren.brinkmann@xilinx.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/pci/host/pcie-xilinx.c | 88 +++++-------------------------------------
 1 file changed, 9 insertions(+), 79 deletions(-)

diff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c
index ef3ebaf..f67d036 100644
--- a/drivers/pci/host/pcie-xilinx.c
+++ b/drivers/pci/host/pcie-xilinx.c
@@ -189,7 +189,7 @@ static bool xilinx_pcie_valid_device(struct pci_bus *bus, unsigned int devfn)
 }
 
 /**
- * xilinx_pcie_config_base - Get configuration base
+ * xilinx_pcie_map_bus - Get configuration base
  * @bus: PCI Bus structure
  * @devfn: Device/function
  * @where: Offset from base
@@ -197,96 +197,26 @@ static bool xilinx_pcie_valid_device(struct pci_bus *bus, unsigned int devfn)
  * Return: Base address of the configuration space needed to be
  *	   accessed.
  */
-static void __iomem *xilinx_pcie_config_base(struct pci_bus *bus,
-					     unsigned int devfn, int where)
+static void __iomem *xilinx_pcie_map_bus(struct pci_bus *bus,
+					 unsigned int devfn, int where)
 {
 	struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
 	int relbus;
 
+	if (!xilinx_pcie_valid_device(bus, devfn))
+		return NULL;
+
 	relbus = (bus->number << ECAM_BUS_NUM_SHIFT) |
 		 (devfn << ECAM_DEV_NUM_SHIFT);
 
 	return port->reg_base + relbus + where;
 }
 
-/**
- * xilinx_pcie_read_config - Read configuration space
- * @bus: PCI Bus structure
- * @devfn: Device/function
- * @where: Offset from base
- * @size: Byte/word/dword
- * @val: Value to be read
- *
- * Return: PCIBIOS_SUCCESSFUL on success
- *	   PCIBIOS_DEVICE_NOT_FOUND on failure
- */
-static int xilinx_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
-				   int where, int size, u32 *val)
-{
-	void __iomem *addr;
-
-	if (!xilinx_pcie_valid_device(bus, devfn)) {
-		*val = 0xFFFFFFFF;
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-
-	addr = xilinx_pcie_config_base(bus, devfn, where);
-
-	switch (size) {
-	case 1:
-		*val = readb(addr);
-		break;
-	case 2:
-		*val = readw(addr);
-		break;
-	default:
-		*val = readl(addr);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-/**
- * xilinx_pcie_write_config - Write configuration space
- * @bus: PCI Bus structure
- * @devfn: Device/function
- * @where: Offset from base
- * @size: Byte/word/dword
- * @val: Value to be written to device
- *
- * Return: PCIBIOS_SUCCESSFUL on success
- *	   PCIBIOS_DEVICE_NOT_FOUND on failure
- */
-static int xilinx_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
-				    int where, int size, u32 val)
-{
-	void __iomem *addr;
-
-	if (!xilinx_pcie_valid_device(bus, devfn))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	addr = xilinx_pcie_config_base(bus, devfn, where);
-
-	switch (size) {
-	case 1:
-		writeb(val, addr);
-		break;
-	case 2:
-		writew(val, addr);
-		break;
-	default:
-		writel(val, addr);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
 /* PCIe operations */
 static struct pci_ops xilinx_pcie_ops = {
-	.read  = xilinx_pcie_read_config,
-	.write = xilinx_pcie_write_config,
+	.map_bus = xilinx_pcie_map_bus,
+	.read	= pci_generic_config_read,
+	.write	= pci_generic_config_write,
 };
 
 /* MSI functions */
-- 
2.1.0

