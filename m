Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3JXMDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:03:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3JXMDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:03:45 -0400
From: Tero Kristo <t-kristo@ti.com>
To: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] regmap: debugfs: Fix a boot time crash with early regmap init
Date: Thu, 24 Oct 2013 15:03:41 +0300
Message-ID: <1382616221-8633-1-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If called early enough, regmap_debugfs_init causes a crash, if the
fs subsystem does not have its mount cache created yet. Even if this
would work, the root node for the regmap debugfs is still missing,
thus postpone the regmap_debugfs_init in this case until the root
node is created. A special regmap_debugfs_early list is created for
this purpose which is parsed later in the boot.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/base/regmap/regmap-debugfs.c |   57 +++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index de11eca..c5471cd 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -15,10 +15,19 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/device.h>
+#include <linux/list.h>
 
 #include "internal.h"
 
+struct regmap_debugfs_node {
+	struct regmap *map;
+	const char *name;
+	struct list_head link;
+};
+
 static struct dentry *regmap_debugfs_root;
+static LIST_HEAD(regmap_debugfs_early_list);
+static DEFINE_MUTEX(regmap_debugfs_early_lock);
 
 /* Calculate the length of a fixed format  */
 static size_t regmap_calc_reg_len(int max_val, char *buf, size_t buf_size)
@@ -465,6 +474,20 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	struct rb_node *next;
 	struct regmap_range_node *range_node;
 
+	/* If we don't have the debugfs root yet, postpone init */
+	if (!regmap_debugfs_root) {
+		struct regmap_debugfs_node *node;
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			return;
+		node->map = map;
+		node->name = name;
+		mutex_lock(&regmap_debugfs_early_lock);
+		list_add(&node->link, &regmap_debugfs_early_list);
+		mutex_unlock(&regmap_debugfs_early_lock);
+		return;
+	}
+
 	INIT_LIST_HEAD(&map->debugfs_off_cache);
 	mutex_init(&map->cache_lock);
 
@@ -519,18 +542,42 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 
 void regmap_debugfs_exit(struct regmap *map)
 {
-	debugfs_remove_recursive(map->debugfs);
-	mutex_lock(&map->cache_lock);
-	regmap_debugfs_free_dump_cache(map);
-	mutex_unlock(&map->cache_lock);
-	kfree(map->debugfs_name);
+	if (map->debugfs) {
+		debugfs_remove_recursive(map->debugfs);
+		mutex_lock(&map->cache_lock);
+		regmap_debugfs_free_dump_cache(map);
+		mutex_unlock(&map->cache_lock);
+		kfree(map->debugfs_name);
+	} else {
+		struct regmap_debugfs_node *node, *tmp;
+
+		mutex_lock(&regmap_debugfs_early_lock);
+		list_for_each_entry_safe(node, tmp, &regmap_debugfs_early_list,
+					 link) {
+			if (node->map == map) {
+				list_del(&node->link);
+				kfree(node);
+			}
+		}
+		mutex_unlock(&regmap_debugfs_early_lock);
+	}
 }
 
 void regmap_debugfs_initcall(void)
 {
+	struct regmap_debugfs_node *node, *tmp;
+
 	regmap_debugfs_root = debugfs_create_dir("regmap", NULL);
 	if (!regmap_debugfs_root) {
 		pr_warn("regmap: Failed to create debugfs root\n");
 		return;
 	}
+
+	mutex_lock(&regmap_debugfs_early_lock);
+	list_for_each_entry_safe(node, tmp, &regmap_debugfs_early_list, link) {
+		regmap_debugfs_init(node->map, node->name);
+		list_del(&node->link);
+		kfree(node);
+	}
+	mutex_unlock(&regmap_debugfs_early_lock);
 }
-- 
1.7.9.5

