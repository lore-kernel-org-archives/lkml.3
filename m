Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3FIC0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:26:11 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44055 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3FICTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:19:50 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Paul Clements <Paul.Clements@steeleye.com>, drbd-user@lists.linbit.com,
        nbd-general@lists.sourceforge.net
Subject: [PATCH 07/26] block: Immutable bio vecs
Date: Sat,  8 Jun 2013 19:18:49 -0700
Message-Id: <1370744348-15407-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a mechanism by which we can advance a bio by an arbitrary
number of bytes without modifying the biovec: bio->bi_iter.bi_bvec_done
indicates the number of bytes completed in the current bvec.

Various driver code still needs to be updated to not refer to the bvec
directly before we can use this for interesting things, like efficient
bio splitting.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: drbd-user@lists.linbit.com
Cc: nbd-general@lists.sourceforge.net
---
 drivers/block/drbd/drbd_main.c |   4 +-
 drivers/block/nbd.c            |   2 +-
 fs/bio.c                       |  27 +----------
 include/linux/bio.h            | 108 ++++++++++++++++++++++++++++++++---------
 include/linux/blk_types.h      |   2 +
 include/linux/blkdev.h         |   4 +-
 6 files changed, 95 insertions(+), 52 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 30b0f91..7309d81 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1546,7 +1546,7 @@ static int _drbd_send_bio(struct drbd_conf *mdev, struct bio *bio)
 
 		err = _drbd_no_send_page(mdev, bvec.bv_page,
 					 bvec.bv_offset, bvec.bv_len,
-					 bio_iter_last(bio, iter)
+					 bio_iter_last(bvec, iter)
 					 ? 0 : MSG_MORE);
 		if (err)
 			return err;
@@ -1565,7 +1565,7 @@ static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
 
 		err = _drbd_send_page(mdev, bvec.bv_page,
 				      bvec.bv_offset, bvec.bv_len,
-				      bio_iter_last(bio, iter) ? 0 : MSG_MORE);
+				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
 			return err;
 	}
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b446f50..3b7e5ca 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -278,7 +278,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 		 */
 		rq_for_each_segment(bvec, req, iter) {
 			flags = 0;
-			if (!rq_iter_last(req, iter))
+			if (!rq_iter_last(bvec, iter))
 				flags = MSG_MORE;
 			dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
 					nbd->disk->disk_name, req, bvec.bv_len);
diff --git a/fs/bio.c b/fs/bio.c
index 018e3a8..92a92bc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -532,13 +532,11 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	 * most users will be overriding ->bi_bdev with a new target,
 	 * so we don't set nor calculate new physical/hw segment counts here
 	 */
-	bio->bi_iter.bi_sector = bio_src->bi_iter.bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
-	bio->bi_iter.bi_size = bio_src->bi_iter.bi_size;
-	bio->bi_iter.bi_idx = bio_src->bi_iter.bi_idx;
+	bio->bi_iter = bio_src->bi_iter;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -808,28 +806,7 @@ void bio_advance(struct bio *bio, unsigned bytes)
 	if (bio_integrity(bio))
 		bio_integrity_advance(bio, bytes);
 
-	bio->bi_iter.bi_sector += bytes >> 9;
-	bio->bi_iter.bi_size -= bytes;
-
-	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
-		return;
-
-	while (bytes) {
-		if (unlikely(bio->bi_iter.bi_idx >= bio->bi_vcnt)) {
-			WARN_ONCE(1, "bio idx %d >= vcnt %d\n",
-				  bio->bi_iter.bi_idx, bio->bi_vcnt);
-			break;
-		}
-
-		if (bytes >= bio_iovec(bio).bv_len) {
-			bytes -= bio_iovec(bio).bv_len;
-			bio->bi_iter.bi_idx++;
-		} else {
-			bio_iovec(bio).bv_len -= bytes;
-			bio_iovec(bio).bv_offset += bytes;
-			bytes = 0;
-		}
-	}
+	bio_advance_iter(bio, &bio->bi_iter, bytes);
 }
 EXPORT_SYMBOL(bio_advance);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index a31bcd2..3c194bc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -61,21 +61,58 @@
  * various member access, note that bio_data should of course not be used
  * on highmem page vectors
  */
-#define bio_iovec_iter(bio, iter) ((bio)->bi_io_vec[(iter).bi_idx])
-
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
 #define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-#define bio_iovec(bio)		(*__bio_iovec(bio))
 
