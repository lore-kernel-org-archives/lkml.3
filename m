Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaBUTpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:45:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35268 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbaBUTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:45:28 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/3] regmap: Add API call apply but not register a patch file
Date: Fri, 21 Feb 2014 19:37:11 +0000
Message-Id: <1393011432-28909-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a new regmap API call that allows a patch to be
applied but not registered with the regmap core. Common code between
this and the existing regmap_register_patch function is factored out to
reduce duplication.

This can be helpful when devices have more complex boot proceedures and
the patch file must be applied manually during the boot process.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   85 +++++++++++++++++++++++++++++++-----------
 include/linux/regmap.h       |    2 +
 2 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c2ba89a..faed8f1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2178,24 +2178,9 @@ int regmap_async_complete(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regmap_async_complete);
 
-/**
- * regmap_register_patch: Register and apply register updates to be applied
- *                        on device initialistion
- *
- * @map: Register map to apply updates to.
- * @regs: Values to update.
- * @num_regs: Number of entries in regs.
- *
- * Register a set of register updates to be applied to the device
- * whenever the device registers are synchronised with the cache and
- * apply them immediately.  Typically this is used to apply
- * corrections to be applied to the device defaults on startup, such
- * as the updates some vendors provide to undocumented registers.
- */
-int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
-			  int num_regs)
+int _regmap_apply_patch(struct regmap *map, const struct reg_default *regs,
+		       int num_regs)
 {
-	struct reg_default *p;
 	int i, ret;
 	bool bypass;
 
@@ -2203,8 +2188,6 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	    num_regs))
 		return 0;
 
-	map->lock(map->lock_arg);
-
 	bypass = map->cache_bypass;
 
 	map->cache_bypass = true;
@@ -2224,6 +2207,67 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 		}
 	}
 
+out:
+	map->async = false;
+	map->cache_bypass = bypass;
+
+	return ret;
+}
+
+/**
+ * regmap_apply_patch: Apply register patch updates
+ *
+ * @map: Register map to apply updates to.
+ * @regs: Values to update.
+ * @num_regs: Number of entries in regs.
+ *
+ * Immediately applies a set of register updates to the device, but does
+ * not register them so they won't be reapplied on subsequent boots of
+ * the device.
+ */
+int regmap_apply_patch(struct regmap *map, const struct reg_default *regs,
+		       int num_regs)
+{
+	int ret;
+
+	map->lock(map->lock_arg);
+
+	ret = _regmap_apply_patch(map, regs, num_regs);
+
+	map->unlock(map->lock_arg);
+
+	regmap_async_complete(map);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_apply_patch);
+
+/**
+ * regmap_register_patch: Register and apply register updates to be applied
+ *                        on device initialistion
+ *
+ * @map: Register map to apply updates to.
+ * @regs: Values to update.
+ * @num_regs: Number of entries in regs.
+ *
+ * Register a set of register updates to be applied to the device
+ * whenever the device registers are synchronised with the cache and
+ * apply them immediately.  Typically this is used to apply
+ * corrections to be applied to the device defaults on startup, such
+ * as the updates some vendors provide to undocumented registers.
+ */
+int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
+			  int num_regs)
+{
+	struct reg_default *p;
+	int ret;
+
+	map->lock(map->lock_arg);
+
+	ret = _regmap_apply_patch(map, regs, num_regs);
+	if (ret != 0)
+		goto out;
+
 	p = krealloc(map->patch,
 		     sizeof(struct reg_default) * (map->patch_regs + num_regs),
 		     GFP_KERNEL);
@@ -2236,9 +2280,6 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	}
 
 out:
-	map->async = false;
-	map->cache_bypass = bypass;
-
 	map->unlock(map->lock_arg);
 
 	regmap_async_complete(map);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index fa4d079..c6d638a 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -423,6 +423,8 @@ void regcache_mark_dirty(struct regmap *map);
 bool regmap_check_range_table(struct regmap *map, unsigned int reg,
 			      const struct regmap_access_table *table);
 
+int regmap_apply_patch(struct regmap *map, const struct reg_default *regs,
+			  int num_regs);
 int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs);
 
-- 
1.7.2.5

