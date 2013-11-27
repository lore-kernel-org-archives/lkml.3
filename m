Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3K0At1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:49:27 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34488 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3K0AqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:46:08 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/25] block: Refactor bio_clone_bioset() for immutable biovecs
Date: Tue, 26 Nov 2013 16:45:19 -0800
Message-Id: <1385513128-5035-16-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_clone() needs to produce a bio that's suitable for the caller to
munge with the biovec. Part of the immutable biovec patch series is
fixing stuff up so that submitting partially completed bios is safe and
works: thus, we now need bio_clone() on a partially completed bio to
produce a bio for which bi_idx and bi_bvec done are 0 - like they would
be if the caller had just allocated a new bio.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 13 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a082ce2..1628917 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -549,36 +549,70 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 EXPORT_SYMBOL(__bio_clone);
 
 /**
- *	bio_clone_bioset -	clone a bio
- *	@bio: bio to clone
+ * 	bio_clone_bioset - clone a bio
+ * 	@bio_src: bio to clone
  *	@gfp_mask: allocation priority
  *	@bs: bio_set to allocate from
  *
- * 	Like __bio_clone, only also allocates the returned bio
+ *	Clone bio. Caller will own the returned bio, but not the actual data it
+ *	points to. Reference count of returned bio will be one.
  */
-struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
+struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 			     struct bio_set *bs)
 {
-	struct bio *b;
+	unsigned nr_iovecs = 0;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	struct bio *bio;
+
+	/*
+	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
+	 * bio_src->bi_io_vec to bio->bi_io_vec.
+	 *
+	 * We can't do that anymore, because:
+	 *
+	 *  - The point of cloning the biovec is to produce a bio with a biovec
+	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
+	 *
+	 *  - The original bio could've had more than BIO_MAX_PAGES biovecs; if
+	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
+	 *    But the clone should succeed as long as the number of biovecs we
+	 *    actually need to allocate is fewer than BIO_MAX_PAGES.
+	 *
+	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
+	 *    that does not own the bio - reason being drivers don't use it for
+	 *    iterating over the biovec anymore, so expecting it to be kept up
+	 *    to date (i.e. for clones that share the parent biovec) is just
+	 *    asking for trouble and would force extra work on
+	 *    __bio_clone_fast() anyways.
+	 */
+
+	bio_for_each_segment(bv, bio_src, iter)
+		nr_iovecs++;
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
-	if (!b)
+	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, bs);
+	if (!bio)
 		return NULL;
 
-	__bio_clone(b, bio);
+	bio->bi_bdev		= bio_src->bi_bdev;
+	bio->bi_rw		= bio_src->bi_rw;
+	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
+	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
-	if (bio_integrity(bio)) {
-		int ret;
+	bio_for_each_segment(bv, bio_src, iter)
+		bio->bi_io_vec[bio->bi_vcnt++] = bv;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask);
+	if (bio_integrity(bio_src)) {
+		int ret;
 
+		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
 		if (ret < 0) {
-			bio_put(b);
+			bio_put(bio);
 			return NULL;
 		}
 	}
 
-	return b;
+	return bio;
 }
 EXPORT_SYMBOL(bio_clone_bioset);
 
-- 
1.8.4.4

