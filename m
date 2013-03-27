Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3C0Rnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:43:32 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:44769 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3C0Rkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:35 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 14/22] block: Kill __BVEC_END, __BVEC_START
Date: Wed, 27 Mar 2013 10:39:44 -0700
Message-Id: <1364405992-28424-15-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new bio splitting code, drivers won't be able to use bi_vcnt to
find the last bvec - even if bi_vcnt was set to point to the last bvec,
this bio might not be using all of it - we've got to take into account
bi_size in case the bvec was split between two bios.

Update the merging code to use bio_for_each_segment() to find the last
bvec and kill the old helpers.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-merge.c   | 13 +++++++++++--
 include/linux/bio.h |  5 -----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index cd15b38..daf94f6 100644
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
index 62c7293..d6c646b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -148,9 +148,6 @@ static inline void *bio_data(struct bio *bio)
  * merge helpers etc
  */
 
-#define __BVEC_END(bio)		bio_iovec_idx((bio), (bio)->bi_vcnt - 1)
-#define __BVEC_START(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-
 /* Default implementation of BIOVEC_PHYS_MERGEABLE */
 #define __BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
@@ -167,8 +164,6 @@ static inline void *bio_data(struct bio *bio)
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
 	__BIO_SEG_BOUNDARY(bvec_to_phys((b1)), bvec_to_phys((b2)) + (b2)->bv_len, queue_segment_boundary((q)))
-#define BIO_SEG_BOUNDARY(q, b1, b2) \
-	BIOVEC_SEG_BOUNDARY((q), __BVEC_END((b1)), __BVEC_START((b2)))
 
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
-- 
1.8.1.3

