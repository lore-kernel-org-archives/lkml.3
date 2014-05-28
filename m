Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaE1VYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:24:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE1VYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:24:50 -0400
Date: Wed, 28 May 2014 14:24:33 -0700
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-6b8f0c8780c71d78624f736d7849645b64cc88b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1399668248-24199-2-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-2-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, iosf:
  Make IOSF driver modular and usable by more drivers
Git-Commit-ID: 6b8f0c8780c71d78624f736d7849645b64cc88b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b8f0c8780c71d78624f736d7849645b64cc88b7
Gitweb:     http://git.kernel.org/tip/6b8f0c8780c71d78624f736d7849645b64cc88b7
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Fri, 9 May 2014 13:44:05 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 May 2014 14:56:15 -0700

x86, iosf: Make IOSF driver modular and usable by more drivers

Currently drivers that run on non-IOSF systems (Core/Xeon) can't use the IOSF
driver on SOC's without selecting it which forces an unnecessary and limiting
dependency. Provides dummy functions to allow these modules to conditionally
use the driver on IOSF equipped platforms without impacting their ability to
compile and load on non-IOSF platforms. Build default m to ensure availability
on x86 SOC's.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                |  7 ++-----
 arch/x86/include/asm/iosf_mbi.h | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |  7 +++++++
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
