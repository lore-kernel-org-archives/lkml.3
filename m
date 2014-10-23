Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbaJWCMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:12:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:47357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbaJWCMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="404553183"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 6/6] ACPI/OSL: Fix performance issue in system memory lockings.
Date: Thu, 23 Oct 2014 10:12:35 +0800
Message-Id: <15370cda5a20981203e319acbf6663126e9e1d25.1414029477.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414029477.git.lv.zheng@intel.com>
References: <cover.1414029477.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reported that the synchronize_rcu() used in the hot path is not
performance friendly:
 <6>[    3.998532] acpi_ut_update_object_reference: obj:ffff88003c305f78 type:10
 <6>[    4.006137] acpi_ut_update_ref_count:locked count:1 action:1 flags:286
 <6>[    4.013450] acpi_ut_delete_internal_obj: obj:ffff88003c305f78 flag:2
 <6>[    4.020569] acpi_ut_delete_internal_obj:second_desc handler_desc:ffff88003c0784c8 flags:1
 <6>[    4.029729] acpi_ut_delete_internal_obj: going to setup @ ffffffff81489299
 <6>[    4.037431] acpi_ev_system_memory_region_setup: addr:ffffc900000b0070, length:16
*<6>[    4.045716] acpi_os_unmap_memory: locked
*<6>[    4.050111] acpi_os_unmap_memory: found map
*<6>[    4.054798] acpi_os_unmap_memory: map dropped
*<6>[    4.059678] acpi_os_unmap_memory: unlocked
*<6>[  122.761255] acpi_os_map_cleanup: after synchronize_rcu
*<6>[  122.767027] acpi_os_unmap_memory: end
*<6>[  122.771134] After unmap
*<6>[  122.773877] After ACPI_FREE
 <6>[  122.777010] acpi_ut_delete_internal_obj: after setup
 <6>[  122.782576] acpi_ut_update_object_reference: obj:ffff88003c0784c8 type:24
 <6>[  122.790183] acpi_ut_update_ref_count:locked count:1c action:1 flags:282
 <6>[  122.797595] acpi_ut_delete_internal_obj: handler_desc removed
 <6>[  122.804034] acpi_ut_delete_internal_obj: second_desc deleted
 <6>[  122.810376] acpi_ut_delete_internal_obj: object deleted
 <6>[  122.816231] acpi_ns_detach_object: reference removed
Note: The "*" marked acpi_os_unmap_memory() instrumentation messages are
      added by the reporter.

The patch converts RCU synchronization into the deferred executed work
queue item to eliminate the consumed time from the hot path. By doing so,
acpi_os_read_memory()/acpi_os_write_memory() need to hold the reference
count and the RCU locks will then be unnecessary. The original
acpi_ioremap_lock (renamed to acpi_map_lock) must be converted into
spinlock to be used for both the IRQ and the task contexts.
But it is still needed that the map operations are serialized because the
spinlock cannot be held around ioremap(), so that the parallel map
operations can wait for each other instead of inserting duplicated entries
into the acpi_ioremaps. This is achieved by introducing another
acpi_serial_map_mutex. Note that the unmap serialization is not required
due to the reference count protected list removal, thus
acpi_os_unmap_iomem() and acpi_map_relinquish() are not protected by the
acpi_serial_map_mutex.
The test feedback from the reporter:
 "The google reboot stability test passed with your 6 patches. Thanks for
  the help."

Known issues:
1. It is better to use a seperate work queue other than the ACPICA
   dedicated GPE work queue to perform mapping relinquishment. Until a real
   case can be seen on bugzilla.kernel.org complaining this, no further
   improvements are done in this patch.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Fei Yang <fei.yang@intel.com>
---
 drivers/acpi/mem.c |   87 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/mem.c b/drivers/acpi/mem.c
index c7c35f7..b631007 100644
--- a/drivers/acpi/mem.c
+++ b/drivers/acpi/mem.c
@@ -30,13 +30,13 @@ struct acpi_ioremap {
 	unsigned long refcount;
 };
 
+/* ioremap() serialization, no need to serialize iounmap() operations */
+static DEFINE_MUTEX(acpi_serial_map_mutex);
+
 static LIST_HEAD(acpi_ioremaps);
-static DEFINE_MUTEX(acpi_ioremap_lock);
+static DEFINE_SPINLOCK(acpi_map_lock);
 
