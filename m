Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaDRJtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45892 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 13/72] floppy: bail out in open() if drive is not responding to block0 read
Date: Fri, 18 Apr 2014 11:21:46 +0200
Message-Id: <e6732e00c9ffc318d21fca56e747f59f85d078a1.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7b7b68bba5ef23734c35ffb0d8d82079ed604d33 upstream.

In case reading of block 0 during open() fails, it is not the right thing
to let open() succeed.

Fix this by introducing FD_OPEN_SHOULD_FAIL_BIT flag, and setting it in
case the bio callback encounters an error while trying to read block 0.

As a bonus, this works around certain broken userspace (blkid), which is
not able to properly handle read()s returning IO errors. Hence be nice to
those, and bail out during open() already; if block 0 is not readable,
read()s are not going to provide any meaningful data anyway.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/floppy.c  | 36 +++++++++++++++++++++++++++---------
 include/uapi/linux/fd.h |  3 ++-
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 04ceb7e2fadd..690011de912a 100644
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
index f1f3dd5981b2..84c517cbce90 100644
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
1.9.2

