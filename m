Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3K0Aql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:46:41 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56735 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3K0AqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:46:11 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Yehuda Sadeh <yehuda@inktank.com>, Alex Elder <elder@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 18/25] rbd: Refactor bio cloning
Date: Tue, 26 Nov 2013 16:45:21 -0800
Message-Id: <1385513128-5035-18-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got drivers converted to the new immutable bvec
primitives, bio splitting becomes much easier - this is how the new
bio_split() will work. (Someone more familiar with the ceph code could
probably use bio_clone_fast() instead of bio_clone() here).

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Yehuda Sadeh <yehuda@inktank.com>
Cc: Alex Elder <elder@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 drivers/block/rbd.c | 64 ++---------------------------------------------------
 1 file changed, 2 insertions(+), 62 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 20e8ab3..3624368 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1173,73 +1173,13 @@ static struct bio *bio_clone_range(struct bio *bio_src,
 					unsigned int len,
 					gfp_t gfpmask)
 {
-	struct bio_vec bv;
-	struct bvec_iter iter;
-	struct bvec_iter end_iter;
-	unsigned int resid;
-	unsigned int voff;
-	unsigned short vcnt;
 	struct bio *bio;
 
-	/* Handle the easy case for the caller */
-
-	if (!offset && len == bio_src->bi_iter.bi_size)
-		return bio_clone(bio_src, gfpmask);
-
-	if (WARN_ON_ONCE(!len))
-		return NULL;
-	if (WARN_ON_ONCE(len > bio_src->bi_iter.bi_size))
-		return NULL;
-	if (WARN_ON_ONCE(offset > bio_src->bi_iter.bi_size - len))
-		return NULL;
-
-	/* Find first affected segment... */
-
-	resid = offset;
-	bio_for_each_segment(bv, bio_src, iter) {
-		if (resid < bv.bv_len)
-			break;
-		resid -= bv.bv_len;
-	}
-	voff = resid;
-
-	/* ...and the last affected segment */
-
-	resid += len;
-	__bio_for_each_segment(bv, bio_src, end_iter, iter) {
-		if (resid <= bv.bv_len)
-			break;
-		resid -= bv.bv_len;
-	}
-	vcnt = end_iter.bi_idx = iter.bi_idx + 1;
-
-	/* Build the clone */
-
-	bio = bio_alloc(gfpmask, (unsigned int) vcnt);
+	bio = bio_clone(bio_src, gfpmask);
 	if (!bio)
 		return NULL;	/* ENOMEM */
 
-	bio->bi_bdev = bio_src->bi_bdev;
-	bio->bi_iter.bi_sector = bio_src->bi_iter.bi_sector +
-		(offset >> SECTOR_SHIFT);
-	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_flags |= 1 << BIO_CLONED;
-
-	/*
-	 * Copy over our part of the bio_vec, then update the first
-	 * and last (or only) entries.
-	 */
-	memcpy(&bio->bi_io_vec[0], &bio_src->bi_io_vec[iter.bi_idx],
-			vcnt * sizeof (struct bio_vec));
-	bio->bi_io_vec[0].bv_offset += voff;
-	if (vcnt > 1) {
-		bio->bi_io_vec[0].bv_len -= voff;
-		bio->bi_io_vec[vcnt - 1].bv_len = resid;
-	} else {
-		bio->bi_io_vec[0].bv_len = len;
-	}
-
-	bio->bi_vcnt = vcnt;
+	bio_advance(bio, offset);
 	bio->bi_iter.bi_size = len;
 
 	return bio;
-- 
1.8.4.4

