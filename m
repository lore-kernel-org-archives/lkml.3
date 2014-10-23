Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaJWCNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:13:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:13863 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaJWCM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:12:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,773,1406617200"; 
   d="scan'208";a="594240630"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 4/6] ACPI/OSL: Add acpi_map2virt() to merge duplicate code.
Date: Thu, 23 Oct 2014 10:12:22 +0800
Message-Id: <749b493bef2138bd34c1b79578abe4e6f47f0871.1414029477.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414029477.git.lv.zheng@intel.com>
References: <cover.1414029477.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds acpi_map2virt() so that some duplicated code can be merged.
No functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Fei Yang <fei.yang@intel.com>
---
 drivers/acpi/mem.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/mem.c b/drivers/acpi/mem.c
index ba74086..c472237 100644
--- a/drivers/acpi/mem.c
+++ b/drivers/acpi/mem.c
@@ -74,16 +74,10 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 	return NULL;
 }
 
-static void __iomem *
-acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
+static inline void __iomem *
+acpi_map2virt(struct acpi_ioremap *map, acpi_physical_address phys)
 {
-	struct acpi_ioremap *map;
-
-	map = acpi_map_lookup_phys(phys, size);
-	if (map)
-		return map->virt + (phys - map->phys);
-
-	return NULL;
+	return map ? map->virt + (phys - map->phys) : NULL;
 }
 
 #ifndef CONFIG_IA64
@@ -129,17 +123,14 @@ static void acpi_map_cleanup(struct acpi_ioremap *map)
 void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
 {
 	struct acpi_ioremap *map;
-	void __iomem *virt = NULL;
 
 	mutex_lock(&acpi_ioremap_lock);
 	map = acpi_map_lookup_phys(phys, size);
-	if (map) {
-		virt = map->virt + (phys - map->phys);
+	if (map)
 		acpi_map_get(map);
-	}
 	mutex_unlock(&acpi_ioremap_lock);
 
-	return virt;
+	return acpi_map2virt(map, phys);
 }
 EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
 
@@ -168,18 +159,16 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	}
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
-		return NULL;
-	}
+	if (!map)
+		goto out;
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
 	virt = acpi_map(pg_off, pg_sz);
 	if (!virt) {
-		mutex_unlock(&acpi_ioremap_lock);
 		kfree(map);
-		return NULL;
+		map = NULL;
+		goto out;
 	}
 
 	INIT_LIST_HEAD(&map->list);
@@ -190,7 +179,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	list_add_tail_rcu(&map->list, &acpi_ioremaps);
 out:
 	mutex_unlock(&acpi_ioremap_lock);
-	return map->virt + (phys - map->phys);
+	return acpi_map2virt(map, phys);
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
 
@@ -310,10 +299,13 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	unsigned int size = width / 8;
 	bool unmap = false;
 	u64 dummy;
+	struct acpi_ioremap *map;
 
 	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	if (!virt_addr) {
+	map = acpi_map_lookup_phys(phys_addr, size);
+	if (map)
+		virt_addr = acpi_map2virt(map, phys_addr);
+	else {
 		rcu_read_unlock();
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
@@ -355,10 +347,13 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	void __iomem *virt_addr;
 	unsigned int size = width / 8;
 	bool unmap = false;
+	struct acpi_ioremap *map;
 
 	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	if (!virt_addr) {
+	map = acpi_map_lookup_phys(phys_addr, size);
+	if (map)
+		virt_addr = acpi_map2virt(map, phys_addr);
+	else {
 		rcu_read_unlock();
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
-- 
1.7.10

