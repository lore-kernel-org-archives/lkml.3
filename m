Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaATWCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:02:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaATWBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:01:54 -0500
Subject: [PATCH 2/2] pci/quirks: Enable quirks for PCIe ACS on Intel PCH
 root ports
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 20 Jan 2014 15:01:52 -0700
Message-ID: <20140120220152.29567.3645.stgit@bling.home>
In-Reply-To: <20140120215502.29567.11291.stgit@bling.home>
References: <20140120215502.29567.11291.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the currently available Intel PCH-based root ports do not
provide PCIe ACS capabilities.  Without this, we must assume that
peer-to-peer traffic between multifunction root ports and between
devices behind root ports is possible.  This lack of isolation is
exposed by grouping the devices together in the same IOMMU group.
If we want to expose these devices to userspace, vfio uses IOMMU
groups as the unit of ownership, thus making it very difficult to
assign individual devices to separate users.

The good news is that the chipset does provide ACS-like isolation
capabilities, but we do need to verify and enable those capabilities
if the BIOS has not done so.  This patch implements the device
specific enabling and testing of equivalent ACS function for these
devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4be1cd5..3439a02 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/atomic.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -3423,6 +3424,74 @@ static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
 #endif
 }
 
+/*
+ * Many Intel PCH root ports do provide ACS-like features to disable peer
+ * transactions and validate bus numbers in requests, but do not provide an
+ * actual PCIe ACS capability.  This is the list of device IDs known to fall
+ * into that category as provided by Intel in Red Hat bugzilla 1037684.
+ */
+static const u16 pci_quirk_intel_pch_acs_ids[] = {
+	/* Ibexpeak PCH */
+	0x3b42, 0x3b43, 0x3b44, 0x3b45, 0x3b46, 0x3b47, 0x3b48, 0x3b49,
+	0x3b4a, 0x3b4b, 0x3b4c, 0x3b4d, 0x3b4e, 0x3b4f, 0x3b50, 0x3b51,
+	/* Cougarpoint PCH */
+	0x1c10, 0x1c11, 0x1c12, 0x1c13, 0x1c14, 0x1c15, 0x1c16, 0x1c17,
+	0x1c18, 0x1c19, 0x1c1a, 0x1c1b, 0x1c1c, 0x1c1d, 0x1c1e, 0x1c1f,
+	/* Pantherpoint PCH */
+	0x1e10, 0x1e11, 0x1e12, 0x1e13, 0x1e14, 0x1e15, 0x1e16, 0x1e17,
+	0x1e18, 0x1e19, 0x1e1a, 0x1e1b, 0x1e1c, 0x1e1d, 0x1e1e, 0x1e1f,
+	/* Lynxpoint-H PCH */
+	0x8c10, 0x8c11, 0x8c12, 0x8c13, 0x8c14, 0x8c15, 0x8c16, 0x8c17,
+	0x8c18, 0x8c19, 0x8c1a, 0x8c1b, 0x8c1c, 0x8c1d, 0x8c1e, 0x8c1f,
+	/* Lynxpoint-LP PCH */
+	0x9c10, 0x9c11, 0x9c12, 0x9c13, 0x9c14, 0x9c15, 0x9c16, 0x9c17,
+	0x9c18, 0x9c19, 0x9c1a, 0x9c1b,
+	/* Wildcat PCH */
+	0x9c90, 0x9c91, 0x9c92, 0x9c93, 0x9c94, 0x9c95, 0x9c96, 0x9c97,
+	0x9c98, 0x9c99, 0x9c9a, 0x9c9b,
+};
+
+/*
+ * We can have multiple PCHs in a system and it is possible that we can
+ * fail to enable ACS support on some of them.  To keep it simple we
+ * handle them as all or nothing with the following values:
+ *  0: ACS is not enabled
+ * -1: ACS enable failed
+ * >0: ACS enabled
+ */
+static atomic_t intel_pch_acs_quirk_status = ATOMIC_INIT(0);
+
+#define INTEL_PCH_ACS_FLAGS (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_SV)
+
+static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)
+{
+	int i;
+
+	/* Filter out a few obvious non-matches first */
+	if (!pci_is_pcie(dev) ||
+	    pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT || dev->bus->number)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(pci_quirk_intel_pch_acs_ids); i++)
+		if (pci_quirk_intel_pch_acs_ids[i] == dev->device)
+			return true;
+
+	return false;
+}
+
+static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	u16 flags = 0;
+
+	if (!pci_quirk_intel_pch_acs_match(dev))
+		return -ENOTTY;
+
+	if (atomic_read(&intel_pch_acs_quirk_status) > 0)
+		flags = INTEL_PCH_ACS_FLAGS;
+
+	return acs_flags & ~flags ? 0 : 1;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -3434,6 +3503,7 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_ATI, 0x439d, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x4384, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x4399, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_intel_pch_acs },
 	{ 0 }
 };
 
@@ -3462,11 +3532,117 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 	return -ENOTTY;
 }
 
