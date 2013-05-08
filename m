Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3EHM7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:59:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab3EHM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:59:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regmap: Make regmap_check_range_table() a public API
Date: Wed,  8 May 2013 13:55:23 +0100
Message-Id: <1368017725-23723-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to use an access table as part of their implementation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   14 +++++++-------
 include/linux/regmap.h       |    3 +++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a941dcf..307f5a1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -65,9 +65,8 @@ bool regmap_reg_in_ranges(unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_reg_in_ranges);
 
-static bool _regmap_check_range_table(struct regmap *map,
-				      unsigned int reg,
-				      const struct regmap_access_table *table)
+bool regmap_check_range_table(struct regmap *map, unsigned int reg,
+			      const struct regmap_access_table *table)
 {
 	/* Check "no ranges" first */
 	if (regmap_reg_in_ranges(reg, table->no_ranges, table->n_no_ranges))
@@ -80,6 +79,7 @@ static bool _regmap_check_range_table(struct regmap *map,
 	return regmap_reg_in_ranges(reg, table->yes_ranges,
 				    table->n_yes_ranges);
 }
+EXPORT_SYMBOL_GPL(regmap_check_range_table);
 
 bool regmap_writeable(struct regmap *map, unsigned int reg)
 {
@@ -90,7 +90,7 @@ bool regmap_writeable(struct regmap *map, unsigned int reg)
 		return map->writeable_reg(map->dev, reg);
 
 	if (map->wr_table)
-		return _regmap_check_range_table(map, reg, map->wr_table);
+		return regmap_check_range_table(map, reg, map->wr_table);
 
 	return true;
 }
@@ -107,7 +107,7 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 		return map->readable_reg(map->dev, reg);
 
 	if (map->rd_table)
-		return _regmap_check_range_table(map, reg, map->rd_table);
+		return regmap_check_range_table(map, reg, map->rd_table);
 
 	return true;
 }
@@ -121,7 +121,7 @@ bool regmap_volatile(struct regmap *map, unsigned int reg)
 		return map->volatile_reg(map->dev, reg);
 
 	if (map->volatile_table)
-		return _regmap_check_range_table(map, reg, map->volatile_table);
+		return regmap_check_range_table(map, reg, map->volatile_table);
 
 	return true;
 }
@@ -135,7 +135,7 @@ bool regmap_precious(struct regmap *map, unsigned int reg)
 		return map->precious_reg(map->dev, reg);
 
 	if (map->precious_table)
-		return _regmap_check_range_table(map, reg, map->precious_table);
+		return regmap_check_range_table(map, reg, map->precious_table);
 
 	return false;
 }
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 5067ee9..d6f3221 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -400,6 +400,9 @@ void regcache_cache_only(struct regmap *map, bool enable);
 void regcache_cache_bypass(struct regmap *map, bool enable);
 void regcache_mark_dirty(struct regmap *map);
 
+bool regmap_check_range_table(struct regmap *map, unsigned int reg,
+			      const struct regmap_access_table *table);
+
 int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs);
 
-- 
1.7.10.4

