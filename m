Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3K0Av3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:51:29 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61499 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3K0Ap5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:45:57 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Paul Clements <Paul.Clements@steeleye.com>, drbd-user@lists.linbit.com,
        nbd-general@lists.sourceforge.net
Subject: [PATCH 08/25] block: Immutable bio vecs
Date: Tue, 26 Nov 2013 16:45:11 -0800
Message-Id: <1385513128-5035-8-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a mechanism by which we can advance a bio by an arbitrary
number of bytes without modifying the biovec: bio->bi_iter.bi_bvec_done
indicates the number of bytes completed in the current bvec.

Various driver code still needs to be updated to not refer to the bvec
directly before we can use this for interesting things, like efficient
bio splitting.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: drbd-user@lists.linbit.com
Cc: nbd-general@lists.sourceforge.net
---
 Documentation/block/biovecs.txt | 111 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_main.c  |   4 +-
 drivers/block/nbd.c             |   2 +-
 fs/bio.c                        |  27 +---------
 include/linux/bio.h             |  81 ++++++++++++++++++++++++++---
 include/linux/blk_types.h       |   3 ++
 include/linux/blkdev.h          |   4 +-
 7 files changed, 194 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/block/biovecs.txt

diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
new file mode 100644
index 0000000..74a32ad
--- /dev/null
+++ b/Documentation/block/biovecs.txt
@@ -0,0 +1,111 @@
+
+Immutable biovecs and biovec iterators:
+=======================================
+
+Kent Overstreet <kmo@daterainc.com>
+
+As of 3.13, biovecs should never be modified after a bio has been submitted.
+Instead, we have a new struct bvec_iter which represents a range of a biovec -
+the iterator will be modified as the bio is completed, not the biovec.
+
+More specifically, old code that needed to partially complete a bio would
+update bi_sector and bi_size, and advance bi_idx to the next biovec. If it
+ended up partway through a biovec, it would increment bv_offset and decrement
+bv_len by the number of bytes completed in that biovec.
+
+In the new scheme of things, everything that must be mutated in order to
+partially complete a bio is segregated into struct bvec_iter: bi_sector,
+bi_size and bi_idx have been moved there; and instead of modifying bv_offset
+and bv_len, struct bvec_iter has bi_bvec_done, which represents the number of
+bytes completed in the current bvec.
+
+There are a bunch of new helper macros for hiding the gory details - in
+particular, presenting the illusion of partially completed biovecs so that
+normal code doesn't have to deal with bi_bvec_done.
+
+ * Driver code should no longer refer to biovecs directly; we now have
+   bio_iovec() and bio_iovec_iter() macros that return literal struct biovecs,
+   constructed from the raw biovecs but taking into account bi_bvec_done and
+   bi_size.
+
+   bio_for_each_segment() has been updated to take a bvec_iter argument
+   instead of an integer (that corresponded to bi_idx); for a lot of code the
+   conversion just required changing the types of the arguments to
+   bio_for_each_segment().
+
+ * Advancing a bvec_iter is done with bio_advance_iter(); bio_advance() is a
+   wrapper around bio_advance_iter() that operates on bio->bi_iter, and also
+   advances the bio integrity's iter if present.
+
+   There is a lower level advance function - bvec_iter_advance() - which takes
+   a pointer to a biovec, not a bio; this is used by the bio integrity code.
+
+What's all this get us?
+=======================
+
+Having a real iterator, and making biovecs immutable, has a number of
+advantages:
+
+ * Before, iterating over bios was very awkward when you weren't processing
+   exactly one bvec at a time - for example, bio_copy_data() in fs/bio.c,
+   which copies the contents of one bio into another. Because the biovecs
+   wouldn't necessarily be the same size, the old code was tricky convoluted -
+   it had to walk two different bios at the same time, keeping both bi_idx and
+   and offset into the current biovec for each.
+
+   The new code is much more straightforward - have a look. This sort of
+   pattern comes up in a lot of places; a lot of drivers were essentially open
+   coding bvec iterators before, and having common implementation considerably
+   simplifies a lot of code.
+
+ * Before, any code that might need to use the biovec after the bio had been
+   completed (perhaps to copy the data somewhere else, or perhaps to resubmit
+   it somewhere else if there was an error) had to save the entire bvec array
+   - again, this was being done in a fair number of places.
+
+ * Biovecs can be shared between multiple bios - a bvec iter can represent an
+   arbitrary range of an existing biovec, both starting and ending midway
+   through biovecs. This is what enables efficient splitting of arbitrary
+   bios. Note that this means we _only_ use bi_size to determine when we've
+   reached the end of a bio, not bi_vcnt - and the bio_iovec() macro takes
+   bi_size into account when constructing biovecs.
+
+ * Splitting bios is now much simpler. The old bio_split() didn't even work on
+   bios with more than a single bvec! Now, we can efficiently split arbitrary
+   size bios - because the new bio can share the old bio's biovec.
+
+   Care must be taken to ensure the biovec isn't freed while the split bio is
+   still using it, in case the original bio completes first, though. Using
+   bio_chain() when splitting bios helps with this.
+
+ * Submitting partially completed bios is now perfectly fine - this comes up
+   occasionally in stacking block drivers and various code (e.g. md and
+   bcache) had some ugly workarounds for this.
+
+   It used to be the case that submitting a partially completed bio would work
+   fine to _most_ devices, but since accessing the raw bvec array was the
+   norm, not all drivers would respect bi_idx and those would break. Now,
+   since all drivers _must_ go through the bvec iterator - and have been
+   audited to make sure they are - submitting partially completed bios is
+   perfectly fine.
+
+Other implications:
+===================
+
+ * Almost all usage of bi_idx is now incorrect and has been removed; instead,
+   where previously you would have used bi_idx you'd now use a bvec_iter,
+   probably passing it to one of the helper macros.
+
+   I.e. instead of using bio_iovec_idx() (or bio->bi_iovec[bio->bi_idx]), you
+   now use bio_iter_iovec(), which takes a bvec_iter and returns a
+   literal struct bio_vec - constructed on the fly from the raw biovec but
+   taking into account bi_bvec_done (and bi_size).
+
+ * bi_vcnt can't be trusted or relied upon by driver code - i.e. anything that
+   doesn't actually own the bio. The reason is twofold: firstly, it's not
+   actually needed for iterating over the bio anymore - we only use bi_size.
+   Secondly, when cloning a bio and reusing (a portion of) the original bio's
+   biovec, in order to calculate bi_vcnt for the new bio we'd have to iterate
+   over all the biovecs in the new bio - which is silly as it's not needed.
+
+   So, don't use bi_vcnt anymore.
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f4e5440..929468e 100644
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
index aa362f4..55298db 100644
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
index 8b7f14a..07b4b7a 100644
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
index c16adb5..04e592e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -64,11 +64,38 @@
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
 #define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
 
