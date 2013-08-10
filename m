Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595Ab3HJHi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 03:38:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53328 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968320Ab3HJHi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 03:38:56 -0400
Date: Sat, 10 Aug 2013 00:38:55 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 18/22] block: Generic bio chaining
Message-ID: <20130810073855.GA9349@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-19-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375912471-5106-19-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:54:27PM -0700, Kent Overstreet wrote:
> This adds a generic mechanism for chaining bio completions. This is
> going to be used for a bio_split() replacement, and some other things in
> the future.
> 
> This is implemented with a new bio flag that bio_endio() checks; it
> would definitely be cleaner to implement chaining with a bi_end_io
> function, but since there's no limits on the depth of a bio chain (and
> with arbitrary bio splitting coming this is going to be a real issue)
> using an endio function would lead to unbounded stack usage.
> 
> Tail call optimization could solve that, but CONFIG_FRAME_POINTER
> disables gcc's tail call optimization (-fno-optimize-sibling-calls) - so
> we do it the hacky but safe way.

Btw, if you saw this patch and went "Wtf? What's the justification for
inflating struct bio and sticking another atomic op in the fast path?" -
here's the justification: The below patch gets me a 5% increase in
throughput (doing 4k random reads, and on one core on an old gulftown so
cpu bound).

(it also considerably simplifies a lot of random code, but there's a
real performance win to drivers handling arbitrary size bios so upper
layers don't have to care).

>From a6b23c56c722ffbf30ca78c14d21dd8615e11474 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Sat, 10 Aug 2013 00:14:03 -0700
Subject: [PATCH] mtip32xx: handle arbitrary size bios


diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 3ea8234..058d86c 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2645,24 +2645,6 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 }
 
 /*
- * Release a command slot.
- *
- * @dd  Pointer to the driver data structure.
- * @tag Slot tag
- *
- * return value
- *      None
- */
-static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag,
-								int unaligned)
-{
-	struct semaphore *sem = unaligned ? &dd->port->cmd_slot_unal :
-							&dd->port->cmd_slot;
-	release_slot(dd->port, tag);
-	up(sem);
-}
-
-/*
  * Obtain a command slot and return its associated scatter list.
  *
  * @dd  Pointer to the driver data structure.
@@ -3913,21 +3895,22 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
-		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
-			dev_warn(&dd->pdev->dev,
-				"Maximum number of SGL entries exceeded\n");
-			bio_io_error(bio);
-			mtip_hw_release_scatterlist(dd, tag, unaligned);
-			return;
-		}
-
 		/* Create the scatter list for this bio. */
 		bio_for_each_segment(bvec, bio, iter) {
-			sg_set_page(&sg[nents],
-					bvec.bv_page,
-					bvec.bv_len,
-					bvec.bv_offset);
-			nents++;
+			if (unlikely(nents == MTIP_MAX_SG)) {
+				struct bio *split = bio_clone(bio, GFP_NOIO);
+
+				split->bi_iter = iter;
+				bio->bi_iter.bi_size -= iter.bi_size;
+				bio_chain(split, bio);
+				generic_make_request(split);
+				break;
+			}
+
+			sg_set_page(&sg[nents++],
+				    bvec.bv_page,
+				    bvec.bv_len,
+				    bvec.bv_offset);
 		}
 
 		/* Issue the read/write. */
@@ -4040,6 +4023,7 @@ skip_create_disk:
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
 	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	set_bit(QUEUE_FLAG_LARGEBIOS,	&dd->queue->queue_flags);
 
 	/*
 	 * write back cache is not supported in the device. FUA depends on
