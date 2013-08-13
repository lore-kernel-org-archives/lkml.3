Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3HMG6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:58:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3HMGdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [ 13/60] regmap: cache: Make sure to sync the last register in a block
Date: Mon, 12 Aug 2013 23:33:40 -0700
Message-Id: <20130813063333.910044708@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 2d49b5987561e480bdbd8692b27fc5f49a1e2f0b upstream.

regcache_sync_block_raw_flush() expects the address of the register after last
register that needs to be synced as its parameter. But the last call to
regcache_sync_block_raw_flush() in regcache_sync_block_raw() passes the address
of the last register in the block. This effectively always skips over the last
register in a block, even if it needs to be synced. In order to fix it increase
the address by one register.

The issue was introduced in commit 75a5f89 ("regmap: cache: Write consecutive
registers in a single block write").

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -644,7 +644,8 @@ static int regcache_sync_block_raw(struc
 		}
 	}
 
-	return regcache_sync_block_raw_flush(map, &data, base, regtmp);
+	return regcache_sync_block_raw_flush(map, &data, base, regtmp +
+			map->reg_stride);
 }
 
 int regcache_sync_block(struct regmap *map, void *block,


