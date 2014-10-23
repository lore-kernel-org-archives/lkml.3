Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaJWCM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:12:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:14062 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbaJWCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,773,1406617200"; 
   d="scan'208";a="623683756"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/6] ACPI/OSL: Split memory operation region implementations to a seperate file.
Date: Thu, 23 Oct 2014 10:12:04 +0800
Message-Id: <67604710cb7de13bb98a3fcb593179a6d44d390e.1414029477.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414029477.git.lv.zheng@intel.com>
References: <cover.1414029477.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves SystemMemory operation region implementations to a
seperate file before doing cleanups. No functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Fei Yang <fei.yang@intel.com>
---
 drivers/acpi/Makefile |    2 +-
 drivers/acpi/mem.c    |  395 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/osl.c    |  381 -----------------------------------------------
 3 files changed, 396 insertions(+), 382 deletions(-)
 create mode 100644 drivers/acpi/mem.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 505d4d7..802b887 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -18,7 +18,7 @@ obj-y				+= acpi.o \
 					acpica/
 
 # All the builtin files are in the "acpi." module_param namespace.
-acpi-y				+= osl.o utils.o reboot.o
+acpi-y				+= mem.o osl.o utils.o reboot.o
 acpi-y				+= nvs.o
 
 # Power management related files
diff --git a/drivers/acpi/mem.c b/drivers/acpi/mem.c
new file mode 100644
index 0000000..722241e
--- /dev/null
+++ b/drivers/acpi/mem.c
@@ -0,0 +1,395 @@
+/*
+ * ACPI system memory implementation
+ *
+ * Copyright (C) 2014, Intel Corporation
+ *   Author: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/io.h>
+#include <linux/acpi.h>
+
+#include "internal.h"
+
+
+/*
+ * This list of permanent mappings is for memory that may be accessed from
+ * interrupt context, where we can't do the ioremap().
+ */
+struct acpi_ioremap {
+	struct list_head list;
+	void __iomem *virt;
+	acpi_physical_address phys;
+	acpi_size size;
+	unsigned long refcount;
+};
+
+static LIST_HEAD(acpi_ioremaps);
+static DEFINE_MUTEX(acpi_ioremap_lock);
+
+static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
+{
+	if (!--map->refcount)
+		list_del_rcu(&map->list);
+}
+
+/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+static struct acpi_ioremap *
+acpi_map_lookup(acpi_physical_address phys, acpi_size size)
+{
+	struct acpi_ioremap *map;
+
+	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+		if (map->phys <= phys &&
+		    phys + size <= map->phys + map->size)
+			return map;
+
+	return NULL;
+}
+
+/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+static struct acpi_ioremap *
+acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
+{
+	struct acpi_ioremap *map;
+
+	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+		if (map->virt <= virt &&
+		    virt + size <= map->virt + map->size)
+			return map;
+
+	return NULL;
+}
+
+/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+static void __iomem *
+acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
+{
+	struct acpi_ioremap *map;
+
+	map = acpi_map_lookup(phys, size);
+	if (map)
+		return map->virt + (phys - map->phys);
+
+	return NULL;
+}
+
+#ifndef CONFIG_IA64
+#define should_use_kmap(pfn)   page_is_ram(pfn)
+#else
+/* ioremap will take care of cache attributes */
+#define should_use_kmap(pfn)   0
+#endif
+
+static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
+{
+	unsigned long pfn;
+
+	pfn = pg_off >> PAGE_SHIFT;
+	if (should_use_kmap(pfn)) {
+		if (pg_sz > PAGE_SIZE)
+			return NULL;
+		return (void __iomem __force *)kmap(pfn_to_page(pfn));
+	}
+	return acpi_os_ioremap(pg_off, pg_sz);
+}
+
+static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
+{
+	unsigned long pfn;
+
+	pfn = pg_off >> PAGE_SHIFT;
+	if (should_use_kmap(pfn))
+		kunmap(pfn_to_page(pfn));
+	else
+		iounmap(vaddr);
+}
+
+static void acpi_os_map_cleanup(struct acpi_ioremap *map)
+{
+	if (!map->refcount) {
+		synchronize_rcu();
+		acpi_unmap(map->phys, map->virt);
+		kfree(map);
+	}
+}
+
+void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
+{
+	struct acpi_ioremap *map;
+	void __iomem *virt = NULL;
+
+	mutex_lock(&acpi_ioremap_lock);
+	map = acpi_map_lookup(phys, size);
+	if (map) {
+		virt = map->virt + (phys - map->phys);
+		map->refcount++;
+	}
+	mutex_unlock(&acpi_ioremap_lock);
+
+	return virt;
+}
+EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
+
+void __iomem *__init_refok
+acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
+{
+	struct acpi_ioremap *map;
+	void __iomem *virt;
+	acpi_physical_address pg_off;
+	acpi_size pg_sz;
+
+	if (phys > ULONG_MAX) {
+		pr_err(PREFIX "Cannot map memory that high\n");
+		return NULL;
+	}
+
+	if (!acpi_gbl_permanent_mmap)
+		return __acpi_map_table((unsigned long)phys, size);
+
+	mutex_lock(&acpi_ioremap_lock);
+	/* Check if there's a suitable mapping already. */
+	map = acpi_map_lookup(phys, size);
+	if (map) {
+		map->refcount++;
+		goto out;
+	}
+
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	if (!map) {
+		mutex_unlock(&acpi_ioremap_lock);
+		return NULL;
+	}
+
+	pg_off = round_down(phys, PAGE_SIZE);
+	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
+	virt = acpi_map(pg_off, pg_sz);
+	if (!virt) {
+		mutex_unlock(&acpi_ioremap_lock);
+		kfree(map);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&map->list);
+	map->virt = virt;
+	map->phys = pg_off;
+	map->size = pg_sz;
+	map->refcount = 1;
+	list_add_tail_rcu(&map->list, &acpi_ioremaps);
+out:
+	mutex_unlock(&acpi_ioremap_lock);
+	return map->virt + (phys - map->phys);
+}
+EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
+
+void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
+{
+	struct acpi_ioremap *map;
+
+	if (!acpi_gbl_permanent_mmap) {
+		__acpi_unmap_table(virt, size);
+		return;
+	}
+
+	mutex_lock(&acpi_ioremap_lock);
+	map = acpi_map_lookup_virt(virt, size);
+	if (!map) {
+		mutex_unlock(&acpi_ioremap_lock);
+		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
+		return;
+	}
+	acpi_os_drop_map_ref(map);
+	mutex_unlock(&acpi_ioremap_lock);
+
+	acpi_os_map_cleanup(map);
+}
+EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
+
+void *__init_refok
+acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
+{
+	return (void *)acpi_os_map_iomem(phys, size);
+}
+EXPORT_SYMBOL_GPL(acpi_os_map_memory);
+
+void __ref acpi_os_unmap_memory(void *virt, acpi_size size)
+{
+	return acpi_os_unmap_iomem((void __iomem *)virt, size);
+}
+EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
+
+void __init early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
+{
+	if (!acpi_gbl_permanent_mmap)
+		__acpi_unmap_table(virt, size);
+}
+
+int acpi_os_map_generic_address(struct acpi_generic_address *gas)
+{
+	u64 addr;
+	void __iomem *virt;
+
+	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		return 0;
+
+	/* Handle possible alignment issues */
+	memcpy(&addr, &gas->address, sizeof(addr));
+	if (!addr || !gas->bit_width)
+		return -EINVAL;
+
+	virt = acpi_os_map_iomem(addr, gas->bit_width / 8);
+	if (!virt)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(acpi_os_map_generic_address);
+
+void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
+{
+	u64 addr;
+	struct acpi_ioremap *map;
+
+	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		return;
+
+	/* Handle possible alignment issues */
+	memcpy(&addr, &gas->address, sizeof(addr));
+	if (!addr || !gas->bit_width)
+		return;
+
+	mutex_lock(&acpi_ioremap_lock);
+	map = acpi_map_lookup(addr, gas->bit_width / 8);
+	if (!map) {
+		mutex_unlock(&acpi_ioremap_lock);
+		return;
+	}
+	acpi_os_drop_map_ref(map);
+	mutex_unlock(&acpi_ioremap_lock);
+
+	acpi_os_map_cleanup(map);
+}
+EXPORT_SYMBOL(acpi_os_unmap_generic_address);
+
+#ifdef readq
+static inline u64 read64(const volatile void __iomem *addr)
+{
+	return readq(addr);
+}
+#else
+static inline u64 read64(const volatile void __iomem *addr)
+{
+	u64 l, h;
+
+	l = readl(addr);
+	h = readl(addr+4);
+	return l | (h << 32);
+}
+#endif
+
+#ifdef writeq
+static inline void write64(u64 val, volatile void __iomem *addr)
+{
+	writeq(val, addr);
+}
+#else
+static inline void write64(u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val>>32, addr+4);
+}
+#endif
+
+acpi_status
+acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
+{
+	void __iomem *virt_addr;
+	unsigned int size = width / 8;
+	bool unmap = false;
+	u64 dummy;
+
+	rcu_read_lock();
+	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
+	if (!virt_addr) {
+		rcu_read_unlock();
+		virt_addr = acpi_os_ioremap(phys_addr, size);
+		if (!virt_addr)
+			return AE_BAD_ADDRESS;
+		unmap = true;
+	}
+
+	if (!value)
+		value = &dummy;
+
+	switch (width) {
+	case 8:
+		*(u8 *) value = readb(virt_addr);
+		break;
+	case 16:
+		*(u16 *) value = readw(virt_addr);
+		break;
+	case 32:
+		*(u32 *) value = readl(virt_addr);
+		break;
+	case 64:
+		*(u64 *) value = read64(virt_addr);
+		break;
+	default:
+		BUG();
+	}
+
+	if (unmap)
+		iounmap(virt_addr);
+	else
+		rcu_read_unlock();
+
+	return AE_OK;
+}
+
+acpi_status
+acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
+{
+	void __iomem *virt_addr;
+	unsigned int size = width / 8;
+	bool unmap = false;
+
+	rcu_read_lock();
+	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
+	if (!virt_addr) {
+		rcu_read_unlock();
+		virt_addr = acpi_os_ioremap(phys_addr, size);
+		if (!virt_addr)
+			return AE_BAD_ADDRESS;
+		unmap = true;
+	}
+
+	switch (width) {
+	case 8:
+		writeb(value, virt_addr);
+		break;
+	case 16:
+		writew(value, virt_addr);
+		break;
+	case 32:
+		writel(value, virt_addr);
+		break;
+	case 64:
+		write64(value, virt_addr);
+		break;
+	default:
+		BUG();
+	}
+
+	if (unmap)
+		iounmap(virt_addr);
+	else
+		rcu_read_unlock();
+
+	return AE_OK;
+}
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9964f70..3533814 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -30,8 +30,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/kmod.h>
@@ -45,9 +43,6 @@
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
 #include "internal.h"
 
 #define _COMPONENT		ACPI_OS_SERVICES
