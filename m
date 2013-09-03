Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3ICQe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:34:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3ICQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        Neil Brown <neilb@suse.de>, Boaz Harrosh <bharrosh@panasas.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 51/58] block: Add bio_for_each_segment_all()
Date: Tue,  3 Sep 2013 09:23:55 -0700
Message-Id: <1378225442-20654-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <koverstreet@google.com>

commit d74c6d514fe314b8bdab58b487b25992291577ec upstream.

__bio_for_each_segment() iterates bvecs from the specified index
instead of bio->bv_idx.  Currently, the only usage is to walk all the
bvecs after the bio has been advanced by specifying 0 index.

For immutable bvecs, we need to split these apart;
bio_for_each_segment() is going to have a different implementation.
This will also help document the intent of code that's using it -
bio_for_each_segment_all() is only legal to use for code that owns the
bio.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Neil Brown <neilb@suse.de>
CC: Boaz Harrosh <bharrosh@panasas.com>
[ kamal: 3.8.y-prereq for:
  35dc248 [SCSI] sg: Fix user memory corruption when SG_IO is interrupted by a signal ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/rbd.c |  2 +-
 drivers/md/raid1.c  |  2 +-
 fs/bio.c            | 12 ++++++------
 fs/exofs/ore.c      |  2 +-
 fs/exofs/ore_raid.c |  2 +-
 include/linux/bio.h | 17 ++++++++++++++---
 mm/bounce.c         |  2 +-
 7 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 992dd78..5ac4a17 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -867,7 +867,7 @@ static struct bio *bio_clone_range(struct bio *bio_src,
 	/* Find first affected segment... */
 
 	resid = offset;
-	__bio_for_each_segment(bv, bio_src, idx, 0) {
+	bio_for_each_segment(bv, bio_src, idx) {
 		if (resid < bv->bv_len)
 			break;
 		resid -= bv->bv_len;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7116798..a382d84 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1306,7 +1306,7 @@ read_again:
 			 * know the original bi_idx, so we just free
 			 * them all
 			 */
-			__bio_for_each_segment(bvec, mbio, j, 0)
+			bio_for_each_segment_all(bvec, mbio, j)
 				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
diff --git a/fs/bio.c b/fs/bio.c
index b96fc6c..18e10cc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -714,7 +714,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 	int iov_idx = 0;
 	unsigned int iov_off = 0;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		char *bv_addr = page_address(bvec->bv_page);
 		unsigned int bv_len = iovecs[i].bv_len;
 
@@ -896,7 +896,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	return bio;
 cleanup:
 	if (!map_data)
-		bio_for_each_segment(bvec, bio, i)
+		bio_for_each_segment_all(bvec, bio, i)
 			__free_page(bvec->bv_page);
 
 	bio_put(bio);
@@ -1110,7 +1110,7 @@ static void __bio_unmap_user(struct bio *bio)
 	/*
 	 * make sure we dirty pages we wrote to
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
 			set_page_dirty_lock(bvec->bv_page);
 
@@ -1216,7 +1216,7 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 	int i;
 	char *p = bmd->sgvecs[0].iov_base;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
@@ -1256,7 +1256,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	if (!reading) {
 		void *p = data;
 
-		bio_for_each_segment(bvec, bio, i) {
+		bio_for_each_segment_all(bvec, bio, i) {
 			char *addr = page_address(bvec->bv_page);
 
 			memcpy(addr, p, bvec->bv_len);
@@ -1541,7 +1541,7 @@ sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 	if (index >= bio->bi_idx)
 		index = bio->bi_vcnt - 1;
 
-	__bio_for_each_segment(bv, bio, i, 0) {
+	bio_for_each_segment_all(bv, bio, i) {
 		if (i == index) {
 			if (offset > bv->bv_offset)
 				sectors += (offset - bv->bv_offset) / sector_sz;
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index f936cb5..b744228 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -401,7 +401,7 @@ static void _clear_bio(struct bio *bio)
 	struct bio_vec *bv;
 	unsigned i;
 
-	__bio_for_each_segment(bv, bio, i, 0) {
+	bio_for_each_segment_all(bv, bio, i) {
 		unsigned this_count = bv->bv_len;
 
 		if (likely(PAGE_SIZE == this_count))
diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index b963f38..7682b97 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -432,7 +432,7 @@ static void _mark_read4write_pages_uptodate(struct ore_io_state *ios, int ret)
 		if (!bio)
 			continue;
 
-		__bio_for_each_segment(bv, bio, i, 0) {
+		bio_for_each_segment_all(bv, bio, i) {
 			struct page *page = bv->bv_page;
 
 			SetPageUptodate(page);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 820e7aa..d203d1e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -136,16 +136,27 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
 /*
- * drivers should not use the __ version unless they _really_ want to
- * run through the entire bio and not just pending pieces
+ * drivers should not use the __ version unless they _really_ know what
+ * they're doing
  */
 #define __bio_for_each_segment(bvl, bio, i, start_idx)			\
 	for (bvl = bio_iovec_idx((bio), (start_idx)), i = (start_idx);	\
 	     i < (bio)->bi_vcnt;					\
 	     bvl++, i++)
 
+/*
+ * drivers should _never_ use the all version - the bio may have been split
+ * before it got to the driver and the driver won't own all of it
+ */
+#define bio_for_each_segment_all(bvl, bio, i)				\
+	for (i = 0;							\
+	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
+	     i++)
+
 #define bio_for_each_segment(bvl, bio, i)				\
-	__bio_for_each_segment(bvl, bio, i, (bio)->bi_idx)
+	for (i = (bio)->bi_idx;						\
+	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
+	     i++)
 
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
diff --git a/mm/bounce.c b/mm/bounce.c
index 0420867..9bc26f3 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -134,7 +134,7 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 	/*
 	 * free up bounce indirect pages used
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		org_vec = bio_orig->bi_io_vec + i;
 		if (bvec->bv_page == org_vec->bv_page)
 			continue;
-- 
1.8.1.2

