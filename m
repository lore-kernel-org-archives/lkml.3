Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3IYUZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:25:39 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48737 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab3IYUWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:22:53 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 1/6] block: Introduce bio_for_each_page()
Date: Wed, 25 Sep 2013 13:22:39 -0700
Message-Id: <1380140564-9030-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prep work for multipage bvecs: various code will still need to iterate
over individual pages, so we add primitives to do so

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/scsi/sd_dif.c |  4 +--
 fs/bio.c              | 20 +++++++-----
 fs/mpage.c            |  8 ++---
 include/linux/bio.h   | 85 ++++++++++++++++++++++++++++++++++-----------------
 4 files changed, 76 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index a7a691d..ea92592 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -385,7 +385,7 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 
 		virt = bio->bi_integrity->bip_iter.bi_sector & 0xffffffff;
 
-		bip_for_each_vec(iv, bio->bi_integrity, iter) {
+		bip_for_each_page(iv, bio->bi_integrity, iter) {
 			sdt = kmap_atomic(iv.bv_page)
 				+ iv.bv_offset;
 
@@ -436,7 +436,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 
 		virt = bio->bi_integrity->bip_iter.bi_sector & 0xffffffff;
 
-		bip_for_each_vec(iv, bio->bi_integrity, iter) {
+		bip_for_each_page(iv, bio->bi_integrity, iter) {
 			sdt = kmap_atomic(iv.bv_page)
 				+ iv.bv_offset;
 
diff --git a/fs/bio.c b/fs/bio.c
index e9d1c05..da8aa81 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -496,16 +496,22 @@ EXPORT_SYMBOL(bio_alloc_bioset);
 
 void zero_fill_bio(struct bio *bio)
 {
-	unsigned long flags;
 	struct bio_vec bv;
 	struct bvec_iter iter;
 
-	bio_for_each_segment(bv, bio, iter) {
+#if defined(CONFIG_HIGHMEM) || defined(ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+	bio_for_each_page(bv, bio, iter) {
+		unsigned long flags;
 		char *data = bvec_kmap_irq(&bv, &flags);
 		memset(data, 0, bv.bv_len);
 		flush_dcache_page(bv.bv_page);
 		bvec_kunmap_irq(data, &flags);
 	}
+#else
+	bio_for_each_segment(bv, bio, iter)
+		memset(page_address(bv.bv_page) + bv.bv_offset,
+		       0, bv.bv_len);
+#endif
 }
 EXPORT_SYMBOL(zero_fill_bio);
 
@@ -1474,11 +1480,11 @@ EXPORT_SYMBOL(bio_copy_kern);
  */
 void bio_set_pages_dirty(struct bio *bio)
 {
-	struct bio_vec *bvec;
-	int i;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+	bio_for_each_page_all(bvec, bio, iter) {
+		struct page *page = bvec.bv_page;
 
 		if (page && !PageCompound(page))
 			set_page_dirty_lock(page);
@@ -1574,7 +1580,7 @@ void bio_flush_dcache_pages(struct bio *bi)
 	struct bio_vec *bvec;
 	struct bvec_iter iter;
 
-	bio_for_each_segment(bvec, bi, iter)
+	bio_for_each_page(bvec, bi, iter)
 		flush_dcache_page(bvec->bv_page);
 }
 EXPORT_SYMBOL(bio_flush_dcache_pages);
diff --git a/fs/mpage.c b/fs/mpage.c
index 8e0a471..7507811 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -43,11 +43,11 @@
  */
 static void mpage_end_io(struct bio *bio, int err)
 {
-	struct bio_vec *bv;
-	int i;
+	struct bio_vec bv;
+	struct bvec_iter iter;
 
-	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
+	bio_for_each_page_all(bv, bio, iter) {
+		struct page *page = bv.bv_page;
 
 		if (bio_data_dir(bio) == READ) {
 			if (!err) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 231ae67..f6f0e99 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -63,16 +63,24 @@
  */
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define bvec_iter_page(bvec, iter)				\
-	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+#define bvec_iter_page(bvec, iter)					\
+	nth_page(__bvec_iter_bvec((bvec), (iter))->bv_page,		\
+		 __bvec_iter_offset((bvec), (iter)) >> PAGE_SHIFT)
 
-#define bvec_iter_len(bvec, iter)				\
-	min((iter).bi_size,					\
+#define bvec_iter_page_bytes(bvec, iter)				\
+	min_t(unsigned, bvec_iter_len((bvec), (iter)),			\
+	      PAGE_SIZE - bvec_iter_offset((bvec), (iter)))
+
+#define bvec_iter_len(bvec, iter)					\
+	min((iter).bi_size,						\
 	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
 
-#define bvec_iter_offset(bvec, iter)				\
+#define __bvec_iter_offset(bvec, iter)					\
 	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
 
+#define bvec_iter_offset(bvec, iter)					\
+	(__bvec_iter_offset((bvec), (iter)) & (PAGE_SIZE - 1))
+
 #define bvec_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {						\
 	.bv_page	= bvec_iter_page((bvec), (iter)),	\
@@ -85,6 +93,8 @@
 
 #define bio_iter_page(bio, iter)				\
 	bvec_iter_page((bio)->bi_io_vec, (iter))
+#define bio_iter_page_bytes(bio, iter)				\
+	bvec_iter_page_bytes((bio)->bi_io_vec, (iter))
 #define bio_iter_len(bio, iter)					\
 	bvec_iter_len((bio)->bi_io_vec, (iter))
 #define bio_iter_offset(bio, iter)				\
@@ -188,13 +198,6 @@ static inline void *bio_data(struct bio *bio)
 
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
-/*
- * drivers should _never_ use the all version - the bio may have been split
- * before it got to the driver and the driver won't own all of it
- */
-#define bio_for_each_segment_all(bvl, bio, i)				\
-	for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
-
 static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
 				     unsigned bytes)
 {
@@ -215,13 +218,6 @@ static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
 	}
 }
 
-#define for_each_bvec(bvl, bio_vec, iter, start)			\
-	for ((iter) = start;						\
-	     (bvl) = bvec_iter_bvec((bio_vec), (iter)),			\
-		(iter).bi_size;						\
-	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
-
-
 static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 				    unsigned bytes)
 {
@@ -233,15 +229,42 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 }
 
-#define __bio_for_each_segment(bvl, bio, iter, start)			\
+#define BVEC_ITER_ALL_INITIALIZER (struct bvec_iter)			\
+{									\
+	.bi_sector	= 0,						\
+	.bi_size	= UINT_MAX,					\
+	.bi_idx		= 0,						\
+	.bi_bvec_done	= 0,						\
+}
+
+#define __bio_for_each(bvl, bio, iter, start, condition, advance)	\
 	for (iter = (start);						\
-	     (iter).bi_size &&						\
-		((bvl = bio_iter_iovec((bio), (iter))), 1);		\
-	     bio_advance_iter((bio), &(iter), (bvl).bv_len))
+	     (condition) &&						\
+		((bvl) = bio_iter_iovec((bio), (iter)), 1);		\
+	     bio_advance_iter((bio), &(iter), advance((bio), (iter))))
+
+#define __bio_for_each_segment(bvl, bio, iter, start)			\
+	__bio_for_each((bvl), (bio), (iter), (start),			\
+		       (iter).bi_size, bio_iter_len)
 
 #define bio_for_each_segment(bvl, bio, iter)				\
 	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
 
+#define bio_for_each_page(bvl, bio, iter)				\
+	__bio_for_each((bvl), (bio), (iter), (bio)->bi_iter,		\
+		       (iter).bi_size, bio_iter_page_bytes)
+
+/*
+ * drivers should _never_ use the all version - the bio may have been split
+ * before it got to the driver and the driver won't own all of it
+ */
+#define bio_for_each_segment_all(bvl, bio, i)				\
+	for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
+
+#define bio_for_each_page_all(bvl, bio, iter)				\
+	__bio_for_each((bvl), (bio), (iter), BVEC_ITER_ALL_INITIALIZER,	\
+		       (iter).bi_idx < (bio)->bi_vcnt, bio_iter_page_bytes)
+
 #define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
 /*
@@ -616,16 +639,22 @@ struct biovec_slab {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
+#define __bip_for_each(bvl, bip, iter, advance)				\
+	for ((iter) = (bip)->bip_iter;					\
+	     (iter).bi_size &&						\
+		((bvl) = bvec_iter_bvec((bip)->bip_vec, (iter)), 1);	\
+	     bvec_iter_advance((bip)->bip_vec, &(iter),			\
+			       advance((bip)->bip_vec, (iter))))
 
+#define bip_for_each_segment(bvl, bip, iter)				\
+	__bip_for_each(bvl, bip, iter, bvec_iter_len)
 
-#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
-
-#define bip_for_each_vec(bvl, bip, iter)				\
-	for_each_bvec(bvl, (bip)->bip_vec, iter, (bip)->bip_iter)
+#define bip_for_each_page(bvl, bip, iter)				\
+	__bip_for_each(bvl, bip, iter, bvec_iter_page_bytes)
 
 #define bio_for_each_integrity_vec(_bvl, _bio, _iter)			\
 	for_each_bio(_bio)						\
-		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
+		bip_for_each_segment(_bvl, _bio->bi_integrity, _iter)
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
-- 
1.8.4.rc3

