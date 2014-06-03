Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaFCNt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:49:26 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37653 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaFCNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:49:24 -0400
Date: Tue, 3 Jun 2014 15:49:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.16
Message-ID: <20140603134917.GA31878@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: 04725ad59474d24553d526fa774179ecd2922342 x86, iosf: Add PCI ID macros for better readability

IOSF (Intel OnChip System Fabric) updates:

 - generalize the IOSF interface to allow mixed mode drivers: non-IOSF 
   drivers to utilize of IOSF features on IOSF platforms.

 - add 'Quark X1000' IOSF/MBI support

 - clean up BayTrail and Quark PCI ID enumeration

 Thanks,

	Ingo

------------------>
David E. Box (1):
      x86, iosf: Make IOSF driver modular and usable by more drivers

Ong Boon Leong (3):
      x86, iosf: Added Quark MBI identifiers
      x86, iosf: Add Quark X1000 PCI ID
      x86, iosf: Add PCI ID macros for better readability


 arch/x86/Kconfig                |  7 ++----
 arch/x86/include/asm/iosf_mbi.h | 55 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      | 13 +++++++++-
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..f1304d3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2375,12 +2375,9 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	bool
+	tristate
+	default m
 	depends on PCI
-	---help---
-	  To be selected by modules requiring access to the Intel OnChip System
-	  Fabric (IOSF) Sideband MailBox Interface (MBI). For MBI platforms
-	  enumerable by PCI.
 
 source "net/Kconfig"
 
diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 8e71c79..57995f0 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -50,6 +50,32 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+/* Quark available units */
+#define QRK_MBI_UNIT_HBA	0x00
+#define QRK_MBI_UNIT_HB	0x03
+#define QRK_MBI_UNIT_RMU	0x04
+#define QRK_MBI_UNIT_MM	0x05
+#define QRK_MBI_UNIT_MMESRAM	0x05
+#define QRK_MBI_UNIT_SOC	0x31
+
+/* Quark read/write opcodes */
+#define QRK_MBI_HBA_READ	0x10
+#define QRK_MBI_HBA_WRITE	0x11
+#define QRK_MBI_HB_READ	0x10
+#define QRK_MBI_HB_WRITE	0x11
+#define QRK_MBI_RMU_READ	0x10
+#define QRK_MBI_RMU_WRITE	0x11
+#define QRK_MBI_MM_READ	0x10
+#define QRK_MBI_MM_WRITE	0x11
+#define QRK_MBI_MMESRAM_READ	0x12
+#define QRK_MBI_MMESRAM_WRITE	0x13
+#define QRK_MBI_SOC_READ	0x06
+#define QRK_MBI_SOC_WRITE	0x07
+
+#if IS_ENABLED(CONFIG_IOSF_MBI)
+
+bool iosf_mbi_available(void);
+
 /**
  * iosf_mbi_read() - MailBox Interface read command
  * @port:	port indicating subunit being accessed
@@ -87,4 +113,33 @@ int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
  */
 int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
 
+#else /* CONFIG_IOSF_MBI is not enabled */
+static inline
+bool iosf_mbi_available(void)
+{
+	return false;
+}
+
+static inline
+int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
+{
+	WARN(1, "IOSF_MBI driver not available");
+	return -EPERM;
+}
+
+static inline
+int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
+{
+	WARN(1, "IOSF_MBI driver not available");
+	return -EPERM;
+}
+
+static inline
+int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
+{
+	WARN(1, "IOSF_MBI driver not available");
+	return -EPERM;
+}
+#endif /* CONFIG_IOSF_MBI */
+
 #endif /* IOSF_MBI_SYMS_H */
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index c3aae66..d30acdc 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -25,6 +25,9 @@
 
 #include <asm/iosf_mbi.h>
 
+#define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_QUARK_X1000	0x0958
+
 static DEFINE_SPINLOCK(iosf_mbi_lock);
 
 static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
@@ -177,6 +180,13 @@ int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
 }
 EXPORT_SYMBOL(iosf_mbi_modify);
 
+bool iosf_mbi_available(void)
+{
+	/* Mbi isn't hot-pluggable. No remove routine is provided */
+	return mbi_pdev;
+}
+EXPORT_SYMBOL(iosf_mbi_available);
+
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
 {
@@ -193,7 +203,8 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 }
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);
