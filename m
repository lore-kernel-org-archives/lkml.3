Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966514Ab3HIKKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:10:03 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:12113 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965601Ab3HIKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:10:00 -0400
Message-ID: <5204BFD0.5080305@nsn.com>
Date: Fri, 09 Aug 2013 12:09:20 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] regmap: regcache: allow read-only regs to be cached
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1570
X-purgate-ID: 151667::1376042964-00003561-337A0975/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_writeable() check should not be done in
regcache_write() because this prevents read-only
registers to be cached. After a read on a read-only
register its value will not be stored in the cache
and the next time someone will try to read it the
value will be read from the bus instead of the
cache.

Instead the regmap_writeable() check should be done
in _regmap_write() to prevent callers from writing
to read-only registers.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/base/regmap/regcache.c |    3 ---
 drivers/base/regmap/regmap.c   |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 3455f83..e2abd05 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -241,9 +241,6 @@ int regcache_write(struct regmap *map,
 
 	BUG_ON(!map->cache_ops);
 
-	if (!regmap_writeable(map, reg))
-		return -EIO;
-
 	if (!regmap_volatile(map, reg))
 		return map->cache_ops->write(map, reg, value);
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fa76b61..42b45ac 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1267,6 +1267,9 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	int ret;
 	void *context = _regmap_map_get_context(map);
 
+	if (!regmap_writeable(map, reg))
+		return -EIO;
+
 	if (!map->cache_bypass && !map->defer_caching) {
 		ret = regcache_write(map, reg, val);
 		if (ret != 0)
-- 
1.7.1

