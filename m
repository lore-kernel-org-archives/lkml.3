Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab3DDM2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:28:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49832 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759744Ab3DDM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:27:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Tom Gundersen <teg@jklm.no>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4/6] efivars: Move pstore code into the new EFI directory
Date: Thu,  4 Apr 2013 13:18:53 +0100
Message-Id: <1365077935-6859-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

efivars.c has grown far too large and needs to be divided up. Create a new
directory and move the persistence storage code to efi-pstore.c now that it
uses the new efivar API. This helps us to greatly reduce the size of efivars.c
and paves the way for moving other code out of efivars.c.

Note that because CONFIG_EFI_VARS can be built as a module efi-pstore must also
include support for buildilng as a module.

Cc: Tom Gundersen <teg@jklm.no>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 MAINTAINERS                       |    2 +-
 drivers/firmware/Kconfig          |   42 +-----
 drivers/firmware/Makefile         |    1 +
 drivers/firmware/efi/Kconfig      |   45 ++++++
 drivers/firmware/efi/Makefile     |    4 +
 drivers/firmware/efi/efi-pstore.c |  244 ++++++++++++++++++++++++++++++++
 drivers/firmware/efivars.c        |  277 ++-----------------------------------
 include/linux/efi.h               |   38 +++++
 8 files changed, 346 insertions(+), 307 deletions(-)
 create mode 100644 drivers/firmware/efi/Kconfig
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/efi-pstore.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cf5fd3..9d106da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6319,7 +6319,7 @@ S:	Maintained
 T:	git git://git.infradead.org/users/cbou/linux-pstore.git
 F:	fs/pstore/
 F:	include/linux/pstore*
-F:	drivers/firmware/efivars.c
+F:	drivers/firmware/efi/efi-pstore.c
 F:	drivers/acpi/apei/erst.c
 
 PTP HARDWARE CLOCK SUPPORT
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 96d84ad..9387630 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -36,47 +36,6 @@ config FIRMWARE_MEMMAP
 
       See also Documentation/ABI/testing/sysfs-firmware-memmap.
 
-config EFI_VARS
-	tristate "EFI Variable Support via sysfs"
-	depends on EFI
-	default n
-	help
-	  If you say Y here, you are able to get EFI (Extensible Firmware
-	  Interface) variable information via sysfs.  You may read,
-	  write, create, and destroy EFI variables through this interface.
-
-	  Note that using this driver in concert with efibootmgr requires
-	  at least test release version 0.5.0-test3 or later, which is
-	  available from Matt Domsch's website located at:
-	  <http://linux.dell.com/efibootmgr/testing/efibootmgr-0.5.0-test3.tar.gz>
-
-	  Subsequent efibootmgr releases may be found at:
-	  <http://linux.dell.com/efibootmgr>
-
-config EFI_VARS_GENERIC_OPS
-	bool
-	depends on EFI
-	depends on !GOOGLE_SMI
-	default y
-
-config EFI_VARS_PSTORE
-	bool "Register efivars backend for pstore"
-	depends on EFI_VARS && PSTORE
-	default y
-	help
-	  Say Y here to enable use efivars as a backend to pstore. This
-	  will allow writing console messages, crash dumps, or anything
-	  else supported by pstore to EFI variables.
-
-config EFI_VARS_PSTORE_DEFAULT_DISABLE
-	bool "Disable using efivars as a pstore backend by default"
-	depends on EFI_VARS_PSTORE
-	default n
-	help
-	  Saying Y here will disable the use of efivars as a storage
-	  backend for pstore by default. This setting can be overridden
-	  using the efivars module's pstore_disable parameter.
-
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
@@ -170,5 +129,6 @@ config ISCSI_IBFT
 	  Otherwise, say N.
 
 source "drivers/firmware/google/Kconfig"
