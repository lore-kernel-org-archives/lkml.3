Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaIPLnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:43:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:53291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaIPLnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="603517414"
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH] regmap: cache: Do not fail silently from regcache_sync calls
Date: Tue, 16 Sep 2014 14:04:14 +0300
Message-Id: <1410865454-30102-1-git-send-email-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call stack of regcache_sync calls may not emit any error message even if
operation was cancelled due an error in I/O driver. One such a silent error
is for instance if I2C bus driver doesn't receive ACK from the I2C device
and returns -EREMOTEIO.

Since many users of regcache_sync() don't check and print the error there is
no any indication that HW registers are potentially out of sync.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
---
I noticed this silent failure when doing commit f4821e8e8e95
("ASoC: rt5640: Do not allow regmap to use bulk read-write operations") but
forgot to send a patch. I was thinking should the error prints be in lower
level, e.g. _regmap_raw_write, but maybe it's good to have sync errors
printed explicitly?
---
 drivers/base/regmap/regcache.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 5617da6dc898..f1280dc356d0 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -269,8 +269,11 @@ static int regcache_default_sync(struct regmap *map, unsigned int min,
 		map->cache_bypass = 1;
 		ret = _regmap_write(map, reg, val);
 		map->cache_bypass = 0;
-		if (ret)
+		if (ret) {
+			dev_err(map->dev, "Unable to sync register %#x. %d\n",
+				reg, ret);
 			return ret;
+		}
 		dev_dbg(map->dev, "Synced register %#x, value %#x\n", reg, val);
 	}
 
@@ -615,8 +618,11 @@ static int regcache_sync_block_single(struct regmap *map, void *block,
 		ret = _regmap_write(map, regtmp, val);
 
 		map->cache_bypass = 0;
-		if (ret != 0)
+		if (ret != 0) {
+			dev_err(map->dev, "Unable to sync register %#x. %d\n",
+				regtmp, ret);
 			return ret;
+		}
 		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
 			regtmp, val);
 	}
@@ -641,6 +647,9 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 	map->cache_bypass = 1;
 
 	ret = _regmap_raw_write(map, base, *data, count * val_bytes);
+	if (ret)
+		dev_err(map->dev, "Unable to sync registers %#x-%#x. %d\n",
+			base, cur - map->reg_stride, ret);
 
 	map->cache_bypass = 0;
 
-- 
2.1.0

