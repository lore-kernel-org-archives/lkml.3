Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab3HGVzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:55:36 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39705 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab3HGVzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:23 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 14/22] block: Kill bio_iovec_idx(), __bio_iovec()
Date: Wed,  7 Aug 2013 14:54:23 -0700
Message-Id: <1375912471-5106-15-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_iovec_idx() and __bio_iovec() don't have any valid uses anymore -
previous users have been converted to bio_iovec_iter() or other methods.

__BVEC_END() has to go too - the bvec array can't be used directly for
the last biovec because we might only be using the first portion of it,
we have to iterate over the bvec array with bio_for_each_segment() which
checks against the current value of bi_iter.bi_size.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-merge.c   | 13 +++++++++++--
 include/linux/bio.h | 26 ++++++++------------------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8940562..b53ddac 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -88,6 +88,9 @@ EXPORT_SYMBOL(blk_recount_segments);
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
 {
+	struct bio_vec end_bv, nxt_bv;
+	struct bvec_iter iter;
+
 	if (!blk_queue_cluster(q))
 		return 0;
 
@@ -98,14 +101,20 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 	if (!bio_has_data(bio))
 		return 1;
 
-	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)))
+	bio_for_each_segment(end_bv, bio, iter)
+		if (end_bv.bv_len == iter.bi_size)
+			break;
+
+	nxt_bv = bio_iovec(nxt);
+
+	if (!BIOVEC_PHYS_MERGEABLE(&end_bv, &nxt_bv))
 		return 0;
 
 	/*
 	 * bio and nxt are contiguous in memory; check if the queue allows
 	 * these two to be merged into one
 	 */
-	if (BIO_SEG_BOUNDARY(q, bio, nxt))
+	if (BIOVEC_SEG_BOUNDARY(q, &end_bv, &nxt_bv))
 		return 1;
 
 	return 0;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9736683..486a997 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -61,9 +61,6 @@
  * various member access, note that bio_data should of course not be used
  * on highmem page vectors
  */
-#define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
-#define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
 #define bvec_iter_page(bvec, iter)				\
@@ -143,19 +140,16 @@ static inline void *bio_data(struct bio *bio)
  * permanent PIO fall back, user is probably better off disabling highmem
  * I/O completely on that queue (see ide-dma for example)
  */
-#define __bio_kmap_atomic(bio, idx)				\
-	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page) +	\
-		bio_iovec_idx((bio), (idx))->bv_offset)
+#define __bio_kmap_atomic(bio, iter)				\
+	(kmap_atomic(bio_iter_iovec((bio), (iter)).bv_page) +	\
+		bio_iter_iovec((bio), (iter)).bv_offset)
 
-#define __bio_kunmap_atomic(addr) kunmap_atomic(addr)
+#define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
 
 /*
  * merge helpers etc
  */
 
-#define __BVEC_END(bio)		bio_iovec_idx((bio), (bio)->bi_vcnt - 1)
-#define __BVEC_START(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-
 /* Default implementation of BIOVEC_PHYS_MERGEABLE */
 #define __BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
@@ -172,8 +166,6 @@ static inline void *bio_data(struct bio *bio)
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
 	__BIO_SEG_BOUNDARY(bvec_to_phys((b1)), bvec_to_phys((b2)) + (b2)->bv_len, queue_segment_boundary((q)))
-#define BIO_SEG_BOUNDARY(q, b1, b2) \
-	BIOVEC_SEG_BOUNDARY((q), __BVEC_END((b1)), __BVEC_START((b2)))
 
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
@@ -182,9 +174,7 @@ static inline void *bio_data(struct bio *bio)
  * before it got to the driver and the driver won't own all of it
  */
 #define bio_for_each_segment_all(bvl, bio, i)				\
-	for (i = 0;							\
-	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
-	     i++)
+	for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
 
 static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
 				     unsigned bytes)
@@ -449,15 +439,15 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 }
 #endif
 
-static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
+static inline char *__bio_kmap_irq(struct bio *bio, struct bvec_iter iter,
 				   unsigned long *flags)
 {
-	return bvec_kmap_irq(bio_iovec_idx(bio, idx), flags);
+	return bvec_kmap_irq(&bio_iter_iovec(bio, iter), flags);
 }
 #define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
 
 #define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), (bio)->bi_iter.bi_idx, (flags))
+	__bio_kmap_irq((bio), (bio)->bi_iter, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
 static inline bool bio_is_rw(struct bio *bio)
-- 
1.8.4.rc1

