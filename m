Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbaHZODm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:03:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:23606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaHZODk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:03:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,404,1406617200"; 
   d="scan'208";a="581860796"
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH 1/2] regmap: cache: Fix regcache_sync_block for non-autoincrementing devices
Date: Tue, 26 Aug 2014 17:03:12 +0300
Message-Id: <1409061793-10495-2-git-send-email-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
References: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75a5f89f635c ("regmap: cache: Write consecutive registers in a single
block write") expected that autoincrementing writes are supported if
hardware has a register format which can support raw writes.

This is not necessarily true and thus for instance rbtree sync can fail when
there is need to sync multiple consecutive registers but block write to
device fails due not supported autoincrementing writes.

Fix this by spliting raw block sync to series of single register writes for
devices that don't support autoincrementing writes.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
---
I noticed this with Realtek RT5642 audio codec which didn't resume properly
since first block write having more data than for single register failed to
not acknowledged I2C write during regcache_sync(). Chip acknowledges device
address, register address and two data bytes for its word size registers but
next data byte is not which then causes aborted I2C transfer and aborted
register sync.
---
 drivers/base/regmap/regcache.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 29b4128da0b0..54707e586ac8 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -629,6 +629,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 {
 	size_t val_bytes = map->format.val_bytes;
 	int ret, count;
+	unsigned int i;
 
 	if (*data == NULL)
 		return 0;
@@ -640,7 +641,18 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 
 	map->cache_bypass = 1;
 
-	ret = _regmap_raw_write(map, base, *data, count * val_bytes);
+	if (!map->use_single_rw) {
+		ret = _regmap_raw_write(map, base, *data, count * val_bytes);
+	} else {
+		for (i = 0; i < count; i++) {
+			ret = _regmap_raw_write(map,
+						base + (i * map->reg_stride),
+						*data + (i * val_bytes),
+						val_bytes);
+			if (ret != 0)
+				break;
+		}
+	}
 
 	map->cache_bypass = 0;
 
-- 
2.1.0

