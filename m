Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030469AbaGCJtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:49:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030207AbaGCJXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 125/198] dm thin: update discard_granularity to reflect the thin-pool blocksize
Date: Thu,  3 Jul 2014 10:19:28 +0100
Message-Id: <1404379241-8590-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 316f8a9af93b..7dab6e605c88 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2675,7 +2675,8 @@ static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
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
1.9.1

