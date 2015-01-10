Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbbAJChB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:37:01 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39129 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbbAJCfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:52 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org
Subject: [PATCH 13/16] pci/host: rcar-gen2: convert to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:47 -0600
Message-Id: <1420857290-8373-14-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the rcar-gen2 host PCI driver to use the generic config access
functions.

This changes the i/o accessors from io(read|write)X to readX/writeX
variants which are equivalent on ARM.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-sh@vger.kernel.org
---
 drivers/pci/host/pci-rcar-gen2.c | 51 +++-------------------------------------
 1 file changed, 3 insertions(+), 48 deletions(-)

diff --git a/drivers/pci/host/pci-rcar-gen2.c b/drivers/pci/host/pci-rcar-gen2.c
index d9c042f..dd6b84e 100644
--- a/drivers/pci/host/pci-rcar-gen2.c
+++ b/drivers/pci/host/pci-rcar-gen2.c
@@ -131,52 +131,6 @@ static void __iomem *rcar_pci_cfg_base(struct pci_bus *bus, unsigned int devfn,
 	return priv->reg + (slot >> 1) * 0x100 + where;
 }
 
-static int rcar_pci_read_config(struct pci_bus *bus, unsigned int devfn,
-				int where, int size, u32 *val)
-{
-	void __iomem *reg = rcar_pci_cfg_base(bus, devfn, where);
-
-	if (!reg)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	switch (size) {
-	case 1:
-		*val = ioread8(reg);
-		break;
-	case 2:
-		*val = ioread16(reg);
-		break;
-	default:
-		*val = ioread32(reg);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int rcar_pci_write_config(struct pci_bus *bus, unsigned int devfn,
-				 int where, int size, u32 val)
-{
-	void __iomem *reg = rcar_pci_cfg_base(bus, devfn, where);
-
-	if (!reg)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	switch (size) {
-	case 1:
-		iowrite8(val, reg);
-		break;
-	case 2:
-		iowrite16(val, reg);
-		break;
-	default:
-		iowrite32(val, reg);
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
 /* PCI interrupt mapping */
 static int rcar_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
@@ -325,8 +279,9 @@ static int rcar_pci_setup(int nr, struct pci_sys_data *sys)
 }
 
 static struct pci_ops rcar_pci_ops = {
-	.read	= rcar_pci_read_config,
-	.write	= rcar_pci_write_config,
+	.map_bus = rcar_pci_cfg_base,
+	.read	= pci_generic_config_read,
+	.write	= pci_generic_config_write,
 };
 
 static int rcar_pci_probe(struct platform_device *pdev)
-- 
2.1.0

