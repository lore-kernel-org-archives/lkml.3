Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaAJBIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:08:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaAJBIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:08:18 -0500
Date: Fri, 10 Jan 2014 02:08:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Stephen Hemminger <shemminger@vyatta.com>
cc: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] floppy: bail out in open() if drive is not responding
 to block0 read
Message-ID: <alpine.LNX.2.00.1401100206190.31628@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case reading of block 0 during open() fails, it is not the right thing 
to let open() succeed.

Fix this by introducing FD_OPEN_SHOULD_FAIL_BIT flag, and setting it in 
case the bio callback encounters an error while trying to read block 0.

As a bonus, this works around certain broken userspace (blkid), which is 
not able to properly handle read()s returning IO errors. Hence be nice to 
those, and bail out during open() already; if block 0 is not readable, 
read()s are not going to provide any meaningful data anyway.

NOT-YET-Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/floppy.c  |   36 +++++++++++++++++++++++++++---------
 include/uapi/linux/fd.h |    3 ++-
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 04ceb7e..690011d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3691,9 +3691,12 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	if (!(mode & FMODE_NDELAY)) {
 		if (mode & (FMODE_READ|FMODE_WRITE)) {
 			UDRS->last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
 			check_disk_change(bdev);
 			if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
 				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
+				goto out;
 		}
 		res = -EROFS;
 		if ((mode & FMODE_WRITE) &&
@@ -3746,17 +3749,29 @@ static unsigned int floppy_check_events(struct gendisk *disk,
  * a disk in the drive, and whether that disk is writable.
  */
 
-static void floppy_rb0_complete(struct bio *bio, int err)
+struct rb0_cbdata {
+	int drive;
+	struct completion complete;
+};
+
+static void floppy_rb0_cb(struct bio *bio, int err)
 {
-	complete((struct completion *)bio->bi_private);
+	struct rb0_cbdata *cbdata = (struct rb0_cbdata *)bio->bi_private;
+	int drive = cbdata->drive;
+
+	if (err) {
+		pr_info("floppy: error %d while reading block 0", err);
+		set_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
+	}
+	complete(&cbdata->complete);
 }
 
-static int __floppy_read_block_0(struct block_device *bdev)
+static int __floppy_read_block_0(struct block_device *bdev, int drive)
 {
 	struct bio bio;
 	struct bio_vec bio_vec;
-	struct completion complete;
 	struct page *page;
+	struct rb0_cbdata cbdata;
 	size_t size;
 
 	page = alloc_page(GFP_NOIO);
@@ -3769,6 +3784,8 @@ static int __floppy_read_block_0(struct block_device *bdev)
 	if (!size)
 		size = 1024;
 
+	cbdata.drive = drive;
+
 	bio_init(&bio);
 	bio.bi_io_vec = &bio_vec;
 	bio_vec.bv_page = page;
@@ -3779,13 +3796,14 @@ static int __floppy_read_block_0(struct block_device *bdev)
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
 	bio.bi_flags = (1 << BIO_QUIET);
-	init_completion(&complete);
-	bio.bi_private = &complete;
-	bio.bi_end_io = floppy_rb0_complete;
+	bio.bi_private = &cbdata;
+	bio.bi_end_io = floppy_rb0_cb;
 
 	submit_bio(READ, &bio);
 	process_fd_request();
-	wait_for_completion(&complete);
+
+	init_completion(&cbdata.complete);
+	wait_for_completion(&cbdata.complete);
 
 	__free_page(page);
 
@@ -3827,7 +3845,7 @@ static int floppy_revalidate(struct gendisk *disk)
 			UDRS->generation++;
 		if (drive_no_geom(drive)) {
 			/* auto-sensing */
-			res = __floppy_read_block_0(opened_bdev[drive]);
+			res = __floppy_read_block_0(opened_bdev[drive], drive);
 		} else {
 			if (cf)
 				poll_drive(false, FD_RAW_NEED_DISK);
diff --git a/include/uapi/linux/fd.h b/include/uapi/linux/fd.h
index f1f3dd5..84c517c 100644
--- a/include/uapi/linux/fd.h
+++ b/include/uapi/linux/fd.h
@@ -185,7 +185,8 @@ enum {
 				 * to clear media change status */
 	FD_UNUSED_BIT,
 	FD_DISK_CHANGED_BIT,	/* disk has been changed since last i/o */
-	FD_DISK_WRITABLE_BIT	/* disk is writable */
+	FD_DISK_WRITABLE_BIT,	/* disk is writable */
+	FD_OPEN_SHOULD_FAIL_BIT
 };
 
 #define FDSETDRVPRM _IOW(2, 0x90, struct floppy_drive_params)

-- 
Jiri Kosina
SUSE Labs
