Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3BGLkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:40:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757874Ab3BGLke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:40:34 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/2] regmap: debugfs: Optimize seeking within blocks of registers
Date: Thu,  7 Feb 2013 11:40:32 +0000
Message-Id: <1360237232-2220-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize this so that we can better guess where to start scanning
from.  We know the length of the register field format, therefore
given the file pointer position align to the nearest register
field and scan from there onwards.  We round down in this calculation
and we let the rest of the code figure out where to start scanning
from.

Change-Id: I2515e0981ef6b17f784dd0e389d0d4a13d47123c
Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c2c51f7..1525f39 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -81,6 +81,8 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	struct regmap_debugfs_off_cache *c = NULL;
 	loff_t p = 0;
 	unsigned int i, ret;
+	unsigned int fpos_offset;
+	unsigned int reg_offset;
 
 	/*
 	 * If we don't have a cache build one so we don't have to do a
@@ -139,15 +141,17 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 		return base;
 	}
 
-	/* Find the relevant block */
+	/* Find the relevant block:offset */
 	list_for_each_entry(c, &map->debugfs_off_cache, list) {
 		if (from >= c->min && from <= c->max) {
-			*pos = c->min;
-			return c->base_reg;
+			fpos_offset = from - c->min;
+			reg_offset = fpos_offset / map->debugfs_tot_len;
+			*pos = c->min + (reg_offset * map->debugfs_tot_len);
+			return c->base_reg + reg_offset;
 		}
 
-		*pos = c->min;
-		ret = c->base_reg;
+		*pos = c->max;
+		ret = c->max_reg;
 	}
 
 	return ret;
-- 
1.8.1.2

