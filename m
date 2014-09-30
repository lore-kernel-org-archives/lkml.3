Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaI3Vy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:54:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60999 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaI3Vh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 080/103] regmap: Fix regcache debugfs initialization
Date: Tue, 30 Sep 2014 14:31:25 -0700
Message-Id: <1412112708-27356-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 5e0cbe78762b5f02986bf9e59a188dad2f6e0be1 upstream.

Commit 6cfec04bcc05 ("regmap: Separate regmap dev initialization") moved the
regmap debugfs initialization after regcache initialization. This means
that the regmap debugfs directory is not created yet when the cache
initialization runs and so any debugfs files registered by the regcache are
created in the debugfs root directory rather than the debugfs directory of
the regmap instance. Fix this by adding a separate callback for the
regcache debugfs initialization which will be called after the parent
debugfs entry has been created.

Fixes: 6cfec04bcc05 (regmap: Separate regmap dev initialization)
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/internal.h        | 3 +++
 drivers/base/regmap/regcache-rbtree.c | 9 +++------
 drivers/base/regmap/regmap-debugfs.c  | 3 +++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 33414b1..12fec5a 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -144,6 +144,9 @@ struct regcache_ops {
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
index 930cad4..8c825a9 100644
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
index c5471cd..f89d382 100644
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
1.9.1

