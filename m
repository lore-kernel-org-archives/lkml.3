Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaHEOjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:39:00 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39721 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaHEOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:38:56 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] vfs: make guard_bh_eod() more generic
Date: Tue,  5 Aug 2014 23:38:32 +0900
Message-Id: <1407249514-20465-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
References: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

guard_bh_eod() is used in submit_bh() to allow us to do IO even on the
odd last sectors of a device, even if the block size is some multiple
of the physical sector size.  This makes guard_bh_eod() more generic
and renames it guard_bio_eod() so that we can use it without struct
buffer_head argument.

The reason for this change is that using mpage_readpages() for block
device requires to add this guard check in mpage code.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/buffer.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8f05111..f891c90 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2954,7 +2954,7 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 
 /*
  * This allows us to do IO even on the odd last sectors
- * of a device, even if the bh block size is some multiple
+ * of a device, even if the block size is some multiple
  * of the physical sector size.
  *
  * We'll just truncate the bio to the size of the device,
@@ -2964,10 +2964,11 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
  * errors, this only handles the "we need to be able to
  * do IO at the final sector" case.
  */
-static void guard_bh_eod(int rw, struct bio *bio, struct buffer_head *bh)
+static void guard_bio_eod(int rw, struct bio *bio)
 {
 	sector_t maxsector;
-	unsigned bytes;
+	struct bio_vec *bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
+	unsigned truncated_bytes;
 
 	maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;
 	if (!maxsector)
@@ -2982,23 +2983,20 @@ static void guard_bh_eod(int rw, struct bio *bio, struct buffer_head *bh)
 		return;
 
 	maxsector -= bio->bi_iter.bi_sector;
-	bytes = bio->bi_iter.bi_size;
-	if (likely((bytes >> 9) <= maxsector))
+	if (likely((bio->bi_iter.bi_size >> 9) <= maxsector))
 		return;
 
-	/* Uhhuh. We've got a bh that straddles the device size! */
-	bytes = maxsector << 9;
+	/* Uhhuh. We've got a bio that straddles the device size! */
+	truncated_bytes = bio->bi_iter.bi_size - (maxsector << 9);
 
 	/* Truncate the bio.. */
-	bio->bi_iter.bi_size = bytes;
-	bio->bi_io_vec[0].bv_len = bytes;
+	bio->bi_iter.bi_size -= truncated_bytes;
+	bvec->bv_len -= truncated_bytes;
 
 	/* ..and clear the end of the buffer for reads */
 	if ((rw & RW_MASK) == READ) {
-		void *kaddr = kmap_atomic(bh->b_page);
-		memset(kaddr + bh_offset(bh) + bytes, 0, bh->b_size - bytes);
-		kunmap_atomic(kaddr);
-		flush_dcache_page(bh->b_page);
+		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
+				truncated_bytes);
 	}
 }
 
@@ -3039,7 +3037,7 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
-	guard_bh_eod(rw, bio, bh);
+	guard_bio_eod(rw, bio);
 
 	if (buffer_meta(bh))
 		rw |= REQ_META;
-- 
1.9.1

