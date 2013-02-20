Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935083Ab3BTAXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:23:46 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63909 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934948Ab3BTAXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:20 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk
Subject: [PATCH 26/27] block: Add an explicit bio flag for bios that own their bvec
Date: Tue, 19 Feb 2013 16:22:40 -0800
Message-Id: <1361319761-23873-27-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for the new bio splitting code. When we split a bio, if the
split occured on a bvec boundry we reuse the bvec for the new bio. But
that means bio_free() can't free it, hence the explicit flag.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c                  | 4 +++-
 include/linux/bio.h       | 5 -----
 include/linux/blk_types.h | 1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e545a44..9238a54 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -252,7 +252,7 @@ static void bio_free(struct bio *bio)
 	__bio_free(bio);
 
 	if (bs) {
-		if (bio_has_allocated_vec(bio))
+		if (bio_flagged(bio, BIO_OWNS_VEC))
 			bvec_free(bs->bvec_pool, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 		/*
@@ -451,6 +451,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 		if (unlikely(!bvl))
 			goto err_free;
+
+		bio->bi_flags |= 1 << BIO_OWNS_VEC;
 	} else if (nr_iovecs) {
 		bvl = bio->bi_inline_vecs;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e25378f..794bcd0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -85,11 +85,6 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
-static inline int bio_has_allocated_vec(struct bio *bio)
-{
-	return bio->bi_io_vec && bio->bi_io_vec != bio->bi_inline_vecs;
-}
-
 /*
  * will die
  */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c178d25..538289f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -117,6 +117,7 @@ struct bio {
  * BIO_POOL_IDX()
  */
 #define BIO_RESET_BITS	12
+#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
-- 
1.7.12

