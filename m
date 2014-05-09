Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaEIUqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:46:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:19657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbaEIUq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:46:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1020,1389772800"; 
   d="scan'208";a="537854893"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: "David E. Box" <david.e.box@linux.intel.com>, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        jacob.jun.pan@linux.intel.com, boon.leong.ong@intel.com
Subject: [PATCH v4 1/4] x86/iosf: Make IOSF driver modular and usable by more drivers
Date: Fri,  9 May 2014 13:44:05 -0700
Message-Id: <1399668248-24199-2-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
References: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Currently drivers that run on non-IOSF systems (Core/Xeon) can't use the IOSF
driver on SOC's without selecting it which forces an unnecessary and limiting
dependency. Provides dummy functions to allow these modules to conditionally
use the driver on IOSF equipped platforms without impacting their ability to
compile and load on non-IOSF platforms. Build default m to ensure availability
on x86 SOC's.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig                |    7 ++-----
 arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |    7 +++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

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
index 8e71c79..1a91a36 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -50,6 +50,10 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+#if IS_ENABLED(CONFIG_IOSF_MBI)
+
+bool iosf_mbi_available(void);
+
 /**
  * iosf_mbi_read() - MailBox Interface read command
  * @port:	port indicating subunit being accessed
@@ -87,4 +91,33 @@ int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
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
index c3aae66..f4ff978 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -177,6 +177,13 @@ int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
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
-- 
1.7.10.4

