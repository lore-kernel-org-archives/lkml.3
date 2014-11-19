Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaKSVJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:09:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600AbaKSVEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 044/122] dm thin: grab a virtual cell before looking up the mapping
Date: Wed, 19 Nov 2014 12:51:34 -0800
Message-Id: <20141119205210.280603868@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit c822ed967cba38505713d59ed40a114386ef6c01 upstream.

Avoids normal IO racing with discard.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1704,6 +1704,14 @@ static int thin_bio_map(struct dm_target
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
@@ -1727,13 +1735,10 @@ static int thin_bio_map(struct dm_target
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
@@ -1754,6 +1759,7 @@ static int thin_bio_map(struct dm_target
 			 * of doing so.
 			 */
 			handle_unserviceable_bio(tc->pool, bio);
+			cell_defer_no_holder_no_free(tc, &cell1);
 			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
@@ -1764,6 +1770,7 @@ static int thin_bio_map(struct dm_target
 		 * provide the hint to load the metadata into cache.
 		 */
 		thin_defer_bio(tc, bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 
 	default:
@@ -1773,6 +1780,7 @@ static int thin_bio_map(struct dm_target
 		 * pool is switched to fail-io mode.
 		 */
 		bio_io_error(bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 	}
 }