+/* Config space offset of Root Complex Base Address register */
+#define INTEL_LPC_RCBA_REG 0xf0
+/* 31:14 RCBA address */
+#define INTEL_LPC_RCBA_MASK 0xffffc000
+/* RCBA Enable */
+#define INTEL_LPC_RCBA_ENABLE (1 << 0)
+
+/* Backbone Scratch Pad Register */
+#define INTEL_BSPR_REG 0x1104
+/* Backbone Peer Non-Posted Disable */
+#define INTEL_BSPR_REG_BPNPD (1 << 8)
+/* Backbone Peer Posted Disable */
+#define INTEL_BSPR_REG_BPPD  (1 << 9)
+
+/* Upstream Peer Decode Configuration Register */
+#define INTEL_UPDCR_REG 0x1114
+/* 5:0 Peer Decode Enable bits */
+#define INTEL_UPDCR_REG_MASK 0x3f
+
+static int pci_quirk_enable_intel_lpc_acs(struct pci_dev *dev)
+{
+	u32 rcba, bspr, updcr;
+	void __iomem *rcba_mem;
+
+	/*
+	 * Read the RCBA register from the LPC (D31:F0).  PCH root ports
+	 * are D28:F* and therefore get probed before LPC, thus we can't
+	 * use pci_get_slot/pci_read_config_dword here.
+	 */
+	pci_bus_read_config_dword(dev->bus, PCI_DEVFN(31, 0),
+				  INTEL_LPC_RCBA_REG, &rcba);
+	if (!(rcba & INTEL_LPC_RCBA_ENABLE))
+		return -EINVAL;
+
+	rcba_mem = ioremap_nocache(rcba & INTEL_LPC_RCBA_MASK,
+				   PAGE_ALIGN(INTEL_UPDCR_REG));
+	if (!rcba_mem)
+		return -ENOMEM;
+
+	/*
+	 * The BSPR can disallow peer cycles, but it's set by soft strap and
+	 * therefore read-only.  If both posted and non-posted peer cycles are
+	 * disallowed, we're ok.  If either are allowed, then we need to use
+	 * the UPDCR to disable peer decodes for each port.  This provides the
+	 * PCIe ACS equivalent of PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF
+	 */
+	bspr = readl(rcba_mem + INTEL_BSPR_REG);
+	bspr &= INTEL_BSPR_REG_BPNPD | INTEL_BSPR_REG_BPPD;
+	if (bspr != (INTEL_BSPR_REG_BPNPD | INTEL_BSPR_REG_BPPD)) {
+		updcr = readl(rcba_mem + INTEL_UPDCR_REG);
+		if (updcr & INTEL_UPDCR_REG_MASK) {
+			dev_info(&dev->dev, "Disabling UPDCR peer decodes\n");
+			updcr &= ~INTEL_UPDCR_REG_MASK;
+			writel(updcr, rcba_mem + INTEL_UPDCR_REG);
+		}
+	}
+
+	iounmap(rcba_mem);
+	return 0;
+}
+
+/* Miscellaneous Port Configuration register */
+#define INTEL_MPC_REG 0xd8
+/* MPC: Invalid Receive Bus Number Check Enable */
+#define INTEL_MPC_REG_IRBNCE (1 << 26)
+
+static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
+{
+	u32 mpc;
+
+	/*
+	 * When enabled, the IRBNCE bit of the MPC register enables the
+	 * equivalent of PCI ACS Source Validation (PCI_ACS_SV), which
+	 * ensures that requester IDs fall within the bus number range
+	 * of the bridge.  Enable if not already.
+	 */
+	pci_read_config_dword(dev, INTEL_MPC_REG, &mpc);
+	if (!(mpc & INTEL_MPC_REG_IRBNCE)) {
+		dev_info(&dev->dev, "Enabling MPC IRBNCE\n");
+		mpc |= INTEL_MPC_REG_IRBNCE;
+		pci_write_config_word(dev, INTEL_MPC_REG, mpc);
+	}
+}
+
+static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
+{
+	if (!pci_quirk_intel_pch_acs_match(dev))
+		return -ENOTTY;
+
+	if (atomic_read(&intel_pch_acs_quirk_status) < 0)
+		return 0;
+
+	if (pci_quirk_enable_intel_lpc_acs(dev)) {
+		dev_warn(&dev->dev, "Failed to enable Intel PCH ACS quirk\n");
+		atomic_set(&intel_pch_acs_quirk_status, -1);
+		return 0;
+	}
+
+	pci_quirk_enable_intel_rp_mpc_acs(dev);
+
+	atomic_inc_unless_negative(&intel_pch_acs_quirk_status);
+
+	return 0;
+}
+
 static const struct pci_dev_enable_acs {
 	u16 vendor;
 	u16 device;
 	int (*enable_acs)(struct pci_dev *dev);
 } pci_dev_enable_acs[] = {
+	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_enable_intel_pch_acs },
 	{ 0 }
 };
 