-#define bio_iter_iovec(bio, iter) ((bio)->bi_io_vec[(iter).bi_idx])
+#define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define bio_page(bio)		(bio_iovec((bio)).bv_page)
-#define bio_offset(bio)		(bio_iovec((bio)).bv_offset)
-#define bio_iovec(bio)		(*__bio_iovec(bio))
+#define bvec_iter_page(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+
+#define bvec_iter_len(bvec, iter)				\
+	min((iter).bi_size,					\
+	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
+
+#define bvec_iter_offset(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
+
+#define bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
+})
+
+#define bio_iter_iovec(bio, iter)				\
+	bvec_iter_bvec((bio)->bi_io_vec, (iter))
+
+#define bio_iter_page(bio, iter)				\
+	bvec_iter_page((bio)->bi_io_vec, (iter))
+#define bio_iter_len(bio, iter)					\
+	bvec_iter_len((bio)->bi_io_vec, (iter))
+#define bio_iter_offset(bio, iter)				\
+	bvec_iter_offset((bio)->bi_io_vec, (iter))
+
+#define bio_page(bio)		bio_iter_page((bio), (bio)->bi_iter)
+#define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
+#define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
 
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
@@ -145,16 +172,54 @@ static inline void *bio_data(struct bio *bio)
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
-	     bvl = bio_iter_iovec((bio), (iter)),			\
-	     (iter).bi_idx < (bio)->bi_vcnt;				\
-	     (iter).bi_idx++)
+	     (iter).bi_size &&						\
+		((bvl = bio_iter_iovec((bio), (iter))), 1);		\
+	     bio_advance_iter((bio), &(iter), (bvl).bv_len))
 
 #define bio_for_each_segment(bvl, bio, iter)				\
 	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
 
-#define bio_iter_last(bio, iter) ((iter).bi_idx == (bio)->bi_vcnt - 1)
+#define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 29b5b84..d369f8f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -34,6 +34,9 @@ struct bvec_iter {
 	unsigned int		bi_size;	/* residual I/O count */
 
 	unsigned int		bi_idx;		/* current index into bvl_vec */
+
+	unsigned int            bi_bvec_done;	/* number of bytes completed in
+						   current bvec */
 };
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 337b92a..02cb6f0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -750,9 +750,9 @@ struct req_iterator {
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
1.8.4.4

