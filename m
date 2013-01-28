Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3A1Q7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:59:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56035 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3A1Q7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:59:00 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 14/15] MODSIGN: Import certificates from UEFI Secure Boot
Date: Mon, 28 Jan 2013 11:42:38 -0500
Message-Id: <1359391359-25783-15-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

Secure Boot stores a list of allowed certificates in the 'db' variable.
This imports those certificates into the module signing keyring.  This
allows for a third party signing certificate to be used in conjunction
with signed modules.  By importing the public certificate into the 'db'
variable, a user can allow a module signed with that certificate to
load.  The shim UEFI bootloader has a similar certificate list stored
in the 'MokListRT' variable.  We import those as well.

In the opposite case, Secure Boot maintains a list of disallowed
certificates in the 'dbx' variable.  We load those certificates into
the newly introduced module blacklist keyring and forbid any module
signed with those from loading.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 include/linux/efi.h   |  6 ++++
 init/Kconfig          |  9 ++++++
 kernel/Makefile       |  3 ++
 kernel/modsign_uefi.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 108 insertions(+)
 create mode 100644 kernel/modsign_uefi.c

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 64b3e55..76fe526 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -394,6 +394,12 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define EFI_CERT_X509_GUID \
     EFI_GUID(  0xa5c059a1, 0x94e4, 0x4aa7, 0x87, 0xb5, 0xab, 0x15, 0x5c, 0x2b, 0xf0, 0x72 )
 
+#define EFI_IMAGE_SECURITY_DATABASE_GUID \
+    EFI_GUID(  0xd719b2cb, 0x3d3a, 0x4596, 0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f )
+
+#define EFI_SHIM_LOCK_GUID \
+    EFI_GUID(  0x605dab50, 0xe046, 0x4300, 0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
diff --git a/init/Kconfig b/init/Kconfig
index d972b77..27e3a82 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1673,6 +1673,15 @@ config MODULE_SIG_BLACKLIST
 	  should not pass module signature verification.  If a module is
 	  signed with something in this keyring, the load will be rejected.
 
+config MODULE_SIG_UEFI
+	bool "Allow modules signed with certs stored in UEFI"
+	depends on MODULE_SIG && MODULE_SIG_BLACKLIST && EFI
+	select EFI_SIGNATURE_LIST_PARSER
+	help
+	  This will import certificates stored in UEFI and allow modules
+	  signed with those to be loaded.  It will also disallow loading
+	  of modules stored in the UEFI dbx variable.
+
 choice
 	prompt "Which hash algorithm should modules be signed with?"
 	depends on MODULE_SIG
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c072b6..8848829 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
+obj-$(CONFIG_MODULE_SIG_UEFI) += modsign_uefi.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -114,6 +115,8 @@ obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
+$(obj)/modsign_uefi.o: KBUILD_CFLAGS += -fshort-wchar
+
 # config_data.h contains the same information as ikconfig.h but gzipped.
 # Info from config_data can be extracted from /proc/config*
 targets += config_data.gz
diff --git a/kernel/modsign_uefi.c b/kernel/modsign_uefi.c
new file mode 100644
index 0000000..b9237d7
--- /dev/null
+++ b/kernel/modsign_uefi.c
@@ -0,0 +1,90 @@
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <linux/efi.h>
+#include <keys/asymmetric-type.h>
+#include "module-internal.h"
+
+static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid, unsigned long *size)
+{
+	efi_status_t status;
+	unsigned long lsize = 4;
+	unsigned long tmpdb[4];
+	void *db = NULL;
+
+	status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		pr_err("Couldn't get size: 0x%lx\n", status);
+		return NULL;
+	}
+
+	db = kmalloc(lsize, GFP_KERNEL);
+	if (!db) {
+		pr_err("Couldn't allocate memory for uefi cert list\n");
+		goto out;
+	}
+
+	status = efi.get_variable(name, guid, NULL, &lsize, db);
+	if (status != EFI_SUCCESS) {
+		kfree(db);
+		db = NULL;
+		pr_err("Error reading db var: 0x%lx\n", status);
+	}
+out:
+	*size = lsize;
+	return db;
+}
+
+/*
+ *  * Load the certs contained in the UEFI databases
+ *   */
+static int __init load_uefi_certs(void)
+{
+	efi_guid_t secure_var = EFI_IMAGE_SECURITY_DATABASE_GUID;
+	efi_guid_t mok_var = EFI_SHIM_LOCK_GUID;
+	void *db = NULL, *dbx = NULL, *mok = NULL;
+	unsigned long dbsize = 0, dbxsize = 0, moksize = 0;
+	int rc = 0;
+
+	/* Check if SB is enabled and just return if not */
+	if (!efi_enabled(EFI_SECURE_BOOT))
+		return 0;
+
+	/* Get db, MokListRT, and dbx.  They might not exist, so it isn't
+	 * an error if we can't get them.
+	 */
+	db = get_cert_list(L"db", &secure_var, &dbsize);
+	if (!db) {
+		pr_err("MODSIGN: Couldn't get UEFI db list\n");
+	} else {
+		rc = parse_efi_signature_list(db, dbsize, modsign_keyring);
+		if (rc)
+			pr_err("Couldn't parse db signatures: %d\n", rc);
+		kfree(db);
+	}
+
+	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
+	if (!mok) {
+		pr_info("MODSIGN: Couldn't get UEFI MokListRT\n");
+	} else {
+		rc = parse_efi_signature_list(mok, moksize, modsign_keyring);
+		if (rc)
+			pr_err("Couldn't parse MokListRT signatures: %d\n", rc);
+		kfree(mok);
+	}
+
+	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
+	if (!dbx) {
+		pr_info("MODSIGN: Couldn't get UEFI dbx list\n");
+	} else {
+		rc = parse_efi_signature_list(dbx, dbxsize,
+			modsign_blacklist);
+		if (rc)
+			pr_err("Couldn't parse dbx signatures: %d\n", rc);
+		kfree(dbx);
+	}
+
+	return rc;
+}
+late_initcall(load_uefi_certs);
-- 
1.8.0.2

