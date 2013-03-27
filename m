Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3C0RrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:47:10 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64804 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3C0RkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:25 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        "Ed L. Cashin" <ecashin@coraid.com>
Subject: [PATCH 06/22] aoe: Convert to bvec_iter
Date: Wed, 27 Mar 2013 10:39:36 -0700
Message-Id: <1364405992-28424-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we start using immutable biovecs to for efficient bio splitting,
drivers need to be using the new primitives that handle
bvec_iter.bi_bvec_done. Otherwise, this should be eqivalent to the old
code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |  10 +---
 drivers/block/aoe/aoecmd.c | 130 +++++++++++++++++----------------------------
 2 files changed, 51 insertions(+), 89 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 1756494..e959e6b 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -100,11 +100,8 @@ enum {
 
 struct buf {
 	ulong nframesout;
-	ulong resid;
-	ulong bv_resid;
-	sector_t sector;
 	struct bio *bio;
-	struct bio_vec *bv;
+	struct bvec_iter iter;
 	struct request *rq;
 };
 
@@ -120,13 +117,10 @@ struct frame {
 	ulong waited;
 	ulong waited_total;
 	struct aoetgt *t;		/* parent target I belong to */
-	sector_t lba;
 	struct sk_buff *skb;		/* command skb freed on module exit */
 	struct sk_buff *r_skb;		/* response skb for async processing */
 	struct buf *buf;
-	struct bio_vec *bv;
-	ulong bcnt;
-	ulong bv_off;
+	struct bvec_iter iter;
 	char flags;
 };
 
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 63acfa1..08422a9 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -182,8 +182,7 @@ aoe_freetframe(struct frame *f)
 
 	t = f->t;
 	f->buf = NULL;
-	f->lba = 0;
-	f->bv = NULL;
+	memset(&f->iter, 0, sizeof(f->iter));
 	f->r_skb = NULL;
 	f->flags = 0;
 	list_add(&f->head, &t->ffree);
@@ -281,21 +280,17 @@ newframe(struct aoedev *d)
 }
 
 static void
-skb_fillup(struct sk_buff *skb, struct bio_vec *bv, ulong off, ulong cnt)
+skb_fillup(struct sk_buff *skb, struct bio *bio, struct bvec_iter *iter)
 {
 	int frag = 0;
-	ulong fcnt;
-loop:
-	fcnt = bv->bv_len - (off - bv->bv_offset);
-	if (fcnt > cnt)
-		fcnt = cnt;
-	skb_fill_page_desc(skb, frag++, bv->bv_page, off, fcnt);
-	cnt -= fcnt;
-	if (cnt <= 0)
-		return;
-	bv++;
-	off = bv->bv_offset;
-	goto loop;
+
+	while (iter->bi_size) {
+		struct bio_vec bv = bio_iovec_iter(bio, *iter);
+
+		skb_fill_page_desc(skb, frag++, bv.bv_page,
+				   bv.bv_offset, bv.bv_len);
+		bio_advance_iter(bio, iter, bv.bv_len);
+	}
 }
 
 static void
@@ -332,12 +327,10 @@ ata_rw_frameinit(struct frame *f)
 	t->nout++;
 	f->waited = 0;
 	f->waited_total = 0;
-	if (f->buf)
-		f->lba = f->buf->sector;
 
 	/* set up ata header */
