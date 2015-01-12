Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbbALLuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:50:55 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:57886 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbbALLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:50:47 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 8/9] fs: use helper bio_add_page() instead of open coding on bi_io_vec
Date: Mon, 12 Jan 2015 12:49:47 +0100
Message-Id: <3fc2ee4eedd3bc6ef515b14108942425afb733d3.1421052746.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b574939e25f9be0aacc631045bb507dcecab5f39.1421052746.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
 <4e7cfbce77dcf72474e1b930ef017c9efaea36d7.1421052746.git.dongsu.park@profitbricks.com>
 <ed9c9f3b8190cd64cddbe58a753c811aee69471f.1421052746.git.dongsu.park@profitbricks.com>
 <641ab3a0eeb225316784b8a22a285eab911d48fd.1421052746.git.dongsu.park@profitbricks.com>
 <ca2dd738a2c26bba51acedae96ddb6cb65658268.1421052746.git.dongsu.park@profitbricks.com>
 <c98bf7a8cccb8a831566a72f87e8be9511d70e41.1421052746.git.dongsu.park@profitbricks.com>
 <5cfac9da1b2724050502c3fa6a00af25bae2e0a7.1421052746.git.dongsu.park@profitbricks.com>
 <b574939e25f9be0aacc631045bb507dcecab5f39.1421052746.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Call pre-defined helper bio_add_page() instead of open coding for
iterating through bi_io_vec[]. Doing that, it's possible to make some
parts in filesystems and mm/page_io.c simpler than before.

Acked-by: Dave Kleikamp <shaggy@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 fs/buffer.c         |  7 ++-----
 fs/jfs/jfs_logmgr.c | 14 ++++----------
 mm/page_io.c        |  8 +++-----
 3 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index dbe5699..78e63e3 100644
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

