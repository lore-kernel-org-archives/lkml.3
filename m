Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3KEIij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:38:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab3KEIig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:38:36 -0500
Message-Id: <20131105082718.185728964@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 16:20:12 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de,
        Dave Young <dyoung@redhat.com>
Subject: [patch 5/7 v2] export efi runtime memory mapping to sysfs
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=05-export-efi-runtime-mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec kernel will need exactly same mapping for
efi runtime memory ranges. Thus here export the
runtime ranges mapping to sysfs, kexec-tools
will assemble them and pass to 2nd kernel via
setup_data.

Introducing a new directly /sys/firmware/efi/efi-runtime-map
Just like /sys/firmware/memmap. Containing below attribute
in each file of that directory:
attribute  num_pages  phys_addr  type  virt_addr

It will not work for efi 32bit. Only x86_64 currently.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/ABI/testing/sysfs-efi-runtime-map |   45 ++++++
 arch/x86/include/asm/efi.h                      |    3 
 arch/x86/platform/efi/efi.c                     |   11 +
 drivers/firmware/efi/Kconfig                    |   10 +
 drivers/firmware/efi/Makefile                   |    1 
 drivers/firmware/efi/efi-runtime-map.c          |  164 ++++++++++++++++++++++++
 drivers/firmware/efi/efi.c                      |    3 
 include/linux/efi.h                             |    6 
 8 files changed, 242 insertions(+), 1 deletion(-)

--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -76,6 +76,9 @@ static __initdata efi_config_table_type_
 	{NULL_GUID, NULL, NULL},
 };
 
+efi_memory_desc_t *efi_runtime_map;
+int nr_efi_runtime_map;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -852,6 +855,14 @@ static void efi_map_regions(void **new_m
 
 		memcpy(*new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+			md->type != EFI_BOOT_SERVICES_DATA) {
+			efi_runtime_map = krealloc(efi_runtime_map,
+					(nr_efi_runtime_map + 1) *
+					sizeof(efi_memory_desc_t), GFP_KERNEL);
+			*(efi_runtime_map + nr_efi_runtime_map) = *md;
+			nr_efi_runtime_map++;
+		}
 		(*count)++;
 	}
 
--- linux-2.6.orig/drivers/firmware/efi/Kconfig
+++ linux-2.6/drivers/firmware/efi/Kconfig
@@ -36,4 +36,14 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 	  backend for pstore by default. This setting can be overridden
 	  using the efivars module's pstore_disable parameter.
 
+config EFI_RUNTIME_MAP
+	bool "Add efi runtime map to sysfs" if EXPERT
+	default X86 && EFI
+	help
+	  Add the efi runtime memory map to /sys/firmware/efi/runtime-map.
+	  That memory map is used for example by kexec to set up efi virtual
+	  mapping the 2nd kernel, but can also be used for debugging purposes.
+
+	  See also Documentation/ABI/testing/sysfs-efi-runtime-map.
+
 endmenu
--- linux-2.6.orig/drivers/firmware/efi/Makefile
+++ linux-2.6/drivers/firmware/efi/Makefile
@@ -4,3 +4,4 @@
 obj-y					+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_EFI_RUNTIME_MAP)		+= efi-runtime-map.o
