Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3FICYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:24:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64266 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3FICT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:19:58 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Neil Brown <neilb@suse.de>
Subject: [PATCH 14/26] md, bcache: Remove bi_idx hacks
Date: Sat,  8 Jun 2013 19:18:56 -0700
Message-Id: <1370744348-15407-15-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
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

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/bcache/io.c | 46 ++--------------------------------------------
 drivers/md/md.c        | 22 ----------------------
 2 files changed, 2 insertions(+), 66 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index da198da..294b4c1 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -9,48 +9,6 @@
 #include "bset.h"
 #include "debug.h"
 
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
-		struct bio *clone = bio_alloc(GFP_NOIO, bio_segments(bio));
-
-		bio_for_each_segment(bv, bio, iter)
-			clone->bi_io_vec[clone->bi_vcnt++] = bv;
-
-		clone->bi_iter.bi_sector = bio->bi_iter.bi_sector;
-		clone->bi_bdev		= bio->bi_bdev;
-		clone->bi_rw		= bio->bi_rw;
-		clone->bi_vcnt		= bio_segments(bio);
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
@@ -225,12 +183,12 @@ void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
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
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1ed2426..20e0408 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -189,9 +189,6 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	 * the given offset and size.
 	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
 	 */
-	struct bio_vec bvec;
-	struct bvec_iter iter;
-	int sofar = 0;
 
 	size <<= 9;
 	if (offset == 0 && size == bio->bi_iter.bi_size)
@@ -202,25 +199,6 @@ void md_trim_bio(struct bio *bio, int offset, int size)
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
-	bio_for_each_segment(bvec, bio, iter) {
-		if (sofar + bvec.bv_len > size)
-			bvec.bv_len = size - sofar;
-		if (bvec.bv_len == 0) {
-			bio->bi_vcnt = iter.bi_idx;
-			break;
-		}
-		sofar += bvec.bv_len;
-	}
 }
 EXPORT_SYMBOL_GPL(md_trim_bio);
 
-- 
1.8.3.rc1

