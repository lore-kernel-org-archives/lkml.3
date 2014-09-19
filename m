Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaISLuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:50:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaISLuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:50:05 -0400
Date: Fri, 19 Sep 2014 04:49:54 -0700
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-ed2226bd4d4a53bcc3b2ea0b1b28e955ebc15da7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1411017231-20807-4-git-send-email-david.e.box@linux.intel.com>
References: <1411017231-20807-4-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/intel/iosf:
  Add debugfs config option for IOSF
Git-Commit-ID: ed2226bd4d4a53bcc3b2ea0b1b28e955ebc15da7
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

Commit-ID:  ed2226bd4d4a53bcc3b2ea0b1b28e955ebc15da7
Gitweb:     http://git.kernel.org/tip/ed2226bd4d4a53bcc3b2ea0b1b28e955ebc15da7
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Wed, 17 Sep 2014 22:13:51 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 13:08:43 +0200

x86/platform/intel/iosf: Add debugfs config option for IOSF

Makes the IOSF sideband available through debugfs. Allows
developers to experiment with using the sideband to provide
debug and analytical tools for units on the SoC.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1411017231-20807-4-git-send-email-david.e.box@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig           | 13 +++++++++++++
 arch/x86/kernel/iosf_mbi.c | 23 +++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d6334f4..6354964 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -496,6 +496,19 @@ config IOSF_MBI
 
 	  You should say Y if you are running a kernel on one of these SoC's.
 
+config IOSF_MBI_DEBUG
+	bool "Enable IOSF sideband access through debugfs"
+	depends on IOSF_MBI && DEBUG_FS
+	---help---
+	  Select this option to expose the IOSF sideband access registers (MCR,
+	  MDR, MCRX) through debugfs to write and read register information from
+	  different units on the SoC. This is most useful for obtaining device
+	  state information for debug and analysis. As this is a general access
+	  mechanism, users of this option would have specific knowledge of the
+	  device they want to access.
+
+	  If you don't require the option or are in doubt, say N.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index e01f741..82f8d02 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -190,7 +190,7 @@ bool iosf_mbi_available(void)
 }
 EXPORT_SYMBOL(iosf_mbi_available);
 
-/********************** debugfs begin ****************************/
+#ifdef CONFIG_IOSF_MBI_DEBUG
 static u32	dbg_mdr;
 static u32	dbg_mcr;
 static u32	dbg_mcrx;
@@ -229,6 +229,7 @@ static int mcr_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(iosf_mcr_fops, mcr_get, mcr_set , "%llx\n");
 
 static struct dentry *iosf_dbg;
+
 static void iosf_sideband_debug_init(void)
 {
 	struct dentry *d;
@@ -257,7 +258,20 @@ static void iosf_sideband_debug_init(void)
 cleanup:
 	debugfs_remove_recursive(d);
 }
-/********************** debugfs end ****************************/
+
+static void iosf_debugfs_init(void)
+{
+	iosf_sideband_debug_init();
+}
+
+static void iosf_debugfs_remove(void)
+{
+	debugfs_remove_recursive(iosf_dbg);
+}
+#else
+static inline void iosf_debugfs_init(void) { }
+static inline void iosf_debugfs_remove(void) { }
+#endif /* CONFIG_IOSF_MBI_DEBUG */
 
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
@@ -290,13 +304,14 @@ static struct pci_driver iosf_mbi_pci_driver = {
 
 static int __init iosf_mbi_init(void)
 {
-	iosf_sideband_debug_init();
+	iosf_debugfs_init();
+
 	return pci_register_driver(&iosf_mbi_pci_driver);
 }
 
 static void __exit iosf_mbi_exit(void)
 {
-	debugfs_remove_recursive(iosf_dbg);
+	iosf_debugfs_remove();
 
 	pci_unregister_driver(&iosf_mbi_pci_driver);
 	if (mbi_pdev) {
