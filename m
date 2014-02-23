Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaBWBEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 20:04:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:34331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaBWBEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 20:04:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,527,1389772800"; 
   d="scan'208";a="488078178"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: [PATCH RESEND] x86: iosf_mbi: Provide dummy functions if CONFIG_IOSF_MBI not set
Date: Sat, 22 Feb 2014 17:02:32 -0800
Message-Id: <1393117352-23717-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392248063-16389-1-git-send-email-david.e.box@linux.intel.com>
References: <1392248063-16389-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Add iosf_mbi_available function for loadable modules.
Add dummy functions to prevent symbol lookup errors on loadable modules.
Clarify that the write opcode is to be used for iosf_mbi_modify().
Changes Kconfig for IOSF_MBI to default built-in.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig                |    2 +-
 arch/x86/include/asm/iosf_mbi.h |   39 +++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/iosf_mbi.c      |    6 ++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d3b1f8b..e25baf1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2385,7 +2385,7 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	bool
+	def_bool y
 	depends on PCI
 	---help---
 	  To be selected by modules requiring access to the Intel OnChip System
diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 8e71c79..1c93591 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -5,6 +5,8 @@
 #ifndef IOSF_MBI_SYMS_H
 #define IOSF_MBI_SYMS_H
 
+#ifdef CONFIG_IOSF_MBI
+
 #define MBI_MCR_OFFSET		0xD0
 #define MBI_MDR_OFFSET		0xD4
 #define MBI_MCRX_OFFSET		0xD8
@@ -50,6 +52,8 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+extern bool iosf_mbi_available(void);
+
 /**
  * iosf_mbi_read() - MailBox Interface read command
  * @port:	port indicating subunit being accessed
@@ -60,7 +64,7 @@
  * Locking is handled by spinlock - cannot sleep.
  * Return: Nonzero on error
  */
-int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr);
+extern int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr);
 
 /**
  * iosf_mbi_write() - MailBox unmasked write command
@@ -72,19 +76,46 @@ int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr);
  * Locking is handled by spinlock - cannot sleep.
  * Return: Nonzero on error
  */
-int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
+extern int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
 
 /**
  * iosf_mbi_modify() - MailBox masked write command
  * @port:	port indicating subunit being accessed
- * @opcode:	port specific read or write opcode
+ * @opcode:	port specific write opcode
  * @offset:	register address offset
  * @mdr:	register data being modified
  * @mask:	mask indicating bits in mdr to be modified
  *
+ * Use write opcode for this function.
  * Locking is handled by spinlock - cannot sleep.
  * Return: Nonzero on error
  */
-int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
+extern int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
+
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
+	return 0;
+}
+
+static inline
+int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
+{
+	return 0;
+}
+
+static inline
+int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
+{
+	return 0;
+}
+#endif /* CONFIG_IOSF_MBI */
 
 #endif /* IOSF_MBI_SYMS_H */
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index c3aae66..d3803c6 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -177,6 +177,12 @@ int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
 }
 EXPORT_SYMBOL(iosf_mbi_modify);
 
+bool iosf_mbi_available(void)
+{
+	return mbi_pdev;
+}
+EXPORT_SYMBOL(iosf_mbi_available);
+
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
 {
-- 
1.7.10.4

