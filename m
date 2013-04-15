Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3DOUKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:10:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40554 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3DOUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:10:05 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V6 1/3] Move utf16 functions to kernel core and rename
Date: Mon, 15 Apr 2013 13:09:45 -0700
Message-Id: <1366056587-24414-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 50.0.250.146
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to use the utf16 functions that are currently present
in the EFI variables code in platform-specific code as well. Move them to
the kernel core, and in the process rename them to accurately describe what
they do - they don't handle UTF16, only UCS2.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/firmware/Kconfig    |  1 +
 drivers/firmware/efivars.c  | 80 ++++++++++-----------------------------------
 include/linux/ucs2_string.h | 14 ++++++++
 lib/Kconfig                 |  3 ++
 lib/Makefile                |  2 ++
 lib/ucs2_string.c           | 51 +++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+), 62 deletions(-)
 create mode 100644 include/linux/ucs2_string.h
 create mode 100644 lib/ucs2_string.c

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 42c759a..3e53200 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -39,6 +39,7 @@ config FIRMWARE_MEMMAP
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI
+	select UCS2_STRING
 	default n
 	help
 	  If you say Y here, you are able to get EFI (Extensible Firmware
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index bf15d81..182ce94 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -80,6 +80,7 @@
 #include <linux/slab.h>
 #include <linux/pstore.h>
 #include <linux/ctype.h>
+#include <linux/ucs2_string.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
@@ -172,51 +173,6 @@ static void efivar_update_sysfs_entries(struct work_struct *);
 static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
 static bool efivar_wq_enabled = true;
 
-/* Return the number of unicode characters in data */
-static unsigned long
-utf16_strnlen(efi_char16_t *s, size_t maxlength)
-{
-	unsigned long length = 0;
-
-	while (*s++ != 0 && length < maxlength)
-		length++;
-	return length;
-}
-
-static inline unsigned long
-utf16_strlen(efi_char16_t *s)
-{
-	return utf16_strnlen(s, ~0UL);
-}
-
-/*
- * Return the number of bytes is the length of this string
- * Note: this is NOT the same as the number of unicode characters
- */
-static inline unsigned long
-utf16_strsize(efi_char16_t *data, unsigned long maxlength)
-{
-	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
-}
-
-static inline int
-utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
-{
-	while (1) {
-		if (len == 0)
-			return 0;
-		if (*a < *b)
-			return -1;
-		if (*a > *b)
-			return 1;
-		if (*a == 0) /* implies *b == 0 */
-			return 0;
-		a++;
-		b++;
-		len--;
-	}
-}
-
 static bool
 validate_device_path(struct efi_variable *var, int match, u8 *buffer,
 		     unsigned long len)
@@ -268,7 +224,7 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer,
 	u16 filepathlength;
 	int i, desclength = 0, namelen;
 
-	namelen = utf16_strnlen(var->VariableName, sizeof(var->VariableName));
+	namelen = ucs2_strnlen(var->VariableName, sizeof(var->VariableName));
 
 	/* Either "Boot" or "Driver" followed by four digits of hex */
 	for (i = match; i < match+4; i++) {
@@ -291,7 +247,7 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer,
 	 * There's no stored length for the description, so it has to be
 	 * found by hand
 	 */
-	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
+	desclength = ucs2_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
 
 	/* Each boot entry must have a descriptor */
 	if (!desclength)
@@ -581,7 +537,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	spin_lock_irq(&efivars->lock);
 
 	status = check_var_size_locked(efivars, new_var->Attributes,
-	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+	       new_var->DataSize + ucs2_strsize(new_var->VariableName, 1024));
 
 	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
 		status = efivars->ops->set_variable(new_var->VariableName,
@@ -759,7 +715,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	 * QueryVariableInfo() isn't supported by the firmware.
 	 */
 
-	varsize = datasize + utf16_strsize(var->var.VariableName, 1024);
+	varsize = datasize + ucs2_strsize(var->var.VariableName, 1024);
 	status = check_var_size(efivars, attributes, varsize);
 
 	if (status != EFI_SUCCESS) {
@@ -1211,7 +1167,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		inode = NULL;
 
-		len = utf16_strlen(entry->var.VariableName);
+		len = ucs2_strlen(entry->var.VariableName);
 
 		/* name, plus '-', plus GUID, plus NUL*/
 		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
@@ -1469,8 +1425,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 		if (efi_guidcmp(entry->var.VendorGuid, vendor))
 			continue;
-		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name))) {
+		if (ucs2_strncmp(entry->var.VariableName, efi_name,
+				  ucs2_strlen(efi_name))) {
 			/*
 			 * Check if an old format,
 			 * which doesn't support holding
@@ -1482,8 +1438,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 			for (i = 0; i < DUMP_NAME_LEN; i++)
 				efi_name_old[i] = name_old[i];
 
-			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
-					  utf16_strlen(efi_name_old)))
+			if (ucs2_strncmp(entry->var.VariableName, efi_name_old,
+					  ucs2_strlen(efi_name_old)))
 				continue;
 		}
 
@@ -1561,8 +1517,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(new_var->VariableName, 1024);
+		strsize1 = ucs2_strsize(search_efivar->var.VariableName, 1024);
+		strsize2 = ucs2_strsize(new_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(&(search_efivar->var.VariableName),
 				new_var->VariableName, strsize1) &&
@@ -1578,7 +1534,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	}
 
 	status = check_var_size_locked(efivars, new_var->Attributes,
-	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+	       new_var->DataSize + ucs2_strsize(new_var->VariableName, 1024));
 
 	if (status && status != EFI_UNSUPPORTED) {
 		spin_unlock_irq(&efivars->lock);
@@ -1602,7 +1558,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
-					   utf16_strsize(new_var->VariableName,
+					   ucs2_strsize(new_var->VariableName,
 							 1024),
 					   new_var->VariableName,
 					   &new_var->VendorGuid);
@@ -1632,8 +1588,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(del_var->VariableName, 1024);
+		strsize1 = ucs2_strsize(search_efivar->var.VariableName, 1024);
+		strsize2 = ucs2_strsize(del_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(&(search_efivar->var.VariableName),
 				del_var->VariableName, strsize1) &&
@@ -1679,9 +1635,9 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 	unsigned long strsize1, strsize2;
 	bool found = false;
 
-	strsize1 = utf16_strsize(variable_name, 1024);
+	strsize1 = ucs2_strsize(variable_name, 1024);
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
+		strsize2 = ucs2_strsize(entry->var.VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(variable_name, &(entry->var.VariableName),
 				strsize2) &&
diff --git a/include/linux/ucs2_string.h b/include/linux/ucs2_string.h
new file mode 100644
index 0000000..cbb20af
--- /dev/null
+++ b/include/linux/ucs2_string.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_UCS2_STRING_H_
+#define _LINUX_UCS2_STRING_H_
+
+#include <linux/types.h>	/* for size_t */
+#include <linux/stddef.h>	/* for NULL */
+
+typedef u16 ucs2_char_t;
+
+unsigned long ucs2_strnlen(const ucs2_char_t *s, size_t maxlength);
+unsigned long ucs2_strlen(const ucs2_char_t *s);
+unsigned long ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength);
+int ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len);
+
+#endif /* _LINUX_UCS2_STRING_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 3958dc4..fe01d41 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -404,4 +404,7 @@ config OID_REGISTRY
 	help
 	  Enable fast lookup object identifier registry.
 
+config UCS2_STRING
+        tristate
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index d7946ff..6e2cc56 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -174,3 +174,5 @@ quiet_cmd_build_OID_registry = GEN     $@
       cmd_build_OID_registry = perl $(srctree)/$(src)/build_OID_registry $< $@
 
 clean-files	+= oid_registry_data.c
+
+obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
new file mode 100644
index 0000000..6f500ef
--- /dev/null
+++ b/lib/ucs2_string.c
@@ -0,0 +1,51 @@
+#include <linux/ucs2_string.h>
+#include <linux/module.h>
+
+/* Return the number of unicode characters in data */
+unsigned long
+ucs2_strnlen(const ucs2_char_t *s, size_t maxlength)
+{
+        unsigned long length = 0;
+
+        while (*s++ != 0 && length < maxlength)
+                length++;
+        return length;
+}
+EXPORT_SYMBOL(ucs2_strnlen);
+
+unsigned long
+ucs2_strlen(const ucs2_char_t *s)
+{
+        return ucs2_strnlen(s, ~0UL);
+}
+EXPORT_SYMBOL(ucs2_strlen);
+
+/*
+ * Return the number of bytes is the length of this string
+ * Note: this is NOT the same as the number of unicode characters
+ */
+unsigned long
+ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength)
+{
+        return ucs2_strnlen(data, maxlength/sizeof(ucs2_char_t)) * sizeof(ucs2_char_t);
+}
+EXPORT_SYMBOL(ucs2_strsize);
+
+int
+ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len)
+{
+        while (1) {
+                if (len == 0)
+                        return 0;
+                if (*a < *b)
+                        return -1;
+                if (*a > *b)
+                        return 1;
+                if (*a == 0) /* implies *b == 0 */
+                        return 0;
+                a++;
+                b++;
+                len--;
+        }
+}
+EXPORT_SYMBOL(ucs2_strncmp);
-- 
1.8.1.2

