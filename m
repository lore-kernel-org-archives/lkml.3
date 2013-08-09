Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966156Ab3HIKJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:09:55 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:12092 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965601Ab3HIKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:09:54 -0400
Message-ID: <5204BFC7.4090106@nsn.com>
Date: Fri, 09 Aug 2013 12:09:11 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] regmap: flat: use the cache_present bitmap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2167
X-purgate-ID: 151667::1376042952-00003561-62A591EF/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As opposed to the other regmap cache implementations,
regcache_flat didn't use the cache_present bitmap for
figuring out whether a register was cached or not, nor
did it mark a register as present in the cache when
regcache_flat_write() was called.

This caused incorrect behaviour, such as returning
value 0 for non-volatile registers without first reading
their value from the device and storing it in the cache.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/base/regmap/regcache-flat.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regcache-flat.c b/drivers/base/regmap/regcache-flat.c
index d9762e4..f47278e 100644
--- a/drivers/base/regmap/regcache-flat.c
+++ b/drivers/base/regmap/regcache-flat.c
@@ -16,9 +16,13 @@
 
 #include "internal.h"
 
+static int regcache_flat_write(struct regmap *map, unsigned int reg,
+			       unsigned int value);
+static int regcache_flat_exit(struct regmap *map);
+
 static int regcache_flat_init(struct regmap *map)
 {
-	int i;
+	int i, ret;
 	unsigned int *cache;
 
 	map->cache = kzalloc(sizeof(unsigned int) * (map->max_register + 1),
@@ -28,8 +32,15 @@ static int regcache_flat_init(struct regmap *map)
 
 	cache = map->cache;
 
-	for (i = 0; i < map->num_reg_defaults; i++)
-		cache[map->reg_defaults[i].reg] = map->reg_defaults[i].def;
+	for (i = 0; i < map->num_reg_defaults; i++) {
+		ret = regcache_flat_write(map,
+				map->reg_defaults[i].reg,
+				map->reg_defaults[i].def);
+		if (ret) {
+			regcache_flat_exit(map);
+			return ret;
+		}
+	}
 
 	return 0;
 }
@@ -47,6 +58,9 @@ static int regcache_flat_read(struct regmap *map,
 {
 	unsigned int *cache = map->cache;
 
+	if (!regcache_reg_present(map, reg))
+		return -ENOENT;
+
 	*value = cache[reg];
 
 	return 0;
@@ -56,6 +70,11 @@ static int regcache_flat_write(struct regmap *map, unsigned int reg,
 			       unsigned int value)
 {
 	unsigned int *cache = map->cache;
+	int ret;
+
+	ret = regcache_set_reg_present(map, reg);
+	if (ret < 0)
+		return ret;
 
 	cache[reg] = value;
 
-- 
1.7.1

