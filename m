Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3LPJcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3LPJcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:32:31 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v6 08/14] efi: export efi runtime memory mapping to sysfs
Date: Mon, 16 Dec 2013 17:30:29 +0800
Message-Id: <1387186235-15972-9-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec kernel will need exactly same mapping for
efi runtime memory ranges. Thus here export the
runtime ranges mapping to sysfs, kexec-tools
will assemble them and pass to 2nd kernel via
setup_data.

Introducing a new directory /sys/firmware/efi/runtime-map
Just like /sys/firmware/memmap. Containing below attribute
in each file of that directory:
attribute  num_pages  phys_addr  type  virt_addr

Changelog:
 - Cleaup code, add function efi_save_runtime_map
 - Improve err handling
 - Add macros for sysfs _show functions
 - Remove forward declarations.
 Matt:
 - s/efi-runtime-map.c/runtime-map.c
 - Change dir name to runtime-map
 - Changelog and documentation fixes.
 - Documentation fixes.
 - Update to use desc_size in efi_runtime_map
 - Kconfig EFI_RUNTIME_MAP depends on X86 && KEXEC && EFI
 Boris:
 - Documentation grammar/spelling fix
 - krealloc fix.
 - Move efi_runtime_map_init to efisubsys_initcall.
 - Remove 'if EXPERT' for EFI_RUNTIME_MAP Kconfig option
 - save_runtime_map: move error handling code into the function itself.
 - other code improvement.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 .../ABI/testing/sysfs-firmware-efi-runtime-map     |  34 ++++
 arch/x86/platform/efi/efi.c                        |  38 ++++-
 drivers/firmware/efi/Kconfig                       |  11 ++
 drivers/firmware/efi/Makefile                      |   1 +
 drivers/firmware/efi/efi.c                         |   6 +
 drivers/firmware/efi/runtime-map.c                 | 181 +++++++++++++++++++++
 include/linux/efi.h                                |   5 +
 7 files changed, 274 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
 create mode 100644 drivers/firmware/efi/runtime-map.c

diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
new file mode 100644
index 0000000..c61b9b3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
@@ -0,0 +1,34 @@
+What:		/sys/firmware/efi/runtime-map/
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	Switching efi runtime services to virtual mode requires
+		that all efi memory ranges which have the runtime attribute
+		bit set to be mapped to virtual addresses.
+
+		The efi runtime services can only be switched to virtual
+		mode once without rebooting. The kexec kernel must maintain
+		the same physical to virtual address mappings as the first
+		kernel. The mappings are exported to sysfs so userspace tools
+		can reassemble them and pass them into the kexec kernel.
+
+		/sys/firmware/efi/runtime-map/ is the directory the kernel
+		exports that information in.
+
+		subdirectories are named with the number of the memory range:
+
+			/sys/firmware/efi/runtime-map/0
+			/sys/firmware/efi/runtime-map/1
+			/sys/firmware/efi/runtime-map/2
+			/sys/firmware/efi/runtime-map/3
+			...
+
+		Each subdirectory contains five files:
+
+		attribute : The attributes of the memory range.
+		num_pages : The size of the memory range in pages.
+		phys_addr : The physical address of the memory range.
+		type      : The type of the memory range.
+		virt_addr : The virtual address of the memory range.
+
+		Above values are all hexadecimal numbers with the '0x' prefix.
+Users:		Kexec
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3e8b760..11b110f9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -76,6 +76,9 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 	{NULL_GUID, NULL, NULL},
 };
 
+static void *efi_runtime_map;
+static int nr_efi_runtime_map;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -810,6 +813,24 @@ static void __init efi_merge_regions(void)
 	}
 }
 
