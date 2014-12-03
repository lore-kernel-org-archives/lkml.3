Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaLCL7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:59:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaLCL1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/101] dm thin: grab a virtual cell before looking up the mapping
Date: Wed,  3 Dec 2014 12:26:01 +0100
Message-Id: <2c49ae544b24a61a8de26c7bf0bce13151d54abf.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c822ed967cba38505713d59ed40a114386ef6c01 upstream.

Avoids normal IO racing with discard.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-thin.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f8c36d30eca8..0396d7fc1d8b 100644
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
2.1.3

