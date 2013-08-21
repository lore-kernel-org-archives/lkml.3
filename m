Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3HUPhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:37:19 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:20235 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3HUPhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:37:17 -0400
From: David Jander <david@protonic.nl>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH V2] drivers: regmap: regcache-rbtree.c: Fix overlapping rbnodes.
Date: Wed, 21 Aug 2013 17:37:22 +0200
Message-Id: <1377099442-13884-1-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid overlapping register regions by making the initial blklen of a new
node 1. If a register write occurs to a yet uncached register, that is
lower than but near an existing node's base_reg, a new node is created
and it's blklen is set to an arbitrary value (sizeof(*rbnode)). That may
cause this node to overlap with another node. Those nodes should be merged,
but this merge doesn't happen yet, so this patch at least makes the initial
blklen small enough to avoid hitting the wrong node, which may otherwise
lead to severe breakage.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/base/regmap/regcache-rbtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 5c1435c..0fccc99 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -332,7 +332,7 @@ regcache_rbtree_node_alloc(struct regmap *map, unsigned int reg)
 	}
 
 	if (!rbnode->blklen) {
-		rbnode->blklen = sizeof(*rbnode);
+		rbnode->blklen = 1;
 		rbnode->base_reg = reg;
 	}
 
-- 
1.8.1.2

