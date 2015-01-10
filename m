Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbbAJCfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:35:47 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59555 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbbAJCfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:43 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/16] ARM: sa1100: convert PCI to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:42 -0600
Message-Id: <1420857290-8373-9-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the sa1100 nanoengine PCI driver to use the generic config access
functions.

This changes accesses from __raw_readX/__raw_writeX to readX/writeX
variants. The spinlock is removed because it is unnecessary. The config
read and write functions are already protected with a spinlock.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-sa1100/pci-nanoengine.c | 94 +++--------------------------------
 1 file changed, 8 insertions(+), 86 deletions(-)

diff --git a/arch/arm/mach-sa1100/pci-nanoengine.c b/arch/arm/mach-sa1100/pci-nanoengine.c
index b704433..d7ae8d5 100644
--- a/arch/arm/mach-sa1100/pci-nanoengine.c
+++ b/arch/arm/mach-sa1100/pci-nanoengine.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/pci.h>
-#include <linux/spinlock.h>
 
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
@@ -30,97 +29,20 @@
 #include <mach/nanoengine.h>
 #include <mach/hardware.h>
 
-static DEFINE_SPINLOCK(nano_lock);
-
-static int nanoengine_get_pci_address(struct pci_bus *bus,
-	unsigned int devfn, int where, void __iomem **address)
+static void __iomem *nanoengine_pci_map_bus(struct pci_bus *bus,
+					    unsigned int devfn, int where)
 {
-	int ret = PCIBIOS_DEVICE_NOT_FOUND;
-	unsigned int busnr = bus->number;
+	if (bus->number != 0 || (devfn >> 3) != 0)
+		return NULL;
 
-	*address = (void __iomem *)NANO_PCI_CONFIG_SPACE_VIRT +
+	return (void __iomem *)NANO_PCI_CONFIG_SPACE_VIRT +
 		((bus->number << 16) | (devfn << 8) | (where & ~3));
-
-	ret = (busnr > 255 || devfn > 255 || where > 255) ?
-		PCIBIOS_DEVICE_NOT_FOUND : PCIBIOS_SUCCESSFUL;
-
-	return ret;
-}
-
-static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int where,
-	int size, u32 *val)
-{
-	int ret;
-	void __iomem *address;
-	unsigned long flags;
-	u32 v;
-
-	/* nanoEngine PCI bridge does not return -1 for a non-existing
-	 * device. We must fake the answer. We know that the only valid
-	 * device is device zero at bus 0, which is the network chip. */
-	if (bus->number != 0 || (devfn >> 3) != 0) {
-		v = -1;
-		nanoengine_get_pci_address(bus, devfn, where, &address);
-		goto exit_function;
-	}
-
-	spin_lock_irqsave(&nano_lock, flags);
-
-	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
-	if (ret != PCIBIOS_SUCCESSFUL)
-		return ret;
-	v = __raw_readl(address);
-
-	spin_unlock_irqrestore(&nano_lock, flags);
-
-	v >>= ((where & 3) * 8);
-	v &= (unsigned long)(-1) >> ((4 - size) * 8);
-
-exit_function:
-	*val = v;
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int where,
-	int size, u32 val)
-{
-	int ret;
-	void __iomem *address;
-	unsigned long flags;
-	unsigned shift;
-	u32 v;
-
-	shift = (where & 3) * 8;
-
-	spin_lock_irqsave(&nano_lock, flags);
-
-	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
-	if (ret != PCIBIOS_SUCCESSFUL)
-		return ret;
-	v = __raw_readl(address);
-	switch (size) {
-	case 1:
-		v &= ~(0xFF << shift);
-		v |= val << shift;
-		break;
-	case 2:
-		v &= ~(0xFFFF << shift);
-		v |= val << shift;
-		break;
-	case 4:
-		v = val;
-		break;
-	}
-	__raw_writel(v, address);
-
-	spin_unlock_irqrestore(&nano_lock, flags);
-
-	return PCIBIOS_SUCCESSFUL;
 }
 
 static struct pci_ops pci_nano_ops = {
-	.read	= nanoengine_read_config,
-	.write	= nanoengine_write_config,
+	.map_bus = nanoengine_pci_map_bus,
+	.read	= pci_generic_config_read32,
+	.write	= pci_generic_config_write32,
 };
 
 static int __init pci_nanoengine_map_irq(const struct pci_dev *dev, u8 slot,
-- 
2.1.0