-	ah->scnt = f->bcnt >> 9;
-	put_lba(ah, f->lba);
+	ah->scnt = f->iter.bi_size >> 9;
+	put_lba(ah, f->iter.bi_sector);
 	if (t->d->flags & DEVFL_EXT) {
 		ah->aflags |= AOEAFL_EXT;
 	} else {
@@ -346,11 +339,11 @@ ata_rw_frameinit(struct frame *f)
 		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
 	}
 	if (f->buf && bio_data_dir(f->buf->bio) == WRITE) {
-		skb_fillup(skb, f->bv, f->bv_off, f->bcnt);
+		skb->len += f->iter.bi_size;
+		skb->data_len = f->iter.bi_size;
+		skb->truesize += f->iter.bi_size;
+		skb_fillup(skb, f->buf->bio, &f->iter);
 		ah->aflags |= AOEAFL_WRITE;
-		skb->len += f->bcnt;
-		skb->data_len = f->bcnt;
-		skb->truesize += f->bcnt;
 		t->wpkts++;
 	} else {
 		t->rpkts++;
@@ -369,7 +362,7 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
-	ulong bcnt, fbcnt;
+	ulong bcnt;
 
 	buf = nextbuf(d);
 	if (buf == NULL)
@@ -381,36 +374,19 @@ aoecmd_ata_rw(struct aoedev *d)
 	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
-	if (bcnt > buf->resid)
-		bcnt = buf->resid;
-	fbcnt = bcnt;
-	f->bv = buf->bv;
-	f->bv_off = f->bv->bv_offset + (f->bv->bv_len - buf->bv_resid);
-	do {
-		if (fbcnt < buf->bv_resid) {
-			buf->bv_resid -= fbcnt;
-			buf->resid -= fbcnt;
-			break;
-		}
-		fbcnt -= buf->bv_resid;
-		buf->resid -= buf->bv_resid;
-		if (buf->resid == 0) {
-			d->ip.buf = NULL;
-			break;
-		}
-		buf->bv++;
-		buf->bv_resid = buf->bv->bv_len;
-		WARN_ON(buf->bv_resid == 0);
-	} while (fbcnt);
+	if (bcnt > buf->iter.bi_size)
+		bcnt = buf->iter.bi_size;
+
+	bio_advance_iter(buf->bio, &buf->iter, bcnt);
 
 	/* initialize the headers & frame */
 	f->buf = buf;
-	f->bcnt = bcnt;
+	f->iter = buf->iter;
+	f->iter.bi_size = bcnt;
 	ata_rw_frameinit(f);
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
-	buf->sector += bcnt >> 9;
 
 	skb = skb_clone(f->skb, GFP_ATOMIC);
 	if (skb) {
@@ -603,10 +579,7 @@ reassign_frame(struct frame *f)
 	skb = nf->skb;
 	nf->skb = f->skb;
 	nf->buf = f->buf;
-	nf->bcnt = f->bcnt;
-	nf->lba = f->lba;
-	nf->bv = f->bv;
-	nf->bv_off = f->bv_off;
+	nf->iter = f->iter;
 	nf->waited = 0;
 	nf->waited_total = f->waited_total;
 	nf->sent = f->sent;
@@ -625,6 +598,7 @@ probe(struct aoetgt *t)
 	struct sk_buff_head queue;
 	size_t n, m;
 	int frag;
+	ulong bcnt;
 
 	d = t->d;
 	f = newtframe(d, t);
@@ -638,19 +612,20 @@ probe(struct aoetgt *t)
 	}
 	f->flags |= FFL_PROBE;
 	ifrotate(t);
-	f->bcnt = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
+	bcnt = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
+	f->iter.bi_size = bcnt;
 	ata_rw_frameinit(f);
 	skb = f->skb;
-	for (frag = 0, n = f->bcnt; n > 0; ++frag, n -= m) {
+	for (frag = 0, n = bcnt; n > 0; ++frag, n -= m) {
 		if (n < PAGE_SIZE)
 			m = n;
 		else
 			m = PAGE_SIZE;
 		skb_fill_page_desc(skb, frag, empty_page, 0, m);
 	}
-	skb->len += f->bcnt;
-	skb->data_len = f->bcnt;
-	skb->truesize += f->bcnt;
+	skb->len += bcnt;
+	skb->data_len = bcnt;
+	skb->truesize += bcnt;
 
 	skb = skb_clone(f->skb, GFP_ATOMIC);
 	if (skb) {
@@ -919,17 +894,11 @@ bio_pagedec(struct bio *bio)
 static void
 bufinit(struct buf *buf, struct request *rq, struct bio *bio)
 {
-	struct bio_vec *bv;
-
 	memset(buf, 0, sizeof(*buf));
 	buf->rq = rq;
 	buf->bio = bio;
-	buf->resid = bio->bi_iter.bi_size;
-	buf->sector = bio->bi_iter.bi_sector;
+	buf->iter = bio->bi_iter;
 	bio_pageinc(bio);
-	buf->bv = bv = __bio_iovec(bio);
-	buf->bv_resid = bv->bv_len;
-	WARN_ON(buf->bv_resid == 0);
 }
 
 static struct buf *
@@ -1114,24 +1083,24 @@ gettgt(struct aoedev *d, char *addr)
 }
 
 static void
-bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, long cnt)
+bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter *iter,
+      long cnt)
 {
-	ulong fcnt;
 	char *p;
 	int soff = 0;
-loop:
-	fcnt = bv->bv_len - (off - bv->bv_offset);
-	if (fcnt > cnt)
-		fcnt = cnt;
-	p = page_address(bv->bv_page) + off;
-	skb_copy_bits(skb, soff, p, fcnt);
-	soff += fcnt;
-	cnt -= fcnt;
-	if (cnt <= 0)
-		return;
-	bv++;
-	off = bv->bv_offset;
-	goto loop;
+
+	do {
+		struct bio_vec bv = bio_iovec_iter(bio, *iter);
+
+		p = page_address(bv.bv_page) + bv.bv_offset;
+		skb_copy_bits(skb, soff, p, bv.bv_len);
+
+		bio_advance_iter(bio, iter, bv.bv_len);
+		soff += bv.bv_len;
+		cnt -= bv.bv_len;
+		if (cnt <= 0)
+			return;
+	} while (cnt > 0);
 }
 
 void
@@ -1224,7 +1193,7 @@ noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
-		bvcpy(f->bv, f->bv_off, skb, n);
+		bvcpy(skb, f->buf->bio, &f->iter, n);
 	case ATA_CMD_PIO_WRITE:
 	case ATA_CMD_PIO_WRITE_EXT:
 		spin_lock_irq(&d->lock);
@@ -1267,7 +1236,7 @@ out:
 
 	aoe_freetframe(f);
 
-	if (buf && --buf->nframesout == 0 && buf->resid == 0)
+	if (buf && --buf->nframesout == 0 && buf->iter.bi_size == 0)
 		aoe_end_buf(d, buf);
 
 	spin_unlock_irq(&d->lock);
@@ -1698,7 +1667,6 @@ aoe_failbuf(struct aoedev *d, struct buf *buf)
 {
 	if (buf == NULL)
 		return;
-	buf->resid = 0;
 	clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 	if (buf->nframesout == 0)
 		aoe_end_buf(d, buf);
-- 
1.8.1.3