+source "drivers/firmware/efi/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 5a7e273..31bf68c 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
+obj-$(CONFIG_EFI)		+= efi/
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
new file mode 100644
index 0000000..c011f9c
--- /dev/null
+++ b/drivers/firmware/efi/Kconfig
@@ -0,0 +1,45 @@
+menu "EFI (Extensible Firmware Interface) Support"
+	depends on EFI
+
+config EFI_VARS
+	tristate "EFI Variable Support via sysfs"
+	depends on EFI
+	default n
+	help
+	  If you say Y here, you are able to get EFI (Extensible Firmware
+	  Interface) variable information via sysfs.  You may read,
+	  write, create, and destroy EFI variables through this interface.
+
+	  Note that using this driver in concert with efibootmgr requires
+	  at least test release version 0.5.0-test3 or later, which is
+	  available from Matt Domsch's website located at:
+	  <http://linux.dell.com/efibootmgr/testing/efibootmgr-0.5.0-test3.tar.gz>
+
+	  Subsequent efibootmgr releases may be found at:
+	  <http://linux.dell.com/efibootmgr>
+
+config EFI_VARS_GENERIC_OPS
+	bool
+	depends on EFI
+	depends on !GOOGLE_SMI
+	default y
+
+config EFI_VARS_PSTORE
+	tristate "Register efivars backend for pstore"
+	depends on EFI_VARS && PSTORE
+	default y
+	help
+	  Say Y here to enable use efivars as a backend to pstore. This
+	  will allow writing console messages, crash dumps, or anything
+	  else supported by pstore to EFI variables.
+
+config EFI_VARS_PSTORE_DEFAULT_DISABLE
+	bool "Disable using efivars as a pstore backend by default"
+	depends on EFI_VARS_PSTORE
+	default n
+	help
+	  Saying Y here will disable the use of efivars as a storage
+	  backend for pstore by default. This setting can be overridden
+	  using the efivars module's pstore_disable parameter.
+
+endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
new file mode 100644
index 0000000..e03cd51
--- /dev/null
+++ b/drivers/firmware/efi/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for linux kernel
+#
+obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
new file mode 100644
index 0000000..088c6ae
--- /dev/null
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -0,0 +1,244 @@
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/pstore.h>
+
+#define DUMP_NAME_LEN 52
+
+static bool efivars_pstore_disable =
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+
+#define PSTORE_EFI_ATTRIBUTES \
+	(EFI_VARIABLE_NON_VOLATILE | \
+	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+	 EFI_VARIABLE_RUNTIME_ACCESS)
+
+static int efi_pstore_open(struct pstore_info *psi)
+{
+	efivar_entry_iter_begin();
+	psi->data = NULL;
+	return 0;
+}
+
+static int efi_pstore_close(struct pstore_info *psi)
+{
+	efivar_entry_iter_end();
+	psi->data = NULL;
+	return 0;
+}
+
+struct pstore_read_data {
+	u64 *id;
+	enum pstore_type_id *type;
+	int *count;
+	struct timespec *timespec;
+	char **buf;
+};
+
+static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
+{
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	struct pstore_read_data *cb_data = data;
+	char name[DUMP_NAME_LEN];
+	int i;
+	int cnt;
+	unsigned int part;
+	unsigned long time, size;
+
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		name[i] = entry->var.VariableName[i];
+
+	if (sscanf(name, "dump-type%u-%u-%d-%lu",
+		   cb_data->type, &part, &cnt, &time) == 4) {
+		*cb_data->id = part;
+		*cb_data->count = cnt;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else if (sscanf(name, "dump-type%u-%u-%lu",
+			  cb_data->type, &part, &time) == 3) {
+		/*
+		 * Check if an old format,
+		 * which doesn't support holding
+		 * multiple logs, remains.
+		 */
+		*cb_data->id = part;
+		*cb_data->count = 0;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else
+		return 0;
+
+	efivar_entry_size(entry, &size);
+	*cb_data->buf = kmalloc(size, GFP_KERNEL);
+	if (*cb_data->buf == NULL)
+		return -ENOMEM;
+	memcpy(*cb_data->buf, entry->var.Data, size);
+	return size;
+}
+
+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
+			       int *count, struct timespec *timespec,
+			       char **buf, struct pstore_info *psi)
+{
+	struct pstore_read_data data;
+
+	data.id = id;
+	data.type = type;
+	data.count = count;
+	data.timespec = timespec;
+	data.buf = buf;
+
+	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
+				   (struct efivar_entry **)&psi->data);
+}
+
+static int efi_pstore_write(enum pstore_type_id type,
+		enum kmsg_dump_reason reason, u64 *id,
+		unsigned int part, int count, size_t size,
+		struct pstore_info *psi)
+{
+	char name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	int i, ret = 0;
+
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
+		get_seconds());
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
+				    !pstore_cannot_block_path(reason),
+				    size, psi->buf);
+
+	if (size && !ret && reason == KMSG_DUMP_OOPS)
+		efivar_run_worker();
+
+	*id = part;
+	return ret;
+};
+
+struct pstore_erase_data {
+	u64 id;
+	enum pstore_type_id type;
+	int count;
+	struct timespec time;
+	efi_char16_t *name;
+};
+
+/*
+ * Clean up an entry with the same name
+ */
+static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
+{
+	struct pstore_erase_data *ed = data;
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	efi_char16_t efi_name_old[DUMP_NAME_LEN];
+	efi_char16_t *efi_name = ed->name;
+	unsigned long utf16_len = utf16_strlen(ed->name);
+	char name_old[DUMP_NAME_LEN];
+	int i;
+
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	if (utf16_strncmp(entry->var.VariableName,
+			  efi_name, (size_t)utf16_len)) {
+		/*
+		 * Check if an old format, which doesn't support
+		 * holding multiple logs, remains.
+		 */
+		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
+			(unsigned int)ed->id, ed->time.tv_sec);
+
+		for (i = 0; i < DUMP_NAME_LEN; i++)
+			efi_name_old[i] = name_old[i];
+
+		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
+				  utf16_strlen(efi_name_old)))
+			return 0;
+	}
+
+	/* found */
+	__efivar_entry_delete(entry);
+	return 1;
+}
+
+static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
+			    struct timespec time, struct pstore_info *psi)
+{
+	struct pstore_erase_data edata;
+	struct efivar_entry *entry;
+	char name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	int found, i;
+
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
+		time.tv_sec);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	edata.id = id;
+	edata.type = type;
+	edata.count = count;
+	edata.time = time;
+	edata.name = efi_name;
+
+	efivar_entry_iter_begin();
+	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
+	efivar_entry_iter_end();
+
+	if (found)
+		efivar_unregister(entry);
+
+	return 0;
+}
+
+static struct pstore_info efi_pstore_info = {
+	.owner		= THIS_MODULE,
+	.name		= "efi",
+	.open		= efi_pstore_open,
+	.close		= efi_pstore_close,
+	.read		= efi_pstore_read,
+	.write		= efi_pstore_write,
+	.erase		= efi_pstore_erase,
+};
+
+static __init int efivars_pstore_init(void)
+{
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	if (!efivars_kobject())
+		return 0;
+
+	if (efivars_pstore_disable)
+		return 0;
+
+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (!efi_pstore_info.buf)
+		return -ENOMEM;
+
+	efi_pstore_info.bufsize = 1024;
+	spin_lock_init(&efi_pstore_info.buf_lock);
+
+	pstore_register(&efi_pstore_info);
+
+	return 0;
+}
+
+static __exit void efivars_pstore_exit(void)
+{
+}
+
+module_init(efivars_pstore_init);
+module_exit(efivars_pstore_exit);
+
+MODULE_DESCRIPTION("EFI variable backend for pstore");
+MODULE_LICENSE("GPL");
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a0f5534..949d8d4 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -78,7 +78,6 @@
 #include <linux/kobject.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/pstore.h>
 #include <linux/ctype.h>
 
 #include <linux/fs.h>
