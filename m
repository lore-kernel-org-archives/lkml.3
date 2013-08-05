Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3HEJ1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:27:38 -0400
Received: from smtp-out-185.synserver.de ([212.40.185.185]:1060 "EHLO
	smtp-out-185.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3HEJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:27:37 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 05:27:36 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15707
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: cache: Make sure to sync the last register in a block
Date: Mon,  5 Aug 2013 11:21:29 +0200
Message-Id: <1375694489-12790-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache_sync_block_raw_flush() expects the address of the register after last
register that needs to be synced as its parameter. But the last call to
regcache_sync_block_raw_flush() in regcache_sync_block_raw() passes the address
of the last register in the block. This effectively always skips over the last
register in a block, even if it needs to be synced. In order to fix it increase
the address by one register.

The issue was introduced in commit 75a5f89 ("regmap: cache: Write consecutive
registers in a single block write").

Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e691026..3455f83 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -719,7 +719,8 @@ static int regcache_sync_block_raw(struct regmap *map, void *block,
 		}
 	}
 
-	return regcache_sync_block_raw_flush(map, &data, base, regtmp);
+	return regcache_sync_block_raw_flush(map, &data, base, regtmp +
+			map->reg_stride);
 }
 
 int regcache_sync_block(struct regmap *map, void *block,
-- 
1.8.0

