Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761202AbaGRNPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:11 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17800 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965275AbaGRNPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/170] dm thin: update discard_granularity to reflect the thin-pool blocksize
Date: Fri, 18 Jul 2014 14:11:37 +0200
Message-Id: <6e9a6814089157ec4de1e99ce79eef7c7dd22d04.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 09869de57ed2728ae3c619803932a86cb0e2c4f8 upstream.

DM thinp already checks whether the discard_granularity of the data
device is a factor of the thin-pool block size.  But when using the
dm-thin-pool's discard passdown support, DM thinp was not selecting the
max of the underlying data device's discard_granularity and the
thin-pool's block size.

Update set_discard_limits() to set discard_granularity to the max of
these values.  This enables blkdev_issue_discard() to properly align the
discards that are sent to the DM thin device on a full block boundary.
As such each discard will now cover an entire DM thin-pool block and the
block will be reclaimed.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-thin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e4cc196634c1..f8c36d30eca8 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2695,7 +2695,8 @@ static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 	 */
 	if (pt->adjusted_pf.discard_passdown) {
 		data_limits = &bdev_get_queue(pt->data_dev->bdev)->limits;
-		limits->discard_granularity = data_limits->discard_granularity;
+		limits->discard_granularity = max(data_limits->discard_granularity,
+						  pool->sectors_per_block << SECTOR_SHIFT);
 	} else
 		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 }
-- 
2.0.0

