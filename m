Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaCAUew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:34:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaCAUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:34:48 -0500
Date: Sat, 1 Mar 2014 12:34:25 -0800
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-60af5c61f26fffb5f53ce74641606fe2c9a4d903@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393641652-7222-2-git-send-email-david.e.box@linux.intel.com>
References: <1393641652-7222-2-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, iosf:
  Add dummy functions for loadable modules
Git-Commit-ID: 60af5c61f26fffb5f53ce74641606fe2c9a4d903
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

Commit-ID:  60af5c61f26fffb5f53ce74641606fe2c9a4d903
Gitweb:     http://git.kernel.org/tip/60af5c61f26fffb5f53ce74641606fe2c9a4d903
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Fri, 28 Feb 2014 18:40:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 28 Feb 2014 19:55:00 -0800

x86, iosf: Add dummy functions for loadable modules

Some loadable modules only need IOSF access on the platforms where it exists.
Provide dummy functions to allow these modules to compile and load on the
platforms where it doesn't exist.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1393641652-7222-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/iosf_mbi.h | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |  6 ++++++
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
