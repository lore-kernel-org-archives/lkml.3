Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaCACnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:43:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:46152 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaCACmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:42:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,565,1389772800"; 
   d="scan'208";a="491994844"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 1/2] x86: IOSF: add dummy functions for loadable modules
Date: Fri, 28 Feb 2014 18:40:51 -0800
Message-Id: <1393641652-7222-2-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
References: <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com>
References: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Some loadable modules only need IOSF access on the platforms where it exists.
Provide dummy functions to allow these modules to compile and load on the
platforms where it doesn't exist.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |    6 ++++++
 2 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 8e71c79..9fc5402 100644
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
+	WARN();
+	return -EPERM;
+}
+
+static inline
+int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
+{
+	WARN();
+	return -EPERM;
+}
+
+static inline
+int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
+{
+	WARN();
+	return -EPERM;
+}
+#endif /* CONFIG_IOSF_MBI */
+
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

