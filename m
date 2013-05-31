Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3EaOi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:38:28 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4003 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3EaOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:38:22 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] regmap: regcache-flat: Implemented sync operation
Date: Fri, 31 May 2013 16:36:15 +0200
Message-Id: <1370010975-10655-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 drivers/base/regmap/regcache-flat.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/base/regmap/regcache-flat.c b/drivers/base/regmap/regcache-flat.c
index d9762e4..1f18bec 100644
--- a/drivers/base/regmap/regcache-flat.c
+++ b/drivers/base/regmap/regcache-flat.c
@@ -62,6 +62,37 @@ static int regcache_flat_write(struct regmap *map, unsigned int reg,
 	return 0;
 }
 
+static int regcache_flat_sync(struct regmap *map, unsigned int min,
+			      unsigned int max)
+{
+	unsigned int *cache = map->cache;
+	unsigned int reg;
+
+	for (reg = min; reg <= max; reg++) {
+		unsigned int val;
+		int ret;
+
+		if (regmap_volatile(map, reg))
+			continue;
+
+		val = cache[reg];
+
+		/* Is this the hardware default?  If so skip. */
+		ret = regcache_lookup_reg(map, reg);
+		if (ret >= 0 && val == map->reg_defaults[ret].def)
+			continue;
+
+		map->cache_bypass = 1;
+		ret = _regmap_write(map, reg, val);
+		map->cache_bypass = 0;
+		if (ret)
+			return ret;
+		dev_dbg(map->dev, "Synced register %#x, value %#x\n", reg, val);
+	}
+
+	return 0;
+}
+
 struct regcache_ops regcache_flat_ops = {
 	.type = REGCACHE_FLAT,
 	.name = "flat",
@@ -69,4 +100,5 @@ struct regcache_ops regcache_flat_ops = {
 	.exit = regcache_flat_exit,
 	.read = regcache_flat_read,
 	.write = regcache_flat_write,
+	.sync = regcache_flat_sync,
 };
-- 
1.7.10.4

