Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbbAJCi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:38:58 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:49914 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbbAJCfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:37 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH 05/16] pci: introduce common pci config space accessors
Date: Fri,  9 Jan 2015 20:34:39 -0600
Message-Id: <1420857290-8373-6-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many PCI controllers' configuration space accesses are memory mapped
varying only in address calculation and access checks. There are 2 main
access methods: a decoded address space such as ECAM or a single address
and data register similar to x86. This implementation can support both
cases as well as be used in cases that need additional pre or post access
handling.

A new pci_ops member map_bus is introduced which can do access checks and
any necessary setup. It returns the address to use for the configuration
space access. The access types supported are 32-bit only accesses or
correct byte, word, or dword sized accesses.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/access.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  | 11 +++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 49dd766..d9b64a1 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -67,6 +67,93 @@ EXPORT_SYMBOL(pci_bus_write_config_byte);
 EXPORT_SYMBOL(pci_bus_write_config_word);
 EXPORT_SYMBOL(pci_bus_write_config_dword);
 
+int pci_generic_config_read(struct pci_bus *bus, unsigned int devfn,
+			    int where, int size, u32 *val)
+{
+	void __iomem *addr;
+
+	addr = bus->ops->map_bus(bus, devfn, where);
+	if (!addr) {
+		*val = ~0;
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	if (size == 1)
+		*val = readb(addr);
+	else if (size == 2)
+		*val = readw(addr);
+	else
+		*val = readl(addr);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+EXPORT_SYMBOL_GPL(pci_generic_config_read);
+
+int pci_generic_config_write(struct pci_bus *bus, unsigned int devfn,
+			     int where, int size, u32 val)
+{
+	void __iomem *addr;
+
+	addr = bus->ops->map_bus(bus, devfn, where);
+	if (!addr)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	if (size == 1)
+		writeb(val, addr);
+	else if (size == 2)
+		writew(val, addr);
+	else
+		writel(val, addr);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+EXPORT_SYMBOL_GPL(pci_generic_config_write);
+
+int pci_generic_config_read32(struct pci_bus *bus, unsigned int devfn,
+			      int where, int size, u32 *val)
+{
+	void __iomem *addr;
+
+	addr = bus->ops->map_bus(bus, devfn, where & ~0x3);
+	if (!addr) {
+		*val = ~0;
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	*val = readl(addr);
+
+	if (size <= 2)
+		*val = (*val >> (8 * (where & 3))) & ((1 << (size * 8)) - 1);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+EXPORT_SYMBOL_GPL(pci_generic_config_read32);
+
+int pci_generic_config_write32(struct pci_bus *bus, unsigned int devfn,
+			       int where, int size, u32 val)
+{
+	void __iomem *addr;
+	u32 mask, tmp;
+
+	addr = bus->ops->map_bus(bus, devfn, where & ~0x3);
+	if (!addr)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	if (size == 4) {
+		writel(val, addr);
+		return PCIBIOS_SUCCESSFUL;
+	} else {
+		mask = ~(((1 << (size * 8)) - 1) << ((where & 0x3) * 8));
+	}
+
+	tmp = readl(addr) & mask;
+	tmp |= val << ((where & 0x3) * 8);
+	writel(tmp, addr);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+EXPORT_SYMBOL_GPL(pci_generic_config_write32);
+
 /**
  * pci_bus_set_ops - Set raw operations of pci bus
  * @bus:	pci bus struct
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 360a966..e7fd519 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -560,6 +560,7 @@ static inline int pcibios_err_to_errno(int err)
 /* Low-level architecture-dependent routines */
 
 struct pci_ops {
+	void __iomem *(*map_bus)(struct pci_bus *bus, unsigned int devfn, int where);
 	int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
 };
@@ -857,6 +858,16 @@ int pci_bus_write_config_word(struct pci_bus *bus, unsigned int devfn,
 			      int where, u16 val);
 int pci_bus_write_config_dword(struct pci_bus *bus, unsigned int devfn,
 			       int where, u32 val);
+
+int pci_generic_config_read(struct pci_bus *bus, unsigned int devfn,
+			    int where, int size, u32 *val);
+int pci_generic_config_write(struct pci_bus *bus, unsigned int devfn,
+			    int where, int size, u32 val);
+int pci_generic_config_read32(struct pci_bus *bus, unsigned int devfn,
+			      int where, int size, u32 *val);
+int pci_generic_config_write32(struct pci_bus *bus, unsigned int devfn,
+			       int where, int size, u32 val);
+
 struct pci_ops *pci_bus_set_ops(struct pci_bus *bus, struct pci_ops *ops);
 
 static inline int pci_read_config_byte(const struct pci_dev *dev, int where, u8 *val)
-- 
2.1.0

