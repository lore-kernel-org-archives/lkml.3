Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaJWCMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:12:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:24403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090AbaJWCMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,773,1406617200"; 
   d="scan'208";a="609713928"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/6] ACPI/OSL: Rename system memory functions.
Date: Thu, 23 Oct 2014 10:12:10 +0800
Message-Id: <6e1b8d2d369d84a27d4b15f6edde8810118be33f.1414029477.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414029477.git.lv.zheng@intel.com>
References: <cover.1414029477.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up system memory functions to make it easier to
understand the meaning of such functions.
No functional cleanup.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Fei Yang <fei.yang@intel.com>
---
 drivers/acpi/mem.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/mem.c b/drivers/acpi/mem.c
index 722241e..defd317 100644
--- a/drivers/acpi/mem.c
+++ b/drivers/acpi/mem.c
@@ -33,15 +33,23 @@ struct acpi_ioremap {
 static LIST_HEAD(acpi_ioremaps);
 static DEFINE_MUTEX(acpi_ioremap_lock);
 
-static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
+/*
+ * The following functions must be called with 'acpi_ioremap_lock' or RCU
+ * read lock held.
+ */
+static inline void acpi_map_get(struct acpi_ioremap *map)
+{
+	map->refcount++;
+}
+
+static inline void acpi_map_put(struct acpi_ioremap *map)
 {
 	if (!--map->refcount)
 		list_del_rcu(&map->list);
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
 static struct acpi_ioremap *
-acpi_map_lookup(acpi_physical_address phys, acpi_size size)
+acpi_map_lookup_phys(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
@@ -53,7 +61,6 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
 	return NULL;
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
 static struct acpi_ioremap *
 acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 {
@@ -67,13 +74,12 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 	return NULL;
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
 static void __iomem *
 acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
 {
 	struct acpi_ioremap *map;
 
-	map = acpi_map_lookup(phys, size);
+	map = acpi_map_lookup_phys(phys, size);
 	if (map)
 		return map->virt + (phys - map->phys);
 
@@ -111,7 +117,7 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
 		iounmap(vaddr);
 }
 
-static void acpi_os_map_cleanup(struct acpi_ioremap *map)
+static void acpi_map_cleanup(struct acpi_ioremap *map)
 {
 	if (!map->refcount) {
 		synchronize_rcu();
@@ -126,10 +132,10 @@ void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
 	void __iomem *virt = NULL;
 
 	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup(phys, size);
+	map = acpi_map_lookup_phys(phys, size);
 	if (map) {
 		virt = map->virt + (phys - map->phys);
-		map->refcount++;
+		acpi_map_get(map);
 	}
 	mutex_unlock(&acpi_ioremap_lock);
 
@@ -155,9 +161,9 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 
 	mutex_lock(&acpi_ioremap_lock);
 	/* Check if there's a suitable mapping already. */
-	map = acpi_map_lookup(phys, size);
+	map = acpi_map_lookup_phys(phys, size);
 	if (map) {
-		map->refcount++;
+		acpi_map_get(map);
 		goto out;
 	}
 
@@ -204,10 +210,10 @@ void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	acpi_map_put(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	acpi_os_map_cleanup(map);
+	acpi_map_cleanup(map);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
 
@@ -265,15 +271,15 @@ void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 		return;
 
 	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup(addr, gas->bit_width / 8);
+	map = acpi_map_lookup_phys(addr, gas->bit_width / 8);
 	if (!map) {
 		mutex_unlock(&acpi_ioremap_lock);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	acpi_map_put(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	acpi_os_map_cleanup(map);
+	acpi_map_cleanup(map);
 }
 EXPORT_SYMBOL(acpi_os_unmap_generic_address);
 
-- 
1.7.10

