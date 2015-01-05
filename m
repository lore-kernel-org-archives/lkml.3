Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbbAECUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 21:20:00 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:38543 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbAECT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 21:19:59 -0500
From: Rob Herring <robh@kernel.org>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH] pci: introduce common pci config space accessors
Date: Sun,  4 Jan 2015 20:19:34 -0600
Message-Id: <1420424374-32412-1-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
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
---

I've converted a few drivers already. I'll send patches for them after
some feedback on this. Most already have some function similar to what is
needed for map_bus, so the conversion is pretty simple. This certainly
isn't a complete list of possible users. The diffstat so far looks like
this:

 arch/arm/mach-cns3xxx/pcie.c          |  46 +++-------------------
 arch/arm/mach-integrator/pci_v3.c     |  61 +++---------------------------
 arch/arm/mach-ks8695/pci.c            |  75 +++---------------------------------
 arch/arm/mach-sa1100/pci-nanoengine.c |  94 ++++-----------------------------------------
 arch/powerpc/platforms/powermac/pci.c | 206 +++++++++++++++++++--------------------------------------------------------------------------------
 arch/powerpc/sysdev/fsl_pci.c         |  46 ++--------------------
 drivers/pci/host/pci-host-generic.c   |  51 ++-----------------------
 drivers/pci/host/pci-rcar-gen2.c      |  51 ++-----------------------
 drivers/pci/host/pci-tegra.c          |  55 ++-------------------------
 drivers/pci/host/pci-xgene.c          | 150 +++++-------------------------------------------------------------------
 drivers/pci/host/pcie-xilinx.c        |  88 +++++-------------------------------------
 11 files changed, 93 insertions(+), 830 deletions(-)

Rob

 drivers/pci/access.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  | 11 +++++++
 2 files changed, 94 insertions(+)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 49dd766..9a29f7a 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -67,6 +67,89 @@ EXPORT_SYMBOL(pci_bus_write_config_byte);
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

