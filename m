Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaAXXlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 18:41:53 -0500
Received: from mail-pb0-f73.google.com ([209.85.160.73]:64679 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaAXXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 18:41:50 -0500
From: Dylan Reid <dgreid@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Dylan Reid <dgreid@chromium.org>
Subject: [PATCH] regmap: cache: Handle stride > 1 in sync_block_raw_flush
Date: Fri, 24 Jan 2014 15:40:39 -0800
Message-Id: <1390606839-1044-1-git-send-email-dgreid@chromium.org>
X-Mailer: git-send-email 1.8.1.3.605.g02339dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache_sync_block_raw_flush takes the address of the base register
and the address of one past the last register to write to.  "count" is
the number of registers in the range, not the number of bytes, it
should be (end addr - start addr) / stride. Without accounting for
strides greater than one, registers past the end might be synced or
the writeable_reg callback at the beginning of _regmap_raw_write will
fail and nothing will be written.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
---
 drivers/base/regmap/regcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d4dd771..dd56177 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -636,10 +636,10 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 	if (*data == NULL)
 		return 0;
 
-	count = cur - base;
+	count = (cur - base) / map->reg_stride;
 
 	dev_dbg(map->dev, "Writing %zu bytes for %d registers from 0x%x-0x%x\n",
-		count * val_bytes, count, base, cur - 1);
+		count * val_bytes, count, base, cur - map->reg_stride);
 
 	map->cache_bypass = 1;
 
-- 
1.8.1.3.605.g02339dd

