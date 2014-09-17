Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaIQD3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:29:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:39776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbaIQD3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,538,1406617200"; 
   d="scan'208";a="603948451"
From: "David E. Box" <david.e.box@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: iosf: Make debugfs addition a separate config option
Date: Tue, 16 Sep 2014 20:26:26 -0700
Message-Id: <1410924386-16977-4-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
References: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig           | 6 ++++++
 arch/x86/kernel/iosf_mbi.c | 8 ++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2db4b1d..3afcac3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -494,6 +494,12 @@ config IOSF_MBI
 	  You should say Y if you are running a kernel on one of these
 	  platforms.
 
+config IOSF_MBI_DEBUG
+	bool "Enable debugfs access to IOSF"
+	depends on IOSF_MBI && DEBUG_FS
+	---help---
+	  Select this option to enable iosf sideband debugging through debugfs.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index e01f741..f884ddc 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -190,7 +190,7 @@ bool iosf_mbi_available(void)
 }
 EXPORT_SYMBOL(iosf_mbi_available);
 
-/********************** debugfs begin ****************************/
+#if (IS_ENABLED(CONFIG_IOSF_MBI_DEBUG))
 static u32	dbg_mdr;
 static u32	dbg_mcr;
 static u32	dbg_mcrx;
@@ -257,7 +257,7 @@ static void iosf_sideband_debug_init(void)
 cleanup:
 	debugfs_remove_recursive(d);
 }
-/********************** debugfs end ****************************/
+#endif /* CONFIG_IOSF_MBI_DEBUG */
 
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
@@ -290,13 +290,17 @@ static struct pci_driver iosf_mbi_pci_driver = {
 
 static int __init iosf_mbi_init(void)
 {
+#if IS_ENABLED(CONFIG_IOSF_MBI_DEBUG)
 	iosf_sideband_debug_init();
+#endif
 	return pci_register_driver(&iosf_mbi_pci_driver);
 }
 
 static void __exit iosf_mbi_exit(void)
 {
+#if IS_ENABLED(CONFIG_IOSF_MBI_DEBUG)
 	debugfs_remove_recursive(iosf_dbg);
+#endif
 
 	pci_unregister_driver(&iosf_mbi_pci_driver);
 	if (mbi_pdev) {
-- 
1.9.1

