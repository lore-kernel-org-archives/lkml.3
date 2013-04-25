Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3DYJuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:50:16 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58759 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757177Ab3DYJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:50:13 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au
Cc: benh@kernel.crashing.org, monstr@monstr.eu, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, grant.likely@secretlab.ca,
        Andrew Murray <Andrew.Murray@arm.com>
Subject: [RFC PATCH 3/3] pci: Use common definations of INDIRECT_TYPE_*
Date: Thu, 25 Apr 2013 10:49:20 +0100
Message-Id: <1366883360-14061-4-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1366883360-14061-1-git-send-email-Andrew.Murray@arm.com>
References: <1366883360-14061-1-git-send-email-Andrew.Murray@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies similar definations of INDIRECT_TYPE_* between
PowerPC and Microblaze.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
---
 arch/microblaze/include/asm/pci-bridge.h |   23 -----------------------
 arch/powerpc/include/asm/pci-bridge.h    |   23 -----------------------
 arch/powerpc/sysdev/fsl_pci.c            |   16 ++++++++--------
 arch/powerpc/sysdev/indirect_pci.c       |   20 ++++++++++----------
 arch/powerpc/sysdev/ppc4xx_pci.c         |    4 ++--
 arch/powerpc/sysdev/xilinx_pci.c         |    2 +-
 include/asm-generic/pci-bridge.h         |   22 ++++++++++++++++++++++
 7 files changed, 43 insertions(+), 67 deletions(-)

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 0ee75dc..acf8252 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -24,29 +24,6 @@ static inline int pcibios_vaddr_is_ioport(void __iomem *address)
 }
 #endif
 
-/*
- * Used for variants of PCI indirect handling and possible quirks:
- *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
- *  EXT_REG - provides access to PCI-e extended registers
- *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
- *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
- *   to determine which bus number to match on when generating type0
- *   config cycles
- *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
- *   hanging if we don't have link and try to do config cycles to
- *   anything but the PHB.  Only allow talking to the PHB if this is
- *   set.
- *  BIG_ENDIAN - cfg_addr is a big endian register
- *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs
- *   on the PLB4.  Effectively disable MRM commands by setting this.
- */
-#define INDIRECT_TYPE_SET_CFG_TYPE		0x00000001
-#define INDIRECT_TYPE_EXT_REG		0x00000002
-#define INDIRECT_TYPE_SURPRESS_PRIMARY_BUS	0x00000004
-#define INDIRECT_TYPE_NO_PCIE_LINK		0x00000008
-#define INDIRECT_TYPE_BIG_ENDIAN		0x00000010
-#define INDIRECT_TYPE_BROKEN_MRM		0x00000020
-
 #ifdef CONFIG_PCI
 static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
 {
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 163bd40..b2bbf05 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -14,29 +14,6 @@
 
 struct device_node;
 
-/*
- * Used for variants of PCI indirect handling and possible quirks:
- *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
- *  EXT_REG - provides access to PCI-e extended registers
- *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
- *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
- *   to determine which bus number to match on when generating type0
- *   config cycles
- *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
- *   hanging if we don't have link and try to do config cycles to
- *   anything but the PHB.  Only allow talking to the PHB if this is
- *   set.
- *  BIG_ENDIAN - cfg_addr is a big endian register
- *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs on
- *   the PLB4.  Effectively disable MRM commands by setting this.
- */
-#define PPC_INDIRECT_TYPE_SET_CFG_TYPE		0x00000001
-#define PPC_INDIRECT_TYPE_EXT_REG		0x00000002
-#define PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS	0x00000004
-#define PPC_INDIRECT_TYPE_NO_PCIE_LINK		0x00000008
-#define PPC_INDIRECT_TYPE_BIG_ENDIAN		0x00000010
-#define PPC_INDIRECT_TYPE_BROKEN_MRM		0x00000020
-
 /* These are used for config access before all the PCI probing
    has been done. */
 extern int early_read_config_byte(struct pci_controller *hose, int bus,
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 682084d..d73f94a 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -399,7 +399,7 @@ void fsl_pcibios_fixup_bus(struct pci_bus *bus)
 
 	if (fsl_pcie_bus_fixup)
 		is_pcie = early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP);
-	no_link = !!(hose->indirect_type & PPC_INDIRECT_TYPE_NO_PCIE_LINK);
+	no_link = !!(hose->indirect_type & INDIRECT_TYPE_NO_PCIE_LINK);
 
 	if (bus->parent == hose->bus && (is_pcie || no_link)) {
 		for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; ++i) {
@@ -462,7 +462,7 @@ int __init fsl_add_bridge(struct platform_device *pdev, int is_primary)
 	hose->last_busno = bus_range ? bus_range[1] : 0xff;
 
 	setup_indirect_pci(hose, rsrc.start, rsrc.start + 0x4,
-		PPC_INDIRECT_TYPE_BIG_ENDIAN);
+		INDIRECT_TYPE_BIG_ENDIAN);
 
 	if (early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP)) {
 		/* For PCIE read HEADER_TYPE to identify controler mode */
@@ -481,10 +481,10 @@ int __init fsl_add_bridge(struct platform_device *pdev, int is_primary)
 
 	/* check PCI express link status */
 	if (early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP)) {
-		hose->indirect_type |= PPC_INDIRECT_TYPE_EXT_REG |
-			PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS;
+		hose->indirect_type |= INDIRECT_TYPE_EXT_REG |
+			INDIRECT_TYPE_SURPRESS_PRIMARY_BUS;
 		if (fsl_pcie_check_link(hose))
-			hose->indirect_type |= PPC_INDIRECT_TYPE_NO_PCIE_LINK;
+			hose->indirect_type |= INDIRECT_TYPE_NO_PCIE_LINK;
 	}
 
 	printk(KERN_INFO "Found FSL PCI host bridge at 0x%016llx. "
@@ -545,7 +545,7 @@ static int mpc83xx_pcie_exclude_device(struct pci_bus *bus, unsigned int devfn)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_NO_PCIE_LINK)
+	if (hose->indirect_type & INDIRECT_TYPE_NO_PCIE_LINK)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 	/*
 	 * Workaround for the HW bug: for Type 0 configure transactions the
@@ -628,7 +628,7 @@ static int mpc83xx_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
 	if (!cfg_addr)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
-	/* PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS */
+	/* INDIRECT_TYPE_SURPRESS_PRIMARY_BUS */
 	if (offset == PCI_PRIMARY_BUS && bus->number == hose->first_busno)
 		val &= 0xffffff00;
 
