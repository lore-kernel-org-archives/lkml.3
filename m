Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaLBTVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:21:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbaLBTVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 057/121] dm thin: grab a virtual cell before looking up the mapping
Date: Tue,  2 Dec 2014 11:18:56 -0800
Message-Id: <1417548000-1794-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit c822ed967cba38505713d59ed40a114386ef6c01 upstream.

Avoids normal IO racing with discard.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f8c36d3..0396d7f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1504,6 +1504,14 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
+	/*
+	 * We must hold the virtual cell before doing the lookup, otherwise
+	 * there's a race with discard.
+	 */
+	build_virtual_key(tc->td, block, &key);
+	if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1, &cell_result))
+		return DM_MAPIO_SUBMITTED;
+
 	r = dm_thin_find_block(td, block, 0, &result);
 
 	/*
@@ -1527,13 +1535,10 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * shared flag will be set in their case.
 			 */
 			thin_defer_bio(tc, bio);
+			cell_defer_no_holder_no_free(tc, &cell1);
 			return DM_MAPIO_SUBMITTED;
 		}
 
-		build_virtual_key(tc->td, block, &key);
-		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1, &cell_result))
-			return DM_MAPIO_SUBMITTED;
-
 		build_data_key(tc->td, result.block, &key);
 		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell2, &cell_result)) {
 			cell_defer_no_holder_no_free(tc, &cell1);
@@ -1554,6 +1559,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * of doing so.  Just error it.
 			 */
 			bio_io_error(bio);
+			cell_defer_no_holder_no_free(tc, &cell1);
 			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
@@ -1564,6 +1570,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * provide the hint to load the metadata into cache.
 		 */
 		thin_defer_bio(tc, bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 
 	default:
@@ -1573,6 +1580,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * pool is switched to fail-io mode.
 		 */
 		bio_io_error(bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 	}
 }
-- 
1.9.1

