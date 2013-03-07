Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3CGRkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:40:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3CGRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:40:29 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Thu,  7 Mar 2013 11:40:17 -0600
Message-Id: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know that with some firmware implementations writing too much data to
UEFI variables can lead to bricking machines. Recent changes attempt to
address this issue, but for some it may still be prudent to avoid
writing large amounts of data until the solution has been proven on a
wide variety of hardware.

Crash dumps or other data from pstore can potentially be a large data
source. Add a new option, CONFIG_EFI_VARS_PSTORE, which can be set to N
to avoid using efivars as a backend to pstore.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/firmware/Kconfig   |    9 +++++++
 drivers/firmware/efivars.c |   64 ++++++++++++++------------------------------
 2 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..898023d 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -53,6 +53,15 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_PSTORE
+	bool "Register efivars backend for pstore"
+	depends on EFI_VARS && PSTORE
+	default y
+	help
+	  Say Y here to enable use efivars as a backend to pstore. This
+	  will allow writing console messages, crash dumps, or anything
+	  else supported by pstore to EFI variables.
+
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7320bf8..73aa2c5 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1253,9 +1253,7 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 	.create = efivarfs_create,
 };
 
-static struct pstore_info efi_pstore_info;
-
-#ifdef CONFIG_PSTORE
+#if defined(CONFIG_PSTORE) && defined(CONFIG_EFI_VARS_PSTORE)
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
@@ -1459,38 +1457,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 	return 0;
 }
-#else
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type, int *count,
-			       struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	return -1;
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	return 0;
-}
-#endif
 
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
@@ -1502,6 +1468,24 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	efivars->efi_pstore_info = efi_pstore_info;
+	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efivars->efi_pstore_info.buf) {
+		efivars->efi_pstore_info.bufsize = 1024;
+		efivars->efi_pstore_info.data = efivars;
+		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
+		pstore_register(&efivars->efi_pstore_info);
+	}
+}
+#else
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	return;
+}
+#endif
+
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -1962,15 +1946,7 @@ int register_efivars(struct efivars *efivars,
 	if (error)
 		unregister_efivars(efivars);
 
-	efivars->efi_pstore_info = efi_pstore_info;
-
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
-	}
+	efivar_pstore_register(efivars);
 
 	register_filesystem(&efivarfs_type);
 
-- 
1.7.9.5

