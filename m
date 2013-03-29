Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3C2VDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:03:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52869 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756931Ab3C2VDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:03:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: dp@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] regmap: cache: Write consecutive registers in a single block write
Date: Fri, 29 Mar 2013 21:03:45 +0000
Message-Id: <1364591025-18525-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When syncing blocks of data using raw writes combine the writes into a
single block write, saving us bus overhead for setup, addressing and
teardown.

Currently the block write is done unconditionally as it is expected that
hardware which has a register format which can support raw writes will
support auto incrementing writes, this decision may need to be revised in
future.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   64 +++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index da4d984..d81f605 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -579,42 +579,72 @@ static int regcache_sync_block_single(struct regmap *map, void *block,
 	return 0;
 }
 
+static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
+					 unsigned int base, unsigned int cur)
+{
+	size_t val_bytes = map->format.val_bytes;
+	int ret, count;
+
+	if (*data == NULL)
+		return 0;
+
+	count = cur - base;
+
+	dev_dbg(map->dev, "Writing %d bytes for %d registers from 0x%x-0x%x\n",
+		count * val_bytes, count, base, cur - 1);
+
+	map->cache_bypass = 1;
+
+	ret = _regmap_raw_write(map, base, *data, count * val_bytes,
+				false);
+
+	map->cache_bypass = 0;
+
+	*data = NULL;
+
+	return ret;
+}
+
 int regcache_sync_block_raw(struct regmap *map, void *block,
 			    unsigned int block_base, unsigned int start,
 			    unsigned int end)
 {
-	unsigned int i, regtmp, val;
-	const void *addr;
+	unsigned int i, val;
+	unsigned int regtmp = 0;
+	unsigned int base = 0;
+	const void *data = NULL;
 	int ret;
 
 	for (i = start; i < end; i++) {
 		regtmp = block_base + (i * map->reg_stride);
 
-		if (!regcache_reg_present(map, regtmp))
+		if (!regcache_reg_present(map, regtmp)) {
+			ret = regcache_sync_block_raw_flush(map, &data,
+							    base, regtmp);
+			if (ret != 0)
+				return ret;
 			continue;
+		}
 
 		val = regcache_get_val(map, block, i);
 
 		/* Is this the hardware default?  If so skip. */
 		ret = regcache_lookup_reg(map, regtmp);
-		if (ret >= 0 && val == map->reg_defaults[ret].def)
+		if (ret >= 0 && val == map->reg_defaults[ret].def) {
+			ret = regcache_sync_block_raw_flush(map, &data,
+							    base, regtmp);
+			if (ret != 0)
+				return ret;
 			continue;
+		}
 
-		map->cache_bypass = 1;
-
-		addr = regcache_get_val_addr(map, block, i);
-		ret = _regmap_raw_write(map, regtmp, addr,
-					map->format.val_bytes,
-					false);
-
-		map->cache_bypass = 0;
-		if (ret != 0)
-			return ret;
-		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
-			regtmp, val);
+		if (!data) {
+			data = regcache_get_val_addr(map, block, i);
+			base = regtmp;
+		}
 	}
 
-	return 0;
+	return regcache_sync_block_raw_flush(map, &data, base, regtmp);
 }
 
 int regcache_sync_block(struct regmap *map, void *block,
-- 
1.7.10.4