@@ -686,7 +686,7 @@ static int __init mpc83xx_pcie_setup(struct pci_controller *hose,
 	out_le32(pcie->cfg_type0 + PEX_OUTWIN0_TAL, 0);
 
 	if (fsl_pcie_check_link(hose))
-		hose->indirect_type |= PPC_INDIRECT_TYPE_NO_PCIE_LINK;
+		hose->indirect_type |= INDIRECT_TYPE_NO_PCIE_LINK;
 
 	return 0;
 err1:
diff --git a/arch/powerpc/sysdev/indirect_pci.c b/arch/powerpc/sysdev/indirect_pci.c
index 82fdad8..aa9dd5d 100644
--- a/arch/powerpc/sysdev/indirect_pci.c
+++ b/arch/powerpc/sysdev/indirect_pci.c
@@ -29,7 +29,7 @@ indirect_read_config(struct pci_bus *bus, unsigned int devfn, int offset,
 	u8 cfg_type = 0;
 	u32 bus_no, reg;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_NO_PCIE_LINK) {
+	if (hose->indirect_type & INDIRECT_TYPE_NO_PCIE_LINK) {
 		if (bus->number != hose->first_busno)
 			return PCIBIOS_DEVICE_NOT_FOUND;
 		if (devfn != 0)
@@ -40,19 +40,19 @@ indirect_read_config(struct pci_bus *bus, unsigned int devfn, int offset,
 		if (ppc_md.pci_exclude_device(hose, bus->number, devfn))
 			return PCIBIOS_DEVICE_NOT_FOUND;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_SET_CFG_TYPE)
+	if (hose->indirect_type & INDIRECT_TYPE_SET_CFG_TYPE)
 		if (bus->number != hose->first_busno)
 			cfg_type = 1;
 
 	bus_no = (bus->number == hose->first_busno) ?
 			hose->self_busno : bus->number;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_EXT_REG)
+	if (hose->indirect_type & INDIRECT_TYPE_EXT_REG)
 		reg = ((offset & 0xf00) << 16) | (offset & 0xfc);
 	else
 		reg = offset & 0xfc;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_BIG_ENDIAN)
+	if (hose->indirect_type & INDIRECT_TYPE_BIG_ENDIAN)
 		out_be32(hose->cfg_addr, (0x80000000 | (bus_no << 16) |
 			 (devfn << 8) | reg | cfg_type));
 	else
@@ -87,7 +87,7 @@ indirect_write_config(struct pci_bus *bus, unsigned int devfn, int offset,
 	u8 cfg_type = 0;
 	u32 bus_no, reg;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_NO_PCIE_LINK) {
+	if (hose->indirect_type & INDIRECT_TYPE_NO_PCIE_LINK) {
 		if (bus->number != hose->first_busno)
 			return PCIBIOS_DEVICE_NOT_FOUND;
 		if (devfn != 0)
@@ -98,19 +98,19 @@ indirect_write_config(struct pci_bus *bus, unsigned int devfn, int offset,
 		if (ppc_md.pci_exclude_device(hose, bus->number, devfn))
 			return PCIBIOS_DEVICE_NOT_FOUND;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_SET_CFG_TYPE)
+	if (hose->indirect_type & INDIRECT_TYPE_SET_CFG_TYPE)
 		if (bus->number != hose->first_busno)
 			cfg_type = 1;
 
 	bus_no = (bus->number == hose->first_busno) ?
 			hose->self_busno : bus->number;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_EXT_REG)
+	if (hose->indirect_type & INDIRECT_TYPE_EXT_REG)
 		reg = ((offset & 0xf00) << 16) | (offset & 0xfc);
 	else
 		reg = offset & 0xfc;
 
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_BIG_ENDIAN)
+	if (hose->indirect_type & INDIRECT_TYPE_BIG_ENDIAN)
 		out_be32(hose->cfg_addr, (0x80000000 | (bus_no << 16) |
 			 (devfn << 8) | reg | cfg_type));
 	else
@@ -118,13 +118,13 @@ indirect_write_config(struct pci_bus *bus, unsigned int devfn, int offset,
 			 (devfn << 8) | reg | cfg_type));
 
 	/* suppress setting of PCI_PRIMARY_BUS */
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS)
+	if (hose->indirect_type & INDIRECT_TYPE_SURPRESS_PRIMARY_BUS)
 		if ((offset == PCI_PRIMARY_BUS) &&
 			(bus->number == hose->first_busno))
 		val &= 0xffffff00;
 
 	/* Workaround for PCI_28 Errata in 440EPx/GRx */
