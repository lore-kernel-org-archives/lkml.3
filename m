Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaIBVH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:07:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaIBVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:07:58 -0400
Date: Tue, 2 Sep 2014 14:07:33 -0700
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-8dc12f933c9d732c5bbfb233daf27377893b109c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1409175640-32426-3-git-send-email-david.e.box@linux.intel.com>
References: <1409175640-32426-3-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/iosf: Add debugfs support
Git-Commit-ID: 8dc12f933c9d732c5bbfb233daf27377893b109c
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

Commit-ID:  8dc12f933c9d732c5bbfb233daf27377893b109c
Gitweb:     http://git.kernel.org/tip/8dc12f933c9d732c5bbfb233daf27377893b109c
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Wed, 27 Aug 2014 14:40:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 27 Aug 2014 14:48:36 -0700

x86/iosf: Add debugfs support

Allows access to the iosf sideband through debugfs.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1409175640-32426-3-git-send-email-david.e.box@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/iosf_mbi.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index 9030e83..0a2faa3 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -22,6 +22,8 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/debugfs.h>
+#include <linux/capability.h>
 
 #include <asm/iosf_mbi.h>
 
@@ -187,6 +189,75 @@ bool iosf_mbi_available(void)
 }
 EXPORT_SYMBOL(iosf_mbi_available);
 
+/********************** debugfs begin ****************************/
+static u32	dbg_mdr;
+static u32	dbg_mcr;
+static u32	dbg_mcrx;
+
+static int mcr_get(void *data, u64 *val)
+{
+	*val = *(u32 *)data;
+	return 0;
+}
+
+static int mcr_set(void *data, u64 val)
+{
+	u8 command = ((u32)val & 0xFF000000) >> 24,
+	   port	   = ((u32)val & 0x00FF0000) >> 16,
+	   offset  = ((u32)val & 0x0000FF00) >> 8;
+	int err;
+
+	*(u32 *)data = val;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
+	if (command & 1u)
+		err = iosf_mbi_write(port,
+			       command,
+			       dbg_mcrx | offset,
+			       dbg_mdr);
+	else
+		err = iosf_mbi_read(port,
+			      command,
+			      dbg_mcrx | offset,
+			      &dbg_mdr);
+
+	return err;
+}
+DEFINE_SIMPLE_ATTRIBUTE(iosf_mcr_fops, mcr_get, mcr_set , "%llx\n");
+
+static struct dentry *iosf_dbg;
+static void iosf_sideband_debug_init(void)
+{
+	struct dentry *d;
+
+	iosf_dbg = debugfs_create_dir("iosf_sb", NULL);
+	if (IS_ERR_OR_NULL(iosf_dbg))
+		return;
+
+	/* mdr */
+	d = debugfs_create_x32("mdr", 0660, iosf_dbg, &dbg_mdr);
+	if (IS_ERR_OR_NULL(d))
+		goto cleanup;
+
+	/* mcrx */
+	debugfs_create_x32("mcrx", 0660, iosf_dbg, &dbg_mcrx);
+	if (IS_ERR_OR_NULL(d))
+		goto cleanup;
+
+	/* mcr - initiates mailbox tranaction */
+	debugfs_create_file("mcr", 0660, iosf_dbg, &dbg_mcr, &iosf_mcr_fops);
+	if (IS_ERR_OR_NULL(d))
+		goto cleanup;
+
+	return;
+
+cleanup:
+	debugfs_remove_recursive(d);
+}
+/********************** debugfs end ****************************/
+
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
 {
@@ -217,11 +288,14 @@ static struct pci_driver iosf_mbi_pci_driver = {
 
 static int __init iosf_mbi_init(void)
 {
+	iosf_sideband_debug_init();
 	return pci_register_driver(&iosf_mbi_pci_driver);
 }
 
 static void __exit iosf_mbi_exit(void)
 {
+	debugfs_remove_recursive(iosf_dbg);
+
 	pci_unregister_driver(&iosf_mbi_pci_driver);
 	if (mbi_pdev) {
 		pci_dev_put(mbi_pdev);
