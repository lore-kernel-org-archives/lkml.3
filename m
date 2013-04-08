Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab3DHJ73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:59:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43005 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935898Ab3DHJwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 084/102] regmap: cache Fix regcache-rbtree sync
Date: Mon,  8 Apr 2013 10:50:39 +0100
Message-Id: <1365414657-29191-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8abac3ba51b5525354e9b2ec0eed1c9e95c905d9 upstream.

The last register block, which falls into the specified range, is not handled
correctly. The formula which calculates the number of register which should be
synced is inverse (and off by one). E.g. if all registers in that block should
be synced only one is synced, and if only one should be synced all (but one) are
synced. To calculate the number of registers that need to be synced we need to
subtract the number of the first register in the block from the max register
number and add one. This patch updates the code accordingly.

The issue was introduced in commit ac8d91c ("regmap: Supply ranges to the sync
operations").

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/regmap/regcache-rbtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e6732cf..79f4fca 100644
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
1.8.1.2

