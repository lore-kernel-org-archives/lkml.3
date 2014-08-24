Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaHXNce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 09:32:34 -0400
Received: from smtp-out-152.synserver.de ([212.40.185.152]:1045 "EHLO
	smtp-out-151.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710AbaHXNcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 09:32:33 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17816
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: Fix regcache debugfs initialization
Date: Sun, 24 Aug 2014 15:32:27 +0200
Message-Id: <1408887148-7627-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6cfec04bcc05 ("regmap: Separate regmap dev initialization") moved the
regmap debugfs initialization after regcache initialization. This means
that the regmap debugfs directory is not created yet when the cache
initialization runs and so any debugfs files registered by the regcache are
created in the debugfs root directory rather than the debugfs directory of
the regmap instance. Fix this by adding a separate callback for the
regcache debugfs initialization which will be called after the parent
debugfs entry has been created.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/internal.h        | 3 +++
 drivers/base/regmap/regcache-rbtree.c | 9 +++------
 drivers/base/regmap/regmap-debugfs.c  | 3 +++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 7d13269..bfc90b8 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -146,6 +146,9 @@ struct regcache_ops {
 	enum regcache_type type;
 	int (*init)(struct regmap *map);
 	int (*exit)(struct regmap *map);
+#ifdef CONFIG_DEBUG_FS
+	void (*debugfs_init)(struct regmap *map);
+#endif
 	int (*read)(struct regmap *map, unsigned int reg, unsigned int *value);
 	int (*write)(struct regmap *map, unsigned int reg, unsigned int value);
 	int (*sync)(struct regmap *map, unsigned int min, unsigned int max);
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 6a7e4fa..f3e8fe0 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -194,10 +194,6 @@ static void rbtree_debugfs_init(struct regmap *map)
 {
 	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);
 }
-#else
-static void rbtree_debugfs_init(struct regmap *map)
-{
-}
 #endif
 
 static int regcache_rbtree_init(struct regmap *map)
@@ -222,8 +218,6 @@ static int regcache_rbtree_init(struct regmap *map)
 			goto err;
 	}
 
-	rbtree_debugfs_init(map);
-
 	return 0;
 
 err:
@@ -532,6 +526,9 @@ struct regcache_ops regcache_rbtree_ops = {
 	.name = "rbtree",
 	.init = regcache_rbtree_init,
 	.exit = regcache_rbtree_exit,
+#ifdef CONFIG_DEBUG_FS
+	.debugfs_init = rbtree_debugfs_init,
+#endif
 	.read = regcache_rbtree_read,
 	.write = regcache_rbtree_write,
 	.sync = regcache_rbtree_sync,
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 45d812c..65ea7b2 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -538,6 +538,9 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 
 		next = rb_next(&range_node->node);
 	}
+
+	if (map->cache_ops && map->cache_ops->debugfs_init)
+		map->cache_ops->debugfs_init(map);
 }
 
 void regmap_debugfs_exit(struct regmap *map)
-- 
1.8.0

