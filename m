Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaGaQH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:07:27 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:65367 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGaQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:07:24 -0400
From: Greg Thelen <gthelen@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Dave Chinner <dchinner@redhat.com>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] dm bufio: fully initialize shrinker
Date: Thu, 31 Jul 2014 09:07:19 -0700
Message-Id: <1406822839-2423-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1d3d4437eae1 ("vmscan: per-node deferred work") added a flags field to
struct shrinker assuming that all shrinkers were zero filled.  The dm
bufio shrinker is not zero filled, which leaves arbitrary kmalloc() data
in flags.  So far the only defined flags bit is SHRINKER_NUMA_AWARE.
But there are proposed patches which add other bits to shrinker.flags
(e.g. memcg awareness).

Rather than simply initializing the shrinker, this patch uses kzalloc()
when allocating the dm_bufio_client to ensure that the embedded shrinker
and any other similar structures are zeroed.

This fixes theoretical over aggressive shrinking of dm bufio objects.
If the uninitialized dm_bufio_client.shrinker.flags contains
SHRINKER_NUMA_AWARE then shrink_slab() would call the dm shrinker for
each numa node rather than just once.  This has been broken since 3.12.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/md/dm-bufio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 4e84095833db..d724459860d9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1541,7 +1541,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	BUG_ON(block_size < 1 << SECTOR_SHIFT ||
 	       (block_size & (block_size - 1)));
 
-	c = kmalloc(sizeof(*c), GFP_KERNEL);
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;
-- 
2.0.0.526.g5318336

