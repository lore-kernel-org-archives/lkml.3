Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3DMNkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:40:13 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38135 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3DMNkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:40:10 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com
Cc: linux-mtd@lists.infradead.org, nbd-general@lists.sourceforge.net,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 7/8] dm thin: use generic helper to set max_discard_sectors
Date: Sat, 13 Apr 2013 22:39:59 +0900
Message-Id: <1365860399-21465-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

It is better to use blk_queue_max_discard_sectors helper
function to set max_discard_sectors as it checks
max_discard_sectors upper limit UINT_MAX >> 9

similar issue was reported for mmc in below link
https://lkml.org/lkml/2013/4/1/292

If multiple discard requests get merged, merged discard request's
size exceeds 4GB, there is possibility that merged discard request's
__data_len field may overflow.

This patch fixes this issue.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 drivers/md/dm-thin.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 905b75f..237295a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2513,7 +2513,8 @@ static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 	struct pool *pool = pt->pool;
 	struct queue_limits *data_limits;
 
-	limits->max_discard_sectors = pool->sectors_per_block;
+	blk_queue_max_discard_sectors(bdev_get_queue(pt->data_dev->bdev),
+					pool->sectors_per_block);
 
 	/*
 	 * discard_granularity is just a hint, and not enforced.
-- 
1.7.9.5

