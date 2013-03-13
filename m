Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab3CMTbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:31:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43879 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933232Ab3CMTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:31:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: cache: Provide a get address of value operation
Date: Wed, 13 Mar 2013 19:31:42 +0000
Message-Id: <1363203102-20810-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a helper to do the size based index into a block of registers and
use it when reading a value.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    6 ++++++
 drivers/base/regmap/regcache.c |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 9fc351f0..54b2fd9 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -190,6 +190,12 @@ int regcache_write(struct regmap *map,
 			unsigned int reg, unsigned int value);
 int regcache_sync(struct regmap *map);
 
+static inline void *regcache_get_val_addr(struct regmap *map, const void *base,
+				   unsigned int idx)
+{
+	return base + (map->cache_word_size * idx);
+}
+
 unsigned int regcache_get_val(struct regmap *map, const void *base,
 			      unsigned int idx);
 bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 0f4fb8b..229c804 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -458,8 +458,8 @@ unsigned int regcache_get_val(struct regmap *map, const void *base,
 
 	/* Use device native format if possible */
 	if (map->format.parse_val)
-		return map->format.parse_val(base +
-					     (map->cache_word_size * idx));
+		return map->format.parse_val(regcache_get_val_addr(map, base,
+								   idx));
 
 	switch (map->cache_word_size) {
 	case 1: {
-- 
1.7.10.4

