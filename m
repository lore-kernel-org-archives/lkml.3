Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3IEUgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:36:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3IEU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Jander <david@protonic.nl>, Mark Brown <broonie@linaro.org>,
        Zhouping Liu <zliu@redhat.com>
Subject: [ 36/36] regmap: rbtree: Fix overlapping rbnodes.
Date: Thu,  5 Sep 2013 13:28:05 -0700
Message-Id: <20130905202706.478614170@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit 4e67fb5f5e336250db944921e3c68057d6203034 upstream.

Avoid overlapping register regions by making the initial blklen of a new
node 1. If a register write occurs to a yet uncached register, that is
lower than but near an existing node's base_reg, a new node is created
and it's blklen is set to an arbitrary value (sizeof(*rbnode)). That may
cause this node to overlap with another node. Those nodes should be merged,
but this merge doesn't happen yet, so this patch at least makes the initial
blklen small enough to avoid hitting the wrong node, which may otherwise
lead to severe breakage.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regcache-rbtree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -362,7 +362,7 @@ static int regcache_rbtree_write(struct
 		rbnode = kzalloc(sizeof *rbnode, GFP_KERNEL);
 		if (!rbnode)
 			return -ENOMEM;
-		rbnode->blklen = sizeof(*rbnode);
+		rbnode->blklen = 1;
 		rbnode->base_reg = reg;
 		rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
 					GFP_KERNEL);