-#define bio_page(bio)		(bio_iovec((bio)).bv_page)
-#define bio_offset(bio)		(bio_iovec((bio)).bv_offset)
+#define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
+
+#define bvec_iter_page(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+#define bvec_iter_len(bio, iter)				\
+	min((iter).bi_size,					\
+	    __bvec_iter_bvec((bio), (iter))->bv_len - (iter).bi_bvec_done)
+#define bvec_iter_offset(bio, iter)				\
+	(__bvec_iter_bvec((bio), (iter))->bv_offset + (iter).bi_bvec_done)
+
+#define bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
+})
+
+
+#define bio_iovec_iter(bio, iter)				\
+	bvec_iter_bvec((bio)->bi_io_vec, (iter))
+#define bio_page_iter(bio, iter)				\
+	bvec_iter_page((bio)->bi_io_vec, (iter))
+#define bio_offset_iter(bio, iter)				\
+	bvec_iter_offset((bio)->bi_io_vec, (iter))
+
+#define bio_page(bio)		bio_page_iter((bio), (bio)->bi_iter)
+#define bio_offset(bio)		bio_offset_iter((bio), (bio)->bi_iter)
+#define bio_iovec(bio)		bio_iovec_iter((bio), (bio)->bi_iter)
+
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
 #define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
 
+/*
+ * Check whether this bio carries any data or not. A NULL bio is allowed.
+ */
+static inline bool bio_has_data(struct bio *bio)
+{
+	if (bio &&
+	    bio->bi_iter.bi_size &&
+	    !(bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK))
+		return true;
+
+	return false;
+}
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
-	if (bio->bi_vcnt)
+	if (bio_has_data(bio))
 		return bio_iovec(bio).bv_len;
 	else /* dataless requests such as discard */
 		return bio->bi_iter.bi_size;
@@ -83,7 +120,7 @@ static inline unsigned int bio_cur_bytes(struct bio *bio)
 
 static inline void *bio_data(struct bio *bio)
 {
-	if (bio->bi_vcnt)
+	if (bio_has_data(bio))
 		return page_address(bio_page(bio)) + bio_offset(bio);
 
 	return NULL;
@@ -144,16 +181,54 @@ static inline void *bio_data(struct bio *bio)
 	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
 	     i++)
 
+static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
+				     unsigned bytes)
+{
+	WARN_ONCE(bytes > iter->bi_size,
+		  "Attempted to advance past end of bvec iter\n");
+
+	while (bytes) {
+		unsigned len = min(bytes, bvec_iter_len(bv, *iter));
+
+		bytes -= len;
+		iter->bi_size -= len;
+		iter->bi_bvec_done += len;
+
+		if (iter->bi_bvec_done == __bvec_iter_bvec(bv, *iter)->bv_len) {
+			iter->bi_bvec_done = 0;
+			iter->bi_idx++;
+		}
+	}
+}
+
+#define for_each_bvec(bvl, bio_vec, iter, start)			\
+	for ((iter) = start;						\
+	     (bvl) = bvec_iter_bvec((bio_vec), (iter)),			\
+		(iter).bi_size;						\
+	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
+
+
+static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
+				    unsigned bytes)
+{
+	iter->bi_sector += bytes >> 9;
+
+	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+		iter->bi_size -= bytes;
+	else
+		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
+}
+
 #define __bio_for_each_segment(bvl, bio, iter, start)			\
 	for (iter = (start);						\
-	     bvl = bio_iovec_iter((bio), (iter)),			\
-	     (iter).bi_idx < (bio)->bi_vcnt;				\
-	     (iter).bi_idx++)
+	     (iter).bi_size &&						\
+		((bvl = bio_iovec_iter((bio), (iter))), 1);		\
+	     bio_advance_iter((bio), &(iter), (bvl).bv_len))
 
 #define bio_for_each_segment(bvl, bio, iter)				\
 	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
 
-#define bio_iter_last(bio, iter) ((iter).bi_idx == (bio)->bi_vcnt - 1)
+#define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
@@ -368,17 +443,6 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 	__bio_kmap_irq((bio), (bio)->bi_iter.bi_idx, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
-/*
- * Check whether this bio carries any data or not. A NULL bio is allowed.
- */
-static inline bool bio_has_data(struct bio *bio)
-{
-	if (bio && bio->bi_vcnt)
-		return true;
-
-	return false;
-}
-
 static inline bool bio_is_rw(struct bio *bio)
 {
 	if (!bio_has_data(bio))
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d46e8a6..72f1274 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -34,6 +34,8 @@ struct bvec_iter {
 	unsigned int		bi_size;	/* residual I/O count */
 
 	unsigned int		bi_idx;		/* current index into bvl_vec */
+
+	unsigned int            bi_bvec_done;
 };
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b9d47b..2a16de2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -714,9 +714,9 @@ struct req_iterator {
 	__rq_for_each_bio(_iter.bio, _rq)			\
 		bio_for_each_segment(bvl, _iter.bio, _iter.iter)
 
-#define rq_iter_last(rq, _iter)					\
+#define rq_iter_last(bvec, _iter)				\
 		(_iter.bio->bi_next == NULL &&			\
-		 bio_iter_last(_iter.bio, _iter.iter))
+		 bio_iter_last(bvec, _iter.iter))
 
 #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
 # error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
-- 
1.8.3.rc1

