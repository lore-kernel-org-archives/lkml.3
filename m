Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaKYLLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:11:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaKYKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 170/254] dm thin: grab a virtual cell before looking up the mapping
Date: Tue, 25 Nov 2014 10:38:40 +0000
Message-Id: <1416912004-5928-171-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit c822ed967cba38505713d59ed40a114386ef6c01 upstream.

Avoids normal IO racing with discard.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index fc9c848a60c9..df898e0db419 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1871,6 +1871,14 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
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
@@ -1894,13 +1902,10 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
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
@@ -1921,6 +1926,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * of doing so.
 			 */
 			handle_unserviceable_bio(tc->pool, bio);
+			cell_defer_no_holder_no_free(tc, &cell1);
 			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
@@ -1931,6 +1937,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * provide the hint to load the metadata into cache.
 		 */
 		thin_defer_bio(tc, bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 
 	default:
@@ -1940,6 +1947,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * pool is switched to fail-io mode.
 		 */
 		bio_io_error(bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 	}
 }
-- 
2.1.0

