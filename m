Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbaKLBnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:43:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbaKLBnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 113/203] x86, iosf: Make IOSF driver modular and usable by more drivers
Date: Wed, 12 Nov 2014 10:16:23 +0900
Message-Id: <20141112011547.864061620@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

commit 6b8f0c8780c71d78624f736d7849645b64cc88b7 upstream.

Currently drivers that run on non-IOSF systems (Core/Xeon) can't use the IOSF
driver on SOC's without selecting it which forces an unnecessary and limiting
dependency. Provides dummy functions to allow these modules to conditionally
use the driver on IOSF equipped platforms without impacting their ability to
compile and load on non-IOSF platforms. Build default m to ensure availability
on x86 SOC's.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Kconfig                |    7 ++-----
 arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |    7 +++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2436,12 +2436,9 @@ config X86_DMA_REMAP
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
@@ -87,4 +91,33 @@ int iosf_mbi_write(u8 port, u8 opcode, u
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
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -177,6 +177,13 @@ int iosf_mbi_modify(u8 port, u8 opcode,
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


