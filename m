Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbbAJCh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:37:58 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61935 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbbAJCfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:46 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 10/16] powerpc: fsl_pci: convert PCI to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:44 -0600
Message-Id: <1420857290-8373-11-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the fsl_pci driver to use the generic config access functions.

This changes accesses from (in|out)_(8|le16|le32) to readX/writeX
variants. I believe these should be equivalent for PCI config space
accesses, but confirmation would be nice.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/sysdev/fsl_pci.c | 46 +++----------------------------------------
 1 file changed, 3 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 6455c1e..271b67e 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -645,61 +645,21 @@ mapped:
 	return pcie->cfg_type1 + offset;
 }
 
-static int mpc83xx_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
-				    int offset, int len, u32 *val)
-{
-	void __iomem *cfg_addr;
-
-	cfg_addr = mpc83xx_pcie_remap_cfg(bus, devfn, offset);
-	if (!cfg_addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	switch (len) {
-	case 1:
-		*val = in_8(cfg_addr);
-		break;
-	case 2:
-		*val = in_le16(cfg_addr);
-		break;
-	default:
-		*val = in_le32(cfg_addr);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
 static int mpc83xx_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
 				     int offset, int len, u32 val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	void __iomem *cfg_addr;
-
-	cfg_addr = mpc83xx_pcie_remap_cfg(bus, devfn, offset);
-	if (!cfg_addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	/* PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS */
 	if (offset == PCI_PRIMARY_BUS && bus->number == hose->first_busno)
 		val &= 0xffffff00;
 
-	switch (len) {
-	case 1:
-		out_8(cfg_addr, val);
-		break;
-	case 2:
-		out_le16(cfg_addr, val);
-		break;
-	default:
-		out_le32(cfg_addr, val);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
+	return pci_generic_config_write(bus, devfn, offset, len, val);
 }
 
 static struct pci_ops mpc83xx_pcie_ops = {
-	.read = mpc83xx_pcie_read_config,
+	.map_bus = mpc83xx_pcie_remap_cfg,
+	.read = pci_generic_config_read,
 	.write = mpc83xx_pcie_write_config,
 };
 
-- 
2.1.0

