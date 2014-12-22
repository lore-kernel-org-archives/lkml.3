Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaLVLuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38611 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaLVLuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:39 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Kleikamp <shaggy@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 15/17] fs: use helper bio_add_page() instead of open coding on bi_io_vec
Date: Mon, 22 Dec 2014 12:48:42 +0100
Message-Id: <a0e8166c0c5455755b0cd2d79e8066636c22aa77.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a7118fb6a3353958a19f4d848472da2de76de238.1419241597.git.dongsu.park@profitbricks.com>
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
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Call pre-defined helper bio_add_page() instead of open coding for
iterating through bi_io_vec[]. Doing that, it's possible to make some
parts in filesystems and mm/page_io.c simpler than before.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/buffer.c         |  7 ++-----
 fs/jfs/jfs_logmgr.c | 14 ++++----------
 mm/page_io.c        |  8 +++-----
 3 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 20805db..35ac0ec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3022,12 +3022,9 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
-	bio->bi_io_vec[0].bv_page = bh->b_page;
-	bio->bi_io_vec[0].bv_len = bh->b_size;
-	bio->bi_io_vec[0].bv_offset = bh_offset(bh);
 
-	bio->bi_vcnt = 1;
-	bio->bi_iter.bi_size = bh->b_size;
+	bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
+	BUG_ON(bio->bi_iter.bi_size != bh->b_size);
 
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index bc462dc..46fae06 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1999,12 +1999,9 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
-	bio->bi_io_vec[0].bv_page = bp->l_page;
-	bio->bi_io_vec[0].bv_len = LOGPSIZE;
-	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
-	bio->bi_vcnt = 1;
-	bio->bi_iter.bi_size = LOGPSIZE;
+	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
+	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
@@ -2145,12 +2142,9 @@ static void lbmStartIO(struct lbuf * bp)
 	bio = bio_alloc(GFP_NOFS, 1);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
-	bio->bi_io_vec[0].bv_page = bp->l_page;
-	bio->bi_io_vec[0].bv_len = LOGPSIZE;
-	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
-	bio->bi_vcnt = 1;
-	bio->bi_iter.bi_size = LOGPSIZE;
+	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
+	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
diff --git a/mm/page_io.c b/mm/page_io.c
index 955db8b..8c878c7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -33,12 +33,10 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 	if (bio) {
 		bio->bi_iter.bi_sector = map_swap_page(page, &bio->bi_bdev);
 		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
-		bio->bi_io_vec[0].bv_page = page;
-		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
-		bio->bi_io_vec[0].bv_offset = 0;
-		bio->bi_vcnt = 1;
-		bio->bi_iter.bi_size = PAGE_SIZE;
 		bio->bi_end_io = end_io;
+
+		bio_add_page(bio, page, PAGE_SIZE, 0);
+		BUG_ON(bio->bi_iter.bi_size != PAGE_SIZE);
 	}
 	return bio;
 }
-- 
2.1.0

