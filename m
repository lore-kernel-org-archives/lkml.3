Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3C2VDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:03:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52870 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756736Ab3C2VDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:03:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: dp@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regmap: cache: Split raw and non-raw syncs
Date: Fri, 29 Mar 2013 21:03:44 +0000
Message-Id: <1364591025-18525-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For code clarity after implementing block writes split out the raw and
non-raw I/O sync implementations.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   64 +++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index bb317db..da4d984 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -545,9 +545,43 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg)
 		return -ENOENT;
 }
 
-int regcache_sync_block(struct regmap *map, void *block,
-			unsigned int block_base, unsigned int start,
-			unsigned int end)
+static int regcache_sync_block_single(struct regmap *map, void *block,
+				      unsigned int block_base,
+				      unsigned int start, unsigned int end)
+{
+	unsigned int i, regtmp, val;
+	int ret;
+
+	for (i = start; i < end; i++) {
+		regtmp = block_base + (i * map->reg_stride);
+
+		if (!regcache_reg_present(map, regtmp))
+			continue;
+
+		val = regcache_get_val(map, block, i);
+
+		/* Is this the hardware default?  If so skip. */
+		ret = regcache_lookup_reg(map, regtmp);
+		if (ret >= 0 && val == map->reg_defaults[ret].def)
+			continue;
+
+		map->cache_bypass = 1;
+
+		ret = _regmap_write(map, regtmp, val);
+
+		map->cache_bypass = 0;
+		if (ret != 0)
+			return ret;
+		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
+			regtmp, val);
+	}
+
+	return 0;
+}
+
+int regcache_sync_block_raw(struct regmap *map, void *block,
+			    unsigned int block_base, unsigned int start,
+			    unsigned int end)
 {
 	unsigned int i, regtmp, val;
 	const void *addr;
@@ -568,14 +602,10 @@ int regcache_sync_block(struct regmap *map, void *block,
 
 		map->cache_bypass = 1;
 
-		if (regmap_can_raw_write(map)) {
-			addr = regcache_get_val_addr(map, block, i);
-			ret = _regmap_raw_write(map, regtmp, addr,
-						map->format.val_bytes,
-						false);
-		} else {
-			ret = _regmap_write(map, regtmp, val);
-		}
+		addr = regcache_get_val_addr(map, block, i);
+		ret = _regmap_raw_write(map, regtmp, addr,
+					map->format.val_bytes,
+					false);
 
 		map->cache_bypass = 0;
 		if (ret != 0)
@@ -586,3 +616,15 @@ int regcache_sync_block(struct regmap *map, void *block,
 
 	return 0;
 }
+
+int regcache_sync_block(struct regmap *map, void *block,
+			unsigned int block_base, unsigned int start,
+			unsigned int end)
+{
+	if (regmap_can_raw_write(map))
+		return regcache_sync_block_raw(map, block, block_base,
+					       start, end);
+	else
+		return regcache_sync_block_single(map, block, block_base,
+						  start, end);
+}
-- 
1.7.10.4

