Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966972Ab3HIAJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:09:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54028 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966955Ab3HIAJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:09:45 -0400
Date: Thu, 8 Aug 2013 17:09:43 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: axboe@kernel.dk, neilb@suse.de, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
Message-ID: <20130809000943.GC15409@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-5-git-send-email-kmo@daterainc.com>
 <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:04:36PM -0400, Ed Cashin wrote:
> On Aug 7, 2013, at 5:54 PM, Kent Overstreet wrote:
> 
> > Immutable biovecs are going to require an explicit iterator. To
> > implement immutable bvecs, a later patch is going to add a bi_bvec_done
> > member to this struct; for now, this patch effectively just renames
> > things.
> 
> Hi, Kent Overstreet.  Thanks for Cc'ing me and for the promising work.
> 
> Were you able to do sanity tests with aoe this time around?  Last time, basic I/O was not working with the immutable biovec patches applied.
> 
> Here is my 28 June email about my experiences with git://evilpiepirate.org/~kent/linux-bcache.git at that time.  It also includes information about creating an easy software-only aoe test environment.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1505222/focus=1517924

Hey, thanks for testing it - sorry, I think I remember seeing that email
last time and got sidetracked before I got around to setting up some
tests.

I think I've got it working now, it's running the same stress tests I
use for bcache. Here's a fixed patch, I broke the aoe changes out into
their own patch since they were more involved than most of the others:

(I am seeing a bug where it's getting stuck after running stress tests
for awhile, but I can reproduce that without the aoe changes too...)

>From 351ff4cdbbc670321b87ad38b5d5edbbb2dd2cf1 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Thu, 8 Aug 2013 16:48:33 -0700
Subject: [PATCH] aoe: Convert to immutable biovecs

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

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 025c41d..c5e1e9b 100644
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
index f17260b..cacd48e 100644
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
@@ -383,7 +373,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
-	ulong bcnt, fbcnt;
 
 	buf = nextbuf(d);
 	if (buf == NULL)
@@ -392,39 +381,22 @@ aoecmd_ata_rw(struct aoedev *d)
 	if (f == NULL)
 		return 0;
 	t = *d->tgt;
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
@@ -617,10 +589,7 @@ reassign_frame(struct frame *f)
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
@@ -652,19 +621,19 @@ probe(struct aoetgt *t)
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
@@ -936,12 +905,8 @@ bufinit(struct buf *buf, struct request *rq, struct bio *bio)
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
@@ -1126,24 +1091,19 @@ gettgt(struct aoedev *d, char *addr)
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
+	BUG_ON(cnt > iter.bi_size);
+	iter.bi_size = cnt;
+
+	__bio_for_each_segment(bv, bio, iter, iter) {
+		char *p = page_address(bv.bv_page) + bv.bv_offset;
+		skb_copy_bits(skb, soff, p, bv.bv_len);
+		soff += bv.bv_len;
+	}
 }
 
 void
@@ -1236,7 +1196,7 @@ noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
-		bvcpy(f->bv, f->bv_off, skb, n);
+		bvcpy(skb, f->buf->bio, f->iter, n);
 	case ATA_CMD_PIO_WRITE:
 	case ATA_CMD_PIO_WRITE_EXT:
 		spin_lock_irq(&d->lock);
@@ -1279,7 +1239,7 @@ out:
 
 	aoe_freetframe(f);
 
-	if (buf && --buf->nframesout == 0 && buf->resid == 0)
+	if (buf && --buf->nframesout == 0 && buf->iter.bi_size == 0)
 		aoe_end_buf(d, buf);
 
 	spin_unlock_irq(&d->lock);
@@ -1734,7 +1694,7 @@ aoe_failbuf(struct aoedev *d, struct buf *buf)
 {
 	if (buf == NULL)
 		return;
-	buf->resid = 0;
+	buf->iter.bi_size = 0;
 	clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 	if (buf->nframesout == 0)
 		aoe_end_buf(d, buf);
