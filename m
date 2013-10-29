Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3J2UWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:22:40 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55564 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3J2USm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:42 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH 12/23] block: Convert drivers to immutable biovecs
Date: Tue, 29 Oct 2013 13:18:05 -0700
Message-Id: <1383077896-4132-13-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got a mechanism for immutable biovecs -
bi_iter.bi_bvec_done - we need to convert drivers to use primitives that
respect it instead of using the bvec array directly.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/block/umem.c   | 50 ++++++++++++++++++++++--------------------------
 drivers/md/dm-crypt.c  | 49 +++++++++++++++++------------------------------
 drivers/md/dm-io.c     | 31 ++++++++++++++++--------------
 drivers/md/dm-raid1.c  |  8 ++++----
 drivers/md/dm-verity.c | 52 ++++++++++++++------------------------------------
 fs/bio.c               | 14 +++++++++++---
 include/linux/dm-io.h  |  4 ++--
 7 files changed, 89 insertions(+), 119 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index dab4f1a..4cf81b5 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -108,8 +108,7 @@ struct cardinfo {
 				    * have been written
 				    */
 	struct bio	*bio, *currentbio, **biotail;
-	int		current_idx;
-	sector_t	current_sector;
+	struct bvec_iter current_iter;
 
 	struct request_queue *queue;
 
@@ -118,7 +117,7 @@ struct cardinfo {
 		struct mm_dma_desc	*desc;
 		int	 		cnt, headcnt;
 		struct bio		*bio, **biotail;
-		int			idx;
+		struct bvec_iter	iter;
 	} mm_pages[2];
 #define DESC_PER_PAGE ((PAGE_SIZE*2)/sizeof(struct mm_dma_desc))
 
@@ -344,16 +343,13 @@ static int add_bio(struct cardinfo *card)
 	dma_addr_t dma_handle;
 	int offset;
 	struct bio *bio;
-	struct bio_vec *vec;
-	int idx;
+	struct bio_vec vec;
 	int rw;
-	int len;
 
 	bio = card->currentbio;
 	if (!bio && card->bio) {
 		card->currentbio = card->bio;
-		card->current_idx = card->bio->bi_iter.bi_idx;
-		card->current_sector = card->bio->bi_iter.bi_sector;
+		card->current_iter = card->bio->bi_iter;
 		card->bio = card->bio->bi_next;
 		if (card->bio == NULL)
 			card->biotail = &card->bio;
@@ -362,18 +358,17 @@ static int add_bio(struct cardinfo *card)
 	}
 	if (!bio)
 		return 0;
-	idx = card->current_idx;
 
 	rw = bio_rw(bio);
 	if (card->mm_pages[card->Ready].cnt >= DESC_PER_PAGE)
 		return 0;
 
-	vec = bio_iovec_idx(bio, idx);
-	len = vec->bv_len;
+	vec = bio_iter_iovec(bio, card->current_iter);
+
 	dma_handle = pci_map_page(card->dev,
-				  vec->bv_page,
-				  vec->bv_offset,
-				  len,
+				  vec.bv_page,
+				  vec.bv_offset,
+				  vec.bv_len,
 				  (rw == READ) ?
 				  PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
 
@@ -381,7 +376,7 @@ static int add_bio(struct cardinfo *card)
 	desc = &p->desc[p->cnt];
 	p->cnt++;
 	if (p->bio == NULL)
-		p->idx = idx;
+		p->iter = card->current_iter;
 	if ((p->biotail) != &bio->bi_next) {
 		*(p->biotail) = bio;
 		p->biotail = &(bio->bi_next);
@@ -391,8 +386,8 @@ static int add_bio(struct cardinfo *card)
 	desc->data_dma_handle = dma_handle;
 
 	desc->pci_addr = cpu_to_le64((u64)desc->data_dma_handle);
-	desc->local_addr = cpu_to_le64(card->current_sector << 9);
-	desc->transfer_size = cpu_to_le32(len);
+	desc->local_addr = cpu_to_le64(card->current_iter.bi_sector << 9);
+	desc->transfer_size = cpu_to_le32(vec.bv_len);
 	offset = (((char *)&desc->sem_control_bits) - ((char *)p->desc));
 	desc->sem_addr = cpu_to_le64((u64)(p->page_dma+offset));
 	desc->zero1 = desc->zero2 = 0;
@@ -407,10 +402,9 @@ static int add_bio(struct cardinfo *card)
 		desc->control_bits |= cpu_to_le32(DMASCR_TRANSFER_READ);
 	desc->sem_control_bits = desc->control_bits;
 
-	card->current_sector += (len >> 9);
-	idx++;
-	card->current_idx = idx;
-	if (idx >= bio->bi_vcnt)
+
+	bio_advance_iter(bio, &card->current_iter, vec.bv_len);
+	if (!card->current_iter.bi_size)
 		card->currentbio = NULL;
 
 	return 1;
@@ -439,23 +433,25 @@ static void process_page(unsigned long data)
 		struct mm_dma_desc *desc = &page->desc[page->headcnt];
 		int control = le32_to_cpu(desc->sem_control_bits);
 		int last = 0;
-		int idx;
+		struct bio_vec vec;
 
 		if (!(control & DMASCR_DMA_COMPLETE)) {
 			control = dma_status;
 			last = 1;
 		}
+
 		page->headcnt++;
-		idx = page->idx;
-		page->idx++;
-		if (page->idx >= bio->bi_vcnt) {
+		vec = bio_iter_iovec(bio, page->iter);
+		bio_advance_iter(bio, &page->iter, vec.bv_len);
+
+		if (!page->iter.bi_size) {
 			page->bio = bio->bi_next;
 			if (page->bio)
-				page->idx = page->bio->bi_iter.bi_idx;
+				page->iter = page->bio->bi_iter;
 		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle,
-			       bio_iovec_idx(bio, idx)->bv_len,
+			       vec.bv_len,
 				 (control & DMASCR_TRANSFER_READ) ?
 				PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 		if (control & DMASCR_HARD_ERROR) {
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3e8dd65..4db7e48 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -38,10 +38,8 @@ struct convert_context {
 	struct completion restart;
 	struct bio *bio_in;
 	struct bio *bio_out;
-	unsigned int offset_in;
-	unsigned int offset_out;
-	unsigned int idx_in;
-	unsigned int idx_out;
+	struct bvec_iter iter_in;
+	struct bvec_iter iter_out;
 	sector_t cc_sector;
 	atomic_t cc_pending;
 };
@@ -650,10 +648,10 @@ static void crypt_convert_init(struct crypt_config *cc,
 {
 	ctx->bio_in = bio_in;
 	ctx->bio_out = bio_out;
-	ctx->offset_in = 0;
-	ctx->offset_out = 0;
-	ctx->idx_in = bio_in ? bio_in->bi_iter.bi_idx : 0;
-	ctx->idx_out = bio_out ? bio_out->bi_iter.bi_idx : 0;
+	if (bio_in)
+		ctx->iter_in = bio_in->bi_iter;
+	if (bio_out)
+		ctx->iter_out = bio_out->bi_iter;
 	ctx->cc_sector = sector + cc->iv_offset;
 	init_completion(&ctx->restart);
 }
@@ -681,8 +679,8 @@ static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
 {
-	struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
-	struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
+	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 	struct dm_crypt_request *dmreq;
 	u8 *iv;
 	int r;
@@ -693,24 +691,15 @@ static int crypt_convert_block(struct crypt_config *cc,
 	dmreq->iv_sector = ctx->cc_sector;
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
-		    bv_in->bv_offset + ctx->offset_in);
+	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
+		    bv_in.bv_offset);
 
 	sg_init_table(&dmreq->sg_out, 1);
-	sg_set_page(&dmreq->sg_out, bv_out->bv_page, 1 << SECTOR_SHIFT,
-		    bv_out->bv_offset + ctx->offset_out);
+	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
+		    bv_out.bv_offset);
 
-	ctx->offset_in += 1 << SECTOR_SHIFT;
-	if (ctx->offset_in >= bv_in->bv_len) {
-		ctx->offset_in = 0;
-		ctx->idx_in++;
-	}
-
-	ctx->offset_out += 1 << SECTOR_SHIFT;
-	if (ctx->offset_out >= bv_out->bv_len) {
-		ctx->offset_out = 0;
-		ctx->idx_out++;
-	}
+	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
+	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
 
 	if (cc->iv_gen_ops) {
 		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
@@ -761,8 +750,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 	atomic_set(&ctx->cc_pending, 1);
 
-	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
-	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
+	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
 
 		crypt_alloc_req(cc, ctx);
 
@@ -1031,7 +1019,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	}
 
 	/* crypt_convert should have filled the clone bio */
-	BUG_ON(io->ctx.idx_out < clone->bi_vcnt);
+	BUG_ON(io->ctx.iter_out.bi_size);
 
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
@@ -1070,7 +1058,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		}
 
 		io->ctx.bio_out = clone;
-		io->ctx.idx_out = 0;
+		io->ctx.iter_out = clone->bi_iter;
 
 		remaining -= clone->bi_iter.bi_size;
 		sector += bio_sectors(clone);
@@ -1114,8 +1102,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 			crypt_inc_pending(new_io);
 			crypt_convert_init(cc, &new_io->ctx, NULL,
 					   io->base_bio, sector);
-			new_io->ctx.idx_in = io->ctx.idx_in;
-			new_io->ctx.offset_in = io->ctx.offset_in;
+			new_io->ctx.iter_in = io->ctx.iter_in;
 
 			/*
 			 * Fragments after the first use the base_io
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 01558b0..b2b8a10 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -201,26 +201,29 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offse
 /*
  * Functions for getting the pages from a bvec.
  */
-static void bvec_get_page(struct dpages *dp,
+static void bio_get_page(struct dpages *dp,
 		  struct page **p, unsigned long *len, unsigned *offset)
 {
-	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
-	*p = bvec->bv_page;
-	*len = bvec->bv_len;
-	*offset = bvec->bv_offset;
+	struct bio *bio = dp->context_ptr;
+	struct bio_vec bvec = bio_iovec(bio);
+	*p = bvec.bv_page;
+	*len = bvec.bv_len;
+	*offset = bvec.bv_offset;
 }
 
-static void bvec_next_page(struct dpages *dp)
+static void bio_next_page(struct dpages *dp)
 {
-	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
-	dp->context_ptr = bvec + 1;
+	struct bio *bio = dp->context_ptr;
+	struct bio_vec bvec = bio_iovec(bio);
+
+	bio_advance(bio, bvec.bv_len);
 }
 
-static void bvec_dp_init(struct dpages *dp, struct bio_vec *bvec)
+static void bio_dp_init(struct dpages *dp, struct bio *bio)
 {
-	dp->get_page = bvec_get_page;
-	dp->next_page = bvec_next_page;
-	dp->context_ptr = bvec;
+	dp->get_page = bio_get_page;
+	dp->next_page = bio_next_page;
+	dp->context_ptr = bio;
 }
 
 /*
@@ -457,8 +460,8 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
 		break;
 
-	case DM_IO_BVEC:
-		bvec_dp_init(dp, io_req->mem.ptr.bvec);
+	case DM_IO_BIO:
+		bio_dp_init(dp, io_req->mem.ptr.bio);
 		break;
 
 	case DM_IO_VMA:
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 9f6d8e6..f284e0b 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -526,8 +526,8 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
 	struct dm_io_region io;
 	struct dm_io_request io_req = {
 		.bi_rw = READ,
-		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
+		.mem.type = DM_IO_BIO,
+		.mem.ptr.bio = bio,
 		.notify.fn = read_callback,
 		.notify.context = bio,
 		.client = m->ms->io_client,
@@ -629,8 +629,8 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	struct mirror *m;
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE | (bio->bi_rw & WRITE_FLUSH_FUA),
-		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
+		.mem.type = DM_IO_BIO,
+		.mem.ptr.bio = bio,
 		.notify.fn = write_callback,
 		.notify.context = bio,
 		.client = ms->io_client,
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 5392135..ac35e95 100644
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
@@ -284,9 +279,10 @@ release_ret_r:
 static int verity_verify_io(struct dm_verity_io *io)
 {
 	struct dm_verity *v = io->v;
+	struct bio *bio = dm_bio_from_per_bio_data(io,
+						   v->ti->per_bio_data_size);
 	unsigned b;
 	int i;
-	unsigned vector = 0, offset = 0;
 
 	for (b = 0; b < io->n_blocks; b++) {
 		struct shash_desc *desc;
@@ -336,31 +332,22 @@ test_block_hash:
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
+			struct bio_vec bv = bio_iter_iovec(bio, io->iter);
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
@@ -383,8 +370,6 @@ test_block_hash:
 			return -EIO;
 		}
 	}
-	BUG_ON(vector != io->io_vec_size);
-	BUG_ON(offset);
 
 	return 0;
 }
@@ -400,9 +385,6 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
 
-	if (io->io_vec != io->io_vec_inline)
-		mempool_free(io->io_vec, v->vec_mempool);
-
 	bio_endio(bio, error);
 }
 
@@ -519,13 +501,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 
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
 
 	verity_submit_prefetch(v, io);
 
diff --git a/fs/bio.c b/fs/bio.c
index 8c118d0..ff5195d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -525,8 +525,17 @@ EXPORT_SYMBOL(bio_phys_segments);
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	if (bio_is_rw(bio_src)) {
+		struct bio_vec bv;
+		struct bvec_iter iter;
+
+		bio_for_each_segment(bv, bio_src, iter)
+			bio->bi_io_vec[bio->bi_vcnt++] = bv;
+	} else if (bio_has_data(bio_src)) {
+		memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
+		       bio_src->bi_max_vecs * sizeof(struct bio_vec));
+		bio->bi_vcnt = bio_src->bi_vcnt;
+	}
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -535,7 +544,6 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_iter = bio_src->bi_iter;
 }
 EXPORT_SYMBOL(__bio_clone);
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index f4b0aa3..a68cbe5 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -29,7 +29,7 @@ typedef void (*io_notify_fn)(unsigned long error, void *context);
 
 enum dm_io_mem_type {
 	DM_IO_PAGE_LIST,/* Page list */
-	DM_IO_BVEC,	/* Bio vector */
+	DM_IO_BIO,	/* Bio vector */
 	DM_IO_VMA,	/* Virtual memory area */
 	DM_IO_KMEM,	/* Kernel memory */
 };
@@ -41,7 +41,7 @@ struct dm_io_memory {
 
 	union {
 		struct page_list *pl;
-		struct bio_vec *bvec;
+		struct bio *bio;
 		void *vma;
 		void *addr;
 	} ptr;
-- 
1.8.4.rc3

