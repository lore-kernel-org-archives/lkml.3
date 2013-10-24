Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3JXJHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:07:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53243 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3JXJHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:07:52 -0400
From: Tero Kristo <t-kristo@ti.com>
To: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] regmap: debugfs: Fix a boot time crash with early regmap init
Date: Thu, 24 Oct 2013 12:07:48 +0300
Message-ID: <1382605668-31395-1-git-send-email-t-kristo@ti.com>
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
 drivers/base/regmap/regmap-debugfs.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index de11eca..e2d8f03 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -15,10 +15,18 @@
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
+static LIST_HEAD(regmap_debugfs_early);
 
 /* Calculate the length of a fixed format  */
 static size_t regmap_calc_reg_len(int max_val, char *buf, size_t buf_size)
@@ -465,6 +473,18 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
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
+		list_add(&node->link, &regmap_debugfs_early);
+		return;
+	}
+
 	INIT_LIST_HEAD(&map->debugfs_off_cache);
 	mutex_init(&map->cache_lock);
 
@@ -528,9 +548,17 @@ void regmap_debugfs_exit(struct regmap *map)
 
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
+	list_for_each_entry_safe(node, tmp, &regmap_debugfs_early, link) {
+		regmap_debugfs_init(node->map, node->name);
+		list_del(&node->link);
+		kfree(node);
+	}
 }
-- 
1.7.9.5