@@ -84,21 +79,6 @@ static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
 static struct workqueue_struct *kacpi_hotplug_wq;
 
-/*
- * This list of permanent mappings is for memory that may be accessed from
- * interrupt context, where we can't do the ioremap().
- */
-struct acpi_ioremap {
-	struct list_head list;
-	void __iomem *virt;
-	acpi_physical_address phys;
-	acpi_size size;
-	unsigned long refcount;
-};
-
-static LIST_HEAD(acpi_ioremaps);
-static DEFINE_MUTEX(acpi_ioremap_lock);
-
 static void __init acpi_osi_setup_late(void);
 
 /*
@@ -279,251 +259,6 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 	return 0;
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
-static struct acpi_ioremap *
-acpi_map_lookup(acpi_physical_address phys, acpi_size size)
-{
-	struct acpi_ioremap *map;
-
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
-		if (map->phys <= phys &&
-		    phys + size <= map->phys + map->size)
-			return map;
-
-	return NULL;
-}
-
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
-static void __iomem *
-acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
-{
-	struct acpi_ioremap *map;
-
-	map = acpi_map_lookup(phys, size);
-	if (map)
-		return map->virt + (phys - map->phys);
-
-	return NULL;
-}
-
-void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
-{
-	struct acpi_ioremap *map;
-	void __iomem *virt = NULL;
-
-	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup(phys, size);
-	if (map) {
-		virt = map->virt + (phys - map->phys);
-		map->refcount++;
-	}
-	mutex_unlock(&acpi_ioremap_lock);
-	return virt;
-}
-EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
-
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
-static struct acpi_ioremap *
-acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
-{
-	struct acpi_ioremap *map;
-
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
-		if (map->virt <= virt &&
-		    virt + size <= map->virt + map->size)
-			return map;
-
-	return NULL;
-}
-
-#ifndef CONFIG_IA64
-#define should_use_kmap(pfn)   page_is_ram(pfn)
-#else
-/* ioremap will take care of cache attributes */
-#define should_use_kmap(pfn)   0
-#endif
-
-static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
-{
-	unsigned long pfn;
-
-	pfn = pg_off >> PAGE_SHIFT;
-	if (should_use_kmap(pfn)) {
-		if (pg_sz > PAGE_SIZE)
-			return NULL;
-		return (void __iomem __force *)kmap(pfn_to_page(pfn));
-	} else
-		return acpi_os_ioremap(pg_off, pg_sz);
-}
-
-static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
-{
-	unsigned long pfn;
-
-	pfn = pg_off >> PAGE_SHIFT;
-	if (should_use_kmap(pfn))
-		kunmap(pfn_to_page(pfn));
-	else
-		iounmap(vaddr);
-}
-
-void __iomem *__init_refok
-acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
-{
-	struct acpi_ioremap *map;
-	void __iomem *virt;
-	acpi_physical_address pg_off;
-	acpi_size pg_sz;
-
-	if (phys > ULONG_MAX) {
-		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
-		return NULL;
-	}
-
-	if (!acpi_gbl_permanent_mmap)
-		return __acpi_map_table((unsigned long)phys, size);
-
-	mutex_lock(&acpi_ioremap_lock);
-	/* Check if there's a suitable mapping already. */
-	map = acpi_map_lookup(phys, size);
-	if (map) {
-		map->refcount++;
-		goto out;
-	}
-
-	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
-		return NULL;
-	}
-
-	pg_off = round_down(phys, PAGE_SIZE);
-	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = acpi_map(pg_off, pg_sz);
-	if (!virt) {
-		mutex_unlock(&acpi_ioremap_lock);
-		kfree(map);
-		return NULL;
-	}
-
-	INIT_LIST_HEAD(&map->list);
-	map->virt = virt;
-	map->phys = pg_off;
-	map->size = pg_sz;
-	map->refcount = 1;
-
-	list_add_tail_rcu(&map->list, &acpi_ioremaps);
-
-out:
-	mutex_unlock(&acpi_ioremap_lock);
-	return map->virt + (phys - map->phys);
-}
-EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
-
-void *__init_refok
-acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
-{
-	return (void *)acpi_os_map_iomem(phys, size);
-}
-EXPORT_SYMBOL_GPL(acpi_os_map_memory);
-
-static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
-{
-	if (!--map->refcount)
-		list_del_rcu(&map->list);
-}
-
-static void acpi_os_map_cleanup(struct acpi_ioremap *map)
-{
-	if (!map->refcount) {
-		synchronize_rcu();
-		acpi_unmap(map->phys, map->virt);
-		kfree(map);
-	}
-}
-
-void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
-{
-	struct acpi_ioremap *map;
-
-	if (!acpi_gbl_permanent_mmap) {
-		__acpi_unmap_table(virt, size);
-		return;
-	}
-
-	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup_virt(virt, size);
-	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
-		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
-		return;
-	}
-	acpi_os_drop_map_ref(map);
-	mutex_unlock(&acpi_ioremap_lock);
-
-	acpi_os_map_cleanup(map);
-}
-EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
-
-void __ref acpi_os_unmap_memory(void *virt, acpi_size size)
-{
-	return acpi_os_unmap_iomem((void __iomem *)virt, size);
-}
-EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
-
-void __init early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
-{
-	if (!acpi_gbl_permanent_mmap)
-		__acpi_unmap_table(virt, size);
-}
-
-int acpi_os_map_generic_address(struct acpi_generic_address *gas)
-{
-	u64 addr;
-	void __iomem *virt;
-
-	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		return 0;
-
-	/* Handle possible alignment issues */
-	memcpy(&addr, &gas->address, sizeof(addr));
-	if (!addr || !gas->bit_width)
-		return -EINVAL;
-
-	virt = acpi_os_map_iomem(addr, gas->bit_width / 8);
-	if (!virt)
-		return -EIO;
-
-	return 0;
-}
-EXPORT_SYMBOL(acpi_os_map_generic_address);
-
-void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
-{
-	u64 addr;
-	struct acpi_ioremap *map;
-
-	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		return;
-
-	/* Handle possible alignment issues */
-	memcpy(&addr, &gas->address, sizeof(addr));
-	if (!addr || !gas->bit_width)
-		return;
-
-	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup(addr, gas->bit_width / 8);
-	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
-		return;
-	}
-	acpi_os_drop_map_ref(map);
-	mutex_unlock(&acpi_ioremap_lock);
-
-	acpi_os_map_cleanup(map);
-}
-EXPORT_SYMBOL(acpi_os_unmap_generic_address);
-
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
 acpi_os_get_physical_address(void *virt, acpi_physical_address * phys)
