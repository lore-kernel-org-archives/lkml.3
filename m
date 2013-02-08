Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946465Ab3BHMrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:47:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48106 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946353Ab3BHMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:47:16 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/2 v2] regmap: debugfs: Add a `max_reg' member in struct regmap_debugfs_off_cache
Date: Fri,  8 Feb 2013 12:47:14 +0000
Message-Id: <1360327634-16669-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are keeping track of the maximum register as well, this will make
things easier for us in sharing this code with the code implementing
the register ranges functionality.  It also simplifies a bit the
calculations when looking for the relevant block:offset from within
the cache.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       | 1 +
 drivers/base/regmap/regmap-debugfs.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 0ae5b78..5a22bd3 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -26,6 +26,7 @@ struct regmap_debugfs_off_cache {
 	off_t min;
 	off_t max;
 	unsigned int base_reg;
+	unsigned int max_reg;
 };
 
 struct regmap_format {
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index faa93cc..5fa2e6d 100644
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
@@ -93,6 +95,9 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 			    regmap_precious(map, i)) {
 				if (c) {
 					c->max = p - 1;
+					fpos_offset = c->max - c->min;
+					reg_offset = fpos_offset / map->debugfs_tot_len;
+					c->max_reg = c->base_reg + reg_offset;
 					list_add_tail(&c->list,
 						      &map->debugfs_off_cache);
 					c = NULL;
@@ -119,6 +124,9 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
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

