Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3ETKyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:54:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3ETKyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 111/115] dm thin: do not set discard_zeroes_data
Date: Mon, 20 May 2013 11:51:51 +0100
Message-Id: <1369047116-9378-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 307615a26e95406c42c95916a66ba50434567e0f upstream.

The dm thin pool target claims to support the zeroing of discarded
data areas.  This turns out to be incorrect when processing discards
that do not exactly cover a complete number of blocks, so the target
must always set discard_zeroes_data_unsupported.

The thin pool target will zero blocks when they are allocated if the
skip_block_zeroing feature is not specified.  The block layer
may send a discard that only partly covers a block.  If a thin pool
block is partially discarded then there is no guarantee that the
discarded data will get zeroed before it is accessed again.
Due to this, thin devices cannot claim discards will always zero data.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 5f52a9a..1307ba8 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2035,6 +2035,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		 * thin devices' discard limits consistent).
 		 */
 		ti->discards_supported = 1;
+		ti->discard_zeroes_data_unsupported = 1;
 	}
 	ti->private = pt;
 
@@ -2496,7 +2497,6 @@ static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
 	 * bios that overlap 2 blocks.
 	 */
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
 }
 
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
-- 
1.8.1.2