--- /dev/null
+++ linux-2.6/drivers/firmware/efi/efi-runtime-map.c
@@ -0,0 +1,164 @@
+/*
+ * linux/drivers/efi/efi-runtime-map.c
+ * Copyright (C) 2013 Red Hat, Inc., Dave Young <dyoung@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+
+struct efi_runtime_map_entry {
+	efi_memory_desc_t md;
+	struct kobject kobj;   /* kobject for each entry */
+};
+
+static struct efi_runtime_map_entry *map_entries;
+
+static ssize_t map_attr_show(struct kobject *kobj,
+				struct attribute *attr, char *buf);
+static ssize_t type_show(struct efi_runtime_map_entry *entry, char *buf);
+static ssize_t phys_addr_show(struct efi_runtime_map_entry *entry, char *buf);
+static ssize_t virt_addr_show(struct efi_runtime_map_entry *entry, char *buf);
+static ssize_t num_pages_show(struct efi_runtime_map_entry *entry, char *buf);
+static ssize_t attribute_show(struct efi_runtime_map_entry *entry, char *buf);
+
+struct map_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct efi_runtime_map_entry *entry, char *buf);
+};
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
+static inline struct efi_runtime_map_entry *
+to_map_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct efi_runtime_map_entry, kobj);
+}
+
+static struct kobj_type __refdata map_ktype = {
+	.sysfs_ops	= &map_attr_ops,
+	.default_attrs	= def_attrs,
+};
+
+/*
+ * Add map entry on sysfs
+ */
+static int add_sysfs_fw_map_entry(struct efi_runtime_map_entry *entry)
+{
+	static int map_entries_nr;
+	static struct kset *map_kset;
+
+	if (!map_kset) {
+		map_kset = kset_create_and_add("efi-runtime-map", NULL,
+				efi_kobj);
+		if (!map_kset)
+			return -ENOMEM;
+	}
+
+	kobject_init(&entry->kobj, &map_ktype);
+	entry->kobj.kset = map_kset;
+	if (kobject_add(&entry->kobj, NULL, "%d", map_entries_nr++))
+		kobject_put(&entry->kobj);
+
+	return 0;
+}
+
+static ssize_t type_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%x\n", entry->md.type);
+}
+
+static ssize_t phys_addr_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->md.phys_addr);
+}
+
+static ssize_t virt_addr_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->md.virt_addr);
+}
+
+static ssize_t num_pages_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->md.num_pages);
+}
+
+static ssize_t attribute_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->md.attribute);
+}
+
+static inline struct map_attribute *to_map_attr(struct attribute *attr)
+{
+	return container_of(attr, struct map_attribute, attr);
+}
+
+static ssize_t map_attr_show(struct kobject *kobj,
+				struct attribute *attr, char *buf)
+{
+	struct efi_runtime_map_entry *entry = to_map_entry(kobj);
+	struct map_attribute *map_attr = to_map_attr(attr);
+
+	return map_attr->show(entry, buf);
+}
+
+static int __init efi_runtime_map_init(void)
+{
+	int i;
+	struct efi_runtime_map_entry *entry;
+	efi_memory_desc_t *md = efi_runtime_map;
+
+	if (!efi_runtime_map) {
+		pr_warn("no efi_runtime_map found\n");
+		return -EINVAL;
+	}
+
+	map_entries = kzalloc(nr_efi_runtime_map *
+		sizeof(struct efi_runtime_map_entry), GFP_KERNEL);
+	if (!map_entries)
+		return -ENOMEM;
+	entry = map_entries;
+
+	for (i = 0; i < nr_efi_runtime_map; i++) {
+		entry->md = *md;
+		add_sysfs_fw_map_entry(entry);
+		entry++;
+		md++;
+	}
+
+	return 0;
+}
+late_initcall(efi_runtime_map_init);
--- linux-2.6.orig/drivers/firmware/efi/efi.c
+++ linux-2.6/drivers/firmware/efi/efi.c
@@ -38,7 +38,8 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
-static struct kobject *efi_kobj;
+struct kobject *efi_kobj;
+EXPORT_SYMBOL_GPL(efi_kobj);
 static struct kobject *efivars_kobj;
 
 /*
--- linux-2.6.orig/arch/x86/include/asm/efi.h
+++ linux-2.6/arch/x86/include/asm/efi.h
@@ -133,6 +133,9 @@ extern void efi_sync_low_kernel_mappings
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
 
+extern efi_memory_desc_t *efi_runtime_map;
+extern int nr_efi_runtime_map;
+
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
--- /dev/null
+++ linux-2.6/Documentation/ABI/testing/sysfs-efi-runtime-map
@@ -0,0 +1,45 @@
+What:		/sys/firmware/efi/efi-runtime-map/
+Date:		Oct 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		Switching efi runtime services to virtual mode requires
+		that all efi memory ranges which has the runtime attribute
+		bit set to be mapped to virtual addresses.
+
+		In kexec kernel kernel can not entering virtual mode again
+		because there's a limitation that SetVirtualAddressMap can
+		only be called once for entering virtual mode. But kexec
+		kernel still need maintain same physical address to virtual
+		address mapping as the 1st kernel. The mappings are exported
+		to sysfs so userspace tools can reassemble them and pass them
+		into kexec kernel.
+
+		/sys/firmware/efi/efi-runtim-map/ is what kernel export for
+		this purpose. The structure is as follows:
+
+		subdirectories are named with the number of the memory ranges:
+
+			/sys/firmware/efi-runtime-map/0
+			/sys/firmware/efi-runtime-map/1
+			/sys/firmware/efi-runtime-map/2
+			/sys/firmware/efi-runtime-map/3
+			...
+
+		Each subdirectory contains five files:
+
+		attribute : The attribute of the memory range.
+		num_pages : The size of the memory range in page number.
+		phys_addr : The start physical address of the memory range.
+		type      : The type of the memory range.
+		virt_addr : The start virtual address of the memory range.
+
+		Above values are all hexadecimal number with the '0x' prefix.
+
+		So, for example:
+
+			/sys/firmware/efi-runtime-map/0/attribute
+			/sys/firmware/efi-runtime-map/0/num_pages
+			/sys/firmware/efi-runtime-map/0/phys_addr
+			/sys/firmware/efi-runtime-map/0/type
+			/sys/firmware/efi-runtime-map/0/virt_addr
+                        ...
--- linux-2.6.orig/include/linux/efi.h
+++ linux-2.6/include/linux/efi.h
@@ -872,4 +872,10 @@ int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+extern efi_memory_desc_t *efi_runtime_map;
+extern int nr_efi_runtime_map;
+extern struct kobject *efi_kobj;
+#endif
+
 #endif /* _LINUX_EFI_H */