-/*
- * The following functions must be called with 'acpi_ioremap_lock' or RCU
- * read lock held.
- */
+/* The following functions must be called with 'acpi_map_lock' held. */
 static inline void acpi_map_get(struct acpi_ioremap *map)
 {
 	map->refcount++;
@@ -45,7 +45,7 @@ static inline void acpi_map_get(struct acpi_ioremap *map)
 static inline void acpi_map_put(struct acpi_ioremap *map)
 {
 	if (!--map->refcount)
-		list_del_rcu(&map->list);
+		list_del(&map->list);
 }
 
 static struct acpi_ioremap *
@@ -53,7 +53,7 @@ acpi_map_lookup_phys(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+	list_for_each_entry(map, &acpi_ioremaps, list)
 		if (map->phys <= phys &&
 		    phys + size <= map->phys + map->size)
 			return map;
@@ -66,7 +66,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+	list_for_each_entry(map, &acpi_ioremaps, list)
 		if (map->virt <= virt &&
 		    virt + size <= map->virt + map->size)
 			return map;
@@ -80,6 +80,7 @@ acpi_map2virt(struct acpi_ioremap *map, acpi_physical_address phys)
 	return map ? map->virt + (phys - map->phys) : NULL;
 }
 
+/* The following functions must be called without 'acpi_map_lock' held. */
 #ifndef CONFIG_IA64
 #define should_use_kmap(pfn)   page_is_ram(pfn)
 #else
@@ -113,22 +114,33 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
 
 static void acpi_map_cleanup(struct acpi_ioremap *map)
 {
-	if (!map->refcount) {
-		synchronize_rcu();
+	if (map && !map->refcount) {
 		acpi_unmap(map->phys, map->virt);
 		kfree(map);
 	}
 }
 
+static void acpi_map_relinquish(void *ctx)
+{
+	struct acpi_ioremap *map = ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&acpi_map_lock, flags);
+	acpi_map_put(map);
+	spin_unlock_irqrestore(&acpi_map_lock, flags);
+	acpi_map_cleanup(map);
+}
+
 void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
 {
 	struct acpi_ioremap *map;
+	unsigned long flags;
 
-	mutex_lock(&acpi_ioremap_lock);
+	spin_lock_irqsave(&acpi_map_lock, flags);
 	map = acpi_map_lookup_phys(phys, size);
 	if (map)
 		acpi_map_get(map);
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_map_lock, flags);
 
 	return acpi_map2virt(map, phys);
 }
@@ -141,6 +153,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	void __iomem *virt;
 	acpi_physical_address pg_off;
 	acpi_size pg_sz;
+	unsigned long flags;
 
 	if (phys > ULONG_MAX) {
 		pr_err(PREFIX "Cannot map memory that high\n");
@@ -150,17 +163,20 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	if (!acpi_gbl_permanent_mmap)
 		return __acpi_map_table((unsigned long)phys, size);
 
-	mutex_lock(&acpi_ioremap_lock);
+	mutex_lock(&acpi_serial_map_mutex);
+
+	spin_lock_irqsave(&acpi_map_lock, flags);
 	/* Check if there's a suitable mapping already. */
 	map = acpi_map_lookup_phys(phys, size);
 	if (map) {
 		acpi_map_get(map);
 		goto out;
 	}
+	spin_unlock_irqrestore(&acpi_map_lock, flags);
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map)
-		goto out;
+		goto err_exit;
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
@@ -168,17 +184,21 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	if (!virt) {
 		kfree(map);
 		map = NULL;
-		goto out;
+		goto err_exit;
 	}
 
+	spin_lock_irqsave(&acpi_map_lock, flags);
 	INIT_LIST_HEAD(&map->list);
 	map->virt = virt;
 	map->phys = pg_off;
 	map->size = pg_sz;
 	map->refcount = 1;
-	list_add_tail_rcu(&map->list, &acpi_ioremaps);
+	list_add_tail(&map->list, &acpi_ioremaps);
 out:
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_map_lock, flags);
+
+err_exit:
+	mutex_unlock(&acpi_serial_map_mutex);
 	return acpi_map2virt(map, phys);
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
@@ -186,19 +206,20 @@ EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
+	unsigned long flags;
 
 	if (!acpi_gbl_permanent_mmap) {
 		__acpi_unmap_table(virt, size);
 		return;
 	}
 
-	mutex_lock(&acpi_ioremap_lock);
+	spin_lock_irqsave(&acpi_map_lock, flags);
 	map = acpi_map_lookup_virt(virt, size);
 	if (map)
 		acpi_map_put(map);
 	else
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_map_lock, flags);
 
 	acpi_map_cleanup(map);
 }
@@ -298,13 +319,16 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	bool unmap = false;
 	u64 dummy;
 	struct acpi_ioremap *map;
+	unsigned long flags;
 
-	rcu_read_lock();
+	spin_lock_irqsave(&acpi_map_lock, flags);
 	map = acpi_map_lookup_phys(phys_addr, size);
-	if (map)
+	if (map) {
+		acpi_map_get(map);
+		spin_unlock_irqrestore(&acpi_map_lock, flags);
 		virt_addr = acpi_map2virt(map, phys_addr);
-	else {
-		rcu_read_unlock();
+	} else {
+		spin_unlock_irqrestore(&acpi_map_lock, flags);
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
@@ -334,7 +358,8 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	if (unmap)
 		iounmap(virt_addr);
 	else
-		rcu_read_unlock();
+		acpi_os_execute(OSL_GPE_HANDLER,
+				acpi_map_relinquish, map);
 
 	return AE_OK;
 }
@@ -346,13 +371,16 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	unsigned int size = width / 8;
 	bool unmap = false;
 	struct acpi_ioremap *map;
+	unsigned long flags;
 
-	rcu_read_lock();
+	spin_lock_irqsave(&acpi_map_lock, flags);
 	map = acpi_map_lookup_phys(phys_addr, size);
-	if (map)
+	if (map) {
+		acpi_map_get(map);
+		spin_unlock_irqrestore(&acpi_map_lock, flags);
 		virt_addr = acpi_map2virt(map, phys_addr);
-	else {
-		rcu_read_unlock();
+	} else {
+		spin_unlock_irqrestore(&acpi_map_lock, flags);
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
@@ -379,7 +407,8 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	if (unmap)
 		iounmap(virt_addr);
 	else
-		rcu_read_unlock();
+		acpi_os_execute(OSL_GPE_HANDLER,
+				acpi_map_relinquish, map);
 
 	return AE_OK;
 }
-- 
1.7.10