@@ -95,15 +94,9 @@ MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
 
-#define DUMP_NAME_LEN 52
-
 static LIST_HEAD(efivarfs_list);
-static LIST_HEAD(efivar_sysfs_list);
-
-static bool efivars_pstore_disable =
-	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
-
-module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+LIST_HEAD(efivar_sysfs_list);
+EXPORT_SYMBOL_GPL(efivar_sysfs_list);
 
 struct efivar_attribute {
 	struct attribute attr;
@@ -114,11 +107,6 @@ struct efivar_attribute {
 /* Private pointer to registered efivars */
 static struct efivars *__efivars;
 
-#define PSTORE_EFI_ATTRIBUTES \
-	(EFI_VARIABLE_NON_VOLATILE | \
-	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
-	 EFI_VARIABLE_RUNTIME_ACCESS)
-
 static struct kset *efivars_kset;
 
 static struct bin_attribute *efivars_new_var;
@@ -148,34 +136,6 @@ static void efivar_update_sysfs_entries(struct work_struct *);
 static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
 static bool efivar_wq_enabled = true;
 
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
@@ -598,12 +558,6 @@ static struct kobj_type efivar_ktype = {
 	.default_attrs = def_attrs,
 };
 
-static inline void
-efivar_unregister(struct efivar_entry *var)
-{
-	kobject_put(&var->kobj);
-}
-
 static int efivarfs_file_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -1129,220 +1083,6 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 	.create = efivarfs_create,
 };
 
-#ifdef CONFIG_EFI_VARS_PSTORE
-
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	efivar_entry_iter_begin();
-	psi->data = NULL;
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	efivar_entry_iter_end();
-	psi->data = NULL;
-	return 0;
-}
-
-struct pstore_read_data {
-	u64 *id;
-	enum pstore_type_id *type;
-	int *count;
-	struct timespec *timespec;
-	char **buf;
-};
-
-static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
-{
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct pstore_read_data *cb_data = data;
-	char name[DUMP_NAME_LEN];
-	int i;
-	int cnt;
-	unsigned int part;
-	unsigned long time, size;
-
-	if (efi_guidcmp(entry->var.VendorGuid, vendor))
-		return 0;
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		name[i] = entry->var.VariableName[i];
-
-	if (sscanf(name, "dump-type%u-%u-%d-%lu",
-		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
-		*cb_data->count = cnt;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
-	} else if (sscanf(name, "dump-type%u-%u-%lu",
-			  cb_data->type, &part, &time) == 3) {
-		/*
-		 * Check if an old format,
-		 * which doesn't support holding
-		 * multiple logs, remains.
-		 */
-		*cb_data->id = part;
-		*cb_data->count = 0;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
-	} else
-		return 0;
-
-	efivar_entry_size(entry, &size);
-	*cb_data->buf = kmalloc(size, GFP_KERNEL);
-	if (*cb_data->buf == NULL)
-		return -ENOMEM;
-	memcpy(*cb_data->buf, entry->var.Data, size);
-	return size;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	struct pstore_read_data data;
-
-	data.id = id;
-	data.type = type;
-	data.count = count;
-	data.timespec = timespec;
-	data.buf = buf;
-
-	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
-				   (struct efivar_entry **)&psi->data);
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	char name[DUMP_NAME_LEN];
-	efi_char16_t efi_name[DUMP_NAME_LEN];
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	int i, ret = 0;
-
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
-		get_seconds());
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
-
-	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-				    !pstore_cannot_block_path(reason),
-				    size, psi->buf);
-
-	if (size && !ret && reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
-		schedule_work(&efivar_work);
-
-	*id = part;
-	return ret;
-};
-
-struct pstore_erase_data {
-	u64 id;
-	enum pstore_type_id type;
-	int count;
-	struct timespec time;
-	efi_char16_t *name;
-};
-
-/*
- * Clean up an entry with the same name
- */
-static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
-{
-	struct pstore_erase_data *ed = data;
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	efi_char16_t efi_name_old[DUMP_NAME_LEN];
-	efi_char16_t *efi_name = ed->name;
-	unsigned long utf16_len = utf16_strlen(ed->name);
-	char name_old[DUMP_NAME_LEN];
-	int i;
-
-	if (efi_guidcmp(entry->var.VendorGuid, vendor))
-		return 0;
-
-	if (utf16_strncmp(entry->var.VariableName,
-			  efi_name, (size_t)utf16_len)) {
-		/*
-		 * Check if an old format, which doesn't support
-		 * holding multiple logs, remains.
-		 */
-		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
-			(unsigned int)ed->id, ed->time.tv_sec);
-
-		for (i = 0; i < DUMP_NAME_LEN; i++)
-			efi_name_old[i] = name_old[i];
-
-		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
-				  utf16_strlen(efi_name_old)))
-			return 0;
-	}
-
-	/* found */
-	__efivar_entry_delete(entry);
-	return 1;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	struct pstore_erase_data edata;
-	struct efivar_entry *entry;
-	char name[DUMP_NAME_LEN];
-	efi_char16_t efi_name[DUMP_NAME_LEN];
-	int found, i;
-
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
-
-	edata.id = id;
-	edata.type = type;
-	edata.count = count;
-	edata.time = time;
-	edata.name = efi_name;
-
-	efivar_entry_iter_begin();
-	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
-	efivar_entry_iter_end();
-
-	if (found)
-		efivar_unregister(entry);
-
-	return 0;
-}
-
-static struct pstore_info efi_pstore_info = {
-	.owner		= THIS_MODULE,
-	.name		= "efi",
-	.open		= efi_pstore_open,
-	.close		= efi_pstore_close,
-	.read		= efi_pstore_read,
-	.write		= efi_pstore_write,
-	.erase		= efi_pstore_erase,
-};
-
-static void efivar_pstore_register(void)
-{
-	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efi_pstore_info.buf) {
-		efi_pstore_info.bufsize = 1024;
-		spin_lock_init(&efi_pstore_info.buf_lock);
-		pstore_register(&efi_pstore_info);
-	}
-}
-#else
-static void efivar_pstore_register(void)
-{
-	return;
-}
-#endif
-
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -2365,6 +2105,16 @@ struct kobject *efivars_kobject(void)
 EXPORT_SYMBOL_GPL(efivars_kobject);
 
 /**
+ * efivar_run_worker - schedule the efivar worker thread
+ */
+void efivar_run_worker(void)
+{
+	if (efivar_wq_enabled)
+		schedule_work(&efivar_work);
+}
+EXPORT_SYMBOL_GPL(efivar_run_worker);
+
+/**
  * efivars_register - register an efivars
  * @efivars: efivars to register
  * @ops: efivars operations
@@ -2382,9 +2132,6 @@ int efivars_register(struct efivars *efivars,
 
 	__efivars = efivars;
 
-	if (!efivars_pstore_disable)
-		efivar_pstore_register();
-
 	register_filesystem(&efivarfs_type);
 
 	return 0;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 78fc71d..a9f18e4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -744,6 +744,34 @@ utf16_strlen(efi_char16_t *s)
 
 #if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
 /*
+ * Return the number of bytes is the length of this string
+ * Note: this is NOT the same as the number of unicode characters
+ */
+static inline unsigned long
+utf16_strsize(efi_char16_t *data, unsigned long maxlength)
+{
+	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
+}
+
+static inline int
+utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
+{
+	while (1) {
+		if (len == 0)
+			return 0;
+		if (*a < *b)
+			return -1;
+		if (*a > *b)
+			return 1;
+		if (*a == 0) /* implies *b == 0 */
+			return 0;
+		a++;
+		b++;
+		len--;
+	}
+}
+
+/*
  * EFI Variable support.
  *
  * Different firmware drivers can expose their EFI-like variables using
@@ -795,6 +823,14 @@ struct efivar_entry {
 	struct kobject kobj;
 };
 
+extern struct list_head efivar_sysfs_list;
+
+static inline void
+efivar_unregister(struct efivar_entry *var)
+{
+	kobject_put(&var->kobj);
+}
+
 int efivars_register(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *kobject);
@@ -834,6 +870,8 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 
 bool efivar_validate(struct efi_variable *var, u8 *data, unsigned long len);
 
+void efivar_run_worker(void);
+
 int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
-- 
1.7.10.4

