Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3FICWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:22:03 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64694 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3FICUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:20:08 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 22/26] block: Make generic_make_request handle arbitrary sized bios
Date: Sat,  8 Jun 2013 19:19:04 -0700
Message-Id: <1370744348-15407-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the block layer is currently written, it goes to great lengths
to avoid having to split bios; upper layer code (such as bio_add_page())
checks what the underlying device can handle and tries to always create
bios that don't need to be split.

But this approach becomes unwieldy and eventually breaks down with
stacked devices and devices with dynamic limits, and it adds a lot of
complexity. If the block layer could split bios as needed, we could
eliminate a lot of complexity elsewhere - particularly in stacked
drivers. Code that creates bios can then create whatever size bios are
convenient, and more importantly stacked drivers don't have to deal with
both their own bio size limitations and the limitations of the
(potentially multiple) devices underneath them.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 block/blk-core.c       |  24 ++++++----
 block/blk-merge.c      | 120 +++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk.h            |   3 ++
 include/linux/blkdev.h |   4 ++
 4 files changed, 142 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4d6eb60..f43bf1a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -599,6 +599,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_q;
 
+	q->bio_split = bioset_create(4, 0);
+	if (!q->bio_split)
+		goto fail_split;
+
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -651,6 +655,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
+fail_split:
+	bioset_free(q->bio_split);
 fail_q:
 	kmem_cache_free(blk_requestq_cachep, q);
 	return NULL;
@@ -1687,15 +1693,6 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (likely(bio_is_rw(bio) &&
-		   nr_sectors > queue_max_hw_sectors(q))) {
-		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
-		       bdevname(bio->bi_bdev, b),
-		       bio_sectors(bio),
-		       queue_max_hw_sectors(q));
-		goto end_io;
-	}
-
 	part = bio->bi_bdev->bd_part;
 	if (should_fail_request(part, bio->bi_iter.bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
@@ -1820,6 +1817,7 @@ void generic_make_request(struct bio *bio)
 	current->bio_list = &bio_list_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+		struct bio *split = NULL;
 
 		/*
 		 * low level driver can indicate that it wants pages above a
@@ -1828,6 +1826,14 @@ void generic_make_request(struct bio *bio)
 		 */
 		blk_queue_bounce(q, &bio);
 
+		if (!blk_queue_largebios(q))
+			split = blk_bio_segment_split(q, bio, q->bio_split);
+		if (split) {
+			bio_chain(split, bio);
+			bio_list_add(current->bio_list, bio);
+			bio = split;
+		}
+
 		q->make_request_fn(q, bio);
 
 		bio = bio_list_pop(current->bio_list);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index ba48830..fbbcfc5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,6 +9,126 @@
 
 #include "blk.h"
 
+static struct bio *blk_bio_discard_split(struct request_queue *q,
+					 struct bio *bio,
+					 struct bio_set *bs)
+{
+	sector_t max_discard_sectors, granularity, alignment, tmp;
+	unsigned split_sectors;
+
+	/* Zero-sector (unknown) and one-sector granularities are the same.  */
+	granularity = max(q->limits.discard_granularity >> 9, 1U);
+
+	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	sector_div(max_discard_sectors, granularity);
+	max_discard_sectors *= granularity;
+
+	if (unlikely(!max_discard_sectors)) {
+		/* XXX: warn */
+		return NULL;
+	}
+
+	if (bio_sectors(bio) <= max_discard_sectors)
+		return NULL;
+
+	split_sectors = max_discard_sectors;
+
+	/*
+	 * If splitting a request, and the next starting sector would be
+	 * misaligned, stop the discard at the previous aligned sector.
+	 */
+	alignment = q->limits.discard_alignment >> 9;
+	alignment = sector_div(alignment, granularity);
+
+	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
+	tmp = sector_div(tmp, granularity);
+
+	if (split_sectors > tmp)
+		split_sectors -= tmp;
+
+	return bio_split(bio, split_sectors, GFP_NOIO, bs);
+}
+
+static struct bio *blk_bio_write_same_split(struct request_queue *q,
+					    struct bio *bio,
+					    struct bio_set *bs)
+{
+	if (!q->limits.max_write_same_sectors)
+		return NULL;
+
+	if (bio_sectors(bio) <= q->limits.max_write_same_sectors)
+		return NULL;
+
+	return bio_split(bio, q->limits.max_write_same_sectors, GFP_NOIO, bs);
+}
+
+struct bio *blk_bio_segment_split(struct request_queue *q, struct bio *bio,
+				  struct bio_set *bs)
+{
+	struct bio *split;
+	struct bio_vec bv, bvprv;
+	struct bvec_iter iter;
+	unsigned seg_size = 0, nsegs = 0;
+	int prev = 0;
+
+	struct bvec_merge_data bvm = {
+		.bi_bdev	= bio->bi_bdev,
+		.bi_sector	= bio->bi_iter.bi_sector,
+		.bi_size	= 0,
+		.bi_rw		= bio->bi_rw,
+	};
+
+	if (bio->bi_rw & REQ_DISCARD)
+		return blk_bio_discard_split(q, bio, bs);
+
+	if (bio->bi_rw & REQ_WRITE_SAME)
+		return blk_bio_write_same_split(q, bio, bs);
+
+	bio_for_each_segment(bv, bio, iter) {
+		if (q->merge_bvec_fn &&
+		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
+			goto split;
+
+		bvm.bi_size += bv.bv_len;
+
+		if (prev && blk_queue_cluster(q)) {
+			if (seg_size + bv.bv_len > queue_max_segment_size(q))
+				goto new_segment;
+			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
+				goto new_segment;
+			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
+				goto new_segment;
+
+			seg_size += bv.bv_len;
+			bvprv = bv;
+			prev = 1;
+			continue;
+		}
+new_segment:
+		if (nsegs == queue_max_segments(q))
+			goto split;
+
+		nsegs++;
+		bvprv = bv;
+		prev = 1;
+		seg_size = bv.bv_len;
+	}
+
+	return NULL;
+split:
+	split = bio_clone_bioset(bio, GFP_NOIO, bs);
+
+	split->bi_iter.bi_size -= iter.bi_size;
+	bio->bi_iter = iter;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_advance(bio, split->bi_iter.bi_size);
+		bio_integrity_trim(split, 0, bio_sectors(split));
+	}
+
+	return split;
+}
+
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
diff --git a/block/blk.h b/block/blk.h
index e837b8f..387afbd 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -130,6 +130,9 @@ static inline int blk_should_fake_timeout(struct request_queue *q)
 }
 #endif
 
+struct bio *blk_bio_segment_split(struct request_queue *q, struct bio *bio,
+				  struct bio_set *bs);
+
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
 		     struct bio *bio);
 int ll_front_merge_fn(struct request_queue *q, struct request *req, 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2a16de2..9a32ed8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -445,6 +445,7 @@ struct request_queue {
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
+	struct bio_set		*bio_split;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -467,6 +468,7 @@ struct request_queue {
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
 #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
+#define QUEUE_FLAG_LARGEBIOS   19	/* no limits on bio size */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -550,6 +552,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_largebios(q)				\
+	test_bit(QUEUE_FLAG_LARGEBIOS, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
1.8.3.rc1

