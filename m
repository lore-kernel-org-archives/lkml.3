Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3IHDmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:42:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366Ab3IHDTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neil Brown" <neilb@suse.de>,
        "Kent Overstreet" <koverstreet@google.com>,
        "Boaz Harrosh" <bharrosh@panasas.com>, "Jens Axboe" <axboe@kernel.dk>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.102338601@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [082/121] block: Add bio_for_each_segment_all()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: drop inapplicable change to drivers/block/rbd.c.
 This is a prerequisite for commit 35dc248383bb 'sg: Fix user memory
 corruption when SG_IO is interrupted by a signal']
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1139,7 +1139,7 @@ read_again:
 			 * know the original bi_idx, so we just free
 			 * them all
 			 */
-			__bio_for_each_segment(bvec, mbio, j, 0)
+			bio_for_each_segment_all(bvec, mbio, j)
 				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -734,7 +734,7 @@ static int __bio_copy_iov(struct bio *bi
 	int iov_idx = 0;
 	unsigned int iov_off = 0;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		char *bv_addr = page_address(bvec->bv_page);
 		unsigned int bv_len = iovecs[i].bv_len;
 
@@ -916,7 +916,7 @@ struct bio *bio_copy_user_iov(struct req
 	return bio;
 cleanup:
 	if (!map_data)
-		bio_for_each_segment(bvec, bio, i)
+		bio_for_each_segment_all(bvec, bio, i)
 			__free_page(bvec->bv_page);
 
 	bio_put(bio);
@@ -1130,7 +1130,7 @@ static void __bio_unmap_user(struct bio
 	/*
 	 * make sure we dirty pages we wrote to
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
 			set_page_dirty_lock(bvec->bv_page);
 
@@ -1236,7 +1236,7 @@ static void bio_copy_kern_endio(struct b
 	int i;
 	char *p = bmd->sgvecs[0].iov_base;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
@@ -1276,7 +1276,7 @@ struct bio *bio_copy_kern(struct request
 	if (!reading) {
 		void *p = data;
 
-		bio_for_each_segment(bvec, bio, i) {
+		bio_for_each_segment_all(bvec, bio, i) {
 			char *addr = page_address(bvec->bv_page);
 
 			memcpy(addr, p, bvec->bv_len);
@@ -1556,7 +1556,7 @@ sector_t bio_sector_offset(struct bio *b
 	if (index >= bio->bi_idx)
 		index = bio->bi_vcnt - 1;
 
-	__bio_for_each_segment(bv, bio, i, 0) {
+	bio_for_each_segment_all(bv, bio, i) {
 		if (i == index) {
 			if (offset > bv->bv_offset)
 				sectors += (offset - bv->bv_offset) / sector_sz;
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -401,7 +401,7 @@ static void _clear_bio(struct bio *bio)
 	struct bio_vec *bv;
 	unsigned i;
 
-	__bio_for_each_segment(bv, bio, i, 0) {
+	bio_for_each_segment_all(bv, bio, i) {
 		unsigned this_count = bv->bv_len;
 
 		if (likely(PAGE_SIZE == this_count))
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -432,7 +432,7 @@ static void _mark_read4write_pages_uptod
 		if (!bio)
 			continue;
 
-		__bio_for_each_segment(bv, bio, i, 0) {
+		bio_for_each_segment_all(bv, bio, i) {
 			struct page *page = bv->bv_page;
 
 			SetPageUptodate(page);
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -135,16 +135,27 @@ static inline int bio_has_allocated_vec(
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
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -132,7 +132,7 @@ static void bounce_end_io(struct bio *bi
 	/*
 	 * free up bounce indirect pages used
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		org_vec = bio_orig->bi_io_vec + i;
 		if (bvec->bv_page == org_vec->bv_page)
 			continue;

