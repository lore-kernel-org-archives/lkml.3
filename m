Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3C0NGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:06:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34733 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab3C0NGW (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 27 Mar 2013 09:06:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: core: Provide regmap_can_raw_write() operation
Date: Wed, 27 Mar 2013 13:06:17 +0000
Message-Id: <1364389578-8714-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly useful internally but exported since this is a public API that's
being checked for.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   15 ++++++++++++---
 include/linux/regmap.h       |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9174c9d..9ab1e1f 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1097,6 +1097,17 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
+/**
+ * regmap_can_raw_write - Test if regmap_raw_write() is supported
+ *
+ * @map: Map to check.
+ */
+bool regmap_can_raw_write(struct regmap *map)
+{
+	return map->bus && map->format.format_val && map->format.format_reg;
+}
+EXPORT_SYMBOL_GPL(regmap_can_raw_write);
+
 static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 				       unsigned int val)
 {
@@ -1220,12 +1231,10 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
-	if (!map->bus)
+	if (!regmap_can_raw_write(map))
 		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
-	if (reg % map->reg_stride)
-		return -EINVAL;
 
 	map->lock(map->lock_arg);
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index bf77dfd..02d84e2 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -389,6 +389,7 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     bool *change);
 int regmap_get_val_bytes(struct regmap *map);
 int regmap_async_complete(struct regmap *map);
+bool regmap_can_raw_write(struct regmap *map);
 
 int regcache_sync(struct regmap *map);
 int regcache_sync_region(struct regmap *map, unsigned int min,
-- 
1.7.10.4

