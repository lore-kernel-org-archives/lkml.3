Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab3HGV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:58:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50675 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741Ab3HGVz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:27 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 17/22] block: Remove bi_idx hacks
Date: Wed,  7 Aug 2013 14:54:26 -0700
Message-Id: <1375912471-5106-18-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that drivers have been converted to the new bvec_iter primitives,
there's no need to trim the bvec before we submit it; and we can't trim
it once we start sharing bvecs.

It used to be that passing a partially completed bio (i.e. one with
nonzero bi_idx) to generic_make_request() was a dangerous thing -
various drivers would choke on such things. But with immutable biovecs
and our new bio splitting that shares the biovecs, submitting partially
completed bios has to work (and should work, now that all the drivers
have been completed to the new primitives)

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/bcache/io.c | 47 ++---------------------------------------------
 fs/bio.c               | 23 -----------------------
 2 files changed, 2 insertions(+), 68 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 6e04f3b..0f0ab65 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -11,49 +11,6 @@
 
 #include <linux/blkdev.h>
 
-static void bch_bi_idx_hack_endio(struct bio *bio, int error)
-{
-	struct bio *p = bio->bi_private;
-
-	bio_endio(p, error);
-	bio_put(bio);
-}
-
-static void bch_generic_make_request_hack(struct bio *bio)
-{
-	if (bio->bi_iter.bi_idx) {
-		struct bio_vec bv;
-		struct bvec_iter iter;
-		unsigned segs = bio_segments(bio);
-		struct bio *clone = bio_alloc(GFP_NOIO, segs);
-
-		bio_for_each_segment(bv, bio, iter)
-			clone->bi_io_vec[clone->bi_vcnt++] = bv;
-
-		clone->bi_iter.bi_sector = bio->bi_iter.bi_sector;
-		clone->bi_bdev		= bio->bi_bdev;
-		clone->bi_rw		= bio->bi_rw;
-		clone->bi_vcnt		= segs;
-		clone->bi_iter.bi_size	= bio->bi_iter.bi_size;
-
-		clone->bi_private	= bio;
-		clone->bi_end_io	= bch_bi_idx_hack_endio;
-
-		bio = clone;
-	}
-
-	/*
-	 * Hack, since drivers that clone bios clone up to bi_max_vecs, but our
-	 * bios might have had more than that (before we split them per device
-	 * limitations).
-	 *
-	 * To be taken out once immutable bvec stuff is in.
-	 */
-	bio->bi_max_vecs = bio->bi_vcnt;
-
-	generic_make_request(bio);
-}
-
 /**
  * bch_bio_split - split a bio
  * @bio:	bio to split
@@ -222,12 +179,12 @@ void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
 		n->bi_private	= &s->cl;
 
 		closure_get(&s->cl);
-		bch_generic_make_request_hack(n);
+		generic_make_request(n);
 	} while (n != bio);
 
 	continue_at(&s->cl, bch_bio_submit_split_done, NULL);
 submit:
-	bch_generic_make_request_hack(bio);
+	generic_make_request(bio);
 }
 
 /* Bios with headers */
diff --git a/fs/bio.c b/fs/bio.c
index bb62198..7d14b79 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1772,11 +1772,7 @@ void bio_trim(struct bio *bio, int offset, int size)
 {
 	/* 'bio' is a cloned bio which we need to trim to match
 	 * the given offset and size.
-	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
 	 */
-	int i;
-	struct bio_vec *bvec;
-	int sofar = 0;
 
 	size <<= 9;
 	if (offset == 0 && size == bio->bi_iter.bi_size)
@@ -1787,25 +1783,6 @@ void bio_trim(struct bio *bio, int offset, int size)
 	bio_advance(bio, offset << 9);
 
 	bio->bi_iter.bi_size = size;
-
-	/* avoid any complications with bi_idx being non-zero*/
-	if (bio->bi_iter.bi_idx) {
-		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_iter.bi_idx,
-			(bio->bi_vcnt - bio->bi_iter.bi_idx) *
-			sizeof(struct bio_vec));
-		bio->bi_vcnt -= bio->bi_iter.bi_idx;
-		bio->bi_iter.bi_idx = 0;
-	}
-	/* Make sure vcnt and last bv are not too big */
-	bio_for_each_segment_all(bvec, bio, i) {
-		if (sofar + bvec->bv_len > size)
-			bvec->bv_len = size - sofar;
-		if (bvec->bv_len == 0) {
-			bio->bi_vcnt = i;
-			break;
-		}
-		sofar += bvec->bv_len;
-	}
 }
 EXPORT_SYMBOL_GPL(bio_trim);
 
-- 
1.8.4.rc1

