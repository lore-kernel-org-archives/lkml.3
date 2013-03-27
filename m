Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3C0RrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:47:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62004 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3C0Rk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:26 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 07/22] dm-verity: convert to bvec iter
Date: Wed, 27 Mar 2013 10:39:37 -0700
Message-Id: <1364405992-28424-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new primitives which respect the current value of bi_idx and
bi_bvec_done.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-verity.c | 51 +++++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 782ee42..2d01c33 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -73,15 +73,10 @@ struct dm_verity_io {
 	sector_t block;
 	unsigned n_blocks;
 
-	/* saved bio vector */
-	struct bio_vec *io_vec;
-	unsigned io_vec_size;
+	struct bvec_iter iter;
 
 	struct work_struct work;
 
-	/* A space for short vectors; longer vectors are allocated separately. */
-	struct bio_vec io_vec_inline[DM_VERITY_IO_VEC_INLINE];
-
 	/*
 	 * Three variably-size fields follow this struct:
 	 *
@@ -277,9 +272,9 @@ release_ret_r:
 static int verity_verify_io(struct dm_verity_io *io)
 {
 	struct dm_verity *v = io->v;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_bio_data_size);
 	unsigned b;
 	int i;
-	unsigned vector = 0, offset = 0;
 
 	for (b = 0; b < io->n_blocks; b++) {
 		struct shash_desc *desc;
@@ -329,31 +324,22 @@ test_block_hash:
 		}
 
 		todo = 1 << v->data_dev_block_bits;
-		do {
-			struct bio_vec *bv;
+		while (io->iter.bi_size) {
 			u8 *page;
-			unsigned len;
-
-			BUG_ON(vector >= io->io_vec_size);
-			bv = &io->io_vec[vector];
-			page = kmap_atomic(bv->bv_page);
-			len = bv->bv_len - offset;
-			if (likely(len >= todo))
-				len = todo;
-			r = crypto_shash_update(desc,
-					page + bv->bv_offset + offset, len);
+			struct bio_vec bv = bio_iovec_iter(bio, io->iter);
+
+			page = kmap_atomic(bv.bv_page);
+			r = crypto_shash_update(desc, page + bv.bv_offset,
+						bv.bv_len);
 			kunmap_atomic(page);
+
 			if (r < 0) {
 				DMERR("crypto_shash_update failed: %d", r);
 				return r;
 			}
-			offset += len;
-			if (likely(offset == bv->bv_len)) {
-				offset = 0;
-				vector++;
-			}
-			todo -= len;
-		} while (todo);
+
+			bio_advance_iter(bio, &io->iter, bv.bv_len);
+		}
 
 		if (!v->version) {
 			r = crypto_shash_update(desc, v->salt, v->salt_size);
@@ -376,8 +362,6 @@ test_block_hash:
 			return -EIO;
 		}
 	}
-	BUG_ON(vector != io->io_vec_size);
-	BUG_ON(offset);
 
 	return 0;
 }
@@ -393,9 +377,6 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
 
-	if (io->io_vec != io->io_vec_inline)
-		mempool_free(io->io_vec, v->vec_mempool);
-
 	bio_endio(bio, error);
 }
 
@@ -491,13 +472,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 
 	bio->bi_end_io = verity_end_io;
 	bio->bi_private = io;
-	io->io_vec_size = bio_segments(bio);
-	if (io->io_vec_size < DM_VERITY_IO_VEC_INLINE)
-		io->io_vec = io->io_vec_inline;
-	else
-		io->io_vec = mempool_alloc(v->vec_mempool, GFP_NOIO);
-	memcpy(io->io_vec, __bio_iovec(bio),
-	       io->io_vec_size * sizeof(struct bio_vec));
+	io->iter = bio->bi_iter;
 
 	verity_prefetch_io(v, io);
 
-- 
1.8.1.3

