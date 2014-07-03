Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbaGCInz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:55 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45905 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaGCIna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:30 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 21/23] drbd: drop spurious parameters from _drbd_md_sync_page_io
Date: Thu,  3 Jul 2014 10:43:13 +0200
Message-Id: <1404376995-4877-22-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

size is always 4096,
page is always device->md_io.page.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index e9fbcaf..d26a3fa 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -137,10 +137,11 @@ void wait_until_done_or_force_detached(struct drbd_device *device, struct drbd_b
 
 static int _drbd_md_sync_page_io(struct drbd_device *device,
 				 struct drbd_backing_dev *bdev,
-				 struct page *page, sector_t sector,
-				 int rw, int size)
+				 sector_t sector, int rw)
 {
 	struct bio *bio;
+	/* we do all our meta data IO in aligned 4k blocks. */
+	const int size = 4096;
 	int err;
 
 	device->md_io.done = 0;
@@ -154,7 +155,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	bio->bi_bdev = bdev->md_bdev;
 	bio->bi_iter.bi_sector = sector;
 	err = -EIO;
-	if (bio_add_page(bio, page, size, 0) != size)
+	if (bio_add_page(bio, device->md_io.page, size, 0) != size)
 		goto out;
 	bio->bi_private = device;
 	bio->bi_end_io = drbd_md_io_complete;
@@ -190,8 +191,6 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 			 sector_t sector, int rw)
 {
 	int err;
-	struct page *iop = device->md_io.page;
-
 	D_ASSERT(device, atomic_read(&device->md_io.in_use) == 1);
 
 	BUG_ON(!bdev->md_bdev);
@@ -207,8 +206,7 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 		     current->comm, current->pid, __func__,
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
-	/* we do all our meta data IO in aligned 4k blocks. */
-	err = _drbd_md_sync_page_io(device, bdev, iop, sector, rw, 4096);
+	err = _drbd_md_sync_page_io(device, bdev, sector, rw);
 	if (err) {
 		drbd_err(device, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ", err);
-- 
1.9.1

