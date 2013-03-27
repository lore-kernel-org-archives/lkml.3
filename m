Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3C0Rkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:40:40 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64205 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3C0Rka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:30 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 10/22] dm-crypt: Convert to bvec_iter
Date: Wed, 27 Mar 2013 10:39:40 -0700
Message-Id: <1364405992-28424-11-git-send-email-koverstreet@google.com>
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
 drivers/md/dm-crypt.c | 52 +++++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index fca3bba..d97d824 100644
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
@@ -650,10 +648,12 @@ static void crypt_convert_init(struct crypt_config *cc,
 {
 	ctx->bio_in = bio_in;
 	ctx->bio_out = bio_out;
-	ctx->offset_in = 0;
-	ctx->offset_out = 0;
-	ctx->idx_in = bio_in ? bio_in->bi_iter.bi_idx : 0;
-	ctx->idx_out = bio_out ? bio_out->bi_iter.bi_idx : 0;
+
+	if (bio_in)
+		ctx->iter_in = bio_in->bi_iter;
+	if (bio_out)
+		ctx->iter_out = bio_out->bi_iter;
+
 	ctx->cc_sector = sector + cc->iv_offset;
 	init_completion(&ctx->restart);
 }
@@ -681,8 +681,8 @@ static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
 {
-	struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
-	struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
+	struct bio_vec bv_in = bio_iovec_iter(ctx->bio_in, ctx->iter_in);
+	struct bio_vec bv_out = bio_iovec_iter(ctx->bio_out, ctx->iter_out);
 	struct dm_crypt_request *dmreq;
 	u8 *iv;
 	int r;
@@ -693,24 +693,15 @@ static int crypt_convert_block(struct crypt_config *cc,
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
@@ -761,8 +752,8 @@ static int crypt_convert(struct crypt_config *cc,
 
 	atomic_set(&ctx->cc_pending, 1);
 
-	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
-	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
+	while (ctx->iter_in.bi_size &&
+	       ctx->iter_out.bi_size) {
 
 		crypt_alloc_req(cc, ctx);
 
@@ -1031,7 +1022,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	}
 
 	/* crypt_convert should have filled the clone bio */
-	BUG_ON(io->ctx.idx_out < clone->bi_vcnt);
+	BUG_ON(io->ctx.iter_out.bi_size);
 
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
@@ -1070,7 +1061,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		}
 
 		io->ctx.bio_out = clone;
-		io->ctx.idx_out = 0;
+		io->ctx.iter_out = clone->bi_iter;
 
 		remaining -= clone->bi_iter.bi_size;
 		sector += bio_sectors(clone);
@@ -1114,8 +1105,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 			crypt_inc_pending(new_io);
 			crypt_convert_init(cc, &new_io->ctx, NULL,
 					   io->base_bio, sector);
-			new_io->ctx.idx_in = io->ctx.idx_in;
-			new_io->ctx.offset_in = io->ctx.offset_in;
+			new_io->ctx.iter_in = io->ctx.iter_in;
 
 			/*
 			 * Fragments after the first use the base_io
-- 
1.8.1.3

