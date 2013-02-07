Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3BGLkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:40:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33081 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757874Ab3BGLk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:40:27 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/2] regmap: debugfs: Add a `max_reg' member in struct regmap_debugfs_off_cache
Date: Thu,  7 Feb 2013 11:40:25 +0000
Message-Id: <1360237225-2184-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are keeping track of the maximum register as well, this will make
things easier for us in sharing this code with the code implementing
the register ranges functionality.  It also simplifies a bit the
calculations when looking for the relevant block:offset from within
the cache.

Change-Id: I961320c4a56fdd25d74f1a6cc1b470ff22d8dbca
Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       | 1 +
 drivers/base/regmap/regmap-debugfs.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index ef61b24..71d9b0a 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -25,6 +25,7 @@ struct regmap_debugfs_off_cache {
 	off_t min;
 	off_t max;
 	unsigned int base_reg;
+	unsigned int max_reg;
 };
 
 struct regmap_format {
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 96990d2..c2c51f7 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -93,6 +93,9 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 			    regmap_precious(map, i)) {
 				if (c) {
 					c->max = p - 1;
+					fpos_offset = c->max - c->min;
+					reg_offset = fpos_offset / map->debugfs_tot_len;
+					c->max_reg = c->base_reg + reg_offset;
 					list_add_tail(&c->list,
 						      &map->debugfs_off_cache);
 					c = NULL;
@@ -119,6 +122,9 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	/* Close the last entry off if we didn't scan beyond it */
 	if (c) {
 		c->max = p - 1;
+		fpos_offset = c->max - c->min;
+		reg_offset = fpos_offset / map->debugfs_tot_len;
+		c->max_reg = c->base_reg + reg_offset;
 		list_add_tail(&c->list,
 			      &map->debugfs_off_cache);
 	}
-- 
1.8.1.2

