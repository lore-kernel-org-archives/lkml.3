Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbbAJCft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:35:49 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33520 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbbAJCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:44 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Greg Ungerer <gerg@uclinux.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/16] ARM: ks8695: convert PCI to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:43 -0600
Message-Id: <1420857290-8373-10-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the ks8695 PCI driver to use the generic config access functions.

This changes accesses from __raw_readX/__raw_writeX to readX/writeX
variants.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-ks8695/pci.c | 77 ++++------------------------------------------
 1 file changed, 6 insertions(+), 71 deletions(-)

diff --git a/arch/arm/mach-ks8695/pci.c b/arch/arm/mach-ks8695/pci.c
index bb18193..c1bc4c3 100644
--- a/arch/arm/mach-ks8695/pci.c
+++ b/arch/arm/mach-ks8695/pci.c
@@ -38,8 +38,6 @@
 
 
 static int pci_dbg;
-static int pci_cfg_dbg;
-
 
 static void ks8695_pci_setupconfig(unsigned int bus_nr, unsigned int devfn, unsigned int where)
 {
@@ -59,75 +57,11 @@ static void ks8695_pci_setupconfig(unsigned int bus_nr, unsigned int devfn, unsi
 	}
 }
 
-
-/*
- * The KS8695 datasheet prohibits anything other than 32bit accesses
- * to the IO registers, so all our configuration must be done with
- * 32bit operations, and the correct bit masking and shifting.
- */
-
-static int ks8695_pci_readconfig(struct pci_bus *bus,
-			unsigned int devfn, int where, int size, u32 *value)
-{
-	ks8695_pci_setupconfig(bus->number, devfn, where);
-
-	*value = __raw_readl(KS8695_PCI_VA +  KS8695_PBCD);
-
-	switch (size) {
-		case 4:
-			break;
-		case 2:
-			*value = *value >> ((where & 2) * 8);
-			*value &= 0xffff;
-			break;
-		case 1:
-			*value = *value >> ((where & 3) * 8);
-			*value &= 0xff;
-			break;
-	}
-
-	if (pci_cfg_dbg) {
-		printk("read: %d,%08x,%02x,%d: %08x (%08x)\n",
-			bus->number, devfn, where, size, *value,
-			__raw_readl(KS8695_PCI_VA +  KS8695_PBCD));
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int ks8695_pci_writeconfig(struct pci_bus *bus,
-			unsigned int devfn, int where, int size, u32 value)
+static void __iomem *ks8695_pci_map_bus(struct pci_bus *bus, unsigned int devfn,
+					int where)
 {
-	unsigned long tmp;
-
-	if (pci_cfg_dbg) {
-		printk("write: %d,%08x,%02x,%d: %08x\n",
-			bus->number, devfn, where, size, value);
-	}
-
 	ks8695_pci_setupconfig(bus->number, devfn, where);
-
-	switch (size) {
-		case 4:
-			__raw_writel(value, KS8695_PCI_VA +  KS8695_PBCD);
-			break;
-		case 2:
-			tmp = __raw_readl(KS8695_PCI_VA +  KS8695_PBCD);
-			tmp &= ~(0xffff << ((where & 2) * 8));
-			tmp |= value << ((where & 2) * 8);
-
-			__raw_writel(tmp, KS8695_PCI_VA +  KS8695_PBCD);
-			break;
-		case 1:
-			tmp = __raw_readl(KS8695_PCI_VA +  KS8695_PBCD);
-			tmp &= ~(0xff << ((where & 3) * 8));
-			tmp |= value << ((where & 3) * 8);
-
-			__raw_writel(tmp, KS8695_PCI_VA +  KS8695_PBCD);
-			break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
+	return KS8695_PCI_VA +  KS8695_PBCD;
 }
 
 static void ks8695_local_writeconfig(int where, u32 value)
@@ -137,8 +71,9 @@ static void ks8695_local_writeconfig(int where, u32 value)
 }
 
 static struct pci_ops ks8695_pci_ops = {
-	.read	= ks8695_pci_readconfig,
-	.write	= ks8695_pci_writeconfig,
+	.map_bus = ks8695_pci_map_bus,
+	.read	= pci_generic_config_read32,
+	.write	= pci_generic_config_write32,
 };
 
 static struct resource pci_mem = {
-- 
2.1.0

