Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaBKBqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:46:01 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37998 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaBKBp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:45:58 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: clm@fb.com, rjones@redhat.com, linux-fsdevel@vger.kernel.org,
        neilb@suse.de, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] block: Fix cloning of discard/write same bios
Date: Mon, 10 Feb 2014 17:45:50 -0800
Message-Id: <1392083150-11670-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Immutable biovecs changed the way bio segments are treated in such a way that
bio_for_each_segment() cannot now do what we want for discard/write same bios,
since bi_size means something completely different for them.

Fortunately discard and write same bios never have more than a single biovec, so
bio_for_each_segment() is unnecessary and not terribly meaningful for them, but
we still have to special case them in a few places.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 fs/bio.c            | 15 ++++++++++-----
 include/linux/bio.h | 11 +++++++++++
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 75c49a3822..8754e7b6eb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -611,7 +611,6 @@ EXPORT_SYMBOL(bio_clone_fast);
 struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 			     struct bio_set *bs)
 {
-	unsigned nr_iovecs = 0;
 	struct bvec_iter iter;
 	struct bio_vec bv;
 	struct bio *bio;
@@ -638,10 +637,7 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	 *    __bio_clone_fast() anyways.
 	 */
 
-	bio_for_each_segment(bv, bio_src, iter)
-		nr_iovecs++;
-
-	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, bs);
+	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
 	if (!bio)
 		return NULL;
 
@@ -650,9 +646,18 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
+	if (bio->bi_rw & REQ_DISCARD)
+		goto integrity_clone;
+
+	if (bio->bi_rw & REQ_WRITE_SAME) {
+		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
+		goto integrity_clone;
+	}
+
 	bio_for_each_segment(bv, bio_src, iter)
 		bio->bi_io_vec[bio->bi_vcnt++] = bv;
 
+integrity_clone:
 	if (bio_integrity(bio_src)) {
 		int ret;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 70654521da..05d2a0392f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -250,6 +250,17 @@ static inline unsigned bio_segments(struct bio *bio)
 	struct bio_vec bv;
 	struct bvec_iter iter;
 
+	/*
+	 * We special case discard/write same, because they interpret bi_size
+	 * differently:
+	 */
+
+	if (bio->bi_rw & REQ_DISCARD)
+		return 1;
+
+	if (bio->bi_rw & REQ_WRITE_SAME)
+		return 1;
+
 	bio_for_each_segment(bv, bio, iter)
 		segs++;
 
-- 
1.8.5.3

