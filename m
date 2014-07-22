Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaGVWvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:51:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbaGVWWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 079/116] dm thin: update discard_granularity to reflect the thin-pool blocksize
Date: Tue, 22 Jul 2014 15:21:30 -0700
Message-Id: <1406067727-19683-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ca954b1..3d183ca 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2479,7 +2479,8 @@ static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 	 */
 	if (pt->adjusted_pf.discard_passdown) {
 		data_limits = &bdev_get_queue(pt->data_dev->bdev)->limits;
-		limits->discard_granularity = data_limits->discard_granularity;
+		limits->discard_granularity = max(data_limits->discard_granularity,
+						  pool->sectors_per_block << SECTOR_SHIFT);
 	} else if (block_size_is_power_of_two(pool))
 		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 	else
-- 
1.9.1

