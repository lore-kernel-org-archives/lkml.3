Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaGAQSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:18:09 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53112 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbaGAQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/20] drbd: drop drbd_md_flush
Date: Tue,  1 Jul 2014 18:16:48 +0200
Message-Id: <1404231410-29852-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The only user of drbd_md_flush was bm_rw(),
and it is always followed by either a drbd_md_sync(),
or an al_write_transaction(), which, if so configured,
both end up submiting a FLUSH|FUA request anyways.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |  4 +---
 drivers/block/drbd/drbd_int.h    | 19 -------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 7e6f924..7303433 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1153,9 +1153,7 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 		err = -EIO; /* Disk timeout/force-detach during IO... */
 
 	now = jiffies;
-	if (rw == WRITE) {
-		drbd_md_flush(device);
-	} else /* rw == READ */ {
+	if (rw == READ) {
 		b->bm_set = bm_count_bits(b);
 		drbd_info(device, "recounting of set bits took additional %lu jiffies\n",
 		     jiffies - now);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a71f8bb..d85f43c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2182,25 +2182,6 @@ static inline int drbd_queue_order_type(struct drbd_device *device)
 	return QUEUE_ORDERED_NONE;
 }
 
-static inline void drbd_md_flush(struct drbd_device *device)
-{
-	int r;
-
-	if (device->ldev == NULL) {
-		drbd_warn(device, "device->ldev == NULL in drbd_md_flush\n");
-		return;
-	}
-
-	if (test_bit(MD_NO_FUA, &device->flags))
-		return;
-
-	r = blkdev_issue_flush(device->ldev->md_bdev, GFP_NOIO, NULL);
-	if (r) {
-		set_bit(MD_NO_FUA, &device->flags);
-		drbd_err(device, "meta data flush failed with status %d, disabling md-flushes\n", r);
-	}
-}
-
 static inline struct drbd_connection *first_connection(struct drbd_resource *resource)
 {
 	return list_first_entry_or_null(&resource->connections,
-- 
1.9.1

