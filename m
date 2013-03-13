Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3CMPgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:36:46 -0400
Received: from smtp-out-061.synserver.de ([212.40.185.61]:1044 "EHLO
	smtp-out-059.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932391Ab3CMPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:36:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12973
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        stable@vger.kernel.org
Subject: [PATCH] regmap: Fix regcache-rbtree sync
Date: Wed, 13 Mar 2013 16:38:33 +0100
Message-Id: <1363189113-9757-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last register block, which falls into the specified range, is not handled
correctly. The formula which calculates the number of register which should be
synced is inverse (and off by one). E.g. if all registers in that block should
be synced only one is synced, and if only one should be synced all (but one) are
synced. To calculate the number of registers that need to be synced we need to
subtract the number of the first register in the block from the max register
number and add one. This patch updates the code accordingly.

The issue was introduced in commit ac8d91c ("regmap: Supply ranges to the sync
operations").

Cc: stable@vger.kernel.org
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 0453196..a1f67eb 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -398,7 +398,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 			base = 0;
 
 		if (max < rbnode->base_reg + rbnode->blklen)
-			end = rbnode->base_reg + rbnode->blklen - max;
+			end = max - rbnode->base_reg + 1;
 		else
 			end = rbnode->blklen;
 
-- 
1.8.0

