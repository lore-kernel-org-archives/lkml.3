Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaDALSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaDALSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/144] dm cache: fix access beyond end of origin device
Date: Tue,  1 Apr 2014 12:14:57 +0100
Message-Id: <1396350948-29910-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

commit e893fba90c09f9b57fb97daae204ea9cc2c52fa5 upstream.

In order to avoid wasting cache space a partial block at the end of the
origin device is not cached.  Unfortunately, the check for such a
partial block at the end of the origin device was flawed.

Fix accesses beyond the end of the origin device that occured due to
attempted promotion of an undetected partial block by:

- initializing the per bio data struct to allow cache_end_io to work properly
- recognizing access to the partial block at the end of the origin device
- avoiding out of bounds access to the discard bitset

Otherwise, users can experience errors like the following:

 attempt to access beyond end of device
 dm-5: rw=0, want=20971520, limit=20971456
 ...
 device-mapper: cache: promotion failed; couldn't copy block

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-target.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e36beca..a2d7e04 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2179,20 +2179,18 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 	bool discarded_block;
 	struct dm_bio_prison_cell *cell;
 	struct policy_result lookup_result;
-	struct per_bio_data *pb;
+	struct per_bio_data *pb = init_per_bio_data(bio, pb_data_size);
 
-	if (from_oblock(block) > from_oblock(cache->origin_blocks)) {
+	if (unlikely(from_oblock(block) >= from_oblock(cache->origin_blocks))) {
 		/*
 		 * This can only occur if the io goes to a partial block at
 		 * the end of the origin device.  We don't cache these.
 		 * Just remap to the origin and carry on.
 		 */
-		remap_to_origin_clear_discard(cache, bio, block);
+		remap_to_origin(cache, bio);
 		return DM_MAPIO_REMAPPED;
 	}
 
-	pb = init_per_bio_data(bio, pb_data_size);
-
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
 		defer_bio(cache, bio);
 		return DM_MAPIO_SUBMITTED;
-- 
1.9.1

