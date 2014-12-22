Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaLVLus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:48 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46652 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaLVLuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:40 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH 16/17] fs: convert buffer head etc. to use immutable biovecs API.
Date: Mon, 22 Dec 2014 12:48:43 +0100
Message-Id: <4287748e7d1a0fce1c951567a7688821f1a21e5e.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a0e8166c0c5455755b0cd2d79e8066636c22aa77.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
 <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
 <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
 <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
 <e35d37b66d621c51f2eb24ff024291bd1d53422e.1419241597.git.dongsu.park@profitbricks.com>
 <a7118fb6a3353958a19f4d848472da2de76de238.1419241597.git.dongsu.park@profitbricks.com>
 <a0e8166c0c5455755b0cd2d79e8066636c22aa77.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Increase bio->bi_remaining instead of calling bio_get(),
and call bio_end() instead of bio_put() upon buffer_head submission.
Also make bio submission in kernel/power/block_io.c to properly submit
bios by checking whether bio_chain is available or not.

Doing that, some codes that have been still using the older API
can be converted in order to use the immutable biovecs API.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
---
 fs/buffer.c             |  4 ++--
 kernel/power/block_io.c | 23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 35ac0ec..78e63e3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3038,13 +3038,13 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	if (buffer_prio(bh))
 		rw |= REQ_PRIO;
 
-	bio_get(bio);
+	atomic_inc(&bio->bi_remaining);
 	submit_bio(rw, bio);
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
 
-	bio_put(bio);
+	bio_endio(bio, 0);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(_submit_bh);
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 9a58bc2..7206408 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -34,7 +34,6 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = bdev;
-	bio->bi_end_io = end_swap_bio_read;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
@@ -44,15 +43,29 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	}
 
 	lock_page(page);
-	bio_get(bio);
 
 	if (bio_chain == NULL) {
-		submit_bio(bio_rw, bio);
-		wait_on_page_locked(page);
+		int err = submit_bio_wait(bio_rw, bio);
+
+		if (err) {
+			SetPageError(page);
+			ClearPageUptodate(page);
+			pr_alert("Read-error on swap-device (%u:%u:%llu)\n",
+				 imajor(bio->bi_bdev->bd_inode),
+				 iminor(bio->bi_bdev->bd_inode),
+				 (unsigned long long)bio->bi_iter.bi_sector);
+		} else {
+			SetPageUptodate(page);
+		}
+
 		if (rw == READ)
-			bio_set_pages_dirty(bio);
+			set_page_dirty_lock(page);
+		unlock_page(page);
 		bio_put(bio);
 	} else {
+		bio->bi_end_io = end_swap_bio_read;
+		bio_get(bio);
+
 		if (rw == READ)
 			get_page(page);	/* These pages are freed later */
 		bio->bi_private = *bio_chain;
-- 
2.1.0