-	if ((hose->indirect_type & PPC_INDIRECT_TYPE_BROKEN_MRM) &&
+	if ((hose->indirect_type & INDIRECT_TYPE_BROKEN_MRM) &&
 			offset == PCI_CACHE_LINE_SIZE) {
 		val = 0;
 	}
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 56e8b3c..745cd7a 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -73,7 +73,7 @@ static void fixup_ppc4xx_pci_bridge(struct pci_dev *dev)
 
 	if (of_device_is_compatible(hose->dn, "ibm,plb440epx-pci") ||
 		of_device_is_compatible(hose->dn, "ibm,plb440grx-pci")) {
-		hose->indirect_type |= PPC_INDIRECT_TYPE_BROKEN_MRM;
+		hose->indirect_type |= INDIRECT_TYPE_BROKEN_MRM;
 	}
 
 	/* Hide the PCI host BARs from the kernel as their content doesn't
@@ -577,7 +577,7 @@ static void __init ppc4xx_probe_pcix_bridge(struct device_node *np)
 
 	/* Setup config space */
 	setup_indirect_pci(hose, rsrc_cfg.start, rsrc_cfg.start + 0x4,
-					PPC_INDIRECT_TYPE_SET_CFG_TYPE);
+					INDIRECT_TYPE_SET_CFG_TYPE);
 
 	/* Disable all windows */
 	writel(0, reg + PCIX0_POM0SA);
diff --git a/arch/powerpc/sysdev/xilinx_pci.c b/arch/powerpc/sysdev/xilinx_pci.c
index 1453b0e..67d4858 100644
--- a/arch/powerpc/sysdev/xilinx_pci.c
+++ b/arch/powerpc/sysdev/xilinx_pci.c
@@ -104,7 +104,7 @@ void __init xilinx_pci_init(void)
 	/* Setup config space */
 	setup_indirect_pci(hose, r.start + XPLB_PCI_ADDR,
 			   r.start + XPLB_PCI_DATA,
-			   PPC_INDIRECT_TYPE_SET_CFG_TYPE);
+			   INDIRECT_TYPE_SET_CFG_TYPE);
 
 	/* According to the xilinx plbv46_pci documentation the soft-core starts
 	 * a self-init when the bus master enable bit is set. Without this bit
diff --git a/include/asm-generic/pci-bridge.h b/include/asm-generic/pci-bridge.h
index 1a7f96d..c627c59 100644
--- a/include/asm-generic/pci-bridge.h
+++ b/include/asm-generic/pci-bridge.h
@@ -87,6 +87,28 @@ struct pci_controller {
 	unsigned int __iomem *cfg_addr;
 	void __iomem *cfg_data;
 
+	/*
+	 * Used for variants of PCI indirect handling and possible quirks:
+	 *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
+	 *  EXT_REG - provides access to PCI-e extended registers
+	 *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
+	 *   on PCI-e controllers since they used the PCI_PRIMARY_BUS
+	 *   to determine which bus number to match on when generating type0
+	 *   config cycles
+	 *  NO_PCIE_LINK - some PCI-e controllers have issues with
+	 *   hanging if we don't have link and try to do config cycles to
+	 *   anything but the PHB.  Only allow talking to the PHB if this is
+	 *   set.
+	 *  BIG_ENDIAN - cfg_addr is a big endian register
+	 *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs
+	 *   on the PLB4.  Effectively disable MRM commands by setting this.
+	 */
+#define INDIRECT_TYPE_SET_CFG_TYPE		0x00000001
+#define INDIRECT_TYPE_EXT_REG			0x00000002
+#define INDIRECT_TYPE_SURPRESS_PRIMARY_BUS	0x00000004
+#define INDIRECT_TYPE_NO_PCIE_LINK		0x00000008
+#define INDIRECT_TYPE_BIG_ENDIAN		0x00000010
+#define INDIRECT_TYPE_BROKEN_MRM		0x00000020
 	u32 indirect_type;
 	/* Currently, we limit ourselves to 1 IO range and 3 mem
 	 * ranges since the common pci_bus structure can't handle more
-- 
1.7.0.4

