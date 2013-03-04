Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3CDBPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:15:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771Ab3CDBOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:14:52 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: cache: Store caches in native register format where possible
Date: Mon,  4 Mar 2013 09:14:40 +0800
Message-Id: <1362359680-23747-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362359680-23747-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1362359680-23747-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the cached data to be sent directly to the device when
we sync it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6948996..0f4fb8b 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -45,8 +45,8 @@ static int regcache_hw_init(struct regmap *map)
 		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
 		if (!tmp_buf)
 			return -EINVAL;
-		ret = regmap_bulk_read(map, 0, tmp_buf,
-				       map->num_reg_defaults_raw);
+		ret = regmap_raw_read(map, 0, tmp_buf,
+				      map->num_reg_defaults_raw);
 		map->cache_bypass = cache_bypass;
 		if (ret < 0) {
 			kfree(tmp_buf);
@@ -421,6 +421,13 @@ bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 	if (regcache_get_val(map, base, idx) == val)
 		return true;
 
+	/* Use device native format if possible */
+	if (map->format.format_val) {
+		map->format.format_val(base + (map->cache_word_size * idx),
+				       val, 0);
+		return false;
+	}
+
 	switch (map->cache_word_size) {
 	case 1: {
 		u8 *cache = base;
@@ -449,6 +456,11 @@ unsigned int regcache_get_val(struct regmap *map, const void *base,
 	if (!base)
 		return -EINVAL;
 
+	/* Use device native format if possible */
+	if (map->format.parse_val)
+		return map->format.parse_val(base +
+					     (map->cache_word_size * idx));
+
 	switch (map->cache_word_size) {
 	case 1: {
 		const u8 *cache = base;
-- 
1.7.10.4

