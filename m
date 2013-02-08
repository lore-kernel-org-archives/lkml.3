Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946526Ab3BHMrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:47:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48111 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946353Ab3BHMrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:47:21 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/2 v2] regmap: debugfs: Optimize seeking within blocks of registers
Date: Fri,  8 Feb 2013 12:47:20 +0000
Message-Id: <1360327640-16705-1-git-send-email-dp@opensource.wolfsonmicro.com>
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

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 5fa2e6d..8584fac 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -139,15 +139,17 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	WARN_ON(list_empty(&map->debugfs_off_cache));
 	ret = base;
 
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

