Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937591Ab3DJXD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:03:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab3DJWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:49:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 02/29] regmap: cache Fix regcache-rbtree sync
Date: Wed, 10 Apr 2013 15:49:20 -0700
Message-Id: <20130410224804.315980557@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regcache-rbtree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -392,7 +392,7 @@ static int regcache_rbtree_sync(struct r
 			base = 0;
 
 		if (max < rbnode->base_reg + rbnode->blklen)
-			end = rbnode->base_reg + rbnode->blklen - max;
+			end = max - rbnode->base_reg + 1;
 		else
 			end = rbnode->blklen;
 


