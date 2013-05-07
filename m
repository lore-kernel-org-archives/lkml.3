Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3EGEOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:14:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3EGD6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:44 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=q4cHZ6xZGTQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=X_sTwmZMbToA:10 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=ZumbMyprnxVMVET0g50A:9 a=8NEP1B8RWw4A:10 a=jeBq3FmKZ4MA:10 a=vMjfzvC7s4arH_Ot:21 a=wpk9WSxQ3rY2pccQ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035841.591165246@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [004/126] regmap: cache Fix regcache-rbtree sync
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0004-regmap-cache-Fix-regcache-rbtree-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 8abac3ba51b5525354e9b2ec0eed1c9e95c905d9 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/base/regmap/regcache-rbtree.c |    2 +-
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
1.7.10.4


