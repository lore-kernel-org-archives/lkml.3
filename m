Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbbALLor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:44:47 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:53392 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbALLoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:44:44 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-pm@vger.kernel.org,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 7/7] PM: submit bio in a sane way in cases without bio_chain
Date: Mon, 12 Jan 2015 12:44:04 +0100
Message-Id: <be07c413948b5504b78bbfc1e20395905525efd0.1421052656.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <962e0fd9683e2d523cadf8036769dfbaf3b21e77.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <19cceed4e701430bfb307301a38cdf8d40fbfcac.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
 <0117035a25929ae97e2039edc895f582d53cf217.1421052656.git.dongsu.park@profitbricks.com>
 <63ea4e86f2a06cbe273692932bdf2499fef01644.1421052656.git.dongsu.park@profitbricks.com>
 <9ef99a9bae03003ae7b2fff1bf942e63aff6e45a.1421052656.git.dongsu.park@profitbricks.com>
 <962e0fd9683e2d523cadf8036769dfbaf3b21e77.1421052656.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Make bio submission in kernel/power/block_io.c to properly submit
bios also when bio_chain is not available. In that case, it's not
necessary to handle refcount with bio_get(), but it's saner to simply
call a predefined helper submit_bio_wait(). So call bio_get() only
when bio_chain is given.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 kernel/power/block_io.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

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