@@ -929,122 +664,6 @@ acpi_status acpi_os_write_port(acpi_io_address port, u32 value, u32 width)
 
 EXPORT_SYMBOL(acpi_os_write_port);
 
-#ifdef readq
-static inline u64 read64(const volatile void __iomem *addr)
-{
-	return readq(addr);
-}
-#else
-static inline u64 read64(const volatile void __iomem *addr)
-{
-	u64 l, h;
-	l = readl(addr);
-	h = readl(addr+4);
-	return l | (h << 32);
-}
-#endif
-
-acpi_status
-acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
-{
-	void __iomem *virt_addr;
-	unsigned int size = width / 8;
-	bool unmap = false;
-	u64 dummy;
-
-	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	if (!virt_addr) {
-		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		if (!virt_addr)
-			return AE_BAD_ADDRESS;
-		unmap = true;
-	}
-
-	if (!value)
-		value = &dummy;
-
-	switch (width) {
-	case 8:
-		*(u8 *) value = readb(virt_addr);
-		break;
-	case 16:
-		*(u16 *) value = readw(virt_addr);
-		break;
-	case 32:
-		*(u32 *) value = readl(virt_addr);
-		break;
-	case 64:
-		*(u64 *) value = read64(virt_addr);
-		break;
-	default:
-		BUG();
-	}
-
-	if (unmap)
-		iounmap(virt_addr);
-	else
-		rcu_read_unlock();
-
-	return AE_OK;
-}
-
-#ifdef writeq
-static inline void write64(u64 val, volatile void __iomem *addr)
-{
-	writeq(val, addr);
-}
-#else
-static inline void write64(u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val>>32, addr+4);
-}
-#endif
-
-acpi_status
-acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
-{
-	void __iomem *virt_addr;
-	unsigned int size = width / 8;
-	bool unmap = false;
-
-	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	if (!virt_addr) {
-		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		if (!virt_addr)
-			return AE_BAD_ADDRESS;
-		unmap = true;
-	}
-
-	switch (width) {
-	case 8:
-		writeb(value, virt_addr);
-		break;
-	case 16:
-		writew(value, virt_addr);
-		break;
-	case 32:
-		writel(value, virt_addr);
-		break;
-	case 64:
-		write64(value, virt_addr);
-		break;
-	default:
-		BUG();
-	}
-
-	if (unmap)
-		iounmap(virt_addr);
-	else
-		rcu_read_unlock();
-
-	return AE_OK;
-}
-
 acpi_status
 acpi_os_read_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 			       u64 *value, u32 width)
-- 
1.7.10

