Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3J2UWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:22:39 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37162 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3J2USn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:43 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        "Ed L. Cashin" <ecashin@coraid.com>
Subject: [PATCH 13/23] aoe: Convert to immutable biovecs
Date: Tue, 29 Oct 2013 13:18:06 -0700
Message-Id: <1383077896-4132-14-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got a mechanism for immutable biovecs -
bi_iter.bi_bvec_done - we need to convert drivers to use primitives that
respect it instead of using the bvec array directly.

The aoe code no longer has to manually iterate over partial bvecs, so
some struct members go away - other struct members are effectively
renamed:

buf->resid	-> buf->iter.bi_size
buf->sector	-> buf->iter.bi_sector

f->bcnt		-> f->iter.bi_size
f->lba		-> f->iter.bi_sector

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |  10 +---
 drivers/block/aoe/aoecmd.c | 135 +++++++++++++++++----------------------------
 2 files changed, 53 insertions(+), 92 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 14a9d19..9220f8e 100644
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
index 7a06aec..8184451 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -196,8 +196,7 @@ aoe_freetframe(struct frame *f)
 
 	t = f->t;
 	f->buf = NULL;
-	f->lba = 0;
-	f->bv = NULL;
+	memset(&f->iter, 0, sizeof(f->iter));
 	f->r_skb = NULL;
 	f->flags = 0;
 	list_add(&f->head, &t->ffree);
@@ -295,21 +294,14 @@ newframe(struct aoedev *d)
 }
 
 static void
-skb_fillup(struct sk_buff *skb, struct bio_vec *bv, ulong off, ulong cnt)
+skb_fillup(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter)
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
+	struct bio_vec bv;
+
+	__bio_for_each_segment(bv, bio, iter, iter)
+		skb_fill_page_desc(skb, frag++, bv.bv_page,
+				   bv.bv_offset, bv.bv_len);
 }
 
 static void
@@ -346,12 +338,10 @@ ata_rw_frameinit(struct frame *f)
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
@@ -360,11 +350,11 @@ ata_rw_frameinit(struct frame *f)
 		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
 	}
 	if (f->buf && bio_data_dir(f->buf->bio) == WRITE) {
-		skb_fillup(skb, f->bv, f->bv_off, f->bcnt);
+		skb_fillup(skb, f->buf->bio, f->iter);
 		ah->aflags |= AOEAFL_WRITE;
-		skb->len += f->bcnt;
-		skb->data_len = f->bcnt;
-		skb->truesize += f->bcnt;
+		skb->len += f->iter.bi_size;
+		skb->data_len = f->iter.bi_size;
+		skb->truesize += f->iter.bi_size;
 		t->wpkts++;
 	} else {
 		t->rpkts++;
@@ -382,7 +372,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct buf *buf;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
-	ulong bcnt, fbcnt;
 
 	buf = nextbuf(d);
 	if (buf == NULL)
@@ -390,39 +379,22 @@ aoecmd_ata_rw(struct aoedev *d)
 	f = newframe(d);
 	if (f == NULL)
 		return 0;
-	bcnt = d->maxbcnt;
-	if (bcnt == 0)
-		bcnt = DEFAULTBCNT;
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
 
 	/* initialize the headers & frame */
 	f->buf = buf;
-	f->bcnt = bcnt;
-	ata_rw_frameinit(f);
+	f->iter = buf->iter;
+	f->iter.bi_size = min_t(unsigned long,
+				d->maxbcnt ?: DEFAULTBCNT,
+				f->iter.bi_size);
+	bio_advance_iter(buf->bio, &buf->iter, f->iter.bi_size);
+
+	if (!buf->iter.bi_size)
+		d->ip.buf = NULL;
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
-	buf->sector += bcnt >> 9;
+
+	ata_rw_frameinit(f);
 
 	skb = skb_clone(f->skb, GFP_ATOMIC);
 	if (skb) {
@@ -613,10 +585,7 @@ reassign_frame(struct frame *f)
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
@@ -648,19 +617,19 @@ probe(struct aoetgt *t)
 	}
 	f->flags |= FFL_PROBE;
 	ifrotate(t);
-	f->bcnt = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
+	f->iter.bi_size = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
 	ata_rw_frameinit(f);
 	skb = f->skb;
-	for (frag = 0, n = f->bcnt; n > 0; ++frag, n -= m) {
+	for (frag = 0, n = f->iter.bi_size; n > 0; ++frag, n -= m) {
 		if (n < PAGE_SIZE)
 			m = n;
 		else
 			m = PAGE_SIZE;
 		skb_fill_page_desc(skb, frag, empty_page, 0, m);
 	}
-	skb->len += f->bcnt;
-	skb->data_len = f->bcnt;
-	skb->truesize += f->bcnt;
+	skb->len += f->iter.bi_size;
+	skb->data_len = f->iter.bi_size;
+	skb->truesize += f->iter.bi_size;
 
 	skb = skb_clone(f->skb, GFP_ATOMIC);
 	if (skb) {
@@ -929,12 +898,8 @@ bufinit(struct buf *buf, struct request *rq, struct bio *bio)
 	memset(buf, 0, sizeof(*buf));
 	buf->rq = rq;
 	buf->bio = bio;
-	buf->resid = bio->bi_iter.bi_size;
-	buf->sector = bio->bi_iter.bi_sector;
+	buf->iter = bio->bi_iter;
 	bio_pageinc(bio);
-	buf->bv = __bio_iovec(bio);
-	buf->bv_resid = buf->bv->bv_len;
-	WARN_ON(buf->bv_resid == 0);
 }
 
 static struct buf *
@@ -1119,24 +1084,18 @@ gettgt(struct aoedev *d, char *addr)
 }
 
 static void
-bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, long cnt)
+bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
 {
-	ulong fcnt;
-	char *p;
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
+	struct bio_vec bv;
+
+	iter.bi_size = cnt;
+
+	__bio_for_each_segment(bv, bio, iter, iter) {
+		char *p = page_address(bv.bv_page) + bv.bv_offset;
+		skb_copy_bits(skb, soff, p, bv.bv_len);
+		soff += bv.bv_len;
+	}
 }
 
 void
@@ -1229,7 +1188,15 @@ noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
-		bvcpy(f->bv, f->bv_off, skb, n);
+		if (n > f->iter.bi_size) {
+			pr_err_ratelimited("%s e%ld.%d.  bytes=%ld need=%u\n",
+				"aoe: too-large data size in read from",
+				(long) d->aoemajor, d->aoeminor,
+				n, f->iter.bi_size);
+			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+			break;
+		}
+		bvcpy(skb, f->buf->bio, f->iter, n);
 	case ATA_CMD_PIO_WRITE:
 	case ATA_CMD_PIO_WRITE_EXT:
 		spin_lock_irq(&d->lock);
@@ -1272,7 +1239,7 @@ out:
 
 	aoe_freetframe(f);
 
-	if (buf && --buf->nframesout == 0 && buf->resid == 0)
+	if (buf && --buf->nframesout == 0 && buf->iter.bi_size == 0)
 		aoe_end_buf(d, buf);
 
 	spin_unlock_irq(&d->lock);
@@ -1727,7 +1694,7 @@ aoe_failbuf(struct aoedev *d, struct buf *buf)
 {
 	if (buf == NULL)
 		return;
-	buf->resid = 0;
+	buf->iter.bi_size = 0;
 	clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 	if (buf->nframesout == 0)
 		aoe_end_buf(d, buf);
-- 
1.8.4.rc3