+static int __init save_runtime_map(efi_memory_desc_t *md, int idx)
+{
+	void *p;
+	p = krealloc(efi_runtime_map, (idx + 1) * memmap.desc_size, GFP_KERNEL);
+	if (!p)
+		goto out;
+
+	efi_runtime_map = p;
+	memcpy(efi_runtime_map + idx * memmap.desc_size, md, memmap.desc_size);
+
+	return 0;
+out:
+	kfree(efi_runtime_map);
+	efi_runtime_map = NULL;
+	nr_efi_runtime_map = 0;
+	return -ENOMEM;
+}
+
 /*
  * Map efi memory ranges for runtime serivce and update new_memmap with virtual
  * addresses.
@@ -820,6 +841,7 @@ static void * __init efi_map_regions(int *count)
 	void *p, *tmp, *new_memmap = NULL;
 	unsigned long size;
 	u64 end, systab;
+	int err = 0;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -844,15 +866,22 @@ static void * __init efi_map_regions(int *count)
 		tmp = krealloc(new_memmap, (*count + 1) * memmap.desc_size,
 			       GFP_KERNEL);
 		if (!tmp)
-			goto out_krealloc;
+			goto out;
 		new_memmap = tmp;
 		memcpy(new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA) {
+			err = save_runtime_map(md, nr_efi_runtime_map);
+			if (err)
+				goto out;
+			nr_efi_runtime_map++;
+		}
 		(*count)++;
 	}
 
 	return new_memmap;
-out_krealloc:
+out:
 	kfree(new_memmap);
 	return NULL;
 }
@@ -899,6 +928,11 @@ void __init efi_enter_virtual_mode(void)
 		return;
 	}
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
+			      boot_params.efi_info.efi_memdesc_size);
+#endif
+
 	BUG_ON(!efi.systab);
 
 	efi_setup_page_tables();
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 3150aa4..730f5f2 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -39,4 +39,15 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 config UEFI_CPER
 	def_bool n
 
+config EFI_RUNTIME_MAP
+	bool "Export efi runtime maps to sysfs"
+	depends on X86 && EFI && KEXEC
+	default y
+	help
+	  Export efi runtime memory maps to /sys/firmware/efi/runtime-map.
+	  That memory map is used for example by kexec to set up efi virtual
+	  mapping the 2nd kernel, but can also be used for debugging purposes.
+
+	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
+
 endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 9ba156d..a58e0f1 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -5,3 +5,4 @@ obj-y					+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
+obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 6d0bc52..0527908 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -167,6 +167,12 @@ static int __init efisubsys_init(void)
 		goto err_unregister;
 	}
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+	error = efi_runtime_map_init(efi_kobj);
+	if (error)
+		goto err_remove_group;
+#endif
+
 	/* and the standard mountpoint for efivarfs */
 	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobj) {
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
new file mode 100644
index 0000000..97cdd16
--- /dev/null
+++ b/drivers/firmware/efi/runtime-map.c
@@ -0,0 +1,181 @@
+/*
+ * linux/drivers/efi/runtime-map.c
+ * Copyright (C) 2013 Red Hat, Inc., Dave Young <dyoung@redhat.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+
+#include <asm/setup.h>
+
+static void *efi_runtime_map;
+static int nr_efi_runtime_map;
+static u32 efi_memdesc_size;
+
+struct efi_runtime_map_entry {
+	efi_memory_desc_t md;
+	struct kobject kobj;   /* kobject for each entry */
+};
+
+static struct efi_runtime_map_entry **map_entries;
+
+struct map_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct efi_runtime_map_entry *entry, char *buf);
+};
+
+static inline struct map_attribute *to_map_attr(struct attribute *attr)
+{
+	return container_of(attr, struct map_attribute, attr);
+}
+
+static ssize_t type_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%x\n", entry->md.type);
+}
+
+#define EFI_RUNTIME_FIELD(var) entry->md.var
+
+#define EFI_RUNTIME_U64_ATTR_SHOW(name) \
+static ssize_t name##_show(struct efi_runtime_map_entry *entry, char *buf) \
+{ \
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", EFI_RUNTIME_FIELD(name)); \
+}
+
+EFI_RUNTIME_U64_ATTR_SHOW(phys_addr);
+EFI_RUNTIME_U64_ATTR_SHOW(virt_addr);
+EFI_RUNTIME_U64_ATTR_SHOW(num_pages);
+EFI_RUNTIME_U64_ATTR_SHOW(attribute);
+
+static inline struct efi_runtime_map_entry *to_map_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct efi_runtime_map_entry, kobj);
+}
+
+static ssize_t map_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct efi_runtime_map_entry *entry = to_map_entry(kobj);
+	struct map_attribute *map_attr = to_map_attr(attr);
+
+	return map_attr->show(entry, buf);
+}
+
+static struct map_attribute map_type_attr = __ATTR_RO(type);
+static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
+static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
+static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
+static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
+
+/*
+ * These are default attributes that are added for every memmap entry.
+ */
+static struct attribute *def_attrs[] = {
+	&map_type_attr.attr,
+	&map_phys_addr_attr.attr,
+	&map_virt_addr_attr.attr,
+	&map_num_pages_attr.attr,
+	&map_attribute_attr.attr,
+	NULL
+};
+
+static const struct sysfs_ops map_attr_ops = {
+	.show = map_attr_show,
+};
+
+static void map_release(struct kobject *kobj)
+{
+	struct efi_runtime_map_entry *entry;
+
+	entry = to_map_entry(kobj);
+	kfree(entry);
+}
+
+static struct kobj_type __refdata map_ktype = {
+	.sysfs_ops	= &map_attr_ops,
+	.default_attrs	= def_attrs,
+	.release	= map_release,
+};
+
+static struct kset *map_kset;
+
+static struct efi_runtime_map_entry *
+add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
+{
+	int ret;
+	struct efi_runtime_map_entry *entry;
+
+	if (!map_kset) {
+		map_kset = kset_create_and_add("runtime-map", NULL, kobj);
+		if (!map_kset)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		kset_unregister(map_kset);
+		return entry;
+	}
+
+	memcpy(&entry->md, efi_runtime_map + nr * efi_memdesc_size,
+	       sizeof(efi_memory_desc_t));
+
+	kobject_init(&entry->kobj, &map_ktype);
+	entry->kobj.kset = map_kset;
+	ret = kobject_add(&entry->kobj, NULL, "%d", nr);
+	if (ret) {
+		kobject_put(&entry->kobj);
+		kset_unregister(map_kset);
+		return ERR_PTR(ret);
+	}
+
+	return entry;
+}
+
+void efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size)
+{
+	efi_runtime_map = map;
+	nr_efi_runtime_map = nr_entries;
+	efi_memdesc_size = desc_size;
+}
+
+int __init efi_runtime_map_init(struct kobject *efi_kobj)
+{
+	int i, j, ret = 0;
+	struct efi_runtime_map_entry *entry;
+
+	if (!efi_runtime_map)
+		return 0;
+
+	map_entries = kzalloc(nr_efi_runtime_map * sizeof(entry), GFP_KERNEL);
+	if (!map_entries) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < nr_efi_runtime_map; i++) {
+		entry = add_sysfs_runtime_map_entry(efi_kobj, i);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			goto out_add_entry;
+		}
+		*(map_entries + i) = entry;
+	}
+
+	return 0;
+out_add_entry:
+	for (j = i - 1; j > 0; j--) {
+		entry = *(map_entries + j);
+		kobject_put(&entry->kobj);
+	}
+	if (map_kset)
+		kset_unregister(map_kset);
+out:
+	return ret;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 988af61..0a3fa38 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -876,4 +876,9 @@ int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+int efi_runtime_map_init(struct kobject *);
+void efi_runtime_map_setup(void *, int, u32);
+#endif
+
 #endif /* _LINUX_EFI_H */
-- 
1.8.3.1

