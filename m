Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab3HGVzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:55:39 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43299 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab3HGVzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:24 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Alex Elder <elder@inktank.com>, ceph-devel@vger.kernel.org
Subject: [PATCH 15/22] rbd: Refactor bio cloning, don't clone biovecs
Date: Wed,  7 Aug 2013 14:54:24 -0700
Message-Id: <1375912471-5106-16-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got drivers converted to the new immutable bvec
primitives, bio splitting becomes much easier. In a few patches,
bio_clone() will be changed to share the old bio's bvec instead of
copying it, and bio_split() will do exactly what's being done here.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Yehuda Sadeh <yehuda@inktank.com>
Cc: Alex Elder <elder@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 drivers/block/rbd.c | 64 ++---------------------------------------------------
 1 file changed, 2 insertions(+), 62 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f99f347..efb082c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1167,73 +1167,13 @@ static struct bio *bio_clone_range(struct bio *bio_src,
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
1.8.4.rc1

