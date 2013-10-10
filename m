Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3JJUHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:07:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56495 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3JJUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:07:20 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Thu, 10 Oct 2013 21:06:57 +0100
Message-Id: <1381435617-18743-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Use async I/O during cache sync
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Try to speed up I/O a little by not synchronising until we are finished
scheduling writes. A brief survey of existing users suggests we have none
that would currently benefit from an async cache sync.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regcache.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index a36112a..d4dd771 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -307,6 +307,8 @@ int regcache_sync(struct regmap *map)
 	if (!map->cache_dirty)
 		goto out;
 
+	map->async = true;
+
 	/* Apply any patch first */
 	map->cache_bypass = 1;
 	for (i = 0; i < map->patch_regs; i++) {
@@ -332,11 +334,15 @@ int regcache_sync(struct regmap *map)
 		map->cache_dirty = false;
 
 out:
-	trace_regcache_sync(map->dev, name, "stop");
 	/* Restore the bypass state */
+	map->async = false;
 	map->cache_bypass = bypass;
 	map->unlock(map->lock_arg);
 
+	regmap_async_complete(map);
+
+	trace_regcache_sync(map->dev, name, "stop");
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regcache_sync);
@@ -375,17 +381,23 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 	if (!map->cache_dirty)
 		goto out;
 
+	map->async = true;
+
 	if (map->cache_ops->sync)
 		ret = map->cache_ops->sync(map, min, max);
 	else
 		ret = regcache_default_sync(map, min, max);
 
 out:
-	trace_regcache_sync(map->dev, name, "stop region");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
+	map->async = false;
 	map->unlock(map->lock_arg);
 
+	regmap_async_complete(map);
+
+	trace_regcache_sync(map->dev, name, "stop region");
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regcache_sync_region);
-- 
1.8.4.rc3

