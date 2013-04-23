Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3DWVw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:52:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab3DWVwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Lawrence <joe.lawrence@stratus.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 13/42] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Tue, 23 Apr 2013 14:52:11 -0700
Message-Id: <20130423215206.900995460@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <Joe.Lawrence@stratus.com>

commit c8dc9c654794a765ca61baed07f84ed8aaa7ca8c upstream.

Set mddev queue's max_write_same_sectors to its chunk_sector value (before
disk_stack_limits merges the underlying disk limits.)  With that in place,
be sure to handle writes coming down from the block layer that have the
REQ_WRITE_SAME flag set.  That flag needs to be copied into any newly cloned
write bio.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |    7 ++++++-
 drivers/md/raid10.c |    9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1001,6 +1001,7 @@ static void make_request(struct mddev *m
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1302,7 +1303,8 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
+		mbio->bi_rw =
+			WRITE | do_flush_fua | do_sync | do_discard | do_same;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -2819,6 +2821,9 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
+	if (mddev->queue)
+		blk_queue_max_write_same_sectors(mddev->queue,
+						 mddev->chunk_sectors);
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1106,6 +1106,7 @@ static void make_request(struct mddev *m
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
@@ -1461,7 +1462,8 @@ retry_write:
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1503,7 +1505,8 @@ retry_write:
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -3570,6 +3573,8 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue,
+						 mddev->chunk_sectors);
 		blk_queue_io_min(mddev->queue, chunk_size);
 		if (conf->geo.raid_disks % conf->geo.near_copies)
 			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);


